Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8131E48B4A5
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344886AbiAKRyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344362AbiAKRyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:54:44 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A240C06173F
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:44 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id l16-20020a17090a409000b001b2e9628c9cso167995pjg.4
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XNRt6/aITGiiV0hFDQpp/ZDiBu3MId5tidREj5NDK10=;
        b=FDjYGWd6T/hxoWbO2LPXcNt1tF/8tq7hKxt2bXqI1j0fALHzDcP402MmdJ9GjSH8u6
         qBOAISS+7VFopdzcwQM7p9SK59sjrXHSzJ1xnzUykhDILer9E/csOl1SB1dVQyhBrHDl
         l2r+6MlaL0GFM9nRpL8Gf4P+Cw4qc6taRalEfTFabLN+438E15TKQxsTK5dxS3YjQdmJ
         ySk8cWO/u+wZ4lBTLBahBQnF0LnT/BqhiQIMvIIZhr0/uvsfzcwWjTyr2QKNKVgDgd1B
         lo8qVnXsDpRqFFqdBylMjNAce4fQ2PQwXiN3OleYumiSl5onagcKJ1cokjzXWsjrQcTJ
         uo9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XNRt6/aITGiiV0hFDQpp/ZDiBu3MId5tidREj5NDK10=;
        b=AzZmNnntd/8p9HsGlivGMjNF7te3F8njm485wtKX9qJQtxuKNK8pWc+o4pO/UAP/eh
         BTXJ2sjuXsOS12LQToM3qBHpGGt1AqKR3wcb9A1PrrhPBZK8Qe9IbeIlOb/3Hnrp1lm6
         +ZTebTqCC+f0nZZUVUTvdZznGP9PW1C30vVH60rjaGFRYkiLSkJzBPYrT7wRqsn7IEo4
         uRO07M2lE51m8Ld/5m2UH+4/s3A71JwjcL18z9naNTdQiuxxBMPTUDX9IrXXMDA2jp2p
         00JnXXRmoGWI8u3mJ88W+SP5fUGr9E9hSltLfWRDPW5kHn48ltPsxySlcPCE6iJh0+se
         yMRw==
X-Gm-Message-State: AOAM530TRVJHbxY2rYucAfRPj5eKHW9VGOI4N72R0w5STq+2nR6g/BBJ
        RC0aFn1NeUPmmaYn8QC/QgWdNWnBBb4/yg==
X-Google-Smtp-Source: ABdhPJySqez4DEth4QgRxxaUznnAF5Mj073VqsIBfn8RIElToo3dhj0WMDxESh30D1vJYNlNrvRaWg==
X-Received: by 2002:a05:6a00:1818:b0:4ba:c287:a406 with SMTP id y24-20020a056a00181800b004bac287a406mr5652833pfa.6.1641923683622;
        Tue, 11 Jan 2022 09:54:43 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id f8sm23925pga.69.2022.01.11.09.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 09:54:43 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2-next 02/11] utils: add format attribute
Date:   Tue, 11 Jan 2022 09:54:29 -0800
Message-Id: <20220111175438.21901-3-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220111175438.21901-1-sthemmin@microsoft.com>
References: <20220111175438.21901-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>

One more format attribute needed to resolve clang warnings.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 include/utils.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/utils.h b/include/utils.h
index b6c468e9cc86..d644202cc529 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -261,7 +261,9 @@ int print_timestamp(FILE *fp);
 void print_nlmsg_timestamp(FILE *fp, const struct nlmsghdr *n);
 
 unsigned int print_name_and_link(const char *fmt,
-				 const char *name, struct rtattr *tb[]);
+				 const char *name, struct rtattr *tb[])
+	__attribute__((format(printf, 1, 0)));
+
 
 #define BIT(nr)                 (UINT64_C(1) << (nr))
 
-- 
2.30.2

