Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE7759D2A5
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 09:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241126AbiHWHwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 03:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241322AbiHWHwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 03:52:19 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3DF65545
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 00:52:18 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id by6so12727749ljb.11
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 00:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :organization:message-id:subject:cc:to:from:date:from:to:cc;
        bh=h69V7MPu94QCaBBJjujVU/YArEOC9MJgSBUyfcsB0B8=;
        b=cteXBRZgqGrWyyWtqFGocrnO6JID3llU8QINR6WYnQt49DtGEYakbQIizU5wlc41uJ
         OnXAgcKFY40JF6RMZOi3PcnX4uFnviBf/3MY9/vxSRB3dDOkR0FuuS5YT/HG6l95ML1b
         vRjW/5/pWGtsXsGmby6Zx6oDjJ66S4RZfb9/d8QcDJSZlOYAT72r7enZWaqGwy3BccvM
         jiBQXowx9k+71xcDvanccIm1zCe1nh0ZV5yV1pVQ/6/qMtg2W+gWVZ3+Bs8G/11h5syz
         qenqCRiASQA1WDW/oLYRbfYBgeyuGsOl7g5NmArLFWqF3IFX+EbCYUkQy+sLgBMS/iMT
         lYbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :organization:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=h69V7MPu94QCaBBJjujVU/YArEOC9MJgSBUyfcsB0B8=;
        b=33bafQ2vofgZ08QxTPF6xPryeetMXpHeuBDA3cLGmr7EOf9szF1jqiGEdY2b/s2Igg
         hVblvIaF12pF4S8vajpA+z95xanmOFgIOX4P0LS/WXozJtMApZPjpcTPNLqms2DKXC4A
         HrKUdzEV5cEYid7vYaW4ZIlAz8mRIPTlUFv7YN7ImB3uKhkrG2pBS0U8JODkdbdjqkAi
         TdYhpqAK42V3Av3MTXHnqQM/Nvt7pPsfcQUllDzufVhvRsSfoBnylTq8Y98wsZ2pFuaR
         Hd145kSOo+g8axj4sHaKaCK0xoeGorCk1vKGqtYIXcv+M68UTe24eNubjdSYiIG7C3i9
         /Hjw==
X-Gm-Message-State: ACgBeo21FSUEROzKnevBouQOOTm8vVQTf6YmQwJGTPdDdd5yu6iZjSvQ
        XyjM+JmTXqiGbVesqbJDpFw=
X-Google-Smtp-Source: AA6agR5KGXhWl8lrL/KyHRKWdP3jtd0trOLYikkSHi4T9+HTUaEB+ZvG5C30SPrC667D7IEx+W1NrA==
X-Received: by 2002:a2e:a884:0:b0:25d:d8a2:d18c with SMTP id m4-20020a2ea884000000b0025dd8a2d18cmr6145940ljq.305.1661241137092;
        Tue, 23 Aug 2022 00:52:17 -0700 (PDT)
Received: from wse-c0155 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id u18-20020a05651220d200b0048b1ba4d2a4sm2365071lfr.265.2022.08.23.00.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 00:52:16 -0700 (PDT)
Date:   Tue, 23 Aug 2022 09:52:15 +0200
From:   Casper Andersson <casper.casan@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 2/3] net: sparx5: add list for mdb entries in
 driver
Message-ID: <20220823075215.gunhf2tsss3zpuip@wse-c0155>
Organization: Westermo Network Technologies AB
References: <20220822140800.2651029-1-casper.casan@gmail.com>
 <20220822140800.2651029-3-casper.casan@gmail.com>
 <YwOe5hNa1PJFr077@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwOe5hNa1PJFr077@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-08-22 17:21, Andrew Lunn wrote:
> > +struct sparx5_mdb_entry {
> > +	struct list_head list;
> > +	unsigned char addr[ETH_ALEN];
> > +	u16 vid;
> > +	DECLARE_BITMAP(port_mask, SPX5_PORTS);
> > +	bool cpu_copy;
> > +	u16 pgid_idx;
> > +};
> 
> You have a number of holes in that structure. Maybe this is better:
> 
> > +struct sparx5_mdb_entry {
> > +	struct list_head list;
> > +	DECLARE_BITMAP(port_mask, SPX5_PORTS);
> > +	unsigned char addr[ETH_ALEN];
> > +	bool cpu_copy;
> > +	u16 vid;
> > +	u16 pgid_idx;
> > +};
> 
> Hopefully the compiler can pack the bool straight after the 6 byte MAC
> address. And the two u16 should make one u32.

I had not considered that. Will fix for v2 and keep in mind for the
future!

> > +static int sparx5_alloc_mdb_entry(struct sparx5 *sparx5,
> > +				  const unsigned char *addr,
> > +				  u16 vid,
> > +				  struct sparx5_mdb_entry **entry_out)
> > +{
> > +	struct sparx5_mdb_entry *entry;
> > +	u16 pgid_idx;
> > +	int err;
> > +
> > +	entry = devm_kzalloc(sparx5->dev, sizeof(struct sparx5_mdb_entry), GFP_ATOMIC);
> 
> Does devm_kzalloc make sense here? A MDB entry has a much shorter life
> time than the driver. devm has overheads, so it is good for large
> allocations which last as long as the device, but less so for lots of
> small short lives structures.

You're right. Reading up on it I can see why kzalloc would make more
sense. Will fix! Do I have to free any remaining mdb entries when the
module is unloaded? Or is it able to handle that by deleting them when
unregistering?

Thanks for the feedback.

Best regards
Casper
