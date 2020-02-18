Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B88B91632CF
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgBRUQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:16:23 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41041 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbgBRUQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 15:16:21 -0500
Received: by mail-wr1-f67.google.com with SMTP id c9so25556863wrw.8;
        Tue, 18 Feb 2020 12:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Tqaz/9DLBs3+nH7EgtfwmunyHz4zjguLxD6YwWDSNJs=;
        b=kq5AA06UofQtD8Gdaou1+OUTno9HRjrvVRFAwApSVbB5t/0XZDjBPtPTunl6agP6pu
         vYOWWtBr0bsczi5kgF2hlJFaAjHvgcrPAzkV1BwOlDSFfHTOOeP5dpQrG/uWBvV+NcPx
         1QL6ouPducEbrdueIVFW3b4uYqfhqu5Dwe0wrbC1JbDXjSnDoSm7LY7FB6M+w0VNEHGV
         k3/Kk0v9sSZbv6Alv4o0wy2aMuI/+Y/K8m0RbzONei86CizfbBl0zYii0FWBwHcSurtu
         sWHGDSmuMFLG5ir62q0J1tu34rXt1Iyf41mNdIoIYtwDWrzVLyWsiv7rvSYFHkpTt0OY
         PQSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tqaz/9DLBs3+nH7EgtfwmunyHz4zjguLxD6YwWDSNJs=;
        b=as/mFxEfWXdrZ/tj5lkUCYGpwJse9AvM6j2AtbESKPOrnK/ufMGAK3ki54FXEPsbLc
         00sOg+yQ2a4FB0SiRCdkE0rXFqp1C/FI0Z/qW1R+2tDZawiulLnRbZfmodJ/0DN9rEU7
         5RI1WovR3h0fCp/aAqrtZJusKzH0xo8vqL8LvbMXb+ahU6C03BX5iRnbMW/CX9b2bWro
         XFOI0Ypey7Y5u/7vLcxk+BqPqTwC2ZVQUmZQciCjo4pAvbseYhIams0yqNGVqIWWAo/5
         9kwh1Z9dSWySKrwlhFTj/MNIIkz8RNCTnnclzoPf7qt96zDgDBS08xVYWwk1ehbalkGt
         uzWQ==
X-Gm-Message-State: APjAAAUUqErbVWSvhSJLxeqCcBIVyYicAtJXlSLGog+8TiquJ6mLw7rB
        Rp1mFZzSF4XVfAv0PRfjjuvBLM5e
X-Google-Smtp-Source: APXvYqzV3Kloe53XiJ5XSgspfZ40NJJ07LzpFBcoGwxafx+rojb2gut3rzWf1rJ97/TUj/MmFFID2A==
X-Received: by 2002:a5d:438c:: with SMTP id i12mr30168536wrq.51.1582056977444;
        Tue, 18 Feb 2020 12:16:17 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:5cb0:582f:968:ec00? (p200300EA8F2960005CB0582F0968EC00.dip0.t-ipconnect.de. [2003:ea:8f29:6000:5cb0:582f:968:ec00])
        by smtp.googlemail.com with ESMTPSA id t187sm4979104wmt.25.2020.02.18.12.16.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 12:16:17 -0800 (PST)
Subject: [PATCH net-next v2 09/13] net: qcom/emac: use new helper
 tcp_v6_gso_csum_prep
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>, Timur Tabi <timur@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
Message-ID: <bb142033-18d9-e243-202c-59bc73cf85ca@gmail.com>
Date:   Tue, 18 Feb 2020 21:08:21 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new helper tcp_v6_gso_csum_prep in additional network drivers.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/qualcomm/emac/emac-mac.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/emac/emac-mac.c b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
index bebe38d74..251d4ac4a 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac-mac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
@@ -1288,11 +1288,8 @@ static int emac_tso_csum(struct emac_adapter *adpt,
 			memset(tpd, 0, sizeof(*tpd));
 			memset(&extra_tpd, 0, sizeof(extra_tpd));
 
-			ipv6_hdr(skb)->payload_len = 0;
-			tcp_hdr(skb)->check =
-				~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
-						 &ipv6_hdr(skb)->daddr,
-						 0, IPPROTO_TCP, 0);
+			tcp_v6_gso_csum_prep(skb);
+
 			TPD_PKT_LEN_SET(&extra_tpd, skb->len);
 			TPD_LSO_SET(&extra_tpd, 1);
 			TPD_LSOV_SET(&extra_tpd, 1);
-- 
2.25.1


