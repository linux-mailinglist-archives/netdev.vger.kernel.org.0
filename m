Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B326E7E07
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbjDSPTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbjDSPTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:19:08 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DB483F7;
        Wed, 19 Apr 2023 08:18:35 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id ff18so10916407qtb.13;
        Wed, 19 Apr 2023 08:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681917400; x=1684509400;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3NzT/hpuNnryCcqzSUjen8isl1rZWNC+fIQh1MymFgo=;
        b=lvc3TyOZQkLu7RUX9PDBPh181gatDjN+TE9ZFR2eJYwmqG4mURsq1KTJ1Tj0QCq7K8
         MepYov5UzrWK1YruY9KU49NrHYcJ0VCQ3vaDti/F5Gu6DGxPkI+6D4zkhjqadfH7j4mj
         59WM1rPoLdbznUDsuw3nqsnELM2mrCbVvo/Tz6ZCN1l/FFjZXqMiYKp+8qTZI/daqVVG
         9EO9h2UfmevoxxqmY3RkRxZ4D4HodLAtTGslkBqEIrZn8zGV1o5x9LgRKt9vCU47scIU
         TGjuPv/OWzM7qzBYclJxNpCDUgloKGKyw5C6BOuTVm6PLu3mkTN/aicPOi4nKwXkQK5A
         aFOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681917400; x=1684509400;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3NzT/hpuNnryCcqzSUjen8isl1rZWNC+fIQh1MymFgo=;
        b=EQoroHysNGFY/zA6818ScAqGTt2c3pllIscLKQBAJb9okxTIQlSJmjRgF0tFCQrPmc
         WZxJ7BYSJmZwv/mFTghYMPvtWqCFeVIiVIJUj0X6jiLZZ+06KwzOIKn9OJk3lGTR69aV
         Yrb9DzqnSI49xnMJtSm2EA48sCilZKE4Lt8N5loS+ufZ5OiB0by32axqqsXkjYoTwFzy
         pydHtnPQr1+Wcdk6b9NyRwa4K+euo81QloDGFn5VCmlhWV7oekPJj4JEoF3w28XY9LlA
         VAIznhV7dBFcj8s77pXZkY1FxwZ+BQcesVxgsho/DDKusvRQfHqllZ8bCZcblB/W2NWZ
         wuoQ==
X-Gm-Message-State: AAQBX9cIcIaw77hbwZyLExWcvkyQRBgIEl/3SVmrv+U3wy84jujlg1G4
        qtoN5+zoT1QhlcE3cPjFdCit7irfeaqSWQ==
X-Google-Smtp-Source: AKy350ZlfQixJ5eO1K9C6XWgyAnyKZduyo7kcHujkvd1ildzBYwQFjALxNRE9WoMi1DTYWqJQKU+Yw==
X-Received: by 2002:ac8:5acb:0:b0:3ef:414e:fb6a with SMTP id d11-20020ac85acb000000b003ef414efb6amr5372187qtd.55.1681917400309;
        Wed, 19 Apr 2023 08:16:40 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id v11-20020a05620a0f0b00b007469b5bc2c4sm4753336qkl.13.2023.04.19.08.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 08:16:40 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net-next 6/6] sctp: delete the nested flexible array payload
Date:   Wed, 19 Apr 2023 11:16:33 -0400
Message-Id: <811ba34fc96b2ec46105af451be97cf87eb410f3.1681917361.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1681917361.git.lucien.xin@gmail.com>
References: <cover.1681917361.git.lucien.xin@gmail.com>
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

This patch deletes the flexible-array payload[] from the structure
sctp_datahdr to avoid some sparse warnings:

  # make C=2 CF="-Wflexible-array-nested" M=./net/sctp/
  net/sctp/socket.c: note: in included file (through include/net/sctp/structs.h, include/net/sctp/sctp.h):
  ./include/linux/sctp.h:230:29: warning: nested flexible array

This member is not even used anywhere.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/sctp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index d182e8c41985..836a7e200f39 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -222,7 +222,7 @@ struct sctp_datahdr {
 	__be16 stream;
 	__be16 ssn;
 	__u32 ppid;
-	__u8  payload[];
+	/* __u8  payload[]; */
 };
 
 struct sctp_data_chunk {
-- 
2.39.1

