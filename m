Return-Path: <netdev+bounces-5907-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1874713503
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 15:32:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8568028170F
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 13:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92C65125D4;
	Sat, 27 May 2023 13:31:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8376A125A3
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 13:31:24 +0000 (UTC)
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5BBA6
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 06:31:23 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id af79cd13be357-75affe9d7feso224229185a.0
        for <netdev@vger.kernel.org>; Sat, 27 May 2023 06:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685194282; x=1687786282;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nf3lOZUzvZydP6gp+IGio5UD+biY/VzV28FgdqXsOsg=;
        b=bvrq6owDUC22yJrG/msO/ZMeygGNo1iTsMA8cs5YONnw4chflA+XKn3vqHkTnyGDAO
         T6kKT0ywCSkY08EoSNAVuw91dtP4FK+3uE2fxe7WGCToou1EomJ1QiNVup0e9qd2eV0K
         LRIWXvmXD234o4dB4PeqYjBLuqNYVfCkepYkttzOq0HV8hDRyJlH/ErUmvsjNkLAoVKS
         zO8fQo7SPMbWjv3insbIX4d0KcABV9sDFd3eBiGZng5FUq585I1Qop2oDNuhm+Ce4gpg
         +MVjHXLok2/bAiGfo6TMnM13//bxJKZFT19b+TInMHcAdoGaxhX2RlPQFjU4hrwI5eX7
         XS7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685194282; x=1687786282;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nf3lOZUzvZydP6gp+IGio5UD+biY/VzV28FgdqXsOsg=;
        b=cTxLzW+vdPUXDhKQbKGkHvxlx5Af1Sv2qybVarnTKt/dRjvKCX1Ey5D+AX5AaAWznM
         TNdoBPxVburyHgRO+S4x4HNhAUJUqXX4rkvoTXdhGdwzBw17M7IOaPMgvPQKwGa8+y7Y
         4Ggdw6lwbY/PLWVmiayHRlyHC5+i6/D5j2H5aCEsOC+k3/K/zcqZtzEmWOxHf2OgDlUq
         RNFCb96KcLc6y2ba8lePF9v01xPxc7PH/YiR6L2oprlfAxa268xphERfgacJVWniOAvB
         y3WBalqBF1nwwLDnLX8kyBdTgMIT3Ejg36/I0oMxKEZzae4BBhRpnrLJN9yzhK2cUgUB
         aj0Q==
X-Gm-Message-State: AC+VfDzOMp00Hk0pZLYLk5ZBQaIIggR1yWulP6PZXOtW9ByTHWM0DHSQ
	Kl8M7yLLAdmKjbps4gyW2in5hHvjJ9bzx+GN
X-Google-Smtp-Source: ACHHUZ62l7AtICiUAGeFw7WRITgx9f8/czCb06ZZNsF02KLAqMOCUPRwyoh6JKuJGidjOZJiT0aB1Q==
X-Received: by 2002:ad4:5b87:0:b0:625:aa49:c345 with SMTP id 7-20020ad45b87000000b00625aa49c345mr4673318qvp.57.1685194282107;
        Sat, 27 May 2023 06:31:22 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id b10-20020a0cbf4a000000b006215f334a18sm2020282qvj.28.2023.05.27.06.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 06:31:21 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Cc: donald.hunter@redhat.com,
	Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v2 2/4] tools: ynl: Initialise fixed headers to 0 in genetlink-legacy
Date: Sat, 27 May 2023 14:31:05 +0100
Message-Id: <20230527133107.68161-3-donald.hunter@gmail.com>
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

This eliminates the need for e.g. --json '{"dp-ifindex":0}' which is not
too big a deal for ovs but will get tiresome for fixed header structs that
have many members.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 tools/net/ynl/lib/ynl.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 39a2296c0003..85ee6a4bee72 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -541,7 +541,7 @@ class YnlFamily(SpecFamily):
         if op.fixed_header:
             fixed_header_members = self.consts[op.fixed_header].members
             for m in fixed_header_members:
-                value = vals.pop(m.name)
+                value = vals.pop(m.name) if m.name in vals else 0
                 format = NlAttr.get_format(m.type, m.byte_order)
                 msg += format.pack(value)
         for name, value in vals.items():
-- 
2.39.0


