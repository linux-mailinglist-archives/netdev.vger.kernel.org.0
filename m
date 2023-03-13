Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605976B760C
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 12:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjCMLdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 07:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbjCMLdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 07:33:40 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAC930E0
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 04:33:09 -0700 (PDT)
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 60BE73F126
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 11:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1678707155;
        bh=WIlBGmglyBuO5BTm3a9yo13ImKUTaHbAmYajOjqNXTU=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=YFyJNP0k8kE4iQLY3jBeDeIKKjYkkFg9Fh0e00Lq/Hv1VuADjZrxGm7NubzU73mHm
         drNaS5tZkfGnnb9noxWMBk6hGvl1wXReZhLyOYveZgKvet9bIQR0oq4v5cRLbRYEen
         HbDo0g41m+3dHnKEsPCZmP+qTcmIwxxaGMKwjIa8b7TSqG0p/pOCg4uU393CK53KKP
         NwnHdHNKk6ABjwr3dqw63U8HEum3zjquWwA2smShv5Fbkti1xtkS63nhz3XgC1Sb2v
         zGukGgjvxnwicoaYRmqSPBdszTO7hrHBmJ5rjbUt0q8UTu0kPR6KSfkUf8gY4BnrwK
         j4QTZ1XwSXGiA==
Received: by mail-ed1-f70.google.com with SMTP id w7-20020a056402268700b004bbcdf3751bso16383143edd.1
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 04:32:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678707155;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WIlBGmglyBuO5BTm3a9yo13ImKUTaHbAmYajOjqNXTU=;
        b=bqxCz7nHZfdSz8LQw6v6iN+IcvsZ++4CJ8yB6aGo54Hcl3q8jPP01cR7fGF1UQHRid
         6zBX6PK+f07IHZMcS/lTa3Ok9OYP4B51iPwfA37RL7/a7jc6cjLLrGoIEuhjH3enrZw7
         xDH1i7PYWztGVsrzWNkAbei2AW38uXGRRltqq+OfDd0Z9CUzspo4HmX8cXFkBPk9aHhT
         7pX/L1UuU2h3PZUQ5bG8auEDzS8le9nTQko8oLPtZTfMz3nRHYEM+zx26dBeacjzpTbp
         mztsBhQQAaLTVwBS7z0EFohh0ZeJDgyYb93+u2CGBClMm54J83C/CkYQLx2kKjkSJWqv
         f83Q==
X-Gm-Message-State: AO0yUKXvj6HCUQAdhBUNBMVTdQtsfYkrPlJmMDecW8hu1bJc8gbTdwMp
        W/Z482i0542lThG+3vlLZ7Mka0qrk5KQmcDheeNQ0+8/8KQTJSXLrfQXTkasiAj+2qDwWBZEagD
        KZMkXY7reKooEmlma+E3tj2JhIOyqXR1yqQ==
X-Received: by 2002:a17:907:80e:b0:8b0:f58d:2da9 with SMTP id wv14-20020a170907080e00b008b0f58d2da9mr43616155ejb.64.1678707155166;
        Mon, 13 Mar 2023 04:32:35 -0700 (PDT)
X-Google-Smtp-Source: AK7set9QXQ820wthA8mkfj06/eCxY8qoFLG6I5ahUEUqt7xmAJQ/WsddvBW3t4NjAyTyI8jC9qOEsQ==
X-Received: by 2002:a17:907:80e:b0:8b0:f58d:2da9 with SMTP id wv14-20020a170907080e00b008b0f58d2da9mr43616132ejb.64.1678707154858;
        Mon, 13 Mar 2023 04:32:34 -0700 (PDT)
Received: from amikhalitsyn.. ([2a02:8109:bd40:1414:c91d:59c1:64e:937b])
        by smtp.gmail.com with ESMTPSA id r8-20020a50d688000000b004fbf6b35a56sm1351501edi.76.2023.03.13.04.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 04:32:34 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     davem@davemloft.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH net-next v2] scm: fix MSG_CTRUNC setting condition for SO_PASSSEC
Date:   Mon, 13 Mar 2023 12:32:11 +0100
Message-Id: <20230313113211.178010-1-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, kernel would set MSG_CTRUNC flag if msg_control buffer
wasn't provided and SO_PASSCRED was set or if there was pending SCM_RIGHTS.

For some reason we have no corresponding check for SO_PASSSEC.

In the recvmsg(2) doc we have:
       MSG_CTRUNC
              indicates that some control data was discarded due to lack
              of space in the buffer for ancillary data.

So, we need to set MSG_CTRUNC flag for all types of SCM.

This change can break applications those don't check MSG_CTRUNC flag.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>

v2:
- commit message was rewritten according to Eric's suggestion
---
 include/net/scm.h | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/net/scm.h b/include/net/scm.h
index 1ce365f4c256..585adc1346bd 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -105,16 +105,27 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
 		}
 	}
 }
+
+static inline bool scm_has_secdata(struct socket *sock)
+{
+	return test_bit(SOCK_PASSSEC, &sock->flags);
+}
 #else
 static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct scm_cookie *scm)
 { }
+
+static inline bool scm_has_secdata(struct socket *sock)
+{
+	return false;
+}
 #endif /* CONFIG_SECURITY_NETWORK */
 
 static __inline__ void scm_recv(struct socket *sock, struct msghdr *msg,
 				struct scm_cookie *scm, int flags)
 {
 	if (!msg->msg_control) {
-		if (test_bit(SOCK_PASSCRED, &sock->flags) || scm->fp)
+		if (test_bit(SOCK_PASSCRED, &sock->flags) || scm->fp ||
+		    scm_has_secdata(sock))
 			msg->msg_flags |= MSG_CTRUNC;
 		scm_destroy(scm);
 		return;
-- 
2.34.1

