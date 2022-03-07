Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2624D021D
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 15:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243648AbiCGOy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 09:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243673AbiCGOys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 09:54:48 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600503B3E1
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 06:53:37 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id q10so8110827ljc.7
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 06:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=z+Sy3daXdZc7eFbdaSwLgS5WLdDuNus4al0ePtnegPY=;
        b=nXjjimFe6hkuycvGrRtBjI1tKHAIDTQIMYAAXSkRjb2oWqSuB/56KJfDcJysox0MNW
         JZgo+cbfllhR/t2NrtkiFGFnBeuEt7tZGrh6Ib1Vw/0OuoHLacO0XOi4RuXFF1hOS2X+
         s6QOSDr89qyk3k5+h2aCsvSU8ZtsqRhvqFiF2cVjVM1RB/b93R7oH8Q14UQI8nCEnil3
         eU336Zo/Yf8z/RNW3DDQbY3LdduKL4XQr5ZrQcGUrgSwhtnFhpk7EIVYOKLR2bgX1BAf
         0XvFoGwBTTXSZ0cC2JWcH8n5czQCnX8QfB0VzjYTnjo+EssdB9v3rjIJKtfhjIJqWEtG
         0cIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=z+Sy3daXdZc7eFbdaSwLgS5WLdDuNus4al0ePtnegPY=;
        b=ZnZEqS4jk1UWY5EuJlf/fjZv3YwSEF9aaIZQjB/+ZOmBVLqhoTyln6TuRcclPEYWNV
         MhMdeZUiT/5ixDDwt+QXfLvZ54g9moMB+fp2vkutWrVuGgK9jxCEm4w1DdmED9jQEMn/
         SA4mkutUARcLyW70me6wTx20uzkwDLwZ14o11TVF4iTkVB9xqGL4HWQE6bM5Cs7g+bap
         LaDvq1nTKt0qrhW8Rndb1ZFcPZ1a5IwL9+Uzv/MKNw0XPOVLUB40dp2eomof5GqjL4hp
         D0Xq9mKOxKJbVprjf8SlCuyUa1xu0tDwmwcv9K7Yxo3PsidqRcw5n7QLVJaUxSGjruLi
         iG1w==
X-Gm-Message-State: AOAM532rAlZ+MxYXvlstHI+bC49ZjYfVpDip8TDaQNYNFqKTgs/06g9a
        pp/xQeT8VnjMsc3gN/eXOKdScQ==
X-Google-Smtp-Source: ABdhPJzwJYX8QzgQc/9gclgdwVh43xGvJ5/ZrCLjbcRJhj+2yO1Yd1a2xOZPXO+BMShe/qizAJYQWQ==
X-Received: by 2002:a2e:8882:0:b0:244:8a8a:212 with SMTP id k2-20020a2e8882000000b002448a8a0212mr8017210lji.220.1646664812423;
        Mon, 07 Mar 2022 06:53:32 -0800 (PST)
Received: from wkz-x280 (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id u26-20020ac25bda000000b0044830ec5d05sm592057lfn.274.2022.03.07.06.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 06:53:31 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v2 net-next 01/10] net: bridge: mst: Multiple Spanning
 Tree (MST) mode
In-Reply-To: <F908AE50-EDF4-4B83-98BD-ECB872CAD776@blackwall.org>
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301100321.951175-2-tobias@waldekranz.com>
 <F908AE50-EDF4-4B83-98BD-ECB872CAD776@blackwall.org>
Date:   Mon, 07 Mar 2022 15:53:30 +0100
Message-ID: <87a6e1olud.fsf@waldekranz.com>
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

On Wed, Mar 02, 2022 at 00:01, Nikolay Aleksandrov <razor@blackwall.org> wrote:
> On 1 March 2022 11:03:12 CET, Tobias Waldekranz <tobias@waldekranz.com> wrote:
>>Allow the user to switch from the current per-VLAN STP mode to an MST
>>mode.
>>
>>Up to this point, per-VLAN STP states where always isolated from each
>>other. This is in contrast to the MSTP standard (802.1Q-2018, Clause
>>13.5), where VLANs are grouped into MST instances (MSTIs), and the
>>state is managed on a per-MSTI level, rather that at the per-VLAN
>>level.
>>
>>Perhaps due to the prevalence of the standard, many switching ASICs
>>are built after the same model. Therefore, add a corresponding MST
>>mode to the bridge, which we can later add offloading support for in a
>>straight-forward way.
>>
>>For now, all VLANs are fixed to MSTI 0, also called the Common
>>Spanning Tree (CST). That is, all VLANs will follow the port-global
>>state.
>>
>>Upcoming changes will make this actually useful by allowing VLANs to
>>be mapped to arbitrary MSTIs and allow individual MSTI states to be
>>changed.
>>
>>Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>>---
>> include/uapi/linux/if_link.h |  1 +
>> net/bridge/Makefile          |  2 +-
>> net/bridge/br_input.c        | 17 +++++++-
>> net/bridge/br_mst.c          | 83 ++++++++++++++++++++++++++++++++++++
>> net/bridge/br_netlink.c      | 14 +++++-
>> net/bridge/br_private.h      | 26 +++++++++++
>> net/bridge/br_stp.c          |  3 ++
>> net/bridge/br_vlan.c         | 20 ++++++++-
>> net/bridge/br_vlan_options.c |  5 +++
>> 9 files changed, 166 insertions(+), 5 deletions(-)
>> create mode 100644 net/bridge/br_mst.c
>>
>
> Hi,
> As I mentioned in another review, I'm currently traveling and will have pc access
> end of this week (Sun), I'll try to review the set as much as I can through my phone in the
> meantime. Thanks for reworking it, generally looks good.
> A few comments below,
>
>
>>diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
>>index e315e53125f4..7e0a653aafa3 100644
>>--- a/include/uapi/linux/if_link.h
>>+++ b/include/uapi/linux/if_link.h
>>@@ -482,6 +482,7 @@ enum {
>> 	IFLA_BR_VLAN_STATS_PER_PORT,
>> 	IFLA_BR_MULTI_BOOLOPT,
>> 	IFLA_BR_MCAST_QUERIER_STATE,
>>+	IFLA_BR_MST_ENABLED,
>
> Please use the boolopt api for new bridge boolean options like this one.

Ahh, I was not aware of that. Will change it in v3. Thanks.
