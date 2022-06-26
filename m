Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4360D55B3DC
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 21:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbiFZTte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 15:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiFZTtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 15:49:33 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB39C214
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 12:49:31 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id fd6so10334354edb.5
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 12:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cvc7WQjIfQALH8uF/wWzX8UFQ5EmdXg7iLe0SD89Mqo=;
        b=JT4ZjTHjXL+k64EtGK335t8/cXSx/wuAsDvOE7MSkpnLYT0urZJ1eaFKa5lIXEC8QW
         yPqCM8GfCtzkV/y5LV1cIda+oQQQbGv2doYMktzYGQ0LqFt0LUjIM1mc87yF5BUw5KWh
         myqB+Rp3cNocSG284jpQR/nGt6TTCsctUOU64mrAX6fuqguxM0MjUf0QmPqkeYGnp9Su
         ueXA1MD2cvnW63j76uv2i7/r5Cg8CxhsPUpaWBwGXBJeD6j/jubJv/Nu3yZN+70tD3dr
         9ygms0KFNmomz0ulDXly4r3Ac+pzCiRylzXbueHsdA9B19kp3zeveA2nsB9ZOgLWjVGV
         2Cbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cvc7WQjIfQALH8uF/wWzX8UFQ5EmdXg7iLe0SD89Mqo=;
        b=MmsLDV9fJm/LjXUMZHEMEh+ENHh/oCk2lQFk8UKafHq43tN7v//uo43GkqKq3CIPJi
         Ft3mMuHVOogayQLks26TnRwDlKW6Wa3ijxNOSO0zr09SUpb1lo4KkDzOs06PJIPcf6Yp
         D3d2hUvBd/yEyDVhTMZcACm14uJmOB2lfMIxXeWlLFCCwyoHIZKVWK1+6RuuJL1k6tT+
         2p+d1CTw2eHWikOy7155KOfoVt+cdRgwATEOMvibPdmkyVHeQSutE8Q7zz9ATu/uUUVe
         A9n5smkqQ/0m/RYXdZcHuGhcCO4CQe+pt9Qw7QYUzUhUBitJMC01FKfyEMW4AX8xBGL2
         lHRg==
X-Gm-Message-State: AJIora+Vog4DGKbtRK25IzskfBq/mAG7g9neP/pd+AghRBfNfZqtEWqO
        R0AvuzFC0IVkwvIwTIzhy3uNxg==
X-Google-Smtp-Source: AGRyM1tfHsWw1mNVcRKGJuLFgpFYJrd57ydeHTObJwUV6/1lxv7hKQIq2WmU+XW3KJ/VREREuLC1Aw==
X-Received: by 2002:a05:6402:42d5:b0:433:1727:b31c with SMTP id i21-20020a05640242d500b004331727b31cmr12335712edc.9.1656272970265;
        Sun, 26 Jun 2022 12:49:30 -0700 (PDT)
Received: from [192.168.0.244] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id a12-20020a170906670c00b006fe8c831632sm4068087ejp.73.2022.06.26.12.49.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jun 2022 12:49:29 -0700 (PDT)
Message-ID: <99e3ad4f-077a-0ca0-6842-b0c5a3439b68@linaro.org>
Date:   Sun, 26 Jun 2022 21:49:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/2] NFC: nxp-nci: check return code of i2c_master_recv()
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>,
        Charles Gorand <charles.gorand@effinnov.com>
Cc:     =?UTF-8?Q?Cl=c3=a9ment_Perrochaud?= <clement.perrochaud@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220626194243.4059870-1-michael@walle.cc>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220626194243.4059870-1-michael@walle.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/06/2022 21:42, Michael Walle wrote:
> Check the return code of i2c_master_recv() for actual errors and
> propagate it to the caller.
> 
> Fixes: 6be88670fc59 ("NFC: nxp-nci_i2c: Add I2C support to NXP NCI driver")

The check was there, so I don't see here bug. The only thing missing was
a bit more detailed error message (without cast to %u) and propagating
error code instead of EBADMSG, but these are not bugs. The commit msg
should sound different and Fixes tag is not appropriate.

> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  drivers/nfc/nxp-nci/i2c.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
> index 7e451c10985d..9c80d5a6d56b 100644
> --- a/drivers/nfc/nxp-nci/i2c.c
> +++ b/drivers/nfc/nxp-nci/i2c.c
> @@ -163,7 +163,10 @@ static int nxp_nci_i2c_nci_read(struct nxp_nci_i2c_phy *phy,
>  	skb_put_data(*skb, (void *)&header, NCI_CTRL_HDR_SIZE);
>  
>  	r = i2c_master_recv(client, skb_put(*skb, header.plen), header.plen);
> -	if (r != header.plen) {
> +	if (r < 0) {
> +		nfc_err(&client->dev, "I2C receive error %pe\n", ERR_PTR(r));

Print just 'r'.

> +		goto nci_read_exit_free_skb;
> +	} else if (r != header.plen) {
>  		nfc_err(&client->dev,
>  			"Invalid frame payload length: %u (expected %u)\n",
>  			r, header.plen);


Best regards,
Krzysztof
