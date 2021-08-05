Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C704E3E1DAD
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 23:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241387AbhHEVBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 17:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbhHEVBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 17:01:52 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3399C0613D5
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 14:01:37 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id o185so9099200oih.13
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 14:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aleksander-es.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pkP3bw5I5Ps1r0+Cjrqa/cYSvBCbFEkN0mypUo9pB7c=;
        b=vqStLWVREgAl+1PuvIR9yOMp3srhqtzv6D5wn0WPJh7zQZzm1Vlj1igVi+LxDmw0GX
         pzvx3sbonSvOaTnBxQuCJhDgc7Hze6o7L93AbUdcXiFNsDmx33DPoS+AJg6Y8iTZTXXi
         0wpZft5seu7O6YeMZm8thiaumwnmjL4F6tWd0oTcWrG4TD9Gqqnm99C9VUIcw0wcrXb6
         q+mXM3neY4eYRhMx0nXEfcH5az86xosrf1lbUkssK50LmyZFdhEwe6k9b0n0wsRFxXJ4
         +tnHhiNC0yzTcu/wj0FZIubsC22yLcCz4uSUBNii863vqTX1qwaCkaoZDjtb/3gQyS1X
         OAKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pkP3bw5I5Ps1r0+Cjrqa/cYSvBCbFEkN0mypUo9pB7c=;
        b=FsLndXUpWBquuVwTuNXxDNpjiKtdpbFedb+qdVdv8m9XIyLJ5fK2H8TT8aDmOqfayH
         Tmz+CaUMLrqALTzpot6oq8kWrsP8kn6Pq6Jo87XQ3Ic5WcUJSzILcNM1XoiofyMzu6FL
         AKeluxRBAlWdX+40ExP/VSBnO120pBKF/gMbE0UONnuSOdmGVsaco9/EDeC8ErTXC0p1
         6y2oo38hgEqQb88amrzSY1TMA1I2NG6DwpDjN5r+yZQ63mENsWe0gnp614YSCzX3j6xW
         ZLyqE07xmfd8lQDu0J0m+QfvxDyZFeEhZkfDJA0ZpP9FOmGAwxOivnXR6BF+UoDpSOD+
         dcCw==
X-Gm-Message-State: AOAM533WLPaoeOrVeIsFoRf0jouuSiZm8RMzG2thnO1OAebEpAKO+1Wk
        f3uAeKKXn9sqmQG6BWwH47fHlIU3RpVEaM/9i3CKnQ==
X-Google-Smtp-Source: ABdhPJzYKDdChnOzr1BclIUvQw/F2huCSAbQCkDLNNaKEcTtrglirUgeuI/Rb1RfFX7ZFESC8otz4WNwvPnpD6pUyr0=
X-Received: by 2002:aca:3246:: with SMTP id y67mr4914785oiy.67.1628197296947;
 Thu, 05 Aug 2021 14:01:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAAP7ucKuS9p_hkR5gMWiM984Hvt09iNQEt32tCFDCT5p0fqg4Q@mail.gmail.com>
 <c0e14605e9bc650aca26b8c3920e9aba@codeaurora.org> <CAAP7ucK7EeBPJHt9XFp7bd5cGXtH5w2VGgh3yD7OA9SYd5JkJw@mail.gmail.com>
 <CAGRyCJHYkH4_FvTzk7BFwjMN=iOTN_Y2=4ueY=s3rJMQO9j7uw@mail.gmail.com>
In-Reply-To: <CAGRyCJHYkH4_FvTzk7BFwjMN=iOTN_Y2=4ueY=s3rJMQO9j7uw@mail.gmail.com>
From:   Aleksander Morgado <aleksander@aleksander.es>
Date:   Thu, 5 Aug 2021 23:01:26 +0200
Message-ID: <CAAP7ucJhO9E3vzM2-w8V6a5K07_nDQS_V6G78FMWQb-74pRbSQ@mail.gmail.com>
Subject: Re: RMNET QMAP data aggregation with size greater than 16384
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Network Development <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> > > I'm playing with the whole QMAP data aggregation setup with a USB
>> > > connected Fibocom FM150-AE module (SDX55).
>> > > See https://gitlab.freedesktop.org/mobile-broadband/libqmi/-/issues/71
>> > > for some details on how I tested all this.
>> > >
>> > > This module reports a "Downlink Data Aggregation Max Size" of 32768
>> > > via the "QMI WDA Get Data Format" request/response, and therefore I
>> > > configured the MTU of the master wwan0 interface with that same value
>> > > (while in 802.3 mode, before switching to raw-ip and enabling
>> > > qmap-pass-through in qmi_wwan).
>> > >
>> > > When attempting to create a new link using netlink, the operation
>> > > fails with -EINVAL, and following the code path in the kernel driver,
>> > > it looks like there is a check in rmnet_vnd_change_mtu() where the
>> > > master interface MTU is checked against the RMNET_MAX_PACKET_SIZE
>> > > value, defined as 16384.
>> > >
>> > > If I setup the master interface with MTU 16384 before creating the
>> > > links with netlink, there's no error reported anywhere. The FM150
>> > > module crashes as soon as I connect it with data aggregation enabled,
>> > > but that's a different story...
>> > >
>> > > Is this limitation imposed by the RMNET_MAX_PACKET_SIZE value still a
>> > > valid one in this case? Should changing the max packet size to 32768
>> > > be a reasonable approach? Am I doing something wrong? :)
>> > >
>> > > This previous discussion for the qmi_wwan add_mux/del_mux case is
>> > > relevant:
>> > > https://patchwork.ozlabs.org/project/netdev/patch/20200909091302.20992-1-dnlplm@gmail.com/..
>> > > The suggested patch was not included yet in the qmi_wwan driver and
>> > > therefore the user still needs to manually configure the MTU of the
>> > > master interface before setting up all the links, but at least there
>> > > seems to be no maximum hardcoded limit.
>> > >
>> > > Cheers!
>> >
>> > Hi Aleksander
>> >
>> > The downlink data aggregation size shouldn't affect the MTU.
>> > MTU applies for uplink only and there is no correlation with the
>> > downlink path.
>> > Ideally, you should be able to use standard 1500 bytes (+ additional
>> > size for MAP header)
>> > for the master device. Is there some specific network which is using
>> > greater than 1500 for the IP packet itself in uplink.
>> >
>>
>> I may be mistaken then in how this should be setup when using rmnet.
>> For the qmi_wwan case using add_mux/del_mux (Daniele correct me if
>> wrong!), we do need to configure the MTU of the master interface to be
>> equal to the aggregation data size reported via QMI WDA before
>> creating any mux link; see
>> http://paldan.altervista.org/linux-qmap-qmi_wwan-multiple-pdn-setup/
>>
>
> Right: it's not for the MTU itself, but for changing the rx_urb_size, since usbnet_change_mtu has that side effect.
>

I knew there was a reason even if not obvious. Should we fix that rx
urb size value to 16384 to avoid needing that extra step? Was that
what you were suggesting in that patch that was never merged?

-- 
Aleksander
https://aleksander.es
