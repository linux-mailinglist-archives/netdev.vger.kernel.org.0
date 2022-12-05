Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 907B0642A4E
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 15:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbiLEOXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 09:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbiLEOX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 09:23:28 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E240C1D300;
        Mon,  5 Dec 2022 06:23:04 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id fc4so21216549ejc.12;
        Mon, 05 Dec 2022 06:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XLE/PDqlXDCt0O91r35ZSTDJXmS9qK/JhviJ5VPvHyw=;
        b=dQDTvb+5Zs4F2Pe2KHuI1HTk7qGG3hGtOtrf8BF5W1+FGzsyUhGh7sKP7yBBcRAf6F
         89X8yfR57OCRZJG2vQueUHVDU8HbMIAsJF/yo47mU1E2rhJ7GuaxBvuMrC8j2dVH0Qr8
         NGMWuiHJaot3864b0r0NoSR+OrU+nw7nMo0UPGVQvFLk7NwrDrJXhOS0J5tw1/Z9Zs0h
         KlSa/XZNiCCB/Jimp+yHdNNAqaPjzARJG4tldypadXZDx+prNMz6cxPL+aLBV/tnkRyw
         4I7MOE6pdS7fxzoFfApYcGWPZGI4ClUGpO8lD6akRlqh/BNm76J9X8eZ9dbaIRAurjOK
         bIIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XLE/PDqlXDCt0O91r35ZSTDJXmS9qK/JhviJ5VPvHyw=;
        b=g/o2OkZejB7C2HyI7Y1Bf05WetlrdR0tKVfHMLHWY5nWFvUoYVCfBmdDOiz6MyGDF/
         Wd3dfZagAU3BaTVHpkYea4/2ixthxe3uXKtTIanqaVhz5syFAAvAdFZCh5uQfmxMa5Tx
         eum3rI462j3f3audLg+FNCg3mkiFr+7vD8Ucgzs2MYlc1qSwsZTgieRUMqSQd7dcJVuy
         QDUPE/Q+Ab4sE7inLXGJfSokrRg3h8tupQuDNUHIwtb60aO5PaaVzkt8b2Sq37cZ2AYn
         RC6L8PAtCL4FfEC/ms5xgxCD/mN6XYNf37AVqboUm4Uy0K35cjnMNZgoDqkwOEG6goFK
         QRqA==
X-Gm-Message-State: ANoB5plGB1DJtY7A1/NOrAm7f2UXsJ2RP9hGfuPD2+fn9JgpQl07kevY
        YxLUAHC8MFtF2rP7gm9tsn0=
X-Google-Smtp-Source: AA0mqf66fEQw17YhL7ku5j1fhPL5KMGQElKYwfYSJ7jrkc/U1eKDavqD5VISpIRQYI3s8gudi3tz7A==
X-Received: by 2002:a17:906:d8a6:b0:7c0:b741:8b61 with SMTP id qc6-20020a170906d8a600b007c0b7418b61mr15031717ejb.625.1670250183188;
        Mon, 05 Dec 2022 06:23:03 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id ku11-20020a170907788b00b007c0c91eae04sm3772045ejc.151.2022.12.05.06.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 06:23:02 -0800 (PST)
Date:   Mon, 5 Dec 2022 15:23:11 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/4] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <Y43+z+xJxZiSJpRm@gvm01>
References: <fc3ac4f2d0c28d9c24b909e97791d1f784502a4a.1670204277.git.piergiorgio.beruto@gmail.com>
 <20221205060057.GA10297@pengutronix.de>
 <Y43CDqAjvlAfLK1v@gvm01>
 <20221205102209.GA17619@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221205102209.GA17619@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 11:22:09AM +0100, Oleksij Rempel wrote:
> A comment about name mapping to specification, spec version and reason
> to take one variants instead of other one will be enough Somewhat similar to
> what i did for PoDL. See ETHTOOL_A_PODL_* in
> Documentation/networking/ethtool-netlink.rst and include/uapi/linux/ethtool.h
> 
> It will help people who use spec to review or extend this UAPI. 
What about the following? This is the first time I write the
documentation in this format, hence I would appreciate if you could give
me some feedback prior to regenerating the patches.

Thanks!
Piergiorgio

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index bede24ef44fd..85a7fd6399cb 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1687,6 +1687,136 @@ to control PoDL PSE Admin functions. This option is implementing
 ``IEEE 802.3-2018`` 30.15.1.2.1 acPoDLPSEAdminControl. See
 ``ETHTOOL_A_PODL_PSE_ADMIN_STATE`` for supported values.

