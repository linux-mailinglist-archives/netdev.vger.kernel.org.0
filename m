Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69CA141BCA6
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 04:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243753AbhI2CWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 22:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243226AbhI2CWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 22:22:21 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04288C06161C;
        Tue, 28 Sep 2021 19:20:41 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id j11-20020a9d190b000000b00546fac94456so1014960ota.6;
        Tue, 28 Sep 2021 19:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/m3v6wHyU+gceCsGIGZQW1YYbgSsrVq1u5VD7Wq+RWY=;
        b=bf8iVuGnsm91udbcvDyigQaau+zWTHvOV48qzQjwWUM9o7fSzCvX/zvHLCyAEseY+a
         fTo7Snk0oXSgXYkOvn/xksR8uIdJESgFU+iy3yqSTlbk8CG1y5VyKDlFAoLPvYsYfNRx
         HBtxV9mM7E4Q0CqmQhsRt6HtcvCMzeqs/vPeRjfc+NTxdK2+JnogFu7+MGSwRHkIHwEK
         cM1saWqdOp3EPEUFneggP3sjPPVpLf0iKO37khA7a972EQk42XdmGcaIcHWeuTv4ddhn
         PEhxz0YukqRjtmO/WBHw318COSpoViXwe2dXJ7YFQwWAjp8+yluQ6jj/ZME8KtARTlB1
         sf7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/m3v6wHyU+gceCsGIGZQW1YYbgSsrVq1u5VD7Wq+RWY=;
        b=ayz/Kxd194tSujNSziTmFfD3TE7nT2tx1ilGIMpKMfBQoDuL6c4sJ3B+e8jHihEHts
         eYyT0qR7yJSqu2pHPTiKbgTySA09coccowu2x2kdpYwVKewikzg/Df+DY+Q0wC9qZPNX
         pHNSnPTKBSJ+4Lgp4nDAIe5zU+zcYHmdxUSH+ZBGLauFjzUSrkiW/zN1/EpOig1Ac2/L
         vM7qODWJxSl+ly0G3MxxWWefBf88LW8KTInBzvtKGvq1o4jRdKT2/uREpNZKH0LcEnOQ
         6tNUfoc7X6U9fnDLxWMrJBXibqYVX8WcrKDZB9HSZk8zXGXW6C94Zq4ZqJ3KA5zoAq3B
         Na2Q==
X-Gm-Message-State: AOAM532EoQ2X622BZ/duH8QD2ZnJKCkDWxW/egxIU+7KOfDbkc30XVhT
        aUHGCmcJ4PG21in/CzIk55pbkaZEyv/4AkjRUMs=
X-Google-Smtp-Source: ABdhPJx1IMWZ/bsJWfzsNpMgmYvbhuD0LF11DiYOzktOGL+jMle4FLXwNSC2UIWIEYvahPBvQbTjH58u6SxFFZyowMk=
X-Received: by 2002:a9d:6143:: with SMTP id c3mr8009609otk.124.1632882040342;
 Tue, 28 Sep 2021 19:20:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210901101206.50274-1-kerneljasonxing@gmail.com>
 <CAL+tcoCOnCpxLXLyAxb+BgumQBpo2PPqSQXY=Xvs-8R48Om=cw@mail.gmail.com> <a1ea0abaadc59bdbc6504a64bae594b059c26cdf.camel@intel.com>
In-Reply-To: <a1ea0abaadc59bdbc6504a64bae594b059c26cdf.camel@intel.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 29 Sep 2021 10:20:02 +0800
Message-ID: <CAL+tcoALdQQPy+9G_azrGqSugGcNjFfYqmf72aNRPahgggeeVA@mail.gmail.com>
Subject: Re: [PATCH v7] ixgbe: let the xdpdrv work with more than 64 cpus
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "kafai@fb.com" <kafai@fb.com>, "hawk@kernel.org" <hawk@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>, "yhs@fb.com" <yhs@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>, lkp <lkp@intel.com>,
        "xingwanli@kuaishou.com" <xingwanli@kuaishou.com>,
        "lishujin@kuaishou.com" <lishujin@kuaishou.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 6:17 AM Nguyen, Anthony L
<anthony.l.nguyen@intel.com> wrote:
>
> On Thu, 2021-09-16 at 14:41 +0800, Jason Xing wrote:
> > Hello guys,
> >
> > any suggestions or comments on this v7 patch?
> >
> > Thanks,
> > Jason
> >
> > On Wed, Sep 1, 2021 at 6:12 PM <kerneljasonxing@gmail.com> wrote:
> > > From: Jason Xing <xingwanli@kuaishou.com>
> > >
> > > Originally, ixgbe driver doesn't allow the mounting of xdpdrv if
> > > the
> > > server is equipped with more than 64 cpus online. So it turns out
> > > that
> > > the loading of xdpdrv causes the "NOMEM" failure.
> > >
> > > Actually, we can adjust the algorithm and then make it work through
> > > mapping the current cpu to some xdp ring with the protect of
> > > @tx_lock.
> > >
> > > Here're some numbers before/after applying this patch with xdp-
> > > example
> > > loaded on the eth0X:
> > >
> > > As client (tx path):
> > >                      Before    After
> > > TCP_STREAM send-64   734.14    714.20
> > > TCP_STREAM send-128  1401.91   1395.05
> > > TCP_STREAM send-512  5311.67   5292.84
> > > TCP_STREAM send-1k   9277.40   9356.22 (not stable)
> > > TCP_RR     send-1    22559.75  21844.22
> > > TCP_RR     send-128  23169.54  22725.13
> > > TCP_RR     send-512  21670.91  21412.56
> > >
> > > As server (rx path):
> > >                      Before    After
> > > TCP_STREAM send-64   1416.49   1383.12
> > > TCP_STREAM send-128  3141.49   3055.50
> > > TCP_STREAM send-512  9488.73   9487.44
> > > TCP_STREAM send-1k   9491.17   9356.22 (not stable)
> > > TCP_RR     send-1    23617.74  23601.60
> > > ...
> > >
> > > Notice: the TCP_RR mode is unstable as the official document
> > > explaines.
> > >
> > > I tested many times with different parameters combined through
> > > netperf.
> > > Though the result is not that accurate, I cannot see much influence
> > > on
> > > this patch. The static key is places on the hot path, but it
> > > actually
> > > shouldn't cause a huge regression theoretically.
> > >
> > > Fixes: 33fdc82f08 ("ixgbe: add support for XDP_TX action")
>
> Hi Jason,
>
> The patch doesn't have an explicit target of net or net-next. I assume
> since you put a Fixes tag you're wanting it to go through net, however,
> this seems more like an improvement that should go through net-next.

Yes, it is like an improvement. At first I wanted to label it as net,
but it isn't a fix as you said. So I agree with you and please help me
send it to net-next.

thanks,
Jason

> Please let me know if you disagree, otherwise I will send to net-next.
>
> Thanks,
> Tony
>
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Co-developed-by: Shujin Li <lishujin@kuaishou.com>
> > > Signed-off-by: Shujin Li <lishujin@kuaishou.com>
> > > Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> >
