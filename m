Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50C2A1258C6
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 01:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfLSAnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 19:43:31 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40852 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfLSAna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 19:43:30 -0500
Received: by mail-lj1-f196.google.com with SMTP id u1so4208341ljk.7
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 16:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=onqicWxqhCYRXnes1QOmSOtJNPq7CuqRS7oJyFTkgKc=;
        b=dLxef6dc8gv8aGWK/lMmakWKizcPikd8Nrh2bu3tj/OcQILCbF1drRvDol8LV2gDiF
         nHYAzEpI2U/1L4NCTGZOtiTQhWXwip+DCdkHA1YF7+zInDfSXRbzafS0hhqodxkUTEJD
         5xXO367L/YlfBHvyvznn0/HOrKRLSa8lgu00S5ZDhnySR/Uvm4X3ZtU95UOVmiaBlLD6
         l2klv/oLqL3Exi+bMNqU8ZoLziPj7SKxJm75go+AnaEsWarofKBK3ueCBcVIbRJIMm9p
         v1FKpoT+AZstNgCBoWTNtRStJ4uvmfyleOX9fiIxoYeim+tbdMFRTxsZ/hJa60WF+Jbk
         z76g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=onqicWxqhCYRXnes1QOmSOtJNPq7CuqRS7oJyFTkgKc=;
        b=tBxxDGLb+ybKrfE+Ka06/+DcOvC1ZICeZwPCBLtSRr8G6Y56zCR3Gd/TsjDr2+BjZb
         2imm+8pMLnR5eEhUUkREAgAtLk98iL6A4+kImNoazcSYdiXkSEWJs/S69A6Emo+Z3OBM
         Xq4L/LVpv2b1yZogugeXq0Fr1cnFb6Q94ETalEGw3933JL/RpiFY4ecAqQH7GEo25XpX
         jQTjNoFcdWg8OlL8CGSrp8P4FOMZezVi+/Q9q/+Udn9jMZ17Mbo88kzkSUoLtDSzgBuD
         wyOKOMnCztfJAiN+rAAYgAvHBa9wjnqlbeopkdYP0y0/EZPvq0iHakL2KNPlJo94XqZ+
         7asg==
X-Gm-Message-State: APjAAAU6QXYi+ulcfWL2YQvzIaSIPJhd19mwXD/+tY0fpGBJWgh9m9H3
        Hs0Jdio4TfVBzwp8ha7NhRWiNQ==
X-Google-Smtp-Source: APXvYqwSHP+/NTHTM96GSP9iEjGjPEwU/jpNK4aD4opvKpeqPHPCWHHq8JjkHgpr5+8UK9AMMohI1g==
X-Received: by 2002:a2e:9e55:: with SMTP id g21mr3818098ljk.245.1576716207794;
        Wed, 18 Dec 2019 16:43:27 -0800 (PST)
Received: from khorivan (57-201-94-178.pool.ukrtel.net. [178.94.201.57])
        by smtp.gmail.com with ESMTPSA id l12sm1903742lji.52.2019.12.18.16.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 16:43:27 -0800 (PST)
Date:   Thu, 19 Dec 2019 02:43:24 +0200
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Po Liu <po.liu@nxp.com>,
        Andre Guedes <andre.guedes@linux.intel.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "ayal@mellanox.com" <ayal@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hauke.mehrtens@intel.com" <hauke.mehrtens@intel.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: Re: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame
 preemption of traffic classes
Message-ID: <20191219004322.GA20146@khorivan>
Mail-Followup-To: Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Po Liu <po.liu@nxp.com>,
        Andre Guedes <andre.guedes@linux.intel.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "ayal@mellanox.com" <ayal@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hauke.mehrtens@intel.com" <hauke.mehrtens@intel.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com>
 <157603276975.18462.4638422874481955289@pipeline>
 <VE1PR04MB6496CEA449E9B844094E580492510@VE1PR04MB6496.eurprd04.prod.outlook.com>
 <87eex43pzm.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87eex43pzm.fsf@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 01:44:13PM -0800, Vinicius Costa Gomes wrote:
