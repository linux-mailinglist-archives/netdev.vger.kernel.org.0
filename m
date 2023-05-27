Return-Path: <netdev+bounces-5905-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28B95713501
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 15:31:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 868B01C209D5
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 13:31:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9122511CB7;
	Sat, 27 May 2023 13:31:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8177B847B
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 13:31:21 +0000 (UTC)
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F1EA6
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 06:31:20 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id d75a77b69052e-3f6c014d33fso8298971cf.2
        for <netdev@vger.kernel.org>; Sat, 27 May 2023 06:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685194279; x=1687786279;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7ZvXOnRyI10Cg/XyOu+r6iFTXWEGhzLKOZ+rAL5qIeI=;
        b=SxJFGeZgpW1335Z9lqZZ3WlGOnOIn5hPrg9ln1W/RcxiDZW/ocgnHZOv5U93KbSQ0w
         P1Nv88c6szWPYL3W4Sg60Ny9E4bT6J4MbLp+vyPW9tRh3Us+QSQvBbqEXv7zoC4TI1hS
         ROuj8yEqc7Yer1SHlOR12t0VSgNnO8XwwjLN8w2XgPLRID7QVLvlC80GPXtD5tIblibN
         wm+cumkLH8Jdn+u/krvQvMpyUSVC4aTt7VorGHNMJtPg+LIrzJk8jbnxBRd1vhRr2skJ
         wl4WVWkIS80A2ELxG/ksANN9ppCumt6lCsfGTy2oxYtIJcpF3Fgd2jDWFrR6DHJqJIXj
         HE4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685194279; x=1687786279;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7ZvXOnRyI10Cg/XyOu+r6iFTXWEGhzLKOZ+rAL5qIeI=;
        b=Lp2ko21Ta+u/JI0JU5VUi+ap3sKEGDLJJur6t4dD976UA7hzZTibbpqea0OGWXct/6
         m2IkwFyOGIHznp+y28F0YFUX/701KCYcLgDauV8GZWHntRoe2BhXz1hgchDRxJ6/ocxE
         T2cM/nr3oDSORE9+GsJoo53tWeBI7On7nOQEN5qOdNG4DBfiFZ3w5jHPPLviLupgVAbb
         /ICytzg7/R+uJ4gIJApg61wV2z/SSBD31UsEEtJdEXZcSZzb1QDef2PFx5BMPJyf/rVD
         rMzjy+Eh7XvI3gLIGARgeXHPZKl9HTcAHgqbShMsDhlyHVl5muu8WaRRCJ3ZTNgt4Zq0
         kApw==
X-Gm-Message-State: AC+VfDwGvHOLngbprJ0uQVMrwA1ZrfQxOSkhaTLCGHIN7DItTaVHtSmK
	4/lsSauWjFwzmMHXezVK6T1owRXV86YLFFVB
X-Google-Smtp-Source: ACHHUZ6k/lcJGCwnRYa2i5AvySkl6dK3vCQ18CHWFZQwXGf5BtR3yyAmfeo2JTybllPMFYnoBcwvAg==
X-Received: by 2002:a05:622a:50:b0:3f5:3f9e:ffce with SMTP id y16-20020a05622a005000b003f53f9effcemr5194976qtw.43.1685194278699;
        Sat, 27 May 2023 06:31:18 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id b10-20020a0cbf4a000000b006215f334a18sm2020282qvj.28.2023.05.27.06.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 06:31:18 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Cc: donald.hunter@redhat.com,
	Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v2 0/4] netlink: specs: add ynl spec for ovs_flow
Date: Sat, 27 May 2023 14:31:03 +0100
Message-Id: <20230527133107.68161-1-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
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

Add a ynl specification for ovs_flow. The spec is sufficient to dump ovs
flows but some attrs have been left as binary blobs because ynl doesn't
support C arrays in struct definitions yet.

Patches 1-3 add features for genetlink-legacy specs
Patch 4 is the ovs_flow netlink spec

Changes in v2:
 - Add reply attribute to flow-get op as reported by Jakub Kicinski

Donald Hunter (4):
  doc: ynl: Add doc attr to struct members in genetlink-legacy spec
  tools: ynl: Initialise fixed headers to 0 in genetlink-legacy
  tools: ynl: Support enums in struct members in genetlink-legacy
  netlink: specs: add ynl spec for ovs_flow

 Documentation/netlink/genetlink-legacy.yaml |   6 +
 Documentation/netlink/specs/ovs_flow.yaml   | 831 ++++++++++++++++++++
 tools/net/ynl/lib/nlspec.py                 |   2 +
 tools/net/ynl/lib/ynl.py                    |   8 +-
 4 files changed, 845 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/netlink/specs/ovs_flow.yaml

-- 
2.39.0


