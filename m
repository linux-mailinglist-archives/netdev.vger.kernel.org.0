Return-Path: <netdev+bounces-5676-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F17D7126BB
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 14:34:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCD231C21092
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6190F1C26;
	Fri, 26 May 2023 12:34:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551ED742D4
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 12:34:00 +0000 (UTC)
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9CBE61
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:33:27 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id af79cd13be357-75b00e5f8e4so47726485a.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685104358; x=1687696358;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kIFl7xJEC24t46tpIRLMfHm5aQaJwJk+Td3zYyok57I=;
        b=AkBwZuz+aIXs2BGmfuFd01f+TfCQMdPsMqhH4eWrDj1Jne76r6cZuwqCl5/lGru267
         gojV1fDGgVTFUuWolxrg9YW/32a0hmQKTHQXAxWkCkzhWODBcJkphXQMckirnTFCpukF
         VgDFWGABme4Sq07kxlLgF0l/pkLj1G1Br7E3KpKaVaWYeATrBvmOpAYE7FGC0nFZqUIC
         mm+k5di73ivcBDB9UiatQdWpH7YV4Y2LwbTgKrKg8WPe50Xl/Nuw2wNzD4v7P7KU5hrF
         CbLVxo0feJ5zifcC8o31nMFsR7FmuJHwTkALpPWfYh7EgFKpbB8G3tN0uCiU0/WF+f2n
         eDsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685104358; x=1687696358;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kIFl7xJEC24t46tpIRLMfHm5aQaJwJk+Td3zYyok57I=;
        b=McNabyWoAkvYdxxSY6ZYGqEk2tKVdDLyH3lhn9enNyPRXJTGtjxRUsib9iFN4Y90px
         2C0pUdGpQor9IUobkkc6L+9DTWyqI25nvuMjdtHb1qKXic88nfXTvw096XifeZji2+p3
         f5Q1dsVdnHsFftkC+F6kBFHvBs0WrbYlONFeaCtF0bruKjBG8EEoq9NtINO9ijqyMLdM
         6jnsYqShHejxwD7ABLGzPmMdW2leqyIteqXuuQ5ECRR3+9rDF2z71s+noioCemGEfx+e
         uJcOFD+zoYBt6gV6/bAmR0gwipQwm70J2adtaTyasr2xqImmd4arstSnwdxdQc1K0Jo1
         YzRA==
X-Gm-Message-State: AC+VfDy6oFRYKoVZaye/MTc5yUKUDe4TwlkzBfEkxu3raiCLZJ52ZZ9/
	CnbebGphI5r42d3JveKllGh8lvPNho/4W0Xj
X-Google-Smtp-Source: ACHHUZ4hKs9DAkUe9mjlh9qg0cgqxJZqqKZDUTb6+zT7QE+J2OJRZbhtcjUZ+yR+PamYN/9o6ARQOA==
X-Received: by 2002:a05:620a:6287:b0:75b:23a0:d9db with SMTP id ov7-20020a05620a628700b0075b23a0d9dbmr1457206qkn.49.1685104358312;
        Fri, 26 May 2023 05:32:38 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id d13-20020a05620a166d00b007595614c17bsm1121026qko.57.2023.05.26.05.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 05:32:37 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Cc: donald.hunter@redhat.com,
	Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v1 0/4] netlink: specs: add ynl spec for ovs_flow
Date: Fri, 26 May 2023 13:32:19 +0100
Message-Id: <20230526123223.35755-1-donald.hunter@gmail.com>
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

Add a ynl specification for ovs_flow. The spec is sufficient to dump ovs
flows but some attrs have been left as binary blobs because ynl doesn't
support C arrays in struct definitions yet.

Patches 1-3 add features for genetlink-legacy specs
Patch 4 is the ovs_flow netlink spec

Donald Hunter (4):
  doc: ynl: Add doc attr to struct members in genetlink-legacy spec
  tools: ynl: Initialise fixed headers to 0 in genetlink-legacy
  tools: ynl: Support enums in struct members in genetlink-legacy
  netlink: specs: add ynl spec for ovs_flow

 Documentation/netlink/genetlink-legacy.yaml |   6 +
 Documentation/netlink/specs/ovs_flow.yaml   | 822 ++++++++++++++++++++
 tools/net/ynl/lib/nlspec.py                 |   2 +
 tools/net/ynl/lib/ynl.py                    |   8 +-
 4 files changed, 836 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/netlink/specs/ovs_flow.yaml

-- 
2.40.0


