Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C789225D1A
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 13:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgGTLIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 07:08:30 -0400
Received: from mout.web.de ([212.227.15.14]:48313 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728232AbgGTLI3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 07:08:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1595243283;
        bh=Q071kHn/GTdg5P4ECeuR4fberT8mGKMiw5YflYY/rHQ=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=jVNdRU4iAM6Hgho/CfUzsr4g+w3TJgsAXV0TEpkbweQlIMmfokhiKp+2uslhNwJdw
         p7vFDJePdjQAqhLWStExvqAtaYrnLTXvIH9+hSP5hO7UFlP/U5EVJYyCl5l9z6swhK
         EtBehPRhVNIxXY2qpB+5THdjEA+B/+RyUe4fhpkg=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.85.87]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N9cLR-1krJtm04vN-015WDV; Mon, 20
 Jul 2020 13:08:03 +0200
To:     Wang Yufen <wangyufen@huawei.com>, brcm80211-dev-list@cypress.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Franky Lin <franky.lin@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Wright Feng <wright.feng@cypress.com>
Subject: Re: [PATCH] ath11k: Fix memory leak in ath11k_qmi_init_service()
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <9379ef46-5931-5542-c424-916bb8476a92@web.de>
Date:   Mon, 20 Jul 2020 13:07:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tHAZkInxJsSb+GbOwGxy2BBe9SNLS7dLnYVRXCXzFDN+p26s0y6
 jEymdAQ/9ZJdBMIPNrskPhte1GwZWTZLuHnHdO99OG6CY22jp1R2xkOLM8OO68ZZokfvKmb
 j/mosDs81s3QQtMxPsEMmCpbhcnG/9eAveG4NDcoeAi6fK8ZS/5pAh1WKj3z7t1nFSG3sDg
 wIMDHkDHPnyIJ4N2xUaog==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:o9t0GH/x8bk=:69QkQAnU2p5BZ9LD/b2qP7
 CsgKogz9DBnbgNpHFXl3iV0jLnlPeQNLnPdSJz51Xegzsv30mrWaKUyauo6x91671x8v/lTaC
 0ERo8U858Kd6C/KXil3X00UIdCoRc8rKm+zb/TNp8kEAqRxhQnPA1ivJz7Htn6Po6s/m6YCVI
 RYPzodjmBnUcp1EbkOAniAtDd37dMoXuFmLFM6CGAQrRTalAwvSgup4v94q3HGL4WbzN/b97N
 Oo43R6DTMpSE7J27Y5PD4XNr0ZAt44iEB5Gim3WEYf7maVZ4/1LVpcmxbAHkK34sLqnSwaurV
 f0rM+zM0SmRykM+FTe/wnzL5kba36La7sgXOAnX88gdHTQdX+6JTwU2HAx5m5YnqAxdOIEos4
 WoTvCQHi7JHq+5G+iMIFH2M01nkFvRzcnJ8pVijSSkjUj3R7nw8AQpNi87ZEdRX+YasTPiFIT
 kmd9fftYworbDqQcERzWSPWCYMdtmvrGCuRyKD58FVK26SKVScofmCvz0csVhFLDc7jOe4fEe
 ZEijPa1BUltaBG3oOPWY0+TdHpUHTMN+uIuaIVa0b761cTyzLrGZEN0x2Vlf0CyYDk7bolJyg
 JnMKYdAoPAOtrnv2TpkUsi4stEVtb+E/nfYHDsw1WpMZ7GVGe907QAwDWR4DwskzyE8XfoMSX
 2Z2sxonxPOIzJG14t3ChIc5MXzbMkfO95vOanHTW6iE0YtspM4flLCmPH/VepVbRCvsOmxmAT
 epErrxz7sW6NetwCXH+Z9MEzseOLRM3CPfRs1gSLsAnQEbriXnHTQYEoBMEwVkGYYkcV3LbKb
 jrbFqEXFprdXOZVa4Gbwx271nJ9EYjI5tvP3x7cZo5CpY49XJkZg+tHfQqAvcAf57iBlHeJhj
 W1KSKHeE6Pen3T+bGwHrBOSIB+UDq9UEyORs9TysWM3R8Tekj9MdoMMrzmkWBIkH0XSBXb6sj
 YZA0ZLqA2wlehy3f/9dtpSMPpd1CFIxE1ES+nhCDR6oREtkW/KByVAHk/mySk+l93Vi78zdX+
 KYqdiEreHeIBACmoyMz2EMLcQtNtgxDFVQGe2Yp7tTE9b4RmmrDT9coYTqbNMkPTDbuf+9JUJ
 8PdEdGSKEmDaZSM2k2WtmhUlL+xCNPBmK3I83pffR+ppt0c8wgr2u4H6F7RWt2jfJokrLGM8V
 /YylMkuNv2KyV78xYH6K8NFg0V+EqnSO/qDpARBXbjL3tS/eUcL+7Wdwbrc8tva/nYnFpPMF1
 ygoQT2D1zAeYP5KOikPz9PbBe7J/oWEe937oAFA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> When qmi_add_lookup fail, we should destroy the workqueue

Can the following wording variant be nicer for the change description?

   Destroy the work queue object in an if branch
   after a call of the function =E2=80=9Cqmi_add_lookup=E2=80=9D failed.

Regards,
Markus
