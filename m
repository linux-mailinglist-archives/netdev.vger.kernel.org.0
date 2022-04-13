Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526184FF462
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbiDMKGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiDMKGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:06:33 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A0657158
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:04:12 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 15so1524430ljw.8
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=b0Q7eIUJvll8Zc2Wicyz8swgbwUiW9Yb1yMGEPB9veY=;
        b=iVn8i3xa3MWY4ELY/Y28Hb05tecqhBRCBGWJu520Pj6jhRfitI1VWQDEr/x1hVnQoo
         r82cbejX0ajDHqpPKanbUIRK9Y99VmAZ/c604Fn2slcSotYfqkHYi7DrTpCCDZOpO4Cf
         ovVRF2EC45La2qlHJz3b44nNP70nL+fARxZEuMmr2BBMjCBa4pKuGdnOWzd77Zj6FUXf
         MlemZs+QugZFfhqxnl7vp6nLdl5zClsiMomEFZ+LQWJ8g/fUbiI1Y6CBaJPltBYv5ebD
         Ebe3d8jGsHGfpQbWi/zugGzz44Vp6IcwgQXiIHewvvPIbXqNHdDJP/0GCvojTSBPrfiZ
         Q0ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=b0Q7eIUJvll8Zc2Wicyz8swgbwUiW9Yb1yMGEPB9veY=;
        b=DAfSsM4bKLazez+Zor1Klou2dw4MWPgkgU00wNN+YMsNkmbYjhnlGgohChEmVo0nE4
         qMcpk6UBeFm8nzmMe4sTOQXBGNeeNWNBH5wlHDZe2gOiudCDOxlgdbALPTIdmB1xytLE
         eJT7gHEZXt+StfzOnTd22vMVx5SYzGCnuRzOxIM74BeU3fzaiXSpWi4/Sag83Q2scHDP
         E1hkZksqhVOg1Eoz0ZjGO994ufHh6KmWqi0pwh1eO+8U4dhDCUlp8PZMxsBXbDoJx+Uu
         JJXmmbUCvbrUDGwUwc0hsB59SSunv2OFgRinBWG2BkZituAovErrkYoJg/1ohJcHJ0yO
         5JQA==
X-Gm-Message-State: AOAM530PchQ3DTMbukBB4NdB5Q+nBQnmdBSyrYrhC9qahnKAZDoOdWIm
        kQb3zYiAya2IY9LFz+Vo17nZ1mEiqV1HZA==
X-Google-Smtp-Source: ABdhPJySOaL1TZPpUvtuv7iJQK2poQ+YbxG4EK8Qp95psxA4pxIqNxKUdfMAPy8Rhqa3cOG4/YtNeg==
X-Received: by 2002:a05:651c:90b:b0:24c:7dee:4087 with SMTP id e11-20020a05651c090b00b0024c7dee4087mr3372228ljq.381.1649844250789;
        Wed, 13 Apr 2022 03:04:10 -0700 (PDT)
Received: from wbg (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id q12-20020a196e4c000000b0046ba44bec79sm1183094lfk.133.2022.04.13.03.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 03:04:10 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH RFC net-next 04/13] net: bridge: netlink support for controlling BUM flooding to bridge
In-Reply-To: <37bb2846-6371-1e49-9a7e-7c27a7a8b9c4@blackwall.org>
References: <20220411133837.318876-1-troglobit@gmail.com> <20220411133837.318876-5-troglobit@gmail.com> <37bb2846-6371-1e49-9a7e-7c27a7a8b9c4@blackwall.org>
Date:   Wed, 13 Apr 2022 12:04:09 +0200
Message-ID: <87h76x9u5i.fsf@gmail.com>
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

On Tue, Apr 12, 2022 at 21:24, Nikolay Aleksandrov <razor@blackwall.org> wrote:
> On 11/04/2022 16:38, Joachim Wiberg wrote:
>> The messy part is in br_setport(), which re-indents a large block of
>> code for the port settings.  To reduce code duplication a few new
>> variables have been added; new_flags and dev.  The latter is used for
>> the recently renamed br_switchdev_set_dev_flag(), which can now be used
>> by underlying switching fabric drivers as another source of information
>> when controlling flooding of unknown BUM traffic to the CPU port.
> Absolutely not. This is just wrong on a few levels and way too hacky.
> Please separate the bridge handling altogether and make it clean.
> No need to integrate it with the port handling,

OK, I'll have a go at it.

> also I think you've missed a few things about bool options, more
> below...
>
> For boolopts examples you can check BR_BOOLOPT_NO_LL_LEARN,
> BR_BOOLOPT_MCAST_VLAN_SNOOPING and BR_BOOLOPT_MST_ENABLE.

Ah yes, will read up on those, thanks!

>> +		if (nla_put_u8(skb, IFLA_BRPORT_UNICAST_FLOOD,
>> +			       br_opt_get(br, BROPT_UNICAST_FLOOD)) ||
>> +		    nla_put_u8(skb, IFLA_BRPORT_MCAST_FLOOD,
>> +			       br_opt_get(br, BROPT_MCAST_FLOOD)) ||
>> +		    nla_put_u8(skb, IFLA_BRPORT_BCAST_FLOOD,
>> +			       br_opt_get(br, BROPT_BCAST_FLOOD)))
>> +			return -EMSGSIZE;
> No. Bool opts are already exposed through IFLA_BR_MULTI_BOOLOPT.

Aha, there it is, awesome!

>> +static void br_set_bropt(struct net_bridge *br, struct nlattr *tb[],
>> +			 int attrtype, enum net_bridge_opts opt)
>> +{
>> +	if (!tb[attrtype])
>> +		return;
>> +
>> +	br_opt_toggle(br, opt, !!nla_get_u8(tb[attrtype]));
>> +}
> These must be controlled via the boolopt api and attributes, not through
> additional nl attributes.

Understood.

>> @@ -1058,9 +1144,9 @@ int br_setlink(struct net_device *dev, struct nlmsghdr *nlh, u16 flags,
>>  				return err;
>>  
>>  			spin_lock_bh(&br->lock);
>> -			err = br_setport(p, tb, extack);
>> +			err = br_setport(br, p, tb, extack);
> setport is for *port* only...

A-firm.

Thank you for the honest review.  Netlink is still much of a mystery in
many ways to me.

Best regards
 /Joachim
