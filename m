Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C699C652C59
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 06:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbiLUFW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 00:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiLUFW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 00:22:56 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17F0205C6;
        Tue, 20 Dec 2022 21:22:53 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id BF9BF32007BE;
        Wed, 21 Dec 2022 00:22:48 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 21 Dec 2022 00:22:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pjd.dev; h=cc:cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1671600168; x=1671686568; bh=7tbpemXh0VafIGgg/pzTEoZlW
        +RVtkobri/l8+5Gu7I=; b=YnTTqjS5HoTiDhx/yp/G8mDIJofpYPYjBb0xL+PfA
        O1PrnLAhZMvZIzffITSrjYuoPO93Z7DILFNVnyYNt8J2Qfi0YD6hx0t7d0+aJSr1
        pobp7gfYFY3jkAo945gvRL+4SZoluBBmB2qBDuQZY/UM2ocJnWXCvLCftUWZ8krk
        cTyB5kH3tcVb7adA2FG6kxKz07AcZP1DqzD9/M5X0/to3qtpFAoDRvsBSSw1HNxd
        yxe7gRaCDfQ4+TeV37crF5xo01By2Q0DK9t+2cWzRvQSIw8kIomIn0oxDLootDaG
        9JlVF0V+lYoZdDBpD53zR38yCLnpWE/TgHKO9UE3sV0vQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1671600168; x=1671686568; bh=7tbpemXh0VafIGgg/pzTEoZlW+RVtkobri/
        l8+5Gu7I=; b=PCwmBqFnz70uVZKU1H6/I/PEP+tV3sW0jT9C5I3XoihpW7WrA1T
        cos7Av8AttGma56EtnFuwDxmXvRkmedgiDMUEpdW8u8MreGvT9LS7p3OkGSHCb5x
        dJZUnNvfTanI55rFIpy84KhC0On+mN7XVrxgrw5gZ8jx/HIJdNPKlQ2L6qjbLFtk
        rdfajM+EJoYf4Q72bNrbbg8dQv6OYlYbRatYFz4hC07D2SaylAWPdkW5g25l9QfZ
        Nag9fBfmiu722FiVTQT2vTphALMFtPwS5zVe/6Tizgd2aHhG915ldtupJc6deG5l
        7utV83YNM+ICbDJG2HkAKkhFpEcJe1iHRkA==
X-ME-Sender: <xms:KJiiY09_uApeNt2-XPFQAeECu5ZZcX09LLuStPfBmdYboNDutb5ESw>
    <xme:KJiiY8tKuXnSJq9EB38Ji_-oo4eeN_6n42LONamtHhDtYE81Nhy5ooX9up2ihuYVR
    GP-Y6p5YrsYjc3dybI>
X-ME-Received: <xmr:KJiiY6CSm0HM-AMJ1L-DnHK8qinslcmkH88t1QGUQaaR39ZVtRMFbR05wd8V5oQD3woxYrOCw9djPT0_rLSO>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeejgdekfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecumhhishhsihhnghcuvffquchfihgvlhguucdlfedtmd
    enogetfedtuddqtdduucdludehmdenucfjughrpefhvfevufffkffoggfgsedtkeertder
    tddtnecuhfhrohhmpefrvghtvghrucffvghlvghvohhrhigrshcuoehpvghtvghrsehpjh
    gurdguvghvqeenucggtffrrghtthgvrhhnpeetgefggfeihedvgfefveekjedvjeejgfdv
    uefgleevudfhvedtudfhueegleefteenucffohhmrghinhepughmthhfrdhorhhgpdhfrh
    gvvgguvghskhhtohhprdhorhhgpdhgihhthhhusgdrtghomhenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehpvghtvghrsehpjhgurdguvghv
X-ME-Proxy: <xmx:KJiiY0eaXOUIA15X6j7kFiQBB60ConEUM6D-iL0sz0-Z6t6Lc0jLOQ>
    <xmx:KJiiY5M-weKscmoNhBVn-QcIh78grGdJpN1ZqTMglWq5NSQdF8vaRA>
    <xmx:KJiiY-lS6tTGOWZaz06lvzk-UKJG3xoGjz6t-jDpXJMSxQuSL77sWw>
    <xmx:KJiiYyhj1IeY8Tc5bVBTfAWHLA0cJQNb2zYdjj3H9rrT1YKY8S-2mQ>
Feedback-ID: i9e814621:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Dec 2022 00:22:47 -0500 (EST)
From:   Peter Delevoryas <peter@pjd.dev>
Cc:     peter@pjd.dev, sam@mendozajonas.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        joel@jms.id.au, gwshan@linux.vnet.ibm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] net/ncsi: Add NC-SI 1.2 Get MC MAC Address command
Date:   Tue, 20 Dec 2022 21:22:43 -0800
Message-Id: <20221221052246.519674-1-peter@pjd.dev>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NC-SI 1.2 isn't officially released yet, but the DMTF takes way too long
to finalize stuff, and there's hardware out there that actually supports
this command (Just the Broadcom 200G NIC afaik).

The work in progress spec document is here:

https://www.dmtf.org/sites/default/files/standards/documents/DSP0222_1.2WIP90_0.pdf

The command code is 0x58, the command has no data, and the response
returns a variable-length array of MAC addresses for the BMC.

I've tested this out using QEMU emulation (I added the Mellanox OEM Get
MAC Address command to libslirp a while ago [1], although the QEMU code
to use it is still not in upstream QEMU [2] [3]. I worked on some more
emulation code for this as well), and on the new Broadcom 200G NIC.

The Nvidia ConnectX-7 NIC doesn't support NC-SI 1.2 yet afaik. Neither
do older versions in newer firmware, they all just report NC-SI 1.1.

Let me know what I can do to change this patch to be more suitable for
upstreaming, I'm happy to work on it more!

Thanks,
Peter

[1] https://gitlab.freedesktop.org/slirp/libslirp/-/blob/0dd7f05095c0a77d9d2ec4764e8617192b4fa6ec/src/ncsi.c#L59
[2] https://github.com/facebook/openbmc/blob/a33dbcc25759f00baf113fd497c8d9db60eeed9e/common/recipes-devtools/qemu/qemu/0003-slirp-Add-mfr-id-to-netdev-options.patch
[3] https://github.com/facebook/openbmc/blob/a33dbcc25759f00baf113fd497c8d9db60eeed9e/common/recipes-devtools/qemu/qemu/0004-slirp-Add-oob-eth-addr-to-netdev-options.patch

Peter Delevoryas (3):
  net/ncsi: Simplify Kconfig/dts control flow
  net/ncsi: Fix netlink major/minor verison numbers
  net/ncsi: Add NC-SI 1.2 Get MC MAC Address command

 net/ncsi/internal.h     |  7 ++--
 net/ncsi/ncsi-cmd.c     |  3 +-
 net/ncsi/ncsi-manage.c  | 29 ++++++-----------
 net/ncsi/ncsi-netlink.c |  4 +--
 net/ncsi/ncsi-pkt.h     | 17 ++++++++--
 net/ncsi/ncsi-rsp.c     | 71 +++++++++++++++++++++++++++++++++++++++--
 6 files changed, 102 insertions(+), 29 deletions(-)

-- 
2.30.2

