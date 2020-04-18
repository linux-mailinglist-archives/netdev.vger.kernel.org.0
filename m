Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEFD1AF50C
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 23:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgDRVF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 17:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgDRVF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 17:05:59 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96752C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:05:58 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id d17so7221717wrg.11
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=hKjB/TY2GNbxl//FV2GKwwcrPmqBSsqhxbQy2fj639U=;
        b=uik0ZHBetWD7ClvJSv+u9CSz2rMlAiFFrR77oMH4mzEbnhshOFAvWzszF1ju1ryyT9
         3XN03UslnC6wn6Q7PrT0DMtX1NtgXuzykEImQEmSjPngU8B/U5w8A2n2/nb+VdFVtAcX
         YuYuBNEnqRwIdWOxQjo44pQKiCLAMe3e5lmXtvJTQAnJ9Zit1dVQnd3HQG9sWOAng+m0
         NRcJPZTwtWcw80Xd5RF1Ql7Q2A0jqzQuuNGTmNqvsmR2x9CvyLkn5GpgVnLyQd+OxYZ9
         qsYLS4CCYjSgSz/V3wA1zYSeL99nTfhd/3TyiYhmjf7hrL0w54rPFcgD0O9XZLAlWFkp
         t/+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=hKjB/TY2GNbxl//FV2GKwwcrPmqBSsqhxbQy2fj639U=;
        b=GdAcesWaafRMkYPsiV8BLS2qdr9tk6bq1s9+/5tubTy1LypgSpXnuvr6dtAp179Hdk
         JMnlMZcAqt/GonxQhowxV2qTNHkm95SDHbGIQUbE1tYEDM0IRExGWOCnTpghyMIUyLmT
         PSHOi1BMDEwqEja9e/Ver/fRD3CRembQaeksPadxPLbtq3yKWFshKdy9inMj/mrf9Y4S
         AecYjWxuw1BznrV/TxCRjFVh+i++F30BogDqprWHOnjnAKymzhyH246ZiDvI7jSPtrmR
         fPmUZp4AO5jXgBTLaf/jz0pMNDpjOvBRBvnw+JI1G94rMDThf6djZsH4tJ5SsJ77+WEF
         mvCw==
X-Gm-Message-State: AGi0Puav0lyNtnBHH2AqazNFMUI14q6Lok9mlS6LERD4QES2XJJjNLbu
        xXQrOjgvHLcQSHgT2eCASEGyvGtw
X-Google-Smtp-Source: APiQypJltOkY8aJbd+pLa5DYoBr95u1Tb3HjvTRlNSxmpojXogHqvnWO7bjblQT62LzOtvR2cvKBXA==
X-Received: by 2002:a5d:498d:: with SMTP id r13mr11053656wrq.374.1587243957156;
        Sat, 18 Apr 2020 14:05:57 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:939:e10c:14c5:fe9f? (p200300EA8F2960000939E10C14C5FE9F.dip0.t-ipconnect.de. [2003:ea:8f29:6000:939:e10c:14c5:fe9f])
        by smtp.googlemail.com with ESMTPSA id t20sm11450244wmi.2.2020.04.18.14.05.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 14:05:56 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/6] r8169: series with improvements
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <f7c53dc0-768c-7eb9-ffc0-b2e39b1ddfa4@gmail.com>
Date:   Sat, 18 Apr 2020 23:05:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Again a series with few improvements.

Heiner Kallweit (6):
  r8169: move setting OCP base to generic init code
  r8169: remove NETIF_F_HIGHDMA from vlan_features
  r8169: preserve VLAN setting on RTL8125 in rtl_init_rxcfg
  r8169: use rtl8169_set_features in rtl8169_init_one
  r8169: improve rtl8169_tso_csum_v2
  r8169: add workaround for RTL8168evl TSO hw issues

 drivers/net/ethernet/realtek/r8169_main.c | 75 +++++++++++++++--------
 1 file changed, 51 insertions(+), 24 deletions(-)

-- 
2.26.1

