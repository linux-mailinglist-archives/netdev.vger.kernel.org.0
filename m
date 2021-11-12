Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DE044EB8D
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 17:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235373AbhKLQr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 11:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbhKLQr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 11:47:26 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353D0C061767
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 08:44:35 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id d27-20020a25addb000000b005c2355d9052so15290981ybe.3
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 08:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=twivPmHGmtG8iF2Iqs4VmwFt4m0EiD82k/Wb4RTz6Kc=;
        b=OyXHubVFMlweTuLfR3lTaZWi9qarwXv7g9No6exsAdlMdf4WR6hKnPWRGAfL3W6705
         R2VAB05Eq+ZLlGCKQX+egZMf8paMfj8KeIJcZY7xxCW2AYOUWi2GaFCdGWD64BC6CAaD
         hONobq8B4xju5OZ7g/81d6TrdkeYwmWETgh373uAoAVO9qkEOuQFKzXiJaJC58nAuy0/
         g4K9ka0AtZ7h5VzMRaStCzfm57+sy+1+DIE2BhJ4IOexlRg4WliOrUEJAbogzklMsjQf
         RybvvnSK+NYOYM/vhvDdxdeuW4awgkVY9XO5miuLlOeLuxgSfJcBMG6jdKn6tF5qh3cP
         WRIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=twivPmHGmtG8iF2Iqs4VmwFt4m0EiD82k/Wb4RTz6Kc=;
        b=2BQ1LMSmPgRmLqKh9HC9whi96srW1XlypnsGQsP8Wu4eySJ90cmFLUgA/UB+JhH9Sz
         4dvgIofETJqcLsLOqgSL46cL4fsAHwxBAjTxvlzqC+bFViW23PexsShS99eSYo3xpEHi
         SzdemcdjZD4xQ5G/7PnjdStoTMMgpmHSiY0ts4hSFCR7GA1LKSALR1WDLGbIYEzcEawl
         eI5g6Vdlqt8AWnYHe4JzYzyHThjUy82gERTbVBxMhCVScuBbXvl8yBnSCwhKDab93vry
         WxH2g0gl2GOeMn2ZepPIlgTcH/IxaEE12uNC/kmVY/kaQzmuW8bfYf30sPh5QhYauVhs
         zJhA==
X-Gm-Message-State: AOAM530LR9XMMu7QNg+AP1UuJAd4bMKbmX7iouCGW++Vy7xaEsKjsCR7
        1pMK1Wk8EyNxjsQNMKw/Y6HMxHz3sVFhsVO+SUh0cXe46D37PfYefkmc4rFOFmm3ipw1LraszoX
        BdmHFwKPQZ1DzQMttiJY3w5E8d1VC6AOAe2et4tfZuqmsmVkld15dZQ==
X-Google-Smtp-Source: ABdhPJzSvSx0imV1lHXiXXkyhTthLeS1VldJBYkhV1Ktp5Agm1ClZh9ThPLr7JcTgABL0preLTPi4LM=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:a840:6f02:587a:91e6])
 (user=sdf job=sendgmr) by 2002:a25:ae07:: with SMTP id a7mr18348527ybj.364.1636735474266;
 Fri, 12 Nov 2021 08:44:34 -0800 (PST)
Date:   Fri, 12 Nov 2021 08:44:32 -0800
Message-Id: <20211112164432.3138956-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH bpf-next] bpftool: add current libbpf_strict mode to version output
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ bpftool --legacy version
bpftool v5.15.0
features: libbfd, skeletons
+ bpftool version
bpftool v5.15.0
features: libbfd, libbpf_strict, skeletons
+ bpftool --json --legacy version
{"version":"5.15.0","features":{"libbfd":true,"libbpf_strict":false,"skeletons":true}}
+ bpftool --json version
{"version":"5.15.0","features":{"libbfd":true,"libbpf_strict":true,"skeletons":true}}

Suggested-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/bpf/bpftool/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 473791e87f7d..edbb146287ee 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -93,6 +93,7 @@ static int do_version(int argc, char **argv)
 		jsonw_name(json_wtr, "features");
 		jsonw_start_object(json_wtr);	/* features */
 		jsonw_bool_field(json_wtr, "libbfd", has_libbfd);
+		jsonw_bool_field(json_wtr, "libbpf_strict", !legacy_libbpf);
 		jsonw_bool_field(json_wtr, "skeletons", has_skeletons);
 		jsonw_end_object(json_wtr);	/* features */
 
@@ -106,6 +107,10 @@ static int do_version(int argc, char **argv)
 			printf(" libbfd");
 			nb_features++;
 		}
+		if (!legacy_libbpf) {
+			printf("%s libbpf_strict", nb_features++ ? "," : "");
+			nb_features++;
+		}
 		if (has_skeletons)
 			printf("%s skeletons", nb_features++ ? "," : "");
 		printf("\n");
-- 
2.34.0.rc1.387.gb447b232ab-goog

