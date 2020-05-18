Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4201D88C4
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgERUDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 16:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgERUDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 16:03:45 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E33C061A0C;
        Mon, 18 May 2020 13:03:43 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id t15so5210543ios.4;
        Mon, 18 May 2020 13:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=N3rvqAX4uqzP8ZJYpHlcH0UIASMnlqmntD/M6QqshOc=;
        b=T5Z6dfddQv472Evjqb9BiRBnao7msU9//6vRnR/mkUtb7aIozt7nejWabjiPxy9Xnf
         db+7ZY59oU6fUuq5k7ICun9KrGI5f1S7u+d04VltIzZ2ZCliIFbzmJCFR+BmS/XqNWpB
         9puUETlWIHJRfwM1X0QkBLH5js41XE6wWFiOvtx8cQJ/9bnloAFaZTrJ7tTn4OFLYN4K
         G+v4iGOnrOfFgmG22K7Fin9DINmua5XBlzpycbze+Y0Mm68OShjPfMdEVksSXXzlEPp8
         pq3zUUPO0Meb4aMsGFxX0EXlKCQLMzuVJUJ3rUlrbbC1h+jeQTExfefuxYG2iauGi3Vo
         ISzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=N3rvqAX4uqzP8ZJYpHlcH0UIASMnlqmntD/M6QqshOc=;
        b=m8yV13TO3kqJXbEUaTQtamRIF6ZqTXY8q9ObmFm22QB/Mp4kTlh/dDM23ZhMk+lNPE
         rqN/V7uUnLn0DvzV5R6PC2QfC+2yaR9N+uCd6MRgVogAeGPJAYpTo9i91SgG7X59bxVz
         dDaB6Z0/mXfvvRGWOp+KwBLg+hISPyofIh7VgsEC27GGYvcQ9rBrXF5abvMrBFTAHNBk
         /bqYk2/Yq1gxjSVBxYkQbwhYLDItjrtJE7W+aa1KlqSTTKMAJe+SlSbIEDMyToyI6zOa
         pvEM5D0sLi/JULm9GfqTDhrNKNgSKjWDhBl58kC7Nc2WmhyRxMUT/1txNrmGmOIYf2bY
         +AxA==
X-Gm-Message-State: AOAM531d5P9HnSOcUmudtPvlroq4/RPFStUSpCFziSqizeEXz4NIaj5I
        E+LqBYX7mpQnB2rYfxQlDuRYcE0X
X-Google-Smtp-Source: ABdhPJzJ5tfoIJtDb/MHQ/a/ffjHIXXs6JRT/RFfBYrFNmcPgy7rbNA6zh34Y64h0fYZVqiqrolDPQ==
X-Received: by 2002:a6b:6508:: with SMTP id z8mr15995597iob.130.1589832222983;
        Mon, 18 May 2020 13:03:42 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id c13sm5215475ilu.81.2020.05.18.13.03.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2020 13:03:42 -0700 (PDT)
Subject: [bpf-next PATCH 4/4] bpf: selftests,
 add printk to test_sk_lookup_kern to encode null ptr check
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Mon, 18 May 2020 13:03:30 -0700
Message-ID: <158983221039.6512.6745842570405722925.stgit@john-Precision-5820-Tower>
In-Reply-To: <158983199930.6512.18408887419883363781.stgit@john-Precision-5820-Tower>
References: <158983199930.6512.18408887419883363781.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding a printk to test_sk_lookup_kern created the reported failure
where a pointer type is checked twice for NULL. Lets add it to the
progs test test_sk_lookup_kern.c so we test the case from C all the
way into the verifier.

We already have printk's in selftests so seems OK to add another one.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/progs/test_sk_lookup_kern.c      |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c b/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
index d2b38fa..e83d0b4 100644
--- a/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
@@ -73,6 +73,7 @@ int bpf_sk_lookup_test0(struct __sk_buff *skb)
 
 	tuple_len = ipv4 ? sizeof(tuple->ipv4) : sizeof(tuple->ipv6);
 	sk = bpf_sk_lookup_tcp(skb, tuple, tuple_len, BPF_F_CURRENT_NETNS, 0);
+	bpf_printk("sk=%d\n", sk ? 1 : 0);
 	if (sk)
 		bpf_sk_release(sk);
 	return sk ? TC_ACT_OK : TC_ACT_UNSPEC;

