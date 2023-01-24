Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC92678E2B
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 03:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbjAXCUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 21:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbjAXCUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 21:20:21 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FA530EB9
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:20:14 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id h24so8102369qta.12
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MRncoLC16sCZcT7mVpILb/C22ea0oeFd+8wfM8ixo3g=;
        b=PBz1ApS5WbMAshDUCXXzXxKSupYOXyQe8ZkxXJRSncmv8vsts+tGI6lubWEkNBShSp
         IyVDttbppXaJMzQ2OhUw/vhKopzhIfEowGAZj7kIrERnnR2+Vv1hU6wdIuCqSNG4euRS
         5Ncc0aMzAarYtFUKpKhQNl5TBB0RiFqyKXXweugp8QZQP1+OK5wVQjpKuBfgQ/37+CkE
         lZhMgssYk92zBF4BSLyhHof7jtB6+iot584oP9LKIaw+aGomUrb2f7netKJY0XqiMp5a
         XAQiISl+0YHjNv5byJEvn13qCRkH0BPxTcFty0sb/XaWo8THbOWz3IOrga0uBu+II0Jd
         3/YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MRncoLC16sCZcT7mVpILb/C22ea0oeFd+8wfM8ixo3g=;
        b=aiCUuNJd3hED4jTxOTA/5I+xFHG74dLRat4x5quWoe4wrmqKmHPWOwn0aD77fPQ2h5
         +vs8+muXd552eOr94h1LAHSqD5fxKibk3ERF21S3SngYEQCgOxX9AGz1rXnGSOBfk6Th
         p7367/4ZCYMam65g7KG5KkN09jYCxFIlfaVH5Qmw/LsmwykI5WPHKhDlivpiyCbKLa2b
         D7Qa+Vw2XKFn9/CnSHqTC/LYPDqM3Ts6NYcLIFmKZKpk/VQ7iXllKHtEBHuiJ9fg0OCN
         Nqiy3RjAyddVM5ofmTpcQIeggYHKzelEqlTqD//q6uN7MRW+VMPqMpdeBicpuZsOGWOP
         CPNA==
X-Gm-Message-State: AFqh2kr6pOOfwE75+Kj2N6lesUBpfrBk7I8oFeEL47o/OTqenOWATv6j
        JElJHRYJRngFvObU6X/PmiV7MFLdmpN2yg==
X-Google-Smtp-Source: AMrXdXtFF0o32oNoRp1xD9OWN9ym+F8TGir0x6M8v8ds5Fl5y5uIONmeJ8JYAQ0ryOflORfTb7xFOQ==
X-Received: by 2002:ac8:6f09:0:b0:3b6:2d34:45ef with SMTP id bs9-20020ac86f09000000b003b62d3445efmr44604548qtb.7.1674526813877;
        Mon, 23 Jan 2023 18:20:13 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f1-20020ac840c1000000b003a981f7315bsm410558qtm.44.2023.01.23.18.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:20:13 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: [PATCHv2 net-next 06/10] cipso_ipv4: use iph_set_totlen in skbuff_setattr
Date:   Mon, 23 Jan 2023 21:20:00 -0500
Message-Id: <bc564c0cbf16a944d59906a0b8d69cde2a285731.1674526718.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1674526718.git.lucien.xin@gmail.com>
References: <cover.1674526718.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It may process IPv4 TCP GSO packets in cipso_v4_skbuff_setattr(), so
the iph->tot_len update should use iph_set_totlen().

Note that for these non GSO packets, the new iph tot_len with extra
iph option len added may become greater than 65535, the old process
will cast it and set iph->tot_len to it, which is a bug. In theory,
iph options shouldn't be added for these big packets in here, a fix
may be needed here in the future. For now this patch is only to set
iph->tot_len to 0 when it happens.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/cipso_ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 6cd3b6c559f0..79ae7204e8ed 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -2222,7 +2222,7 @@ int cipso_v4_skbuff_setattr(struct sk_buff *skb,
 		memset((char *)(iph + 1) + buf_len, 0, opt_len - buf_len);
 	if (len_delta != 0) {
 		iph->ihl = 5 + (opt_len >> 2);
-		iph->tot_len = htons(skb->len);
+		iph_set_totlen(iph, skb->len);
 	}
 	ip_send_check(iph);
 
-- 
2.31.1

