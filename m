Return-Path: <netdev+bounces-11468-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 648C07332B7
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:58:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 953741C20FDD
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:58:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 058211950D;
	Fri, 16 Jun 2023 13:55:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA701ACB0
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:55:51 +0000 (UTC)
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45F34213;
	Fri, 16 Jun 2023 06:55:19 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-666b0fab552so633801b3a.0;
        Fri, 16 Jun 2023 06:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686923707; x=1689515707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ur+ZoWtsQoZEEwjfiS9ZE1I3KVkk8c56whaW0Nypd8=;
        b=SVN0dgEJGt3QELIkEZuSnwcAcFVFeiQQaSn9SEVAhjFdlBeSHLPXeXsxUEWdOAZ0hi
         m0kSjjIcGUQqqCRJ+jxABfz/jaQ48BikWT6ZSqKrByN2DCtWDBKZKgs+1P2iiUYW4CyT
         pZMSn6jJNWSQaw1XUtbigwwe0/3LIDboYyYI7hAihxU7roXGBU8lrXFjn9bls6bn0v58
         a2vORJ+fLFfEgRfKl2q/6vXfN6l5TUmiCunsK+w5sLEWU8WYdcR/gy6tLYlIFN8d/AcI
         GelSC6f4EdQPV3JCU5A8YN8tz7fxXGwiKupFI6VE/GQ9dd+Z3yEo5DISSWV9HgCMRGuv
         upcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686923707; x=1689515707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1ur+ZoWtsQoZEEwjfiS9ZE1I3KVkk8c56whaW0Nypd8=;
        b=MYvunu8yCBLLG3g3Hb4FQlHifxo43myXCuOMoxcpU0TjLEHXmh6h6acvc89aYQ5cqY
         zK8P3BjQyQOJx18ifN1DpUFfMzVwH65oqrjk4tQM7Qh2y83UWVC8ILBMnHvrpGLcVf8A
         Cbg98BnUwjPscsRX0aSrzS9hHsQaJos2A6PtXr7ZBgYxoejUcDH2/p8mGp05khaWiE50
         aNhvkH4hPZx62r0ixoYuHoMFEk0qYuuG2OdqcgL71vnGAhPG0Ph8AdaL7P1egk8RXrWA
         bSwvuRTEN5dIin33jcseyJVjPysxERvwosBJkvlJsRxvTs9CNhiAPk1kwYgsunoDfQk9
         xXMg==
X-Gm-Message-State: AC+VfDyzgEifwkOfpTv5hrJmIP0V325smTNwK9hVaFlYDYqN8DXvYC/S
	0153HcKqZ/bivm9SnjuHrSm7f4hUDss5U5wA
X-Google-Smtp-Source: ACHHUZ50b0yZ6dKMDsAHI/YkpFqAWiLziqLE9E0h4ojEatTUTVbVrXy6ufavI52PMXxNW57Wv/rNkA==
X-Received: by 2002:a05:6a20:2588:b0:106:5dff:5db5 with SMTP id k8-20020a056a20258800b001065dff5db5mr10701811pzd.1.1686923707356;
        Fri, 16 Jun 2023 06:55:07 -0700 (PDT)
Received: from localhost.localdomain ([103.116.245.58])
        by smtp.gmail.com with ESMTPSA id c11-20020a63ea0b000000b0050a0227a4bcsm14459487pgi.57.2023.06.16.06.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 06:55:07 -0700 (PDT)
From: Jianhui Zhao <zhaojh329@gmail.com>
To: zhaojh329@gmail.com
Cc: andrew@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	hkallweit1@gmail.com,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	linux@armlinux.org.uk,
	netdev@vger.kernel.org,
	pabeni@redhat.com
Subject: [PATCH V4] net: phy: Add sysfs attribute for PHY c45 identifiers.
Date: Fri, 16 Jun 2023 21:54:55 +0800
Message-Id: <20230616135455.1985-1-zhaojh329@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230616131246.41989-1-zhaojh329@gmail.com>
References: <20230616131246.41989-1-zhaojh329@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>+	struct phy_c45_devid_attribute *devattr =
>+		container_of(attr, struct phy_c45_devid_attribute, attr);

>+	struct phy_c45_devid_attribute *devattr =
>+		(struct phy_c45_devid_attribute *)container_of(attr, struct device_attribute, attr);

The two conversions is not same.
One is convert "struct device_attribute" to "struct phy_c45_devid_attribute",
and another one is convert "struct attribute" to "struct phy_c45_devid_attribute".
The second one must cast "struct device_attribute" returned from container_of
to "struct phy_c45_devid_attribute".

