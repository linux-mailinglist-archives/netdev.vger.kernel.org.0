Return-Path: <netdev+bounces-7858-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12140721D96
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:40:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4702A28116C
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 05:40:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A07123FE4;
	Mon,  5 Jun 2023 05:40:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9409C17F4
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 05:40:02 +0000 (UTC)
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DDBA9;
	Sun,  4 Jun 2023 22:40:00 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-19f31d6b661so5096712fac.0;
        Sun, 04 Jun 2023 22:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685943599; x=1688535599;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hcDHb3otHZKZPSZ9/RvK/O8QwVbU81EhbliZYL0NPkw=;
        b=VPM/BXLGlEDJFZWtZzHA9AyA+AWECn9ORWX87ESiadzudMovZJ4TxOXbq3OiHBZ6k9
         /qnpQDkDETmsevI+Rin4e8jSBoKnTuYx1S1jhOEpR1bk937Fn6p2Xn4Q7kjgWfI99JWW
         E7jun7sRtg2M5R2C6uZYhQ9JhYp8p8v6Ou2tWaJxbNIjz+ezNh7sbJep586MB1MLVDtJ
         a8vxzculTBcOZqYhnHuTq6uY8+WP+kJmf23+VdzWNnQMG00cShQt1WlQYFfsSMWb9XwF
         dNhGj6G2pFcRCTly665LqkWnAbY/Hl04D04NFY/76kKHuIR78pWmo25O1RDfNAX4tLtx
         EDeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685943599; x=1688535599;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hcDHb3otHZKZPSZ9/RvK/O8QwVbU81EhbliZYL0NPkw=;
        b=Z6SIGko6QQ2iTfJdb6NnclywZPdahsU5TKLTux69dkKI4+S4nP6t3is5GJPZVR+2TU
         jNUwMAJChEEwhhfrktGlXSKNvTsrqInPJSPBv8Anz9i8IFtgjLSZXEKhXNrjHVHha/qP
         4CqfBaJCUzOgP2WCJzwDmbwQLsEQwITufz+eOJKaKCTGiNLpAkkvSjEDVZlku7iQeM4P
         0NGICRXV7nZX/zi0Bts5kNpaq4dzgmBQggA9T6mVGSwocruoDpIBDaB/fLqWo1ckFi5E
         qgffnAPDlVNKd4+nPA8G75pHzhh1wp5zDXNsmAhWBMn2O6r9e+NaRZ56O+42fgvMckq5
         X4+g==
X-Gm-Message-State: AC+VfDzBih550REV83kCuTXj5JptrxHw6kHarq6kUjAWzg+VXecnYlaw
	JhmmJ/d2u83X64A32phwYp4=
X-Google-Smtp-Source: ACHHUZ7nwScN4/QpnlQXcDIoAa1VMEla09SP1nuo4C58NKf58t6Vzxs5LbbOctcoIfQ/6eoTKZ1w1A==
X-Received: by 2002:a05:6358:9316:b0:121:4f03:1ef0 with SMTP id x22-20020a056358931600b001214f031ef0mr20962182rwa.19.1685943598629;
        Sun, 04 Jun 2023 22:39:58 -0700 (PDT)
Received: from babbage.. (162-227-164-7.lightspeed.sntcca.sbcglobal.net. [162.227.164.7])
        by smtp.gmail.com with ESMTPSA id c13-20020a17090a674d00b0024dee5cbe29sm4994822pjm.27.2023.06.04.22.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 22:39:58 -0700 (PDT)
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
	ioana.ciornei@nxp.com,
	Michal Smulski <michal.smulski@ooma.com>
Subject: [PATCH net-next v7 0/1] net: dsa: mv88e6xxx: implement USXGMII mode for mv88e6393x
Date: Sun,  4 Jun 2023 22:39:53 -0700
Message-Id: <20230605053954.4051-1-msmulski2@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Michal Smulski <michal.smulski@ooma.com>

Changelist:
* do not enable USXGMII for 6361 chips
* track state->an_complete with state->link 

*** BLURB HERE ***

Michal Smulski (1):
  net: dsa: mv88e6xxx: implement USXGMII mode for mv88e6393x

 drivers/net/dsa/mv88e6xxx/chip.c   |  3 +-
 drivers/net/dsa/mv88e6xxx/port.c   |  3 ++
 drivers/net/dsa/mv88e6xxx/serdes.c | 47 ++++++++++++++++++++++++++++--
 drivers/net/dsa/mv88e6xxx/serdes.h |  4 +++
 4 files changed, 53 insertions(+), 4 deletions(-)

-- 
2.34.1


