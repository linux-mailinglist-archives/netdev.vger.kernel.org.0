Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A1B4D3597
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236592AbiCIRLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236588AbiCIRLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:11:00 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AFF38794;
        Wed,  9 Mar 2022 09:03:54 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id c25so1570955edj.13;
        Wed, 09 Mar 2022 09:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k141GwidNXRjahdS4nq6wClv46C5Je0axvt+W5lVMQk=;
        b=PdiEj+1Aa51J+awk55tE9/R3W0LIoQGtcEoKk9RtW5aNNQqg24erRB0bCZXjETVH+H
         NXhO1TaxSzmwuzxfs2+bIzZHdfGWKO6NLXGZjEOKiVDbB24HEUbAObdXvHvyt+7P0Nxj
         ufe+DHxvaGvH/P1e6uBxVTDUaryB7BnJV9ie1kmBDJAr3kwHftc7MOWcgP2pMq2FgSPA
         UEtNdjoZOxFTqcXMRlaHsr+2WEhhvpP/qKyAw+no8NrN+DjhLdaB9ZfyNlICJGqIvn3O
         YwdFkGTH6q9R4kMZs4hIhrCCgJ4u/x+EWIZMx+jPC4LsHrHsqBpRxuSqotPjhah/GN9o
         LRdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k141GwidNXRjahdS4nq6wClv46C5Je0axvt+W5lVMQk=;
        b=OHEXsCVwMGm1SXfFgeRn2f0hHHHae/2uRb3w4HqLB318aNBJ6fs+LQcJBAYasWA3KD
         ON5J11sBkrqZBf7pAE3DkYur1LUrANtm246Jdd5MXlao4P4l9NHsIcOBGjDj0Qzq+lpS
         mEhJXyIM8f5YyAE18xSPkfnxyhsDOsJEZ5jC/db7siNPxdX9Y22tfecRgdRxLNRtKArL
         EGzC3Yqi8yBUXh5cAUQA2Qn3ETj1pnTW7oAf/ymj3TAgZU7TBTQ/wzkVTavoihef5aNh
         ynLaSaDvETcQqEllqjhNkWg5WEFgqRufIAYSuIsGZm67PdKFz91IQ1K2xu7qadNwD7j5
         jeGQ==
X-Gm-Message-State: AOAM530T2HBKB/sjYsuyfOjZOYzlEP+9qbV9tAjU4FtXmrhPFLHAo392
        jyxjZUFDM926v4VK1M6o/8o=
X-Google-Smtp-Source: ABdhPJzH1n/dW6F/FfDqnkYKpsgEVC3b/FyC5pynSjuvTOkiGMKVlb6ljXIZfTPGC9OhdXoe4m5d1w==
X-Received: by 2002:aa7:c6d7:0:b0:415:a0fc:1dcd with SMTP id b23-20020aa7c6d7000000b00415a0fc1dcdmr432777eds.266.1646845432914;
        Wed, 09 Mar 2022 09:03:52 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id yy18-20020a170906dc1200b006d6e5c75029sm913693ejb.187.2022.03.09.09.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 09:03:52 -0800 (PST)
Date:   Wed, 9 Mar 2022 19:03:50 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v2 net-next 06/10] net: dsa: Pass VLAN MSTI migration
 notifications to driver
Message-ID: <20220309170350.fzp3d6jjpiskdhqv@skbuf>
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301100321.951175-7-tobias@waldekranz.com>
 <20220303222942.dkz7bfuagkv7hbpp@skbuf>
 <87pmmvm8ll.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pmmvm8ll.fsf@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 09, 2022 at 04:47:02PM +0100, Tobias Waldekranz wrote:
> >> +int dsa_port_vlan_msti(struct dsa_port *dp, const struct switchdev_attr *attr)
> >> +{
> >> +	struct dsa_switch *ds = dp->ds;
> >> +
> >> +	if (!ds->ops->vlan_msti_set)
> >> +		return -EOPNOTSUPP;
> >> +
> >> +	return ds->ops->vlan_msti_set(ds, attr);
> >
> > I guess this doesn't need to be a cross-chip notifier event for all
> > switches, because replication to all bridge ports is handled by
> > switchdev_handle_port_attr_set(). Ok. But isn't it called too many times
> > per switch?
> 
> It is certainly called more times than necessary. But I'm not aware of
> any way to limit it. Just as with other bridge-global settings like
> ageing timeout, the bridge will just replicate the event to each port,
> not knowing whether some of them belong to the same underlying ASIC or
> not.
> 
> We could leverage hwdoms in the bridge to figure that out, but then:

Hmm, uncalled for. Also, not sure how it helps (it just plain doesn't
work, as you've pointed out below yourself).

> 
> - Drivers that do not implement forward offloading would miss out on
>   this optimization. Unfortunate but not a big deal.
> - Since DSA presents multi-chip trees as a single switchdev, the DSA
>   layer would have to replicate the event out to each device. Doable,
>   but feels like a series of its own.

I've mentally walked through the alternatives and I don't see a practical
alternative than letting the driver cut out the duplicate calls.

Maybe it's worth raising awareness by adding a comment above the
dsa_switch_ops :: vlan_msti_set definition that drivers should be
prepared to handle such calls.

Case in point, in mv88e6xxx_vlan_msti_set() you could avoid some useless
MDIO transactions (a call to mv88e6xxx_vtu_loadpurge) with a simple
"if (vlan.sid != new_sid)" check. Basically just go through a refcount
bump followed by an immediate drop.
