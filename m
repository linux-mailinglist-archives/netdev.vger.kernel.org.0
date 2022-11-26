Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 522FD639642
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 15:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiKZOHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 09:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiKZOHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 09:07:16 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC03C1B9D6
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 06:07:15 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id x5so10455741wrt.7
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 06:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j6G2Huf2TZqbTUaRJYYmgS3CqklmcxwBV8jSX4nQwKY=;
        b=ABXceDXVYfpk6Sq5ExASw0bO7ZYp4qsXyYdC9TpZ6OyBeJvQFoU8+X3FUgoq2innkH
         aE/SLoyzexBOBqp/PMqZsZr+ul/UegDX5fY2tDpL5od7eo6zLoo+J1PNIcFLjupgkaHl
         pYfm5bgtnITURgPRpB4tIt8f8OMfFb10Ld20FqpeJl1C46M68xBc+cLdP3EPJVwmZzgA
         V5eaKTRq6Vjimc0RBzYHsV1xvkOxKD3LUHPYv2nobBobuer84haZR7DPi6//BhNWYGZY
         Fs35zyk/6kYy0VnF7+611JfwrEPc929qMIsIYxFBHTHEbfF79CSfZDKPGia31gMFEYGu
         6O4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=j6G2Huf2TZqbTUaRJYYmgS3CqklmcxwBV8jSX4nQwKY=;
        b=cFC6vKVvBjF/CqnvGC0Sq/WTjT+Vlp1tduMVZdF4N++Cwz25b2196VjXr98eHlrpZx
         GVjphhNd4RffEeEPQ3Tm+Q5rVvWDxQKGtGSb4suBeJe55dXS0kRyEHHlckhnaPP3Qrrj
         KCI3E0PAdcgcQQ+0X5bh6HsRMnv7mLVY+GGqP+FGM4DEUo0TfDt11SP/UM6L6cZRbHa6
         /QRc0JzbwtPFSN6RkTdCsTINj0BJqR1jWewkVhyVbRC/1gqmxXGrTmL63kuHkum65IB7
         951Ik+7YjqPFZRmzZwDrpqhe1EIM0q7oT/L3gVoq8r6WJWseaGD1gKW5De9Yu76clC95
         5Cwg==
X-Gm-Message-State: ANoB5pmLYQ0hS6Qi5UOS1TcJBK/S/g3nhWjuF95QZk3A3mlgPHV5eb3l
        7Kjg9pZfCAgQ9OaBMJx4xsU=
X-Google-Smtp-Source: AA0mqf77P2jld77tnPldWdqvszuJKergAiD+7Wf5zKOLITGxH7vkMj38SN47hxqIgMB/hu27YyKacw==
X-Received: by 2002:a5d:6b8d:0:b0:236:4c14:4e4c with SMTP id n13-20020a5d6b8d000000b002364c144e4cmr26586636wrx.634.1669471634154;
        Sat, 26 Nov 2022 06:07:14 -0800 (PST)
Received: from ?IPV6:2a01:c23:c542:d400:fcae:8320:c33:9e4b? (dynamic-2a01-0c23-c542-d400-fcae-8320-0c33-9e4b.c23.pool.telefonica.de. [2a01:c23:c542:d400:fcae:8320:c33:9e4b])
        by smtp.googlemail.com with ESMTPSA id r6-20020a05600c458600b003cfd4a50d5asm13217511wmo.34.2022.11.26.06.07.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Nov 2022 06:07:13 -0800 (PST)
Message-ID: <9d94f2d8-d297-7550-2932-793a34e5efb9@gmail.com>
Date:   Sat, 26 Nov 2022 15:07:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Subject: [PATCH net-next] r8169: enable GRO software interrupt coalescing per
 default
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are reports about r8169 not reaching full line speed on certain
systems (e.g. SBC's) with a 2.5Gbps link.
There was a time when hardware interrupt coalescing was enabled per
default, but this was changed due to ASPM-related issues on few systems.

Meanwhile we have sysfs attributes for controlling kind of
"software interrupt coalescing" on the GRO level. However most distros
and users don't know about it. So lets set a conservative default for
both involved parameters. Users can still override the defaults via
sysfs. Don't enable these settings on the fast ethernet chip versions,
they are slow enough.

Even with these conservative setting interrupt load on my 1Gbps test
system reduced significantly.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 5bc1181f8..1cb51ec71 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5282,6 +5282,12 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->hw_features |= NETIF_F_RXALL;
 	dev->hw_features |= NETIF_F_RXFCS;
 
+	if (tp->supports_gmii) {
+		/* enable software interrupt coalescing per default */
+		dev->gro_flush_timeout = 20000;
+		dev->napi_defer_hard_irqs = 1;
+	}
+
 	/* configure chip for default features */
 	rtl8169_set_features(dev, dev->features);
 
-- 
2.38.1

