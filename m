Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 383B92407F
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 20:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbfETSgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 14:36:43 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:40892 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725909AbfETSgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 14:36:43 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id DFAFFA40092;
        Mon, 20 May 2019 18:36:40 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 20 May
 2019 11:36:36 -0700
Subject: Re: [RFC PATCH v2 net-next 0/3] flow_offload: Re-add per-action
 statistics
To:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <9b137a90-9bfb-9232-b01b-6b6c10286741@solarflare.com>
 <f4fdc1f1-bee2-8456-8daa-fbf65aabe0d4@solarflare.com>
 <cacfe0ec-4a98-b16b-ef30-647b9e50759d@mojatatu.com>
 <f27a6a44-5016-1d17-580c-08682d29a767@solarflare.com>
 <3db2e5bf-4142-de4b-7085-f86a592e2e09@mojatatu.com>
 <17cf3488-6f17-cb59-42a3-6b73f7a0091e@solarflare.com>
 <b4b5e1e7-ebef-5d20-67b6-a3324e886942@mojatatu.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <d70ed72f-69db-dfd0-3c0d-42728dbf45c7@solarflare.com>
Date:   Mon, 20 May 2019 19:36:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <b4b5e1e7-ebef-5d20-67b6-a3324e886942@mojatatu.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24624.005
X-TM-AS-Result: No-10.552800-4.000000-10
X-TMASE-MatchedRID: 8+bhjh9TQnHmLzc6AOD8DfHkpkyUphL9F9s8UTYYetUZSz1vvG+0mpnB
        iGeCTSiBlKHr8Cov1n3jzHPSq+SlEv/E8pKAu+Qt/I86v5Fe2NzpVMb1xnESMmmycYYiBYyZMrJ
        18VCI8ftvO0CgsOaW7b0RJbiXHWT1R/LrKX7ntfCVOwZbcOalSyAeV4oFCpbhIyM6bqaAlyuplt
        /ndMV7yesnjDCnbp2KZKk8ASWMqqQoqtz9efX8KeUEC57Foxt0CBjso/O/Vch9eguxhXL5MnV9g
        u9iocCNaMT0cRrDveNycKtPkXGgBwiXIt8WXwJnIwk7p1qp3JaH0N4NyO41W9up0fEawV9pHjKd
        T/yfRehFleQSA5qYTF+24nCsUSFNjaPj0W1qn0TKayT/BQTiGhvtSXvbrEoCOr8+JhSbeeL/xez
        ZWxtCU1grGYhLG8BJQJzZB+h1gaE=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.552800-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24624.005
X-MDID: 1558377402-0B9DEPfUCSIA
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/05/2019 17:29, Jamal Hadi Salim wrote:
> Maybe dump after each step and it will be easier to see what is
> happening.
>
>> I don't *think* my changes can have caused this, but I'll try a test on a
>>   vanilla kernel just to make sure the same thing happens there.
>
> Possible an offload bug that was already in existence.
I've now reproduced on vanilla net-next (63863ee8e2f6); the breakage occurs
 when I run `tc -s actions get action drop index 104`, even _without_ having
 previously deleted a rule.
And in a correction to my last email, it turns out this *does* reproduce
 without offloading (I evidently didn't hit the right sequence to tickle
 the bug before).

# tc -stats filter show dev $vfrep parent ffff:
filter protocol ip pref 49151 flower chain 0
filter protocol ip pref 49151 flower chain 0 handle 0x1
  eth_type ipv4
  skip_sw
  in_hw in_hw_count 1
        action order 1: vlan  push id 100 protocol 802.1Q priority 0 pipe
         index 3 ref 1 bind 1 installed 7 sec used 7 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0

        action order 2: mirred (Egress Mirror to device $pf) pipe
        index 102 ref 1 bind 1 installed 7 sec used 3 sec
        Action statistics:
        Sent 306 bytes 3 pkt (dropped 0, overlimits 0 requeues 0)
        Sent software 0 bytes 0 pkt
        Sent hardware 306 bytes 3 pkt
        backlog 0b 0p requeues 0

        action order 3: vlan  pop pipe
         index 4 ref 1 bind 1 installed 7 sec used 7 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0

        action order 4: gact action drop
         random type none pass val 0
         index 104 ref 3 bind 2 installed 13 sec used 3 sec
        Action statistics:
        Sent 306 bytes 3 pkt (dropped 3, overlimits 0 requeues 0)
        Sent software 0 bytes 0 pkt
        Sent hardware 306 bytes 3 pkt
        backlog 0b 0p requeues 0

