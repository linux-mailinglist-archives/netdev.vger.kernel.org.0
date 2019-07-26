Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6B576E83
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 18:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbfGZQHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 12:07:01 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39280 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727215AbfGZQG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 12:06:59 -0400
Received: by mail-ed1-f65.google.com with SMTP id m10so53723448edv.6
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 09:06:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=CyYEdy98K1vtgUTnbwkUFgPj3OGkpmHsdUQwKffDrWw=;
        b=nqfBlJhEXgqfdhqVzobg82CJuJgWNqohKPLZv0fVkKUu6Q1zWI7Pqp159zUgIln8UQ
         vqdKiCfvGcVgTwlih2xxv3pps4HCwZxBgBo2rWf1l/HKe+tbiY4fqj8SuFbGLQEWZuXT
         08myqDi7KTVT5EKIbTc+TSnhdFMmp3REh6qyG9OhPQAL+qv8YjKLC+lYMLy2UBeziRwb
         e5EkPCrSgXYycRzK2t/RPYcTycsFxbC7Fk9zjL+HT0TyC0TASBMKZTVr2m2CZupbJXXB
         n1OjCkLNER/YrRnOvsO9mOymlzt6DRygHcyKXDNVtx1jqdvQ9QdZse7DvxAAR5rS2X7M
         0jUw==
X-Gm-Message-State: APjAAAV2LQcy9siZycT8l2hxYstzUJW6TX58FU5v8tO0Dbw3LBdg2qjs
        E3hU/HVtLky/iaUKlxTLsowcow==
X-Google-Smtp-Source: APXvYqw1G8XVKa936qfYuqdO7ycprvMTOyOWjvdO20XwiNfAaFbBBaplshpjLBtrAW2OI5YUI4IkJg==
X-Received: by 2002:aa7:c486:: with SMTP id m6mr83694226edq.298.1564157217481;
        Fri, 26 Jul 2019 09:06:57 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id p15sm8343624ejr.1.2019.07.26.09.06.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 09:06:56 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5142D1800C5; Fri, 26 Jul 2019 18:06:56 +0200 (CEST)
Subject: [PATCH bpf-next v5 4/6] tools/include/uapi: Add devmap_hash BPF map
 type
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>
Date:   Fri, 26 Jul 2019 18:06:56 +0200
Message-ID: <156415721611.13581.17123668393574840124.stgit@alrua-x1>
In-Reply-To: <156415721066.13581.737309854787645225.stgit@alrua-x1>
References: <156415721066.13581.737309854787645225.stgit@alrua-x1>
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
Acked-by: Yonghong Song <yhs@fb.com>
---
 tools/include/uapi/linux/bpf.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4e455018da65..ee35cdbcc003 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -134,6 +134,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_QUEUE,
 	BPF_MAP_TYPE_STACK,
 	BPF_MAP_TYPE_SK_STORAGE,
+	BPF_MAP_TYPE_DEVMAP_HASH,
 };
 
 /* Note that tracing related programs such as

