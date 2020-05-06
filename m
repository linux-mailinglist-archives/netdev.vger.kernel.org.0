Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416381C6EC2
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 12:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgEFKxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 06:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725882AbgEFKxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 06:53:35 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42400C061A0F;
        Wed,  6 May 2020 03:53:34 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id pg17so929161ejb.9;
        Wed, 06 May 2020 03:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0ZCSjwl3dWty6i1/QxOKSEagP/YVG1NrqycYLPOUigA=;
        b=lUdkqNo35GvfXfKpdsgzcHdahvF49WBeIzAnW/FLwSXSHStkhHvht8c4yhMroCBZpo
         xwSr36TCt9j3TzZEVO2JfbyrRqYsSxDiQOVjuJPZb10mlEuOptGJQPOXrUmsxsuKcgQL
         Vd2WLPvfdGxrOzRhCfE9+oNa2snFdoVxvV5g3RvZ3Pq0gFFBvpMAEJET7rfkE7E9G96E
         EJNJ7ScdwPnv3kwzhStT6H57ghplQ+qNZyDUmKtBHCVHB/3l5CJBrNnkAcpj7k0cHO3Q
         4NFI0WVsU7kCzcJyzLxWWsTTyhHrm2wwIr8Jqwran8F+yLIrzZNbMjT6ApfTUGpQkLxq
         2tLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0ZCSjwl3dWty6i1/QxOKSEagP/YVG1NrqycYLPOUigA=;
        b=H3fES/xg4gbRpT7m2H8ugKB6RtTQhMDuMyY42eHv8ee92Mmzl1F6apOSn1HnKHdZxt
         zgCZug2sX+onWhsFvNKYOJy+doZ7DY+LaPzGIiB0j76DMCim427SyKFNGE1z6lOUezOT
         mDu0tQD5yuiqgJKdfwo0YXKgvVLcEjWfB8XuwZ2l6altfcV5yaDa0h8TtmbJ6WSLgzzq
         zFK3UJjI1WYrGOjheJhSIUe1FhvaiTyJ9kzKxV1nfCGAwzHbH0lTo77CNEImdDwwF81J
         YPYMlnGZznsS28fVcclStWOJN4JGZhSrwmFHPHg91TcpmAr0gpk5A9tdXZK23UaPfLoZ
         IYlQ==
X-Gm-Message-State: AGi0PuaZGDn1wufOR1QXaT36tIkBJ/GjlQiTgvw1rpdAIuje8O+SBzSe
        iVA6w9LlwO4zeFsrsKZDc0Ahda7dYWEdyD4JqWQ=
X-Google-Smtp-Source: APiQypIPWhYdWrQxjVUWUwNUJYb+HMj605jznsCxp9aXjQkVAc8Fl1O9qa+CEjoPDEL0eeFJFRwOM5ct0BAZYcy9N6o=
X-Received: by 2002:a17:906:f1d7:: with SMTP id gx23mr6649673ejb.176.1588762412772;
 Wed, 06 May 2020 03:53:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200506074900.28529-1-xiaoliang.yang_1@nxp.com>
 <20200506074900.28529-5-xiaoliang.yang_1@nxp.com> <20200506094345.n4zdgjvctwiz4pkh@ws.localdomain>
In-Reply-To: <20200506094345.n4zdgjvctwiz4pkh@ws.localdomain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 6 May 2020 13:53:21 +0300
Message-ID: <CA+h21hoqJC_CJB=Sg=-JanXw3S_WANgjsfYjU+ffqn6YCDMzrA@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 4/6] net: mscc: ocelot: VCAP IS1 support
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        linux-devel@linux.nxdi.nxp.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Allan,

