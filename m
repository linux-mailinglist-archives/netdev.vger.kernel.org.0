Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A487F5AA5DD
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 04:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235321AbiIBCbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 22:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235244AbiIBCac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 22:30:32 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5314640E28;
        Thu,  1 Sep 2022 19:30:28 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id i5-20020a17090a2a0500b001fd8708ffdfso4203715pjd.2;
        Thu, 01 Sep 2022 19:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=V0gc6AUiAQY/WQln3OGyPk91MKpBrNPoI3+sFkmiGew=;
        b=YdKJPsj3wxmrtdhJ63cf//SS9jJ7JPgMY5Ex1l+fOx9UNzapxQ7i8fyfCKfg4DC/fk
         SKCqoIu3Lb00g2SEoCnPl+BmSgfvaKisdl966nvF6kLOv46V4GjP7QAko0FRxIpQUgDP
         +BAUY24JOpf1j9T/XcBIZ1nzFMUebVEKtDxZ3QHbKE/m/bDB7+h36BTsKpp/lHfXQVv6
         GmxW8iDrtqqVi0VcXAO6aBbWMwwAb6hXr2tJE3pBNIxaczYssgaQaXmHSMnehmD0T9In
         MbelyenA6iu3l7pz8fEFlMFkPExLSWN/gjke+3if8/R7WdY2vWMLVfeC38NKGyCWOiVt
         Vhjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=V0gc6AUiAQY/WQln3OGyPk91MKpBrNPoI3+sFkmiGew=;
        b=McUIvQM8IX1P8YtieXw6jSZp7yQFcFI7W2/W8q9UGY4C1Uojwq+/T/Wg9BjTX62o/v
         llgju5TuVvSJAKKBCd3M5YI6gyWlLFYp5JfFeESniESQHEliIzJ0eVTyI57PfN/IknSG
         aXEUbwBFm2fZRxS4P45vqkZjhoFOMPnL4uuMimWNoQQx6iaUFDJlBepiAI+MvMRpQHJx
         XrTL99DvUou1qzCS9ZznmYQKDmKFO9k+BtOyPm9Yr2ooOJlfCL1CBwb4y4FIg+sGI8t+
         3iMcHK84bVlkcUBzRXIcX0hcuwmuZQLxNYwvVcmEh3BdnDdecA9Colji6tQwbf45lVFL
         eBYA==
X-Gm-Message-State: ACgBeo34JblvNTME7MpOGClXaGAqE34j4m+9LBr+nIIAUNbx9gOqyK0/
        8DTY44Au5fB6Nfg1eMSpTbA=
X-Google-Smtp-Source: AA6agR5uktgD0liwSY6UrfEhRG+mLXx9clJMktiplgxkJLtJtcoS4ulnUGKjv6sSBbLKMm+PhmeuJQ==
X-Received: by 2002:a17:902:8e88:b0:172:d1f8:efcb with SMTP id bg8-20020a1709028e8800b00172d1f8efcbmr32528601plb.27.1662085827706;
        Thu, 01 Sep 2022 19:30:27 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:50ea:5400:4ff:fe1f:fbe2])
        by smtp.gmail.com with ESMTPSA id j4-20020a170902da8400b0017297a6b39dsm269719plx.265.2022.09.01.19.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 19:30:26 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org, tj@kernel.org,
        lizefan.x@bytedance.com
Cc:     cgroups@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 08/13] bpf: Use bpf_map_kzalloc in arraymap
Date:   Fri,  2 Sep 2022 02:29:58 +0000
Message-Id: <20220902023003.47124-9-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220902023003.47124-1-laoar.shao@gmail.com>
References: <20220902023003.47124-1-laoar.shao@gmail.com>
MIME-Version: 1.0
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

Allocates memory after map creation, then we can use the generic helper
bpf_map_kzalloc() instead of the open-coded kzalloc().

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/arraymap.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 114fbda..f953acc 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -1096,20 +1096,20 @@ static struct bpf_map *prog_array_map_alloc(union bpf_attr *attr)
 	struct bpf_array_aux *aux;
 	struct bpf_map *map;
 
-	aux = kzalloc(sizeof(*aux), GFP_KERNEL_ACCOUNT);
-	if (!aux)
+	map = array_map_alloc(attr);
+	if (IS_ERR(map))
 		return ERR_PTR(-ENOMEM);
 
+	aux = bpf_map_kzalloc(map, sizeof(*aux), GFP_KERNEL);
+	if (!aux) {
+		array_map_free(map);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	INIT_WORK(&aux->work, prog_array_map_clear_deferred);
 	INIT_LIST_HEAD(&aux->poke_progs);
 	mutex_init(&aux->poke_mutex);
 
-	map = array_map_alloc(attr);
-	if (IS_ERR(map)) {
-		kfree(aux);
-		return map;
-	}
-
 	container_of(map, struct bpf_array, map)->aux = aux;
 	aux->map = map;
 
-- 
1.8.3.1

