Return-Path: <netdev+bounces-7249-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE46371F518
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 23:53:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0BA3281914
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 21:53:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2DD024156;
	Thu,  1 Jun 2023 21:53:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED88182D0
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 21:53:02 +0000 (UTC)
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BC4180;
	Thu,  1 Jun 2023 14:52:59 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1b0314f057cso8201325ad.1;
        Thu, 01 Jun 2023 14:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685656378; x=1688248378;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6LA2WfV+MGNSQK0LQ+YPYdqGXEsb6E+SKA1yS0FnP30=;
        b=hjHniLhauhO+b1lPsrb8bymLLAaQS3SJoca0H1MPIeUNu+eJfcea6YIbID5ehJuLa1
         AyI5tV4lvKSbhuFDT5pU6lKxKL00tdCZSY1Y//rIqr9OZrtGFJW6g0ASdct3dpsywlyn
         vmplKyDWVG8JhxUV87vGedwljJf94nos5L7x93ikOyiXhX6cwE/CmH1oqcLBCueB0yuw
         K+0jiNJ45C3xo0RYHsCNaaKAP7Hz+lOimpOSxiggucmkk5UOpHz6kvdreQAZc3IIKxAg
         z5bnBpW7UCZfkPiuN8yOqrTsqHlQyQj+++omR6RvUUiGy2Fl92ajCcXnG9iG6eqxWXvJ
         xpXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685656378; x=1688248378;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6LA2WfV+MGNSQK0LQ+YPYdqGXEsb6E+SKA1yS0FnP30=;
        b=SzyNjkQotOwrVyC/KiIZQFqKpyDv/fi+0Kge4ehMfRLt9SLcs9gmEssSLjqbfPI8cb
         NF4kksmKTzNjYS2cTyLdaASVozN3Y0ET0UUig/mhU4dpVrasn1THPHPz4uriwg/XWBgw
         OhHUZfz8IX9+6+yiU24G0AjvzGbV4YFOqmgA+GBqRn8HtxTgQD/LKVeLLbd9ykUAtyXN
         BkTaF3cVVOs0izgsU2NzyJOxWxC7GDBpB4HVOuTmn89/i47t99bmpd58WvGRi2pnM1tR
         NS16AM83Hqug0zFW9mtLv3uAstROPJkJkj0nb/itAwTmrHtW8i0xreeZ/tpk2cGN/U5s
         SXIQ==
X-Gm-Message-State: AC+VfDzUNFAPt9CGzDoSPx6lA4FzRARnfrmZqWXrX2Ch93MAAlQgKTAM
	uyb6kEdDjs9UM8k6QDlhSWo=
X-Google-Smtp-Source: ACHHUZ6ZBwPyFrHRKP+2cT8NyeVpiVYTb+w8A7XCEPtDWEPa+CNgGLC6lMQbthcGVRqxwj2iZ6d9uA==
X-Received: by 2002:a17:902:eb46:b0:1b0:5814:d8d4 with SMTP id i6-20020a170902eb4600b001b05814d8d4mr548919pli.53.1685656378520;
        Thu, 01 Jun 2023 14:52:58 -0700 (PDT)
Received: from babbage.. (162-227-164-7.lightspeed.sntcca.sbcglobal.net. [162.227.164.7])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902650700b001b034d2e71csm4049207plk.34.2023.06.01.14.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 14:52:58 -0700 (PDT)
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
Subject: [PATCH net-next v5 0/1] net: dsa: mv88e6xxx: implement USXGMII mode for mv88e6393x
Date: Thu,  1 Jun 2023 14:52:50 -0700
Message-Id: <20230601215251.3529-1-msmulski2@gmail.com>
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

Re-generated patch against net-next(main) updated as of 2023-06-01 

Michal Smulski (1):
  net: dsa: mv88e6xxx: implement USXGMII mode for mv88e6393x

 drivers/net/dsa/mv88e6xxx/chip.c   |  3 +-
 drivers/net/dsa/mv88e6xxx/port.c   |  3 ++
 drivers/net/dsa/mv88e6xxx/serdes.c | 70 +++++++++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/serdes.h | 13 ++++++
 4 files changed, 85 insertions(+), 4 deletions(-)

-- 
2.34.1


