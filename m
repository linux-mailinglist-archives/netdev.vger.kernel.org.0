Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D718693A84
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 23:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjBLWkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 17:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBLWkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 17:40:09 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156E79EC8;
        Sun, 12 Feb 2023 14:40:08 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id cq19so7918021edb.5;
        Sun, 12 Feb 2023 14:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4/Grc85MiBD37njhsVZjX1/GXp5d4F7f5liqxfFI2J4=;
        b=c9CsVnYxto3zijMk//LjW+/OjK7ut9fL6CWiGg3iOqIcc8dkD6yT5ymngGPVW6vYJA
         Y5we7Yq0amNxkzYAmRsoLZzZ7ZkcVpNj/sEn3XzkOIWOe3ti7790APjv8cJZ4pR4A9tG
         q1uwGavR5OLWZNnXppT2VjjBTcGbtA3/dG3halrbUj0E/2qIbidkhKeCX69xEKZLE7Ho
         vmeJ7mhVJZAEexPvtht/FBacH5iqiPWGnfBt2JxJA90bHG2AlkX2TjdmsGh+CUFjohSG
         glER6NXgdMiuJvgMhaoB6d7yvgVFYZie3R7GbMf++f3526bNLN4Enq8yEAuTE/pC6Vxb
         Yo0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4/Grc85MiBD37njhsVZjX1/GXp5d4F7f5liqxfFI2J4=;
        b=e413yiKO9VJnUTyhG+/jUdBdeC+H01z9GGdTaf6c1vgCtJ/GpI+WvYAI55d2CQqmJL
         XotT/HCLqNJ1G6dbl9R53BmHSBHJ3Mde4/H+/syPMYExdYNsQ5j6zI2fwdStM028W7OJ
         PbjMEtMDUis1NiNmrysiADaay/bUD/aazFDp8mBkbpMy40eQZ2czYQ/F3elIhOVwwZxu
         8Pv/tMvRBSUTHdaVhAxhQ3CDEQWeNxl7WayO2ckFh+FYiWj9qqB/92xUkHFy2O35AUrG
         Vcx2GIq3RuBfdmjqZ3HabWT3Um94PTF+RuKtFtH2vNy6Ra29zSF6oBd+YI8LxGOKtU9D
         7c4Q==
X-Gm-Message-State: AO0yUKUd1HTOrUQJIr9HuXj/L5w8jQ6lnejp0xDSwxTNzflWXhNe/L2n
        8VykGlwz/2xALsVAa83wzVE=
X-Google-Smtp-Source: AK7set/PUZm5S2F7bk6fyv0swICJyLeA2Gf9YQ7KuxWtuAFSs9dL1AS2j8wBIzXeMOs5lsxcfXzBUA==
X-Received: by 2002:a50:950e:0:b0:4a2:3637:5be2 with SMTP id u14-20020a50950e000000b004a236375be2mr24152057eda.39.1676241605449;
        Sun, 12 Feb 2023 14:40:05 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id y4-20020a50ce04000000b004a27046b7a7sm5820051edi.73.2023.02.12.14.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 14:40:04 -0800 (PST)
Date:   Sun, 12 Feb 2023 23:40:03 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org, bagasdotme@gmail.com
Subject: Re: [PATCH v5 ethtool-next 1/1] add support for IEEE 802.3cg-2019
 Clause 148
Message-ID: <Y+lqw1NPWdlMexNZ@gvm01>
References: <cover.1675327734.git.piergiorgio.beruto@gmail.com>
 <d51013e0bc617651c0e6d298f47cc6b82c0ffa88.1675327734.git.piergiorgio.beruto@gmail.com>
 <20230212195723.y32z2m4j4tbt4lx6@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230212195723.y32z2m4j4tbt4lx6@lion.mk-sys.cz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 12, 2023 at 08:57:23PM +0100, Michal Kubecek wrote:
