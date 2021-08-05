Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91AD03E1D5D
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 22:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240780AbhHEUdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 16:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbhHEUdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 16:33:12 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12B1C061765
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 13:32:57 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id s21-20020a4ae5550000b02902667598672bso1646141oot.12
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 13:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aleksander-es.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W9vYmFHMexd2bNJ9EsbusMDr8ooE3klEPAps5y58KR0=;
        b=zNJPHz1+Jy4PR0XaUIxRCHD38ukS1cPL9tvSdmHcBEEba9BcFbCG/lRGMEgQnY8M/6
         s8906o4DgnKRnLhkBjwMdyL6sX7d6wL1EwnJNTNkcVy//1J2nNClNVHzgv45ODD3bAPt
         wWHlpcLvBylm+m8ptwqqmQjF78PmXldGytmFTUmgnWNxXbNf5NwgEm8FEkrfL5vni4FQ
         EdWjs6BOF3PfFKkv7RL7d2NSCMPtlwy57kLLDUZYwB8FzP4TXzWrt0E8UxeWr3N/MfRQ
         u0UGR/hxlseBKvmZdDLuru5dPXMyhrr3+7RdidJQFGJ/keaGFND60khM5ugB87uRHMcz
         7Ycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W9vYmFHMexd2bNJ9EsbusMDr8ooE3klEPAps5y58KR0=;
        b=qHFEkAlWUc0xtSEy1AVD4EYUNenMS60un4hF47I9FfBJbkP8ytT48Si6k8sSkbG97W
         Rhk57p0hBdfa+180TnqwMlpO2ULZmEegUAuW0WCRh0StG0T124qd1FGR8/wlGuO/sRog
         IrdixOG0kCpWHLPqCYFUqMq6T/5uB22Y3j2MzIUQ535YYInoNVCOjFhKPi1UTSV5wPVN
         HqYTHic3g0VrQx9fMtOCULoe5bkW0V/76bO3X+DY9CcMvdlPgHuh2x8eIVIJcbSY0Wqq
         vLZpBjG3RQV4W1//RbU2C0WgEKN2/3AN29o2d8QtS5OPKOiK6LdbeSs0DQbBGku0/Ctm
         JzNQ==
X-Gm-Message-State: AOAM531SaOapTrjUquwDJmrEs1o0EsOm2pSE6gDSKT2RCH1lppyi9PAF
        mYKV1p+ghJ0ySa9HB75iTd40GMAX8+F8JaT9fGJse53263QYeQ==
X-Google-Smtp-Source: ABdhPJy/NF1EsAAXOefnJm0hY2HXwt9DmNvGxEkp//gset56ONvosUQNbsij8cbVLBMNELYIhzwBEJDjrNjqd51D6tM=
X-Received: by 2002:a4a:d8d7:: with SMTP id c23mr4563957oov.51.1628195576862;
 Thu, 05 Aug 2021 13:32:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAAP7ucKuS9p_hkR5gMWiM984Hvt09iNQEt32tCFDCT5p0fqg4Q@mail.gmail.com>
 <c0e14605e9bc650aca26b8c3920e9aba@codeaurora.org>
In-Reply-To: <c0e14605e9bc650aca26b8c3920e9aba@codeaurora.org>
From:   Aleksander Morgado <aleksander@aleksander.es>
Date:   Thu, 5 Aug 2021 22:32:45 +0200
Message-ID: <CAAP7ucK7EeBPJHt9XFp7bd5cGXtH5w2VGgh3yD7OA9SYd5JkJw@mail.gmail.com>
Subject: Re: RMNET QMAP data aggregation with size greater than 16384
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Daniele Palmas <dnlplm@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        stranche@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Subash,

> > I'm playing with the whole QMAP data aggregation setup with a USB
> > connected Fibocom FM150-AE module (SDX55).
> > See https://gitlab.freedesktop.org/mobile-broadband/libqmi/-/issues/71
> > for some details on how I tested all this.
> >
> > This module reports a "Downlink Data Aggregation Max Size" of 32768
> > via the "QMI WDA Get Data Format" request/response, and therefore I
> > configured the MTU of the master wwan0 interface with that same value
> > (while in 802.3 mode, before switching to raw-ip and enabling
> > qmap-pass-through in qmi_wwan).
> >
> > When attempting to create a new link using netlink, the operation
> > fails with -EINVAL, and following the code path in the kernel driver,
> > it looks like there is a check in rmnet_vnd_change_mtu() where the
> > master interface MTU is checked against the RMNET_MAX_PACKET_SIZE
> > value, defined as 16384.
> >
> > If I setup the master interface with MTU 16384 before creating the
> > links with netlink, there's no error reported anywhere. The FM150
> > module crashes as soon as I connect it with data aggregation enabled,
> > but that's a different story...
> >
> > Is this limitation imposed by the RMNET_MAX_PACKET_SIZE value still a
> > valid one in this case? Should changing the max packet size to 32768
> > be a reasonable approach? Am I doing something wrong? :)
> >
> > This previous discussion for the qmi_wwan add_mux/del_mux case is
> > relevant:
> > https://patchwork.ozlabs.org/project/netdev/patch/20200909091302.20992-1-dnlplm@gmail.com/..
> > The suggested patch was not included yet in the qmi_wwan driver and
> > therefore the user still needs to manually configure the MTU of the
> > master interface before setting up all the links, but at least there
> > seems to be no maximum hardcoded limit.
> >
> > Cheers!
>
> Hi Aleksander
>
> The downlink data aggregation size shouldn't affect the MTU.
> MTU applies for uplink only and there is no correlation with the
> downlink path.
> Ideally, you should be able to use standard 1500 bytes (+ additional
> size for MAP header)
> for the master device. Is there some specific network which is using
> greater than 1500 for the IP packet itself in uplink.
>

I may be mistaken then in how this should be setup when using rmnet.
For the qmi_wwan case using add_mux/del_mux (Daniele correct me if
wrong!), we do need to configure the MTU of the master interface to be
equal to the aggregation data size reported via QMI WDA before
creating any mux link; see
http://paldan.altervista.org/linux-qmap-qmi_wwan-multiple-pdn-setup/

I ended up doing the same here for the rmnet case; but if it's not
needed I can definitely change that. I do recall that I originally had
left the master MTU untouched in the rmnet case and users had issues,
and increasing it to the aggregation size solved that; I assume that's
because the MTU should have been increased to accommodate the extra
MAP header as you said. How much more size does it need on top of the
1500 bytes?

-- 
Aleksander
https://aleksander.es
