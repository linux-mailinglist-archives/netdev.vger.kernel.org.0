Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5805ACEB4
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 11:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235589AbiIEJU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 05:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235294AbiIEJUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 05:20:24 -0400
Received: from 7of9.schinagl.nl (7of9.connected.by.freedominter.net [185.238.129.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010362FFD2;
        Mon,  5 Sep 2022 02:20:21 -0700 (PDT)
Received: from localhost (7of9.are-b.org [127.0.0.1])
        by 7of9.schinagl.nl (Postfix) with ESMTP id B5252186D1D0;
        Mon,  5 Sep 2022 11:20:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=schinagl.nl; s=7of9;
        t=1662369619; bh=cofEbB06/+acWIWgi66P5zqIUBr/NcKKXWfVW34kB2U=;
        h=From:To:Cc:Subject:Date;
        b=IijrGzuamKoXvTWgfG2Ohsyb0feYqq5frk0b2XrBX4Vv7tbyRJkaC3lnsrC70jrET
         uzjMPFDlZ+u1xG23b0iRcHU4PPY48kJbtUPkw1R/WEHdJu9jAEL6XF15axYomoerRF
         dCSU5a0lqC0JqfBg2SiRGMQUTPNaWXAFGephqjjs=
X-Virus-Scanned: amavisd-new at schinagl.nl
Received: from 7of9.schinagl.nl ([127.0.0.1])
        by localhost (7of9.schinagl.nl [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 1XIIXhNEnYha; Mon,  5 Sep 2022 11:20:19 +0200 (CEST)
Received: from valexia.are-b.org (unknown [10.2.11.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by 7of9.schinagl.nl (Postfix) with ESMTPSA id E9885186D1CB;
        Mon,  5 Sep 2022 11:20:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=schinagl.nl; s=7of9;
        t=1662369619; bh=cofEbB06/+acWIWgi66P5zqIUBr/NcKKXWfVW34kB2U=;
        h=From:To:Cc:Subject:Date;
        b=IijrGzuamKoXvTWgfG2Ohsyb0feYqq5frk0b2XrBX4Vv7tbyRJkaC3lnsrC70jrET
         uzjMPFDlZ+u1xG23b0iRcHU4PPY48kJbtUPkw1R/WEHdJu9jAEL6XF15axYomoerRF
         dCSU5a0lqC0JqfBg2SiRGMQUTPNaWXAFGephqjjs=
From:   Olliver Schinagl <oliver@schinagl.nl>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     inux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCHv2] phy: Add helpers for setting/clearing bits in paged registers
Date:   Mon,  5 Sep 2022 11:20:05 +0200
Message-Id: <20220905092007.1999943-1-oliver@schinagl.nl>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We currently can set and clear bits on PHY registers and MMD registers,
but not on paged registers. Since all we need is the `phy_modify_paged`
function for this, lets add these helpers.

To ensure we can keep the structure of the header file and group things
logically, the prototypes for the paged functions are moved to the
prototypes for the phy and mmd functions to keep them together as well.

Changes since:
  v1: Move paged functions higher to avoid compilation warnings


