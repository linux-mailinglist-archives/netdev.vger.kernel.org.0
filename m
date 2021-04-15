Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFD8360184
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 07:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhDOFRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 01:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhDOFRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 01:17:21 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B6FC061574;
        Wed, 14 Apr 2021 22:16:58 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id f75-20020a9d03d10000b0290280def9ab76so16428664otf.12;
        Wed, 14 Apr 2021 22:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gxcWeNrjFCcTeKjmbsNotnTpQRzTFqaqt9nFjPnqCjA=;
        b=HljV85rUzclS3NeavfN9xrwN4+8P6rsi8WPxVPCCn/SY3DA5zrJdR8DMeDEE7ZVYXj
         LjjHl0bchiENqHDYTxH/bLMsUvi9EArsWd7nf+M2+hvl1R8kLI5Gq0KBeFVsBfMkEv1D
         1eSc0qUul43wNnzZGC/Wnln4xkgoFvzlmxPUqK6fUnvKLYZ3duz7eRMy4/eaMNS5fuVv
         LZ3+mtoU/buaKhxgwgXqRjusMeRmB/b3GGtb4zGjiDpuk9JjBCBEc0+r9KIzF8s73vyh
         MgDFUN56sRJtjh0PEYN8KcIief60O2GIffJ6zeQ1IovVj1tRHtDqr+KZwYnPimzbPE3K
         ratw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gxcWeNrjFCcTeKjmbsNotnTpQRzTFqaqt9nFjPnqCjA=;
        b=shp8Dpbi5wX8B7lQlDdfkyP7jvchaPW3wPFnsOVOu3cY3cQYrvdGgv0ucPtX11nV6c
         xqsxJe07Q24uYLvXzfO08Ph+/O9Uva9ZySkDJ+a+Ma2csFokzzVp7OLCBTyf5MScfSbM
         /6LcvMS6egA1yUc3vtS5eUehwK7pdI+UZ1BsKP/vzOScX7vLCuq2zRVUobwZ6Q8yxiLq
         HS/pv307qt9fJ3K53/LhED78Exi7Gy4wJe56/1CK+h2WYCUxRc1dKVAeR4UqUEWEd6/8
         5AbKpOFeNiPHwjOoxh9qrHjJKVYuhdtByqlZ25EVK6BG1zlNLmvfynWoi20hllKd+pQ1
         Dccg==
X-Gm-Message-State: AOAM530xvnpmfnLEyXa3mQFgrTrvf1lwmmXM/uY0iq29gXE+WJNl90JX
        Ra2nLJntf6HJUVlHQMfq7qj3UWoRfDK1LK9+WtQcvhtd6lV+Sg==
X-Google-Smtp-Source: ABdhPJyKx6RobEXsCC6040Be2jAITs+SqWUI/vu+hz87uwHTi9bm17mC42YqhPaktVI0VUQF/gqkIxzaWMv6XlFwDDI=
X-Received: by 2002:a9d:1c7:: with SMTP id e65mr1304632ote.105.1618463818159;
 Wed, 14 Apr 2021 22:16:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210412065759.2907-1-kerneljasonxing@gmail.com>
 <20210413025011.1251-1-kerneljasonxing@gmail.com> <20210413091812.0000383d@intel.com>
 <CAL+tcoBVhD1SfMYAFVn0HxZ3ig88pxtiLoha9d6Z+62yq8bWBA@mail.gmail.com> <20210414190837.0000085a@intel.com>
In-Reply-To: <20210414190837.0000085a@intel.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Thu, 15 Apr 2021 13:16:22 +0800
Message-ID: <CAL+tcoAfVCJMgeVFnyHaZhEEJRiWEYc5hm5c0GOKwg2BDiVtYA@mail.gmail.com>
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

On Thu, Apr 15, 2021 at 10:08 AM Jesse Brandeburg
<jesse.brandeburg@intel.com> wrote:
>
> Jason Xing wrote:
>
> > On Wed, Apr 14, 2021 at 12:27 AM Jesse Brandeburg
> > <jesse.brandeburg@intel.com> wrote:
> > >
> > > kerneljasonxing@gmail.com wrote:
> > >
> > > > From: Jason Xing <xingwanli@kuaishou.com>
> > >
> > > Hi Jason,
> > >
> > > Sorry, I missed this on the first time: Added intel-wired-lan,
> > > please include on any future submissions for Intel drivers.
> > > get-maintainers script might help here?
> > >
> >
> > Probably I got this wrong in the last email. Did you mean that I should add
> > intel-wired-lan in the title not the cc list? It seems I should put
> > this together on
> > the next submission like this:
> >
> > [Intel-wired-lan] [PATCH net v4]
>
> Your v3 submittal was correct. My intent was to make sure
> intel-wired-lan was in CC:
>

Well, I get to know more about the whole thing.

> If Kuba or Dave wants us to take the fix in via intel-wired-lan trees,
> then we can do that, or they can apply it directly. I'll ack it on the
> v3.

Thanks, Jesse:)

Jason

>
