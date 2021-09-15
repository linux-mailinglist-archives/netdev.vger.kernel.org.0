Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99FAC40BF2F
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 07:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236322AbhIOFLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 01:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236318AbhIOFLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 01:11:25 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AB9C061766;
        Tue, 14 Sep 2021 22:10:07 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id h3so1534983pgb.7;
        Tue, 14 Sep 2021 22:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hBFUZiw6zxf4pUKWQiQT11iEjQyVaR1toou8fKVqzJw=;
        b=j6PkD4ICM6J1UDHTLsdrC+FhPor80OW+AnAIKezuFQUe0M90+umNDYUfamSKPpYhVQ
         VNgKLBvlU7+Igo6CiAarce76quLlib5L+CjlcaeR1FgZO+8AIpSzdCye4tSmwjFpwdpX
         kh5s2Bes/dBq5u1ZOQF7+RFFMwWMXnqcCPtphy7jkx71xGBStnnmsn1kKffCgHkDORBJ
         kMg4UlMGio7kvWxv3UAO1aq4kmjBy3fvVYuYeO4IYcDrYuGZIK9YllDJrMTzGXNwxAy8
         IvBjbtf0thkNuNKn3Mp0MqckEqY5LA+zvS0tWTqpBX0ZIEBgRkpZ8QTui//KhZwMPVu7
         JHKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hBFUZiw6zxf4pUKWQiQT11iEjQyVaR1toou8fKVqzJw=;
        b=TN3tgbUW0esyGT5PQ4VjZ3Wbmosaajjywgv6vsLjMZ9IRfsqqDiC1aci8e0fDkLb7S
         0OHUfmywzoPokBpQsrgx8DOMJivQkKxe1Ncg7mV6uXzLNDYDJvMf3NChMO0gjMPkI+Fs
         gPRo6cHwEvla1mvaPmDhUgNgiJGlwNLloxxApnAAK4QrECp7sWTscRQBk4AO2uSmRnLO
         ZZKisI96LhWK4Pm2/qUfG5SLxyPcdVNS/6LG8S0HBj6k+2lM8csed3vnQp/G2FRu5HnZ
         O4/1ADcJeKv36GNk6K9rjk/cvjBbKN8mmePE5O1D1kX3lu/+D4l0LH2wzf7AY+aLpMGu
         xsEQ==
X-Gm-Message-State: AOAM530maXVVfrlkObrjaeZnxZjhihDV6dSx6qt0ZxT08tUppjybtOkw
        urWPjRlV1QZ8a741YUP6pnRZyN16j+ibRw==
X-Google-Smtp-Source: ABdhPJz6xeO0Srn5ZxFGEalSFRCadJvDctmx3CKiNeuBWigCz3t4h0x9CAuCWCZFBGDheDXrJKSoFA==
X-Received: by 2002:a05:6a00:1706:b0:434:9def:d275 with SMTP id h6-20020a056a00170600b004349defd275mr8610387pfc.1.1631682606504;
        Tue, 14 Sep 2021 22:10:06 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id m18sm3201835pjq.32.2021.09.14.22.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 22:10:06 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 06/10] bpf: Bump MAX_BPF_STACK size to 768 bytes
Date:   Wed, 15 Sep 2021 10:39:39 +0530
Message-Id: <20210915050943.679062-7-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210915050943.679062-1-memxor@gmail.com>
References: <20210915050943.679062-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=912; h=from:subject; bh=B19ILwR6K3rnkHTsjQYwJPYCeDgJJfCXMOYYCnC9Rck=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhQX4b3LKRLbzT7lxBhQPvK4fFFNC2ILXCx90krbkD YYg+LBWJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUF+GwAKCRBM4MiGSL8RytupD/ 9W8w4iMpqg+Fzt4k2rJHmoqdBCnDzAFKF2c01jFpn2Pn1/RqaomJ0gYD2TJRhcL+w/smmuBdZ0fElh dPU60iNPCKuKs5y999vTPn39s+m/yDsFsuuHBKrFCw82brpq9Was5zPmcLC2mEaGvM/MNmI4JgZ79J dbkdcm/Y2lUG8rL6GpBwRhJKzi9WFDj923DtSMXFF5Tpy8vbeothTUYElaH9syOCWg/ruh5Lzlv0tv wutC6bmAWXptJKee2sdQm9UfES2ctsCNIpeWO5H/4s5VI0hVHyPdJSpJ5kr7l67J9TR2v1ymf3N4UA cLSxZE60bKpXzYEChJOJUTH9INWDtItA5m84QjBwnEgOdEMBJ5QDL5c7N1dK9sJl9kXXLPIuEm51Wj 8GoIX7528R7JwmShVrhqvj3OpWDni3rKYXkDy7iN5W3RVuG8Mc97oB6dL5uQao0A8OoK8xosxyKTmp 2OKEtonrAWs/EgHpcjbvp3viQJZ/jIra+7KiR7odiL33qGT9TB07ZyvfIRGVeDruH8YYsZM4ieDwOQ Q7vBRkJpwhDikhi6ZTkhkOtv7PTZTOuv/tYohZF4AZAuEZrGlZnmEUpHAfyC4qUp7Xgo2V+zQPVGKA N3nPjdal02q9xIcxGCbMKOrRMmX+R0puMV1Q/sFDn0YGi2QDSOaZp4pqgVlw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Increase the maximum stack size accessible to BPF program to 768 bytes.
This is done so that gen_loader can use 94 additional fds for kfunc BTFs
that it passes in to fd_array from the remaining space available for the
loader_stack struct to expand.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/filter.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 4a93c12543ee..b214189ece62 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -82,8 +82,8 @@ struct ctl_table_header;
  */
 #define BPF_SYM_ELF_TYPE	't'
 
-/* BPF program can access up to 512 bytes of stack space. */
-#define MAX_BPF_STACK	512
+/* BPF program can access up to 768 bytes of stack space. */
+#define MAX_BPF_STACK	768
 
 /* Helper macros for filter block array initializers. */
 
-- 
2.33.0

