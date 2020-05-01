Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA061C1CB3
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 20:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730262AbgEASPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 14:15:23 -0400
Received: from mout.web.de ([212.227.15.14]:37699 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729425AbgEASPW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 14:15:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588356906;
        bh=xjkKsoljwN5DN226VD+/6P5ZiuDy8ctAVl1hIg99XqE=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=S8VASFrGLcUUJuV40NC9CPYQ7oA7l1a+e1xCN0ZBg4Wu10cOWh6J/c0YqSqqPNf38
         RyXzQokZE9Js/9GcIk+SO91MaEb2e1zt3niP/nV4igADzFsW18rilvxoySyRWTSTAq
         xyW6KMdniD5T2ER2lCLWnQfdXc74CaqSBvQ+T6Ss=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.136.146]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0Md16Y-1jmf2O0rII-00IEFr; Fri, 01
 May 2020 20:15:06 +0200
To:     Colin Ian King <colin.king@canonical.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lubomir Rintel <lkundrak@v3.sk>,
        Steve deRosier <derosier@cal-sierra.com>
Subject: Re: [PATCH] libertas_tf: Avoid a null pointer dereference in
 if_usb_disconnect()
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <93740048-acc1-b140-3b91-a659408091ac@web.de>
Date:   Fri, 1 May 2020 20:15:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:/dKeb0S9rbPjx25NWaRkRXvRQfJHDuX1LgZM5rUjlNh0Klczjh8
 GnDeu331l0Pkc2hsKtDm5K/PCW8u26MIO4+foUIrcW1AoIBNMfu1SuRnGNpcr6fkoED2OTC
 Az+UnGMouxAKvUKPCQKk2ssbX+Q3q/I2Ts9ACxjFv6GMY+ViADsDnIExYZ8MO+BUXhcTgek
 FwVmhFy0y9Vl1f+uAxT8w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:g5k29zEdniM=:5bGdlZ2q4bvE786PtMsVfy
 9XHapYEadoHSQh3iiL+wMwNfbjhFtCL667giKm1b3E1Yt2FtyXHITY2qCaluP1H6udP2NWNQF
 OMzglM6OACVPTKeG+indQOoQmdMI2YiYCkIW2A7ASBHw0Sln+kJrWDSFiZwRt03pvDlA/wPyn
 C9g4nWHQr75px0D8SjjO/g+sNDb88juA+jxAbnDu4Vd9xV7hMW1L9bBoGlZ6v1C9t/9DZpWrD
 C2B5GNuIbMqp8B6E68cs1MITD7VcB0bytobQQSGpK9AEn3xJiQvQFhF43SuoAF5DQLdwsTnCA
 6w2UFG0XjVrmXl7rLTSON79d9cpytfkCxEuwA9i+FY/REkOvKOgpidNKvv8s8VqFmU0DXTkyu
 ZPxB7NQQrFJh+v9ihqphb0iEViLnm+23zXQwbJ8suFFsqmZ5gOBLzrfKLU3YrFB7IrJEVf7YY
 tuDt5oBj8113f8o/1YcrJ/cFOCH+pc5DrbBEfrm3J4GV//wI3ksz+5mgd2r45nGqcfEcI449R
 Yu8zYYMddeoLOMtpuHd3Odm1vcJHMzikVTyvJNor+cCPj16MfEtwItW+bTn7VsMRF8Q35C7ZQ
 FzM1hD/m8r5Zw8BPCvqzUt/x/8c22IlzTdIn4DsG7x/JPe2V1zPOkdlumFP1Xzih7H1LE0n1R
 NHsGrbsjtQc2/EaDSd10yCnWptcLOSUUcvEnbkbZ6tNaRbnnPdfTgof28gUCNAZqZAYs6MN60
 a7y67umAjXvESK3E5wj7b3emdvsnpCmhQRGV+DtDOPAfzY7+LUFuSADWqzEifKVVjbWLmVxVj
 ySJQxz1R38z+h/c27Y+f9u8/d9xRRDZ8Ud3R0Ra8YZwfYoyX720bLfaiO/knGRzJ1wI9SvW7u
 OoEpJCK3WVcrNRH5F+gjxtAUbJsSLwdRcZcwkW6r1lwhy4nAUfLP87Idnk+Tcloow4AihDeKd
 MgrAOF16I+XUSq2tGxGDlwb9e+xfDIqvHYS/0JmCCrlQfbZMrhzRgtxes3mADthtNv+Z2WNMU
 5tIvcJ6rjj4XclRqW6daaiGXMM9pUuLWiGbCPvp5HHpHdPpvhTeu4ozXcdVEBK2sF3u1Q1GfF
 vA4hkJtagDuoN+ihck2WlGfCb8ac7suQRB0JQLwQ+Wp/e3Lm4nsZUZyhUoSp0L60MJPcPxPS6
 v/L4JXr+bjqhQ4uTk0e52BDzw3ap/dGA2uSMIn4mUdC5owwhmBgR1uD949Q3dkHar1Yqci3Ek
 7g2jm0RPiosEMkQrY
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Currently there is a check if priv is null when calling lbtf_remove_card
> but not in a previous call to if_usb_reset_dev that can also dereference
> priv.  Fix this by also only calling lbtf_remove_card if priv is null.

I suggest to recheck this description (and the corresponding patch subject=
).


=E2=80=A6
> +++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
> @@ -247,10 +247,10 @@ static void if_usb_disconnect(struct usb_interface=
 *intf)
>
>  	lbtf_deb_enter(LBTF_DEB_MAIN);
>
> -	if_usb_reset_device(priv);
> -
> -	if (priv)
> +	if (priv) {
> +		if_usb_reset_device(priv);
>  		lbtf_remove_card(priv);
> +	}
>
>  	/* Unlink and free urb */
>  	if_usb_free(cardp);

The patch code proposes to move a specific function call into an if branch
according to a null pointer check.

Regards,
Markus
