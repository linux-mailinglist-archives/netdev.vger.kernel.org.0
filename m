Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472D54E87CA
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 14:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235692AbiC0Mry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 08:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbiC0Mrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 08:47:51 -0400
Received: from stuerz.xyz (unknown [45.77.206.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65554433B5;
        Sun, 27 Mar 2022 05:46:12 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id 3C409FBBC6; Sun, 27 Mar 2022 12:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648385171; bh=G70xCP6D8WSn+bAqlXu192tXuBsjh/gv9sAawqfU9NY=;
        h=Date:Subject:To:References:Cc:From:In-Reply-To:From;
        b=XW7jQ0JjvkbBwWYcDnJe2nlVcVuRIXoXRSxf3PNWwPKilsznYeHIMaHkGHbpF6CPi
         nqty3MnXTqG+wOEmI6ELfBW3t6Ot8AvrXhUDwqW1UwZJf6kiQJniSr9SnP78twlnv0
         ZUgcLapZcbEI4qbn8OxvPWktNikL6Kc+Etx6Bphh9afk/Hjw9xpphYQkktP6pYTs4U
         LH6YzQsfUm6Srdnzw7PCZmDV1KvBPkO+9qnzYPwcN+LOHDfP1TScrzVJPWp75MbJFA
         PLeKhwC+Gp8yjNM/5t52esOjGU9lpx0aWVyem4iFCEGjhJnePoGwI4TGCoWVDXFMVG
         IaZqNMJ7zdbtQ==
Received: from [IPV6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8] (unknown [IPv6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8])
        by stuerz.xyz (Postfix) with ESMTPSA id 2060CFBBBC;
        Sun, 27 Mar 2022 12:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648385168; bh=G70xCP6D8WSn+bAqlXu192tXuBsjh/gv9sAawqfU9NY=;
        h=Date:Subject:To:References:Cc:From:In-Reply-To:From;
        b=vBbH8cJYXUrIhSgvFCWqsIlouOaWa0Ob/IwOKcnk6W9EsrhxCv3d9ruHzL3uCcOyT
         isUVW1tcpcwMZ4y6KY5ZxcD9C88CnxszLWDsiAskZjdJ53DER27M6zK0oaEhWWieSL
         Juy7xWTEZPuLwOj9cO6+/7dR2PqcKQxjkt2MABFO0zPwNEsjU2mafYbXnQPlZ2I0cL
         2ZDQJwWjnuzEx4AHGvLxNgfwyXB0lIDpMXfYtHANjMklviMBw30yLOvmuMA/WBhhwQ
         lTIOL/KwWHU60GJWJ06zwdDByMnoxCjLnfIwK3SRtaOMOkXk/Hr5rtRBTGuebT4pdB
         MUwu53koBYhbA==
Message-ID: <8f9271b6-0381-70a9-f0c2-595b2235866a@stuerz.xyz>
Date:   Sun, 27 Mar 2022 14:46:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: [PATCH 00/22] Replace comments with C99 initializers
Content-Language: en-US
To:     =?UTF-8?Q?Benjamin_St=c3=bcrz?= <benni@stuerz.xyz>
References: <20220326165909.506926-1-benni@stuerz.xyz>
Cc:     sebastian.hesselbarth@gmail.com, gregory.clement@bootlin.com,
        linux@armlinux.org.uk, linux@simtec.co.uk, krzk@kernel.org,
        alim.akhtar@samsung.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        robert.moore@intel.com, rafael.j.wysocki@intel.com,
        lenb@kernel.org, 3chas3@gmail.com, laforge@gnumonks.org,
        arnd@arndb.de, gregkh@linuxfoundation.org, mchehab@kernel.org,
        tony.luck@intel.com, james.morse@arm.com, rric@kernel.org,
        linus.walleij@linaro.org, brgl@bgdev.pl,
        mike.marciniszyn@cornelisnetworks.com,
        dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca,
        pali@kernel.org, dmitry.torokhov@gmail.com, isdn@linux-pingi.de,
        benh@kernel.crashing.org, fbarrat@linux.ibm.com, ajd@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        nico@fluxnic.net, loic.poulain@linaro.org, kvalo@kernel.org,
        pkshih@realtek.com, bhelgaas@google.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-acpi@vger.kernel.org, devel@acpica.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-input@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-media@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-pci@vger.kernel.org
From:   =?UTF-8?Q?Benjamin_St=c3=bcrz?= <benni@stuerz.xyz>
In-Reply-To: <20220326165909.506926-1-benni@stuerz.xyz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RDNS_DYNAMIC,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series replaces comments with C99's designated initializers
in a few places. It also adds some enum initializers. This is my first
time contributing to the Linux kernel, therefore I'm probably doing a
lot of things the wrong way. I'm sorry for that.

I've gotten a few emails so far stating that this patch series is
unnecessary. Yes, in fact this patch series is not necessary by itself,
but it could help me understand how the whole process works and maybe I
could help somewhere, where help is actually needed.

This patch itself is a no-op.

Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
---
 .gitignore | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.gitignore b/.gitignore
index 7afd412dadd2..706f667261eb 100644
--- a/.gitignore
+++ b/.gitignore
@@ -20,7 +20,7 @@
 *.dtb
 *.dtbo
 *.dtb.S
-*.dwo
+*.dwo
 *.elf
 *.gcno
 *.gz
-- 
2.35.1
