Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B57B4D4E3D
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 17:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238150AbiCJQMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 11:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240918AbiCJQMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 11:12:38 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD5B18FADE;
        Thu, 10 Mar 2022 08:11:36 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id u7so8374139ljk.13;
        Thu, 10 Mar 2022 08:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=MufqSeq1797sybWvUzWNxRr994dS4snnHebtCwEvGkc=;
        b=KEe6AxjRiWmjW2zWTlqRE6chQO2F6bM5QvsiaMTXb+ecJqncaZ1LoXq8uSuItiF9CO
         9yypsn12ZliRCAiv1iSz+hiwDgiaUpecJe2TdXnbzCq4M0HMdEBNFzQCOVu9aCMsHWDr
         5PeFazRqxwCxZ4L33LZ5DQLA7ibqFPvSfehLdip75G98h6yN6Qb79BCl6amv4rUMdsEu
         Jqm0Lpw5sf0ydnLrEn4N/y8/zuoIzOW8f+bPhfAS9Op/lk2Gg6mdFB4GJW9C5psY4UDE
         WlduR/etXca9IHj4lMsjtVHsjGkaJonMPUoCf4nsl60H+1e4FYURFKGcu/yYGMe/egkJ
         JQpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=MufqSeq1797sybWvUzWNxRr994dS4snnHebtCwEvGkc=;
        b=OFYBP1rNsDBIL6uZYOuYr4DwMHMcK4vQVhdx5zzVbSb1i5lSHzFHf+xZyc5sHJpbWd
         jK3SjZIwABZ5h3hFkN3R0mFhuIApmEbKe/PXKm9SFU0e3dHQk5Iu63D0uKG/HugdhZWx
         g9Tox0Wi4FLTiEpKvoDSxh8Ecn0C6g8vEg/iOmNxQJr980jpgK/DKIjEQCK26JXJoJj4
         AMrdtoTALFpQ41YhYAIBG/ty3afQX29MzIFsglWVIqszMIR7BAQ1dDO2t6t1lKE3u9ry
         ppL0XXSTuKrDWSmFNzAF1k365k7k1vJl6byhJuvhdk+TZUefT9GhyAEmsPhoHakpKXCY
         Xmvw==
X-Gm-Message-State: AOAM533NC/bcLhAe1uJpfeiz+GhdUEe2gnCKMLMEoB+xyhQawQ4oxiEK
        ZRcRKEQE/wyMoxQwbajOK3o=
X-Google-Smtp-Source: ABdhPJwEX/eT9ZIBI5InToY7N6YUdowzsxBWHG30YIoiV8oRMa44Mw5tvmp3KNx91X1uJrOZ2ntiBg==
X-Received: by 2002:a2e:3318:0:b0:246:392b:d092 with SMTP id d24-20020a2e3318000000b00246392bd092mr3311746ljc.173.1646928694937;
        Thu, 10 Mar 2022 08:11:34 -0800 (PST)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id f11-20020a05651c02cb00b00244bd3dd6bdsm1134260ljo.5.2022.03.10.08.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 08:11:34 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 1/3] net: bridge: add fdb flag to extent locked
 port feature
In-Reply-To: <e3f57a64-4823-7cf3-0345-3777c44c2fe4@blackwall.org>
References: <20220310142320.611738-1-schultz.hans+netdev@gmail.com>
 <20220310142320.611738-2-schultz.hans+netdev@gmail.com>
 <0eeaf59f-e7eb-7439-3c0a-17e7ac6741f0@blackwall.org>
 <86v8wles1g.fsf@gmail.com>
 <e3f57a64-4823-7cf3-0345-3777c44c2fe4@blackwall.org>
Date:   Thu, 10 Mar 2022 17:11:32 +0100
Message-ID: <8635jp23ez.fsf@gmail.com>
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

