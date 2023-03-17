Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 677E26BF249
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjCQUTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjCQUTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:19:42 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC733B20E;
        Fri, 17 Mar 2023 13:19:37 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id h8so6490038plf.10;
        Fri, 17 Mar 2023 13:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679084376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MXegsicfeEQTJRNtz+ivUG8LHA5872wbv9Jz/Z3VRk4=;
        b=QaBqPDPgXJ7sCxCDL13tYT/aZRro2hmKYgUpuMZTSOMlmfGZrK/jmpCJTjpAUIrZdX
         JgLQ3p8Suu2e0WWCYa6xIFI3HB1OunRBy6pXb41C/Qe6xkO9FSJOYZuNssoVCbmEJ/3Q
         pR60r4ft/p0R+xYlcu3uhRIyiw7FyLnizmjKGwQQJv4jSxN0eLgmT1kJoCc4VcD2f1C7
         VFhMMHxis0fbOdNMU0iWcYARly7cMEBVNxK1pRi1lmeZXfBbPZLUGw8i6aLotBwGXvzo
         rw0l+ah6ZxXJaCKlTApwT2oW31lkeEOG6Z/Z1IgDHq3TlD4GlgMxqh/k5ZGA36rdZUGM
         KTxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679084376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MXegsicfeEQTJRNtz+ivUG8LHA5872wbv9Jz/Z3VRk4=;
        b=tLA+VbKYHym1m+XDvoOakTWAAoQcq5zETvGfTPo7b0px8wkqM0Qm5cUJgcL5XVzTFy
         WD8ebMrkUv4gCvpFCI66G0b91oLGr8oQNDtT2VXiunh0I+GFlEyPE5PghF5bIjMLwm2S
         11gb3CvwLrOUEmnAg9aI1vuip19zzZ8L/UZpVrBt8E3Hy9H77WNtW7QQV5s6NOmqgGh+
         Bz9o0XPV6Yj9DUoELZI7Jz9gmlddOvdBNptoY+UywnYMcqtDOE2IWWyzPnxrfhifeJU2
         qqNHuWNannPsIFrcIq3dmGiW5KHQ67Y+qs1fmReA6kxsJuTd1sj6So450oTMBYjCv0Mx
         tJHQ==
X-Gm-Message-State: AO0yUKVtsIdhOtROIfrmPH7zkeczH3M3EKTcb+S6JaP+96yb3caBtvJX
        iA7ol3KKVznERFby09ehfG0=
X-Google-Smtp-Source: AK7set/hdeU7pRtByU9ErrjsWFkNnP9G6CGmJifh9C4m5JQa9a9NXvgyR14f9zHdOUs4Wn3TlUSZSw==
X-Received: by 2002:a17:902:ce81:b0:1a0:7602:589e with SMTP id f1-20020a170902ce8100b001a07602589emr10830122plg.40.1679084376627;
        Fri, 17 Mar 2023 13:19:36 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:2bcf])
        by smtp.gmail.com with ESMTPSA id i20-20020a63cd14000000b0050a0227a4bcsm1851520pgg.57.2023.03.17.13.19.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 17 Mar 2023 13:19:36 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 bpf-next 3/4] libbpf: Introduce bpf_ksym_exists() macro.
Date:   Fri, 17 Mar 2023 13:19:19 -0700
Message-Id: <20230317201920.62030-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230317201920.62030-1-alexei.starovoitov@gmail.com>
References: <20230317201920.62030-1-alexei.starovoitov@gmail.com>
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

From: Alexei Starovoitov <ast@kernel.org>

Introduce bpf_ksym_exists() macro that can be used by BPF programs
to detect at load time whether particular ksym (either variable or kfunc)
is present in the kernel.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/lib/bpf/bpf_helpers.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index 7d12d3e620cc..b49823117dae 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -177,6 +177,9 @@ enum libbpf_tristate {
 #define __kptr_untrusted __attribute__((btf_type_tag("kptr_untrusted")))
 #define __kptr __attribute__((btf_type_tag("kptr")))
 
+#define bpf_ksym_exists(sym) \
+	({ _Static_assert(!__builtin_constant_p(!!sym), #sym " should be marked as __weak"); !!sym; })
+
 #ifndef ___bpf_concat
 #define ___bpf_concat(a, b) a ## b
 #endif
-- 
2.34.1

