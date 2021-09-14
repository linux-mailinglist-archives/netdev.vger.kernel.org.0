Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951FB40ADF2
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbhINMjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbhINMjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 08:39:33 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C06C061574;
        Tue, 14 Sep 2021 05:38:15 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id v1so8082155plo.10;
        Tue, 14 Sep 2021 05:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hBFUZiw6zxf4pUKWQiQT11iEjQyVaR1toou8fKVqzJw=;
        b=YeAfWMtchwQfhWC7kL+ghw7be+SBhtzT0PSa1lKdsXAwUAgb2n6HPiaOeZ0iWrLOtW
         7wfsncn2D5XMIL+wGGxwxLm9GveA/t5Ak/fZC/e5vIqVJe8rS8m82XFTAvWGOVYGidHe
         vtjOJjFNJxYu0tbC2UO1gFK9b4+OuYUmavSe1+cXw1OS6vLuxr3M9m3EGSaxY0csdBGi
         RPurR2NzXngjyzE/KMm9XD+saRAZcvLm/Uge+YmNEsabZ6zwb7G0IZjpEalOJHI+1pHC
         Hck63BfE716ayTDjePqQhQmNIsOl3jhoIooILuhu507NRYLbPiGRNtHWE5EzGX6d1S/n
         w0Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hBFUZiw6zxf4pUKWQiQT11iEjQyVaR1toou8fKVqzJw=;
        b=XVGjJudUpvcCGb20sbQn9bSZe9DwztU0uHm/gPr68JohAP9PFRTqea7yaqKhKY9Vd5
         iMUuFmXHK9nie7FRkzPCpHqNSuxXS85o8Mi4V/mAbIAPbmupls3i5Gw4q5ucojD6hyv9
         arweuniHC+/E4ZrZSDZ+yJdF4Pvp1l63IfcDvKQGwjSN+8ivyE0VBBngl0iBzXFindNo
         P9ByedrsEEy5rghbRSsdzhm7E7Xirls/ikP52aYLB2qY29Hrao+gIGc+kodkSgdcAvha
         Ov2R8UPFMWtboqnyzy/2rfqWw9ID9tzQjTgUvWmho1IV9sdk6TKBp0jW5XvxTAsGTMgs
         6jxA==
X-Gm-Message-State: AOAM531Qab1Z/kShB+7VK8zh+E0MiWhbsE//n9B7h7Ll5FXTtdrGggXk
        irjMeMKP8qIAcIsZe+c+Ak4aNqekkmEgBA==
X-Google-Smtp-Source: ABdhPJzX72bxMhcDvNcWPTP2qi2JplW7H194IQ06bcsBBd+nQOGAksif2c8MMb2kKzWHXo2aMpWlfg==
X-Received: by 2002:a17:90a:4d8d:: with SMTP id m13mr1883197pjh.190.1631623095243;
        Tue, 14 Sep 2021 05:38:15 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id mi18sm1893661pjb.15.2021.09.14.05.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 05:38:15 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 06/10] bpf: Bump MAX_BPF_STACK size to 768 bytes
Date:   Tue, 14 Sep 2021 18:07:45 +0530
Message-Id: <20210914123750.460750-7-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210914123750.460750-1-memxor@gmail.com>
References: <20210914123750.460750-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=912; h=from:subject; bh=B19ILwR6K3rnkHTsjQYwJPYCeDgJJfCXMOYYCnC9Rck=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhQJdW3LKRLbzT7lxBhQPvK4fFFNC2ILXCx90krbkD YYg+LBWJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUCXVgAKCRBM4MiGSL8RymO/D/ 96CbCCvvSNET6IxUjrLbI/OHXI2yo5UeZ9puFOxSgPOyhxx005s/C8bVWtAEllZvdh/htmO7rc+7uq oGEOGHG9DU0XhjcgaMIvbKwQHQ/PDX9DXcigUGbDqND6Ysf98qRMwVKExMaF9GQ795L2nG0JMoGv0j zRjdrl/iB+dh/Bp6eOmBDlgpNb+JyqHRjQqhp5HbCeMr2DKR+yMvxwVlXbWz3sUKlTqXHnwisMqXes Bn16rdhSA9CzBKEAcj1efIy/6S7tqBAW/55lFw4WP4ZLvgH7QtpIBNRQvdFOkHfL7YDXsbQXA1YiZT rNEm6ftxqkjZKEB39U6mAauKLQo0S7Wmmm1JqwBUlr7J7WjfLipxFu/rpbBzsKeqhQ+EPn2Tvxr4cK KvqJC69uVy3+bKQqjcB99oCPsdXZOU0/QINqjODE6qVJv0z5TrsNWcYBlWoDp6OUPNEUMznhsjQRcR Dnti5q2dRrKu1nNzErCgDG0a1cb4MGeCdYJFzumLGXLRiT6MZQaC8OoDPl8hLZeLSZ8Nd8YLA2si+y 878myrCUx7l73qoEXI0uDoQHJaC1UIGDLB6qyEZF4XTZF6PhUH8NorzbydEV0h2OJ4+Zxm4Mid26GG 9Hdmumq5x5u5eb87OZ8n9VV4Qexd2U7aMb+2CC08LiMON2YHxkp7YDYsxk7g==
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