On Wed, 6 May 2020 at 12:45, Allan W. Nielsen
<allan.nielsen@microchip.com> wrote:
>
> Hi Xiaoliang,
>
> On 06.05.2020 15:48, Xiaoliang Yang wrote:
> >VCAP IS1 is a VCAP module which can filter MAC, IP, VLAN, protocol, and
> >TCP/UDP ports keys, and do Qos and VLAN retag actions.
> >This patch added VCAP IS1 support in ocelot ace driver, which can supports
> >vlan modify action of tc filter.
> >Usage:
> >        tc qdisc add dev swp0 ingress
> >        tc filter add dev swp0 protocol 802.1Q parent ffff: flower \
> >        skip_sw vlan_id 1 vlan_prio 1 action vlan modify id 2 priority 2
> I skimmed skimmed through the patch serie, and the way I understood it
> is that you look at the action, and if it is a VLAN operation, then you
> put it in IS1 and if it is one of the other then put it in IS2.
>
> This is how the HW is designed - I'm aware of that.
>
> But how will this work if you have 2 rules, 1 modifying the VLAN and
> another rule dropping certain packets?
>

At the moment, the driver does not support more than 1 action. We
might need to change that, but we can still install more filters with
the same key and still be fine (see more below). When there is more
than 1 action, the IS1 stuff will be combined into a single rule
programmed into IS1, and the IS2 stuff will be combined into a single
new rule with the same keys installed into VCAP IS2. Would that not
work?

> The SW model have these two rules in the same table, and can stop
> process at the first match. SW will do the action of the first frame
> matching.
>

Actually I think this is an incorrect assumption - software stops at
the first action only if told to do so. Let me copy-paste a text from
a different email thread.

"
Thank you for the good discussion today.
I think the key talking points were:
- How to express with tc filters the fact that some actions are
executed by different hardware pipelines than others (VCAP IS1: vlan
retagging and QoS classification, VCAP IS2: trap, drop, police), and
that those pipelines can be completely independent, as well as chained
via a policy
- How to express the fact that VCAP IS1 can perform up to 3 parallel
lookups (and VCAP IS2 can perform 2 lookups) per frame with
potentially different key types and different actions.

I am trying to take a different (top-down) approach than Allan, which
is to try to express the capabilities that we are interested in
offloading to Ocelot/Felix as software (skip_hw) tc filters first.
It was said during the call that flow classification stops at the
first action that matches a frame, which would prevent us from adding
actions for the VCAP IS1 in the same chain as actions for the VCAP
IS2.

