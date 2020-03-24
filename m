Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B02E4190A86
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 11:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbgCXKT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 06:19:27 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56269 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727238AbgCXKT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 06:19:26 -0400
Received: by mail-wm1-f67.google.com with SMTP id v25so696544wmh.5
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 03:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=80RpxoOFK8eqQJ7z0FpcXdmQ/4odvbE0BLwcslIjfFA=;
        b=ZGuryb3WTvrwhKPhS13bSYjlBqsg8iqViEV4+Sk8KxV9fcxM9kvv+xvFJQdKNTq8Yt
         XMKdgvOI790cxdQOElHbDmqnHfSAi6hhKrel8o5LDpkspHZ9x+dmO5V82UL+Fj6j5P54
         9wwBgCs5Dk56IzpWCd/oLC/icDheIAKIfb80TSCBQzSiUl5ONB1Gbw50BD18ebV/a/z5
         2dDTlcjFas5Otidoil8L1Fez68hSL+1ySLsEwsUgn2tLcEZBjBGolXwZRwOx0kzlXBrC
         xT1Cse+AbMcrJN3L9AFqjw2xAUcuDBpKgi/VzPwLKz8nsrR8T4W/mnWhpdJe1KOLlFxb
         jpAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=80RpxoOFK8eqQJ7z0FpcXdmQ/4odvbE0BLwcslIjfFA=;
        b=QqJicHPoi/6MN/48z8DJxazzSp+2lXwvjDn/CGf16UjcXT5Di3iC0uRgYydRRtg/Sz
         +8XZVs6cxMq1LeNoniRZfAoXEZD7DEc3oMVqteh+iaU+yd1LhYcfDwToOrlmAQrTARZU
         PQfovXB5TtO3NjjFFaZVsVrBrwf10hsT2ZF6ZQLBQKeH4StquKuiw1VjS8NHc6s5jNC3
         XRADj8Tp6u1OXWmDBagzCT/9AzPpcx9Q2lMIB/y90fY3kDS9W0oabFaNI+E8ohg0OFyT
         eS1oJWtpgTK8LdiywKKizC+mgqrrYXotNo2JVg3TzTEHWGT2mEZsQmwYkCMDQBqfO2Mt
         q/Ag==
X-Gm-Message-State: ANhLgQ1nTCbSWUuLpP53jyyiictOIsCUTT9XE9deCn5ueY/gLeBNwkBY
        ZCIMYmt/OmRKkXIruCykvrzuCg==
X-Google-Smtp-Source: ADFU+vumcRucMsLTJbxE25tsTtT5Pfd+KJ0fcyrSYAwiyIRt/bwmiNlawBL/tZk6cXpuFUgyxt2r5w==
X-Received: by 2002:a1c:2285:: with SMTP id i127mr4985834wmi.152.1585045162529;
        Tue, 24 Mar 2020 03:19:22 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id h26sm3769114wmb.19.2020.03.24.03.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 03:19:21 -0700 (PDT)
Date:   Tue, 24 Mar 2020 11:19:21 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Po Liu <Po.Liu@nxp.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vinicius.gomes@intel.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        roy.zang@nxp.com, mingkai.hu@nxp.com, jerry.huang@nxp.com,
        leoyang.li@nxp.com, michael.chan@broadcom.com, vishal@chelsio.com,
        saeedm@mellanox.com, leon@kernel.org, jiri@mellanox.com,
        idosch@mellanox.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, simon.horman@netronome.com,
        pablo@netfilter.org, moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org
Subject: Re: [v1,net-next  2/5] net: qos: introduce a gate control flow action
Message-ID: <20200324101921.GS11304@nanopsycho.orion>
References: <20200306125608.11717-11-Po.Liu@nxp.com>
 <20200324034745.30979-1-Po.Liu@nxp.com>
 <20200324034745.30979-3-Po.Liu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324034745.30979-3-Po.Liu@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Mar 24, 2020 at 04:47:40AM CET, Po.Liu@nxp.com wrote:
