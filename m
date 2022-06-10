Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88A7545ACB
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 05:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346225AbiFJDpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 23:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241354AbiFJDpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 23:45:22 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A129387E3B;
        Thu,  9 Jun 2022 20:45:21 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id u12-20020a17090a1d4c00b001df78c7c209so1108252pju.1;
        Thu, 09 Jun 2022 20:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/uH0Tg1zVcDlHNhyIIFBcnnUKdSwUfTJgB1DfUre/zI=;
        b=m778EZofcp8jmVOVkAKDDP61gGR2HG8R0OXzo+MpDab171Mk1W3ub7xZw4Einp8RWe
         patQ/hICpLAv7EnecP8O6G76Dp7U8HglbfIHajf8ihzzhSb2HJ5YIqyv1BsSxO7EdVgQ
         R73K0wJbMVTQsOMKQEga30/qoSPzhwO6agjrNg6+vMYhMpu+Ib6vjmkE4eWNRtYUHsv+
         ErXYDKR0nS1H6enG5kZR1VwXJfp0bDZRqP+KG51PuzLWOyOwgBPpIgJ+UDUqzJPPrbYa
         1JR1sdY1hs2Qjdp7bQ4qrxey5RprDuLkyszvWKGcRQd60ckcKMJidKny6tEocO0oLDe6
         wkGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/uH0Tg1zVcDlHNhyIIFBcnnUKdSwUfTJgB1DfUre/zI=;
        b=vJwJOQd1QEDp8ukHaw7B5UObYP3SWlOvqQPDx5NJIG0u8O6pw66J/TZQ69tMDGtJna
         zo5TRLBHQvVMHR/DtUuVUNTfoaMODaL3QW73cG4dvQ4r8qmTJtu19h/QCUk4hPkybNTu
         nsJZsw9hiVCIzizSwBLh1jcuEb+vJnXwwZYCj2p65HWFqSd8X8dugQZ7Lt1zl8btjjhe
         nRErNuhw0MIlUgRJfS6IabbCUNxaRa45wtuS+cH2raARdunpaN5EosGck4c4YGEotyYI
         UCv3kxXR4vJRzzyRpaps+tHd5qKNUoQw3k35PjKEc4kRYj4YpL/+GX/91oaOkzXITeUi
         +xww==
X-Gm-Message-State: AOAM530Cts8ydRVCiE1PZ8OE6y/xgWWh/PiWBBPuW9iKNPRRPcRSKzSH
        62GKiy+TsGR8IlS2e0f3EqY=
X-Google-Smtp-Source: ABdhPJys1yEG2SHw3qwtRRUfFmmb0j8fT9xupsIS8suAMdra/9NzHar2iteHWtU2X9V9SJmCDJ0Paw==
X-Received: by 2002:a17:902:d409:b0:167:7425:caa8 with SMTP id b9-20020a170902d40900b001677425caa8mr25625352ple.72.1654832720895;
        Thu, 09 Jun 2022 20:45:20 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.27])
        by smtp.gmail.com with ESMTPSA id u30-20020a63b55e000000b003fc136f9a7dsm5908368pgo.38.2022.06.09.20.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 20:45:20 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v3 9/9] net: tcp: use LINUX_MIB_TCPABORTONLINGER in tcp_rcv_state_process()
Date:   Fri, 10 Jun 2022 11:42:04 +0800
Message-Id: <20220610034204.67901-10-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220610034204.67901-1-imagedong@tencent.com>
References: <20220610034204.67901-1-imagedong@tencent.com>
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

From: Menglong Dong <imagedong@tencent.com>

The statistics for 'tp->linger2 < 0' in tcp_rcv_state_process() seems
more accurate to be LINUX_MIB_TCPABORTONLINGER.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 9b9247b34a6c..07b06c12fe87 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6592,7 +6592,7 @@ enum skb_drop_reason tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 
 		if (tp->linger2 < 0) {
 			tcp_done(sk);
-			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPABORTONDATA);
+			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPABORTONLINGER);
 			return SKB_DROP_REASON_TCP_LINGER;
 		}
 		if (TCP_SKB_CB(skb)->end_seq != TCP_SKB_CB(skb)->seq &&
-- 
2.36.1

