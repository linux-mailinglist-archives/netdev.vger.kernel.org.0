Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0EA1B644C
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 21:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgDWTLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 15:11:35 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:37045 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgDWTLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 15:11:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587669094; x=1619205094;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+cVjfYAvD3unz6/hlGHc2ikrQ4gswyF1rlxFN2YivHk=;
  b=VmiJV0ENqhfTJ/daRhsW+T80el7COvVR7Uhp2LtMcEJZpSYMT5IXqtHz
   DUEYWJFcOcYBf41dIjeSpyv4F3fjVefWNjiwLcTKYPYUKhMRExIRdeXyP
   Bbjh5/gLCVmQjS9KafatDH8qywv+4C6rEmheECLPk6DFPNIKvCsRa+7Yp
   wCDB9cvEBG3QhBBMQ1QFgBwwqOSOBEbAFPJrxAIS99gAZhJVgeDifGGCt
   EMxvb+x+ZWYAM3Cbsy2CIi09scX1n2K1mLIpZJh7cG7puKf43twCDH1SN
   ZbaUX6BON4M2mM/zJXCO3DlGKeaQ8WQM3zlBRwAk+zTFVg1g6daqYQeFA
   A==;
IronPort-SDR: iHfHgFDexiVhSHmxfaViEIXRiY8e+MXC3cnM/YGOy+vDxVWcImOZAZIYrQttPmt3uHYNLLJcFL
 jxAuIt1KC+YK+zpfveo0gNWmghvYTxZMV6LcyNQzQdPyZixq8/MGJko/t4piTy6d4dGxiCHq0o
 iFy0lrW3pOzrn8XaCxR645jX3RMfvpQrWtAXQXv1wRsq3Y2zWUaZpxzrVxAcCQkwshYUqbcm8C
 KS9GmqBZZXfTxttS/z0nW+ZG6Cb0Z/a5oeOb4VBGvUwJM5P7ExJ1Bs1Hu9Zb7UNr3zoWv9pikX
 Nag=
X-IronPort-AV: E=Sophos;i="5.73,307,1583218800"; 
   d="scan'208";a="73628295"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Apr 2020 12:11:33 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 23 Apr 2020 12:11:34 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 23 Apr 2020 12:11:33 -0700
Date:   Thu, 23 Apr 2020 21:11:31 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Po Liu <Po.Liu@nxp.com>, "David S. Miller" <davem@davemloft.net>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Vinicius Costa Gomes" <vinicius.gomes@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        <michael.chan@broadcom.com>, <vishal@chelsio.com>,
        <saeedm@mellanox.com>, <leon@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        <simon.horman@netronome.com>, <pablo@netfilter.org>,
        <moshe@mellanox.com>, Murali Karicheri <m-karicheri2@ti.com>,
        Andre Guedes <andre.guedes@linux.intel.com>,
        "Stephen Hemminger" <stephen@networkplumber.org>
Subject: Re: [v3,net-next 1/4] net: qos: introduce a gate control flow action
Message-ID: <20200423191131.c257srsnicyrhol6@ws.localdomain>
References: <20200418011211.31725-5-Po.Liu@nxp.com>
 <20200422024852.23224-1-Po.Liu@nxp.com>
 <20200422024852.23224-2-Po.Liu@nxp.com>
 <20200422191910.gacjlviegrjriwcx@ws.localdomain>
 <CA+h21hrZiRq2-8Dx31X_rwgJ2Lkp6eF9H7M3cOyiBAWs0_xxhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+h21hrZiRq2-8Dx31X_rwgJ2Lkp6eF9H7M3cOyiBAWs0_xxhw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.04.2020 22:28, Vladimir Oltean wrote:
>> >> tc qdisc add dev eth0 ingress
>> >
>> >> tc filter add dev eth0 parent ffff: protocol ip \
>> >           flower src_ip 192.168.0.20 \
>> >           action gate index 2 clockid CLOCK_TAI \
>> >           sched-entry open 200000000 -1 8000000 \
>> >           sched-entry close 100000000 -1 -1
>>
>> First of all, it is a long time since I read the 802.1Qci and when I did
>> it, it was a draft. So please let me know if I'm completly off here.
>>
>> I know you are focusing on the gate control in this patch serie, but I
>> assume that you later will want to do the policing and flow-meter as
>> well. And it could make sense to consider how all of this work
>> toghether.
>>
>> A common use-case for the policing is to have multiple rules pointing at
>> the same policing instance. Maybe you want the sum of the traffic on 2
>> ports to be limited to 100mbit. If you specify such action on the
>> individual rule (like done with the gate), then you can not have two
>> rules pointing at the same policer instance.
>>
>> Long storry short, have you considered if it would be better to do
>> something like:
>>
>>    tc filter add dev eth0 parent ffff: protocol ip \
>>             flower src_ip 192.168.0.20 \
>>             action psfp-id 42
>>
>> And then have some other function to configure the properties of psfp-id
>> 42?
>>
>>
>> /Allan
>>
>
>It is very good that you brought it up though, since in my opinion too
>it is a rather important aspect, and it seems that the fact this
>feature is already designed-in was a bit too subtle.
>
>"psfp-id" is actually his "index" argument.
Ahh.. Thanks for clarifying, I missed this point completly.

