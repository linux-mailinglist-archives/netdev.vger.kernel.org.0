Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 057AE28E58
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 02:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388653AbfEXAan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 20:30:43 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43480 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731488AbfEXAam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 20:30:42 -0400
Received: by mail-pg1-f194.google.com with SMTP id f25so3989513pgv.10;
        Thu, 23 May 2019 17:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding:user-agent;
        bh=XZsqJgkcCKygTlVoU/wFBCrr+8eotqrBwsnc4F7PYoY=;
        b=BY++Z5xBgwJMBsNDSgyb/nDiqbsQpBpBaAGWMK/dtyX6ST0HuululL8lFKpX+ApBMd
         PG4j2HomNxN4U10INIuR7hIzfzRaVWeGqR05sXXpTb4GUSDWFOdGGW03FslMblIybUVG
         49nTQDBPDDG/rt7YLLk5LWn/LWbDSZKgH8nUDXUEnlOV4gmZvVvZI5gyuzBX3j+5aB0M
         mdqWkzOEgmcxVav2JYt2ALUU3UaxHmLjPkckQGZPm545eVMLWCDRfNUA0CbTXEcZPaBC
         xRrEYFxaXmavKAB9sxcM4V69yUfmznDozhE6KO3IuphJZ88pcqwRsm4eulzkpva0TEPe
         ZleA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=XZsqJgkcCKygTlVoU/wFBCrr+8eotqrBwsnc4F7PYoY=;
        b=Gn9B7aDkAoo1HFYIgMi1xwDQDEBsEErDQyfKmh4lvKMCAacIJfx80J3AOMBbfURpyn
         sJ0FEoyzqkW+Mqcu8sbZIXQMfA5UxiLDrcg46W99+o1L0KX/7bTY8WBdcJe0hyQQpUQf
         i9R6ArbTZy8Bw7mOwOMy9iYCTsrgZomx00VVgw/aO0oYOv9aQF25rXujihVRNQvIgNQ9
         8DSjpKZO4pu/jkj5IoFS+AZFsfgkN6H3/tS+S1kWJAabpxSfiT81uoB6cU6UZB1gt3d+
         4s/gOPOJMoV0ZjjFFBu5nSL72icrr3E95678rFtJ6JIvaKh/ZtNc7U6zyYuJzBK2qaBq
         pB2g==
X-Gm-Message-State: APjAAAVR4nhWvYsUudIPx8GvvyiBd3jeJh0Iyd8e5ukww0vHZ/u6dkko
        HVmZ8Bhw+uXS8f0o3sE8CbI=
X-Google-Smtp-Source: APXvYqxdX3g4INyo5kJ6LXrrSnnDu7DWa3DIgP83m/ktPBR+Bo3gIUCa+bzgvEr9EgKGj3j0VLh0Ig==
X-Received: by 2002:a17:90a:a608:: with SMTP id c8mr5298255pjq.37.1558657841393;
        Thu, 23 May 2019 17:30:41 -0700 (PDT)
Received: from ip-172-31-44-144.us-west-2.compute.internal (ec2-54-186-128-88.us-west-2.compute.amazonaws.com. [54.186.128.88])
        by smtp.gmail.com with ESMTPSA id w12sm457394pgp.51.2019.05.23.17.30.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 May 2019 17:30:40 -0700 (PDT)
Date:   Fri, 24 May 2019 00:30:38 +0000
From:   Alakesh Haloi <alakesh.haloi@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Stanislav Fomichev <sdf@google.com>
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: bpf: fix compiler warning
Message-ID: <20190524003038.GA69487@ip-172-31-44-144.us-west-2.compute.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing header file following compiler warning

prog_tests/flow_dissector.c: In function ‘tx_tap’:
prog_tests/flow_dissector.c:175:9: warning: implicit declaration of function ‘writev’; did you mean ‘write’? [-Wimplicit-function-declaration]
  return writev(fd, iov, ARRAY_SIZE(iov));
         ^~~~~~
         write

Signed-off-by: Alakesh Haloi <alakesh.haloi@gmail.com>
---
 tools/testing/selftests/bpf/prog_tests/flow_dissector.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
index fbd1d88a6095..c938283ac232 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -3,6 +3,7 @@
 #include <error.h>
 #include <linux/if.h>
 #include <linux/if_tun.h>
+#include <sys/uio.h>
 
 #define CHECK_FLOW_KEYS(desc, got, expected)				\
 	CHECK_ATTR(memcmp(&got, &expected, sizeof(got)) != 0,		\
-- 
2.17.1

