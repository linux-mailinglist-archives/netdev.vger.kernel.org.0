Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32CC25AEDAC
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 16:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbiIFOiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 10:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234253AbiIFOiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 10:38:01 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D526999244
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 07:00:28 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id e20so15566621wri.13
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 07:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=74Hu2hFJEc8BFwZQhDoNAR0+tVtOeAehawBC6mbovfg=;
        b=H7I34+dogLDxG+fWbAMSudgLUL2qlzZre0g3aSrUa0rneVMMl5qZysEuHvjm6hdjKI
         pbtuCm5wYp//jCzGFZqypQe29kHO5Ds8NlDxqS6q2zLDwnNyBZIk7KbsqPaiN4KAe02E
         3vx7vTaWw3idUcybOn/Mb+nOmvZru/9Ez+3gXSQcgtsBz2W8pluDrvK9ZUSylAG1QYaK
         8oc3r08JkITVOVlOZwTc6ALgI5YSZaUzlLSZi1aun1dYqqgC4HMxYhSwNyhegLQEnFw5
         Rb1m8yFf99qPf7GCDAlkL/I0XCFT+EVLKCydG/ulIABsZ4fgbtms9wX8jiAvMFiG1duG
         wqFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=74Hu2hFJEc8BFwZQhDoNAR0+tVtOeAehawBC6mbovfg=;
        b=FIxSJ0bsBQ4HmLdFQAo3hhdhj+uXf52hHIDi/bBm2mS4vmk2m1zl0dedPjd+LkG8DD
         NlkboQ1a97kGUJCB8W3qLulhbNaLvP2xZDRjlpze9wV+2pAxPCAenh1gtjtquW/Jf7aJ
         HvQIPNvgd8US47VQLgTIAmSWNL/AXzU/I4srdXZ2UfzNjl48zROVSBM5nSMzQLaM5301
         7P6/73BmKtB74H51bSHYSAZyiuZtndA5P3FllTEJYYSLCn+GFmR4HOlYlkkf9etEeEPH
         q0lbd5ScXP4v8+g7YuNNx/JzhT8kq6CpMPB6PfKozX/QRJDnu38WssIGLNcwJlgdtdDh
         vqow==
X-Gm-Message-State: ACgBeo1ky6s4c2eJYFYRwTbIncghb2M2NQihbRTUKolq8bTtxsqQ6b8m
        vMP/r3K49OKlGeGZqCxdNGrm2jYb1A6y9yfF
X-Google-Smtp-Source: AA6agR6WsCkHcX6O40+LnbDM1qtsX6s1geDWRb7VLq8Gsn/e9cYkDSMjJX/MN3bmLnSRfb7F/xlDZQ==
X-Received: by 2002:a17:907:16a0:b0:741:833b:c4c9 with SMTP id hc32-20020a17090716a000b00741833bc4c9mr30035873ejc.524.1662472316161;
        Tue, 06 Sep 2022 06:51:56 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id by12-20020a0564021b0c00b00445e1489313sm8413309edb.94.2022.09.06.06.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 06:51:55 -0700 (PDT)
Date:   Tue, 6 Sep 2022 16:51:53 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v4 3/6] net: dsa: Introduce dsa tagger data
 operation.
Message-ID: <20220906135153.kkvw4oxe34or5dai@skbuf>
References: <20220906063450.3698671-1-mattias.forsblad@gmail.com>
 <20220906063450.3698671-4-mattias.forsblad@gmail.com>
 <20220906063450.3698671-1-mattias.forsblad@gmail.com>
 <20220906063450.3698671-4-mattias.forsblad@gmail.com>
 <YxdGR/TPuNf7E0w1@lunn.ch>
 <YxdGR/TPuNf7E0w1@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxdGR/TPuNf7E0w1@lunn.ch>
 <YxdGR/TPuNf7E0w1@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 03:08:23PM +0200, Andrew Lunn wrote:
