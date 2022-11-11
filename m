Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6AA625011
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 03:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbiKKCSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 21:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiKKCSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 21:18:15 -0500
X-Greylist: delayed 39639 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Nov 2022 18:18:13 PST
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427A86035F;
        Thu, 10 Nov 2022 18:18:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1668133089;
        bh=66u608aFHZD7h1jR6L1oiYO9NFjD5WzC53iCZ4YS08U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=lJ9CH/0awAh/JjZbQAR1V446mXcFNHN3vl4nifTua+WlhRCOtafXSMDOh3EZ7lwTN
         +KrIfCJ7nE66IIPb3SGp3EMO9VQjfpq/up1CeDWGjlH34NT3PuSu63SGJnZlvHuElP
         Rl95dS7jEphifyVzheCMRShVfZqfzpLTt9npSCnw=
Received: from localhost.localdomain ([111.199.191.46])
        by newxmesmtplogicsvrszb6-0.qq.com (NewEsmtp) with SMTP
        id 4863509E; Fri, 11 Nov 2022 10:18:06 +0800
X-QQ-mid: xmsmtpt1668133086tzqlvsuh7
Message-ID: <tencent_754AAA6CBDDE8DB223CE1BF009D566E55E0A@qq.com>
X-QQ-XMAILINFO: MFdGPHhuqhNoJSP8CvP//ibepTOSuWEQ+vLjaWXTatogKs+WmmVwVAVtD7pZ8U
         XWWEYAIV6msV3341BUKn9EGwWuVIvgy40fVH68NRRho6xZV/8GGh5LeQsFoLI88HAplYx/beW8jl
         LnE+WGdMFOUQuDy5u58Z4rOXYaK5BGJd6lEpQWnIm283AAiUCG+/8yjnGgbL52P1YgiBFQhK20bh
         A9o8xACvkj8ivCgT3K5FWy9MvcsOq3pIynBTKj5BoFvMQNGg5R091dOhoBMaAJagXa3vmFK61RLI
         v4nn9/pYGnO56w2pPl7akGGanZ022jP4moQrGdUFooqZ9pVrCoT9etjpAjqwQ1R/JporQvVzWYWp
         7EXryepKlPDPXpKF5yNeMli0QsrU4ZZJZnovt0hRoBk/3QR1WusNCu2/N6uj3nsBfJZ/PA3JYyHu
         BdX7Z4tKU5LM8/Dg3yZcHLxE6Ps2+fgvU6O/FAApYJja2nCLvTBtVOEqqV210pP1lQM3bZ6Ve+aS
         Rt/pp4SqKt8IiV0cj4m7H15VmBI7pyiHL7QpABRiLmF8H3z+EaPkPBxhyGeV7L6B4kTrbtpqCETw
         2Tc4MrEpm1h8RtHuOGMgjGZt0PLjl0PpCscQ03pdcVEbUg+qfcqIs+KmKRedkKv/aSJXTH01kD0U
         ZIJIyyJ7QEvWYA2Rij6dwt4OGrCYOyZZT3hPQJ5x5xfyQv6p+34UFiBYbP49+6sNxUl4d9tagJZV
         rZ61bBLJA3BOCs+DNxxFF3g5bVzuXD11WwzbHNTmk1/bnGoDSA2AhV89ZQ0mrMiNUo4KuwcUNVAQ
         CvzL0kNF9nlQzFsmZs+Uj5ZGlCdikE/HhSlzATw1DIYbxxMjGUmJQ26LCIxnbq2RTi+calwvK1IT
         g9z+kLuCqJ00I2wTEoBQDSJgV2C4yFK1Jxrtp4f1ozIoDNLWw6nQ0f4GRq6zPcf4yubKtbVt8E3J
         jPI84jjl7oJy6XJtTeTWFK+1Qub64PpOxRbQ5DeSjLBRQbvy3HY7DV7G1V6GDO
From:   Rong Tao <rtoax@foxmail.com>
To:     yhs@meta.com
Cc:     acme@redhat.com, bpf@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, rongtao@cestc.cn,
        rtoax@foxmail.com
Subject: [PATCH] lib/radix-tree: Fix uninitialized variable compilation
Date:   Fri, 11 Nov 2022 10:18:05 +0800
X-OQ-MSGID: <20221111021805.12513-1-rtoax@foxmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <4ed2ebee-26a8-f0ab-2bc4-a0b6a29768af@meta.com>
References: <4ed2ebee-26a8-f0ab-2bc4-a0b6a29768af@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RDNS_DYNAMIC,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Song, thanks for your reply. I'm wondering if i want to fix code in
tools/include/uapi/linux/in.h next time, should i just modify
include/uapi/linux/in.h, and it will auto 'Sync' to tools/include/uapi/
linux/in.h? Or i need to modify tools/include/uapi/linux/in.h at the
same time?

