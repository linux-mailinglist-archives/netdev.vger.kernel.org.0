Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9B8E61D4C
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 12:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730233AbfGHKzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 06:55:53 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44392 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729335AbfGHKzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 06:55:51 -0400
Received: by mail-ed1-f65.google.com with SMTP id k8so14110105edr.11
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 03:55:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Y+HIP1D5snh3uC+OteMBxZ6y8Bs63Vc1YRZCnHNTQEQ=;
        b=Sd9qoJTcY360HR89z0lKARXsVVLmNBNgSPEVASx7SjM7EbK/4o7iC3AbAhGpzbUcUh
         c/kdBE+fCMuKnuUuc2m7xAkhWYfiAURWQQS/G0NPOsZywKnvS3zoMtbjGltqiJGmKupW
         slyFYl5WbWr8OL3fzuB0l1y1b9UDCle1BA1T9pbeT0k5Md76xwhL4lF/SMq1muBidD9p
         ORirY9FrSE8t+fl9WunhSVaJ4C8Kb/wQeP+lmKO33ZvcUrlsgzk8cxgrswQAsyj1nlJ+
         Dguvbtvpy6a92Uc6Hcw9K2k8eeKlgT3nBHKsS+UF373ixOHhFh0y95z6D1oZ1NZq5mOz
         YuUQ==
X-Gm-Message-State: APjAAAWGHbMIJaUUYZSk95u3K5LTsM0s6Wcwn8BjuPA5iaZC7Vc8PJ53
        HIRDK7AN/JLAjEj6HO8kaYf9KQ==
X-Google-Smtp-Source: APXvYqwS9f2KDKwAGkiWV/1tUiztvgTukRXi8fRCLZ38e0tenvPc1eJq2WClhdjSGSjPx480+u9k1A==
X-Received: by 2002:a17:906:d183:: with SMTP id c3mr15988490ejz.149.1562583349524;
        Mon, 08 Jul 2019 03:55:49 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id w24sm5564686edb.90.2019.07.08.03.55.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 03:55:47 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6FE19181CEA; Mon,  8 Jul 2019 12:55:47 +0200 (CEST)
Subject: [PATCH bpf-next v3 4/6] tools/include/uapi: Add devmap_hash BPF map
 type
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>
Date:   Mon, 08 Jul 2019 12:55:47 +0200
Message-ID: <156258334740.1664.18295003114988159871.stgit@alrua-x1>
In-Reply-To: <156258334704.1664.15289699152225647059.stgit@alrua-x1>
References: <156258334704.1664.15289699152225647059.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds the devmap_hash BPF map type to the uapi headers in tools/.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/include/uapi/linux/bpf.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index cecf42c871d4..8afaa0a19c67 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -134,6 +134,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_QUEUE,
 	BPF_MAP_TYPE_STACK,
 	BPF_MAP_TYPE_SK_STORAGE,
+	BPF_MAP_TYPE_DEVMAP_HASH,
 };
 
 /* Note that tracing related programs such as

