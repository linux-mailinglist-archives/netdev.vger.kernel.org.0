Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53F64D1627
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 12:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346439AbiCHLXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 06:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346530AbiCHLW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 06:22:56 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED8646164;
        Tue,  8 Mar 2022 03:22:00 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id g3so11782024edu.1;
        Tue, 08 Mar 2022 03:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c+rvaRPglsdjCivkAUDo1zGQCcIIdAVOXsTQ+b3U1eU=;
        b=eseSg3gO+h/WvBzk8rHM8vEeplHFFSPvnISVegXP8IIJiZCcnzEQYyKbh4+9dP8AE5
         Qj3EdGyvLx/4sVjgcMFAbWRfId2FhrgNBZgtJ0X2qCyc51JG+hg3yplFDYb2fBzamJAQ
         6MfeEjNncMY45sNgvFXEF/ll/p5aTEmHhn+KcrRzfwX4qLiLZxvbVmKEOK+mQNPHrjUC
         9NIPbLunXD+FESfsntzHENX9cdwvhLddR0GrIMPMWXnuMUrX32OZxSZVfSGzFGl36ARi
         JPX2PtM1eStZ+7jatS9466HRnQlOH+npvgfCizjbUOt6ogC2AoDkltYcxO3YIrHcDaxF
         S10Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c+rvaRPglsdjCivkAUDo1zGQCcIIdAVOXsTQ+b3U1eU=;
        b=4W4xa8E67AN8avlhNz+W4MSUngRu5tXT8XkVy1qb3CGAV7XmjHH3GWI+wj2O+scwZ4
         KKnVorKlNVs/TJbzRiEqzoF10HhQcvxve4lroLdSOyhMsuW3VbpkkCW3joGzWwRy5EIS
         YRYQ/QG8E+yFYGf84xMjwyibmxwoBJE3Yl1yHPjgUEpwlBW9f7J7g4sSNbbty0BVHrH3
         GQxE+n3oVjFJkItz98QOP5L1UWA0t5R92lzNZ40XtCMYejbVqod4vLro++Y5xyArdYvQ
         3SwdNsjXDGn/8HLL7uKlfYFapW64LqiNJllfNB3+X4PQ/oNtdyMhAYwa6BcRp24llgxA
         v/GA==
X-Gm-Message-State: AOAM531BL2/QzjQ+64+w37kXOVy+QtRBt32EwUX56VVW4BeMZ8lurs6j
        MIIu90rb0+GpNGHNVoyq8EE=
X-Google-Smtp-Source: ABdhPJyZEf6Mycjwi3XGLk0/LoHIRa79uwoByVgnNfLv4FkoMPZSH04fTXlGXFc09jGZmUuS9DgAvA==
X-Received: by 2002:a05:6402:2987:b0:414:39b0:7fc1 with SMTP id eq7-20020a056402298700b0041439b07fc1mr15519948edb.214.1646738518909;
        Tue, 08 Mar 2022 03:21:58 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id g22-20020a170906395600b006cec40b9cf0sm5757828eje.92.2022.03.08.03.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 03:21:58 -0800 (PST)
Date:   Tue, 8 Mar 2022 13:21:56 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 1/1] net: dsa: microchip: ksz9477: implement
 MTU configuration
Message-ID: <20220308112156.6s2ssnkhifxuuw2w@skbuf>
References: <20220223233833.mjknw5ko7hpxj3go@skbuf>
 <20220224045936.GB4594@pengutronix.de>
 <20220224093329.hssghouq7hmgxvwb@skbuf>
 <20220224093827.GC4594@pengutronix.de>
 <20220224094657.jzhvi67ryhuipor4@skbuf>
 <20220225114740.GA27407@pengutronix.de>
 <20220225115802.bvjd54cwwk6hjyfa@skbuf>
 <20220225125430.GB27407@pengutronix.de>
 <20220225163543.vnqlkltgmwf4vlmm@skbuf>
 <20220308100644.GA5189@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308100644.GA5189@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 11:06:44AM +0100, Oleksij Rempel wrote:
> > > > I was saying:
> > > > 
> > > > ip link set lan1 up
> > > > ip link add link lan1 name lan1.5 type vlan id 5
> > > > ip addr add 172.17.0.2/24 dev lan1.5 && ip link set lan1.5 up
> > > > iperf3 -c 172.17.0.10
> > > 
> > > It works.
> > 
> > This is akin to saying that without any calls to ksz9477_change_mtu(),
> > just writing VLAN_ETH_FRAME_LEN + ETH_FCS_LEN into REG_SW_MTU__2 is
> > sufficient to get VLAN-tagged MTU-sized packets to pass through the CPU
> > port and the lan1 user port.
> > 
> > So my question is: is this necessary?
> > 
> > 	if (dsa_is_cpu_port(ds, port))
> > 		new_mtu += KSZ9477_INGRESS_TAG_LEN;
> > 
> 
> No.
> 
> I did some extra tests with following results: REG_SW_MTU__2 should be
> configured to 1518 to pass 1514 frame. Independent if the frame is
> passed between external ports or external to CPU port. So, I assume,
> ETH_FRAME_LEN + ETH_FCS_LEN should be used instead of VLAN_ETH_FRAME_LEN
> + ETH_FCS_LEN. Correct?

Oleksij, to be clear, I only had an issue with consistency.
You were adding KSZ9477_INGRESS_TAG_LEN during ksz9477_change_mtu() but
not during initial setup. That prompted the question: is that particular
member of the sum needed or not? Either it's needed in both places, or
in none.

Then, apart from removing KSZ9477_INGRESS_TAG_LEN, you've also made an
unsolicited change (subtracted VLAN_HLEN from the value programmed to
hardware) without a clear confirmation that you understand what this
does, and without explicitly saying that the iperf3 test above still
works with this formula applied.

Since the VLAN header is part of L2, it means that a port configured for
MTU 1500 must also support VLAN-tagged packets with an L2 payload of
1500 octets. 1500 + ETH_HLEN + VLAN_HLEN == 1518 octets.
And since you need to add ETH_HLEN + ETH_FCS_LEN, I have an unconfirmed
hunch that VLAN_HLEN is also needed for the case above.

So, I'm sorry for being paranoid, but you aren't really giving me a
choice but to ask again, and again.
