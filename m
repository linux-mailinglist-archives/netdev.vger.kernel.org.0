Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A14D69D780
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 01:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbjBUA1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 19:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjBUA1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 19:27:23 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEEC22A11
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 16:27:17 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id f13so10206664edz.6
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 16:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ylC8QvuGejK5fzLfmum5pxntYgGt+IyIVJxUSBqK3cI=;
        b=byl9l/CbAT/GOTLuotLsZ98BON7L5A0U1L2WpfQKKKUTJmEaefB2GwJXUtOR+bOmZe
         ODQrGo6igQQ3qw4Sd3VAylAxJG8+ZJiWnrPgJjflxCrNaXH7RiYxNE7VJv3O7BFp061A
         mbC4SxKr6ikI3B12wrkB0sO5e9im3XYe9xp3911hiflMAB0ttn4ubmj087C7fJ/0X5Kz
         GsHDw6rBbMZjofKohYsVLmGmUD8bYKlvWc6dTDheqEK4ffo3X2o86gh8LTGxObO7hc8+
         9JFbHo5ISd1LvwCSN1JxdEBVeE+qsgQ/rCESMlWP2VqIg27hxZJjaJXAbUcTPPCZh/7q
         29mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ylC8QvuGejK5fzLfmum5pxntYgGt+IyIVJxUSBqK3cI=;
        b=c+UabV4kLneqfAvqqhdQPGCq3tCk0fRLJOX68Ppx9PQoSNLa9nRAHF9b9FoV9IBU4t
         ENqFI+xTN96LZdRQXWi5C57kokenbeuO6koXr7cJ55KFuLihm/Tvv5OHGK8I0hlLK2/J
         t/4AhYZrSlQ2TxhjN1btXO29mPAqCMeWTrEemQ+ZnhzTjoyNmDSVXsV+3bPUwfgjKMA3
         ttArN828Y1kfwdF/WajEq0dUFBY3u/Tqr1vZNMMNEM1KT6EDonWN6wOiBD0N5kss+sYm
         w8OZRBdLjdg1LlGe0lEO+RX2eTyHgHXvyilgodKu55X6fG/sB9qY53/ZemRv4UAYkw+m
         WYFg==
X-Gm-Message-State: AO0yUKWZ7klbxw34W2x/WNuoNHmp8qv2ARas6yXZQWhFB8xBf+yOksu1
        eFzjdaMUqqqDG3p7mbmz1zc=
X-Google-Smtp-Source: AK7set91smbwQ1b3RQ5/lLnWrEsL/O2AexkOHin15/cINc56kX0RxL4JKPozQqLhvmQYqOGm+2sQ/Q==
X-Received: by 2002:a17:907:6025:b0:878:683c:f0d1 with SMTP id fs37-20020a170907602500b00878683cf0d1mr8638445ejc.38.1676939236192;
        Mon, 20 Feb 2023 16:27:16 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id p9-20020a17090653c900b008b13039003csm6396525ejo.166.2023.02.20.16.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 16:27:15 -0800 (PST)
Date:   Tue, 21 Feb 2023 02:27:13 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Choose a default DSA CPU port
Message-ID: <20230221002713.qdsabxy7y74jpbm4@skbuf>
References: <5833a789-fa5a-ce40-f8e5-d91f4969a7c4@arinc9.com>
 <20230218205204.ie6lxey65pv3mgyh@skbuf>
 <a4936eb8-dfaa-e2f8-b956-75e86546fbf3@arinc9.com>
 <trinity-4025f060-3bb8-4260-99b7-e25cbdcf9c27-1676800164589@3c-app-gmx-bs35>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-4025f060-3bb8-4260-99b7-e25cbdcf9c27-1676800164589@3c-app-gmx-bs35>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 19, 2023 at 10:49:24AM +0100, Frank Wunderlich wrote:
> > I'm leaving this to Frank to explain.
> 
> yes only looking at phy speed may not be the right way, but one way...i would like the hw driver
> choose the right port which is used as default.
> 
> currently i try to figure out why dsa_tree_setup_cpu_ports does not use dsa_tree_find_first_cpu.
> the loops looks same, first returns the first one, second skips all further which should be same
> and at the end it calls dsa_tree_find_first_cpu for all ports not yet having a cpu-port assigned...

Because by the time dsa_tree_find_first_cpu() has been called, all user
and cascade ports got their dp->cpu_dp pointers resolved by the earlier
logic, which prefers a CPU port local to that switch before assigning
CPU ports which are potentially on remote switches.

> looks starnge to me, but maybe i oversee a detail.

Yeah, at least one.

> does not yet compile because i do not know how to get dsa_switch from dsa_switch_tree,
> but basicly shows how i would do it (select the right cpu at driver level without dts properties).