>Hi Po,
>
>Po Liu <po.liu@nxp.com> writes:
>
>> Hi Andre,
>>
>>
>> Br,
>> Po Liu
>>
>>> -----Original Message-----
>>> From: Andre Guedes <andre.guedes@linux.intel.com>
>>> Sent: 2019年12月11日 10:53
>>> To: alexandru.ardelean@analog.com; allison@lohutok.net; andrew@lunn.ch;
>>> ayal@mellanox.com; davem@davemloft.net; f.fainelli@gmail.com;
>>> gregkh@linuxfoundation.org; hauke.mehrtens@intel.com;
>>> hkallweit1@gmail.com; jiri@mellanox.com; linux-kernel@vger.kernel.org;
>>> netdev@vger.kernel.org; pablo@netfilter.org; saeedm@mellanox.com;
>>> tglx@linutronix.de; Po Liu <po.liu@nxp.com>
>>> Cc: vinicius.gomes@intel.com; simon.horman@netronome.com; Claudiu Manoil
>>> <claudiu.manoil@nxp.com>; Vladimir Oltean <vladimir.oltean@nxp.com>;
>>> Alexandru Marginean <alexandru.marginean@nxp.com>; Xiaoliang Yang
>>> <xiaoliang.yang_1@nxp.com>; Roy Zang <roy.zang@nxp.com>; Mingkai Hu
>>> <mingkai.hu@nxp.com>; Jerry Huang <jerry.huang@nxp.com>; Leo Li
>>> <leoyang.li@nxp.com>; Po Liu <po.liu@nxp.com>
>>> Subject: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame preemption of
>>> traffic classes
>>>
>>> Caution: EXT Email
>>>
>>> Hi Po,
>>>
>>> Quoting Po Liu (2019-11-27 01:59:18)
>>> > IEEE Std 802.1Qbu standard defined the frame preemption of port
>>> > traffic classes. This patch introduce a method to set traffic classes
>>> > preemption. Add a parameter 'preemption' in struct
>>> > ethtool_link_settings. The value will be translated to a binary, each
>>> > bit represent a traffic class. Bit "1" means preemptable traffic
>>> > class. Bit "0" means express traffic class.  MSB represent high number
>>> > traffic class.
>>> >
>>> > If hardware support the frame preemption, driver could set the
>>> > ethernet device with hw_features and features with NETIF_F_PREEMPTION
>>> > when initializing the port driver.
>>> >
>>> > User can check the feature 'tx-preemption' by command 'ethtool -k
>>> > devname'. If hareware set preemption feature. The property would be a
>>> > fixed value 'on' if hardware support the frame preemption.
>>> > Feature would show a fixed value 'off' if hardware don't support the
>>> > frame preemption.
>
>Having some knobs in ethtool to enable when/how Frame Preemption is
>advertised on the wire makes sense. I also agree that it should be "on"
>by default.
>
>>> >
>>> > Command 'ethtool devname' and 'ethtool -s devname preemption N'
>>> > would show/set which traffic classes are frame preemptable.
>>> >
>>> > Port driver would implement the frame preemption in the function
>>> > get_link_ksettings() and set_link_ksettings() in the struct ethtool_ops.
>>>
>>> In an early RFC series [1], we proposed a way to support frame preemption. I'm
>>> not sure if you have considered it before implementing this other proposal
>>> based on ethtool interface so I thought it would be a good idea to bring that up
>>> to your attention, just in case.
>>
>> Sorry, I didn't notice the RFC proposal. Using ethtool set the
>> preemption just thinking about 8021Qbu as standalone. And not limit to
>> the taprio if user won't set 802.1Qbv.
>
>I see your point of using frame-preemption "standalone", I have two
>ideas:
>
> 1. add support in taprio to be configured without any schedule in the
> "full offload" mode. In practice, allowing taprio to work somewhat
> similar to (mqprio + frame-preemption), changes in the code should de
> fairly small;

+

And if follow mqprio settings logic then preemption also can be enabled
immediately while configuring taprio first time, and similarly new ADMIN
can't change it and can be set w/o preemption option afterwards.

So that following is correct:

OPER
$ tc qdisc add dev IFACE parent root handle 100 taprio \
      base-time 10000000 \
      num_tc 3 \
      map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
      queues 1@0 1@1 2@2 \
      preemption 0 1 1 1
      flags 1

