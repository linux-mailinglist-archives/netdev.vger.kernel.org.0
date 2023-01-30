Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC95680E4C
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 13:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236940AbjA3M6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 07:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236938AbjA3M6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 07:58:49 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DE934304;
        Mon, 30 Jan 2023 04:58:18 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id x7so7615732edr.0;
        Mon, 30 Jan 2023 04:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jSgexImJFvbllsb2hR3ybobUUI/wwigUcBhRfKkOfog=;
        b=WnI3TvSl212FavxWOkWMzASf/zIj1UOOD3xLh8tKgY0jr9lubQgLZHuu+NelEDy+T3
         wJLtc2WTm1v87TuE1IhPmaV403HE4Tkx0rN5In1UMSwlwgTMuRLYoR6E2lTnIykggiUw
         ezlwKOg2+r3YPwr2GfXiCyfkDYrvpjiidG4yhqBVXRJ6Gp1YvzuyQ34zt8mib6A8T0r6
         GhD3B05WMRm7Eg/SgH+HSle7CE/z/IvqLQCm61NkKxrvLfu6x0kcyyW1HHkBiMUh6lbx
         bJ19TrC9eh0mOqj+hudtHkIV7HHSxlj9a2i4H8atMIuWaJJYiFFRM841mgKZM4MNO+dP
         GA3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jSgexImJFvbllsb2hR3ybobUUI/wwigUcBhRfKkOfog=;
        b=R18PCTvc32WSeJvqMivLWud70i6O0zqF9znbyASGRjxZw70fw/IZfLpQ3G5emxuuhm
         F9nKY7DbvJITdKUCGzbZNUEl94Jr2TGfHKxF3B9JhHWWz1/yKmBaVf5h69nOeSkTsxGx
         VkvaO3fB3DF1CyubmqOmrbhOuc4szDOzJX3LSB009vbd9BVGUxklwyoDXEf47BKzz9XG
         /JPT0qzqsPRID/g7AgrNT5sWHkyWCLyWaPPoHowRktUpsWh5FkZv7Q5sypGRizID3lUN
         /H2R3sWb6p0hf+pb3lKnaYAMWI5LVQ2B3AmPd4ytP3E3gjyq/GXUqESSAQq/+6nFi5NP
         olcg==
X-Gm-Message-State: AO0yUKWs78SrfDHgOX2h6+ny5uf3JSwWBTSTSsvY0ZBBFVBl4Zyimm4v
        b/NwwGpfifDklk31pZtolKI=
X-Google-Smtp-Source: AK7set9JkJt7Zz6KHjv7o/kgAl8hsm7AuCNxAD+p1Qxe5KFXyl5rE/TM1/tzqi2oSQTtcNqdA8YEwQ==
X-Received: by 2002:a05:6402:4003:b0:4a2:2fa:ead4 with SMTP id d3-20020a056402400300b004a202faead4mr14839532eda.17.1675083496377;
        Mon, 30 Jan 2023 04:58:16 -0800 (PST)
Received: from skbuf ([188.26.57.205])
        by smtp.gmail.com with ESMTPSA id c20-20020aa7df14000000b00499b3d09bd2sm2351700edy.91.2023.01.30.04.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 04:58:15 -0800 (PST)
Date:   Mon, 30 Jan 2023 14:58:13 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>
Subject: Re: [BUG] vlan-aware bridge breaks vlan on another port on same gmac
Message-ID: <20230130125813.asx5qtm6ttuwdobo@skbuf>
References: <trinity-e6294d28-636c-4c40-bb8b-b523521b00be-1674233135062@3c-app-gmx-bs36>
 <20230120172132.rfo3kf4fmkxtw4cl@skbuf>
 <trinity-b0df6ff8-cceb-4aa5-a26f-41bc04dc289c-1674303103108@3c-app-gmx-bap60>
 <20230121122223.3kfcwxqtqm3b6po5@skbuf>
 <trinity-7c2af652-d3f8-4086-ba12-85cd18cd6a1a-1674304362789@3c-app-gmx-bap60>
 <20230121133549.vibz2infg5jwupdc@skbuf>
 <trinity-cbf3ad23-15c0-4c77-828b-94c76c1785a1-1674310370120@3c-app-gmx-bap60>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-cbf3ad23-15c0-4c77-828b-94c76c1785a1-1674310370120@3c-app-gmx-bap60>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Frank,

On Sat, Jan 21, 2023 at 03:12:50PM +0100, Frank Wunderlich wrote:
> Hi
> 
> > Gesendet: Samstag, 21. Januar 2023 um 14:35 Uhr
> > Von: "Vladimir Oltean" <olteanv@gmail.com>
> > An: "Frank Wunderlich" <frank-w@public-files.de>
> > Cc: "Andrew Lunn" <andrew@lunn.ch>, "Florian Fainelli" <f.fainelli@gmail.com>, "David S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, "Landen Chao" <Landen.Chao@mediatek.com>, "Sean Wang" <sean.wang@mediatek.com>, "DENG Qingfang" <dqfext@gmail.com>, "Matthias Brugger" <matthias.bgg@gmail.com>, "Daniel Golle" <daniel@makrotopia.org>
> > Betreff: Re: [BUG] vlan-aware bridge breaks vlan on another port on same gmac
> >
> > On Sat, Jan 21, 2023 at 01:32:42PM +0100, Frank Wunderlich wrote:
> > > so first patch fixes the behaviour on bpi-r3 (mt7531)...but maybe mt7530 need the tagging on cpu-port
> > >
> > > > Can you try the second patch instead of the first one? Without digging
> > > > deeply into mt7530 hardware docs, that's the best chance of making
> > > > things work without changing how the hardware operates.
> > >
> > > second patch works for wan, but vlan on bridge is broken, no packets receiving my laptop (also no untagged ones).
> >
> > It's hard for me to understand how applying only patch "tag_mtk only
> > combine VLAN tag with MTK tag is user port is VLAN aware" can produce
> > the results you describe... For packets sent to port lan0, nothing
> > should have been changed by that patch, because dsa_port_is_vlan_filtering(dp)
> > should return true.
> >
> > If you can confirm there isn't any mistake in the testing procedure,
> > I'll take a look later today at the hardware documentation and try to
> > figure out why the CPU port is configured the way it is.
> 
> ok, booted again the kernel with first patch ("mt7530 don't make the CPU port a VLAN user port")
> and yes lan0-vlan is broken...
> seems i need to reboot after each lan/wan test to at least clean arp-cache.
> 
> but patch2 ("tag_mtk only combine VLAN tag with MTK tag is user port is VLAN aware") still not
> works on lanbridge vlan (no packet received on target).
> 
> regards Frank

