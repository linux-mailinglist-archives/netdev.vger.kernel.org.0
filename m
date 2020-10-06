Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5A22852EB
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 22:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbgJFUKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 16:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727208AbgJFUKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 16:10:09 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611ABC0613D2
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 13:10:09 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id a3so19473898ejy.11
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 13:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=U1LNP3VHSA1pU/Vo32I8UbLHtFi+8EjnDoznnO3hZbw=;
        b=jABCf4I3f6QeC8MbvXs6Ie6Me+K+qiXHhIe1o+Wn5UuiP8Yau3DYygTnnMGdmQuLAI
         V/BNyC8Ktvx9/Ye3/FYxXSLjNE6rO/P81y+Ynk3cl614daoJcs25tcvoWIvdPa6HTV7G
         Z1ZHc9cZ8tO8rRMVG2DrFOdJhM4nZPYYHlikjhJChVylnZGoqO6V5QPfLx/uV/NVu+9a
         wm2VklMND/8FjMwbs7iCfPTFYSZodmMjIMp/zVIJZY14L6G1MpxgD0MG7Olsx/X1ysJe
         EAiNSLKYhf6HtH1h3XYPkfiIECOsIl6U05upgsSsRFVG4keoMJOmhGUlUc4aOMC7HTw7
         qrSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=U1LNP3VHSA1pU/Vo32I8UbLHtFi+8EjnDoznnO3hZbw=;
        b=kZAkdAGESRv7BEaGuC5Kkpm6A8/txgZpezZ6vmnyDNfZNSHulZZ+6Ws8jQuS0sQAEt
         uT7SE+CqK8kLq6e1VkE8DsAxzRmB0fovma4hMEGriGUc5lebd9JrY/OKZ40gbJ6H1OFk
         qT4eR6XCpEySV3yRnkv9i9ifGrEj27dTYVg6s77Bs1IQwyDDI7YDH3aaqIJ5GzbGpepT
         CjQD3rQ6NNpUhZFDgaCPXiGatz7ziaABUI2GmXVkLeKQ4ch14Gc6SKM9EZFXSaX4jBNu
         7UKtr5KgjAmFTesMhVj97yb33WZumEUtBYiDWcYAXe9KOI1z/oAJaW4K7KryQuBYjoAY
         6lfw==
X-Gm-Message-State: AOAM533/Of/uRn5XRMGVnXzCa1RVUlp8/eywFaA5YQtiz6cJBImUHnoY
        I1Nji3svnxNbpkJ9Pqb8P62f3Qz7uqrVTg==
X-Google-Smtp-Source: ABdhPJxceORrkMEJuoZU1/A39Nw1YqBihCDrXAKB2W8z/aw3rfx5jT7QfczRXYc45mjwCSXdrx6JFw==
X-Received: by 2002:a17:906:e10e:: with SMTP id gj14mr1420287ejb.134.1602015007833;
        Tue, 06 Oct 2020 13:10:07 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:dc1a:256e:66bd:f0d1? (p200300ea8f006a00dc1a256e66bdf0d1.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:dc1a:256e:66bd:f0d1])
        by smtp.googlemail.com with ESMTPSA id bt16sm2849532ejb.89.2020.10.06.13.10.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2020 13:10:07 -0700 (PDT)
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH RFC] net: add helper eth_set_protocol
Message-ID: <027ab4c5-57e8-10b8-816a-17c783f82323@gmail.com>
Date:   Tue, 6 Oct 2020 22:10:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In all cases I've seen eth_type_trans() is used as in the new helper.
Biggest benefit is improved readability when replacing statements like
the following:
desc->skb->protocol = eth_type_trans(desc->skb, priv->dev);

Coccinelle tells me that using the new helper tree-wide would touch
313 files. Therefore I'd like to check for feedback before bothering
100+ maintainers.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/linux/etherdevice.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 2e5debc03..c7f89b1bf 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -64,6 +64,11 @@ static const u8 eth_reserved_addr_base[ETH_ALEN] __aligned(2) =
 { 0x01, 0x80, 0xc2, 0x00, 0x00, 0x00 };
 #define eth_stp_addr eth_reserved_addr_base
 
+static inline void eth_set_protocol(struct sk_buff *skb, struct net_device *dev)
+{
+	skb->protocol = eth_type_trans(skb, dev);
+}
+
 /**
  * is_link_local_ether_addr - Determine if given Ethernet address is link-local
  * @addr: Pointer to a six-byte array containing the Ethernet address
-- 
2.28.0

