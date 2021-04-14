Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0203F35EA7D
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 03:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346041AbhDNBiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 21:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345994AbhDNBiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 21:38:07 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73584C061756;
        Tue, 13 Apr 2021 18:37:47 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id i20-20020a4a8d940000b02901bc71746525so4271313ook.2;
        Tue, 13 Apr 2021 18:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oPpNub0x+LlxaW1pwDR4JCfKjMoHmPl4Y2gZyA8yXlU=;
        b=hb89ZLS7XGn9p6/IQ3ARbB44mCMtTx4Zb+sy9TMH8ajohYZiXxzrhXK7fIDDfVVClU
         qG+VPSYqBfyBeeo17NN/rWnJls/XSIrbIuastNqB23SEOLP3ZcuPgZ+zaemsa2lEm5VK
         tvIbjAM8Z/iperVJeXbR9BbCCBRtyaSbc4L9wyOuheB9Bzth2SBIno19lD9+rUMRR6jF
         DIcIfLo8nnTQDRQM2wJNrH+OZDgywo4v6kASLrfYoKB7zaASTejOdL6hfqYDsEaID/PZ
         VqfwzqLVBxPPLgsXbd1U61Sq266S3c5iz9GuUvMTTFMSgfG+Ubcf0PcPH4vomMmLuCV4
         BLBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oPpNub0x+LlxaW1pwDR4JCfKjMoHmPl4Y2gZyA8yXlU=;
        b=GJxg56ow1GpF13SWySOIktsIfuLJmGmAHa74NhCegA28S2oAgO6PYw2qJXQJDfVLdw
         ZS+sr73W3ldQPneYYw7PGmPkW5RtdzDbqo2BWlKloXA12pueJPV9R+kvK82vT+Cbbv5W
         na2h6aO9VDUfmBDVgE3tbNfwrLpeeu9u/cb7KQ1LfeOS66rCdbJPfbDK8KwVZuUcV20Z
         k68ETL/zZDkhlFmW4mzV/HQKE8/OsmDR2SgkwiqbHuicA/JcyydIiagdEYNJU4w1PodR
         jWBV3+HPKgzGnWfbBXJZGHNmF92VnefWaDI7MYkeTNyXRiDdE0QOVRNuU9gKqD65lGMt
         ELHA==
X-Gm-Message-State: AOAM533/6ES7dK4Nipo4kvEiUJx5y+qklNWbCQJm9PqWpewTrRH0f86f
        thFzWM5S136wqDjc3Kyl9+IBhS8nnQlrlSCnP+M=
X-Google-Smtp-Source: ABdhPJzIhIzU0JDW2KqMzbOHnshkFNf0Y8ES8z75edQSXwAPyOM2ngKQOMK3lwvc42C647oky87ox4Nct7r3Esi/nmA=
X-Received: by 2002:a4a:e797:: with SMTP id x23mr22962494oov.24.1618364266860;
 Tue, 13 Apr 2021 18:37:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210412065759.2907-1-kerneljasonxing@gmail.com>
 <20210413025011.1251-1-kerneljasonxing@gmail.com> <20210413091812.0000383d@intel.com>
In-Reply-To: <20210413091812.0000383d@intel.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 14 Apr 2021 09:37:10 +0800
Message-ID: <CAL+tcoBHdVa8eJQVYK4aQj+XWAgcN8VOaL558z=2YuHSa8mbKQ@mail.gmail.com>
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

Hi, Jesse

In the first patch, I did send to intel-wired-lan but it told me that
it is open for the member only, so
I got rid of it in this patch v2.

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

Well, yes, I will add a Co-developed-by label later.

> Your signature should be last if you sent the patch. The sign-offs are
> like a chain of custody, please review
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html#when-to-use-acked-by-cc-and-co-developed-by
>

Thanks so much for your detailed instructions. I'm about to correct
them all together and then resend the patch v3.

Jason

> Thanks,
>  Jesse
