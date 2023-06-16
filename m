Return-Path: <netdev+bounces-11471-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B8F2733347
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 16:17:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C87901C20F8C
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 14:17:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A355019E48;
	Fri, 16 Jun 2023 14:17:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AAC1113
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 14:17:01 +0000 (UTC)
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C81B30DE;
	Fri, 16 Jun 2023 07:17:00 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1b5018cb4dcso5144895ad.2;
        Fri, 16 Jun 2023 07:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686925020; x=1689517020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=An/rdJavvmU9ACpPTpspbl193LS1F89T5MDqS1a0mPI=;
        b=I0nKKEYaePfPrIOzDWEIPxJna7yuzGIhhZtoECMhxHLkJVW4J5H0GcGba46oAnUNya
         9AZcF2iyTtHM6i4MYnyiHY1xJTqN8gPW1KPlEwpYnAq5tXM1PlHYi0EztTvuqB0ku0mx
         0uDQEGxXqoD1yMpG6/baCGD4SfxreSLhc9mP7arpSezcLvhtFSFKlxqxC6/fI0bROYal
         JOjqeZT6/FMkT6CeE4VUzgpAAIvJfe5nfsYI+Cd0uOkV7byTYhHiGkkPUbP6e/re3dwI
         GeXdeaQwr93JIi2+F2v6KTjKmg/SF7oMnNq/lsWQOL6TOjyGrhZMltf4qVs7honVF6Ji
         A5lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686925020; x=1689517020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=An/rdJavvmU9ACpPTpspbl193LS1F89T5MDqS1a0mPI=;
        b=iwX9QLFCscXp98AuElm6ke5BfspmlOwC6+1I8nu8mszaCRkN2MOV0oUGF5mKFZdz5y
         PP9f63F/iw45mPN2YvI0QoJzUcKjbZSvhpyTeIFkgs4h0ItYV7fbYmaeEa3zq0gY/B6c
         1gTKd696qssp57UnmISH1tf3Gok8SPiyejI0Umw+YaNIVLcuV3h30oCmTYhXkldHrAVR
         rL6N2FfQhTE3yPW+raP4Kf1/UyrFZ3wEn6q1d4Gzl0Cp02YR3F5O7HpC6VYeiCgPHJVu
         IXQZpzT4KeOLFZmPLJOc+rbt32nj3AKK8p/GOLg+jJ7qbgYX2l2tllpyz0PE1868t4nP
         y1EA==
X-Gm-Message-State: AC+VfDxzMtfKDx+cHl1byPwn/GQK3KpU982THlgmIFfofesdyfKUYsEH
	QvRHDWLBLukvPYbChCoK2xE=
X-Google-Smtp-Source: ACHHUZ4+UBcOMwX39mJtoK9hol0pfAAe4DmQ2FpucAnocmfKreb6V7C761jTaQ1VBhWzKgw9YtC3Fw==
X-Received: by 2002:a17:902:7fc8:b0:1b3:e6ba:3539 with SMTP id t8-20020a1709027fc800b001b3e6ba3539mr1371673plb.51.1686925019853;
        Fri, 16 Jun 2023 07:16:59 -0700 (PDT)
Received: from localhost.localdomain ([103.116.245.58])
        by smtp.gmail.com with ESMTPSA id r21-20020a170902ea5500b001b03a1a3151sm15922859plg.70.2023.06.16.07.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 07:16:59 -0700 (PDT)
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
Date: Fri, 16 Jun 2023 22:16:47 +0800
Message-Id: <20230616141647.4248-1-zhaojh329@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230616135455.1985-1-zhaojh329@gmail.com>
References: <20230616135455.1985-1-zhaojh329@gmail.com>
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

>Doing it properly:
>
>        struct phy_c45_devid_attribute *devattr =
>                container_of(attr, struct phy_c45_devid_attribute, attr.attr);

Thanks for the tip!

