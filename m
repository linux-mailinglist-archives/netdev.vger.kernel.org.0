Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9852D4FF428
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 11:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbiDMJyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 05:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiDMJyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 05:54:05 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FB24ECC9
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 02:51:45 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id b21so1509603ljf.4
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 02:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=BuoKK4ZQpOyixi88t54FMVtVUCr5+bIsufKlx4kYhpw=;
        b=QndnMZC+0awTwppISkLvQV3tLtPDwKIPNp1//QeXRe1ypOhSWYZi3KTZPJ37eUeg6E
         6x5X9WkfHdCPw/bd/CIjjLo9+HlPK+E8m9la8g+y7C09Q7Kj7FePXOwQPLzWjBcKnOte
         9ZAqZP4P83uuZy2ThDNRtZq82RAf0aK+fTzifYy/unZk1mM3SLh/vZI7VRJxDwTTD1nn
         Iu84BQzf1s1SymRiW1rJuhkXZ+FxMxew9AVCyUiqz3Vyxjy2RQeCYIcMTS9cdEFKu2gD
         2tJmw1f/H+ioQFv81n+292jQAXDwlU0cJGG98MfD6c7/gY5lJpOvnD9R3i855Cjpfyz5
         MXNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=BuoKK4ZQpOyixi88t54FMVtVUCr5+bIsufKlx4kYhpw=;
        b=VKS6VEVNFgquu5P2yYmTZ6vEBj12AN43L0DXiEqYmwwstJBsGAVmboi8dFJpCmisQ+
         ovjrAfSad/4DBqKA2VgjRS+6Ktc//mtHOe4juCDUU5ZXV2s+67c7ttEpGzdee/jOYFSF
         bq0BJ/HZYMKNvWx61UHDCZ/jqQpQvkKaMunkWZ30qf3eZlN70SxIsz4KizdoikeAtS+v
         NsUv0KIRUgJh0DrwRV2caFyBl2n5RKih2TysJk3InDdoOg6ENqsKSXHikWDuYd+lf2yw
         yEkDroSjBRcOrIp9D0lLUXZ/c0cEGzerT/wvef5KsvjYXG7KAUuNdozdRY21U+Oebjs8
         RbGQ==
X-Gm-Message-State: AOAM533n+OmWYi8SfNG94wzRDsrLykdw93bVmpzJHatT2UPHpkW1laY1
        JJ47OODrn4ithnzW7WuZY9Q=
X-Google-Smtp-Source: ABdhPJxXYe9eW4tJgfG7afZJkmKVxfg7aNOPanbyJAbZusazZz1lE+uShtQ9Lo6K7iseYBxV7e3ygw==
X-Received: by 2002:a2e:bf12:0:b0:249:3a3b:e91a with SMTP id c18-20020a2ebf12000000b002493a3be91amr26316149ljr.343.1649843503171;
        Wed, 13 Apr 2022 02:51:43 -0700 (PDT)
Received: from wbg (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id a3-20020a195f43000000b0044a997dea6bsm4064965lfj.288.2022.04.13.02.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 02:51:42 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH RFC net-next 01/13] net: bridge: add control of bum flooding to bridge itself
In-Reply-To: <99b0790a-9746-ea08-b57e-52c53436666d@blackwall.org>
References: <20220411133837.318876-1-troglobit@gmail.com> <20220411133837.318876-2-troglobit@gmail.com> <99b0790a-9746-ea08-b57e-52c53436666d@blackwall.org>
Date:   Wed, 13 Apr 2022 11:51:42 +0200
Message-ID: <87k0bt9uq9.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 21:27, Nikolay Aleksandrov <razor@blackwall.org> wrote:
> On 11/04/2022 16:38, Joachim Wiberg wrote:
>> @@ -526,6 +526,10 @@ void br_dev_setup(struct net_device *dev)
>>  	br->bridge_ageing_time = br->ageing_time = BR_DEFAULT_AGEING_TIME;
>>  	dev->max_mtu = ETH_MAX_MTU;
>> +	br_opt_toggle(br, BROPT_UNICAST_FLOOD, 1);
> This one must be false by default. It changes current default behaviour.
> Unknown unicast is not currently passed up to the bridge if the port is
> not in promisc mode, this will change it. You'll have to make it consistent
> with promisc (e.g. one way would be for promisc always to enable unicast flood
> and it won't be possible to be disabled while promisc).

Ouch, my bad!  Will look into how to let this have as little impact as
possible.  I like your semantics there, promisc should always win.

>> +	br_opt_toggle(br, BROPT_MCAST_FLOOD, 1);
>> +	br_opt_toggle(br, BROPT_BCAST_FLOOD, 1);
>
> s/1/true/ for consistency

Of course, thanks!

>> @@ -118,7 +118,8 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>  		/* by definition the broadcast is also a multicast address */
>>  		if (is_broadcast_ether_addr(eth_hdr(skb)->h_dest)) {
>>  			pkt_type = BR_PKT_BROADCAST;
>> -			local_rcv = true;
>> +			if (br_opt_get(br, BROPT_BCAST_FLOOD))
>> +				local_rcv = true;
>>  		} else {
>>  			pkt_type = BR_PKT_MULTICAST;
>>  			if (br_multicast_rcv(&brmctx, &pmctx, vlan, skb, vid))
>> @@ -161,12 +162,16 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>  			}
>>  			mcast_hit = true;
>>  		} else {
>> -			local_rcv = true;
>> -			br->dev->stats.multicast++;
>> +			if (br_opt_get(br, BROPT_MCAST_FLOOD)) {
>> +				local_rcv = true;
>> +				br->dev->stats.multicast++;
>> +			}
>>  		}
>>  		break;
>>  	case BR_PKT_UNICAST:
>>  		dst = br_fdb_find_rcu(br, eth_hdr(skb)->h_dest, vid);
>> +		if (!dst && br_opt_get(br, BROPT_UNICAST_FLOOD))
>> +			local_rcv = true;
>>  		break;
>
> This adds new tests for all fast paths for host traffic, especially
> the port - port communication which is the most critical one.  Please
> at least move the unicast test to the "else" block of "if (dst)"
> later.

OK, will fix!

> The other tests can be moved to host only code too, but would require
> bigger changes.  Please try to keep the impact on the fast-path at
> minimum.

Interesting, you mean by speculatively setting local_rcv = true and
postpone the decsion to br_pass_frame_up(), right?  Yeah that would
indeed be a bit more work.