then
ADMIN
$ tc qdisc add dev IFACE parent root handle 100 taprio \
      base-time 12000000 \
      num_tc 3 \
      map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
      queues 1@0 1@1 2@2 \
      preemption 0 1 1 1
      sched-entry S 01 300000 \
      sched-entry S 02 300000 \
      flags 1

then
ADMIN
$ tc qdisc add dev IFACE parent root handle 100 taprio \
      base-time 13000000 \
      sched-entry S 01 300000 \
      sched-entry S 02 300000 \
      flags 1

BUT:

1) The question is only should it be in this way? I mean preemption to be
enabled immediately? Also should include other parameters like fragment size.

2) What if I want to use frame preemption with another "transmission selection
algorithm"? Say another one "time sensitive" - CBS? How is it going to be
stacked?

In this case ethtool looks better, allowing this "MAC level" feature, to be
configured separately.

>
> 2. extend mqprio to support frame-preemption;
>
>>
>> As some feedback  also want to set the MAC merge minimal fragment size
>> and get some more information of 802.3br.
>
>The minimal fragment size, I guess, also makes sense to be kept in
>ethtool. That is we have a sane default, and allow the user to change
>this setting for special cases.
>
>>
>>>
>>> In that initial proposal, Frame Preemption feature is configured via taprio qdisc.
>>> For example:
>>>
>>> $ tc qdisc add dev IFACE parent root handle 100 taprio \
>>>       num_tc 3 \
>>>       map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>>>       queues 1@0 1@1 2@2 \
>>>       preemption 0 1 1 1 \
>>>       base-time 10000000 \
>>>       sched-entry S 01 300000 \
>>>       sched-entry S 02 300000 \
>>>       sched-entry S 04 400000 \
>>>       clockid CLOCK_TAI
>>>
>>> It also aligns with the gate control operations Set-And-Hold-MAC and Set-And-
>>> Release-MAC that can be set via 'sched-entry' (see Table 8.7 from
>>> 802.1Q-2018 for further details.
>>
>> I am curious about Set-And-Hold-Mac via 'sched-entry'. Actually, it
>> could be understand as guardband by hardware preemption. MAC should
>> auto calculate the nano seconds before  express entry slot start to
>> break to two fragments. Set-And-Hold-MAC should minimal larger than
>> the fragment-size oct times.
>
>Another interesting point. My first idea is that when the schedule is
>offloaded to the driver and the driver detects that the "entry" width is
>smaller than the fragment side, the driver could reject that schedule
>with a nice error message.

Looks ok, if entry command is RELEASE or SET only, but not HOLD, and
only if it contains express queues. And if for entry is expectable to have
interval shorter, the entry has to be marked as HOLD then.

But not every offload is able to support mac/hold per sched (there is
no HOLD/RELEASE commands in this case). For this case seems like here can
be 2 cases:

1) there is no “gate close” event for the preemptible traffic
2) there is "gate close" event for the preemptable traffic

And both can have the following impact, if assume the main reason to
this guard check is to guarantee the express queue cannot be blocked while
this "close to short" interval opening ofc:

If a preemption fragment is started before "express" frame, then interval
should allow to complete preemption fragment and has to have enough time
to insert express frame. So here situation when maximum packet size per
each queue can have place.

In case of TI am65 this queue MTU is configurable per queue (for similar
reasons and couple more (packet fill feature for instance)) and can be
used for guard check also, but not clear where it should be. Seems like
it should be done using ethtool also, but can be needed for taprio
interface....

>>
>>>
>>> Please share your thoughts on this.
>>
>> I am good to see there is frame preemption proposal. Each way is ok
>> for me but ethtool is more flexible. I've seen the RFC the code. The
>> hardware offload is in the mainline, but preemption is not yet, I
>> don't know why. Could you post it again?
>
>It's not mainline because this kind of stuff will not be accepted
>upstream without in-tree users. And you are the first one to propose
>such a thing :-)
>
>It's just now that I have something that supports frame-preemption, the
>code I have is approaching RFC-like quality. I will send another RFC
>this week hopefully, and we can see how things look in practice.
>
>
>Cheers,
>--
>Vinicius

-- 
Regards,
Ivan Khoronzhuk
