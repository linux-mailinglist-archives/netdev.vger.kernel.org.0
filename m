Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23AC57A0BC
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237890AbiGSOJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238559AbiGSOIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:08:10 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B01754644;
        Tue, 19 Jul 2022 06:24:50 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id ez10so27108542ejc.13;
        Tue, 19 Jul 2022 06:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4cFR1T4lbutWstXHmbM2dbPlJKpl1mp7S3Dg2sFTtXY=;
        b=bbvbU9/VIBfx8nTpUA08RgMOwLrYN9HNlmwCvNPx3ADsuPEraxeXetEdoNY6GFL6EY
         s6vdpPwfgPxk9mla4Adjxc+ggy4+svDCCpRk4s8QRSMCOOYAzv8hvxYCCAPb31jTCZZA
         0JQXOWx7lnB7l0GvXBwc15wNzlgtZNZvihvXK1gZcDRS6dOxWwLeC4bVlRr3ALuHDVCY
         m2LJB9rq+bl6cLvE9xi4WvjFnEPFsjOESzKACF7w+phWjF4XY2BRhQjzhmyBlC3+b6b+
         /ekAkGhtxF4euSC4usgkZigfoLb7ktf/51TKeE4xICpooZliJ0e0HrbMSP8puWz2SDKx
         hjpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4cFR1T4lbutWstXHmbM2dbPlJKpl1mp7S3Dg2sFTtXY=;
        b=qurnwsfa081EX/LaGZmcC5jwQGVxpDYGnIRtw5Y1AqHCVezisVBtXpj12TwLwY9A+F
         Fi3VWhVym8M4TlO1wQLE2yvuyKFq5TO2HpuGSA580njMvWtjXGoAd4HTvOKeazdQdXVq
         CWxxyBUERadAlpItLr+93xoOJ/pn3SIOEYr5to5Rzn8BkxHm/mMyQKn5pYfPUDBUV7M7
         22NAz3HxhoPfIwo5VeGCu2TjY1/AXFEUpnJwWcaWBdzm7eP8aS/R8gSQ1zTprCaaiF6o
         TL9JmGfO0HHUKZDfmFzOPaYfx1RuWlS/gxuMM+Mfqrs0EqJTMTd5raJ4DaA4Kd34zsRF
         DM4Q==
X-Gm-Message-State: AJIora/aaaMJNQUqYh9VOW1LySYlcOrAgTXA8Fck5MO/xEdIUzdgJNFt
        RRYgObiLjicMpUAWAgyZXUJss7+994eepQ==
X-Google-Smtp-Source: AGRyM1vG4GsrYNk4GaXnjMHks9prfDbdxx0xwxUPmUidxm41ZHQsI7i0HioiZdrrGaxqlF5aXzKOEw==
X-Received: by 2002:a17:907:a0c6:b0:72e:ea7d:6a98 with SMTP id hw6-20020a170907a0c600b0072eea7d6a98mr21068836ejc.140.1658237088740;
        Tue, 19 Jul 2022 06:24:48 -0700 (PDT)
Received: from localhost (icdhcp-1-189.epfl.ch. [128.178.116.189])
        by smtp.gmail.com with ESMTPSA id gt2-20020a170906f20200b0072b342ad997sm6619764ejb.199.2022.07.19.06.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:24:48 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v6 13/13] selftests/bpf: Fix test_verifier failed test in unprivileged mode
Date:   Tue, 19 Jul 2022 15:24:30 +0200
Message-Id: <20220719132430.19993-14-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220719132430.19993-1-memxor@gmail.com>
References: <20220719132430.19993-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1029; i=memxor@gmail.com; h=from:subject; bh=avUxAzVXxTSlvvIczCgkt5Bck8b2xRF1My3q7b4wHho=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi1rBmQgxaln2kgyqBnUL/mSLBYQq2oZzyQ+9iPSWL 0uAGw62JAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtawZgAKCRBM4MiGSL8RynoeEA CoG6hQ7m9ddUrYrkaVr449xHtXW2oF1Uip9faZAIF8vjZUaonnLZ8zdr6A9SnpK2YbOQbLxg3p1Uo/ EBIGiIYNB8faI1xi6DAmLkGsr59JcKzMULymFpXH3zhG63W/MaRjJYJcfilx6Tx0Qj8EFEvUNzmkaP S93WupfXvvf8VF/OXZCD182SN5tpnN7z1DVKIVJjppfv3AcFdqvE9FfJrvMwDUUY7CbSerHvHbJxrD 7YDjtNE5bYqTCmeMfli+R7mn9yG56ZAcgLJ0giqXbYh44NBGakzwdW5VE0AhYsi0AU19estFcQH2g6 8eqHqTm/QFhEiAewcS8JDy/RRRYgUGQjKOqGpJTMDVINtuEM4EJXS1qLS4nzN1iZa7KROus8R04YIT IE6yWiXQsgdpal+JhJxIFFdGkyQjMHQ6CgP6TdssFyJKoBjbAJLvGa/CmWiVB3SUOgnTJbv0wZlHkT cRMEOX6ADpm3XWLTR7U8zmtGS3UTblqq83uSc4A7DfQGRhwddvLgQeIs/Su8/SOwaV/qeklgt9Ey8C fRzFTPkTeK8k5PHtxuK3D3WVCI/PSUN+ogwrD52lkNNLGIvJ2LGRYTrTRW+e6zvh1knooxKpJtOcdi DPL0NzvhNaySzZBkBF1z8DNPJLdnVagZPntus7elq2Q8FkqDAT9A4GDOSjnw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
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

Loading the BTF won't be permitted without privileges, hence only test
for privileged mode by setting the prog type. This makes the
test_verifier show 0 failures when unprivileged BPF is enabled.

Fixes: 4118e9e9def ("selftest/bpf: Test for use-after-free bug fix in inline_bpf_loop")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/verifier/bpf_loop_inline.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/verifier/bpf_loop_inline.c b/tools/testing/selftests/bpf/verifier/bpf_loop_inline.c
index 2d0023659d88..a535d41dc20d 100644
--- a/tools/testing/selftests/bpf/verifier/bpf_loop_inline.c
+++ b/tools/testing/selftests/bpf/verifier/bpf_loop_inline.c
@@ -251,6 +251,7 @@
 	.expected_insns = { PSEUDO_CALL_INSN() },
 	.unexpected_insns = { HELPER_CALL_INSN() },
 	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
 	.func_info = { { 0, MAIN_TYPE }, { 16, CALLBACK_TYPE } },
 	.func_info_cnt = 2,
 	BTF_TYPES
-- 
2.34.1

