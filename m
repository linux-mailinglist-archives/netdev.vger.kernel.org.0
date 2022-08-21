Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8445059B61B
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 21:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiHUTSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 15:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiHUTSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 15:18:07 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E581CFCF;
        Sun, 21 Aug 2022 12:18:06 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 12so7661876pga.1;
        Sun, 21 Aug 2022 12:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=g4Jq3jLthELbJHukRc3Iv/BvScPnTFSVj9j7skCzo1c=;
        b=kDU2UU5SlgmthEgn6AtfuD9P27Zu6gu7yy3Cr/bPAD5vrFnOsb6gEBqVTevTlfFmVa
         FUbXWqT2/iWfzzIEzqSEvbkhwpkX1mvPiUblcOyvZ97u4FTJ8zBf95ylVpVMSUc4aStq
         WdIiD5JKfvIV+Nsbnk+0v+ZtqT9a1ef3ceHZ25LnxU29ixiWYa+qRJWAsJCoD7szCzdk
         Ht3ee/SzTjB+gUwiofg6iNOPClmm2V0IH2sAP8NbP7hqKC7mmOC964vkTk0YZUTkxY3Q
         gRgrj4dZ21G6NTA54wS9d1DwsV9a7wMXg1VFlUbz1JliGRAX9/QcYiszo6ExeA/0u4wv
         o7xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=g4Jq3jLthELbJHukRc3Iv/BvScPnTFSVj9j7skCzo1c=;
        b=V83bQe69LIBhF/UrniBYmaTk+QfBN57Bls35xkv2e3SGMT2akRIENlAiZVB1d1Zm6F
         FcT+FTIwwSyOt2fVR57q9isIdcHSRsSgTujY2IMLyMScgB7SG6K4sS7OLoJWmofw/yQl
         DmQInESL0pX2yeXbZOpv7nlU11JXAdL91tiRvikef/v2y8pwyhyq/PtWRc4xOSVWvzyO
         jNbtLtqnuaqyPx7UyNiW71Oi2GHkRQdgAgPN6u7oifPnl3aFT6NjJa2LxEdPYH1SJYOo
         rPyO79SEnXRQvhLcK656qZEvJpXCpyyB8aTY/MJIiVbBeiJn7GfnEXbxAdxlKjxwHZ4T
         8S4Q==
X-Gm-Message-State: ACgBeo3LcKCiEMyQGm4P4EfCXj9fjVWe59o7uhwog5mOgLXkcxxlEA6+
        eW5j4qmooTweXzvyjUKpk7s=
X-Google-Smtp-Source: AA6agR7g0vUdHNB436qax714lzXjZm0PbKlo0UfLHsf2DpJCNmP1zuz4nFo5+5LXimvrXhQ3j3lZHw==
X-Received: by 2002:a65:6d13:0:b0:41d:b593:e5ab with SMTP id bf19-20020a656d13000000b0041db593e5abmr14000051pgb.467.1661109485454;
        Sun, 21 Aug 2022 12:18:05 -0700 (PDT)
Received: from fedora.. ([103.159.189.146])
        by smtp.gmail.com with ESMTPSA id w23-20020a627b17000000b0052d16416effsm7051203pfc.80.2022.08.21.12.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Aug 2022 12:18:05 -0700 (PDT)
From:   Khalid Masum <khalid.masum.92@gmail.com>
To:     syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com
Cc:     David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        paskripkin@gmail.com, skhan@linuxfoundation.org,
        18801353760@163.com, Hawkins Jiawei <yin31149@gmail.com>,
        Khalid Masum <khalid.masum.92@gmail.com>
Subject: Re: [syzbot] WARNING: bad unlock balance in rxrpc_do_sendmsg
Date:   Mon, 22 Aug 2022 01:17:51 +0600
Message-Id: <20220821191751.222357-1-khalid.masum.92@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <000000000000ce327f05d537ebf7@google.com>
References: <000000000000ce327f05d537ebf7@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maybe we do not need to lock since no other timer_schedule needs 
it. 

Test if this fixes the issue.
---
#syz test https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 568035b01cfb
 net/rxrpc/sendmsg.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 1d38e279e2ef..640e2ab2cc35 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -51,10 +51,8 @@ static int rxrpc_wait_for_tx_window_intr(struct rxrpc_sock *rx,
 			return sock_intr_errno(*timeo);
 
 		trace_rxrpc_transmit(call, rxrpc_transmit_wait);
-		mutex_unlock(&call->user_mutex);
 		*timeo = schedule_timeout(*timeo);
-		if (mutex_lock_interruptible(&call->user_mutex) < 0)
-			return sock_intr_errno(*timeo);
+		return sock_intr_errno(*timeo);
 	}
 }
 
-- 
2.37.1

