Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2694E56A1
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 17:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238314AbiCWQkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 12:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbiCWQkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 12:40:20 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A2355499
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 09:38:49 -0700 (PDT)
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id DEF723F6BA
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 16:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1648053527;
        bh=mDygNB4hlr8O2IiqVOYkBZ7ZOtLoUjEBL+tdiRjaXQ8=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=jsza7bpfgHSQo8U6Ay15gXV128khHWIun3+6+NB9TG2mANpIuQBuBC0kiFPZlrbc/
         9hFoA/xVaFIcEqNg7q3Vz0Yc34eNdI8mmb0GZabdUDNOxDE6pMqdhq+LrjeJwWWGA3
         ZHLBw0BaDchK4HSbVmRSHznNEMrt4evhpBuxK3mO6zxCW1XwYDGw7aO/Vyc7+x6Pu+
         RWjx2u0WbvbvE6WEv8zbo+xOW2NfKyEZYUG3XPpu64P6qgwyMPGqZ8aHlza2bXms2K
         G/bIHO33dJLBfj0t3AN9cJ3jgSw3mzJcptfQ0QQ0bEgkSi4tESIyvP6mVZdcUsFs+j
         Dc0H1x8CK7f5g==
Received: by mail-pl1-f197.google.com with SMTP id z10-20020a170902708a00b0014fc3888923so1136480plk.22
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 09:38:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:date:message-id;
        bh=mDygNB4hlr8O2IiqVOYkBZ7ZOtLoUjEBL+tdiRjaXQ8=;
        b=ZvSz7upJvQ+lRljJoxyFogdYgNl9Ky/2qdQqPQYpjQLjvQwhyZMNjPpaiUJmQYJnWa
         Hp40lLmJZvHXkP9AMjLoZD7kEKT9CjHwFs25ZYq28FQSAUHBpePZ480Uynxgdt4xLU0Q
         vmbbwaQbSPCnNEiG5CC+FSHbEwN29tMmlZ3Bzcf9TeFtx9B9fJT1HmFlz56BH4tgB2L7
         KFjfOWioh5sMW2GMBlbrs4vNF6B8Ci0Bc9Ay5fRT3vU1WBhiK8jm9Cu/mQ4ohkaNn/D2
         y+lZyUwsRsNixnEZPuH1huC3DrN+JRaEeZMiCl/XmZpJlPBXXRo+7JTiXsNhg8J5u7pA
         T+rQ==
X-Gm-Message-State: AOAM533nEp5LijkKWGDlMrSr/yjfOpK07BW4HRteXm0gStzPsivmbA6Q
        eRn7NfxBBABB2q6EVpSK6FMyEvJMoEeN4sBXpQdST1+v5YAfh+fPyvy99Tl086XVGKDiElGNA5C
        4WvrnneZTRjCDVDz3MG5IE2uZSHgo0jVEAA==
X-Received: by 2002:a17:902:e846:b0:154:3d19:c5ae with SMTP id t6-20020a170902e84600b001543d19c5aemr721627plg.87.1648053526448;
        Wed, 23 Mar 2022 09:38:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkGv9mOLlEFy7D6mUCtMt9cGQMdW84q8pg19L4S6yOohWutc8ytNgEYE9Ekaua+SYe6d6j0w==
X-Received: by 2002:a17:902:e846:b0:154:3d19:c5ae with SMTP id t6-20020a170902e84600b001543d19c5aemr721595plg.87.1648053526157;
        Wed, 23 Mar 2022 09:38:46 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id 22-20020a17090a019600b001c6457e1760sm244576pjc.21.2022.03.23.09.38.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Mar 2022 09:38:45 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 49ED16093D; Wed, 23 Mar 2022 09:38:45 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 426C2A0B18;
        Wed, 23 Mar 2022 09:38:45 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     David Ahern <dsahern@kernel.org>,
        Sun Shouxin <sunshouxin@chinatelecom.cn>, vfalico@gmail.com,
        andy@greyhouse.net, davem@davemloft.net, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, oliver@neukum.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
Subject: Re: [PATCH v6 0/4] Add support for IPV6 RLB to balance-alb mode
In-reply-to: <20220323083332.54dc0a6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220323120906.42692-1-sunshouxin@chinatelecom.cn> <7288faa9-0bb1-4538-606d-3366a7a02da5@kernel.org> <20220323083332.54dc0a6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Comments: In-reply-to Jakub Kicinski <kuba@kernel.org>
   message dated "Wed, 23 Mar 2022 08:33:32 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4912.1648053525.1@famine>
Date:   Wed, 23 Mar 2022 09:38:45 -0700
Message-ID: <4913.1648053525@famine>
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:

>On Wed, 23 Mar 2022 08:35:03 -0600 David Ahern wrote:
>> On 3/23/22 6:09 AM, Sun Shouxin wrote:
>> > This patch is implementing IPV6 RLB for balance-alb mode.
>>
>> net-next is closed, so this set needs to be delayed until it re-opens.
>
>What I'm not sure of is why this gets reposted after Jiri nacked
>it. A conclusion needs to be reached on whether we want this
>functionality in the first place. Or someone needs to explain 
>to me what the conclusion is if I'm not reading the room right :)

	The summary (from my perspective) is that the alb/rlb technology
more or less predates LACP, and is a complicated method to implement
load balancing across a set of local network peers.  The existing
implementation for IPv4 uses per-peer tailored ARP messages to "assign"
particular peers on the subnet to particular bonding interfaces.  I do
encounter users employing the alb/rlb mode, but it is uncommon; LACP is
by far the most common mode that I see, with active-backup a distant
second.

	The only real advantage alb/rlb has over LACP is that the
balance is done via traffic monitoring (i.e., assigning new peers to the
least busy bond interface, with periodic rebalances) instead of a hash
as with LACP.  In principle, some traffic patterns may end up with hash
collisions on LACP, but will be more evenly balanced via the alb/rlb
logic (but this hasn't been mentioned by the submitter that I recall).
The alb/rlb logic also balances all traffic that will transit through a
given router together (because it works via magic ARPs), so the scope of
its utility is limited.

	As much as I'm all in favor of IPv6 being a first class citizen,
I haven't seen a compelling use case or significant advantage over LACP
stated for alb/rlb over IPv6 that justifies the complexity of the
implementation that will need to be maintained going forward.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
