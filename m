Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8E46109BE7
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbfKZKJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:09:45 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37143 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727919AbfKZKJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:09:44 -0500
Received: by mail-pg1-f195.google.com with SMTP id b10so8756821pgd.4;
        Tue, 26 Nov 2019 02:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pUc8XgU3PRUIYnmGD1sk4dmdkx2zuWhcKZo2RCjAbj4=;
        b=V/YUucEhcvTyJgZSWsi5RwLlFSOkklklct0nM4joSGWaIR7na/no+LPxPiWVwQxxt3
         MZTId0BfvRrcBB5cS/xNn6YkR/nR/a/oFs+qoKWNnr42ZGOZSgTJb1F9wGQ/O7rl4ool
         fqDK2tc6OlvGgzuoLOzoJUJQHilZeQPmXpSCsMF/iAGRQPq1estAj8ZW+DJ3zXLxs0I/
         Q9QpB8OHiq3d1Lt0nQ7YBRWLpuxJLuJe9KhDCvCcZTqb9EKaythXaA5hLTcRTjhHTcg0
         Zmy8SaIL9vFHoxTDHybOLMp6I58SLo01Hd5rnDgBZPghb4JF9K2no8TAUZxDYsM3NvAV
         RVqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pUc8XgU3PRUIYnmGD1sk4dmdkx2zuWhcKZo2RCjAbj4=;
        b=O9+qpQW0FhQD8rPBmhv4FycRYTSLSamB6YnyBj76qcm5GvWuNhlSy0ktfHNCjRMV4R
         4M50zfTf2kDCb893TM8dPrNiaTBr/GdIYBMwuPWc6qNlRFjp8mTMoaZfxHNJBsgm8PwY
         7CEd5Wg+kIM3WFOvYCpNPp0CgA7h/oWeZKhF55BusraV8zstB2M6x/wSSb013aC95Xvz
         ROH0XzJ02ZdJHxWr3OUBNqllVlcByqwxpKg78xI+3la1uS1zPYRVsbv2u5rWsOfoG2bD
         zVidoAdfK2N+Utj1M4y9sxxGPyybeR8j6NP6t9eJ8U7Z3DNsQ7YqrBhoPhp/HTzv/uGJ
         iY8A==
X-Gm-Message-State: APjAAAXTBSXTeOkRSY1MmCbt5/OPR09c6s4EYr573H8a86PWUEhHoJPI
        232w9TFST/afPiaQrc9jUmA=
X-Google-Smtp-Source: APXvYqyXGcO2rx/7HpN4RNXvapDE7gQDbHTJMsH1+iqGmKXZYJEaN21RZ6AzcvVf5dFk+Y1nNp9XGQ==
X-Received: by 2002:a63:6b87:: with SMTP id g129mr29081453pgc.438.1574762984061;
        Tue, 26 Nov 2019 02:09:44 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s24sm11848485pfh.108.2019.11.26.02.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 02:09:43 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Prashant Bhole <prashantbhole.linux@gmail.com>
Subject: [RFC net-next 16/18] bpf: export function __bpf_map_get
Date:   Tue, 26 Nov 2019 19:07:42 +0900
Message-Id: <20191126100744.5083-17-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

__bpf_map_get is necessary to get verify whether an fd corresponds
to a bpf map, without adding a refcount on that map. After exporting
it can be used by a kernel module.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 kernel/bpf/syscall.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e3461ec59570..e524ab1e7c64 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -737,6 +737,7 @@ struct bpf_map *__bpf_map_get(struct fd f)
 
 	return f.file->private_data;
 }
+EXPORT_SYMBOL(__bpf_map_get);
 
 void bpf_map_inc(struct bpf_map *map)
 {
-- 
2.20.1

