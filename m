Return-Path: <netdev+bounces-9896-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D786472B0E8
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 10:58:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22AC31C20AC9
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 08:58:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEC8B6FB4;
	Sun, 11 Jun 2023 08:58:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BB833D5
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 08:58:39 +0000 (UTC)
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67636EC;
	Sun, 11 Jun 2023 01:58:38 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1b3b5a5134dso3693685ad.2;
        Sun, 11 Jun 2023 01:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686473918; x=1689065918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EWZUFDSZ/fMZAMF0QPe7zZpxsyUC+/jDdvK69lb9eHE=;
        b=kw1sDcMeRYxNNp7XO/lycGtVtMANOv8tx7yHtKn/tO3WhfGcXfTzA/f3EnVEBX49q8
         9BLJlyZhYDmTFBTu0NKAJGlFqG7kqz9ur5qXR07a86rSrgGb7Mo1JYC+kBrMoG/Pj73S
         a3fkyYNaGmDgKy3Dimm/DEiPdYvV8LfdtPg1qi47Zyq9iaCw4HvOQ0NgNPLuFwVm580R
         4G1easP7UsK46aewJTjxuXMZgGhtcyI5WxrkRbxnxx/ePbp+vzm4LXFtLRk8cmac6cll
         BYHgFfD3G2BC9BwBInoZbGvGkpTr4BtMaYrq5ltZ8OvGkL+Xjy5NHKtwkindZ/5kihD4
         bgow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686473918; x=1689065918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EWZUFDSZ/fMZAMF0QPe7zZpxsyUC+/jDdvK69lb9eHE=;
        b=J7Z7Hp/iM9gbHqirRDhjcfDbb+rt8OuIQnvxWK3+x1yvZ6HjC2rm/Iy2sYgZJ3Tblk
         TawVPWOsc6C+hiIjvLaUL6BUpaW8XHM3KwrXeScIpIjRg55Oi8u4l4SBf3xIqjld9HPr
         E2NQPqFlRo9uAoeweRxbMwZmrPap2UG5u4u/2WltJldP/ipkd+Ocw4AgY9FdXn4BLana
         +e6sGx+05l7lb0MD7bNS/GGrJiQX9gwqXs2ZclI8e21TzzdHg3cQymgyKNMUbkurg8OL
         raeHUDwKD9pPvDjuNoyj3rmeVFkAogYs6Wqsd5gd9a1SBBtZoBpTSuVnILrRb4VXPFlE
         +4rg==
X-Gm-Message-State: AC+VfDz/KKIPVE/OLIH3FaWfyDNVZFmRzwh5sEqbU2QY45UNBLC+f/ob
	xtr6xBzMBzcHysbNFNeR5q4=
X-Google-Smtp-Source: ACHHUZ6fLRGLJOO/cw2i7Qt8yDZ2Ek6qUAg/tjjQXa2JZb7jn6L02rHAGJ6X0g4U6SyYZh3oNommzQ==
X-Received: by 2002:a17:902:bf08:b0:1ac:a661:a4b0 with SMTP id bi8-20020a170902bf0800b001aca661a4b0mr3814826plb.57.1686473917727;
        Sun, 11 Jun 2023 01:58:37 -0700 (PDT)
Received: from localhost.localdomain ([103.116.245.58])
        by smtp.gmail.com with ESMTPSA id jm18-20020a17090304d200b001ac6b926621sm6008371plb.292.2023.06.11.01.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 01:58:37 -0700 (PDT)
From: Jianhui Zhao <zhaojh329@gmail.com>
To: zhaojh329@gmail.com
Cc: andrew@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	hkallweit1@gmail.com,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	pabeni@redhat.com
Subject: [PATCH] net: mdio: fix duplicate registrations for phy with c45 in __of_mdiobus_register()
Date: Sun, 11 Jun 2023 16:58:26 +0800
Message-Id: <20230611085826.647536-1-zhaojh329@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230610161308.3158-1-zhaojh329@gmail.com>
References: <20230610161308.3158-1-zhaojh329@gmail.com>
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

__of_mdiobus_register
    __mdiobus_register
        mdiobus_scan_bus_c45
    of_mdiobus_child_is_phy
        of_mdiobus_register_phy
            fwnode_mdiobus_register_phy
                is_c45 = fwnode_device_is_compatible(child, "ethernet-phy-ieee802.3-c45");
                    get_phy_device
						phy_device_create

This is the function call chain. If a phy is already registered in
mdiobus_scan_bus_c45(), and it's compatible "ethernet-phy-ieee802.3-c45",
thus it will duplicated call get_phy_device later.

