Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9C84D8862
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 16:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242690AbiCNPnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 11:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236618AbiCNPnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 11:43:15 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF99745056
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 08:42:04 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id c15so5920269ljr.9
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 08:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=+7QYUGPUJGV7sAchppxshMOtZinPJnPqBas5RxkhQiA=;
        b=JBs6VYGA92rPbFqrd6OxMJkb4R8GLOe+Xpwa5oFbRmVd82ki7mxCsJWIBzPm+JULZh
         9B0lLCPVeGKpryB9BI+w5qKvmrzH2YA7wvAUEZqLGZMj+Jg9c4AcrGninr0PWy55NywR
         5xjZXsTsP2Th+S3Ff31kLVt190cEwtZbOTJN9y92RW7OrX+FqaeA7U7JNa8IK4Fje0hS
         0tn3lIHEDsO8TDQOxr/95Ps+dXmFShPpMYXBuVsQD4NSC/l2KfdliVs6vsNdj676nCxd
         UwnIpZnn+arFt5WnzRSKXrA7i697mjWJXs5+Pg+x0RI2lYrGKbDbQ7bBV2oaHD9wXdVN
         7I4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=+7QYUGPUJGV7sAchppxshMOtZinPJnPqBas5RxkhQiA=;
        b=1q8X/TnU/2KBzwxjZ7ll5FKGO3MS6DZoCWsNh0UoinDkvM/7qROfdBbbQ9RThWZpL3
         GeBlnTF5oa9it1fnpIFP+9Y45ncKP74PrhxKbv7WIFgGNUnaxcDnUy2gmlMVf4CmNUVE
         ygC41CxGxwnSqDzR7xxM+I5Iy68n9CHJx0BdZGo/ItLWKlIzmzhWuauI1BIXPz1vXGMo
         SDux611HZMtXTIvKTCrUerB2eshflp/6RoBeamP3BQXnakx0kmHgXGTqFhmhfDeJINGf
         J6ZqWs6w7NjubderI1ezbNVmoR4gQss+Ft89MIiU6LbT3UPrwoUZ1OcNBZPeGt9c0jJ5
         NUbA==
X-Gm-Message-State: AOAM5338gq5QwtSGszJn7JjM0rNkZ+jNhuhaJYAMyFo/2nhxYre8I9WU
        QsWFkb6O1JUPyrvhZfA8uOv/2A==
X-Google-Smtp-Source: ABdhPJxepvXdRnAvXL8qHIRPk5CjrHrMRqu3MnQUMPxTSbMYzgNmCBRal44+PHcVkvnim5xaB191Tw==
X-Received: by 2002:a05:651c:b10:b0:247:f37f:f595 with SMTP id b16-20020a05651c0b1000b00247f37ff595mr14431028ljr.444.1647272523106;
        Mon, 14 Mar 2022 08:42:03 -0700 (PDT)
Received: from wkz-x280 (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id u16-20020a056512129000b00448872b44afsm1419319lfs.29.2022.03.14.08.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 08:42:02 -0700 (PDT)
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
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v3 net-next 03/14] net: bridge: mst: Support setting and
 reporting MST port states
In-Reply-To: <20220314145854.shtnvetounjfnu4e@skbuf>
References: <20220314095231.3486931-1-tobias@waldekranz.com>
 <20220314095231.3486931-4-tobias@waldekranz.com>
 <20220314145854.shtnvetounjfnu4e@skbuf>
Date:   Mon, 14 Mar 2022 16:42:01 +0100
Message-ID: <87y21clewm.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 16:58, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Mar 14, 2022 at 10:52:20AM +0100, Tobias Waldekranz wrote:
>> +int br_mst_fill_info(struct sk_buff *skb, struct net_bridge_vlan_group *vg)
>> +{
>> +	struct net_bridge_vlan *v;
>> +	struct nlattr *nest;
>> +	unsigned long *seen;
>> +	int err = 0;
>> +
>> +	seen = bitmap_zalloc(VLAN_N_VID, 0);
>
> I see there is precedent in the bridge driver for using dynamic
> allocation as opposed to on-stack declaration using DECLARE_BITMAP().
> I imagine this isn't just to be "heapsters", but why?
>
> I don't have a very good sense of how much on-stack memory is too much
> (a lot probably depends on the expected depth of the call stack too, and here it
> doesn't appear to be too deep), but I see that mlxsw_sp_bridge_vxlan_vlan_is_valid()
> has a DECLARE_BITMAP(vlans, VLAN_N_VID) too.
>
> The comment applies for callers of br_mst_get_info() too.

In v4, things become even worse, as I need to allocate the bitmap in a
context where I can't return an error. So if it's ok to keep it on the
stack, then that would be great.

Here's the code in question:

size_t br_mst_info_size(const struct net_bridge_vlan_group *vg)
{
	const struct net_bridge_vlan *v;
	unsigned long *seen;
	size_t sz;

	seen = bitmap_zalloc(VLAN_N_VID, 0);
	if (WARN_ON(!seen))
		return 0;

	/* IFLA_BRIDGE_MST */
	sz = nla_total_size(0);

	list_for_each_entry(v, &vg->vlan_list, vlist) {
		if (test_bit(v->brvlan->msti, seen))
			continue;

		/* IFLA_BRIDGE_MST_ENTRY */
		sz += nla_total_size(0) +
			/* IFLA_BRIDGE_MST_ENTRY_MSTI */
			nla_total_size(sizeof(u16)) +
			/* IFLA_BRIDGE_MST_ENTRY_STATE */
			nla_total_size(sizeof(u8));

		__set_bit(v->brvlan->msti, seen);
	}

	kfree(seen);
	return sz;
}