Sorry for the delay and thanks again for testing.

I simply didn't have time to sit down with the hardware documentation
and (re)understand the concepts governing this switch.

I now have the patch below which should have everything working. Would
you mind testing it?

From 9110460832d99c3b3e86ffcda472a27a52cdf259 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Mon, 30 Jan 2023 14:31:17 +0200
Subject: [PATCH] net: dsa: mt7530: don't change PVC_EG_TAG when CPU port
 becomes VLAN-aware

Frank reports that in a mt7530 setup where some ports are standalone and
some are in a VLAN-aware bridge, 8021q uppers of the standalone ports
lose their VLAN tag on xmit, as seen by the link partner.

This seems to occur because once the other ports join the VLAN-aware
bridge, mt7530_port_vlan_filtering() also calls
mt7530_port_set_vlan_aware(ds, cpu_dp->index), and this affects the way
that the switch processes the traffic of the standalone port.

Relevant is the PVC_EG_TAG bit. The MT7530 documentation says about it:

EG_TAG: Incoming Port Egress Tag VLAN Attribution
0: disabled (system default)
1: consistent (keep the original ingress tag attribute)

My interpretation is that this setting applies on the ingress port, and
"disabled" is basically the normal behavior, where the egress tag format
of the packet (tagged or untagged) is decided by the VLAN table
(MT7530_VLAN_EGRESS_UNTAG or MT7530_VLAN_EGRESS_TAG).

But there is also an option of overriding the system default behavior,
and for the egress tagging format of packets to be decided not by the
VLAN table, but simply by copying the ingress tag format (if ingress was
tagged, egress is tagged; if ingress was untagged, egress is untagged;
aka "consistent). This is useful in 2 scenarios:

- VLAN-unaware bridge ports will always encounter a miss in the VLAN
  table. They should forward a packet as-is, though. So we use
  "consistent" there. See commit e045124e9399 ("net: dsa: mt7530: fix
  tagged frames pass-through in VLAN-unaware mode").

- Traffic injected from the CPU port. The operating system is in god
  mode; if it wants a packet to exit as VLAN-tagged, it sends it as
  VLAN-tagged. Otherwise it sends it as VLAN-untagged*.

*This is true only if we don't consider the bridge TX forwarding offload
feature, which mt7530 doesn't support.

So for now, make the CPU port always stay in "consistent" mode to allow
software VLANs to be forwarded to their egress ports with the VLAN tag
intact, and not stripped.

Link: https://lore.kernel.org/netdev/trinity-e6294d28-636c-4c40-bb8b-b523521b00be-1674233135062@3c-app-gmx-bs36/
Fixes: e045124e9399 ("net: dsa: mt7530: fix tagged frames pass-through in VLAN-unaware mode")
Reported-by: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mt7530.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 616b21c90d05..3a15015bc409 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1302,14 +1302,26 @@ mt7530_port_set_vlan_aware(struct dsa_switch *ds, int port)
 		if (!priv->ports[port].pvid)
 			mt7530_rmw(priv, MT7530_PVC_P(port), ACC_FRM_MASK,
 				   MT7530_VLAN_ACC_TAGGED);
-	}
 
-	/* Set the port as a user port which is to be able to recognize VID
-	 * from incoming packets before fetching entry within the VLAN table.
-	 */
-	mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK | PVC_EG_TAG_MASK,
-		   VLAN_ATTR(MT7530_VLAN_USER) |
-		   PVC_EG_TAG(MT7530_VLAN_EG_DISABLED));
+		/* Set the port as a user port which is to be able to recognize
+		 * VID from incoming packets before fetching entry within the
+		 * VLAN table.
+		 */
+		mt7530_rmw(priv, MT7530_PVC_P(port),
+			   VLAN_ATTR_MASK | PVC_EG_TAG_MASK,
+			   VLAN_ATTR(MT7530_VLAN_USER) |
+			   PVC_EG_TAG(MT7530_VLAN_EG_DISABLED));
+	} else {
+		/* Also set CPU ports to the "user" VLAN port attribute, to
+		 * allow VLAN classification, but keep the EG_TAG attribute as
+		 * "consistent" (i.o.w. don't change its value) for packets
+		 * received by the switch from the CPU, so that tagged packets
+		 * are forwarded to user ports as tagged, and untagged as
+		 * untagged.
+		 */
+		mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK,
+			   VLAN_ATTR(MT7530_VLAN_USER));
+	}
 }
 
 static void
-- 
2.34.1

