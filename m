Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7DFE1B4D35
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 21:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgDVTTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 15:19:14 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:43502 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbgDVTTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 15:19:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587583152; x=1619119152;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wUFdB6s2DW2Sp8KobX3ZW4FX95vp1dXONK3ZKJv9l1E=;
  b=xawdOcom03yL6DIoD8FbRc7Zj453bsveSbIkEkY7Qc62LnLUrzI3kLj/
   smalJPK5T1Rhp4b3PbLqZwo+exvjCbwK2I5m8aLyhjGyeL6M/z9rlVVnS
   xi0CDMKXxex1DyA7zB/TIC03O03B2TVjVBPLQRna0jSVaY3rPPutIX3Si
   vgSvw0+rfZDgD7DDtyVLbpdNfAoEqeB+1TdmaoUu+hW6tzBH6uqI8BiG4
   J1C4fvTsf3I+FpqPCS3VDcAn9m3yWszrHjTOmPrwJEnWvubDOHijgLJ3/
   4EDQJtctK1IiLiKJX1lsrwwpDYeNEkhYib/uivFIqhh1alnLURrGBe3/g
   w==;
IronPort-SDR: z7PGyBtN0m1w1Trdy4Iw9ZiOw5G/9AfMrzqGDuCKyo30O3sHaFmWHt6wZihosFBZZc9ys4JzLK
 63unZUpamyXo2J2hj7xRVOhCklNspn7Pc4cJuSBBsOZ/ynrr68lvLlbg8ls9rJYKjm5Ch4mQ6q
 FW6MSKz5lMUAEly08vcC6s79eefmcUh9WN2zhCW4Di5lwdp/SLbA6DxHCWdGR6TlIPNjAaF6gK
 KGkuzkZqRHBFQpLeEQW/zuSpw8VDkWTUwhzhvUp9NmGJS/gD0mJvVKUdJXs1jISgletzUsV70A
 HHU=
X-IronPort-AV: E=Sophos;i="5.73,304,1583218800"; 
   d="scan'208";a="71228360"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Apr 2020 12:19:11 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 Apr 2020 12:18:38 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Wed, 22 Apr 2020 12:18:38 -0700
Date:   Wed, 22 Apr 2020 21:19:10 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Po Liu <Po.Liu@nxp.com>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <vinicius.gomes@intel.com>,
        <claudiu.manoil@nxp.com>, <vladimir.oltean@nxp.com>,
        <alexandru.marginean@nxp.com>, <michael.chan@broadcom.com>,
        <vishal@chelsio.com>, <saeedm@mellanox.com>, <leon@kernel.org>,
        <jiri@mellanox.com>, <idosch@mellanox.com>,
        <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <kuba@kernel.org>, <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
        <simon.horman@netronome.com>, <pablo@netfilter.org>,
        <moshe@mellanox.com>, <m-karicheri2@ti.com>,
        <andre.guedes@linux.intel.com>, <stephen@networkplumber.org>
Subject: Re: [v3,net-next  1/4] net: qos: introduce a gate control flow action
Message-ID: <20200422191910.gacjlviegrjriwcx@ws.localdomain>
References: <20200418011211.31725-5-Po.Liu@nxp.com>
 <20200422024852.23224-1-Po.Liu@nxp.com>
 <20200422024852.23224-2-Po.Liu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20200422024852.23224-2-Po.Liu@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Po,

Nice to see even more work on the TSN standards in the upstream kernel.

On 22.04.2020 10:48, Po Liu wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>Introduce a ingress frame gate control flow action.
>Tc gate action does the work like this:
>Assume there is a gate allow specified ingress frames can be passed at
>specific time slot, and be dropped at specific time slot. Tc filter
>chooses the ingress frames, and tc gate action would specify what slot
>does these frames can be passed to device and what time slot would be
>dropped.
>Tc gate action would provide an entry list to tell how much time gate
>keep open and how much time gate keep state close. Gate action also
>assign a start time to tell when the entry list start. Then driver would
>repeat the gate entry list cyclically.
>For the software simulation, gate action requires the user assign a time
>clock type.
>
>Below is the setting example in user space. Tc filter a stream source ip
>address is 192.168.0.20 and gate action own two time slots. One is last
>200ms gate open let frame pass another is last 100ms gate close let
>frames dropped. When the frames have passed total frames over 8000000
>bytes, frames will be dropped in one 200000000ns time slot.
>
>> tc qdisc add dev eth0 ingress
>
>> tc filter add dev eth0 parent ffff: protocol ip \
>           flower src_ip 192.168.0.20 \
>           action gate index 2 clockid CLOCK_TAI \
>           sched-entry open 200000000 -1 8000000 \
>           sched-entry close 100000000 -1 -1

First of all, it is a long time since I read the 802.1Qci and when I did
it, it was a draft. So please let me know if I'm completly off here.

I know you are focusing on the gate control in this patch serie, but I
assume that you later will want to do the policing and flow-meter as
well. And it could make sense to consider how all of this work
toghether.

A common use-case for the policing is to have multiple rules pointing at
the same policing instance. Maybe you want the sum of the traffic on 2
ports to be limited to 100mbit. If you specify such action on the
individual rule (like done with the gate), then you can not have two
rules pointing at the same policer instance.

Long storry short, have you considered if it would be better to do
something like:

   tc filter add dev eth0 parent ffff: protocol ip \
            flower src_ip 192.168.0.20 \
            action psfp-id 42

And then have some other function to configure the properties of psfp-id
42?


/Allan

