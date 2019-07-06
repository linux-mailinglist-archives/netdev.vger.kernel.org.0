Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C01D360F82
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 10:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbfGFIrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 04:47:19 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38766 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfGFIrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 04:47:18 -0400
Received: by mail-ed1-f67.google.com with SMTP id r12so9817203edo.5
        for <netdev@vger.kernel.org>; Sat, 06 Jul 2019 01:47:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=7vneWnyXJzKPPDvLHL2jJZFzjuGOto3omXFCao9md4I=;
        b=CQmHFZ8c7tOzCBNyg3SX3ovqxDPPz1FLsYD6yWVLArkKSsHikIXa2WhX6hjFXQfMzv
         niuE77LAsSy4+k2nmwsXLygibBDkH2gy2kVbtrBJstC8sPOxDyU9GV77swdm5zrN0M4g
         v3QqpwmWASvMKnYsgCvALAa0q1UJezXaSUM2PItiK4T7IJcX5HF2JNRz22/Tj0GsVVs3
         NrxIVEW3IMCRIs3bzv3Xp8BBtyaF2P0+n1axLTuhousuQyBgkct6NHexK8C8YoSfTqfV
         mnOndulMP2oAk0nPqgIJ7HAgP1dtA1imGNk8ngg2TqqwcN9BTjtZjT+emgluB/FuddBk
         yRgA==
X-Gm-Message-State: APjAAAWSYtM9L7/a3b2YaRidCg+zH6BwW8Us49SAS924ndEBRX2W4zU/
        GRyTSY5Pj3OUOwE27BMjr1Bxqg==
X-Google-Smtp-Source: APXvYqyMXAZZTM1bR54H9gvnOvjzSwbATCyIo/jic65RJFNsXsME/mIERBhQbXHNRrzEMGTGeN5UhA==
X-Received: by 2002:a50:b122:: with SMTP id k31mr9042621edd.204.1562402837218;
        Sat, 06 Jul 2019 01:47:17 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id uz27sm2225681ejb.24.2019.07.06.01.47.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 06 Jul 2019 01:47:16 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E7A9C181CE6; Sat,  6 Jul 2019 10:47:15 +0200 (CEST)
Subject: [PATCH bpf-next v2 3/6] uapi/bpf: Add new devmap_hash type
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Sat, 06 Jul 2019 10:47:15 +0200
Message-ID: <156240283587.10171.7368339368508661325.stgit@alrua-x1>
In-Reply-To: <156240283550.10171.1727292671613975908.stgit@alrua-x1>
References: <156240283550.10171.1727292671613975908.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds the BPF_MAP_TYPE_DEVMAP_HASH type to the uapi bpf.h header, for
use in the subsequent patch adding the support to the kernel.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/uapi/linux/bpf.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index ead27aebf491..7a0301407f3a 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -134,6 +134,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_QUEUE,
 	BPF_MAP_TYPE_STACK,
 	BPF_MAP_TYPE_SK_STORAGE,
+	BPF_MAP_TYPE_DEVMAP_HASH,
 };
 
 /* Note that tracing related programs such as

