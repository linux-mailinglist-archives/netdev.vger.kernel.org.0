Return-Path: <netdev+bounces-5348-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6E5B710E88
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:47:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 663581C20EF1
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:47:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAF56156E8;
	Thu, 25 May 2023 14:47:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF293FC1B
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:47:18 +0000 (UTC)
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15A8E7
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 07:47:16 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 46e09a7af769-6af6ec6d73bso650427a34.3
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 07:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685026036; x=1687618036;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/uBJ2DruwOG0cJncTPfGcoP5HR2V12nr6nJoowyl75U=;
        b=AYrRTeGyLAC+jXACnDjqAmmUQMkLO7cQDtroRMQjPGWCnWXoqbgwVucVG89UytROSq
         c7TRQ3aJ9+wEotz25FNmoQ7EpgAGdmb78/yv8nhbWC5moeVmQkJSs7M7KRUOJtZo9xby
         ajPF0YDnJizobAT62ZJgOhb+Ap5c5MpAD5+VKgiadNSakEj0p4C+vB98Z87jWQ3RPVtK
         Dsn5ywKJ4QJn/2R0ZT5w8D3898Tn4uZ89F6d6mgDTJwL6wVJjuj9C4yfzz+516mHQx5h
         AUKGOuZTs8nkag7B04ak8+Sj4O2SSVeJmGEpfiSsX3LF6Eh2WUrxZMi1c/Q3DGyNzK7C
         2RbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685026036; x=1687618036;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/uBJ2DruwOG0cJncTPfGcoP5HR2V12nr6nJoowyl75U=;
        b=dKK4KEYtd2CBp2cCi2g68dlYA9k0HAX98BKgTkAsd0isuMMxonywKztCNGZCfw4Xlv
         OpeohCxr+hkY9ZuN2x/alpCu3dlTuRRAVYXSnuAy3ImQ0Wsi3OFYFFCFRSnv98rQjJUg
         SA5Dy2kCXbmmk8E1EGJsH2bfJuoewW8mQexql8TE04vuFjotoVvVe4AQgF87Bud0ktmC
         ypM7tq/vAgCiORagbq/cS0O69NV/vWHMTCw/stSO0XR+CS/eWtcA+2dL0XnG58kHrv3k
         jUX8GTswdfCpIzZxbld4aNCxf2WiYvOPnvPRvSF8+HjJFnVtrK2RAfsGnxoLsl0u08kh
         mQow==
X-Gm-Message-State: AC+VfDwBc0jzFSepnC2B531sYpew7ukbfHCJSGSDhaPeSMhPKoK6F0D3
	Bhv2EIl8p/VshBGTjtM32/gXoPX5mBIrU+D2fo0=
X-Google-Smtp-Source: ACHHUZ6ikc3Rh0Knml2I3YmFUiyRb9z2izWu6NJmbINVSDX/FLIrGSId36Zx/FTkFxi3uc4NHcqxzw==
X-Received: by 2002:a9d:7dca:0:b0:6b0:c711:8dd1 with SMTP id k10-20020a9d7dca000000b006b0c7118dd1mr399029otn.14.1685026035975;
        Thu, 25 May 2023 07:47:15 -0700 (PDT)
Received: from rogue-one.tail33bf8.ts.net ([2804:14d:5c5e:44fb:6c2d:bef9:6672:b79d])
        by smtp.gmail.com with ESMTPSA id e23-20020a0568301e5700b006af731d100fsm661079otj.75.2023.05.25.07.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 07:47:15 -0700 (PDT)
From: Pedro Tammela <pctammela@mojatatu.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kuniyu@amazon.com,
	dh.herrmann@gmail.com,
	jhs@mojatatu.com,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net] net/netlink: fix NETLINK_LIST_MEMBERSHIPS group array length check
Date: Thu, 25 May 2023 11:46:09 -0300
Message-Id: <20230525144609.503744-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

For the socket option 'NETLINK_LIST_MEMBERSHIPS' the length is defined
as the number of u32 required to represent the whole bitset.
User space then usually queries the required size and issues a subsequent
getsockopt call with the correct parameters[1].

The current code has an unit mismatch between 'len' and 'pos', where
'len' is the number of u32 in the passed array while 'pos' is the
number of bytes iterated in the groups bitset.
For netlink groups greater than 32, which from a quick glance
is a rare occasion, the mismatch causes the misreport of groups e.g.
if a rtnl socket is a member of group 34, it's reported as not a member
(all 0s).

[1] https://github.com/systemd/systemd/blob/9c9b9b89151c3e29f3665e306733957ee3979853/src/libsystemd/sd-netlink/netlink-socket.c#L26

Fixes: b42be38b2778 ("netlink: add API to retrieve all group memberships")
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/netlink/af_netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index c87804112d0c..de21ddd5bf9a 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1765,10 +1765,11 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
 		break;
 	case NETLINK_LIST_MEMBERSHIPS: {
 		int pos, idx, shift, err = 0;
+		int blen = len * sizeof(u32);
 
 		netlink_lock_table();
 		for (pos = 0; pos * 8 < nlk->ngroups; pos += sizeof(u32)) {
-			if (len - pos < sizeof(u32))
+			if (blen - pos < sizeof(u32))
 				break;
 
 			idx = pos / sizeof(unsigned long);
-- 
2.39.2


