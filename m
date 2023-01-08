Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD54E661648
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 16:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbjAHPqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 10:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233053AbjAHPqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 10:46:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33CA10042
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 07:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673192739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=mBUPsllV7S0PFvOHT8nwAOJJCxWYHkxwaycDYQO5qZs=;
        b=Q7MuMZZ8tSxJho9112S/WoTnivYVJERm7HjeUfZdDTw8haXX6LHNsD+uUn0Pdscyh3Bu2G
        l3VeDW2f0Uyt7QTTTJ5ylph+SmHtCuXWIGvTg8pVZkyWVYbr7smMuonfn/+zSyb/KLb4yb
        nOlaZrohcp7QGOqiv8CLGQ3IYzB8Xs8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-424-hXHUWsxDPs6yCvE-iSKJ6g-1; Sun, 08 Jan 2023 10:45:37 -0500
X-MC-Unique: hXHUWsxDPs6yCvE-iSKJ6g-1
Received: by mail-qk1-f197.google.com with SMTP id y6-20020a05620a44c600b00704d482d3a0so4877826qkp.21
        for <netdev@vger.kernel.org>; Sun, 08 Jan 2023 07:45:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mBUPsllV7S0PFvOHT8nwAOJJCxWYHkxwaycDYQO5qZs=;
        b=u6A4ZyZvLHhQVWyjHdOUseyME26x/qtLNU11v9/rFtwTSJeM09q2qCtuouyDyhSvCe
         youyL3XkkS8tlMRaz2p3ii9jyNDWSVZhzj7CC+yt3P/TOnDlcgTTYn9ZsFUynpoJfTxr
         al41BaP5AZmjK2yHAYgvWCcdgFJ4WyMkNQw7mwTcrPznvOBhcO7Ddp+RLLwnwkxjzJT9
         93C3GStYkpevNJNNkcN32xWz9/S0PZzWtGaz6S6NHjAk/PNmshFiPKwWXP1MFyuWrBm4
         OhccPveuVbhfF/UpDu2vh87MJWs3ypmt1EZq5MiXzoJMJDNqGd591ujzOBvD1iVKRK+i
         ZmRQ==
X-Gm-Message-State: AFqh2kqiyPRbn9owzheDCLAV3GZXIBzfE4ywhXYn1VC7sqFfepKl+9kl
        zPqm4PcoxVDC2GXZE1Lz7Z8kq1iS9bgGyoJNXcmODOcMNF1/N73C6fcVA0ktdBloI1H3UC8yMQy
        DaAB75jOvfRcWhx9j
X-Received: by 2002:a05:6214:c6c:b0:4c6:fcf7:9aea with SMTP id t12-20020a0562140c6c00b004c6fcf79aeamr113843015qvj.49.1673192737392;
        Sun, 08 Jan 2023 07:45:37 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuPuNPqKiPcbcSTUSOcOvyUfZX//mmtaUg5y3+sN2P0QdNm6wotBczBPXa+bMRlEDm04TvPNw==
X-Received: by 2002:a05:6214:c6c:b0:4c6:fcf7:9aea with SMTP id t12-20020a0562140c6c00b004c6fcf79aeamr113842838qvj.49.1673192735159;
        Sun, 08 Jan 2023 07:45:35 -0800 (PST)
Received: from debian (2a01cb058918ce0098fed9113971adae.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:98fe:d911:3971:adae])
        by smtp.gmail.com with ESMTPSA id t7-20020a05620a034700b007054a238bf2sm3842200qkm.126.2023.01.08.07.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 07:45:34 -0800 (PST)
Date:   Sun, 8 Jan 2023 16:45:31 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        Matthias May <matthias.may@westermo.com>,
        linux-kselftest@vger.kernel.org,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Subject: [PATCH net 0/3] selftests/net: Isolate l2_tos_ttl_inherit.sh in its
 own netns.
Message-ID: <cover.1673191942.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

l2_tos_ttl_inherit.sh uses a veth pair to run its tests, but only one
of the veth interfaces runs in a dedicated netns. The other one remains
in the initial namespace where the existing network configuration can
interfere with the setup used for the tests.

Isolate both veth devices in their own netns and ensure everything gets
cleaned up when the script exits.

Link: https://lore.kernel.org/netdev/924f1062-ab59-9b88-3b43-c44e73a30387@alu.unizg.hr/

Guillaume Nault (3):
  selftests/net: l2_tos_ttl_inherit.sh: Set IPv6 addresses with "nodad".
  selftests/net: l2_tos_ttl_inherit.sh: Run tests in their own netns.
  selftests/net: l2_tos_ttl_inherit.sh: Ensure environment cleanup on
    failure.

 .../selftests/net/l2_tos_ttl_inherit.sh       | 202 +++++++++++-------
 1 file changed, 129 insertions(+), 73 deletions(-)

-- 
2.30.2

