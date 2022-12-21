Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A7C652EC9
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 10:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbiLUJpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 04:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234615AbiLUJpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 04:45:34 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CF421E34
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 01:45:32 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id m29so22442048lfo.11
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 01:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=00Inf63iGaAsVhYSavXD2K2q3AWuG2Zj5gcQJk+z2i4=;
        b=qTLeLBAcwolPiW0pMxHIgX/+j4GMOVsFLzYLYdKKubLh89RJVmTl1YEtvk8+IFqm+w
         uNFT8wrUcNT8ohDTMB/IoJZ1hAaUblf1Nwjvo6+CyArxUKbFDKAQcXi6G6rUqj7Veyv1
         p4N/MDL+UvnFv5bxX2/iVT6se0BPJ8le7aDutnLJsatj9/k2lnhCle43ZyP1GB0LtzS4
         NQF+Mcaxli1Z8EjkFJ6GF+jxWg+der6A3j1ORGy19Nr6XiRayjHML2EIILLhcB4MTd/D
         zsKx2sC09KszSvML1G6T6L97u9c185I0x+83Z7l5Kq8wOBjZ+sF0lYzyRaSZViSme3Yd
         ikMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=00Inf63iGaAsVhYSavXD2K2q3AWuG2Zj5gcQJk+z2i4=;
        b=YiNy/95hcpFzuRYoZ+/SNbcdEuwqflaVvI3vL7RfYMAlt8lvdDKPo2FRrPhXmzmrjd
         IO5TKpOpqmPf+WtBNT87RmAgoqYEVd8hh8ngFDHkB15+ZNx9WinyqdSWxWdO+QWIf6BJ
         PjIH+SOfIpog/UDeKoqus3TkZzfFjloWCeYZW4X++NOpxxafmqG3MFGY8OhcM4pdaJUX
         mgqIDYv1R8uJsXZLagYHReu9Py3ikHVU77Q5oOGDhmfJry8Te6CbelLScvBGY26AaTYD
         9uyh4uepNcJcfR60iTlewWB2WDijhIVWjH5JBYn0q5ZLSbGDKYykvZqEu21omxCCUVDA
         US+g==
X-Gm-Message-State: AFqh2krWm8vBvCnRrc69ssIr1HOIfkzXLVDgVLUqECYtthiD/MfH5UlF
        1caPYPEoMSFeIW4V8egk60rJMQ==
X-Google-Smtp-Source: AMrXdXv6F0T1mgD1kw4HVCZHPSMdZt2dpa2hqSxaIodKeBscaNn14i0wcVM+58/+5+y3O4o6SvPRjw==
X-Received: by 2002:a05:6512:6d0:b0:4b5:d:efb2 with SMTP id u16-20020a05651206d000b004b5000defb2mr410566lff.14.1671615930786;
        Wed, 21 Dec 2022 01:45:30 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id y4-20020a197504000000b0049c29389b98sm1777424lfe.151.2022.12.21.01.45.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Dec 2022 01:45:30 -0800 (PST)
Message-ID: <0f1d8479-657a-acb2-4a8d-69ae5a451a63@linaro.org>
Date:   Wed, 21 Dec 2022 10:45:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] nfc: Fix potential resource leaks
Content-Language: en-US
To:     Miaoqian Lin <linmq006@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221220134623.2084443-1-linmq006@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221220134623.2084443-1-linmq006@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/12/2022 14:46, Miaoqian Lin wrote:
> nfc_get_device() take reference for the device, add missing
> nfc_put_device() to release it when not need anymore.
> Also fix the style warnning by use error EOPNOTSUPP instead of
> ENOTSUPP.
> 
> Fixes: 5ce3f32b5264 ("NFC: netlink: SE API implementation")
> Fixes: 29e76924cf08 ("nfc: netlink: Add capability to reply to vendor_cmd with data")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> ---
>  net/nfc/netlink.c | 51 ++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 37 insertions(+), 14 deletions(-)
> 
> diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
> index 9d91087b9399..d081beaf4828 100644
> --- a/net/nfc/netlink.c
> +++ b/net/nfc/netlink.c
> @@ -1497,6 +1497,7 @@ static int nfc_genl_se_io(struct sk_buff *skb, struct genl_info *info)
>  	u32 dev_idx, se_idx;
>  	u8 *apdu;
>  	size_t apdu_len;
> +	int error;

