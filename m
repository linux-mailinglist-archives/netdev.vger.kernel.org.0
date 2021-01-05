Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3339A2EA933
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 11:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbhAEKuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 05:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728963AbhAEKue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 05:50:34 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CC6C061574;
        Tue,  5 Jan 2021 02:49:54 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id m23so27848629ioy.2;
        Tue, 05 Jan 2021 02:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=SZtcMCWcM95xhz6VJ/T22tr2CGPc3L3+n4XwdXE0LY0=;
        b=s2v2ZMxzMup1cuYJnmn0CA0lOVqCXNl5BAWRg2eT9bwWHKBr1btQQt1BA0e8EH+V1H
         Da4RTLOYxI71cGkPbJf9ak12/ByKw2hC7AQ3Q0XjU/v5i5cvz2w4ca9T7L26ykbqrSGA
         f8JfSm7xPHxGW8ZZzCRvNRoacUxZfUG10ZjYz+4cvrW4ZSyS6fOIsYhLGF0LKgmVRrbu
         TLdr2sbLOM5Db6p9xDKgOaPdwXOVQyhnnG3gqJDic6HHqbpTnm3+oVqEkHsfgWd+/ahl
         S3IyKLInDaM5V+CiO+MsNBvdDRXvf3q7cTCp7TIF4grmkOlqqaDYb+3sC9bqh0U3xdPk
         YjYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=SZtcMCWcM95xhz6VJ/T22tr2CGPc3L3+n4XwdXE0LY0=;
        b=CryLWh7HLMayPPN62zSxWzSCm0U32VW/knO0VOkBGO9Fmmi9sHCjaJ1FCuwoTKimnb
         c6IF6PWESKRbY5jYEbrMAIZ1J4wkPFxpTRUQ18wDCQ8EF78NfgzLAtB5L+MKlM9tAH++
         AhVMfF+0WSlyD3QlO9OrD+wspzDy7geHJoKCiGOUZUVR5/ltDzv+XKSEvUGDFjoTWDsr
         7SBna2XM6Ci6kEX3SEnu7zMWVUq5zA9v38T+/vx/+C8YwTvd+fbX1XA5NkKqSrbTTNbO
         YsKoa5jf4sEhlSHCyKmTHI11KKxAt/xnA8W2Mk+nrYbQk020sGJjynq8ZEovGFLORTnn
         Q6/Q==
X-Gm-Message-State: AOAM530UHcaeb2uBrL0xfgYgCQS7hwGrCs3T3Sgw6/xi79bODQGHiV+S
        iAfY1PJvtEuDEyg3koYgJn4=
X-Google-Smtp-Source: ABdhPJz5gLH+sxI4EXIVR4ivcK9M3BTj6+lM/tQw2CYLMrYCzUZRRdZpPauS9BFs0ZktrXUGkgshAw==
X-Received: by 2002:a5e:820c:: with SMTP id l12mr61678828iom.50.1609843793884;
        Tue, 05 Jan 2021 02:49:53 -0800 (PST)
Received: from Gentoo ([156.146.37.136])
        by smtp.gmail.com with ESMTPSA id a7sm43634349iln.0.2021.01.05.02.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 02:49:53 -0800 (PST)
Date:   Tue, 5 Jan 2021 16:20:02 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Julian Calaby <julian.calaby@gmail.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        baijiaju1990@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: wireless: rtlwifi: rtl8192ce: Fix construction
 of word rtl8192ce/trx.c
Message-ID: <X/REWkSdWaoXdLxA@Gentoo>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Julian Calaby <julian.calaby@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Larry Finger <Larry.Finger@lwfinger.net>, baijiaju1990@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <20210105102751.21237-1-unixbhaskar@gmail.com>
 <CAGRGNgWfHb=5jS_Dg0pKw7q_K9mkd8S2o70OCBEnWmaJY+5V9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EbciqnUOLbvDbSPl"
Content-Disposition: inline
In-Reply-To: <CAGRGNgWfHb=5jS_Dg0pKw7q_K9mkd8S2o70OCBEnWmaJY+5V9w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--EbciqnUOLbvDbSPl
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 21:34 Tue 05 Jan 2021, Julian Calaby wrote:
>Hi Bhaskar,
>
>On Tue, Jan 5, 2021 at 9:32 PM Bhaskar Chowdhury <unixbhaskar@gmail.com> wrote:
>>
>> s/defautly/de-faulty/p
>>
>> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
>> ---
>>  drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
>> index 4165175cf5c0..d53397e7eb2e 100644
>> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
>> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
>> @@ -671,7 +671,7 @@ bool rtl92ce_is_tx_desc_closed(struct ieee80211_hw *hw,
>>         u8 own = (u8)rtl92ce_get_desc(hw, entry, true, HW_DESC_OWN);
>>
>>         /*beacon packet will only use the first
>> -        *descriptor defautly,and the own may not
>> +        *descriptor de-faulty,and the own may not
>
>Same comments here as the previous patch:
>
>"de-faultly" makes less sense than "defaultly". This comment needs to
>be re-written by someone who knows what's going on here.
>
Again, it was written "defautly" ..which is a wrong spelling , it has got
nothing do with other thing.
>Thanks,
>
>--
>Julian Calaby
>
>Email: julian.calaby@gmail.com
>Profile: http://www.google.com/profiles/julian.calaby/

--EbciqnUOLbvDbSPl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl/0RFoACgkQsjqdtxFL
KRWrSAf7BOkYm/u93t//q7LmVGhbtZLS54NjoHN9u7mwJ7a41kKRkbJiWhHEFOwm
CaAgAV2sBGFDsFUi8EAxpBks8XclVqpMBvG6Kf5D/CjESQUCEJoJj2Mh2ct/h8I6
58z/7EamuuNo5A6se75m4d3KQ8wcQbaQMYZeTqcht46IvBK6SiUrrWAau1DFYWkZ
RplWJvnSGTwBVxgoJ9ORPVB0iE8bSUbFw6K7UtMy+BOfXq9fBtEB9bJBdcdvZ8iH
N9drl855n0NpwBeTZ2WMHo7CPYjOuulB+oBKLxEh3Th9cuqxzleGuCmnBbMG1G5n
YTBPSz7m9NcHZMwYdI9Wn6nXFHbY0A==
=znz5
-----END PGP SIGNATURE-----

--EbciqnUOLbvDbSPl--
