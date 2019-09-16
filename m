Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 717DBB38DF
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 12:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732702AbfIPKz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 06:55:56 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38387 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfIPKyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 06:54:46 -0400
Received: by mail-lj1-f195.google.com with SMTP id y23so32915605ljn.5
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 03:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=myQi7tUoXKWvWu2Otr2cMzZrUikwx9p5w927Z5U7K18=;
        b=zqzL4JzwdgYet7wSFB53zjRItWpS1hdeN0ygAfE9AmPl/tgeJ6oyvRLjQXycdwZXvW
         0LkJJSRAf4imSOLOE29XGY2MZ3eqllofQcObiDHWP0n70jafz5Etprt2/18so9bAoNTR
         PAxrU/Zo2hoAsOPF39JndhObn/PUwZAIGsIAbIudvGDm7SINJLoGj6UWh+CSx6AR54CG
         cqRWHQ/B4qTgGzo7uNYmgSSKMEPe9rgAJFIAtbz5BnbBBB1x1PXd9E9GZFdPz3dzbqwH
         8ftOXF8bhIMPmwb3IKjgxhtoyYYyFPxole8xysIfutsFzMyg7yF01NS6KpCla5EtW1LM
         4LFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=myQi7tUoXKWvWu2Otr2cMzZrUikwx9p5w927Z5U7K18=;
        b=I0ti/0V2/IsMYuw2KdV8E9P/RupeI2Cx/huDldtwv5a8zSSagaNK1NmcoqQYfkJYtr
         DgJh024U/izZCRVIsXOiGBbJJ+Ix42ErKrqbb8qRnMWQ20BbZzLkiIp4nGq95G1A4ur1
         HovUvyzpKuuneoLCSvm7CsAeQ6fnIKFhLGi580UyLBl4XaEWABQOFFTNnly+VC5M0dIE
         wE0NcOjEFTLKaD8M2Sn4FBUHErgA8A3ofKtdAi/F3AMCQzOhBzmQIH8hSjxsjH8nO93t
         xgnkl5mXjD1/ogjIBtQ99o2Dk0zTSs1iwP4+YcvNgHjSDFA5EPBKhPZeAQbRX/1lJ6CD
         YqNw==
X-Gm-Message-State: APjAAAVbw4/6jL4QkD6RjonoA0L2rRuWkDfH6vb2pCqNCFOuiX3sMM/Q
        lAUGbiZC1quKbhVAlG0qUGlNeQ==
X-Google-Smtp-Source: APXvYqzNr13KKv1AIr7OpHjlQSQcSa/f7Y9MYJkeX7w54sCZf3/vtF9w89HiJUF4vYPD+fo2fgIN4g==
X-Received: by 2002:a2e:b0c2:: with SMTP id g2mr1900577ljl.217.1568631282996;
        Mon, 16 Sep 2019 03:54:42 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id v1sm8987737lfq.89.2019.09.16.03.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 03:54:42 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v3 bpf-next 02/14] samples: bpf: makefile: fix cookie_uid_helper_example obj build
Date:   Mon, 16 Sep 2019 13:54:21 +0300
Message-Id: <20190916105433.11404-3-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
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

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 samples/bpf/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index f50ca852c2a8..43dee90dffa4 100644
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

