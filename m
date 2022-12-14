Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 908D864CF7B
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 19:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238528AbiLNSgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 13:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbiLNSgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 13:36:05 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E82DF26;
        Wed, 14 Dec 2022 10:36:01 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 79so2554911pgf.11;
        Wed, 14 Dec 2022 10:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=soAwEUNUP/nDdMk1tXKi47w1Woy9jZA1B7hD1tT2IFU=;
        b=ENEQrMhCmMvxlj4Xz8fMhvwLCYmwV5cAqV9BEeCR2AHyCNFY3MpY6JebttMmRzOL2E
         XMr3O3g9/TWYhnpgBnlxqcKUNvzjut06q3Sx2rO20FKQRbVj6gmm/+QOrbx2u7D5B4xl
         q8Z/qVaiMiRmmqu+5smAhDMIWkgG4FG53OanL/Xtyeod0aebYN+bSAgbdXI0tIV8pfYa
         piNl97QZo89pZj5udMAqW7BMl2Sh4OaF85nH0IY0zD29XMYsHTyKSorUwxWXK3IPTDYc
         RNdr2XqWIQf08J6DHDIqcCrzg/z/BaLBAlS43zn81a5KYCgS/epwXcmfvvjoFy3/CYQ2
         mLoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=soAwEUNUP/nDdMk1tXKi47w1Woy9jZA1B7hD1tT2IFU=;
        b=xiW6OMLVITNzENJSLZttuSW2jzMtAQONcSEJw3YtunZt6YZ4NltkMf0+trxUx2QpcN
         izReYgCFhDKiccKRaBLpNH/OMsiGRb4PhvpGdApzWHsKd0LhHOtGeDrJR1Zq7uHa1nfC
         jzka3fZVBsHIWuW6rsMPmjI74Lh3xhRPbo+s+mMfVeXDGjYK8BSTKHvuDDEXP3cJIxI7
         p3QTUDqQKN3gafl8pq/EW4yLlFGSbAsXXvqO1pHDIpO7gVss5bp87yCepRVSk7Gum2yG
         b53xP57xet3yNmDvOqkl0HnEt8aMtT4JnM27PZEd+K/nEMYpWglB79mPHDnWdtKto/Ap
         +m2g==
X-Gm-Message-State: ANoB5pmi+J8giXkhXT3NnnT2jV4Otse6SFdX+J4mmb7CpWmWk6eWEWIZ
        /O6JTWCx5rAT1XtssWgxPFg=
X-Google-Smtp-Source: AA0mqf5xtQRfuRR9aoG/416uv6Fce0kcE4nzbDdXDrfpSfLgS2fIljRdPRBkm04C6TRhEzMayDm/sg==
X-Received: by 2002:a62:5fc1:0:b0:566:900d:4667 with SMTP id t184-20020a625fc1000000b00566900d4667mr26303537pfb.1.1671042961158;
        Wed, 14 Dec 2022 10:36:01 -0800 (PST)
Received: from [192.168.0.128] ([98.97.42.38])
        by smtp.googlemail.com with ESMTPSA id y184-20020a6264c1000000b00575acb243besm215068pfb.1.2022.12.14.10.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 10:36:00 -0800 (PST)
Message-ID: <5841f9021baf856c26fb27ac1d75fc1e29d3e044.camel@gmail.com>
Subject: Re: [PATCH] nfc: st-nci: array index overflow in st_nci_se_get_bwi()
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Aleksandr Burakov <a.burakov@rosalinux.ru>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Date:   Wed, 14 Dec 2022 10:35:59 -0800
In-Reply-To: <20221213141228.101786-1-a.burakov@rosalinux.ru>
References: <20221213141228.101786-1-a.burakov@rosalinux.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-12-13 at 09:12 -0500, Aleksandr Burakov wrote:
> Index of info->se_info.atr can be overflow due to unchecked increment
> in the loop "for". The patch checks the value of current array index
> and doesn't permit increment in case of the index is equal to
> ST_NCI_ESE_MAX_LENGTH - 1.
>=20
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>=20
> Fixes: ed06aeefdac3 ("nfc: st-nci: Rename st21nfcb to st-nci")
> Signed-off-by: Aleksandr Burakov <a.burakov@rosalinux.ru>
> ---
>  drivers/nfc/st-nci/se.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
> index ec87dd21e054..ff8ac1784880 100644
> --- a/drivers/nfc/st-nci/se.c
> +++ b/drivers/nfc/st-nci/se.c
> @@ -119,10 +119,11 @@ static u8 st_nci_se_get_bwi(struct nci_dev *ndev)
>  	/* Bits 8 to 5 of the first TB for T=3D1 encode BWI from zero to nine *=
/
>  	for (i =3D 1; i < ST_NCI_ESE_MAX_LENGTH; i++) {
>  		td =3D ST_NCI_ATR_GET_Y_FROM_TD(info->se_info.atr[i]);
> -		if (ST_NCI_ATR_TA_PRESENT(td))
> +		if (ST_NCI_ATR_TA_PRESENT(td) && i < ST_NCI_ESE_MAX_LENGTH - 1)
>  			i++;
>  		if (ST_NCI_ATR_TB_PRESENT(td)) {
> -			i++;
> +			if (i < ST_NCI_ESE_MAX_LENGTH - 1)
> +				i++;
>  			return info->se_info.atr[i] >> 4;
>  		}
>  	}

Rather than adding 2 checks you could do this all with one check.
Basically you would just need to replace:
  if (ST_NCI_ATR_TB_PRESENT(td)) {
	i++;

with:
  if (ST_NCI_ATR_TB_PRESENT(td) && ++i < ST_NCI_ESE_MAX_LENGTH)

Basically it is fine to increment "i" as long as it isn't being used as
an index so just restricting the last access so that we don't
dereference using it as an index should be enough.
