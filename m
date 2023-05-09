Return-Path: <netdev+bounces-1269-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E727D6FD271
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 00:16:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CCA328114D
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 22:16:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7B76174E7;
	Tue,  9 May 2023 22:16:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951D51990B
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 22:16:18 +0000 (UTC)
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130FE3A87
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 15:16:17 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-306f2b42a86so4126196f8f.3
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 15:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1683670575; x=1686262575;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hu65y9LQ0JYUL/b/I+3CE2Q5EL9XofrXHd9owDz27hI=;
        b=hBZrbLhMlpy/7oSVs0lTprrVy94U7upvFqODG929/y5dhCt9nV1hGalb0dMN0Bw0ER
         5DNOkwvSwT/9VKbM3+BNzR/TQk0etBwApXWwMlfJQB2sTqYOvpUFz9QSmWOgUudK9pvQ
         iEeIg4PuDTD83+ivdSQdwUf70PgfCfdoaFvcIcuEmyymE7/0yFkC8z3DT+/NWKxI0FU3
         x71z6oOvpTQQCc67HK51hOoKfaAjUcQDv9UXIbZ2QxmUmMjW54OydoPA2Koacp6atRiD
         B/avJ/CyKq22ldsN/3ZjA1hTQ+NkZYbXZSQttzNV6zHKe6pWl+YJ+cr9xwLEdACkltMN
         MOug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683670575; x=1686262575;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hu65y9LQ0JYUL/b/I+3CE2Q5EL9XofrXHd9owDz27hI=;
        b=LBscMYLjWHq/JsjuzZLMx3ZuqMkNHA5E6SZja2lnrYZM6sSzN5wzKnLB6Lh7R4KQDE
         RUQR4kfp/acmoTa9dF+zB1WDnt5bmo4QunnDKOfujq5MKWSpRQkce8kPf0h8p43u+u/g
         wYBcZrpGV9S81cehqebKCNWm33HeKbxCDblown/A5T44Q3Ra1C8hzN/Swbtdn+gr1+Pz
         4Nu02pMROSieLB/uPikX1DB3RXC9QM3hSZSzVGaFuKAfAQ/1PAvUUp2ZUrdobmLqdkh1
         pYGcGBVykn/Z4uKphZfshKXF1h6ms4lTlrD9gsIDQVHpyE2GCePZxsvin27JI3FHiYwQ
         00Wg==
X-Gm-Message-State: AC+VfDwb8ospdY6KS9fB1kOaFQdbRzh9ie0JV8Pe6jampEb01jCaT3D1
	DKR5QrkVNKfCV+BDTIRmRqrfug==
X-Google-Smtp-Source: ACHHUZ79BTqG7tWfhK7o9CNI8lUq9aMIXawO83vQQ1z7O/72MkWFXZxOplN99ejMbyp9axkegONteQ==
X-Received: by 2002:adf:f54c:0:b0:307:a24f:c15e with SMTP id j12-20020adff54c000000b00307a24fc15emr3059912wrp.39.1683670575497;
        Tue, 09 May 2023 15:16:15 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id t25-20020a7bc3d9000000b003f42d3111b8sm2052888wmj.30.2023.05.09.15.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 15:16:14 -0700 (PDT)
From: Dmitry Safonov <dima@arista.com>
To: linux-kernel@vger.kernel.org,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: Dmitry Safonov <dima@arista.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Leonard Crestez <cdleonard@gmail.com>,
	Salam Noureddine <noureddine@arista.com>,
	netdev@vger.kernel.org
Subject: [PATCH 0/5] net/tcp-md5: Verify segments on TIME_WAIT sockets
Date: Tue,  9 May 2023 23:16:03 +0100
Message-Id: <20230509221608.2569333-1-dima@arista.com>
X-Mailer: git-send-email 2.40.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

Started as a refactoring of tcp_v{4,6}_send_reset(), in order to prepare
it for TCP-AO signing for RST segments. As you can see the previous
TCP-AO-v5 [1] version of those functions, they get too big and nasty.
Patches 1 and 2 seem more-or-less straight-forward to me.

But then another thing that I wanted to fix for TCP-AO-version6 was
accepting of unsigned or incorrectly signed segments on twsk, which is
against RFC5925 (7.2) that requires checking the signature. So, I decided
to give it a shot and fix twsk for TCP-MD5 as well.
That seems more questionable, that's why I'm sending patch 3 as RFC.

And the last part, patches 4 and 5 are paranoid checks made to minimize
cases when inbound segment's signature and RST/ACK reply aren't consistent.
This is direct result of RFC2385 that lacks key rotation mechanism.
Probably, patches 4 and 5 are a bit too much, sending them for review
anyway in case such paranoia makes sense.

Thanks,
          Dmitry

Cc: David Ahern <dsahern@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Leonard Crestez <cdleonard@gmail.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Salam Noureddine <noureddine@arista.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

[1]: https://lore.kernel.org/all/20230403213420.1576559-9-dima@arista.com/T/#u

Dmitry Safonov (5):
  net/tcp: Separate TCP-MD5 signing from tcp_v{4,6}_send_reset()
  net/tcp: Use tcp_v6_md5_hash_skb() instead of .calc_md5_hash()
  [RFC] net/tcp-md5: Verify inbound segments on twsk
  [RFC] net/tcp-md5: Don't send RST if key (dis)appeared
  [RFC] net/tcp-md5: Don't send ACK if key (dis)appears

 include/net/tcp.h   |  18 +++-
 net/ipv4/tcp.c      |   9 +-
 net/ipv4/tcp_ipv4.c | 196 +++++++++++++++++++++++++-------------------
 net/ipv6/tcp_ipv6.c | 130 +++++++++++++++++------------
 4 files changed, 207 insertions(+), 146 deletions(-)


base-commit: ba0ad6ed89fd5dada3b7b65ef2b08e95d449d4ab
-- 
2.40.0