Actually it seems that it is possible to specify to the flow
classifier what to do after each individual action, as can be seen in
the man page of tc-actions
(http://man7.org/linux/man-pages/man8/tc-actions.8.html):

       CONTROL
              The CONTROL indicates how tc should proceed after executing
              the action. Any of the following are valid:

              reclassify
                     Restart the classifiction by jumping back to the first
                     filter attached to the action's parent.

              pipe   Continue with the next action. This is the default
                     control.

              drop   Drop the packed without running any further actions.

              continue
                     Continue the classification with the next filter.

              pass   Return to the calling qdisc for packet processing, and
                     end classification of this packet.

In the above description, it says that "pipe" is the default action
control. My experience does not seem to coincide with that.

I wrote this quick list of software filters:

tc qdisc add dev swp0 clsact
# IS1
tc filter add dev swp0 ingress protocol ip flower skip_hw src_ip
192.168.1.1 hw_tc 5
tc filter add dev swp0 ingress protocol all flower skip_hw action vlan push id 3
tc filter add dev swp0 egress protocol 802.1Q flower skip_hw action vlan pop
# IS2
swp0_mac=$(ip link show dev swp0 | awk '/link\/ether/ {print $2}')
tc filter add dev swp0 ingress protocol all flower skip_hw dst_mac
${swp0_mac} action police rate 37Mbit burst 64k

ip link add link swp0 name swp0.3 type vlan id 3 && ip link set dev swp0.3 up

which would permit me to terminate IP traffic on the swp0.3 VLAN
sub-interface, over which I ran an iperf3 test.

The traffic _was_ successfully rate limited at 37 Mbps, _and_
retagged, but I got a lot of these errors coming from tcf_classify:

[  321.100883] net_ratelimit: 150766 callbacks suppressed
[  321.100896] 0: reclassify loop, rule prio 0, protocol 03
[  321.112613] 0: reclassify loop, rule prio 0, protocol 03
[  321.118625] 0: reclassify loop, rule prio 0, protocol 03
[  321.124575] 0: reclassify loop, rule prio 0, protocol 03
[  321.130566] 0: reclassify loop, rule prio 0, protocol 03
[  321.136630] 0: reclassify loop, rule prio 0, protocol 03
[  321.142610] 0: reclassify loop, rule prio 0, protocol 03
[  321.148603] 0: reclassify loop, rule prio 0, protocol 03
[  321.154625] 0: reclassify loop, rule prio 0, protocol 03
[  321.160569] 0: reclassify loop, rule prio 0, protocol 03

And looking at the rules themselves:

tc -s filter show dev swp0 ingress
filter protocol all pref 49150 flower chain 0
filter protocol all pref 49150 flower chain 0 handle 0x1
  dst_mac 26:cc:e4:73:9f:9b
  skip_hw
  not_in_hw
        action order 1:  police 0x1 rate 37Mbit burst 64Kb mtu 2Kb
action reclassify overhead 0b
        ref 1 bind 1 installed 20 sec used 6 sec
        Action statistics:
        Sent 1994574813 bytes 1351356 pkt (dropped 0, overlimits
1319959 requeues 0)
        backlog 0b 0p requeues 0

filter protocol all pref 49151 flower chain 0
filter protocol all pref 49151 flower chain 0 handle 0x1
  skip_hw
  not_in_hw
        action order 1: vlan  push id 3 protocol 802.1Q priority 0 pipe
         index 1 ref 1 bind 1 installed 20 sec used 0 sec
        Action statistics:
        Sent 1263 bytes 21 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0

filter protocol ip pref 49152 flower chain 0
filter protocol ip pref 49152 flower chain 0 handle 0x1 hw_tc 5
  eth_type ipv4
  src_ip 192.168.1.1
  skip_hw
  not_in_hw

basically the "vlan push" rule matches on way less packets than I was
expecting, and the default control for the police action is to
reclassify, not to pipe. I think this is an odd choice for a default
value, but it looks like I can specify the police rule like this
(using conform-exceed):

tc filter add dev swp0 ingress protocol all flower skip_hw dst_mac
${swp0_mac} action police rate 37Mbit burst 64k conform-exceed
drop/pipe

Basically the idea I want to transmit is that the impression we had
during the call does not seem to hold true. The default action control
is "pipe" (well, it's "almost" default), which has the effect of going
through all rules and not just through the first one that matches
(that would be the "pass" control). So in principle I don't see why we
couldn't model the actions that require VLAN retagging or QoS
classification as lookups in IS1 (ES0 might also need to be involved
in the retagging case, I am not 100% sure how the egress rewriter is
involved in the retagging process, but it seems like it is), and the
actions that require dropping, trapping or policing as lookups in IS2.
I am not sure that chains would be necessary, nor that we could use
them anyway (given that we can't make a chain template based on action
types).

As for the other point (multiple TCAM lookups in the same block), I
think some concrete examples would definitely help.
The example of supporting matches on src_mac and src_ip simultaneously
is a valid one, but it can be dealt with just privately by the driver.
Looking for concrete examples where that would not be enough.

Another item I would like to bring up is how to perform QoS
classification. In my example I used the "hw_tc" action from
tc-flower, but not being offloaded, I couldn't test it. Is this how it
should be done? Is there an equivalent to hw_tc in tc-matchall and in
tc-u32? We might need them there too.
"


> The HW will how-ever do both, as they are in independent TCAMs.
>
> If we want to enable all the TCAM lookups in Ocelot/Felix, then we need
> to find a way where we will get the same results when doing the
> operation in HW and in SW.
>
> /Allan
>

Thanks,
-Vladimir
