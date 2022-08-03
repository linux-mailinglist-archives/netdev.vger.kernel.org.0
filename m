Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2CE588EE8
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 16:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236303AbiHCOtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 10:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236284AbiHCOtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 10:49:52 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0125B32ECC;
        Wed,  3 Aug 2022 07:49:51 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id uj29so18770777ejc.0;
        Wed, 03 Aug 2022 07:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=T1eaEYCsiztUOu1TAFfBm7LGOQwx8sYwZrazGABjp+A=;
        b=Yom+/5l7W5v3IQO5nqagXRpVxKMpv4b7nLy15Z6BDRoWDxwlVaalW5CEdekCHWvuPg
         YZKrPrvu72xBODBU5dl9eDTkzvRQ2y9Mt06mqJOUZtgzugOaVbzSlQZLokrl+KZ10jch
         skW/DCMDiUoFj2/Kuo+XwRpZxOrjibDrIb8ctmsj9wWmXHGH9jPgpIqIToC8wFJ0/ajq
         7ll0l4RGsYggKLsbnHQ3Znd0wd+HABJIROt4nCuspGyBmuAQlXkxRPnKUrbooBsn/iFH
         shZ6LYBNiJiN3MqtFSbqb1DFn1uN6PKeGxrVam7mN9UxqP+rr4Cv2D/AbADFsH+5HjRy
         NIZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T1eaEYCsiztUOu1TAFfBm7LGOQwx8sYwZrazGABjp+A=;
        b=79naeU5fqhiEB5mKC+y41ItKyNbKE6Y1QoTfXOiC1RhaYp3M59WkLyqoOo6Il6w/mO
         6nDcrYmirCTxLpvyeYg2MRhsHlB8TtdJmipCRcpNOLvi31xselqx9MAfI1n1qIxdQPyM
         Oaaz/9AHYmXku4ncnGauSBRRrZxSX4tVYD1c95TNMmVcTD/dV6OsFRzFc3REQRYIoOy1
         QgSuMVSgEtdq6AUKT5elsxy0aQLT+40H54rhvMiX3RDUAuh2qjIpiAAb1tnlqhe9QRyE
         EO9nuSODve8mP7P3WJLb/GkCZN0b1bzlPPWJAWzyoPCcfuZc0XPe/nX3QCWjFtT33WXI
         Ahqg==
X-Gm-Message-State: AJIora/YckQjUiv1CZFkFzYU+TFkLoAyfYKrDwtsnMgFXDevkp4/T/e+
        B4Xc7JkXcytJa3j56L1XWEhXYdE2Bs8=
X-Google-Smtp-Source: AGRyM1vTtK6HW/bbts8o1KO6oBtaME8U2fUjf+wRHKFzlBr/ItS+9WsFxI8n6qGRmfqGsyEQulv1QQ==
X-Received: by 2002:a17:907:94ca:b0:72b:8f3e:3be0 with SMTP id dn10-20020a17090794ca00b0072b8f3e3be0mr20580195ejc.462.1659538189411;
        Wed, 03 Aug 2022 07:49:49 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id ck28-20020a0564021c1c00b0043df40e4cfdsm2335053edb.35.2022.08.03.07.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 07:49:48 -0700 (PDT)
Date:   Wed, 3 Aug 2022 17:49:46 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun.Ramadoss@microchip.com
Cc:     andrew@lunn.ch, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        linux@armlinux.org.uk, f.fainelli@gmail.com, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        Woojung.Huh@microchip.com, davem@davemloft.net
Subject: Re: [Patch RFC net-next 4/4] net: dsa: microchip: use private pvid
 for bridge_vlan_unwaware
Message-ID: <20220803144946.utxy2mbppj7lmgig@skbuf>
References: <20220729151733.6032-1-arun.ramadoss@microchip.com>
 <20220729151733.6032-1-arun.ramadoss@microchip.com>
 <20220729151733.6032-5-arun.ramadoss@microchip.com>
 <20220729151733.6032-5-arun.ramadoss@microchip.com>
 <20220802105935.gjjc3ft6zf35xrhr@skbuf>
 <365b35f48b4a6c2003b67a4ee0c287b8172fa262.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <365b35f48b4a6c2003b67a4ee0c287b8172fa262.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 02, 2022 at 02:40:09PM +0000, Arun.Ramadoss@microchip.com wrote:
