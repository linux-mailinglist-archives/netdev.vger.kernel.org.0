Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E754F8DAF
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbiDHDkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 23:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiDHDka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 23:40:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2218636E0A
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 20:38:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B256C61DBA
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 03:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE15FC385A0;
        Fri,  8 Apr 2022 03:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649389106;
        bh=lfxXs6EIeOWJJCkPCdD2STuUjCLqvAsoquHYS9E62ZQ=;
        h=From:To:Cc:Subject:Date:From;
        b=kMO7Q8Ilql4kux+vv11EY0odKadhs7hiu13b3C6IAfRTkiL+TuWDFeDhwi6XOFiUG
         MD66Tt6GyryBCaTfK7KMbWPZ/8EmIQ386fxZ5I77chUj62RrKWR2/OPi6YGc8hKwBq
         5JwyJWEj5NJVrk/CsLiT3Q8HGjtHgviiyToTveoVlM/X4E4hvYYwEc2rpuFZ08H7VJ
         QGZ/eDg8MZuO9+SZ4vhcGJP9ZSIc4tj9mjvXRqnLg8EEiDtY049GssJ9swixaOvR0K
         6HISYKLKGKoHCEivbz51NdvN7IHZynwlOTil91Jlnk/oxrA0EgRe+lzkaJo7AJUpJl
         zWgIIlL+ACX8g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/10] tls: rx: random refactoring part 1
Date:   Thu,  7 Apr 2022 20:38:13 -0700
Message-Id: <20220408033823.965896-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TLS Rx refactoring. Part 1 of 3. A couple of features to follow.

Jakub Kicinski (10):
  tls: rx: jump to a more appropriate label
  tls: rx: drop pointless else after goto
  tls: rx: don't store the record type in socket context
  tls: rx: don't store the decryption status in socket context
  tls: rx: init decrypted status in tls_read_size()
  tls: rx: use a define for tag length
  tls: rx: replace 'back' with 'offset'
  tls: rx: don't issue wake ups when data is decrypted
  tls: rx: refactor decrypt_skb_update()
  tls: hw: rx: use return value of tls_device_decrypted() to carry
    status

 include/net/strparser.h |   4 ++
 include/net/tls.h       |  12 ++--
 net/tls/tls_device.c    |   6 +-
 net/tls/tls_sw.c        | 129 +++++++++++++++++++---------------------
 4 files changed, 70 insertions(+), 81 deletions(-)

-- 
2.34.1

