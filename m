Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4C4545748
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 00:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345709AbiFIWTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 18:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345674AbiFIWTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 18:19:49 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E194CD5F
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 15:19:33 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id s205-20020a632cd6000000b003fdb97e6951so7120906pgs.7
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 15:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VtmBCpNp1KP0Wih0wNtSn6S6eDN4r8qEfTH0S3sfDvI=;
        b=k5UJiPwakkG5FRIZZ5lAwSHv1cl5CV0HckKotKPvFRLB2rm04skCRUAH92Ocj74nI8
         VRgM32h5RM5BUgSugbEFBV15QskHdJF/UARg45aXgMXIqpE44JaqgZSOgpAQZ1jpikDb
         GULMqiClDzX4kfuE9w7o93QGAbqsh6kUT85oC3PEd1vaEzeRnphtmpPAmbhnAhgk6lx0
         LnkSW18ZNlDn2dA0I8HZDUuV5QwUSYnjU7SGR9fWBj1oQGC+opt0AKeg9qvISijvMYMC
         exN/sa9O/SGU7ijyDd9mK0GdtUUcbGfySNVXrOfDrxnggsEQ+nfu/2kYPptx+0sLFFrT
         DcWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VtmBCpNp1KP0Wih0wNtSn6S6eDN4r8qEfTH0S3sfDvI=;
        b=5Tnh7lLXF8ppCRcNfdH2iQGmnnnGjGz5aDEdRyGFgBwqoQuTpiC483TEZDkyqYhgDA
         yTxOBpxuIB/u/ZLiAUg6NYZflqjj4pL392H6z3d4Yf9Ri+lCL19u4lPoNN+uGbjRzYVV
         ZZrZb32IhnXBab48cVi/v4OVYEwk/VKWdOAqhHg0jOerxj7p/y7D2mX8IDEUvfNEy4i1
         k3e1yCTRR7g+td8DBMmsOv6I72cHajA9166CFFa696so9gRm9PVOs76ojQsRwTN/7Dx6
         j1/4S3UH/paLeFaYmUWP4tDldCUcrzhmg3gT5deqoglio3IEINm2iSQanbkc2H8d1vaC
         JhWA==
X-Gm-Message-State: AOAM533nh5Ef6L9Ao1KJV2by4v5IrLl0AJZ+sP3kaCS823hPPRkEmCFJ
        HUVwiwl2XIbUOOO4BP2K+nhLMK6w
X-Google-Smtp-Source: ABdhPJyLvkWkgsl5N6fEs4uPVrRWt8N7EGGq7Ji9SRjDngCAZu0NMTQ8venaNAjb270E/IyAc5Cnz/CcgQ==
X-Received: from fawn.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5795])
 (user=morbo job=sendgmr) by 2002:a63:4722:0:b0:3fb:94a7:9986 with SMTP id
 u34-20020a634722000000b003fb94a79986mr36618043pga.531.1654813173379; Thu, 09
 Jun 2022 15:19:33 -0700 (PDT)
Date:   Thu,  9 Jun 2022 22:16:25 +0000
In-Reply-To: <20220609221702.347522-1-morbo@google.com>
Message-Id: <20220609221702.347522-7-morbo@google.com>
Mime-Version: 1.0
References: <20220609221702.347522-1-morbo@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 06/12] PNP: use correct format characters
From:   Bill Wendling <morbo@google.com>
To:     isanbard@gmail.com
Cc:     Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jan Kara <jack@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Ross Philipson <ross.philipson@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-mm@kvack.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, alsa-devel@alsa-project.org,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bill Wendling <isanbard@gmail.com>

When compiling with -Wformat, clang emits the following warnings:

drivers/pnp/interface.c:273:22: error: format string is not a string literal (potentially insecure) [-Werror,-Wformat-security]
                pnp_printf(buffer, pnp_resource_type_name(res));
                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~

Use a string literal for the format string.

Link: https://github.com/ClangBuiltLinux/linux/issues/378
Signed-off-by: Bill Wendling <isanbard@gmail.com>
---
 drivers/pnp/interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pnp/interface.c b/drivers/pnp/interface.c
index 44efcdb87e6f..553221a0c89a 100644
--- a/drivers/pnp/interface.c
+++ b/drivers/pnp/interface.c
@@ -270,7 +270,7 @@ static ssize_t resources_show(struct device *dmdev,
 	list_for_each_entry(pnp_res, &dev->resources, list) {
 		res = &pnp_res->res;
 
-		pnp_printf(buffer, pnp_resource_type_name(res));
+		pnp_printf(buffer, "%s", pnp_resource_type_name(res));
 
 		if (res->flags & IORESOURCE_DISABLED) {
 			pnp_printf(buffer, " disabled\n");
-- 
2.36.1.255.ge46751e96f-goog

