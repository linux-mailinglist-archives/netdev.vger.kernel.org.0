Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D8B4DA572
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 23:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352266AbiCOWgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 18:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245546AbiCOWgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 18:36:20 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B978E5C856
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 15:35:06 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id g17so908597lfh.2
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 15:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=WG7wAjUqAepF5ItMqejD0JSQeopv4zw5TgTzR3nTVpg=;
        b=08bbh2q2doQ/hf09T5YToBREVzd93tB1dJg+jlIcEZvH3cwaNw0qpNdLWn+A/zuNX8
         Z8fTqKdoh51qK+8sigaTMCHFoQKXa23V9rzd5g25dCU/pIkjrm+AJ5CTBDWo1QNrUglM
         caEA76zCeUAC2BVn4jGOkicaSI+koUtPKQ3dvSte2rHMZxRHo1xXFcwQc0NAfD+TZogS
         AHxG8BJaICXP5JunIZ+6AwE5ayH27QiI4vyOS8RtRDmFq0KgXbIxE7DjMmilTflPy5nX
         8SwX4X02D6zypf6GMr8hknSnnxAZlrQWcZzrLPGlW4BTLaD8+jxfjh3PbvPWLknwNW9v
         bnEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=WG7wAjUqAepF5ItMqejD0JSQeopv4zw5TgTzR3nTVpg=;
        b=c3LGnFUuVllaHZPSHONDQ4BD7pxSYmwjTz+vF6pIToWCDkb+tH70XqfCqjDSga4WSQ
         2svtRmQjAeFXJdMlQ6VNxSnOYpZedrajKtsf94c0RVSIriVYIObFAnDVN26r9qG3uih0
         yRFlSjJqCakWzVrj0kLkcxX2/IdHTW2NR0r+JBoJCT3gcMe6Zlba5oC2uHzjEG3hBfog
         FXw1Arq9XMCogq8U08jV+q9JY7Uq1OjzBnuJWWLtjZgydI6sYguJ+X5iBtEQ3vOa/KlE
         tOfPmwCjEvOXrYcMWTYddakB4CPsJX9tzJPtaTQAIdjda2pkZGKDD1moXD90izIKJPaw
         SsbA==
X-Gm-Message-State: AOAM532QBe3Pl4K+ZjW+0I894vOiGPm3Yl4Y81MNn+XS4jTvm/xnT0xy
        K/my8rv/lpxBDcu/EregKH1SRw==
X-Google-Smtp-Source: ABdhPJwQqGoHou+iDNZj+gXfz4ZxqVT1PcTU4zpn7U0Gnp6jyqD5tE8fL0oUqR7ILv8rSynTGNNDMQ==
X-Received: by 2002:a05:6512:3e0c:b0:448:3480:1fe5 with SMTP id i12-20020a0565123e0c00b0044834801fe5mr17628788lfv.358.1647383704869;
        Tue, 15 Mar 2022 15:35:04 -0700 (PDT)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id s5-20020ac24645000000b00448628b8462sm19133lfo.249.2022.03.15.15.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 15:35:04 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH v4 net-next 03/15] net: bridge: mst: Support setting and
 reporting MST port states
In-Reply-To: <20220315165455.3nakoccbm7c7d2w5@skbuf>
References: <20220315002543.190587-1-tobias@waldekranz.com>
 <20220315002543.190587-4-tobias@waldekranz.com>
 <20220315165455.3nakoccbm7c7d2w5@skbuf>
Date:   Tue, 15 Mar 2022 23:35:03 +0100
Message-ID: <878rtalu94.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 18:54, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Tue, Mar 15, 2022 at 01:25:31AM +0100, Tobias Waldekranz wrote:
>> Make it possible to change the port state in a given MSTI by extending
>> the bridge port netlink interface (RTM_SETLINK on PF_BRIDGE).The
>> proposed iproute2 interface would be:
>> 
>>     bridge mst set dev <PORT> msti <MSTI> state <STATE>
>> 
>> Current states in all applicable MSTIs can also be dumped via a
>> corresponding RTM_GETLINK. The proposed iproute interface looks like
>> this:
>> 
>> $ bridge mst
>> port              msti
>> vb1               0
>> 		    state forwarding
>> 		  100
>> 		    state disabled
>> vb2               0
>> 		    state forwarding
>> 		  100
>> 		    state forwarding
>> 
>> The preexisting per-VLAN states are still valid in the MST
>> mode (although they are read-only), and can be queried as usual if one
>> is interested in knowing a particular VLAN's state without having to
>> care about the VID to MSTI mapping (in this example VLAN 20 and 30 are
>> bound to MSTI 100):
>> 
>> $ bridge -d vlan
>> port              vlan-id
>> vb1               10
>> 		    state forwarding mcast_router 1
>> 		  20
>> 		    state disabled mcast_router 1
>> 		  30
>> 		    state disabled mcast_router 1
>> 		  40
>> 		    state forwarding mcast_router 1
>> vb2               10
>> 		    state forwarding mcast_router 1
>> 		  20
>> 		    state forwarding mcast_router 1
>> 		  30
>> 		    state forwarding mcast_router 1
>> 		  40
>> 		    state forwarding mcast_router 1
>> 
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>> +static int br_mst_process_one(struct net_bridge_port *p,
>> +			      const struct nlattr *attr,
>> +			      struct netlink_ext_ack *extack)
>> +{
>> +	struct nlattr *tb[IFLA_BRIDGE_MST_ENTRY_MAX + 1];
>> +	u16 msti;
>> +	u8 state;
>> +	int err;
>> +
>> +	err = nla_parse_nested(tb, IFLA_BRIDGE_MST_ENTRY_MAX, attr,
>> +			       br_mst_nl_policy, extack);
>> +	if (err)
>> +		return err;
>> +
>> +	if (!tb[IFLA_BRIDGE_MST_ENTRY_MSTI]) {
>> +		NL_SET_ERR_MSG_MOD(extack, "MSTI not specified");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (!tb[IFLA_BRIDGE_MST_ENTRY_STATE]) {
>> +		NL_SET_ERR_MSG_MOD(extack, "State not specified");
>> +		return -EINVAL;
>> +	}
>> +
>> +	msti = nla_get_u16(tb[IFLA_BRIDGE_MST_ENTRY_MSTI]);
>> +	state = nla_get_u8(tb[IFLA_BRIDGE_MST_ENTRY_STATE]);
>> +
>> +	br_mst_set_state(p, msti, state);
>
> Is there any reason why this isn't propagating the error?

No, we definitely should. Thanks.

>> +	return 0;
>> +}
