Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F434F82D3
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 17:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344636AbiDGP0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 11:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344624AbiDGP0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 11:26:51 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBB7217998
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 08:24:44 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id d29so8339766wra.10
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 08:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=i9UnM1jI36UJQSwNcT9S3fjmamsXy5kuN/3o31cSk0s=;
        b=p23UKOUTNyiaqmDzp1F7Eoypbg9uujL44gyzm6C0pf7IUaSDIlpPXWHIbF+dMAQpZo
         jQQGSHj32VYdUNKjUKc5QcMxBtQmn9Q2uETnmwhTeQvk9s1nOaSeF54fRz33COTq481P
         84azdd6l8J5AbNA1fN1/LIp1e/3HL4vLsnWssEawhLOEMqIb5wKDbLFI8CuK9mrG0mBF
         mSKTG1FkS4gu036Ot9Nlg0C7AvvvZ8Ovk7bt/8BQ3wUkdZeT2Uf72WKTqfEbCUAt0I4F
         BT6WqRkFXS1gnVbvE9WJ0uOyalSEteh2lxMGqva1LGuth5t73EK/alhUa65C7GYsjO/+
         E0eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=i9UnM1jI36UJQSwNcT9S3fjmamsXy5kuN/3o31cSk0s=;
        b=u3+ONFiyYiE+6JH4rs6vuKozHv6J8MdMgESi18IfFNYtEQLpy8SZz2iklaQr5WaNmf
         LhpkW7xXU1152evBfKi+NaqXPPKp897DhkV4d6qcbi16SLZuXJuAC8FIaP6Ky5fgyxsw
         z7Ul83Ff9XJ9VomU5MgaXtQxc14mICyxNpKYceV1wPMhG6Z3Fh8cfc57zwr5C50pAlIS
         QU44DK43lKFlUNfZ53d18Pcjqe1BRfp0qUnsXR8lT3QNPQ5CURcuj3/TR4N5lupabzUy
         LyYSZ4/tUUk/FUOn3muH+N2qjWvUferSfH+N/1OJ1iFdyi2w67FRO1o3BbkvX+EIevlQ
         56RQ==
X-Gm-Message-State: AOAM530Ui9Tft8O5JDtB6E8JYUsigRcXwtb2l9DXxHnRBQqaFysOKSPt
        ye1S4obtl8+TBqrymEJYECk=
X-Google-Smtp-Source: ABdhPJzyFFIjoSANuFnYc07A2TKmWIv+Sfa3y+A8HAiVcXO7UHjjWicl8zc3TNdx7jcmSAm9L8tWDw==
X-Received: by 2002:a05:6000:2aa:b0:206:1862:f841 with SMTP id l10-20020a05600002aa00b002061862f841mr11381242wry.304.1649345076356;
        Thu, 07 Apr 2022 08:24:36 -0700 (PDT)
Received: from [10.108.8.172] ([149.199.80.128])
        by smtp.gmail.com with ESMTPSA id j3-20020adfd203000000b0020616cddfd5sm9114068wrh.7.2022.04.07.08.24.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 08:24:35 -0700 (PDT)
Message-ID: <510652dc-54b4-0e11-657e-e37ee3ca26a9@gmail.com>
Date:   Thu, 7 Apr 2022 16:24:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-GB
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, habetsm.xilinx@gmail.com,
        ihuguet@redhat.com
From:   Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next] sfc: use hardware tx timestamps for more than PTP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bert Kenward <bkenward@solarflare.com>

The 8000 series and newer NICs all get hardware timestamps from the MAC
 and can provide timestamps on a normal TX queue, rather than via a slow
 path through the MC. As such we can use this path for any packet where a
 hardware timestamp is requested.
This also enables support for PTP over transports other than IPv4+UDP.

Signed-off-by: Bert Kenward <bkenward@solarflare.com>
Signed-off-by: Edward Cree <ecree@xilinx.com>
---
 drivers/net/ethernet/sfc/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index d16e031e95f4..35240eb6e903 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -524,7 +524,8 @@ netdev_tx_t efx_hard_start_xmit(struct sk_buff *skb,
 
 	/* PTP "event" packet */
 	if (unlikely(efx_xmit_with_hwtstamp(skb)) &&
-	    unlikely(efx_ptp_is_ptp_tx(efx, skb))) {
+	    ((efx_ptp_use_mac_tx_timestamps(efx) && efx->ptp_data) ||
+	    unlikely(efx_ptp_is_ptp_tx(efx, skb)))) {
 		/* There may be existing transmits on the channel that are
 		 * waiting for this packet to trigger the doorbell write.
 		 * We need to send the packets at this point.
