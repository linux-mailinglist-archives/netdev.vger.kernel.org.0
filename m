Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C783E2C50
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 16:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237522AbhHFOPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 10:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhHFOPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 10:15:49 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D1BC0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 07:08:57 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id r5so1777321oiw.7
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 07:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aleksander-es.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MJ7CCmOrrQ1EMyOU5DQxWjMW5NSA4+qYmc5v4hp8M7I=;
        b=X9YAqxXr3mkNEl6dlBbugiOtVOHWi5nwmqjSzpcbYQC0KhBrgYkGx5MI3Vtx6G3wd8
         xcRPafRnRGUHqHdnFwJ/ySG/Gt8icfiWsH5MFkIb62zhjl8U7o1yfEe048U02opnccl1
         lEK+KLgzNIRcLJPigPsaKZ3VBmt9jVARAMb8R5L9eC654jldVmrm4bRRNBO+UFQvVkQm
         9EAcTxihYCIpJ4EOZX3HIvdjRpZ0Yf7wopSepF7E2AN0kPlqzRyXoOCtrtl1foNDOo5M
         i1aERK9N0lexAaIT6hV0Vf34CxYN5TOPn60y54bErxTrbERyDnzjQ0HKZGUVEfqYMlDq
         0FMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MJ7CCmOrrQ1EMyOU5DQxWjMW5NSA4+qYmc5v4hp8M7I=;
        b=ApjDXQ5WQ3K+hdGVfCh0TFJcqwNl8V+l2jgXeAST/OeOfTNCyZsQsZEEz3GYR95K6R
         F6y6QRy6aO0/8hsU2lIadlHJwRiX+TuhlTn8gga+H9FRq1g4skj77+FPLMldVv5KT6iG
         Ku0iDW8Rcplfk41LeiwsYGic2+ZnxKZ4iAgji0yez3Awb+VToSdGCEY+Qfyu20FCRz1G
         4kvTK9jI+Hdpfu14h0EyaGu+4gcVdfhviUWsmKkPj9L/jNu5+byYBQ7tsV3STzIZxm5m
         WMbMEHs1nfebx6qSYIx6ZWuMN5Xe1udBVgbykTKQ2ihF56TX245Mo1ZjI38KHRDOTcn3
         M/YQ==
X-Gm-Message-State: AOAM5337SSIPLMWNDN/Z8kcclYVhk1bGyNKRf+nV7445rVqyQNIXO2XH
        CacphwUn/2MzwJ5oH+3CMpLiOba4Afk6Vydv1GKclH9EjaLHmQ==
X-Google-Smtp-Source: ABdhPJwxMIiUeNPrxT676vdXSc0z6AIDu7nSPWStW/kz0UagEplwB5qJgV5uaVD3bJbmvKLAzSznvwUXw6AgfRK28v0=
X-Received: by 2002:a54:4e8f:: with SMTP id c15mr15243693oiy.114.1628258936748;
 Fri, 06 Aug 2021 07:08:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAAP7ucKuS9p_hkR5gMWiM984Hvt09iNQEt32tCFDCT5p0fqg4Q@mail.gmail.com>
 <c0e14605e9bc650aca26b8c3920e9aba@codeaurora.org> <CAAP7ucK7EeBPJHt9XFp7bd5cGXtH5w2VGgh3yD7OA9SYd5JkJw@mail.gmail.com>
 <77b850933d9af8ddbc21f5908ca0764d@codeaurora.org>
In-Reply-To: <77b850933d9af8ddbc21f5908ca0764d@codeaurora.org>
From:   Aleksander Morgado <aleksander@aleksander.es>
Date:   Fri, 6 Aug 2021 16:08:45 +0200
Message-ID: <CAAP7ucJRbg58Yqcx-qFFUuu=_=3Ss1HE1ZW4XGrm0KsSXnwdmA@mail.gmail.com>
Subject: Re: RMNET QMAP data aggregation with size greater than 16384
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Daniele Palmas <dnlplm@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Subash,

> > I may be mistaken then in how this should be setup when using rmnet.
> > For the qmi_wwan case using add_mux/del_mux (Daniele correct me if
> > wrong!), we do need to configure the MTU of the master interface to be
> > equal to the aggregation data size reported via QMI WDA before
> > creating any mux link; see
> > http://paldan.altervista.org/linux-qmap-qmi_wwan-multiple-pdn-setup/
> >
> > I ended up doing the same here for the rmnet case; but if it's not
> > needed I can definitely change that. I do recall that I originally had
> > left the master MTU untouched in the rmnet case and users had issues,
> > and increasing it to the aggregation size solved that; I assume that's
> > because the MTU should have been increased to accommodate the extra
> > MAP header as you said. How much more size does it need on top of the
> > 1500 bytes?
>
> You need to use an additional 4 bytes for MAPv1 and 8 bytes for
> MAPv4/v5.
>

I tried with a SIMCOM 7600E, with data aggregation enabled with QMAPv1:

$ sudo qmicli -d /dev/cdc-wdm0 -p --wda-get-data-format
[/dev/cdc-wdm0] Successfully got data format
                   QoS flow header: no
               Link layer protocol: 'raw-ip'
  Uplink data aggregation protocol: 'qmap'
Downlink data aggregation protocol: 'qmap'
                     NDP signature: '0'
Downlink data aggregation max datagrams: '10'
Downlink data aggregation max size: '4096'

As you suggested, the MTU of the new muxed interface is set to 1500
and the MTU of the master interface to only 4 more bytes (1504):

# ip link
8: wwp0s20f0u8u4i5: <POINTOPOINT,UP,LOWER_UP> mtu 1504 qdisc fq_codel
state UNKNOWN mode DEFAULT group default qlen 1000
    link/none
9: qmapmux0.0@wwp0s20f0u8u4i5: <UP,LOWER_UP> mtu 1500 qdisc fq_codel
state UNKNOWN mode DEFAULT group default qlen 1000
    link/[519]

Under this scenario, the downlink is completely broken (speedtest
0.39Mbps), while the uplink seems to work (speedtest 13Mbps).

If I use the logic I had before, associating the downlink data
aggregation max size reported by the module to the MTU of the master
interface, same as I had to do when using qmi_wwan add_mux/del_mux,
then it works properly:

# ip link
14: wwp0s20f0u8u4i5: <POINTOPOINT,UP,LOWER_UP> mtu 4096 qdisc fq_codel
state UNKNOWN mode DEFAULT group default qlen 1000
    link/none
15: qmapmux0.0@wwp0s20f0u8u4i5: <UP,LOWER_UP> mtu 1500 qdisc fq_codel
state UNKNOWN mode DEFAULT group default qlen 1000
    link/[519]

Downlink is now 26Mbps and uplink still 13Mbps.

Is there something I'm doing wrong? Or do we really need to do the
same thing as in qmi_wwan add_mux/del_mux; i.e. configuring the master
interface MTU to be the same as the downlink max aggregation data size
so that we change the rx_urb_size?

-- 
Aleksander
https://aleksander.es