> On Tue, 2022-08-02 at 13:59 +0300, Vladimir Oltean wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you
> > know the content is safe
> > 
> > On Fri, Jul 29, 2022 at 08:47:33PM +0530, Arun Ramadoss wrote:
> > > diff --git a/drivers/net/dsa/microchip/ksz_common.c
> > > b/drivers/net/dsa/microchip/ksz_common.c
> > > index 516fb9d35c87..8a5583b1f2f4 100644
> > > --- a/drivers/net/dsa/microchip/ksz_common.c
> > > +++ b/drivers/net/dsa/microchip/ksz_common.c
> > > @@ -161,6 +161,7 @@ static const struct ksz_dev_ops ksz8_dev_ops =
> > > {
> > >       .vlan_filtering = ksz8_port_vlan_filtering,
> > >       .vlan_add = ksz8_port_vlan_add,
> > >       .vlan_del = ksz8_port_vlan_del,
> > > +     .drop_untagged = ksz8_port_enable_pvid,
> > 
> > You'll have to explain this one. What impact does PVID insertion on KSZ8
> > have upon dropping/not dropping untagged packets? This patch is saying
> > that when untagged packets should be dropped, PVID insertion should be
> > enabled, and when untagged packets should be accepted, PVID insertion
> > should be disabled. How come?
> 
> Its my mistake. I referred KSZ87xx datasheet but I couldn't find the
> register for the dropping the untagged packet. If that is the case,
> shall I remove the dropping of untagged packet feature from the ksz8
> switches?

You'll have to see how KSZ8 behaves when the ingress port is configured
with a PVID (through REG_PORT_CTRL_VID) which isn't present in the VLAN
table. If untagged packets are dropped, that's your "drop untagged"
setting. Some other switches will not do this, and accept untagged
packets even if the VLAN table doesn't contain an entry for the PVID
(or doesn't have this port as a member of that VLAN), but have a
separate knob for dropping untagged traffic.

> > This is better in the sense that it resolves the need for the
> > configure_vlan_while_not_filtering hack. But standalone and VLAN-unaware
> > bridge ports still share the same PVID. Even more so, standalone ports
> > have address learning enabled, which will poison the address database of
> > VLAN-unaware bridge ports (and of other standalone ports):
> > 
> https://patchwork.kernel.org/project/netdevbpf/patch/20220802002636.3963025-1-vladimir.oltean@nxp.com/
> > 
> > Are you going to do further work in this area?
> 
> For now, I thought I can fix the issue for bridge vlan unaware port. I
> have few other patch series to be submitted like gPTP, tc commands. If
> standalone port fix also needed for your patch series I can work on it
> otherwise I can take up later stage.

I think the most imperative thing for you to do is to make sure you are
not introducing regressions with the port default VID change - this can
be done by running the bridge related selftests (and making them pass).

Something which I forgot to mention is that normally, I'd expect a
change of VLAN-unaware PVID to also need a change in the way that
VLAN-unaware FDB entries are added (other drivers need to remap vid=0
from port_fdb_add() to the PVID that they use for that VLAN-unaware
bridge, in your case 4095, for those FDB entries to continue matching
properly).

However, I see that currently, ksz9477_fdb_add() sets the "USE FID" bit
only for VLAN-aware FDB entries (vid != 0), which leaves me with more
questions than answers.

It isn't very well explained what it means to not use FID: let's say
there are 2 entries in the static address table, one has "USE FID"=false,
and the other has "USE FID"=true and FID=127, and a packet is received
which is classified to FID 127. On which entry will this packet match?

The bridge driver gives you all FDB entries at once (VLAN-aware and
VLAN-unaware), so if the USE_FID=false entries that the ksz9477 driver
uses for VLAN-unaware mode will shadow the VLAN-aware FDB entries, this
is going to be a problem.

Also, the way in which the ksz9477 driver translates a 12-bit VID into a
7-bit FID also has me incredibly confused (FID is vlan->vid & VLAN_FID_M,
or otherwise said, a simple truncation). This means that your
VLAN-unaware PVID of 4095 uses a FID of 127, which is also the same FID
as VLANs 127, 255, 383 etc, right? So there is potentially still full
address database leakage between VLAN-unaware and VLAN-aware bridges.

I think this phrase from the documentation is under-appreciated in
understanding how the hardware works:

| Table 4-8 details the forwarding and discarding actions that are taken
| for the various VLAN scenarios. The first entry in the table is
| explained by the fact that VLAN Table lookup is enabled even when 802.1Q
| VLAN is not enabled.

The last part ("VLAN Table lookup is enabled even when 802.1Q VLAN is
not enabled") is what makes it so that the PVID of the port must be
present in the VLAN table or otherwise you get packet drops. In turn,
if the VLAN table is being looked up, it means that regardless of
whether the switch is VLAN-unaware or not, the VID will be transformed
into a 7-bit FID.

I want that the FID that is being used for standalone ports and
VLAN-unaware bridges (127) to be a fully conscious decision, with the
implications understood, and not just something done for me to shut up.
There is a risk here that you may think things are fine and work on
other features, but things are not fine at all. And in this area,
standalone ports/bridge VLANs/ FDB entries/FIDs are very inter-related
things. When you change one, you may find that the entire scheme needs
to be re-thought.
