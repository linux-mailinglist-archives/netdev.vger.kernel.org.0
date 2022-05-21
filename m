Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6087B52F9E4
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 09:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239714AbiEUH5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 03:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbiEUH5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 03:57:51 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943BF15E60E;
        Sat, 21 May 2022 00:57:48 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id fw21-20020a17090b129500b001df9f62edd6so7746943pjb.0;
        Sat, 21 May 2022 00:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=66wlav12zvJy4zvz1Wy50I4EsO3Dd5TnttLlC+3jPcw=;
        b=UhZI+zhNM+HAgkiOZ0YEmMhihvbVyVukWBoVTR4goCGAxhgQkiBpOvH8uh2J2q5G9S
         4Qo7JqibsUFwBCMVVbOXs4KA135AcBFz2RQSVjlxBklDllKtA7twgPoq6EOs07YvzK33
         7LgFJLr1mcqlkGfdTMp+Ifv4BPj6YsqV1f+UVXpgrLtsacDm1B8BJWhSKj55D6+Az6jt
         mMuL3dYTcQ/cKTtl/yju7U8AHZZR62e9V9pNhisd7JzJnXlHJQb67jy2A3yD6hO6WQYk
         fK8tGftQAPPwAiPC/hy/XGX8Ss5Ia66zCy8tq8F+oBR5ZlZ2Owdakv6YQMqUCaF35zyk
         kM9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=66wlav12zvJy4zvz1Wy50I4EsO3Dd5TnttLlC+3jPcw=;
        b=WWbzzRNOB0GBhMgrbhGMi4HnpVftWhZp24M/Mj3KdpJkbSWahrZWuRVAulr2qDotS1
         zcOs3WJPhNw9t7osBVdi+vwYP5+57APnfDoSkYy4P6zlcuYhuUpDepLkpzpzMacH0qtH
         1fp45C09nWrAWOmvavpkknm7Qn/QcQDz+mebXxU3XEB6phFXuiO4IVKMFu0au+ZQrvo8
         mEw/k84oZ/l81QLsiy88Co4WpB5acTM3H8TOalDYeTO0uD/wC2r96usAPIN/yUR1Y8a/
         sDut+tsS5UWxJi0QR6WgiVjkZpn1d5mXKJBziNNhb2jEmLHQzfcnSn8BQHgor8STgOox
         MUcg==
X-Gm-Message-State: AOAM532r4T3W6sLXpEFlNta6ll2T4tZZ/yILLA3/dvpPyUen9hCz9eBK
        8kxnHkGw3irPAxh6HyyDcgUk5LnLYiraxw==
X-Google-Smtp-Source: ABdhPJzhE15xzgFrvORKlaOiyN73bRE3ckz/NblCjn+CyI4p2G3KTzQ4x39iTahiaLRnKO+7A9mbpQ==
X-Received: by 2002:a17:902:c944:b0:161:7b60:e707 with SMTP id i4-20020a170902c94400b001617b60e707mr12829752pla.70.1653119867846;
        Sat, 21 May 2022 00:57:47 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:200:f932:45b1:b75e:5ba7])
        by smtp.gmail.com with ESMTPSA id kx14-20020a17090b228e00b001dedb8bbe66sm2986082pjb.33.2022.05.21.00.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 May 2022 00:57:47 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH bpf-next] bpf: print a little more info about maps via cat /sys/fs/bpf/pinned_name
Date:   Sat, 21 May 2022 00:57:36 -0700
Message-Id: <20220521075736.1225397-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Maciej Żenczykowski <maze@google.com>

While this information can be fetched via bpftool,
the cli tool itself isn't always available on more limited systems.

From the information printed particularly the 'id' is useful since
when combined with /proc/pid/fd/X and /proc/pid/fdinfo/X it allows
tracking down which bpf maps a process has open (which can be
useful for tracking down fd leaks).

Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 kernel/bpf/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 4f841e16779e..784266e258fe 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -257,6 +257,9 @@ static int map_seq_show(struct seq_file *m, void *v)
 	if (unlikely(v == SEQ_START_TOKEN)) {
 		seq_puts(m, "# WARNING!! The output is for debug purpose only\n");
 		seq_puts(m, "# WARNING!! The output format will change\n");
+		seq_printf(m, "# type: %d, key_size: %d, value_size: %d, max_entries: %d, id: %d\n",
+			   map->map_type, map->key_size, map->value_size, map->max_entries,
+			   map->id);
 	} else {
 		map->ops->map_seq_show_elem(map, key, m);
 	}
-- 
2.36.1.124.g0e6072fb45-goog

