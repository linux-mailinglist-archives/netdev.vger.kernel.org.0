Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87713E2F64
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 20:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243281AbhHFSnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 14:43:24 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:58178 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbhHFSnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 14:43:22 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628275386; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=IbPZn8iNaCUL+l5O5Ljf/OCMajoxh9XOhvk0L9CL2X8=;
 b=a9fSoGLmq/QW7DQLmmidJLYYaeB7Ay0u1PEKpkpjulIW/fX3ctZ59+9CNOyEie2MapjfoMdI
 1Yjp+4V08Y+n+uQFArB3WQIvcoCKzmOg6aAX8zC5JtOm8pewo39aBa3o3d0PeMInaulXpko2
 SqvReZp6rDzQ4OWoaC3IrA1K00M=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 610d82ab041a739c4641c0b6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 06 Aug 2021 18:42:51
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EE1B6C4338A; Fri,  6 Aug 2021 18:42:49 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 90E7FC433D3;
        Fri,  6 Aug 2021 18:42:49 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 06 Aug 2021 12:42:49 -0600
From:   subashab@codeaurora.org
To:     Aleksander Morgado <aleksander@aleksander.es>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Daniele Palmas <dnlplm@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>
Subject: Re: RMNET QMAP data aggregation with size greater than 16384
In-Reply-To: <CAAP7ucJRbg58Yqcx-qFFUuu=_=3Ss1HE1ZW4XGrm0KsSXnwdmA@mail.gmail.com>
References: <CAAP7ucKuS9p_hkR5gMWiM984Hvt09iNQEt32tCFDCT5p0fqg4Q@mail.gmail.com>
 <c0e14605e9bc650aca26b8c3920e9aba@codeaurora.org>
 <CAAP7ucK7EeBPJHt9XFp7bd5cGXtH5w2VGgh3yD7OA9SYd5JkJw@mail.gmail.com>
 <77b850933d9af8ddbc21f5908ca0764d@codeaurora.org>
 <CAAP7ucJRbg58Yqcx-qFFUuu=_=3Ss1HE1ZW4XGrm0KsSXnwdmA@mail.gmail.com>
Message-ID: <13972ac97ffe7a10fd85fe03dc84dc02@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I tried with a SIMCOM 7600E, with data aggregation enabled with QMAPv1:
> 
> $ sudo qmicli -d /dev/cdc-wdm0 -p --wda-get-data-format
> [/dev/cdc-wdm0] Successfully got data format
>                    QoS flow header: no
>                Link layer protocol: 'raw-ip'
>   Uplink data aggregation protocol: 'qmap'
> Downlink data aggregation protocol: 'qmap'
>                      NDP signature: '0'
> Downlink data aggregation max datagrams: '10'
> Downlink data aggregation max size: '4096'
> 
> As you suggested, the MTU of the new muxed interface is set to 1500
> and the MTU of the master interface to only 4 more bytes (1504):
> 
> # ip link
> 8: wwp0s20f0u8u4i5: <POINTOPOINT,UP,LOWER_UP> mtu 1504 qdisc fq_codel
> state UNKNOWN mode DEFAULT group default qlen 1000
>     link/none
> 9: qmapmux0.0@wwp0s20f0u8u4i5: <UP,LOWER_UP> mtu 1500 qdisc fq_codel
> state UNKNOWN mode DEFAULT group default qlen 1000
>     link/[519]
> 
> Under this scenario, the downlink is completely broken (speedtest
> 0.39Mbps), while the uplink seems to work (speedtest 13Mbps).
> 
> If I use the logic I had before, associating the downlink data
> aggregation max size reported by the module to the MTU of the master
> interface, same as I had to do when using qmi_wwan add_mux/del_mux,
> then it works properly:
> 
> # ip link
> 14: wwp0s20f0u8u4i5: <POINTOPOINT,UP,LOWER_UP> mtu 4096 qdisc fq_codel
> state UNKNOWN mode DEFAULT group default qlen 1000
>     link/none
> 15: qmapmux0.0@wwp0s20f0u8u4i5: <UP,LOWER_UP> mtu 1500 qdisc fq_codel
> state UNKNOWN mode DEFAULT group default qlen 1000
>     link/[519]
> 
> Downlink is now 26Mbps and uplink still 13Mbps.
> 
> Is there something I'm doing wrong? Or do we really need to do the
> same thing as in qmi_wwan add_mux/del_mux; i.e. configuring the master
> interface MTU to be the same as the downlink max aggregation data size
> so that we change the rx_urb_size?

Unfortunately, this seems to be a limitation of qmi_wwan (usbnet)
where its tying the RX to the TX size through usbnet_change_mtu.

Ideally, we should break this dependency and have a sysfs or some other
configuration scheme to set the rx_urb_size.

Looks like this discussion has happened a while back and the option to 
use
a configurable scheme for rx_urb_size was rejected by Bjorn and Greg KH.
The summary of the thread was to set a large rx_urb_size during probe 
itself for qmi_wwan.

https://patchwork.kernel.org/project/linux-usb/patch/20200803065105.8997-1-yzc666@netease.com/

We could try setting a large value as suggested there and it should 
hopefully
solve the issue you are seeing.

--
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
a Linux Foundation Collaborative Project
