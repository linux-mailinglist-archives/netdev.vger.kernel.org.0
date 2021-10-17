Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50084308A6
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 14:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245643AbhJQMa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 08:30:56 -0400
Received: from mout.gmx.net ([212.227.15.15]:49225 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245634AbhJQMa4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Oct 2021 08:30:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1634473696;
        bh=cbmUGzU1hyhfVw27QCJZ4UFCSB3owM8yg3KH4pv2Meo=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=FgQF1bnMfZpqiLiWcwmo4tKY92EvGGpLSrDNF8O8Pl2Ok7TFaQFmXtHPkpiNnWcTb
         +kVIye22YcImxnUMoO/R3nPQLDOuma5QAVqihArxeVkZUN0TWSjXk0iN1w4FOmzGg3
         aVQFHOxFlgTm/24TudrTjM59RMRGfTkjOhDal5YA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [157.180.225.22] ([157.180.225.22]) by web-mail.gmx.net
 (3c-app-gmx-bs33.server.lan [172.19.170.85]) (via HTTP); Sun, 17 Oct 2021
 14:28:16 +0200
MIME-Version: 1.0
Message-ID: <trinity-b64203a5-8e23-4d1c-afd1-a29afa69f8f6-1634473696601@3c-app-gmx-bs33>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Nick <vincent@systemli.org>, Kalle Valo <kvalo@codeaurora.org>,
        nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        sean.wang@mediatek.com, shayne.chen@mediatek.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Foss <robert.foss@linaro.org>
Subject: Aw: Re: [RFC v2] mt76: mt7615: mt7622: fix ibss and meshpoint
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 17 Oct 2021 14:28:16 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <YWGXiExg1uBIFr2c@makrotopia.org>
References: <20211007225725.2615-1-vincent@systemli.org>
 <87czoe61kh.fsf@codeaurora.org>
 <274013cd-29e4-9202-423b-bd2b2222d6b8@systemli.org>
 <YWGXiExg1uBIFr2c@makrotopia.org>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:fyBM2xVbitALniHvauTUD7yrO0uOEc4mCU0F1K23UQXJGTTN449orREFI7R6/jIwk2Gfz
 +/t5YHtCN79gYYBepZq88+TxCl9EOmLon24tVUZtoEA+yhKSKkYwyZfIMvm4BmHiBOooqXdvcPkN
 2tiEOmsT8A75bnUmNG3cwMe2lVBuOhH9OQ96pnvWguNt1I8QU8ooFGKgHp7PWQok+ckMlwWMpQnU
 DCRkLgt6buZvFOvW9LKpt8RMxF+gVj07Jt+pnBeV6TmBIIY5cOfKzjCvRfR697xToQ48ZFR4+kSg
 Ec=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:uRD9Evc6puo=:G4Jl5nlDqhYHEAGiTmwbT9
 B4HxHhEQJFhMTmBBoc65QLaRQ+84jKSXRdt59yACNSSbcCvyyGLvnrwSeO2xVx5jBnmJn/eMM
 z5HhMUlK4WpOrvAoD5QdWjiNvEiZrPiWfGk7WOXa+BDfgAP9dBZzeXQNRptwumLi1LDGEY0+3
 Q3jjuyfFqb4wN/PWx36xsnYAKK66Z7KL4z1nOmkhWc1UXcetmdrWzsYIb3h4YrWSPIC9gk+DP
 c4hILA67s3n35PnK2nQJkCHwqGB4ngTOQZBfSDAJXxxvghncAfXIAohXT+9pLtrgj2o4+MSCo
 VBJO8EtTsIMhJ/z6R1HxiHVOyi2RSGKvdY+fAQ5Y5Ptnb5R2pzM56i5wmIITBA+BPWtrsN0ei
 1ZM+BPGhBZTsWFGii7Q5KOVsFm/KiNtwC4FpLXyRhhzEXADby7Wll0Iaorhx/AiY4xeF/7oIQ
 DuEOOSsnV5vltv7sEUCB00SIPWnSske6NpOh9hxMS150uB75Uy10lSVUddwQbWvC2IrZ4RkiE
 BRrlxcKZmA5IWfHBU8/4iMAFz2nLGmL4ySQ+0B0CC9xN521KUMjlFkGTxalvCq9mZ2b9muquX
 wsL7buDtbeD4iQVs8khWkueC1UyJMRmyL+wPVPsbQbvR2skb+cADRMI269FjG/+AUjmjox6aC
 EuTLt25a8zAvN1KGXCcEn/6StV8u8DB236SL04zPCNRwkhKrD/x5laTLaKYGcJUATGoIF/LKI
 xAzkrGay/GV/iFmBg9w26NP8IX8TfSCwKUKtp3iUHVI3b+wwpFXAX605EOdKFmo4FXPWTcEEs
 4X+LBRj
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Samstag, 09. Oktober 2021 um 15:22 Uhr
> Von: "Daniel Golle" <daniel@makrotopia.org>

> Does Mesh+AP or Ad-Hoc+AP also work on MT7622 and does it still work on
> MT7615E card with your patch applied?

tested bananapi-r2 with mt7615 and bananapi-r64 with internal mt7622-wmac

ibss/ad-hoc: working
AP-Mode: still working

regards Frank
