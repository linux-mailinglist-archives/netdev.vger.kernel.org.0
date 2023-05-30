Return-Path: <netdev+bounces-6307-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E86F7159F9
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:24:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 687E41C20B6A
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E58DC14264;
	Tue, 30 May 2023 09:24:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB040134D4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 09:24:17 +0000 (UTC)
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E95110E4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 02:23:49 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f6077660c6so27835365e9.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 02:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685438620; x=1688030620;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wjR90Ctvp6ZQbw8QRFKChSdyEnuHvvabu/xgCEjiGB4=;
        b=ecb6HZm/MEXj2cucvYfvya+WXqaP/YABRut+6eJlRkVXdvsmLptN35/8Bui9HmLBcj
         TsviLhx8W3VNezNkfI9Um6lKqYcigFqV2AaEt4It/uSx2RBRecqGtu3rm/3dTSQgYFFR
         F7xjEEvqCDTeDdwfn51rd78K10TmB5xBTqBZm5ut9bLkgNkTg9VuuEFA+mZgaGu61vkB
         E6dkrUkdZLLj923hBlef0FAsdcB2jFF2cFFkW60CJfQcxY3fy78mWIgt69azMS+FFmIv
         14dWPKYdWsUmYqo8GMdz4UWYjy8N9w+QuGQvOaXa2HKp6gO9/Lo3V5X67JlwdHqhdylD
         5Pvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685438620; x=1688030620;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wjR90Ctvp6ZQbw8QRFKChSdyEnuHvvabu/xgCEjiGB4=;
        b=lei60Rqj3PwQMETJHIoDpgS3nJfZ0AlY163J2HvC96A1FY81uJ2p1r4Y2w8snhZlcg
         IaHuOBskMA/N2qjT3cTkTVOBWIvEnoEsYDN+V3fjeJ94X7NW2MMU6A5QNRq6HNhzV8mV
         da9FMtgCG9HuToMtbGLduVcglenTZrB/fdQo2csAmN5dqese8JoGrW/YLVW73j9Rg2PG
         AFKERyb5X9BXRylNY+BLpvL3tUQ49q1M6VgccLhiItEAPmwjo85xOZiQKoVlr8QADE1v
         5fBbCvvl/OERxaqyeDCDTHhla9oRyXqJnJOLbjwldB7Ub5FivWXRN1wl4yjlkO3gfMra
         L/4Q==
X-Gm-Message-State: AC+VfDzLKWdTOJTnH0N6kC9fD/TlKMFts1y4PcQVYtWSHCOXRQuYI8Bw
	N9K532bybBSQqR11hb1A/sDgZQ==
X-Google-Smtp-Source: ACHHUZ5+4SmegIyAIJS+17P4obWCr0wwjHL2trNkxyb8ungnYM8gi9ma+XnOQYcNrWcwELOsTL2aLw==
X-Received: by 2002:a1c:c906:0:b0:3f4:2c21:b52c with SMTP id f6-20020a1cc906000000b003f42c21b52cmr1175562wmb.39.1685438619961;
        Tue, 30 May 2023 02:23:39 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id l21-20020a1c7915000000b003f603b8eb5asm16993997wme.7.2023.05.30.02.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 02:23:36 -0700 (PDT)
Date: Tue, 30 May 2023 12:23:32 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	Russell King <linux@armlinux.org.uk>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: phy: fix a signedness bug in genphy_loopback()
Message-ID: <813008f6-cb26-4666-81ca-6f88c04bba07@kili.mountain>
References: <d7bb312e-2428-45f6-b9b3-59ba544e8b94@kili.mountain>
 <20230529215802.70710036@kernel.org>
 <c7a1ee2dea22cd9665c0273117fe39eebc72e662.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7a1ee2dea22cd9665c0273117fe39eebc72e662.camel@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 11:06:55AM +0200, Paolo Abeni wrote:
> On Mon, 2023-05-29 at 21:58 -0700, Jakub Kicinski wrote:
> > On Fri, 26 May 2023 14:45:54 +0300 Dan Carpenter wrote:
> > > The "val" variable is used to store error codes from phy_read() so
> > > it needs to be signed for the error handling to work as expected.
> > > 
> > > Fixes: 014068dcb5b1 ("net: phy: genphy_loopback: add link speed configuration")
> > > Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> > 
> > Is it going to be obvious to PHY-savvy folks that the val passed to
> > phy_read_poll_timeout() must be an int? Is it a very common pattern?
> > My outsider intuition is that since regs are 16b, u16 is reasonable,
> > and more people may make the same mistake. Therefore we should try to
> > fix phy_read_poll_timeout() instead to use a local variable like it
> > does for __ret. 
> > 
> > Weaker version would be to add a compile time check to ensure val 
> > is signed (assert(typeof(val)~0ULL < 0) or such?).
> 
> FTR, a BUILD_BUG_ON() the above check spots issues in several places
> (e.g. r8169_main.c, drivers/net/phy/phy_device.c, ...)
> 

I don't see an issue in r8169_main.c and in drivers/net/phy/phy_device.c
then I only find the bug from this patch.

regards,
dan carpenter

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 6478838405a08..f05fc25b77583 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1173,6 +1173,7 @@ static inline int phy_read(struct phy_device *phydev, u32 regnum)
 ({ \
 	int __ret = read_poll_timeout(phy_read, val, val < 0 || (cond), \
 		sleep_us, timeout_us, sleep_before_read, phydev, regnum); \
+	BUILD_BUG_ON((typeof(val))~0ULL > 0);				\
 	if (val < 0) \
 		__ret = val; \
 	if (__ret) \