>Introduce a ingress frame gate control flow action. tc create a gate
>action would provide a gate list to control when open/close state. when
>the gate open state, the flow could pass but not when gate state is
>close. The driver would repeat the gate list cyclically. User also could
>assign a time point to start the gate list by the basetime parameter. if
>the basetime has passed current time, start time would calculate by the
>cycletime of the gate list.

Cannot decypher this either :/ Seriously, please make the patch
descriptions readable.

Also, a sentence starts with capital letter.



>The action gate behavior try to keep according to the IEEE 802.1Qci spec.
>For the software simulation, require the user input the clock type.
>
>Below is the setting example in user space. Tc filter a stream source ip
>address is 192.168.0.20 and gate action own two time slots. One is last
>200ms gate open let frame pass another is last 100ms gate close let
>frames dropped. When the passed total frames over 8000000 bytes, it will
>dropped in one 200000000ns time slot.
>
>> tc qdisc add dev eth0 ingress
>
>> tc filter add dev eth0 parent ffff: protocol ip \
>	   flower src_ip 192.168.0.20 \
>	   action gate index 2 clockid CLOCK_TAI \
>	   sched-entry OPEN 200000000 -1 8000000 \
>	   sched-entry CLOSE 100000000 -1 -1

The rest of the commands do not use capitals. Please lowercase these.


>
>> tc chain del dev eth0 ingress chain 0
>
>"sched-entry" follow the name taprio style. gate state is
>"OPEN"/"CLOSE". Follow the period nanosecond. Then next item is internal
>priority value means which ingress queue should put. "-1" means
>wildcard. The last value optional specifies the maximum number of
>MSDU octets that are permitted to pass the gate during the specified
>time interval.
>Base-time is not set will be as 0 as default, as result start time would
>be ((N + 1) * cycletime) which is the minimal of future time.
>
>Below example shows filtering a stream with destination mac address is
>10:00:80:00:00:00 and ip type is ICMP, follow the action gate. The gate
>action would run with one close time slot which means always keep close.
>The time cycle is total 200000000ns. The base-time would calculate by:
>
> 1357000000000 + (N + 1) * cycletime
>
>When the total value is the future time, it will be the start time.
>The cycletime here would be 200000000ns for this case.
>
>> tc filter add dev eth0 parent ffff:  protocol ip \
>	   flower skip_hw ip_proto icmp dst_mac 10:00:80:00:00:00 \
>	   action gate index 12 base-time 1357000000000 \
>	   sched-entry CLOSE 200000000 -1 -1 \
>	   clockid CLOCK_TAI
>
>NOTE: This software simulator version not separate the admin/operation
>state machine. Update setting would overwrite stop the previos setting
>and waiting new cycle start.
>

[...]


>diff --git a/net/sched/Kconfig b/net/sched/Kconfig
>index bfbefb7bff9d..320471a0a21d 100644
>--- a/net/sched/Kconfig
>+++ b/net/sched/Kconfig
>@@ -981,6 +981,21 @@ config NET_ACT_CT
> 	  To compile this code as a module, choose M here: the
> 	  module will be called act_ct.
> 
>+config NET_ACT_GATE
>+	tristate "Frame gate list control tc action"
>+	depends on NET_CLS_ACT
>+	help
>+	  Say Y here to allow the control the ingress flow by the gate list

"to control"?


>+	  control. The frame policing by the time gate list control open/close

Incomplete sentence.


>+	  cycle time. The manipulation will simulate the IEEE 802.1Qci stream
>+	  gate control behavior. The action could be offload by the tc flower
>+	  to hardware driver which the hardware own the capability of IEEE
>+	  802.1Qci.

We do not mention offload for the other actions. I suggest to not to
mention it here either.


>+
>+	  If unsure, say N.
>+	  To compile this code as a module, choose M here: the
>+	  module will be called act_gate.
>+
> config NET_IFE_SKBMARK
> 	tristate "Support to encoding decoding skb mark on IFE action"
> 	depends on NET_ACT_IFE

[...]
