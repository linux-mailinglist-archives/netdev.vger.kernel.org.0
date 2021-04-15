Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C4535FF25
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 03:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhDOBNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 21:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhDOBNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 21:13:23 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6809EC061574;
        Wed, 14 Apr 2021 18:13:01 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id x77so13231243oix.8;
        Wed, 14 Apr 2021 18:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wk6DDw94syWr3OzbAVtOTZ5taUo+9eS6vbkw8K6bZxg=;
        b=lQgWT9I5SsT2HAkp0PsUwausGwHSnnJUzjvCUFqCG/RfY+eXGLH1oQvI7P5QnJISf/
         49aIiqJBC3VrMrxU9RXuHExtB6gZeZvMzeZXIOvX2zka+my5IPvw+BlB9mysrc3pYaxI
         ht4IbWJp/snEjlf5HNr+L/uLveNxnex+PB5066UHKJNVvOjsI8ZmZlXD1i+XDL66a5X+
         t1QZ29TmTRqXb1iyyOCw0MPABHi2pLeQ5sBqXys9E71vQXUEQX1i77ak5HWkK0S9aSF1
         TA3aJsITZzODrijj2NVMX+zF/L/80qIcTgqAnj7wWiUFcEiLZzRRZlKvsBMfp7E0Er1d
         3efg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wk6DDw94syWr3OzbAVtOTZ5taUo+9eS6vbkw8K6bZxg=;
        b=nB3ADBhCG+ImKOnHgWzh/qs2MU4CuCibWJnq+SnVsgG6LJQtgK28bq5QFZtJkEgGga
         2d9lJR+jLGHoqgVte+XBJxpWMUbB0YVoUbhsJu81rVoncPlUtYm4F2dIhgE40xuDE2Rc
         iYhLwQ7LImiQZ2oIDsKLO+nI7bupww97SSslqB0ZwFIxkkbDLoBJDuFsKUb2hnCWCfrJ
         gLagXyRZDftAormkf9S8362YG83KLoXoIvOJmJnlW3Dxmi6JG1lvNLXQrD+HdRvdVW/o
         KV2A02+CKcpusYQL6Jq0+eR1JK8vzqd0x70S3cQH48WSt8NQXZ79BMgUbEy72L9Q3kuN
         2jJw==
X-Gm-Message-State: AOAM5312TAkmF1UQdzLGJsKKHq5AhgyFA+gk1H/i/xrP1g6833+N6asu
        86zxyzfh2qgD+AFC9zrUrPp/aJrLxKlZJlsvdZY=
X-Google-Smtp-Source: ABdhPJx3PuI7DwXAjEnGNsv9IgN+3156u+3ZcW2UMAvBa6vIMB1X4/zDb8vuXKDfytrYqKdZ9VjLCg6zhcYNaHrsxJg=
X-Received: by 2002:a05:6808:bcb:: with SMTP id o11mr700419oik.141.1618449180579;
 Wed, 14 Apr 2021 18:13:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210412065759.2907-1-kerneljasonxing@gmail.com>
 <20210413025011.1251-1-kerneljasonxing@gmail.com> <20210413091812.0000383d@intel.com>
In-Reply-To: <20210413091812.0000383d@intel.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Thu, 15 Apr 2021 09:12:24 +0800
Message-ID: <CAL+tcoBVhD1SfMYAFVn0HxZ3ig88pxtiLoha9d6Z+62yq8bWBA@mail.gmail.com>
Subject: Re: [PATCH net v2] i40e: fix the panic when running bpf in xdpdrv mode
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     anthony.l.nguyen@intel.com, David Miller <davem@davemloft.net>,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org,
        Jason Xing <xingwanli@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>,
        intel-wired-lan@lists.osuosl.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 12:27 AM Jesse Brandeburg
<jesse.brandeburg@intel.com> wrote:
>
> kerneljasonxing@gmail.com wrote:
>
> > From: Jason Xing <xingwanli@kuaishou.com>
>
> Hi Jason,
>
> Sorry, I missed this on the first time: Added intel-wired-lan,
> please include on any future submissions for Intel drivers.
> get-maintainers script might help here?
>

Probably I got this wrong in the last email. Did you mean that I should add
intel-wired-lan in the title not the cc list? It seems I should put
this together on
the next submission like this:

[Intel-wired-lan] [PATCH net v4]

Am I missing something?

Thanks,
Jason

> >
> > Fix this panic by adding more rules to calculate the value of @rss_size_max
> > which could be used in allocating the queues when bpf is loaded, which,
> > however, could cause the failure and then trigger the NULL pointer of
> > vsi->rx_rings. Prio to this fix, the machine doesn't care about how many
> > cpus are online and then allocates 256 queues on the machine with 32 cpus
> > online actually.
> >
> > Once the load of bpf begins, the log will go like this "failed to get
> > tracking for 256 queues for VSI 0 err -12" and this "setup of MAIN VSI
> > failed".
> >
> > Thus, I attach the key information of the crash-log here.
> >
> > BUG: unable to handle kernel NULL pointer dereference at
> > 0000000000000000
> > RIP: 0010:i40e_xdp+0xdd/0x1b0 [i40e]
> > Call Trace:
> > [2160294.717292]  ? i40e_reconfig_rss_queues+0x170/0x170 [i40e]
> > [2160294.717666]  dev_xdp_install+0x4f/0x70
> > [2160294.718036]  dev_change_xdp_fd+0x11f/0x230
> > [2160294.718380]  ? dev_disable_lro+0xe0/0xe0
> > [2160294.718705]  do_setlink+0xac7/0xe70
> > [2160294.719035]  ? __nla_parse+0xed/0x120
> > [2160294.719365]  rtnl_newlink+0x73b/0x860
> >
> > Fixes: 41c445ff0f48 ("i40e: main driver core")
> >
>
> This Fixes line should be connected to the Sign offs with
> no linefeeds between.
>
> > Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> > Signed-off-by: Shujin Li <lishujin@kuaishou.com>
>
> Did Shujin contribute to this patch? Why are they signing off? If
> they developed this patch with you, it should say:
> Co-developed-by: Shujin ....
> Signed-off-by: Shujin ...
> Signed-off-by: Jason ...
>
> Your signature should be last if you sent the patch. The sign-offs are
> like a chain of custody, please review
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html#when-to-use-acked-by-cc-and-co-developed-by
>
> Thanks,
>  Jesse
