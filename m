Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0155259E5
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 05:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376662AbiEMDF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 23:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376659AbiEMDFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 23:05:22 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDC8296BCD;
        Thu, 12 May 2022 20:05:10 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id l11-20020a17090a49cb00b001d923a9ca99so6587414pjm.1;
        Thu, 12 May 2022 20:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BHwxj5/3zfJqT2Wrvjpo8DsHfoccm9nsiUOrbL558ys=;
        b=c0U/VBDd0f57x+RlO6UJhtq14moDx1LVcq/Xt9i5HyZxtKjX3JjQZYEmbFdwKUSo9q
         hhbGiXUAY7gzbWnOHD17WM0vDC3Bplaq4xwTLO4rwcy3E60mweRlYpjuBfKb91k5EivS
         guAG697EhWtP5JlRekHvAbQk8D7cDtzmYVh1EAi0HrSZe6LakOwvpqjO6rFU/KRhOC37
         CouYvy+lJ28/OjpEzED4httUbrb2q7ZbCBbAutdnkER4Ny6B45AkFmPBCYf1BJtuYZoU
         ry0LMWmon8dtrWgd4zKoAztMHTaneMEDSkGadn+/WgtHirYiB9I84Swa4a89Bwe1ZVe4
         p7FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BHwxj5/3zfJqT2Wrvjpo8DsHfoccm9nsiUOrbL558ys=;
        b=InMgo1xddcAwtIemPbuzkPsO+LM0mMwoGlrGICuOVWM3xSRqKiMkQvWZBLLC6YJRKw
         4V21BWR5vhZcSHerDg4Jm03OPvYl5AFZhagNBoKYw0PuQtvA1n6/0pxrItJ4gI97ByYq
         UKUA5LXKySHs5gAi4RAEd91kXz6C2Eq16owvAv6ps1zUthMwzs78D9/vO462OmrbRYTE
         RtGNsICwgznEzNkzQHQkEzUtJH04Szmap4XK8ixMi10RYL4sZ63HfayCpiXkulerMATz
         uvLdFfaIoYMHEIqdYHWv5274uh1cxb163meU7+B4L58hUXobTinuzuuovqMzomyQzrB0
         bEBQ==
X-Gm-Message-State: AOAM5335VOhVVU+OIf06XX6mEWJOQPWKX9wRzjWujMinQ5SJQJ0T2u1f
        k5D8mX3FYVRytpZZt2o/oso=
X-Google-Smtp-Source: ABdhPJwYAcMlmA0kpYY5SJtvzHRDsIyHJ7UtTXrxKOAqW1Cy9GoJNNiOfM8KsEypDaHq1ZKvCCdX2g==
X-Received: by 2002:a17:902:f652:b0:156:701b:9a2a with SMTP id m18-20020a170902f65200b00156701b9a2amr2497221plg.14.1652411110315;
        Thu, 12 May 2022 20:05:10 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.26])
        by smtp.gmail.com with ESMTPSA id b7-20020a170903228700b0015e8d4eb1f8sm638693plh.66.2022.05.12.20.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 20:05:09 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        imagedong@tencent.com, kafai@fb.com, talalahmad@google.com,
        keescook@chromium.org, asml.silence@gmail.com, willemb@google.com,
        vasily.averin@linux.dev, ilias.apalodimas@linaro.org,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
Subject: [PATCH net-next v3 4/4] net: tcp: reset 'drop_reason' to NOT_SPCIFIED in tcp_v{4,6}_rcv()
Date:   Fri, 13 May 2022 11:03:39 +0800
Message-Id: <20220513030339.336580-5-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513030339.336580-1-imagedong@tencent.com>
References: <20220513030339.336580-1-imagedong@tencent.com>
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

The 'drop_reason' that passed to kfree_skb_reason() in tcp_v4_rcv()
and tcp_v6_rcv() can be SKB_NOT_DROPPED_YET(0), as it is used as the
return value of tcp_inbound_md5_hash().

And it can panic the kernel with NULL pointer in
net_dm_packet_report_size() if the reason is 0, as drop_reasons[0]
is NULL.

Fixes: 1330b6ef3313 ("skb: make drop reason booleanable")
Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v3:
- remove new lines between tags
v2:
- consider tcp_v6_rcv()
---
 net/ipv4/tcp_ipv4.c | 1 +
 net/ipv6/tcp_ipv6.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 918816ec5dd4..24eb42497a71 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2101,6 +2101,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	}
 
 discard_it:
+	SKB_DR_OR(drop_reason, NOT_SPECIFIED);
 	/* Discard frame. */
 	kfree_skb_reason(skb, drop_reason);
 	return 0;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 60bdec257ba7..636ed23d9af0 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1509,6 +1509,7 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 discard:
 	if (opt_skb)
 		__kfree_skb(opt_skb);
+	SKB_DR_OR(reason, NOT_SPECIFIED);
 	kfree_skb_reason(skb, reason);
 	return 0;
 csum_err:
-- 
2.36.1