+PLCA_GET_CFG
+=======
+
+Gets PLCA RS attributes.
+
+Request contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_A_PLCA_HEADER``              nested  request header
+  =====================================  ======  ==========================
+
+Kernel response contents:
+
+  ======================================  ======  =============================
+  ``ETHTOOL_A_PLCA_HEADER``               nested  reply header
+  ``ETHTOOL_A_PLCA_VERSION``              u16     Supported PLCA management
+                                                  interface standard/version
+  ``ETHTOOL_A_PLCA_ENABLED``              u8      PLCA Admin State
+  ``ETHTOOL_A_PLCA_NODE_ID``              u8      PLCA unique local node ID
+  ``ETHTOOL_A_PLCA_NODE_CNT``             u8      Number of PLCA nodes on the
+                                                  netkork, including the
+						  coordinator
+  ``ETHTOOL_A_PLCA_TO_TMR``               u8      Transmit Opportunity Timer
+                                                  value in bit-times (BT)
+  ``ETHTOOL_A_PLCA_BURST_CNT``            u8      Number of additional packets
+                                                  the node is allowed to send
+						  within a single TO
+  ``ETHTOOL_A_PLCA_BURST_TMR``            u8      Time to wait for the MAC to
+                                                  transmit a new frame before
+						  terminating the burst
+  ======================================  ======  =============================
+
+When set, the optional ``ETHTOOL_A_PLCA_VERSION`` attribute indicates which
+standard and version the PLCA management interface complies to. When not set,
+the interface is vendor-specific and (possibly) supplied by the driver.
+The OPEN Alliance SIG specifies a standard register map for 10BASE-T1S PHYs
+embedding the PLCA Reconcialiation Sublayer. See "10BASE-T1S PLCA Management
+Registers" at https://www.opensig.org/about/specifications/. When this standard
+is supported, ETHTOOL_A_PLCA_VERSION is reported as 0Axx where 'xx' denotes the
+map version (see Table A.1.0 — IDVER bits assignment).
+
+When set, the optional ``ETHTOOL_A_PLCA_ENABLED`` attribute indicates the
+administrative state of the PLCA RS. When not set, the node operates in "plain"
+CSMA/CD mode. This option is corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.1
+aPLCAAdminState / 30.16.1.2.1 acPLCAAdminControl.
+
+When set, the optional ``ETHTOOL_A_PLCA_NODE_ID`` attribute indicates the
+configured local node ID of the PHY. This ID determines which transmit
+opportunity (TO) is reseverd for the node to transmit into. This option is
+corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.4 aPLCALocalNodeID.
+
+When set, the optional ``ETHTOOL_A_PLCA_NODE_CNT`` attribute indicates the
+configured maximum number of PLCA nodes on the mixing-segment. This number
+determines the total number of transmit opportunities generated during a
+PLCA cycle. This attribute is relevant only for the PLCA coordinator, which is
+the node with aPLCALocalNodeID set to 0. Follower nodes ignore this setting.
+This option is corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.3
+aPLCANodeCount.
+
+When set, the optional ``ETHTOOL_A_PLCA_TO_TMR`` attribute indicates the
+configured value of the transmit opportunity timer in bit-times. This value
+must be set equal across all nodes sharing the medium for PLCA to work
+correctly. This option is corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.5
+aPLCATransmitOpportunityTimer.
+
+When set, the optional ``ETHTOOL_A_PLCA_BURST_CNT`` attribute indicates the
+configured number of extra packets that the node is allowed to send during a
+single transmit opportunity. By default, this attribute is 0, meaning that
+the node can only send a sigle frame per TO. When greater than 0, the PLCA RS
+keeps the TO after any transmission, waiting for the MAC to send a new frame
+for up to aPLCABurstTimer BTs. This can only happen a number of times per PLCA
+cycle up to the value of this parameter. After that, the burst is over and the
+normal counting of TOs resumes. This option is corresponding to
+``IEEE 802.3cg-2019`` 30.16.1.1.6 aPLCAMaxBurstCount.
+
+When set, the optional ``ETHTOOL_A_PLCA_BURST_TMR`` attribute indicates how
+many bit-times the PLCA RS waits for the MAC to initiate a new transmission
+when aPLCAMaxBurstCount is greater than 0. If the MAC fails to send a new
+frame within this time, the burst ends and the counting of TOs resumes.
+Otherwise, the new frame is sent as part of the current burst. This option
+is corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.7 aPLCABurstTimer.
+
+PLCA_SET_CFG
+=======
+
+Sets PLCA RS parameters.
+
+Request contents:
+
+  ======================================  ======  =============================
+  ``ETHTOOL_A_PLCA_HEADER``               nested  request header
+  ``ETHTOOL_A_PLCA_ENABLED``              u8      PLCA Admin State
+  ``ETHTOOL_A_PLCA_NODE_ID``              u8      PLCA unique local node ID
+  ``ETHTOOL_A_PLCA_NODE_CNT``             u8      Number of PLCA nodes on the
+                                                  netkork, including the
+						  coordinator
+  ``ETHTOOL_A_PLCA_TO_TMR``               u8      Transmit Opportunity Timer
+                                                  value in bit-times (BT)
+  ``ETHTOOL_A_PLCA_BURST_CNT``            u8      Number of additional packets
+                                                  the node is allowed to send
+						  within a single TO
+  ``ETHTOOL_A_PLCA_BURST_TMR``            u8      Time to wait for the MAC to
+                                                  transmit a new frame before
+						  terminating the burst
+  ======================================  ======  =============================
+
+For a description of each attribute, see ``PLCA_GET_CFG``.
+
+PLCA_GET_STATUS
+=======
+
+Gets PLCA RS status information.
+
+Request contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_A_PLCA_HEADER``              nested  request header
+  =====================================  ======  ==========================
+
+Kernel response contents:
+
+  ======================================  ======  =============================
+  ``ETHTOOL_A_PLCA_HEADER``               nested  reply header
+  ``ETHTOOL_A_PLCA_STATUS``               u8      PLCA RS operational status
+  ======================================  ======  =============================
+
+When set, the ``ETHTOOL_A_PLCA_STATUS`` attribute indicates whether the node is
+detecting the presence of the BEACON on the network. This flag is
+corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.2 aPLCAStatus.
+
 Request translation
 ===================

@@ -1788,4 +1918,7 @@ are netlink only.
   n/a                                 ``ETHTOOL_MSG_PHC_VCLOCKS_GET``
   n/a                                 ``ETHTOOL_MSG_MODULE_GET``
   n/a                                 ``ETHTOOL_MSG_MODULE_SET``
+  n/a                                 ``ETHTOOL_MSG_PLCA_GET_CFG``
+  n/a                                 ``ETHTOOL_MSG_PLCA_SET_CFG``
+  n/a                                 ``ETHTOOL_MSG_PLCA_GET_STATUS``
   =================================== =====================================

