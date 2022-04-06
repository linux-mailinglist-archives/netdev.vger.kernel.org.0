Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E424F6765
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238745AbiDFRZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238639AbiDFRZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:25:36 -0400
Received: from stuerz.xyz (stuerz.xyz [IPv6:2001:19f0:5:15da:5400:3ff:fecc:7379])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC014B75A7;
        Wed,  6 Apr 2022 08:24:29 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id EECFCFC6D8; Wed,  6 Apr 2022 15:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1649258668; bh=vlsd1PJdKyHK1SGffch1w4JGaYZk4ff39fIfLFwEuZM=;
        h=From:To:Cc:Subject:Date:From;
        b=Bhm85yBeKpAs0mNtJfQmunUKCt9wKZ6FJlrORtEaXOS1UPoe0RWsefVsFM7oR+USC
         aR4CU4LEZugODwYdume9WUxLc6RpnUJwTy7CDgFdvrYaL1WKTRcIDHseSqQt+Bx1l5
         qzqnOXu7lLnRgkgsc0HL/MaUbcyTc5O5gK60+ocvl+Jekvr1zFvAeraE2FlJIa99HP
         7cfBZS24vOXasOWXrxeZOgBHNgyMGbuod1dH71PPCoBe/LhhQZx0gI86yzahyV7mo2
         45/fL/edMCJTWHcM1qtok3ObuxxLTToHN0uNcpcTBojZeUmmbhsJ4dG1+oAKy+r/si
         FXcl5bQZhWmfw==
Received: from benni-fedora.. (unknown [IPv6:2a02:8109:a100:1a48::1e62])
        by stuerz.xyz (Postfix) with ESMTPSA id 96194FBC37;
        Wed,  6 Apr 2022 15:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1649258666; bh=vlsd1PJdKyHK1SGffch1w4JGaYZk4ff39fIfLFwEuZM=;
        h=From:To:Cc:Subject:Date:From;
        b=GIiyk/hmfR1kNFA+Ij4qKoJN429DqKLzNttrcYiiQaZWbyXyf+yiOzEqxAjtYO7nz
         sCU07p2g9Aw7wMKWzH6ZQTImglyoQ2tum3gGu/4vY5PXK+Nc4Ne1GJo8Qfb3fG+9ll
         lxdKlhULMG9TOnTd2tvgK1h7jDABAPE4HnAyfMrVar7yx0KJiXyd1DbrLnns6bfwXm
         fCIUskh/3plAkSKldKr7iSyM/QBP9WWFJsZP53Nr185guYscRoF9D6gvV/MXp3oOBu
         1zbRL6c94ExtCicpzm0xhcIzNA5prqYi7I09Il0fd9Ymzj5DRd8HDJknMOJWHizIx0
         Dfh0HyZFShlXg==
From:   =?UTF-8?q?Benjamin=20St=C3=BCrz?= <benni@stuerz.xyz>
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Benjamin=20St=C3=BCrz?= <benni@stuerz.xyz>
Subject: [PATCH v4 0/2] wireless: ray_cs: Improve card_status[]
Date:   Wed,  6 Apr 2022 17:22:45 +0200
Message-Id: <20220406152247.386267-1-benni@stuerz.xyz>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        FROM_SUSPICIOUS_NTLD_FP,PDS_OTHER_BAD_TLD,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small patch series improves the card_status[] array in ray_cs.c.
It essentially replaces comments describing the index with designated
initializers using enum constants as indexes.
It also makes the array const because it shouldn't be modified at
runtime.

Benjamin Stürz (2):
  ray_cs: Improve card_status[]
  ray_cs: Make card_status[] const

 drivers/net/wireless/ray_cs.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

-- 
2.35.1

