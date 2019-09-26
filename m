Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54B7EBF8F2
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 20:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbfIZSM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 14:12:26 -0400
Received: from mout.web.de ([212.227.15.14]:57493 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727944AbfIZSM0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 14:12:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1569521506;
        bh=xoKMDy6TPxmJvn8dQIo3SWVQLdurBya+ryEIo3zC7n0=;
        h=X-UI-Sender-Class:Cc:References:Subject:To:From:Date:In-Reply-To;
        b=Qt9XVWsVp0x/bk7xQjP58+qPqufrkTEd4IxvdRmVN0lIVvuh9o8s+qO1sfTuYSjKg
         xIp6OCQVpOIK4o/MhTUr9i/a0Ngsi3Q1SUnx1lNTnDNlDc8jF31MRMYlArEDjrQcsL
         9VFpXq67iKKkTbi3L2Azc6rkfhmi6baBBGlttEJs=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.81.241]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MPp0k-1iITvU1iQU-0052DX; Thu, 26
 Sep 2019 20:11:46 +0200
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
References: <20190925205858.30216-1-efremov@linux.com>
Subject: Re: rtlwifi: Remove excessive check in _rtl_ps_inactive_ps()
To:     Denis Efremov <efremov@linux.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <f99ca489-723c-0c2f-4241-e03c785a4a8d@web.de>
Date:   Thu, 26 Sep 2019 20:11:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20190925205858.30216-1-efremov@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:GNAjcmt2VkBpwn1IivuBbkFB2WNicyo6Jj8jytp6yFHTYVAo2mH
 0qBAtB2OLvyj7n1BgJMJpqtWzsotBJOI4tUoe5F0kkKgLwBaWWg9jcbbnb+tpULpeSoqLz3
 QJG376zu4dFkAzvYd9W67gaInbuaVDSO1FtlYQx20QqKNWXmelZMt38HZXDAlOUjKa/1a3Z
 VNX3f3gFC22eJHFdGM9LA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:xmELudbMPn4=:ghSyyEK4o2hwyjI42WuPfZ
 UkZkWeTk9jcdSSj1YkjikGRRdBJDQCIpmMUYYL7X4NypI6gtGu0ofI+O4S4UfBwsZO/qkRwcB
 S0dm8Pw15iQE+AH33TEdZIkZEyUDGzystyjy7wTRcfjfoNGMpteUwkt+qMSRIpMS8XpRm0WW+
 bRQwoRWHbcMlN0mSUMPaPOPKyvMc6bd3PO0qgvu4SW4Q85Q8RoECPlSDqSA8ReqXRU6/LS9iC
 d03IV7gn/aNwv9tHyQjJLL5vAtSdYT8Blzh1cnKrvt9G+0rakxyykmAyJ+hxQG3hqlYdPSSJ2
 zr5QHgZI/I6aovIRdi8AevSoFCryWcwl+O/b+iSKCU4mLWEAQMtOCAaEcKDRmhvrZK3xuurrY
 4gWN8AHE+CIHJeFXKNVxCFyCzSZuxN/pKBzNFs8aDZxgBVULFhVSgAYDKwpNqxbpohJxPIjDY
 h8PTIQb+JtV8+1sqi40gXRUvD+Dw514Vznpvb9niQcQ9BLrwq7QERnym3TNz+UDSiv0ZZHPSl
 LXf8Wcq5TmFJ8DrPRw/1EOd9WbrWNRkZiA66sNsHmbz3G+l5Zzpf67jnYYfHzF7G3atYQdIQc
 GTuCdSJc43U+wQmbGV5AfXA+UtgedTwfTyNE6/7QTI+/yHR/R18wJQQB1sWtHf7RSHz9eRYOE
 grLmNbFHxSuxBRJfyYyETTyT1CY3Fi1GYw8BgOuSFkiSotMmdGoVUyPN1WFBMH8LRoupKtyl1
 /0utMt9zYg7R8p8TwA0kpYl7hnozFclD2LSw5YxXdPvWgfNXoGJunn/QKqoUNCzmWWGNyM9C1
 ZTrTI36oHTcSITXlSGBlKwB14sMPB0/eKCSclbQDns9yi6H8qUyzDX3dlxGimBb3BPq2nat2H
 /ZpetaOByBYRA18pgMkgE8NhWNgF42HU+FlKQq4mCv0dKJ/kASD96LbuD/dc4liPUsdA7RY9j
 RrrCxNx0kliqkWeCbREfoPW3Vd17PGVR4upxSiGhWdaBH7q7YcnJDzfhgffv6008tbacN1eL1
 WeihM4ux+dybDSawyI2doHSJs7qbtn4sPAkMTjr3HYRNN1Z/voh3JjH5moxHe4ZVZrSEcalLd
 F1vgZy5LHLONufLNbCVk5GEip3ntETW7FilJfnpp3b1x/GWAY/7Qkda8u083Yp4dTAY9IfvCv
 R5sD5LS9sVnWukW6vhW/b3zC71u6ykJlhEzvCiOAM41xWVa6xLGsgk34sgQg1WLqjBfHoZkEB
 OmI3pyggw+U/dTekIxNDJOuyHI8y19GNqe7SWqpol1foI0pz/4y9hAgXswg0=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
> @@ -161,8 +161,7 @@  static void _rtl_ps_inactive_ps(struct ieee80211_hw *hw)
>  	if (ppsc->inactive_pwrstate == ERFON &&
>  	    rtlhal->interface == INTF_PCI) {
>  		if ((ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM) &&

Can it make sense to reduce the nesting level for these condition checks
besides the suggested deletion of duplicate source code?

Regards,
Markus
