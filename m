Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 443CB4E9ECE
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 20:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245144AbiC1SSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 14:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245170AbiC1SSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 14:18:52 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B90A6350C
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 11:16:59 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id h83-20020a25d056000000b0063380d246ceso11496692ybg.3
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 11:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Me/7ozlD/ZpN60GWxY7vr2NpUMtv/HbFvHkjvcqVM5w=;
        b=e92QG3GhviC5BOH5Sj0NgXCkdeGdVwE9NmuRYiA0qa1DSRS1Tm+owdUQE4PEIMVmRw
         u0IBU+Na4SiLjWRtKRpP9dxnT7XAFyhlRmopj3TuADV7kbVz86A5kFVrBRdXlMq8j4CH
         ICuiwmCut5LTqrybH3I2Q1mQY+vtxfFeFWXyvVlcezB0+wggv4u8MeuXP73AtwKACrhp
         zK7iqGq5LUKJLhUn02vPW2a4LbTycH5EHtZO12MPZ1y0Rce1x6Vlj3Ja+1CPtpbi7iBL
         gSFFhgCvGcQQ30fqiuEzkJzq/0/E+9zaiFpFHSKpEegjnYTZ1rRdzbsEzSQ36eJSf2D2
         9gjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Me/7ozlD/ZpN60GWxY7vr2NpUMtv/HbFvHkjvcqVM5w=;
        b=vh96eYjP52FdcRpCjqD5CE/xwRCQ+GYIN8ouaGjDDIJqo+vQPxW84jmwxMtVO7iNY3
         jBtvlk63yGf5l/T02GiH8/rsTeZyIx33itxU6gotzi1jCGvudRe3B5pQh24a+mTxeKhD
         0q8KEXTY6lgomfxxH9LEnUUl7Hn0QjfnCaNUfgVAjio1OJSpwKW5uCUDq4ZjSJVl8ybx
         idd/reetiKe4Z7qCE51aUTMXv3vqKktaFtBiuogY7PwI5ZbNYRxSBe5ubhAbjRfvw/q1
         hwThv6h1Xfv0dCzIAt+sADJTQe3dDdWoCh8qeVX18oaQlks/37Ysj5x2ArdSaXASckvQ
         L18Q==
X-Gm-Message-State: AOAM532Wr+ng2e3Ymv/wto0p7bR0eV8KhI9CC6yDwRL+BGmyr+psv2Rb
        wMf9dSe/DJpR4zNsTjtEBb/15rf2fUSikKQpJOWh3eUVeuxwVn/i/wxiFgthKJX90cBoa05c0sX
        Q9rbOyyjDzbn+AYM2hV5Jb+0lI5F0N9H3+4WNI17aYruxJ8HlcInItw==
X-Google-Smtp-Source: ABdhPJyOv4M0ANoYtFUTlHXFDTqNWvdiiVDt5tHeJgSFrBy1e3QbU7A632UstS6XZNYZGVdc1ZKehZk=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:a900:e0f6:cf98:d8c8])
 (user=sdf job=sendgmr) by 2002:a05:6902:91e:b0:621:b123:de46 with SMTP id
 bu30-20020a056902091e00b00621b123de46mr24523858ybb.76.1648491418731; Mon, 28
 Mar 2022 11:16:58 -0700 (PDT)
Date:   Mon, 28 Mar 2022 11:16:42 -0700
In-Reply-To: <20220328181644.1748789-1-sdf@google.com>
Message-Id: <20220328181644.1748789-6-sdf@google.com>
Mime-Version: 1.0
References: <20220328181644.1748789-1-sdf@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH bpf-next 5/7] libbpf: add lsm_cgoup_sock type
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lsm_cgroup/ is the prefix for BPF_LSM_CGROUP.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/lib/bpf/libbpf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 809fe209cdcc..195c9f078726 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8666,6 +8666,7 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("freplace/",		EXT, 0, SEC_ATTACH_BTF, attach_trace),
 	SEC_DEF("lsm/",			LSM, BPF_LSM_MAC, SEC_ATTACH_BTF, attach_lsm),
 	SEC_DEF("lsm.s/",		LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
+	SEC_DEF("lsm_cgroup/",	LSM, BPF_LSM_CGROUP, SEC_ATTACH_BTF),
 	SEC_DEF("iter/",		TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
 	SEC_DEF("iter.s/",		TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_iter),
 	SEC_DEF("syscall",		SYSCALL, 0, SEC_SLEEPABLE),
@@ -9087,6 +9088,7 @@ void btf_get_kernel_prefix_kind(enum bpf_attach_type attach_type,
 		*kind = BTF_KIND_TYPEDEF;
 		break;
 	case BPF_LSM_MAC:
+	case BPF_LSM_CGROUP:
 		*prefix = BTF_LSM_PREFIX;
 		*kind = BTF_KIND_FUNC;
 		break;
-- 
2.35.1.1021.g381101b075-goog

