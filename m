Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43135EDBBD
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 13:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbiI1L1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 07:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbiI1L1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 07:27:20 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEA4B657B
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 04:27:15 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 87C5C1242;
        Wed, 28 Sep 2022 13:27:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1664364433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=hXORp1dC1sofrmn1GxpdYS13O7xrxpFRtAhU7eD8seU=;
        b=gCJbLuXpKJGKIfBXE5s5Olmon8VCLJg/cWItXBzCP/CN46Q5mrmN/N2YKq2EM8g7WfdWFq
        XZZEI1Nub5h8B4RK7lsC4ElqGsc1CDHBX7Xw2Uo3bLLiyfo/7cKVKmGzGB575++lpQoOdj
        6atYXB1At2KYA4yNIgQ3D3m/TuLtp/tTB0QhWb4U+96mO2TA4+R+kD1q1Y+BnPg3Rd+i3w
        C/o938CQRsh4WFBw6b9/5eCtAZ+eh1W6KGUufbfYhhprzljkyotrtdvZD2m8RHBaiuiN1h
        t7JK4OcIbolgwRDRQv9tPMjvK9DPAct85fkM/IclgCWp3X1rUmqAr4n/Fcj/wg==
MIME-Version: 1.0
Date:   Wed, 28 Sep 2022 13:27:13 +0200
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org
Subject: PHY firmware update method
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <bf53b9b3660f992d53fe8d68ea29124a@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

There are PHYs whose firmware can be updated. Usually, they have
an internal ROM and you can add patches on top of that, or there
might be an external flash device which can have a more recent
firmware version installed which can be programmed in-place
through the PHY.

The firmware update for a PHY is usually quite simple, but there
seems to be no infrastructure in the kernel for that. There is the
ETHTOOL_FLASHDEV ioctl for upgrading the firmware of a NIC it seems.
Other than that I haven't found anything. And before going in a wrong
directions I'd like to hear your thoughts on how to do it. I.e. how
should the interface to the userspace look like.

Also I think the PHY should be taken offline, similar to the cable
test.

-michael
