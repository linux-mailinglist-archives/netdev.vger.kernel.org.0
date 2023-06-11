Return-Path: <netdev+bounces-9908-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2F7872B25E
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 16:57:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C81B31C20963
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 14:57:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F26DAD2B;
	Sun, 11 Jun 2023 14:57:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9450A441D
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 14:57:42 +0000 (UTC)
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52158F0;
	Sun, 11 Jun 2023 07:57:41 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 98e67ed59e1d1-25bc4c0101dso471008a91.1;
        Sun, 11 Jun 2023 07:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686495461; x=1689087461;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nPXYY+9Jj9nHwsM08iZ/SEWwt4aEmfyfzLsfJ+5si9E=;
        b=HkgsufbMSa2FgoqrNZIJXTmhSWu++BKKzGI58zYD0X6QDmNQx/2fcrOcoB3d3kpe+U
         ykVZIbwRZgdtkIg/tWG2qsDXg4q5j/SsevmEMZPtnQ3RodjnnvTH97ysdxsufL1+rHRj
         6hJ02I2X157COgAqVB1BP6KbcPw9dQFVb6aeLUbv8gai0tru0sAvVcjiGmES5TEV78CI
         5U3VITn7miyZbQgGH8gdB+XQw4b0hEdCkodxKPdkYxha8k3m4jIMgIr6Db9JeVV6TnFh
         bJiisv/EqK+p11zxYMiAZ2r7YX6lgWgpF/LSmZUR08t62QKdAixahlurwrtz74PxowaU
         uynw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686495461; x=1689087461;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nPXYY+9Jj9nHwsM08iZ/SEWwt4aEmfyfzLsfJ+5si9E=;
        b=hjhM49ACHQfNWfc74WFihZ9RIAqO4VeKBkSP9vAkuflBcl//Vjg0eAXZp87kj1/tWH
         l3LC+0czVxBeWpJCvk0+kXjR29NG5e1uIwEZKsF41vMzQyMdMQ0l82dFm3dHy7Kr7Xlb
         LQb0thJkaFKQo/+Ww6/yDOBgtACkbpeBxZAbppPnQBPrkU2aX5rDNb9nsk4GAe2uDH0X
         PkMRiCEcTWFMwvr6APde6nleDDPpsXF2GEeNuSj703XF/3JRcgn95I78UyM0ida9nnZb
         izfwhlgEJSf06m5uDRZbGg8cJuiYWWRf4AuYCol3vXa9RIxihJOS3D/lh0sVKEqh1tGt
         iR3w==
X-Gm-Message-State: AC+VfDzRF1myR6GLH08+lv0IPjIm0QEhp9LAnCJWS0Q6PDKXTIS44Fe0
	orTznS+h622KWwaISjnpUU8=
X-Google-Smtp-Source: ACHHUZ7pH/eLfdAc/g3kiQD0PwO25nkisNEYfd082agijeALc/GdCksAzvKGU49RUmR4InfRdihthg==
X-Received: by 2002:a17:90a:1db:b0:25b:b703:43e2 with SMTP id 27-20020a17090a01db00b0025bb70343e2mr3545963pjd.8.1686495460633;
        Sun, 11 Jun 2023 07:57:40 -0700 (PDT)
Received: from localhost.localdomain ([103.116.245.58])
        by smtp.gmail.com with ESMTPSA id v15-20020a17090a088f00b0023a9564763bsm7578611pjc.29.2023.06.11.07.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 07:57:40 -0700 (PDT)
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
Date: Sun, 11 Jun 2023 22:57:28 +0800
Message-Id: <20230611145728.655524-1-zhaojh329@gmail.com>
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

Sorry, I misread the code.

