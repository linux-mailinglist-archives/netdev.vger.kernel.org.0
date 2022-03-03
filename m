Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C2E4CC8E4
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 23:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236901AbiCCW3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 17:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbiCCW3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 17:29:38 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733F24F9D6;
        Thu,  3 Mar 2022 14:28:52 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id p15so13686676ejc.7;
        Thu, 03 Mar 2022 14:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q3KMKlNL1UmXA+3fpqyraxkBiFVYfDRSUjKE3l3RuVk=;
        b=MDnX4bgCQ/oEW0UhmojxOqONfN9vQW6YLWXvJiTN9ZgftqcQr1HntMOS2g3/z2DPmE
         8m33ZJNdMHy5QvE34NBHTPyrFtQvSqNCX42VcKXLUA28fVVOjSENDm9kkQb1YrThCzCw
         4mhs+Ja7G4trf5TymB8l8SBevLF4w8Cx1wjasWV1OlHemYMPolDQEc3m40FjuotYMIpW
         V6ohRAT19l0vMqSS6sFnNBHePLzvjUzcp24j5GeZvNTFfz0x9TD2VOYGM0sWaQzurbAG
         VnZd3CbpCGqvfBGxVJoFWuMNGVRlf0X0sqsXMbKEppdV4jwy/kqgzP0I0ikBXbUVso/Z
         hbtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q3KMKlNL1UmXA+3fpqyraxkBiFVYfDRSUjKE3l3RuVk=;
        b=P/2ngA0FyEHXKt4hqIz9HzpYQq1w3xcHsbxEKIMHVG6YNhN89x7Hpws9/yoDEPqv3E
         EcpHjj6AKh6dACEwgE6iClywy5JXqFKy+hx4X2snwS6Jb1JlZ/EVffY2TdaMd1p0AVQ1
         2IFJCOUtwuZ3YIQTwnCcvjqOgvjcm9O2fvQ0wL2PoGAQRbOVnMTs+CflW04LF4j9iz2o
         +QUKSY7VzYohlZtJAKuzphQ3JHWHep8z1xpD3X4oQYDMnzoRq32WU5kdWz/dw0qGYozU
         o8327ahW36YYCohhd1ItrwvozSNtcRKweDH+9Sbf1KHX2R/c+q0B6DxUfU4fR13gDX+f
         5OHg==
X-Gm-Message-State: AOAM530VxHyrYgiJYDEeNg+X4APjS+utm4WFXb8E2n/R7GD6Ni4ceM+U
        o7d+OGqz9EMDXkMxEsi8vQ8=
X-Google-Smtp-Source: ABdhPJzk13wyTbmYgwXumamuMcIRNwpzubAWgHvblQ9VhZ2Wj9eexC+yjherORwhPTNIQRvPpaYgVg==
X-Received: by 2002:a17:906:5d11:b0:6da:68ed:270f with SMTP id g17-20020a1709065d1100b006da68ed270fmr7732259ejt.661.1646346530968;
        Thu, 03 Mar 2022 14:28:50 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id n27-20020a1709062bdb00b006da975173bfsm810028ejg.170.2022.03.03.14.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 14:28:50 -0800 (PST)
Date:   Fri, 4 Mar 2022 00:28:48 +0200
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
Subject: Re: [PATCH v2 net-next 01/10] net: bridge: mst: Multiple Spanning
 Tree (MST) mode
Message-ID: <20220303222848.4e2s2zrbzfckmiqw@skbuf>
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301100321.951175-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301100321.951175-2-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 11:03:12AM +0100, Tobias Waldekranz wrote:
> Allow the user to switch from the current per-VLAN STP mode to an MST
> mode.
> 
> Up to this point, per-VLAN STP states where always isolated from each
> other. This is in contrast to the MSTP standard (802.1Q-2018, Clause
> 13.5), where VLANs are grouped into MST instances (MSTIs), and the
> state is managed on a per-MSTI level, rather that at the per-VLAN
> level.
> 
> Perhaps due to the prevalence of the standard, many switching ASICs
> are built after the same model. Therefore, add a corresponding MST
> mode to the bridge, which we can later add offloading support for in a
> straight-forward way.
> 
> For now, all VLANs are fixed to MSTI 0, also called the Common
> Spanning Tree (CST). That is, all VLANs will follow the port-global
> state.
> 
> Upcoming changes will make this actually useful by allowing VLANs to
> be mapped to arbitrary MSTIs and allow individual MSTI states to be
> changed.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
> +void br_mst_vlan_set_state(struct net_bridge_port *p, struct net_bridge_vlan *v,
> +			   u8 state)

Function can be static.

> +{
> +	struct net_bridge_vlan_group *vg = nbp_vlan_group(p);
> +
> +	if (v->state == state)
> +		return;
> +
> +	br_vlan_set_state(v, state);
> +
> +	if (v->vid == vg->pvid)
> +		br_vlan_set_pvid_state(vg, state);
> +}
