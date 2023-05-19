Return-Path: <netdev+bounces-3912-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDA9F70985C
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:32:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA243281B9F
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BACAADDBB;
	Fri, 19 May 2023 13:32:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B065C7C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 13:32:11 +0000 (UTC)
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4548710C0
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 06:31:44 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-966400ee79aso621452066b.0
        for <netdev@vger.kernel.org>; Fri, 19 May 2023 06:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684503102; x=1687095102;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iYLjI0uYdREMP4rNfk3sm5VoRCLSWTA2WtCKAtNi7Wk=;
        b=mZtXP07aPqQW4yNScmsz5AN0KMzBRcrqNfPVwh48g2+a6/q3Zq6FzYMAJSJudm2yKP
         WF+afmB5F8vYPXaFVdK7r2cv9FcTzKUl2dTomtkLZKjjdnwveyh+XDqwxZxk/yVO//tR
         adJQ255spiVq61zUEenjx+RFjFD3Bhim3CP8yf31jMonsKAPild7vXBnylqdU2/jnWhG
         TBoG9/vCwxJtq36GMalV9+JhmrV4oOctO1p5CXFuEbSpUlcG7UQg66mjOWAKoYAFPwlI
         xfDLT0mAj2rSwzpslVVvqX8KWJdmvxK40GsOy4rYYvmSRPLUyKrj9m2ln/orNYfx3NLq
         53Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684503102; x=1687095102;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iYLjI0uYdREMP4rNfk3sm5VoRCLSWTA2WtCKAtNi7Wk=;
        b=dy4za76gy2IjD8z0QMUn0aKN/xgu7brNdrAcuu6vUFli4SOlDActTmykhj+2ShR8Is
         pinF1AkMrCqoCT1mbeo7pdCqVdXLzfP4kX1D9nxPDzDDVReW8e1UzAMwan9gqtDTG/qw
         UqHVJVe8hmxDpFkmaWOwrgr1sEid2tkQohjE7Aft6PWa0yOEey2J2kp8ZAne6OAUgfAM
         TIiM+6l5PJLz5A7D4KCsgyCNoiPsklGyM7nNF7DBMKNc9Wk8O+1Kd3n9MUr2ZduaZ8rp
         W3tlMdbvMUrTd/Nm5VzE5DkEk2h6E5BfkoOPkwIHsX8G+HGCfa11Bp8DzLbxRk1zqsHo
         PqDA==
X-Gm-Message-State: AC+VfDyCvK6hw2OmPiPn21aH3rF1JdMh7FxxlXy52QBv5pBaobj3pb4v
	dCkHEHk2iZi6iSVx7AjM3UVi57oEZHI=
X-Google-Smtp-Source: ACHHUZ4yjNI/I40oaiXu1U5OUy7CEU5fFuUnH7hZdVKY7rdL3XnpXJ+gidaqbk9K7v7/VwrxAlhDeA==
X-Received: by 2002:a17:906:fd8e:b0:96a:d916:cb31 with SMTP id xa14-20020a170906fd8e00b0096ad916cb31mr1678593ejb.29.1684503101869;
        Fri, 19 May 2023 06:31:41 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:a04d])
        by smtp.gmail.com with ESMTPSA id d26-20020a170906175a00b0094f410225c7sm2300273eje.169.2023.05.19.06.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 06:31:41 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: netdev@vger.kernel.org,
	edumazet@google.com,
	davem@davemloft.net,
	dsahern@kernel.org,
	pabeni@redhat.com,
	kuba@kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next] net/tcp: refactor tcp_inet6_sk()
Date: Fri, 19 May 2023 14:30:36 +0100
Message-Id: <16be6307909b25852744a67b2caf570efbb83c7f.1684502478.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Don't keep hand coded offset caluclations and replace it with
container_of(). It should be type safer and a bit less confusing.

It also makes it with a macro instead of inline function to preserve
constness, which was previously casted out like in case of
tcp_v6_send_synack().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/tcp_ipv6.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 7132eb213a7a..d657713d1c71 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -93,12 +93,8 @@ static struct tcp_md5sig_key *tcp_v6_md5_do_lookup(const struct sock *sk,
  * This avoids a dereference and allow compiler optimizations.
  * It is a specialized version of inet6_sk_generic().
  */
-static struct ipv6_pinfo *tcp_inet6_sk(const struct sock *sk)
-{
-	unsigned int offset = sizeof(struct tcp6_sock) - sizeof(struct ipv6_pinfo);
-
-	return (struct ipv6_pinfo *)(((u8 *)sk) + offset);
-}
+#define tcp_inet6_sk(sk) (&container_of_const(tcp_sk(sk), \
+					      struct tcp6_sock, tcp)->inet6)
 
 static void inet6_sk_rx_dst_set(struct sock *sk, const struct sk_buff *skb)
 {
@@ -533,7 +529,7 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
 			      struct sk_buff *syn_skb)
 {
 	struct inet_request_sock *ireq = inet_rsk(req);
-	struct ipv6_pinfo *np = tcp_inet6_sk(sk);
+	const struct ipv6_pinfo *np = tcp_inet6_sk(sk);
 	struct ipv6_txoptions *opt;
 	struct flowi6 *fl6 = &fl->u.ip6;
 	struct sk_buff *skb;
-- 
2.40.0


