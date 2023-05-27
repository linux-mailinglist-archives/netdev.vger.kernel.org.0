Return-Path: <netdev+bounces-5906-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE425713502
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 15:31:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 523B71C209FD
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 13:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAF41125A4;
	Sat, 27 May 2023 13:31:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD726125A3
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 13:31:22 +0000 (UTC)
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA7AA6
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 06:31:21 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id 6a1803df08f44-6260e8a1424so4753136d6.2
        for <netdev@vger.kernel.org>; Sat, 27 May 2023 06:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685194280; x=1687786280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3iv2Uw2VUZnaHXukTO80M8vue39EcfBHRFOOD/lQVJA=;
        b=KKY7tWWONZ99JHnmx9TwZReIYXJsF4YYYQJ6STCZ25lnyL3ETzO1f6OxWKajWUBFkU
         i1zPrpiudXW5YgbwH5O/C/D23eCZn6HQPYAZjNTd0M8a/V8LfI2EkCefiHaSHmyewefM
         9GzrItDptbIpDCjSt0eeF1cdTLZpj07vRnILMaQf41NNtPCr7IFREnH6D5vdCUQPozAG
         RmV+0ajJVTmspXcW7RU0dUkXGMqv8cTRELbCmtRxGC/o267+4R85ucDJZq3cOeVUN1Mv
         1PVah7JPMSVlJtrBqHJAjDDN+EIkrmsVmhwUSe+G8cc0DEuhyxpUshm0+DbZ4SNu5pAy
         ewzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685194280; x=1687786280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3iv2Uw2VUZnaHXukTO80M8vue39EcfBHRFOOD/lQVJA=;
        b=BEw3Zxd7J2YW+eiHd/QNxM5j47hxlXfVu0Z340iLQaICa/GzizH/nUBCeotcmVxQuc
         gt+vLKseWYgnsiR1uvOQI5SJCJdCjrAPasz22pfny9EzhDGUHPiuT1RwmQNOUOKIcbfg
         VmEMeNAAzBfTX6yvDPAr0JDaqjZSgzdkz4LXn36Fy3gVJ8vxRtYjX5Ap7mJL4epxz8Vk
         QBNBKOA42tkpjTGbLIgOx5lRhK/RiIqKEKlpsGl+9PRR13Nu/qDNUnHIbi3+9Jmp/dv6
         FnSuuLtfG22nOZ4+1eDd3svTKMYyNoBgPtDoq1RpCJHLAqUTMFWICfsuXhfEVWqXOfns
         JdQw==
X-Gm-Message-State: AC+VfDxdzBpK2G3gzqjDq8AQu0s0N439U913sykrpl1ZFAV9CruJBDnJ
	mU4eB2D2yXrPCIiXwpu5OJOrZkIoZML78ud+
X-Google-Smtp-Source: ACHHUZ4XicAWkrB00prAaaCQK1hhHlkPdvXJkeNnaG3O2GNQe2tJ8qi4EhuGu3Woc5OGQMkWTwuJcg==
X-Received: by 2002:ad4:5ce6:0:b0:626:476:5ea1 with SMTP id iv6-20020ad45ce6000000b0062604765ea1mr6367766qvb.15.1685194280363;
        Sat, 27 May 2023 06:31:20 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id b10-20020a0cbf4a000000b006215f334a18sm2020282qvj.28.2023.05.27.06.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 06:31:19 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Cc: donald.hunter@redhat.com,
	Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v2 1/4] doc: ynl: Add doc attr to struct members in genetlink-legacy spec
Date: Sat, 27 May 2023 14:31:04 +0100
Message-Id: <20230527133107.68161-2-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230527133107.68161-1-donald.hunter@gmail.com>
References: <20230527133107.68161-1-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Make it possible to document the meaning of struct member attributes in
genetlink-legacy specs.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 Documentation/netlink/genetlink-legacy.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
index b5319cde9e17..d8f132114308 100644
--- a/Documentation/netlink/genetlink-legacy.yaml
+++ b/Documentation/netlink/genetlink-legacy.yaml
@@ -124,6 +124,9 @@ properties:
                 $ref: '#/$defs/len-or-define'
               byte-order:
                 enum: [ little-endian, big-endian ]
+              doc:
+                description: Documentation for the struct member attribute.
+                type: string
         # End genetlink-legacy
 
   attribute-sets:
-- 
2.39.0


