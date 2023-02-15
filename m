Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDB3698801
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 23:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjBOWlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 17:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjBOWlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 17:41:18 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543E55B83
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 14:41:17 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id r9-20020a17090a2e8900b00233ba727724so4534280pjd.1
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 14:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UZFupiFq/4KrFzWRVb2kBs6eN4fR4fQR35ZoSgg2YLo=;
        b=H9IolviLahg+UekQXAEExIooMi5CIWRFTU2XQFZEiscWIdecTIS6q4rPm1IjGn2bHb
         0eLwvzEwtXX+oPynpDpbmTbYTOTatZ2FYokF3EBBT84M2zZvIaqDMLgUMs9g84Ye8L6X
         YFE5a1tUERoSv83IgwbRMrLHEzuh8ltuu2L6E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UZFupiFq/4KrFzWRVb2kBs6eN4fR4fQR35ZoSgg2YLo=;
        b=YLlLRDox8G7dnqyPVs1q120etxGNloQfGHCOCh5vOZ2JVUUnd/8TvddQ118i/hjUj2
         uQ/qc5Qoa9ewAYH4OIUP/6XwUY0pI9vYUEi1VL+HIo9YYkhUUm3j9bqjv9EIlNYaEyGu
         nQ847ZC7nf7aUacvNNl+KhRNOXrCIg1eQcCm+2vokMboDVzSdsc3a9hdij/Yzj/Rwp4D
         G2Ws1lgUAgLtSPJoVgMlLoLXjNcNrbMzle823WF+uQe/KQp3zu6br03PW/lTOFAJdJ1B
         T5RHDWDNfanwHCtbTT5dv1KEjotDgbZXUd/Cl3YwcBZanE16AZHGYP+OZBAxgpK3SHLi
         S+Iw==
X-Gm-Message-State: AO0yUKWY9v/KIiB7SadZlSVisUzVu6zSbXTZ+GqiEkfi8ozuQ7jY/vTJ
        VbpYHN0uIsQ8ilae4XTVyOmK4Q==
X-Google-Smtp-Source: AK7set+ESHLvLprT78VX57LGMFVGWa5ezLj0nQ6OjMNOjQARTMpt90pjNQIEkK59KR3uXsgXZDzF5w==
X-Received: by 2002:a17:903:11c6:b0:19a:7ef5:4c98 with SMTP id q6-20020a17090311c600b0019a7ef54c98mr4811187plh.2.1676500876782;
        Wed, 15 Feb 2023 14:41:16 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id p11-20020a170902a40b00b0019460ac7c6asm12547885plq.283.2023.02.15.14.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 14:41:16 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Arend van Spriel <aspriel@gmail.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Colin Ian King <colin.i.king@gmail.com>,
        Brian Henriquez <brian.henriquez@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] wifi: brcmfmac: p2p: Introduce generic flexible array frame member
Date:   Wed, 15 Feb 2023 14:41:14 -0800
Message-Id: <20230215224110.never.022-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2984; h=from:subject:message-id; bh=NH05WGlz+NfU8MmAO7fhDCoD/bk5xcg8PiXevXOGYSQ=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBj7V+KSkepxl6m0w6HQmTbuhMT6gFMTrKHHEn1r560 zilCZCGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY+1figAKCRCJcvTf3G3AJlg6D/ 9qMIaHwoHnLx1HJ4KX7Nv5fk/N7aOg/N9My3M1Wz1uzob6c6m1wNf8ByQ233hu0dvdVGkcuou6PDGZ XqeqxOOKQJ+sJcE+md+OPHeYzuQl5dZ+DgPE623iyEDeCxSrxBWgN62zF2o1OPrxWYIpT+ggxyItoq h2Nve+50UFQV1kk5Lco1P5dkNmPNUnbxZj3OFO03dgb379EkMrRy5/e1I7PaPV5QqLKCfwFbQ0Ak56 +3XQvas7yA0vXG5FmXOg4LOliAB8mNpxbSt2BBKUt34yUw8KH4nAogrqtk+VqKfHR+NvXHN9Bppy8T EaMNN0FnfYujqSpVcvlnrrj8yzaINe+I019+ct+FO76MniG5GL51c9bwnGl7jkdl4HcfygL9ZQTKs2 U0GqvMxtzZNTxVTaxgVxG3HK5Ejk0mmsEZMsggjrLlv1nN8W6tylgLay3VCJi3OpwoJsHRKPNN8RzT Mxd85Tah3an4b7Y9SNsKN0kwivhsWHVbuSsZXoVkwkYeciFom7QfqXu5TkHPnOvXUE1bw1YMgHAnyc HgyzyE59M1BvyYRX9LFFr8EHhHyV4pzQKjKxmLWEmPzvZqn96itCaD5FGQYAoj3sO/9CeslfAEigth i8O+/02BUNLmAExMGZFGPTCc2m2cDuo/7EGQ3FapqrmMPbQoFpFsFpK97+jA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Silence run-time memcpy() false positive warning when processing
management frames:

  memcpy: detected field-spanning write (size 27) of single field "&mgmt_frame->u" at drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:1469 (size 26)

Due to this (soon to be fixed) GCC bug[1], FORTIFY_SOURCE (via
__builtin_dynamic_object_size) doesn't recognize that the union may end
with a flexible array, and returns "26" (the fixed size of the union),
rather than the remaining size of the allocation. Add an explicit
flexible array member and set it as the destination here, so that we
get the correct coverage for the memcpy().

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=101832

Reported-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Arend van Spriel <aspriel@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Brian Henriquez <brian.henriquez@cypress.com>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: SHA-cyfmac-dev-list@infineon.com
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 4 ++--
 include/linux/ieee80211.h                              | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index e975d10e6009..4d0db7107e65 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -1466,8 +1466,8 @@ int brcmf_p2p_notify_action_frame_rx(struct brcmf_if *ifp,
 			       ETH_ALEN);
 	memcpy(mgmt_frame->sa, e->addr, ETH_ALEN);
 	mgmt_frame->frame_control = cpu_to_le16(IEEE80211_STYPE_ACTION);
-	memcpy(&mgmt_frame->u, frame, mgmt_frame_len);
-	mgmt_frame_len += offsetof(struct ieee80211_mgmt, u);
+	memcpy(mgmt_frame->u.frame, frame, mgmt_frame_len);
+	mgmt_frame_len += offsetof(struct ieee80211_mgmt, u.frame);
 
 	freq = ieee80211_channel_to_frequency(ch.control_ch_num,
 					      ch.band == BRCMU_CHAN_BAND_2G ?
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 80d6308dea06..990d204d918a 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1356,6 +1356,7 @@ struct ieee80211_mgmt {
 				} __packed wnm_timing_msr;
 			} u;
 		} __packed action;
+		DECLARE_FLEX_ARRAY(u8, frame); /* Generic frame contents. */
 	} u;
 } __packed __aligned(2);
 
-- 
2.34.1