filter protocol arp pref 49152 flower chain 0
filter protocol arp pref 49152 flower chain 0 handle 0x1
  eth_type arp
  skip_sw
  in_hw in_hw_count 1
        action order 1: vlan  push id 100 protocol 802.1Q priority 0 pipe
         index 1 ref 1 bind 1 installed 7 sec used 7 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0

        action order 2: mirred (Egress Mirror to device $pf) pipe
        index 101 ref 1 bind 1 installed 7 sec used 5 sec
        Action statistics:
        Sent 64 bytes 1 pkt (dropped 0, overlimits 0 requeues 0)
        Sent software 0 bytes 0 pkt
        Sent hardware 64 bytes 1 pkt
        backlog 0b 0p requeues 0

        action order 3: vlan  pop pipe
         index 2 ref 1 bind 1 installed 7 sec used 7 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0

        action order 4: gact action drop
         random type none pass val 0
         index 104 ref 3 bind 2 installed 13 sec used 3 sec
        Action statistics:
        Sent 370 bytes 4 pkt (dropped 4, overlimits 0 requeues 0)
        Sent software 0 bytes 0 pkt
        Sent hardware 370 bytes 4 pkt
        backlog 0b 0p requeues 0

# tc -s actions get action drop index 104
total acts 0

        action order 1: gact action drop
         random type none pass val 0
         index 104 ref 3 bind 2 installed 27 sec used 17 sec
        Action statistics:
        Sent 370 bytes 4 pkt (dropped 4, overlimits 0 requeues 0)
        Sent software 0 bytes 0 pkt
        Sent hardware 370 bytes 4 pkt
        backlog 0b 0p requeues 0
# tc -stats filter show dev $vfrep parent ffff:
filter protocol ip pref 49151 flower chain 0
filter protocol ip pref 49151 flower chain 0 handle 0x1
  eth_type ipv4
  skip_sw
  in_hw in_hw_count 1
        action order 1: vlan  push id 100 protocol 802.1Q priority 0 pipe
         index 3 ref 1 bind 1 installed 26 sec used 26 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0

        action order 2: mirred (Egress Mirror to device $pf) pipe
        index 102 ref 1 bind 1 installed 26 sec used 22 sec
        Action statistics:
        Sent 306 bytes 3 pkt (dropped 0, overlimits 0 requeues 0)
        Sent software 0 bytes 0 pkt
        Sent hardware 306 bytes 3 pkt
        backlog 0b 0p requeues 0

        action order 3: vlan  pop pipe
         index 4 ref 1 bind 1 installed 26 sec used 26 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0

filter protocol arp pref 49152 flower chain 0
filter protocol arp pref 49152 flower chain 0 handle 0x1
  eth_type arp
  skip_sw
  in_hw in_hw_count 1
        action order 1: vlan  push id 100 protocol 802.1Q priority 0 pipe
         index 1 ref 1 bind 1 installed 27 sec used 27 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0

        action order 2: mirred (Egress Mirror to device $pf) pipe
        index 101 ref 1 bind 1 installed 27 sec used 17 sec
        Action statistics:
        Sent 256 bytes 4 pkt (dropped 0, overlimits 0 requeues 0)
        Sent software 0 bytes 0 pkt
        Sent hardware 256 bytes 4 pkt
        backlog 0b 0p requeues 0

        action order 3: vlan  pop pipe
         index 2 ref 1 bind 1 installed 27 sec used 27 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0

#