On tor, mar 10, 2022 at 17:57, Nikolay Aleksandrov <razor@blackwall.org> wrote:
> On 10/03/2022 17:38, Hans Schultz wrote:
>> On tor, mar 10, 2022 at 16:42, Nikolay Aleksandrov <razor@blackwall.org> wrote:
>>> On 10/03/2022 16:23, Hans Schultz wrote:
>>>> Add an intermediate state for clients behind a locked port to allow for
>>>> possible opening of the port for said clients. This feature corresponds
>>>> to the Mac-Auth and MAC Authentication Bypass (MAB) named features. The
>>>> latter defined by Cisco.
>>>>
>>>> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
>>>> ---
>>>>    include/uapi/linux/neighbour.h |  1 +
>>>>    net/bridge/br_fdb.c            |  6 ++++++
>>>>    net/bridge/br_input.c          | 11 ++++++++++-
>>>>    net/bridge/br_private.h        |  3 ++-
>>>>    4 files changed, 19 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
>>>> index db05fb55055e..83115a592d58 100644
>>>> --- a/include/uapi/linux/neighbour.h
>>>> +++ b/include/uapi/linux/neighbour.h
>>>> @@ -208,6 +208,7 @@ enum {
>>>>    	NFEA_UNSPEC,
>>>>    	NFEA_ACTIVITY_NOTIFY,
>>>>    	NFEA_DONT_REFRESH,
>>>> +	NFEA_LOCKED,
>>>>    	__NFEA_MAX
>>>>    };
>>>
>>> Hmm, can you use NDA_FLAGS_EXT instead ?
>>> That should simplify things and reduce the nl size.
>>>
>> 
>> I am using NDA_FDB_EXT_ATTRS. NFEA_LOCKED is just the
>> flag as the other flags section is full wrt the normal flags, but maybe it
>> doesn't fit in that section?
>> 
>
> Actually wait a second, this is completely wrong use of NDA_FDB_EXT_ATTRS.
> That is a nested attribute, so the code below is wrong. More below..
>
>> I will just note that iproute2 support for parsing nested attributes
>> does not work, thus the BR_FDB_NOTIFY section (lines 150-165) are
>> obsolete with respect to iproute2 as it is now. I cannot rule out that
>> someone has some other tool that can handle this BR_FDB_NOTIFY, but I
>> could not make iproute2 as it stands handle nested attributes. And of
>> course there is no handling of NDA_FDB_EXT_ATTRS in iproute2 now.
>> >>>    #define NFEA_MAX (__NFEA_MAX - 1)
>>>> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
>>>> index 6ccda68bd473..396dcf3084cf 100644
>>>> --- a/net/bridge/br_fdb.c
>>>> +++ b/net/bridge/br_fdb.c
>>>> @@ -105,6 +105,7 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
>>>>    	struct nda_cacheinfo ci;
>>>>    	struct nlmsghdr *nlh;
>>>>    	struct ndmsg *ndm;
>>>> +	u8 ext_flags = 0;
>>>>    
>>>>    	nlh = nlmsg_put(skb, portid, seq, type, sizeof(*ndm), flags);
>>>>    	if (nlh == NULL)
>>>> @@ -125,11 +126,16 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
>>>>    		ndm->ndm_flags |= NTF_EXT_LEARNED;
>>>>    	if (test_bit(BR_FDB_STICKY, &fdb->flags))
>>>>    		ndm->ndm_flags |= NTF_STICKY;
>>>> +	if (test_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags))
>>>> +		ext_flags |= 1 << NFEA_LOCKED;
>>>>    
>>>>    	if (nla_put(skb, NDA_LLADDR, ETH_ALEN, &fdb->key.addr))
>>>>    		goto nla_put_failure;
>>>>    	if (nla_put_u32(skb, NDA_MASTER, br->dev->ifindex))
>>>>    		goto nla_put_failure;
>>>> +	if (nla_put_u8(skb, NDA_FDB_EXT_ATTRS, ext_flags))
>>>> +		goto nla_put_failure;
>>>> +
>
> This is wrong. NDA_FDB_EXT_ATTRS is a nested attribute, you can't use it as a u8.
> You need to have this structure:
>   [ NDA_FDB_EXT_ATTRS ]
>    ` [ NFEA_LOCKED ]
>
> But that's why I asked if you could use the NDA_FLAGS_EXT attribute. You can see
> the logic from the neigh code.

Ahh yes, NDA_FLAGS_EXT was not there in the 5.15.x kernel I have
originally being making the patches in.

I hope that the handling of nested attributes has been fixed in
iproute2. ;-)

>
> Also note that you need to account for the new attribute's size in fdb_nlmsg_size().
>
>
>>>>    	ci.ndm_used	 = jiffies_to_clock_t(now - fdb->used);
>>>>    	ci.ndm_confirmed = 0;
>>>>    	ci.ndm_updated	 = jiffies_to_clock_t(now - fdb->updated);
>>>> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
>>>> index e0c13fcc50ed..897908484b18 100644
>>>> --- a/net/bridge/br_input.c
>>>> +++ b/net/bridge/br_input.c
>>>> @@ -75,6 +75,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>>>    	struct net_bridge_mcast *brmctx;
>>>>    	struct net_bridge_vlan *vlan;
>>>>    	struct net_bridge *br;
>>>> +	unsigned long flags = 0;
>>>
>>> Please move this below...
>>>
>>>>    	u16 vid = 0;
>>>>    	u8 state;
>>>>    
>>>> @@ -94,8 +95,16 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>>>    			br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
>>>>    
>>>>    		if (!fdb_src || READ_ONCE(fdb_src->dst) != p ||
>>>> -		    test_bit(BR_FDB_LOCAL, &fdb_src->flags))
>>>> +		    test_bit(BR_FDB_LOCAL, &fdb_src->flags)) {
>>>> +			if (!fdb_src) {
>>>
>>> ... here where it's only used.
>>>
>> 
>> Forgot that one. Shall do!
>> 
>>>> +				set_bit(BR_FDB_ENTRY_LOCKED, &flags);
>>>> +				br_fdb_update(br, p, eth_hdr(skb)->h_source, vid, flags);
>>>> +			}
>>>>    			goto drop;
>>>> +		} else {
>>>> +			if (test_bit(BR_FDB_ENTRY_LOCKED, &fdb_src->flags))
>>>> +				goto drop;
>>>> +		}
>>>>    	}
>>>>    
>>>>    	nbp_switchdev_frame_mark(p, skb);
>>>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
>>>> index 48bc61ebc211..f5a0b68c4857 100644
>>>> --- a/net/bridge/br_private.h
>>>> +++ b/net/bridge/br_private.h
>>>> @@ -248,7 +248,8 @@ enum {
>>>>    	BR_FDB_ADDED_BY_EXT_LEARN,
>>>>    	BR_FDB_OFFLOADED,
>>>>    	BR_FDB_NOTIFY,
>>>> -	BR_FDB_NOTIFY_INACTIVE
>>>> +	BR_FDB_NOTIFY_INACTIVE,
>>>> +	BR_FDB_ENTRY_LOCKED,
>>>>    };
>>>>    
>>>>    struct net_bridge_fdb_key {
