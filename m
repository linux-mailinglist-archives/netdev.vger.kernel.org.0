Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 475CEBBA43
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 19:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437797AbfIWRSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 13:18:07 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:49058 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393311AbfIWRSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 13:18:07 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 80F8D700070;
        Mon, 23 Sep 2019 17:18:05 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 23 Sep
 2019 10:17:59 -0700
Subject: Re: CONFIG_NET_TC_SKB_EXT
To:     Paul Blakey <paulb@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Pravin Shelar <pshelar@ovn.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@netronome.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
References: <CAADnVQJBxsWU8BddxWDBX==y87ZLoEsBdqq0DqhYD7NyEcDLzg@mail.gmail.com>
 <1569153104-17875-1-git-send-email-paulb@mellanox.com>
 <20190922144715.37f71fbf@cakuba.netronome.com>
 <68c6668c-f316-2ceb-31b0-8197d22990ae@mellanox.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <d6867e6c-2b81-5fcd-1d88-46663bed6e26@solarflare.com>
Date:   Mon, 23 Sep 2019 18:17:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <68c6668c-f316-2ceb-31b0-8197d22990ae@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24928.004
X-TM-AS-Result: No-9.285500-4.000000-10
X-TMASE-MatchedRID: vbSD0OnL8/LmLzc6AOD8DfHkpkyUphL9H5K8yhnQ+F7Lkl8e9W70i6RD
        Y/5zED8rGWtzbrhLRgj/hp1J2K7oH7+Cta6KT8i9BcaL/tyWL2ORAgbvhPsYZnWQkCh22d7hR0h
        OfMhcLSuooFOXe3T87CZCoAd28/HUUf5Pjz8cHCP1MIl9eZdLb+P6p+9mEWlCT7zqZowzdpK6qD
        ODPQL97QfLt7fjttmDsS7038O+zLx4pkAgPeEdVp3bt4XlQMWjAf1C358hdK/VBer5AbO6mzj6q
        uwd84U8kJt/DBitOccT0dgdGmCGjSVYhgUyukZCGUlF/M3Dxp9z5XSaFaJhbG9uoEMoROR6h5cq
        6HoMtLOOYxUPZ+m5WQ4CPFs4fQZiA0thPpAa7ey7B1QwzOcQD+vcTjVWUqx9pQrupClYLxI/5bo
        wgIF6xg1BX3gLkAgZX7bicKxRIU2No+PRbWqfRDsAVzN+Ov/sSkEFhJ9xr2XUN6CjPA/QP97gW7
        6RuO9FkdSEWrGm8Pv4YcR2yeHq0A==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.285500-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24928.004
X-MDID: 1569259086-7oZaThhpnHsL
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/09/2019 17:56, Paul Blakey wrote:
> Even following this approach in tc only is challenging for some 
> scenarios, consider the following tc rules:
>
> tc filter add dev1 ... chain 0 flower <match1> action goto chain 1
> tc filter add dev1 ... chain 0 flower <match2> action goto chain 1
> tc filter add dev1 ... chain 0 flower <match3> action goto chain 1
> ..
> ..
> tc filter add dev1 ... chain 0 flower ip_dst <match1000> action goto chain 1
>
> tc filter add dev1 ... chain 1 flower ip_proto tcp action tunnel_key set dst_ip 8.8.8.8 action mirred egress redirect dev2
This one is easy, if a packet gets to the end of a chain without matching any rules then it just gets delivered to the uplink (PF), and software TC starts over from the beginning of chain 0.  AFAICT this is the natural hardware behaviour for any design of offload, and it's inherently all-or-nothing.

> You'd also have to keep track of what fields were originally on the packet, and not a match resulting from a modifications,
> See the following set of rules:
> tc filter add dev1 ... chain 0 prio 1 flower src_mac <mac1> action pedit munge ex set dst mac <mac2> pipe action goto chain 1
> tc filter add dev1 ... chain 0 prio 2 flower dst_mac <mac2> action goto chain 1
> tc filter add dev1 ... chain 1 prio 1 flower dst_mac <mac3> action <action3>
> tc filter add dev1 ... chain 1 prio 2 flower src_mac <mac1> action <action4>
This one is slightly harder in that you have to either essentially 'gather up' actions as you go and only 'commit' them at the end of your processing pipeline (in which case you have to deal with the data hazard you cleverly included in your example), or keep a copy of the original packet around.  But I don't see the data-hazard case as having any realistic use-cases (does anyone actually put actions other than ct before a goto chain?) and it's easy enough to detect it in SW at rule-insertion time.

FWIW I think the only way this infra will ever be used is: chain 0 rules match <blah> action ct zone <n> goto chain <m>; chain <m> rules match ct_state +xyz <blah> action <actually do stuff to packet>.  This can be supported with a hardware pipeline with three tables in series in a fairly natural way — and since all the actions that modify the packet (rather than just directing subsequent matching) are at the end, the natural miss behaviour is deliver-unmodified.

I tried to explain this back on your [v3] net: openvswitch: Set OvS recirc_id from tc chain index, but you seemed set on your approach so I didn't persist.  Now it looks like maybe I should have...
