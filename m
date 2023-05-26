Return-Path: <netdev+bounces-5677-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB9F87126BC
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 14:34:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6125D2816BE
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:34:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A457F111BC;
	Fri, 26 May 2023 12:34:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C1B111B6
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 12:34:00 +0000 (UTC)
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8D2E62
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:33:28 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id af79cd13be357-75affe977abso99704185a.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685104360; x=1687696360;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6X4Bfe6hVtGh+yHd5QM/+fO4/1vvEt43SDEWITn87u0=;
        b=oGE6hEKAWYztS8Y+SBy/2Iapgm3o3xxyFT4qgVOOBZp9kRsrAzP1hBtdf2gBtfF0i6
         g4AXvEx0buL97QpI+PakxIEZQfyBpBFVD6cLvr6EFotdUn+66lxAFcZYrBIdDN+2dOfB
         qjYJifWdFS9DpdA3/qmGjmy42WD8sYW3zC0fK+6c3IYhY9mJOh50w5XAZQh/HPj5wDbT
         DA5Tpg3Fuk20I5Leke5TYrqMq5ObxxWYiHXugwW7SWMT4TU8NVSZLQ+gVhumw0lHzX82
         zDiPozYSLY34TCYPTagNs6N5lZCIchT8r4EnG6QsLMuE2rIOlRc5HdBGvjVyR/mmdLfC
         RCuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685104360; x=1687696360;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6X4Bfe6hVtGh+yHd5QM/+fO4/1vvEt43SDEWITn87u0=;
        b=GCYADZKpoRzkvqjHAPrYdqmLCxrL9L76AxTpHAFKtFnaXTGY2+Ai+aqOv5ZFQs4SXL
         gdky3y5aSBa5zNiH3JmHHnygA0p0qxOtNei2zLoCu698pni9rJc2f6kHKQHMLm53z2U7
         Ns2hSqhqK55u/JLYZrm6DQyks1q/QUVK94FNy9Bd44+5Fqdurjefn/HKrfbeNEio8xov
         vKJrQoa8PwIH1YKFdgJpYeWimQi8qK1q1vi/inPcfgxJuf940E5Ync+wgLJuSOXRgK2l
         WL5TpnSXlU4PQKCqfpSbILjEd+kBxJ7IBKQR/SHuuDk5Sqj7xG0mcJXtco8cMSNW7F2D
         R6Xw==
X-Gm-Message-State: AC+VfDxvjgVVJN3tnG8HKRn6Z5l6AA+kG7Big4YPZMpchCY5wlVPnKnE
	AEqXsLvr9yEiYo5jwi6dShrshsjdjJxyGnSs
X-Google-Smtp-Source: ACHHUZ7MHN2lEP9V1/EgkKZN0ShEt946ZoMgt+dwnf4qrDwDMUTcpxcMjGNoO+aG4L5lLPZADA1gcw==
X-Received: by 2002:a05:620a:8287:b0:75b:23a1:3611 with SMTP id ox7-20020a05620a828700b0075b23a13611mr1544031qkn.34.1685104359913;
        Fri, 26 May 2023 05:32:39 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id d13-20020a05620a166d00b007595614c17bsm1121026qko.57.2023.05.26.05.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 05:32:39 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Cc: donald.hunter@redhat.com,
	Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v1 1/4] doc: ynl: Add doc attr to struct members in genetlink-legacy spec
Date: Fri, 26 May 2023 13:32:20 +0100
Message-Id: <20230526123223.35755-2-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230526123223.35755-1-donald.hunter@gmail.com>
References: <20230526123223.35755-1-donald.hunter@gmail.com>
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
2.40.0


