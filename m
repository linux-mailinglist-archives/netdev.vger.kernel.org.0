Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB451B95B4
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 06:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgD0EOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 00:14:12 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55481 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726172AbgD0EOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 00:14:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 269BC5C00AA;
        Mon, 27 Apr 2020 00:14:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 27 Apr 2020 00:14:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rylan.coffee; h=
        date:from:to:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=K4URk2ZcnQjk+hjquiyOCCD9fs1
        u9LxSkQFBuzSxcE8=; b=TJlAI0ygGDBJqLKlSdGWLqYUbRtFGhimrNidI5NUrjr
        wO96GG8ymACYq9C+bKujmGLxQO/ju8pVlDewpQstu9gxQaQy+fTh+XlMvXrLCBYj
        TovvazlJ2JZ26CZLoUJNqc/G/Zvjnt67q7CRdvmvAO1L9dD9UZqimqr1MGevAYHR
        JqzAgOUc54aFem38u+pngFSozO+6WYmpfsLYIZ87JwDlAvZOPmojbGHQyJ1GavBd
        cwmvpOBLTfmpcdhDtUzZSbHkCdld8MP0r6r3cgZrGeGfzSDHjTHT4NGrsGNvkqLj
        xFZsFOn1PASXmt77mxbocRJ/h6MjUSx7giflgXo6uIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=K4URk2
        ZcnQjk+hjquiyOCCD9fs1u9LxSkQFBuzSxcE8=; b=KWRuli8w4n4WfxbX/umecW
        xHlP32jFKHc4bczAwRNlb7Vk7WAUyUUDCz1quPxFrSe4ybAQmPqBSlw1w+GbJyA8
        va13zPxfShv6UOtdMOuvbI5XzGvly+s09nFWd5YrLz2/e+45/zHJkiG7LF38w1gK
        Fd0jk3SArVu64DAVxMFFm4XhwDqkQ4Ww84243sGzlnmu+2p1fflILf3ijVKSoG7V
        cPzlE3+3e8oaWQrc9yV/ah4alSmwnwsBcneCuZmHGbfcpW+tpf3FkXH+xIeo/1gq
        rtVghMClCu6woLEwsNYw5plm3sFXHP2Ih/TMSYgrOgXVXqUCS3WMU+LiX5ciZO2w
        ==
X-ME-Sender: <xms:E1ymXuNWQnvyfu9Ba7VlCcf49hcRS0nrUhUrYdwARBoT3oX2lzVxQA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheekgdekvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtjeenucfhrhhomheptfihlhgrnhcu
    ffhmvghllhhouceomhgrihhlsehrhihlrghnrdgtohhffhgvvgeqnecukfhppedutdekrd
    egledrudehkedrkeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepmhgrihhlsehrhihlrghnrdgtohhffhgvvg
X-ME-Proxy: <xmx:E1ymXvSUjKWEBoOYSKYsyE5sOs-3OCHnM0KgW_M6HDPRK5P2xC9HeQ>
    <xmx:E1ymXj8BctDZsQbiaEVFckmFz4jlZj_fRWRnEbgs-GIlDlM4661COQ>
    <xmx:E1ymXro36m4ZnulVuRnVejbnmOsOVfnXGXokJpyXPS-nIXi-K3EfBA>
    <xmx:E1ymXvkA7cTh67u4rGT-zDbIfkere_DWi21yjc_TQ7kSSMRHcwxN4A>
Received: from athena (pool-108-49-158-84.bstnma.fios.verizon.net [108.49.158.84])
        by mail.messagingengine.com (Postfix) with ESMTPA id B26363065E3B;
        Mon, 27 Apr 2020 00:14:10 -0400 (EDT)
Date:   Mon, 27 Apr 2020 00:14:11 -0400
From:   Rylan Dmello <mail@rylan.coffee>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Benjamin Poirier <bpoirier@suse.com>,
        Jiri Pirko <jpirko@redhat.com>
Subject: [PATCH 1/3] staging: qlge: Remove unnecessary parentheses around
 struct field
Message-ID: <4dea7a7fae6a56c51cc19228b82a3c230029f54b.1587959245.git.mail@rylan.coffee>
References: <cover.1587959245.git.mail@rylan.coffee>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1587959245.git.mail@rylan.coffee>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unnecessary parentheses around a struct field accessor that
causes a build failure when QL_DEV_DUMP is set.

Signed-off-by: Rylan Dmello <mail@rylan.coffee>
---
 drivers/staging/qlge/qlge_dbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 216b13d8c131..e0dcdc452e2e 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1559,7 +1559,7 @@ void ql_dump_stat(struct ql_adapter *qdev)
 #ifdef QL_DEV_DUMP
 
 #define DUMP_QDEV_FIELD(qdev, type, field)		\
-	pr_err("qdev->%-24s = " type "\n", #field, (qdev)->(field))
+	pr_err("qdev->%-24s = " type "\n", #field, (qdev)->field)
 #define DUMP_QDEV_DMA_FIELD(qdev, field)		\
 	pr_err("qdev->%-24s = %llx\n", #field, (unsigned long long)qdev->field)
 #define DUMP_QDEV_ARRAY(qdev, type, array, index, field) \
-- 
2.26.2

