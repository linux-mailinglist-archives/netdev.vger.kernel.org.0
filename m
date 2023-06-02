Return-Path: <netdev+bounces-7272-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0959471F70E
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 02:17:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C2741C21184
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 00:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 705FC816;
	Fri,  2 Jun 2023 00:17:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F5019A
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 00:17:11 +0000 (UTC)
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352DD12C;
	Thu,  1 Jun 2023 17:17:10 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-53f832298acso927774a12.0;
        Thu, 01 Jun 2023 17:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685665029; x=1688257029;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yrN0t9UfclF5cy9ZloYwTGr7DNKDxki6WiEgWkwACt0=;
        b=lhdPVIA071TFtqeyHYSqjD+WiSJe5DtZLJeVp0VVCLWYYZd+5WAjeq1hVbT5+7ClFy
         9u2kk7mjDc48JB9HqsVR2sAZ9rP81WaiX4dzkboZzQcHhpXACuDj2nnKilO0GpRb+w+U
         GHE3V9Wj+8jyWmXurP1jnV0hdWJW6F6Oc0kgM4cb7hNG2vjVJ9V93WnUUJaAuQFXy75M
         EX70u2pqVKKtBfi0cdlsZwHCN1KYMuyOQbtGqBzQwSBC8CYln56LMIhCGlMyKuL/Lhns
         nGOn2mA7NCNpeXL3+28jIJiSx++xrwO63IgXVRfw70YfqUbvm/+rxnFh81O4k0la58j8
         cWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685665029; x=1688257029;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yrN0t9UfclF5cy9ZloYwTGr7DNKDxki6WiEgWkwACt0=;
        b=lBTh2/8S8nxh4s7rd7w7H6AIBAv4rwqhc8aAOuqmVlGEhO1FKkk7IOhKBxLge3l5sn
         Qj4VB0DGZddT2L2eC5hmPMY3vxBwg7Ps/LDXCmxwD35trproipO8Bp6NPAjGEJK8jdCs
         ct9I/jp+w4WTji13M9xjU8PC+If1lpCFip1rzN6raHk3kg+pWFYTxT3mKUvIimnkyvIL
         fAy/QQ9Sj3DaIAIPw4T6K5c3esS8J19MryKz2yRists0ho4fJBX/5BFIfIC/MZeoRbjY
         cPEex1QdYSAIXmFyDBhVQr1HZwFFSRScvJ5xipmQRWIAJrt0TI3u7rin36o6pXgwr2MW
         rUbQ==
X-Gm-Message-State: AC+VfDz+VrSj8VzYByFTapUbvS8KNw2Bj00za3yiKRjDh/ms7+fCbTF4
	567iUYNCQgvnv2n/rRGkh7o=
X-Google-Smtp-Source: ACHHUZ4kgjZ/9aCx3yqrjCBRAZjTN9DN2TIK1WeVwg35b18YgGek5vl5Fbx+Mm9jblZN4JyRmlMgVg==
X-Received: by 2002:a05:6a20:1583:b0:10b:71c:20c5 with SMTP id h3-20020a056a20158300b0010b071c20c5mr9859169pzj.51.1685665029572;
        Thu, 01 Jun 2023 17:17:09 -0700 (PDT)
Received: from babbage.. (162-227-164-7.lightspeed.sntcca.sbcglobal.net. [162.227.164.7])
        by smtp.gmail.com with ESMTPSA id b38-20020a631b66000000b0051eff0a70d7sm8063pgm.94.2023.06.01.17.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 17:17:09 -0700 (PDT)
From: msmulski2@gmail.com
To: andrew@lunn.ch
Cc: f.fainelli@gmail.com,
	olteanv@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux@armlinux.org.uk,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	simon.horman@corigine.com,
	kabel@kernel.org,
	Michal Smulski <michal.smulski@ooma.com>
Subject: [PATCH net-next v6 0/1] net: dsa: mv88e6xxx: implement USXGMII mode for mv88e6393x
Date: Thu,  1 Jun 2023 17:17:03 -0700
Message-Id: <20230602001705.2747-1-msmulski2@gmail.com>
X-Mailer: git-send-email 2.34.1
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

From: Michal Smulski <michal.smulski@ooma.com>

Changes from previous version:
* use phylink_decode_usxgmii_word() to decode USXGMII link state
* use existing include/uapi/linux/mdio.h defines when parsing status bits

Michal Smulski (1):
  net: dsa: mv88e6xxx: implement USXGMII mode for mv88e6393x

 drivers/net/dsa/mv88e6xxx/chip.c   |  3 +-
 drivers/net/dsa/mv88e6xxx/port.c   |  3 ++
 drivers/net/dsa/mv88e6xxx/serdes.c | 46 ++++++++++++++++++++++++++++--
 drivers/net/dsa/mv88e6xxx/serdes.h |  4 +++
 4 files changed, 52 insertions(+), 4 deletions(-)

-- 
2.34.1