> >  		switch (code) {
> >  		case DSA_CODE_FRAME2REG:
> > -			/* Remote management is not implemented yet,
> > -			 * drop.
> > -			 */
> > +			tagger_data = ds->tagger_data;
> > +			if (likely(tagger_data->decode_frame2reg))
> > +				tagger_data->decode_frame2reg(dev, skb);
> >  			return NULL;
> >  		case DSA_CODE_ARP_MIRROR:
> >  		case DSA_CODE_POLICY_MIRROR:
> > @@ -323,6 +326,25 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
> >  	return skb;
> >  }
>   
> > +static void dsa_tag_disconnect(struct dsa_switch *ds)
> > +{
> > +	kfree(ds->tagger_data);
> > +	ds->tagger_data = NULL;
> > +}
> 
> 
> Probably a question for Vladimir.
> 
> Is there a potential use after free here? Is it guaranteed that the
> masters dev->dsa_ptr will be cleared before the disconnect function is
> called?

There is no use after free because there is no free...
There are 3 cases of tag protocol disconnect, one is on error path of
bidirectional connection (handled properly), another is on tag protocol
change (handled properly; we only allow it with the master down), and
another is on switch driver removal (handled incorrectly, we don't do
anything here).

The following patch is compile tested only. However it should answer
your question of order of operations too.

From d93b2ddf0e0f4e82d6b0bac4591b346e8cd0fdb9 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 6 Sep 2022 16:24:41 +0300
Subject: [PATCH] net: dsa: don't leak tagger-owned storage on switch driver
 unbind

In the initial commit dc452a471dba ("net: dsa: introduce tagger-owned
storage for private and shared data"), we had a call to
tag_ops->disconnect(dst) issued from dsa_tree_free(), which is called at
tree teardown time.

There were problems with connecting to a switch tree as a whole, so this
got reworked to connecting to individual switches within the tree. In
this process, tag_ops->disconnect(ds) was made to be called only from
switch.c (cross-chip notifiers emitted as a result of dynamic tag proto
changes), but the normal driver teardown code path wasn't replaced with
anything.

Solve this problem by adding a function that does the opposite of
dsa_switch_setup_tag_protocol(), which is called from the equivalent
spot in dsa_switch_teardown(). The positioning here also ensures that we
won't have any use-after-free in tagging protocol (*rcv) ops, since the
teardown sequence is as follows:

dsa_tree_teardown
-> dsa_tree_teardown_master
   -> dsa_master_teardown
      -> unsets master->dsa_ptr, making no further packets match the
         ETH_P_XDSA packet type handler
-> dsa_tree_teardown_ports
   -> dsa_port_teardown
      -> dsa_slave_destroy
         -> unregisters DSA net devices, there is even a synchronize_net()
            in unregister_netdevice_many()
-> dsa_tree_teardown_switches
   -> dsa_switch_teardown
      -> dsa_switch_teardown_tag_protocol
         -> finally frees the tagger-owned storage

Fixes: 7f2973149c22 ("net: dsa: make tagging protocols connect to individual switches from a tree")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index ed56c7a554b8..4bb0a203b85c 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -864,6 +864,14 @@ static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
 	return err;
 }
 
+static void dsa_switch_teardown_tag_protocol(struct dsa_switch *ds)
+{
+	const struct dsa_device_ops *tag_ops = ds->dst->tag_ops;
+
+	if (tag_ops->disconnect)
+		tag_ops->disconnect(ds);
+}
+
 static int dsa_switch_setup(struct dsa_switch *ds)
 {
 	struct dsa_devlink_priv *dl_priv;
@@ -967,6 +975,8 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 		ds->slave_mii_bus = NULL;
 	}
 
+	dsa_switch_teardown_tag_protocol(ds);
+
 	if (ds->ops->teardown)
 		ds->ops->teardown(ds);
 
-- 
2.34.1

> 
> Also, the receive function checks for tagger_data->decode_frame2reg,
> but does not check for tagger_data != NULL.
> 
> This is just a straight copy of tag_qca, so if there are issues here,
> they are probably not new issues.

It checks for tagger_data->decode_frame2reg because the "dsa" or "edsa"
tagging protocol drivers could also be connected to the dsa_loop driver,
for testing. That driver won't populate tagger_data->decode_frame2reg().
What is supposed to happen is that if the tagging protocol driver has no
subscriber for management Ethernet frames, nothing happens with them,
they are just freed right away. This is the model of separate switch
driver and tag protocol driver.