Let's don't introduce the third or fourth style. Existing code calls it
"rc".

>  
>  	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
>  	    !info->attrs[NFC_ATTR_SE_INDEX] ||
> @@ -1510,25 +1511,37 @@ static int nfc_genl_se_io(struct sk_buff *skb, struct genl_info *info)
>  	if (!dev)
>  		return -ENODEV;
>  
> -	if (!dev->ops || !dev->ops->se_io)
> -		return -ENOTSUPP;
> +	if (!dev->ops || !dev->ops->se_io) {
> +		error = -EOPNOTSUPP;
> +		goto put_dev;
> +	}
>  
>  	apdu_len = nla_len(info->attrs[NFC_ATTR_SE_APDU]);
> -	if (apdu_len == 0)
> -		return -EINVAL;
> +	if (apdu_len == 0) {
> +		error = -EINVAL;
> +		goto put_dev;
> +	}
>  
>  	apdu = nla_data(info->attrs[NFC_ATTR_SE_APDU]);
> -	if (!apdu)
> -		return -EINVAL;
> +	if (!apdu) {
> +		error = -EINVAL;
> +		goto put_dev;
> +	}
>  
>  	ctx = kzalloc(sizeof(struct se_io_ctx), GFP_KERNEL);
> -	if (!ctx)
> -		return -ENOMEM;
> +	if (!ctx) {
> +		error = -ENOMEM;
> +		goto put_dev;
> +	}
>  
>  	ctx->dev_idx = dev_idx;
>  	ctx->se_idx = se_idx;
>  
> -	return nfc_se_io(dev, se_idx, apdu, apdu_len, se_io_cb, ctx);
> +	error = nfc_se_io(dev, se_idx, apdu, apdu_len, se_io_cb, ctx);
> +
> +put_dev:
> +	nfc_put_device(dev);
> +	return error;
>  }
>  
>  static int nfc_genl_vendor_cmd(struct sk_buff *skb,
> @@ -1551,14 +1564,20 @@ static int nfc_genl_vendor_cmd(struct sk_buff *skb,
>  	subcmd = nla_get_u32(info->attrs[NFC_ATTR_VENDOR_SUBCMD]);
>  
>  	dev = nfc_get_device(dev_idx);
> -	if (!dev || !dev->vendor_cmds || !dev->n_vendor_cmds)
> +	if (!dev)
>  		return -ENODEV;

Blank line

> +	if (!dev->vendor_cmds || !dev->n_vendor_cmds) {
> +		err = -ENODEV;
> +		goto put_dev;
> +	}
>  
>  	if (info->attrs[NFC_ATTR_VENDOR_DATA]) {
>  		data = nla_data(info->attrs[NFC_ATTR_VENDOR_DATA]);
>  		data_len = nla_len(info->attrs[NFC_ATTR_VENDOR_DATA]);
> -		if (data_len == 0)
> -			return -EINVAL;
> +		if (data_len == 0) {
> +			err = -EINVAL;
> +			goto put_dev;
> +		}
>  	} else {
>  		data = NULL;
>  		data_len = 0;
> @@ -1573,10 +1592,14 @@ static int nfc_genl_vendor_cmd(struct sk_buff *skb,
>  		dev->cur_cmd_info = info;
>  		err = cmd->doit(dev, data, data_len);
>  		dev->cur_cmd_info = NULL;
> -		return err;
> +		goto put_dev;
>  	}
>  
> -	return -EOPNOTSUPP;
> +	err = -EOPNOTSUPP;
> +
> +put_dev:
> +	nfc_put_device(dev);
> +	return err;
>  }
>  
>  /* message building helper */

Best regards,
Krzysztof

