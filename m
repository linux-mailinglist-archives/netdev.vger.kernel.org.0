Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A836F04ED
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 13:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243737AbjD0LYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 07:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243711AbjD0LYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 07:24:10 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2335FE0;
        Thu, 27 Apr 2023 04:24:03 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 24C3FC021; Thu, 27 Apr 2023 13:24:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682594640; bh=ktwVTjkmEChjhY/kRpODTnUXv8zYYBOjSBS7MBgR468=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=YiL6ZYJi+YLRa0svXQ6itVhYqBapUedCZ4a+ZF/jn5/jg/WQccb6l3L6jcFfooyzu
         DrunOhIJfUZcnqtGy4jKULDC1x5RqQcft4G5S7CpVhu6hqS3q7AcJi5Y9ncYRLitJX
         7TKlxFwaeEBLxbj0CdOpyAvSyBHMq7/T/iNzlDd2E6HRzWitgTMP5zk/Gk52ZS4mJd
         3MygLf0G1/ye2m01NnAMMKv5HJKMTLcGEkhZfeEpz2Jxth9oXyz2fvbgxgFe8XYP9Q
         gcRgYiTVgn2wYP1LTuA1SiucHQDqZ//hogpK9yQswv5DR4ZNGsbJc2dsgpW+/8Y7oS
         YD1btsr+EUffg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 2F438C009;
        Thu, 27 Apr 2023 13:23:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682594639; bh=ktwVTjkmEChjhY/kRpODTnUXv8zYYBOjSBS7MBgR468=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=GaPAOn9ax4E4wXFYH9FS+G/gn+WN8TnFfXvp/VD6Wr1pstK3XxHXSMVNHqAkxzUxb
         vXr7yXzu1V6sn6k7t5eY7xVCFHrn1aRD36Gi/ktPRn1mOaH97Zhj+ZJ07WiI+Sh/+7
         PweTC8jln3zqzitON0FKtdXhM31TisXEoatiLlom7MaKFZLAKxw6OIylDIyTwT2+J0
         KXBGojHZXOqAoAUiSNNynMQMhF3OIStrkizhMJP4vLxoEy+yeWa/j4lDXkHZGGS265
         3IwECDv8OH2AzPyDfSDddoiAGaX8cSdWmyctMvvlThKxwwghlyQMpkO8ebxQXsQAvV
         6NKgXWyaHiD2w==
Received: from [127.0.0.2] (localhost [::1])
        by odin.codewreck.org (OpenSMTPD) with ESMTP id d47cdf86;
        Thu, 27 Apr 2023 11:23:38 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
Date:   Thu, 27 Apr 2023 20:23:36 +0900
Subject: [PATCH 3/5] 9p: virtio: make sure 'offs' is initialized in
 zc_request
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230427-scan-build-v1-3-efa05d65e2da@codewreck.org>
References: <20230427-scan-build-v1-0-efa05d65e2da@codewreck.org>
In-Reply-To: <20230427-scan-build-v1-0-efa05d65e2da@codewreck.org>
To:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     v9fs@lists.linux.dev, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Dominique Martinet <asmadeus@codewreck.org>
X-Mailer: b4 0.13-dev-f371f
X-Developer-Signature: v=1; a=openpgp-sha256; l=1151;
 i=asmadeus@codewreck.org; h=from:subject:message-id;
 bh=MTmAPJ1UlUfirYv8DGy7tXkrUTvjMEZVRvmnf3jNkLY=;
 b=owEBbQKS/ZANAwAIAatOm+xqmOZwAcsmYgBkSls6AeJis7+yhZZ2w56xFaCjuExc7wUz20f1l
 IVqwQ9n4JGJAjMEAAEIAB0WIQT8g9txgG5a3TOhiE6rTpvsapjmcAUCZEpbOgAKCRCrTpvsapjm
 cGisD/9Eq2d3KddRTicpI39DZzltwawS/nAxGl9GSeTqTSN4fm+hsRzlV6MHofvjXhxVCdsA7BO
 b/5apjazGZZIOD8cSC3LGikEEGhySt7vSuf0abg5Ux1/IekDadvtFVpnTSEYeILBE82+c9e4uyQ
 6QKzx7VNOBriS0/Q3Q9MXiP1dEOoLIVJhxIWy/wJHGgx23Kx0k7JdNexzmrisfoWJerNhZN2N7w
 wZg4RvMrPJCyi5rvCs7NfAxP08M/91aYLqnYlRJl3nDrEJd7EsO6/gEcmlW3xm+UmVSHGULu4Em
 Ue2RWrTE9UderjLPqKiLvftYTHj5Cpyt5duZ6sU9h/bMMw4Z0IK/u++Lr9mYB+XGRWXBhdft9ZC
 uI+frkrXkGJP0NGFyIfrsDSbYs1Ma9ARicxfXFM2xXutUJZvpsF6aNBiIUK0XPS3nIRIjSt0HHD
 4JJFvQ6zfkcb1hcNrfrntwneTVaYoBMlVoZHTdYOX1HmoOb88NH1QWHY2b7DgtBS/91dsGqLpIy
 x0cWtAMWp6WvdnwViuzJ038G+Hq6yvc+2bZBDerAgQc88Wo/EHpRivMWKmeJOAmHibF/PYtMNbM
 4OKQmEhlz+Ho9beZRwgyqiIPxsJ4ZxydEl0ONnaa7eX10VgCyuq70KwBM4k3FEMw6yBgTU2Y2dL
 JXY+AQLEaBGbZbA==
X-Developer-Key: i=asmadeus@codewreck.org; a=openpgp;
 fpr=B894379F662089525B3FB1B9333F1F391BBBB00A
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to the previous patch: offs can be used in handle_rerrors
without initializing on small payloads; in this case handle_rerrors will
not use it because of the size check, but it doesn't hurt to make sure
it is zero to please scan-build.

This fixes the following warning:
net/9p/trans_virtio.c:539:3: warning: 3rd function call argument is an uninitialized value [core.CallAndMessage]
                handle_rerror(req, in_hdr_len, offs, in_pages);
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
 net/9p/trans_virtio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 2c9495ccda6b..f3f678289423 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -428,7 +428,7 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 	struct page **in_pages = NULL, **out_pages = NULL;
 	struct virtio_chan *chan = client->trans;
 	struct scatterlist *sgs[4];
-	size_t offs;
+	size_t offs = 0;
 	int need_drop = 0;
 	int kicked = 0;
 

-- 
2.39.2

