Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732296E2BA6
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 23:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjDNVVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 17:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjDNVVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 17:21:20 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C93B194;
        Fri, 14 Apr 2023 14:21:19 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id w14so5374570qtv.13;
        Fri, 14 Apr 2023 14:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681507278; x=1684099278;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XZoDLLpG5fmpyITzBZtd+EuYaUQs2fIMhuAZi8K1sT4=;
        b=TheenAsgWbpjh03HpiYy8PS4e5WolHNttlsGjaTGuPuZCu5WtTkqzG55juNf8ILKyR
         BEGicIbWMTIJXHFKpm7GKgPmaC1n7vAEDHwQS6DtapHN5lk9RG6orGT+u8s3duEj6XLy
         Vk9hB8R0a9BThru2nbS8Uconvfq3OgRLaxsNKHjEUQ5LqOzUf3n/klKBUHIXV5AnkoNm
         l/T5rzVycKWK/Jsb18ICVNI8bSF4PSumM7i6g2SB1zwPn5kZFOH4cjHj4BG9gRkxCeU8
         Q5qdYiffIn7LgP4HlozSykICGIO5rwGL/eQ6xbHmWWLTUMJqROEyJehpbfghKeC+dNeh
         Mn2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681507278; x=1684099278;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XZoDLLpG5fmpyITzBZtd+EuYaUQs2fIMhuAZi8K1sT4=;
        b=DZzTfc9INNrtuLVdemJ4PsRX2mVYl+hM/izcklIF1FwbuTAR6RfydSJnwM5ZeQSwx2
         aE2KS91HodZn5CIrzmeYmqEihSL0dllbciWCoFsPSV+i25rshlZTFntqwwQ2LXgjqpRh
         go8NWOoVQTOWOaLKyMjIg3sv57eZDQvsiT9Cpu7ZxhUMRUhuPueTsx0m2+uwQOdSwV18
         qkPScmZTTra2g6Yx8wa9hS7xOEwVfWDAnRMEtugbQLejxKPPjBSvMV+eYOUmT4+9/L+H
         DSgZdjrQR5bh9B6mxjReQW5E+zthxdaigZAZ0NyP3NLFNLnTd5nv43uH82xOTqzjuBv3
         BP/Q==
X-Gm-Message-State: AAQBX9f9mm6xshJStyRNu9cLG6bMooz0bTc1i93Cyv8gLVx82889mrF+
        CdzUwICwnwHBghIEiZWr92F3ZPQKRyJC4A==
X-Google-Smtp-Source: AKy350Z5R+N+wtpF6NNwobIfvvkYyAoqny+lZdE36eIuCCBu5l2kUd/pBmmZtQNnAFtq7IbhqqqbIA==
X-Received: by 2002:a05:622a:1a0c:b0:3d6:dca:f0df with SMTP id f12-20020a05622a1a0c00b003d60dcaf0dfmr10567204qtb.66.1681507278197;
        Fri, 14 Apr 2023 14:21:18 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id b5-20020ac85bc5000000b003e693d92781sm593373qtb.70.2023.04.14.14.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 14:21:17 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net-next 0/2] sctp: add some missing peer_capables in sctp info dump
Date:   Fri, 14 Apr 2023 17:21:14 -0400
Message-Id: <cover.1681507192.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 1st patch removes the unused and obsolete hostname_address from
sctp_association peer and also the bit from sctp_info peer_capables,
and then reuses its bit for reconf_capable and use the higher
available bit for intl_capable in the 2nd patch.

Xin Long (2):
  sctp: delete the obsolete code for the host name address param
  sctp: add intl_capable and reconf_capable in ss peer_capable

 include/net/sctp/structs.h |  1 -
 net/sctp/sm_make_chunk.c   | 10 +---------
 net/sctp/socket.c          |  5 +++--
 3 files changed, 4 insertions(+), 12 deletions(-)

-- 
2.39.1

