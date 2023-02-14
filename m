Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF2969605B
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 11:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbjBNKIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 05:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbjBNKI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 05:08:29 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6092310B
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 02:08:04 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id r9-20020a17090a2e8900b00233ba727724so1042198pjd.1
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 02:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=in-reply-to:from:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=1ipTSVcuZ1cwNOu80agNHKQFdpvEfbgsK01ztJtXzH4=;
        b=alZdjRPN0T533YhstF5fzNgCNLhHIbdtRCJcKprq7PKIHrTEfPFSOVVANzYX1UCrYh
         7WUsCiVp3LFe/YJq9kOhNYRuRGyj/uj/1wqGIuKHm0c08TIm4sZniMP0eEuq3WkfJl1f
         ITIYZ2+Hu3u06+auPdT6R4dZXE/M76JX3CSKk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:from:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ipTSVcuZ1cwNOu80agNHKQFdpvEfbgsK01ztJtXzH4=;
        b=yK+YH3VPGKWvBIQmV42ModQsLipjQz4HxNVaqDwAB3AbKEDBwq5rMAKvKBTtrR1MeT
         l88hrM+1p6Z6/ge9R7zP1YUbCBx66ZHeoY8bXGZjAI9sFLwguD1UZSnJKe5wEKriEkvz
         Ekm4EksQI2EYLq9wOZS7Nzw7m3+/sCSbzJ0ew8cKKBSDWbEaxCUMVXguo7Zr0CdeZHR7
         JWfLgV2kWnsVu6a26z8gV42ZCtsFvJ25QZ4xoGwmhHrkXi+L38imOkeRzd6xy6/CgsI1
         Q9UotbZiIHaNZQuP/xUq2c/0L7v9LwMMNv4wChZ+DOIvHcLV3Kr47aRvBr2Y4aJyIwgG
         8C+Q==
X-Gm-Message-State: AO0yUKUB6x2vnDsulWcJxaPmcC/dc+FUC8FU/Jkq/JSUzmCxAPDlTymw
        rg9uedlRKDNwqzE+dAcxTYdWuA==
X-Google-Smtp-Source: AK7set9JywPOnggdXTn0yp81dKrSXy+5NJedSUDe2cDba3m23mi2JM53uEOvsVjAHvr/0Cix9UrJlA==
X-Received: by 2002:a17:903:110c:b0:19a:96f0:a8de with SMTP id n12-20020a170903110c00b0019a96f0a8demr2186968plh.5.1676369281776;
        Tue, 14 Feb 2023 02:08:01 -0800 (PST)
Received: from [10.176.68.61] ([192.19.148.250])
        by smtp.gmail.com with ESMTPSA id ix11-20020a170902f80b00b0019926c7757asm5605668plb.289.2023.02.14.02.07.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 02:08:00 -0800 (PST)
Message-ID: <edcabef3-f440-9c15-e69f-845eb6a4de1b@broadcom.com>
Date:   Tue, 14 Feb 2023 11:07:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] brcmfmac: cfg80211: Use WSEC to set SAE password
To:     Hector Martin <marcan@marcan.st>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Double Lo <double.lo@infineon.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Linus Walleij <linus.walleij@linaro.org>,
        asahi@lists.linux.dev, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230214093319.21077-1-marcan@marcan.st>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <20230214093319.21077-1-marcan@marcan.st>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000925eb305f4a623c3"
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000925eb305f4a623c3
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

+ Double Lo

On 2/14/2023 10:33 AM, Hector Martin wrote:
> Using the WSEC command instead of sae_password seems to be the supported
> mechanism on newer firmware, and also how the brcmdhd driver does it.

The SAE code in brcmfmac was added by Cypress/Infineon. For my BCA 
devices that did not work, but this change should be verified on Cypress 
hardware.

Regards,
Arend

> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---
> Note: must be applied after:
> 
> [PATCH 06/10] brcmfmac: cfg80211: Pass the PMK in binary instead of hex
> 
> Since that is reviewed and this isn't yet, I expect that will go in
> first anyway.
> 
>   .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 46 ++++++++-----------
>   .../broadcom/brcm80211/brcmfmac/fwil_types.h  |  2 +-
>   2 files changed, 20 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 18e6699d4024..e4690d56e7c3 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -1682,52 +1682,44 @@ static u16 brcmf_map_fw_linkdown_reason(const struct brcmf_event_msg *e)
>   	return reason;
>   }
>   
> -static int brcmf_set_pmk(struct brcmf_if *ifp, const u8 *pmk_data, u16 pmk_len)
> +static int brcmf_set_wsec(struct brcmf_if *ifp, const u8 *key, u16 key_len, u16 flags)
>   {
>   	struct brcmf_pub *drvr = ifp->drvr;
>   	struct brcmf_wsec_pmk_le pmk;
>   	int err;
>   
> +	if (key_len > sizeof(pmk.key)) {
> +		bphy_err(drvr, "key must be less than %zu bytes\n",
> +			 sizeof(pmk.key));
> +		return -EINVAL;
> +	}
> +
>   	memset(&pmk, 0, sizeof(pmk));
>   
> -	/* pass pmk directly */
> -	pmk.key_len = cpu_to_le16(pmk_len);
> -	pmk.flags = cpu_to_le16(0);
> -	memcpy(pmk.key, pmk_data, pmk_len);
> +	/* pass key material directly */
> +	pmk.key_len = cpu_to_le16(key_len);
> +	pmk.flags = cpu_to_le16(flags);
> +	memcpy(pmk.key, key, key_len);
>   
> -	/* store psk in firmware */
> +	/* store key material in firmware */
>   	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_WSEC_PMK,
>   				     &pmk, sizeof(pmk));
>   	if (err < 0)
>   		bphy_err(drvr, "failed to change PSK in firmware (len=%u)\n",
> -			 pmk_len);
> +			 key_len);
>   
>   	return err;
>   }
>   
> +static int brcmf_set_pmk(struct brcmf_if *ifp, const u8 *pmk_data, u16 pmk_len)
> +{
> +	return brcmf_set_wsec(ifp, pmk_data, pmk_len, 0);
> +}
> +
>   static int brcmf_set_sae_password(struct brcmf_if *ifp, const u8 *pwd_data,
>   				  u16 pwd_len)
>   {
> -	struct brcmf_pub *drvr = ifp->drvr;
> -	struct brcmf_wsec_sae_pwd_le sae_pwd;
> -	int err;
> -
> -	if (pwd_len > BRCMF_WSEC_MAX_SAE_PASSWORD_LEN) {
> -		bphy_err(drvr, "sae_password must be less than %d\n",
> -			 BRCMF_WSEC_MAX_SAE_PASSWORD_LEN);
> -		return -EINVAL;
> -	}
> -
> -	sae_pwd.key_len = cpu_to_le16(pwd_len);
> -	memcpy(sae_pwd.key, pwd_data, pwd_len);
> -
> -	err = brcmf_fil_iovar_data_set(ifp, "sae_password", &sae_pwd,
> -				       sizeof(sae_pwd));
> -	if (err < 0)
> -		bphy_err(drvr, "failed to set SAE password in firmware (len=%u)\n",
> -			 pwd_len);
> -
> -	return err;
> +	return brcmf_set_wsec(ifp, pwd_data, pwd_len, BRCMF_WSEC_PASSPHRASE);
>   }
>   
>   static void brcmf_link_down(struct brcmf_cfg80211_vif *vif, u16 reason,
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
> index 792adaf880b4..3ba90878c47d 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
> @@ -574,7 +574,7 @@ struct brcmf_wsec_key_le {
>   struct brcmf_wsec_pmk_le {
>   	__le16  key_len;
>   	__le16  flags;
> -	u8 key[2 * BRCMF_WSEC_MAX_PSK_LEN + 1];
> +	u8 key[BRCMF_WSEC_MAX_SAE_PASSWORD_LEN];
>   };
>   
>   /**

--000000000000925eb305f4a623c3
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
2Gzj3QNJRLsZu1TLyOyBBIr/BE7UiY3RabgRzknBGAPmzhS+fmyM8OtM5BYBsFBrSUFtZZO2p/tf
Nbc24J2zf2peoZ8MK+7WQqummYlOnz+FyDkA9EybeNMcS5C+xi/PAgMBAAGjggHdMIIB2TAOBgNV
HQ8BAf8EBAMCBaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJl
Lmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYI
KwYBBQUHMAGGNWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24y
Y2EyMDIwME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3
dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqG
OGh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3Js
MCcGA1UdEQQgMB6BHGFyZW5kLnZhbnNwcmllbEBicm9hZGNvbS5jb20wEwYDVR0lBAwwCgYIKwYB
BQUHAwQwHwYDVR0jBBgwFoAUljPR5lgXWzR1ioFWZNW+SN6hj88wHQYDVR0OBBYEFIikAXd8CEtv
ZbDflDRnf3tuStPuMA0GCSqGSIb3DQEBCwUAA4IBAQCdS5XCYx6k2GGZui9DlFsFm75khkqAU7rT
zBX04sJU1+B1wtgmWTVIzW7ugdtDZ4gzaV0S9xRhpDErjJaltxPbCylb1DEsLj+AIvBR34caW6ZG
sQk444t0HPb29HnWYj+OllIGMbdJWr0/P95ZrKk2bP24ub3ZP/8SyzrohfIba9WZKMq6g2nTLZE3
BtkeSGJx/8dy0h8YmRn+adOrxKXHxhSL8BNn8wsmIZyYWe6fRcBtO3Ks2DOLyHCdkoFlN8x9VUQF
N2ulEgqCbRKkx+qNirW86eF138lr1gRxzclu/38ko//MmkAYR/+hP3WnBll7zbpIt0jc9wyFkSqH
p8a1MYICbTCCAmkCAQEwazBbMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1z
YTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMgUGVyc29uYWxTaWduIDIgQ0EgMjAyMAIMTv1t
bpIzNUky46LXMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCCynxZ1Gl49fThIAxyD
Hi/6AmstafpI6JJ/eACvnb523jAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yMzAyMTQxMDA4MDJaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFl
AwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAFKPe6aaVAENUut5TPigjhZohQ84lnPunp6v/
Vd8D6dG1QLn4NRoexKxUbemATKX7X0SqKM+NKFNVWcp4SKM1M0FCx5V89IkW9nu7D9CXntscjTDs
xmNR/DOBBVeQzYunusRRCuy+o5fAUBEn5op2Ds6FCbrH/HGEIxd0fdfjPZlaVJtkfXa0OEEs3zKv
tnwsXHTQc0xQaW9HMbZNIXrcVUWYsy7vTDnnL+3La7vjUTaj84PCQ0Vx4BGiF3RGfV0G+FO/GR5V
iEVqTAEzPjtTrpwmy7+H2MOxQd6e+iy5ItHNKQNyIErGqK/1GkQW/8WiOBxvjTw+z0ZTk9smYGim
CQ==
--000000000000925eb305f4a623c3--