Basically what you want is something like this:

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 3a15015bc409..c4771a848319 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -393,6 +393,20 @@ mt7530_fdb_write(struct mt7530_priv *priv, u16 vid,
 		mt7530_write(priv, MT7530_ATA1 + (i * 4), reg[i]);
 }
 
+/* If port 6 is available as a CPU port, always prefer that as the default,
+ * otherwise don't care.
+ */
+static struct dsa_port *
+mt7530_preferred_default_local_cpu_port(struct dsa_switch *ds)
+{
+	struct dsa_port *cpu_dp = dsa_to_port(ds, 6);
+
+	if (dsa_port_is_cpu(cpu_dp))
+		return cpu_dp;
+
+	return NULL;
+}
+
 /* Setup TX circuit including relevant PAD and driving */
 static int
 mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
@@ -3152,6 +3166,7 @@ static int mt753x_set_mac_eee(struct dsa_switch *ds, int port,
 static const struct dsa_switch_ops mt7530_switch_ops = {
 	.get_tag_protocol	= mtk_get_tag_protocol,
 	.setup			= mt753x_setup,
+	.preferred_default_local_cpu_port = mt7530_preferred_default_local_cpu_port,
 	.get_strings		= mt7530_get_strings,
 	.get_ethtool_stats	= mt7530_get_ethtool_stats,
 	.get_sset_count		= mt7530_get_sset_count,
diff --git a/include/net/dsa.h b/include/net/dsa.h
index a15f17a38eca..5db43be2a464 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -973,6 +973,14 @@ struct dsa_switch_ops {
 			       struct phy_device *phy);
 	void	(*port_disable)(struct dsa_switch *ds, int port);
 
+	/*
+	 * Compatibility between device trees defining multiple CPU ports and
+	 * drivers which are not ok to use by default the numerically first CPU
+	 * port of a switch for its local ports. This can return NULL, meaning
+	 * "don't know/don't care".
+	 */
+	struct dsa_port *(*preferred_default_local_cpu_port)(struct dsa_switch *ds);
+
 	/*
 	 * Port's MAC EEE settings
 	 */
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index e5f156940c67..6cd8607a3928 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -402,6 +402,24 @@ static int dsa_tree_setup_default_cpu(struct dsa_switch_tree *dst)
 	return 0;
 }
 
+static struct dsa_port *
+dsa_switch_preferred_default_local_cpu_port(struct dsa_switch *ds)
+{
+	struct dsa_port *cpu_dp;
+
+	if (!ds->ops->preferred_default_local_cpu_port)
+		return NULL;
+
+	cpu_dp = ds->ops->preferred_default_local_cpu_port(ds);
+	if (!cpu_dp)
+		return NULL;
+
+	if (WARN_ON(!dsa_port_is_cpu(cpu_dp) || cpu_dp->ds != ds))
+		return NULL;
+
+	return cpu_dp;
+}
+
 /* Perform initial assignment of CPU ports to user ports and DSA links in the
  * fabric, giving preference to CPU ports local to each switch. Default to
  * using the first CPU port in the switch tree if the port does not have a CPU
@@ -409,12 +427,16 @@ static int dsa_tree_setup_default_cpu(struct dsa_switch_tree *dst)
  */
 static int dsa_tree_setup_cpu_ports(struct dsa_switch_tree *dst)
 {
-	struct dsa_port *cpu_dp, *dp;
+	struct dsa_port *preferred_cpu_dp, *cpu_dp, *dp;
 
 	list_for_each_entry(cpu_dp, &dst->ports, list) {
 		if (!dsa_port_is_cpu(cpu_dp))
 			continue;
 
+		preferred_cpu_dp = dsa_switch_preferred_default_local_cpu_port(cpu_dp->ds);
+		if (preferred_cpu_dp && preferred_cpu_dp != cpu_dp)
+			continue;
+
 		/* Prefer a local CPU port */
 		dsa_switch_for_each_port(dp, cpu_dp->ds) {
 			/* Prefer the first local CPU port found */

> imho there is no way to ensure both ways backwards compatible..

if you say so... can't argue with that

> in the moment you add port5 it will be the default cpu-port which is
> what we try to "fix" here. either driver should select the better one
> (drivercode not backported if no real fix) or it needs a setting in
> dts (which is not read in older driver/core).

If changes to driver code to resolve a device tree compatibility issue
are not treated as stable-worthy bug fixes, then the implication is that
the whole thing with device tree as stable ABI is just a moronic and
pointless effort.

Have you ever tried fixing some kind of issue similar to this and gotten
adverse feedback?

There are 2 ways of addressing the compatibility issue for stable
kernels. Either port 6 always gets preferred over port 5, or the patches
which make port 5 work as a CPU port are resubmitted as stable material.
I was hoping you'd be able to bring an argument why preferring port 6
would unconditionally be a better choice than working with the first
port that's given: $insert_reason_here.
