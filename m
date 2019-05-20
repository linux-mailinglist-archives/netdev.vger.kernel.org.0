Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC77223FBC
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 19:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfETR6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 13:58:10 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:33848 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726566AbfETR6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 13:58:10 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 72EE5B8010C;
        Mon, 20 May 2019 17:58:08 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 20 May
 2019 10:58:04 -0700
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
Message-ID: <4a88d3a1-88ff-6e8a-c045-b8ee56e2b66b@solarflare.com>
Date:   Mon, 20 May 2019 18:58:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <b4b5e1e7-ebef-5d20-67b6-a3324e886942@mojatatu.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24624.005
X-TM-AS-Result: No-13.203800-4.000000-10
X-TMASE-MatchedRID: hls5oAVArl/mLzc6AOD8DfHkpkyUphL9g99C97sXB8AJXdJay2PKJGbQ
        ECMuGYlEOUYNXsr1n12ynap/7V6e/yrHfI6PZrYiPwKTD1v8YV4IGOyj879VyH16C7GFcvkydX2
        C72KhwI1oxPRxGsO943Jwq0+RcaAHCJci3xZfAmcjCTunWqnclofQ3g3I7jVbkaEC8FJraL/UZZ
        so3zLrry7L53atdQGS15pRb9r3LBPtODNJU+fn6u1rOTqE/7ITrYIJqyGcXHWiaaypnafKT/H+E
        rZATmt+XtOUALFmDFLhJSQgZSPD5L9ZdlL8eonaVnRXm1iHN1bEQdG7H66TyF82MXkEdQ77MkWh
        9vfukz9YplaPWgg4ij5LVnQb6+Htm718JDiE69nrpON2y0tpKQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--13.203800-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24624.005
X-MDID: 1558375089-c3qVeLTjBzyX
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/05/2019 17:29, Jamal Hadi Salim wrote:
> On 2019-05-20 12:10 p.m., Edward Cree wrote:
>> # tc filter del dev $vfrep parent ffff: pref 49151
>> # tc -stats filter show dev $vfrep parent ffff:
>> filter protocol arp pref 49152 flower chain 0
>> filter protocol arp pref 49152 flower chain 0 handle 0x1
>>    eth_type arp
>>    skip_sw
>>    in_hw in_hw_count 1
>>          action order 1: vlan  push id 100 protocol 802.1Q priority 0 pipe
>>           index 1 ref 1 bind 1 installed 180 sec used 180 sec
>>          Action statistics:
>>          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>>          backlog 0b 0p requeues 0
>>
>>          action order 2: mirred (Egress Mirror to device $pf) pipe
>>          index 101 ref 1 bind 1 installed 180 sec used 169 sec
>>          Action statistics:
>>          Sent 256 bytes 4 pkt (dropped 0, overlimits 0 requeues 0)
>>          Sent software 0 bytes 0 pkt
>>          Sent hardware 256 bytes 4 pkt
>>          backlog 0b 0p requeues 0
>>
>>          action order 3: vlan  pop pipe
>>           index 2 ref 1 bind 1 installed 180 sec used 180 sec
>>          Action statistics:
>>          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>>          backlog 0b 0p requeues 0
>>
>> #
>>
>
> Hold on, did you intentionaly add that "protocol arp" there?
Yes; if you go back to my `tc filter add` commands, I had one matching
 'protocol arp' and the other 'protocol ipv4', and the latter is the one
 I then deleted.  I'm not 100% sure why `tc filter show` prints it twice
 ('protocol' and 'eth_type'), though.

>> # tc -s actions get action mirred index 101
>> total acts 0
>>
>>          action order 1: mirred (Egress Mirror to device $pf) pipe
>>          index 101 ref 1 bind 1 installed 796 sec used 785 sec
>>          Action statistics:
>>          Sent 256 bytes 4 pkt (dropped 0, overlimits 0 requeues 0)
>>          Sent software 0 bytes 0 pkt
>>          Sent hardware 256 bytes 4 pkt
>>          backlog 0b 0p requeues 0
>> #
>
> Assuming in this case you added by value the actions? Bind and ref
> are 1 each.
Yes, the mirreds were added by value.

> Possible an offload bug that was already in existence. Can you try the
> same steps but without offloading and see if you see the same behavior?
Running with 'skip_hw' instead of 'skip_sw', I *don't* see the same
 behaviour.

-Ed
