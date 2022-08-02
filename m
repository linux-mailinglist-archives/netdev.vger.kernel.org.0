Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDF55874F1
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 03:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234725AbiHBBFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 21:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbiHBBFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 21:05:02 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D7145069
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 18:05:01 -0700 (PDT)
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id C7EC23F134
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 01:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1659402298;
        bh=17KPfkqT0KO6/7GmmdgMditRPhVi8MbKFiHcuXVNjPk=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=EVFE5QM5u1NrddyRnNjNoBkZsmbzT8osF6v0qBeusULYrPlSdy6tdMYZrbR1r7EOc
         /FkwLtdkguu+XoSsJOu7m3t0gwYyBSxqRylphaNxoyMLVp7pBLrc0+7No3YJ4H9W/K
         MRtkwZ9fjPEgYCEBDmJgmLauDnllh/afVefHpXMbzPrOUIS5GUPPsabTKzJ1rXrn62
         EPcqvxTsvr/KfVOXyZr+l5AZlr4bTeFPUkpPbXTu43aaH+kqjoj9Pvjefs3Oi0/KCw
         BJRTGuqK8fRHi+IQJ4eJcq0/xNOZ0afDy5F935bW16xoXt56RqH3qPKTmIGZYgk4g5
         zytylNg3U6slQ==
Received: by mail-pf1-f200.google.com with SMTP id h13-20020a056a00000d00b0052de2e258dbso12546pfk.7
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 18:04:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-id:mime-version:comments:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=17KPfkqT0KO6/7GmmdgMditRPhVi8MbKFiHcuXVNjPk=;
        b=k6l+3eCiUYOCn5HQFhGnM1hR7BxbBGt37h0081LTqNXWlkRKza6oARSaHQ+aHjdq4i
         sUhSKqhxXR0L1Gky80v6qVoDIPqcqdCsM07dAqhQzCDAIiMpC9qJ5RnOwnUoqq/Wpi9Q
         IoFND10wc2ViF3GKkK0EQlbLqYYZx0miRVD6RzCVMfd7vydCeaeeLtZI8vjzooXnLN7Q
         WbO+o7Xde345bihxjUgk1BQ2gVQM47bxJVtVjrOEyOF4MdxP3Nmq6i82bupAl4U4iwFc
         jJnOZkR5an5i6tRmTiL2C4DvAdVljOXmfd6u3RwymZQ83I+uVMBAQBdSb7JjyMGx72Vz
         iHCg==
X-Gm-Message-State: ACgBeo0ujGhJkVPUmsQOGDJCu/74FnnkvwlimKfj+IiyrIZ5MRVixD2i
        Q4gp/Eh3hLjjWAwlIrBLhJ3mYQ2RngEBNKESWpOL/c67uSktnufXPbugU1qPd1+t7QNP55qcPIN
        P70fYCXqZs5fpcfpSHimjCE55vCexuGzS0w==
X-Received: by 2002:a63:40c:0:b0:41c:3dee:5475 with SMTP id 12-20020a63040c000000b0041c3dee5475mr3288833pge.385.1659402297194;
        Mon, 01 Aug 2022 18:04:57 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6gKYvZUwQ69NqOApR0MbZ2u8Pb309t76xRy7MozCn5BGk28z/WOgtOoLDsMwfhFIswFBgtBw==
X-Received: by 2002:a63:40c:0:b0:41c:3dee:5475 with SMTP id 12-20020a63040c000000b0041c3dee5475mr3288806pge.385.1659402296892;
        Mon, 01 Aug 2022 18:04:56 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id n7-20020a622707000000b0052dbad1ea2esm1493438pfn.6.2022.08.01.18.04.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Aug 2022 18:04:56 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id E5BEF6118F; Mon,  1 Aug 2022 18:04:55 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id DE3A19FA79;
        Mon,  1 Aug 2022 18:04:55 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH v3 net 1/4] net: bonding: replace dev_trans_start() with the jiffies of the last ARP/NS
In-reply-to: <20220731191327.cey4ziiez5tvcxpy@skbuf>
References: <20220731124108.2810233-1-vladimir.oltean@nxp.com> <20220731124108.2810233-2-vladimir.oltean@nxp.com> <1547.1659293635@famine> <20220731191327.cey4ziiez5tvcxpy@skbuf>
Comments: In-reply-to Vladimir Oltean <vladimir.oltean@nxp.com>
   message dated "Sun, 31 Jul 2022 19:13:28 -0000."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5678.1659402295.1@famine>
Date:   Mon, 01 Aug 2022 18:04:55 -0700
Message-ID: <5679.1659402295@famine>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

>Hello Jay,
>
>On Sun, Jul 31, 2022 at 11:53:55AM -0700, Jay Vosburgh wrote:
>> Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>> 
>> >The bonding driver piggybacks on time stamps kept by the network stack
>> >for the purpose of the netdev TX watchdog, and this is problematic
>> >because it does not work with NETIF_F_LLTX devices.
>> >
>> >It is hard to say why the driver looks at dev_trans_start() of the
>> >slave->dev, considering that this is updated even by non-ARP/NS probes
>> >sent by us, and even by traffic not sent by us at all (for example PTP
>> >on physical slave devices). ARP monitoring in active-backup mode appears
>> >to still work even if we track only the last TX time of actual ARP
>> >probes.
>> 
>> 	Because it's the closest it can get to "have we sent an ARP," really.
>
>Does it really track this? It seems pretty easy to fool to me.
>I don't know why keeping a last_tx the way my patch does wouldn't be
>better.

	The ARP monitor in general is pretty easy to fool (which was
part of the impetus for adding the "arp_validate" logic).  Ultimately it
was simpler to have the ARP monitor logic be "interface sent something
AND received an appropriate ARP" since the "sent something" came for
free from ->trans_start (which over time became less useful for this
purpose).

	And, I'm not saying your patch isn't better, rather that what I
was intending to do is minimize the change in behavior.  My concern is
that some change in semantics will break existing configurations that
rely on the old behavior.  Then, the question becomes whether the broken
configuration was reasonable or not.

	I haven't thought of anything that seems reasonable thus far;
the major change looks to be that the new logic in your patch presumes
that arp_xmit cannot fail, so if some device was discarding all TX
packets, the new logic would update "last_rx" regardless.

>> The issue with LLTX is relatively new (the bonding driver has worked
>> this way for longer than I've been involved, so I don't know what the
>> original design decisions were).
>> 
>> 	FWIW, I've been working with the following, which is closer in
>> spirit to what Jakub and I discussed previously (i.e., inspecting the
>> device stats for virtual devices, relying on dev_trans_start for
>> physical devices with ndo_tx_timeout).
>> 
>> 	This WIP includes one unrelated change: including the ifindex in
>> the route lookup; that would be a separate patch if it ends up being
>> submitted (it handles the edge case of a route on an interface other
>> than the bond matching before the bond itself).
>
>The problem with dev_get_stats() is that it will contain hardware
>statistics, which may be completely unrelated to the number of packets
>software has sent. DSA can offload the Linux bridge and the bonding
>driver as a bridge port, so dev_get_stats() on a physical port will
>return the total number of packets that egressed that port, even without
>CPU intervention. Again, even easier to fool if "have we sent an ARP"
>is what the bonding driver actually wants to know.

	I'm not well versed in how DSA works, but if a physical port is,
well, discrete from the system to a degree, why would it be part of a
bond running on the host?

	Put another way, what sort of topology / plumbing makes sense
for DSA in conjunction with bonding?

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
