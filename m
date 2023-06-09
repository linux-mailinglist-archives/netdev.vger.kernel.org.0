Return-Path: <netdev+bounces-9703-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA7D472A4D1
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 22:42:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D65C1C20CC5
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:42:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 063171548C;
	Fri,  9 Jun 2023 20:42:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8C3408C9
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 20:42:50 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963583583
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 13:42:49 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5692be06cb2so28207907b3.1
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 13:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686343369; x=1688935369;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nilVUYHBI+XDuxDJXu1TYICkdcT3kCIqdArG2v79qdg=;
        b=T+niFhomPfZhYJErb+0r8g48XLLJkZdDlUyrzGnLkE5CxuhgTsO6j+dQq6zx2LsLCh
         18KtGe4FYcvjsIpTdqDd1c7+fZZ13R9q+D+RFRIhecqh4Y39iuF3x3/G4CxYCmu7qPDA
         kCXucnmkwjwVAXHmFWbJ3OOoX2jZ0CdpkJvMZNH5681apbrg2ruXUFByGQtacAxW09pQ
         iPiF6aWC6yzCQyhkdgkBYKHmqYfF2onTojTOM16tpwSY63tTNzGyfPgxYCSoKmopKG/x
         j1BKP6bNZWZ7dDdK0BbLt/6zAUpLpZBlpP0xcUza+GFO7e4kOXG1DyphZrTgW56MQ+Nn
         Hrjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686343369; x=1688935369;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nilVUYHBI+XDuxDJXu1TYICkdcT3kCIqdArG2v79qdg=;
        b=YzFxbr5S0hHB5OiEiXBJL502kxlVQp7T8MLMwUb0nfXsu50hYWBR/Myq2f4qDnqjhE
         F93V70d+yhLdDROri9ZjU49hpuVONspZzXzBuITZrxvObHQuLtvoVpOFnNVCeO6sxLRu
         22+/IClpX6AVHQLCKTj35qOi1Q8cUW9Z7JHQNhZzSQ7dLMbxpCneCf3ac28DjteCy9zK
         24x8un/0cm4+jdt4Omm888ljU1zQxPYK0QDgddFE71Hy8yoL+ojkIcf32/4iCjE+voqF
         zuj3aGphucXujG96MbEkIGsGYBzKlHWHTLMBJSNXlSuAl4cvmB9TWLjnhsz3kgzTzx9p
         2bRg==
X-Gm-Message-State: AC+VfDyfQzmFsGWz7SCMa2NuNXJ5lakrLQ19cdX77s1KPyssvI7ItEb5
	b1tN9WB/KJsOTrHXWCfszyttVv/hygas/Q==
X-Google-Smtp-Source: ACHHUZ4GljA2F55veV5HE59jOy4XmWANEJzf/PPPf1oFRP3H8lql6RC3IbM2dcdZw2JoVJM7FJ++bUCPPGOwBg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:75c6:0:b0:bac:2448:2aa3 with SMTP id
 q189-20020a2575c6000000b00bac24482aa3mr654774ybc.9.1686343368802; Fri, 09 Jun
 2023 13:42:48 -0700 (PDT)
Date: Fri,  9 Jun 2023 20:42:43 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230609204246.715667-1-edumazet@google.com>
Subject: [PATCH net-next 0/3] tcp: tx path fully headless
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This series completes transition of TCP stack tx path
to headless packets : All payload now reside in page frags,
never in skb->head.

Eric Dumazet (3):
  tcp: let tcp_send_syn_data() build headless packets
  tcp: remove some dead code
  tcp: remove size parameter from tcp_stream_alloc_skb()

 include/net/tcp.h     |  3 +-
 net/ipv4/tcp.c        |  8 ++---
 net/ipv4/tcp_output.c | 77 +++++++++++++++++++------------------------
 3 files changed, 40 insertions(+), 48 deletions(-)

-- 
2.41.0.162.gfafddb0af9-goog


