Return-Path: <netdev+bounces-2917-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11D0A704829
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:49:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 950C12811D6
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:48:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5BAD2C72D;
	Tue, 16 May 2023 08:48:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5D22C726
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:48:57 +0000 (UTC)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95783AD
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:48:56 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-969f90d71d4so1394789566b.3
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1684226935; x=1686818935;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UCUEsQWywfzvnNkzWZz14anWyPMkxondrNA7tsslfks=;
        b=cZ5zOgbxSZe3gUtZkULV30ThCoSJbvbkkrFMtGt4VCU5sg3yx9hvI1vyefqzNhjaGS
         4J+Fc6Wwic6ysXQXpGRjs0P1ZUp41P9NXp/al3SsoHpxQKPK0WiOUBj4mmWtTRRvQmmT
         lE/2Q7HRIGZiHmn1y/qIKVJ9WfblRAwnjfBjwl3mppDaUg4ebubU95OWNzv6RLzgFemu
         RnNBxoLgskwe89M4bmDvqs8Xss74OPIgW/qYsuw30vs/miVgGbF71RPkBxf4LPwuhDK7
         FApqwHtfeqVCIqDFSUBBB8UGz+x9Fnu4x8jPxq1JpynLuK7ymCWzcSy+YF02h88KCJya
         1kJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684226935; x=1686818935;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UCUEsQWywfzvnNkzWZz14anWyPMkxondrNA7tsslfks=;
        b=VnwzcDKD0wMLZaMHdMiyDB24i7wMxKASRo6Hz1C8phbDA+xU06i+KbsvEO4CCzX2sP
         lnIfAuvS1DyxzfV4nnYnEhesPlhS3z/xWQHjxAQbBbPR03qDiyZ2kGSM6fWSDDb+MUvP
         7gZoUaPQ60PX8HizOQDT72PgA48RzBL9i29Bl7cpKr4NjgvuknmioH/W+QR1v4p8fv+p
         Fq6Q4tzpkdMYzsV9QiEsniBQR1F11qtzT5vpIiF6PMRUDyIv1uZlMhfQ6ozGVfz5f5xl
         7oeWO/JC1obdOmsitcEf1gsWPWgw2KUWk2CI8YqG4jNkDICL9s8S4sFDBjWEodrefXJn
         qDVg==
X-Gm-Message-State: AC+VfDyLE6MtbEKVvO50M6UBFCKa/qTvxO4Hv7aeyDpMLcOS7qKpMtxb
	uNMbshfIRzfwytDbeM2EBGiluHbwIHqPqEMyfBZ3ng==
X-Google-Smtp-Source: ACHHUZ6uJ10q4yj/V1YfpIKrnrGLf/xrc/uCrAFulYeEqyysAbJfQXqtCdXBXVScPRHbafrqaJd64g==
X-Received: by 2002:a17:907:5ca:b0:965:6cb9:b768 with SMTP id wg10-20020a17090705ca00b009656cb9b768mr30365340ejb.31.1684226934480;
        Tue, 16 May 2023 01:48:54 -0700 (PDT)
Received: from debil.. (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id jr18-20020a170906515200b00965f5d778e3sm10699241ejc.120.2023.05.16.01.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 01:48:53 -0700 (PDT)
From: Nikolay Aleksandrov <razor@blackwall.org>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net] mailmap: add entries for Nikolay Aleksandrov
Date: Tue, 16 May 2023 11:48:49 +0300
Message-Id: <20230516084849.2165114-1-razor@blackwall.org>
X-Mailer: git-send-email 2.40.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Turns out I missed a few patches due to use of old addresses by
senders. Add a mailmap entry with my old addresses.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 .mailmap | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/.mailmap b/.mailmap
index 71127b2608d2..bf076bbc36b1 100644
--- a/.mailmap
+++ b/.mailmap
@@ -364,6 +364,11 @@ Nicolas Pitre <nico@fluxnic.net> <nico@linaro.org>
 Nicolas Saenz Julienne <nsaenz@kernel.org> <nsaenzjulienne@suse.de>
 Nicolas Saenz Julienne <nsaenz@kernel.org> <nsaenzjulienne@suse.com>
 Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
+Nikolay Aleksandrov <razor@blackwall.org> <naleksan@redhat.com>
+Nikolay Aleksandrov <razor@blackwall.org> <nikolay@redhat.com>
+Nikolay Aleksandrov <razor@blackwall.org> <nikolay@cumulusnetworks.com>
+Nikolay Aleksandrov <razor@blackwall.org> <nikolay@nvidia.com>
+Nikolay Aleksandrov <razor@blackwall.org> <nikolay@isovalent.com>
 Oleksandr Natalenko <oleksandr@natalenko.name> <oleksandr@redhat.com>
 Oleksij Rempel <linux@rempel-privat.de> <bug-track@fisher-privat.net>
 Oleksij Rempel <linux@rempel-privat.de> <external.Oleksij.Rempel@de.bosch.com>
-- 
2.40.0