> On Thu, Feb 02, 2023 at 09:53:15AM +0100, Piergiorgio Beruto wrote:
> > This patch adds support for the Physical Layer Collision Avoidance
> > Reconciliation Sublayer which was introduced in the IEEE 802.3
> > standard by the 802.3cg working group in 2019.
> > 
> > The ethtool interface has been extended as follows:
> > - show if the device supports PLCA when ethtool is invoked without FLAGS
> >    - additionally show what PLCA version is supported
> >    - show the current PLCA status
> > - add FLAGS for getting and setting the PLCA configuration
> > 
> > Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> 
> Sorry for the delay, I missed the patch in the mailing list and did not
> get it directly into my inbox. Thankfully I noticed it in patchwork.
No worries, thanks for taking time to review this :-)
> 
> > ---
> >  Makefile.am        |   1 +
> >  ethtool.8.in       |  83 ++++++++++++-
> >  ethtool.c          |  21 ++++
> >  netlink/extapi.h   |   6 +
> >  netlink/plca.c     | 296 +++++++++++++++++++++++++++++++++++++++++++++
> >  netlink/settings.c |  82 ++++++++++++-
> >  6 files changed, 486 insertions(+), 3 deletions(-)
> >  create mode 100644 netlink/plca.c
> > 
> > diff --git a/Makefile.am b/Makefile.am
> > index 999e7691e81c..cbc1f4f5fdf2 100644
> > --- a/Makefile.am
> > +++ b/Makefile.am
> > @@ -42,6 +42,7 @@ ethtool_SOURCES += \
> >  		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
> >  		  netlink/module-eeprom.c netlink/module.c netlink/rss.c \
> >  		  netlink/desc-rtnl.c netlink/cable_test.c netlink/tunnels.c \
> > +		  netlink/plca.c \
> >  		  uapi/linux/ethtool_netlink.h \
> >  		  uapi/linux/netlink.h uapi/linux/genetlink.h \
> >  		  uapi/linux/rtnetlink.h uapi/linux/if_link.h \
> > diff --git a/ethtool.8.in b/ethtool.8.in
> > index eaf6c55a84bf..c43c6d8b5263 100644
> > --- a/ethtool.8.in
> > +++ b/ethtool.8.in
> [...]
> > +.TP
> > +.BI node\-cnt \ N
> > +The node-cnt [1 .. 255] should be set after the maximum number of nodes that
> > +can be plugged to the multi-drop network. This parameter regulates the minimum
> > +length of the PLCA cycle. Therefore, it is only meaningful for the coordinator
> > +node (\fBnod-id\fR = 0). Setting this parameter on a follower node has no
> > +effect. The \fBnode\-cnt\fR parameter maps to IEEE 802.3cg-2019 clause 
> > +30.16.1.1.3 (aPLCANodeCount).
> > +.TP
> > +.BI to\-tmr \ N
> > +The TO timer parameter sets the value of the transmit opportunity timer in 
> > +bit-times, and shall be set equal across all the nodes sharing the same
> > +medium for PLCA to work. The default value of 32 is enough to cover a link of
> > +roughly 50 mt. This parameter maps to  IEEE 802.3cg-2019 clause 30.16.1.1.5
> > +(aPLCATransmitOpportunityTimer).
> > +.TP
> > +.BI burst\-cnt \ N
> > +The \fBburst\-cnt\fR parameter [0 .. 255] indicates the extra number of packets
> > +that the node is allowed to send during a single transmit opportunity.
> > +By default, this attribute is 0, meaning that the node can send a sigle frame 
> > +per TO. When greater than 0, the PLCA RS keeps the TO after any transmission,
> > +waiting for the MAC to send a new frame for up to \fBburst\-tmr\fR BTs. This can
> > +only happen a number of times per PLCA cycle up to the value of this parameter.
> > +After that, the burst is over and the normal counting of TOs resumes.
> > +This parameter maps to IEEE 802.3cg-2019 clause 30.16.1.1.6 (aPLCAMaxBurstCount).
> > +.TP
> > +.BI burst\-tmr \ N
> > +The \fBburst\-tmr\fR parameter [0 .. 255] sets how many bit-times the PLCA RS
> > +waits for the MAC to initiate a new transmission when \fBburst\-cnt\fR is 
> > +greater than 0. If the MAC fails to send a new frame within this time, the burst
> > +ends and the counting of TOs resumes. Otherwise, the new frame is sent as part
> > +of the current burst. This parameter maps to IEEE 802.3cg-2019 clause
> > +30.16.1.1.7 (aPLCABurstTimer). The value of \fBburst\-tmr\fR should be set
> > +greater than the Inter-Frame-Gap (IFG) time of the MAC (plus some margin)
> > +for PLCA burst mode to work as intended.
> 
> There are some trailing spaces in these paragraphs.
Uh, sorry, thanks for noticing!
> 
> > +.RE
> > +.TP
> > +.B \-\-get\-plca\-status
> > +Show the current PLCA status for the given interface. If \fBon\fR, the PHY is
> > +successfully receiving or generating the BEACON signal. If \fBoff\fR, the PLCA
> > +function is temporarily disabled and the PHY is operating in plain CSMA/CD mode.
> >  .SH BUGS
> >  Not supported (in part or whole) on all network drivers.
> >  .SH AUTHOR
> > @@ -1532,7 +1610,8 @@ Alexander Duyck,
> >  Sucheta Chakraborty,
> >  Jesse Brandeburg,
> >  Ben Hutchings,
> > -Scott Branden.
> > +Scott Branden,
> > +Piergiorgio Beruto.
> >  .SH AVAILABILITY
> >  .B ethtool
> >  is available from
> 
> Do you have a strong reason to add your name here? In general, I rather
> see lists like these as a historical relic. In this case, the list has
> not been updated since 2017 and even before that, I'm pretty sure it is
> only a small fraction of contributors. IMHO the git log serves the
> purpose much better today.
Ah, not really. I just read through the doc and finding this I
assumed it was a list to be populated with contributors! No real
reasons.
> 
> [...]
> > diff --git a/netlink/settings.c b/netlink/settings.c
> > index 1107082167d4..a349e270dff9 100644
> > --- a/netlink/settings.c
> > +++ b/netlink/settings.c
> [...]
> > @@ -923,7 +987,10 @@ int nl_gset(struct cmd_context *ctx)
> >  	    netlink_cmd_check(ctx, ETHTOOL_MSG_LINKINFO_GET, true) ||
> >  	    netlink_cmd_check(ctx, ETHTOOL_MSG_WOL_GET, true) ||
> >  	    netlink_cmd_check(ctx, ETHTOOL_MSG_DEBUG_GET, true) ||
> > -	    netlink_cmd_check(ctx, ETHTOOL_MSG_LINKSTATE_GET, true))
> > +	    netlink_cmd_check(ctx, ETHTOOL_MSG_LINKSTATE_GET, true) ||
> > +	    netlink_cmd_check(ctx, ETHTOOL_MSG_LINKSTATE_GET, true) ||
> 
> You accidentally duplicated the line here.
Thanks for noticing.
> 
> > +	    netlink_cmd_check(ctx, ETHTOOL_MSG_PLCA_GET_CFG, true) ||
> > +	    netlink_cmd_check(ctx, ETHTOOL_MSG_PLCA_GET_STATUS, true))
> >  		return -EOPNOTSUPP;
> >  
> >  	nlctx->suppress_nlerr = 1;
> > @@ -943,6 +1010,12 @@ int nl_gset(struct cmd_context *ctx)
> >  	if (ret == -ENODEV)
> >  		return ret;
> >  
> > +	ret = gset_request(nlctx, ETHTOOL_MSG_PLCA_GET_CFG,
> > +			   ETHTOOL_A_PLCA_HEADER, plca_cfg_reply_cb);
> > +
> > +	if (ret == -ENODEV)
> > +		return ret;
> > +
> >  	ret = gset_request(nlctx, ETHTOOL_MSG_DEBUG_GET, ETHTOOL_A_DEBUG_HEADER,
> >  			   debug_reply_cb);
> >  	if (ret == -ENODEV)
> > @@ -950,6 +1023,13 @@ int nl_gset(struct cmd_context *ctx)
> >  
> >  	ret = gset_request(nlctx, ETHTOOL_MSG_LINKSTATE_GET,
> >  			   ETHTOOL_A_LINKSTATE_HEADER, linkstate_reply_cb);
> > +
> > +	if (ret == -ENODEV)
> > +		return ret;
> > +
> > +
> > +	ret = gset_request(nlctx, ETHTOOL_MSG_PLCA_GET_STATUS,
> > +			   ETHTOOL_A_PLCA_HEADER, plca_status_reply_cb);
> >  	if (ret == -ENODEV)
> >  		return ret;
> 
> Please make the whitespace consistent with existing code, i.e. no empty
> line between gset_request() call and the test of ret and no double empty
> line.
Got it!
> 
> As I have no actual objections, I can adjust the whitespace issues here
> and in ethtool.8.in if you would prefer to avoid v6 before moving on to
> the MAC merge series.
Oh, thank you! I really appreciate this.
--Piergiorgio

> 
> Michal


