Return-Path: <netdev+bounces-30-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D0E06F4CCC
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 00:13:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DF411C209C3
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 22:13:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B322AD5F;
	Tue,  2 May 2023 22:13:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787699470
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 22:13:25 +0000 (UTC)
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32261FE3
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 15:13:19 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id d75a77b69052e-3ef49c15454so21810541cf.0
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 15:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683065597; x=1685657597;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OSTE2EBzjtyK1nC8QYLZAUhuBEohE0E+dS8BewQx3HM=;
        b=a3g7NsB8a9g+kM+gkjrSWUac3bqHNHVPXXidB9fx//JWUdbEnIAPCvhMfqLdLQpOFK
         a2RaYBzNxut220TBLWJgE9Edo4F455BmRgA6i/K6FJ4Iyx32ZOS2rrlJCEaAaeN2WbGx
         TuMXpzHyhKum740JmsvYU30JyRf2AlXhvx1uHfflbTb9BjPfBwWOeIr+4XoTLAGcs7GM
         4dt9gN4ROLMe8GsufY5yoh6TcY03jtorzl/ENveesg1fThJAzWCU+KT/A9y16MDLdsmH
         Q4L9UrtwLhj6/0BbX0KWvL6138ZbNGzNBCc5XF7/QbO3JTPaSeHtJxaGgoHSicU17YmM
         3LSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683065597; x=1685657597;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OSTE2EBzjtyK1nC8QYLZAUhuBEohE0E+dS8BewQx3HM=;
        b=aCNb1qAjiHpGULRyqky74U/l645r3jOifXDF7tt+HideHD/K5Y+GO+RLswoL29jt+7
         PPgzj+bdLz9Cfd9+XSneT2As+4qUMZDtwNeo8UPe7cRX4xVEyQBO9WcCxNZK6MCuTxkD
         GhdtC+kI9YTj6R7q3uYQE+mcnEtxlExYi2os5JiXvweLdkxG08OJSXntdNFpKXWkYR3x
         M2uYPjAU0T/GKJSu/HXsLN7yv6o+DXoNkO5LeKECyVodE3ZanIODrRdgfUVD2NZWIDg/
         lWmEd/6cwh1096X7zRb49V4FEuizqwtAEWLSH1gblPBSSHIhfhZ2jk1ieflsi7JsfV1J
         P1bA==
X-Gm-Message-State: AC+VfDyQVo4UT41PEOApeCU1wPitRocWNnch1mMpKU0c82+er/LDGreu
	g6SN7nXX8+QStjP7f8HbdqT1Xs9pUHssnQ==
X-Google-Smtp-Source: ACHHUZ4BF2acC2J592aZmYL6ukFagSi04tFXhGQN5Fwb0tLOBzvxp/1ncpB5LoQgZRZVjbGZAvKOBw==
X-Received: by 2002:ac8:5a55:0:b0:3bf:daae:7ee3 with SMTP id o21-20020ac85a55000000b003bfdaae7ee3mr30438427qta.53.1683065597462;
        Tue, 02 May 2023 15:13:17 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id cf23-20020a05622a401700b003ef58044a4bsm10362636qtb.34.2023.05.02.15.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 15:13:17 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	tipc-discussion@lists.sourceforge.net
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jon Maloy <jmaloy@redhat.com>,
	Tung Nguyen <tung.q.nguyen@dektech.com.au>
Subject: [PATCHv2 net 0/3] tipc: fix the mtu update in link mtu negotiation
Date: Tue,  2 May 2023 18:13:12 -0400
Message-Id: <cover.1683065352.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
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

This patchset fixes a crash caused by a too small MTU carried in the
activate msg. Note that as such malicious packet does not exist in
the normal env, the fix won't break any application

The 1st patch introduces a function to calculate the minimum MTU for
the bearer, and the 2nd patch fixes the crash with this helper. While
at it, the 3rd patch fixes the udp bearer mtu update by netlink with
this helper.

Xin Long (3):
  tipc: add tipc_bearer_min_mtu to calculate min mtu
  tipc: do not update mtu if msg_max is too small in mtu negotiation
  tipc: check the bearer min mtu properly when setting it by netlink

 net/tipc/bearer.c    | 17 +++++++++++++++--
 net/tipc/bearer.h    |  3 +++
 net/tipc/link.c      |  9 ++++++---
 net/tipc/udp_media.c |  5 +++--
 4 files changed, 27 insertions(+), 7 deletions(-)

-- 
2.39.1


