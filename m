Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3E1ED19FA
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 22:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732347AbfJIUnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:43:00 -0400
Received: from mail-lj1-f170.google.com ([209.85.208.170]:35196 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729535AbfJIUlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 16:41:44 -0400
Received: by mail-lj1-f170.google.com with SMTP id m7so3907317lji.2
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 13:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=y12OqUDXt0uUd8S/w/N9B4j5fJB9b6dEGe48WxLpJQ0=;
        b=b82CPx+fPly56w9MPycjqjk9NJFrcqTUC+lMTY5z15BMRw4pELbH/XPZ+RJefWuxPY
         Ve+lIxc6pQd+2yDHo9zcMjT2RLJUqoXNChE9oUJ1xBcEkkjBJsESNa9GWmIK6Li9Rbkw
         2gsZITjElYlpNfxDj0t7SIHmbzIKhfrXgQQ0eutD4pIHkl55qf+nSBf/bZYmQNvZSkgO
         bLliGWmkU+bpjvxPedusjcxCZqk6Z8tNN3fiXpA9lu1SC9hixLlHu7am+/BzaOY0OlQc
         nx3uyOZj9pepIabNtCEHnzksYGri285CEa6jAL/ZaogaUkfB9TcjD1KrdFRk5hVdInNL
         Q7yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=y12OqUDXt0uUd8S/w/N9B4j5fJB9b6dEGe48WxLpJQ0=;
        b=iHtwXaVaO1H3GPyOi48whyItkXV4rsxh9UhpokzFevXTKnwMlh1KphbvbnVljuutHy
         sFGspU0V+LCXTybeZNGQhkHXjr+cwwciZwj0K9sesOmgnmD4WxWeMSruM4FytNuP6Z0a
         lZ0qXFaumTSBT8bmRjXkz5URgDkhkT5e+12LAjW7DFCEqOb2qH7YSEd5uYKY93KK1Q3N
         KTpIjHcKBaEMTALOdH82+sEdKVR0FmR19OZ1Jo7vs0RXzMhGUWdtiQnZkVnDj42p9Eoq
         pTSz8TwRlXbNokC6gNpXoqT4b3/arFZage2l1hVoKefz+PlDdVGfJULNXnrUXRVxcmKr
         PD0g==
X-Gm-Message-State: APjAAAXpUH2fgqUCGCH5OrurW94Du5i63XfGjx1xu7P0n40pU7HWq0bH
        xoK4NOkUmMKbEW2lhL1DnZnPvQ==
X-Google-Smtp-Source: APXvYqz9ZmT3mmRmWoZneEqLxJDx7rmmR3dC+5Tb7MVDbitwoik3uWhRkcyt0PDRQ6WmBWMTwbR9xA==
X-Received: by 2002:a2e:7e05:: with SMTP id z5mr3623227ljc.120.1570653702474;
        Wed, 09 Oct 2019 13:41:42 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id h3sm730871ljf.12.2019.10.09.13.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 13:41:41 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        ilias.apalodimas@linaro.org, sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v4 bpf-next 02/15] samples/bpf: fix cookie_uid_helper_example obj build
Date:   Wed,  9 Oct 2019 23:41:21 +0300
Message-Id: <20191009204134.26960-3-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191009204134.26960-1-ivan.khoronzhuk@linaro.org>
References: <20191009204134.26960-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't list userspace "cookie_uid_helper_example" object in list for
bpf objects.

'always' target is used for listing bpf programs, but
'cookie_uid_helper_example.o' is a user space ELF file, and covered
by rule `per_socket_stats_example`, so shouldn't be in 'always'.
Let us remove `always += cookie_uid_helper_example.o`, which avoids
breaking cross compilation due to mismatched includes.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 samples/bpf/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 4f61725b1d86..045fa43842e6 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -145,7 +145,6 @@ always += sampleip_kern.o
 always += lwt_len_hist_kern.o
 always += xdp_tx_iptunnel_kern.o
 always += test_map_in_map_kern.o
-always += cookie_uid_helper_example.o
 always += tcp_synrto_kern.o
 always += tcp_rwnd_kern.o
 always += tcp_bufs_kern.o
-- 
2.17.1

