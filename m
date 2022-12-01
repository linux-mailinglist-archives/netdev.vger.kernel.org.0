Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B97963F9F3
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 22:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiLAVl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 16:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiLAVlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 16:41:23 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37345B0DCA
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 13:41:20 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id w15so4940670wrl.9
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 13:41:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iQz5pBpkO8xYdbER52V8d8Wv1i3SDO8OvdHRuU1DAh4=;
        b=f79us2JwmwXIFRK9MEOMvleB1WwzxrgappbJLjb+AGEfgJ0P38UXpTsZJ1Ci9xr69Z
         f0B6i41LnKXX7XYsnYhRtiQ44guT/F3am5mw6r03TbJvFsCSoAlUojzTwjpl6IcDd2JT
         j/KZw6tMeTV2l0rjLSSjYD6wvQszkzXp1T2JIQgVVFYwxNsQ2f8tOyaANpptddaQ9iM6
         s4H5CFXpjJ4FvD0ko9xzTECLKxURmn0MmNuTwj8jFEjOkru2PzLpTIbeSvC5bmqxnu5h
         pc/qZtXUHEx0q2K46BlbvKbZQsjy/N7Llw5/VQv+OOqI1FUZXym1YniRnzs1oIRMC+TA
         bekw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iQz5pBpkO8xYdbER52V8d8Wv1i3SDO8OvdHRuU1DAh4=;
        b=1hJjjPmiomM/Sz2+cGXedFdmu7zexydRKF8UScXtFwBMAjAaTLYrtIEZdKus8MUTRx
         FM/0Tqo9OObrTill+KBopRjsSVkJfl2HEtJSebhHOPiVAdsLhRHOdms7Zphr1IFJi/P9
         n01luIQktaCbOHrqUDv21Ta8nGVfUBAHlKoVt0yt+dogdyGDIptXCNvHpm2PBRYV4gEf
         lLFfFdYh0w1dw+8KGU6YWmzBQHmQuO5uP6Dioy54N/OuwhH8KlImyA085QbOzvx639gh
         hDWdaKra+Mh2A7y5mgT7WO9t613w9DxcNbi/8D+TxBkXh2vFimLHmcRDq7nXji8hNXmf
         7xIw==
X-Gm-Message-State: ANoB5pmfYM2rOqDnAOrQs9zzaKipv94O/njS9+5cukHMF27G47kOM3IH
        0ydZwDPav2o5IO2ja19EKHgj3qVC6Qo=
X-Google-Smtp-Source: AA0mqf7vjVWZvwCbKLxqi1qBrpYZ5oAuCC5KkK39EZwxz2r5YWoIppOVItJo/mHm3+UsG++bSW0NwA==
X-Received: by 2002:a5d:56c9:0:b0:236:5d8b:dd9c with SMTP id m9-20020a5d56c9000000b002365d8bdd9cmr32850647wrw.283.1669930878840;
        Thu, 01 Dec 2022 13:41:18 -0800 (PST)
Received: from localhost.localdomain ([2a04:241e:502:a080:d550:2713:91f3:c113])
        by smtp.gmail.com with ESMTPSA id i2-20020adff302000000b002421a8f4fa6sm5294662wro.92.2022.12.01.13.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 13:41:18 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH iproute2 2/2] testsuite: Add test for ip --json neigh get
Date:   Thu,  1 Dec 2022 23:41:06 +0200
Message-Id: <9b167a5bf910676cdae24edeb47aa77c2f312476.1669930736.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <63b6585719b0307d81191bbcf5228b94f81c112f.1669930736.git.cdleonard@gmail.com>
References: <63b6585719b0307d81191bbcf5228b94f81c112f.1669930736.git.cdleonard@gmail.com>
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

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 testsuite/tests/ip/neigh/basic.t | 13 +++++++++++++
 1 file changed, 13 insertions(+)
 create mode 100755 testsuite/tests/ip/neigh/basic.t

diff --git a/testsuite/tests/ip/neigh/basic.t b/testsuite/tests/ip/neigh/basic.t
new file mode 100755
index 000000000000..9c13c8ef4b25
--- /dev/null
+++ b/testsuite/tests/ip/neigh/basic.t
@@ -0,0 +1,13 @@
+#!/bin/sh
+
+. lib/generic.sh
+
+ts_log "[Testing add/get neigh]"
+
+NEW_DEV="$(rand_dev)"
+ts_ip "$0" "Add $NEW_DEV dummy interface" link add dev $NEW_DEV type dummy
+ts_ip "$0" "Add $NEW_DEV neighbor 192.0.2.2 " neigh add 192.0.2.2 lladdr 02:00:00:00:00:01 dev $NEW_DEV
+ts_ip "$0" "List neighbors " neigh list
+test_on '02:00:00:00:00:01'
+ts_ip "$0" "Get $NEW_DEV neighbor 192.0.2.2 " --json neigh get 192.0.2.2 dev $NEW_DEV
+test_on '"lladdr":"02:00:00:00:00:01"'
-- 
2.34.1

