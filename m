Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD101B617C
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 19:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbgDWRAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 13:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729674AbgDWRAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 13:00:19 -0400
X-Greylist: delayed 426 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Apr 2020 10:00:19 PDT
Received: from relay2.marples.name (relay2.marples.name [IPv6:2a00:da00:1800:80d6::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB2CC09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 10:00:19 -0700 (PDT)
Received: from mail.marples.name (cpc115040-bour7-2-0-cust370.15-1.cable.virginm.net [81.108.15.115])
        by relay2.marples.name (Postfix) with ESMTPS id 4F88B7E5
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 16:53:12 +0000 (UTC)
Received: from [10.73.0.30] (uberpc.marples.name [10.73.0.30])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        by mail.marples.name (Postfix) with ESMTPSA id 491CF45F4
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 17:53:09 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marples.name;
        s=mail; t=1587660789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=yKLrOljADJd251/sjY/sg9T0uYP7Yoc26fkVr1L8qFc=;
        b=hUFRELrInW/JhPrYTAhW/uvv2UDC947ifg0JtlUkvdWzIEEQ1nlTJFa0w6n3QjAGwNl/DS
        rmcp41+DIUu8rVhqNl3zkqsB76cnwgIl+33NFa60Fto0wt4XCVdeNMNOL0ivLVXb7kz2PJ
        xihENsrRHjXgwiqItk/yRqYdoVHm368=
From:   Roy Marples <roy@marples.name>
To:     netdev@vger.kernel.org
Subject: [PATCH net] netlink: Align NLA_ALIGNTO with the other ALIGNTO macros
Message-ID: <f8725c2b-635f-1da9-d2f6-4f34777b194a@marples.name>
Date:   Thu, 23 Apr 2020 17:53:08 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This avoids sign conversion errors.

Signed-off-by: Roy Marples <roy@marples.name>

diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index 0a4d73317759..c9ed05f14005 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -227,7 +227,7 @@ struct nlattr {
   #define NLA_F_NET_BYTEORDER    (1 << 14)
   #define NLA_TYPE_MASK          ~(NLA_F_NESTED | NLA_F_NET_BYTEORDER)

-#define NLA_ALIGNTO            4
+#define NLA_ALIGNTO            4U
   #define NLA_ALIGN(len)         (((len) + NLA_ALIGNTO - 1) & ~(NLA_ALIGNTO - 1))
   #define NLA_HDRLEN             ((int) NLA_ALIGN(sizeof(struct nlattr)))
