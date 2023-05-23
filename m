Return-Path: <netdev+bounces-4613-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF79370D93F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:38:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4D0F1C20CC6
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:38:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4A561E515;
	Tue, 23 May 2023 09:38:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940831E500
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:38:04 +0000 (UTC)
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F005F119
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:38:02 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id af79cd13be357-75afa109e60so141676985a.2
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684834682; x=1687426682;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dr30X9imBEZFF8RYSJvvNbTUTKyxHmbeECUnehEEaT8=;
        b=Pi3A+4WWfBNBRsY8v/K/LC86XIvC4Te+u8zBO5MAaBfXeaAjir8xHoHnMajgVruiv3
         vniGGYx0xPeOygpvFzMMXKhIJ0pHg/qKstN0i9DZC6eRmNaMO8KYRztKr08aZjPfXSJO
         WKipL4L2P2ZBrkm9V31X0WyO8nP3u8yAzQZc2oDOrxzcGgCUINYPiXOxYLBhN1FfzBsH
         hXARmT9kUHEKBSoO+SFXoEjrRH1lIXbS9LqbN0sekxwsPERMcF4LKNNDFrr3tTDWfsVc
         7XALNMisErf4Aj6HSW9kfmWkwwvmtnhzu+Kmhvl1t1xzHaQ/eWtIzKOASpBvaa2lhw5K
         rkDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684834682; x=1687426682;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dr30X9imBEZFF8RYSJvvNbTUTKyxHmbeECUnehEEaT8=;
        b=Tcf3SyENulODZ0udWRPK/EXHWE9kl/CSotbTle2xZYs632Mers/Tz2PsOeecPEZLIe
         FuULt38XXY0aZpD3mX721QajnRqkcZSwYgKmgqD6kPdbMDTzXSw43QA5Rre2MmRpV3qj
         EbztYqAyYUHdt9lzCme0oyESEFavCypNxjWoKBza8X84B6zBhScAQW9prQUPITR2l3g1
         Xn0mAvwKhMS1pP5gllsKKazgCo/p466oXtq6P70l0tLTrD8SwG/aELi0S39KYLIVK6hV
         q+sxpp7TwJlGTVxwieoFTdMPkWK0nx0Ocoyva5ufD1vEWWXEChMI53RubrfQ+LaQSQzA
         sz4Q==
X-Gm-Message-State: AC+VfDzuxCcNW3cBKrF/yNXSfwACtC0DL1/zm3/PSYGqw+hwzB+EwLoz
	HUimajJQym4kPwytGh/V06a75vv/KqOqLIMV
X-Google-Smtp-Source: ACHHUZ4Vbl4E+/X+/UDQWpK47bNR9aw1NlSj7COolKV/DVwOF5ILFAjkfzTtJMUvDY0XhF+SCeN4dw==
X-Received: by 2002:a05:622a:14d0:b0:3f4:ef5f:b5c7 with SMTP id u16-20020a05622a14d000b003f4ef5fb5c7mr21811484qtx.0.1684834681554;
        Tue, 23 May 2023 02:38:01 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id x7-20020a05622a000700b003bf9f9f1844sm2758128qtw.71.2023.05.23.02.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 02:38:01 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Cc: donald.hunter@redhat.com
Subject: [PATCH net-next v2 0/2] tools: ynl: Add byte-order support for struct members
Date: Tue, 23 May 2023 10:37:46 +0100
Message-Id: <20230523093748.61518-1-donald.hunter@gmail.com>
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
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Donald Hunter <donald.hunter@redhat.com>

This patchset adds support to ynl for handling byte-order in struct
members. The first patch is a refactor to use predefined Struct() objects
instead of generating byte-order specific formats on the fly. The second
patch adds byte-order handling for struct members.

Donald Hunter (2):
  tools: ynl: Use dict of predefined Structs to decode scalar types
  tools: ynl: Handle byte-order in struct members

 Documentation/netlink/genetlink-legacy.yaml |   2 +
 tools/net/ynl/lib/nlspec.py                 |   4 +-
 tools/net/ynl/lib/ynl.py                    | 101 +++++++++-----------
 3 files changed, 49 insertions(+), 58 deletions(-)

-- 
2.40.0


