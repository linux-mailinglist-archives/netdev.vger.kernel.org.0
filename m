Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028324FEC2E
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 03:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbiDMBZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 21:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiDMBZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 21:25:48 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26362899F;
        Tue, 12 Apr 2022 18:23:25 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id k5so845899lfg.9;
        Tue, 12 Apr 2022 18:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qKK7F55fvPxfwHvUeGcsnCfPeejSbawXKaUujgRE1VU=;
        b=qmeXoJ4HsVpKd0Y9Qxco39Vg9+JwdZ5ICugBMgSXaXZSImgUEBgJ+y7sCP+YnbUwWu
         4aFykSMLTQ/3I1ivRKgoYxQq6GO9ozpDVbfgiQF66bVljr+YzmcjEc/P0WmV11pMSsx3
         Ygw4pUJjdyh23yJ/znLI1sepVVGorucyG88A6auvWJgM32DBh3eOMC+GiQN1nDRDJrT3
         vk/iIk6pyAQhMnaX0CfM4esaczKdqJ43FhmuwWqJCShJZAK+74TF9vW4R5UvpdMBh7+2
         O2bA4+4haEqBJeT9z311xSDXLb9SzZjgP134MwpQMCzBXOyJHsorif8uXp0TSiNzuNt3
         ldYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qKK7F55fvPxfwHvUeGcsnCfPeejSbawXKaUujgRE1VU=;
        b=YFoiI5J5fTJSxVQkY3KKTgjiL7Y9Xf5RT32XId0b+6g4hcGH7n+nJOE1HSpPtHetKA
         lI+EQPkfsX3boMFVLHDHEQphnl5IZoKrWD74yEnoGgeDM1LZIGb9YffyQpbbJiuLS/lo
         G+GALj96F3DHfdiHGFJRi3SOQh4UedtJCKt1S4w08uOztsVPC9WnmsDPs/33dxLmUUz5
         zb/8foXB6AzWPmPhyz1zwq5fbUAQVMfXYA/KcwhDd0v17HVVxzXyv97rWi7C4oITzewR
         tCvAScPwvm8oXH83yEfPsWmHnIzToDACX9LoLaZrlAuzB9Tlrz7EfGihLeQEDPyxMfwt
         +trA==
X-Gm-Message-State: AOAM532Go++U7zwjl89v4T0hHTujaMflN8SimmJ/nJAVoTHm4G78vcVF
        YJQ/jqqEYLWxfIwRdZF3SJQT8WAMR5zbTQ==
X-Google-Smtp-Source: ABdhPJx+HALY5x4EMB0lD4M2/rknLJURVhZQWBiOjxtnGRI6kS21TbnVJxYT9CoT48k12xB5tgBDtQ==
X-Received: by 2002:a05:6512:3c97:b0:46b:92c5:5bcb with SMTP id h23-20020a0565123c9700b0046b92c55bcbmr13104677lfv.429.1649813003750;
        Tue, 12 Apr 2022 18:23:23 -0700 (PDT)
Received: from ?IPV6:2001:470:6180:0:a105:2443:47df:c2c9? ([2001:470:6180:0:a105:2443:47df:c2c9])
        by smtp.googlemail.com with ESMTPSA id m1-20020a05651202e100b0046cd451b8easm63972lfq.22.2022.04.12.18.23.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 18:23:23 -0700 (PDT)
Message-ID: <2efc5cef-c466-4c7f-cb7d-c461ac342361@gmail.com>
Date:   Wed, 13 Apr 2022 03:23:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 2/3] rndis_host: enable the bogus MAC fixup for ZTE
 devices from cdc_ether
Content-Language: en-GB
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Cc:     =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Kristian Evensen <kristian.evensen@gmail.com>,
        Oliver Neukum <oliver@neukum.org>
References: <20220413001158.1202194-1-lech.perczak@gmail.com>
 <20220413001158.1202194-3-lech.perczak@gmail.com>
From:   Lech Perczak <lech.perczak@gmail.com>
In-Reply-To: <20220413001158.1202194-3-lech.perczak@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

W dniu 2022-04-13 o 02:11, Lech Perczak pisze:
> Certain ZTE modems, namely: MF823. MF831, MF910, built-in modem from
> MF286R, expose both CDC-ECM and RNDIS network interfaces.
> They have a trait of ignoring the locally-administered MAC address
> configured on the interface both in CDC-ECM and RNDIS part,
> and this leads to dropping of incoming traffic by the host.
> However, the workaround was only present in CDC-ECM, and MF286R
> explicitly requires it in RNDIS mode.
>
> Re-use the workaround in rndis_host as well, to fix operation of MF286R
> module, some versions of which expose only the RNDIS interface. Do so by
> introducing new flag, RNDIS_DRIVER_DATA_BOGUS_MAC, and testing for it in
And I just noticed that I forgot to rename that flag here, as well as
one unneded whitespace change creeped in. Will resend V3 shortly.
> rndis_rx_fixup. This is required, as RNDIS uses frame batching, and all
> of the packets inside the batch need the fixup. This might introduce a
> performance penalty, because test is done for every returned Ethernet
> frame.
>
> Apply the workaround to both "flavors" of RNDIS interfaces, as older ZTE
> modems, like MF823 found in the wild, report the USB_CLASS_COMM class
> interfaces, while MF286R reports USB_CLASS_WIRELESS_CONTROLLER.
>
> Suggested-by: Bjørn Mork <bjorn@mork.no>
> Cc: Kristian Evensen <kristian.evensen@gmail.com>
> Cc: Oliver Neukum <oliver@neukum.org>
> Signed-off-by: Lech Perczak <lech.perczak@gmail.com>
> ---
> v2:
> - Ensured that MAC fixup is applied to all Ethernet frames inside an
>    RNDIS batch. Thanks to Bjørn for finding the issue.
> - Introduced new driver flag to facilitate the above.
>
>   drivers/net/usb/rndis_host.c   | 33 ++++++++++++++++++++++++++++++++-
>   include/linux/usb/rndis_host.h |  1 +
>   2 files changed, 33 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
> index 247f58cb0f84..18b27a4ed8bd 100644
> --- a/drivers/net/usb/rndis_host.c
> +++ b/drivers/net/usb/rndis_host.c
> @@ -485,10 +485,14 @@ EXPORT_SYMBOL_GPL(rndis_unbind);
>    */
>   int rndis_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
>   {
> +	bool dst_mac_fixup;
> +
>   	/* This check is no longer done by usbnet */
>   	if (skb->len < dev->net->hard_header_len)
>   		return 0;
>   
> +	dst_mac_fixup = !!(dev->driver_info->data & RNDIS_DRIVER_DATA_DST_MAC_FIXUP);
> +
>   	/* peripheral may have batched packets to us... */
>   	while (likely(skb->len)) {
>   		struct rndis_data_hdr	*hdr = (void *)skb->data;
> @@ -523,10 +527,17 @@ int rndis_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
>   			break;
>   		skb_pull(skb, msg_len - sizeof *hdr);
>   		skb_trim(skb2, data_len);
> +
> +		if (unlikely(dst_mac_fixup))
> +			usbnet_cdc_zte_rx_fixup(dev, skb2);
> +
>   		usbnet_skb_return(dev, skb2);
>   	}
>   
>   	/* caller will usbnet_skb_return the remaining packet */
> +	if (unlikely(dst_mac_fixup))
> +		usbnet_cdc_zte_rx_fixup(dev, skb);
> +
>   	return 1;
>   }
>   EXPORT_SYMBOL_GPL(rndis_rx_fixup);
> @@ -578,7 +589,6 @@ rndis_tx_fixup(struct usbnet *dev, struct sk_buff *skb, gfp_t flags)
>   }
>   EXPORT_SYMBOL_GPL(rndis_tx_fixup);
>   
> -
>   static const struct driver_info	rndis_info = {
>   	.description =	"RNDIS device",
>   	.flags =	FLAG_ETHER | FLAG_POINTTOPOINT | FLAG_FRAMING_RN | FLAG_NO_SETINT,
> @@ -600,6 +610,17 @@ static const struct driver_info	rndis_poll_status_info = {
>   	.tx_fixup =	rndis_tx_fixup,
>   };
>   
> +static const struct driver_info	zte_rndis_info = {
> +	.description =	"ZTE RNDIS device",
> +	.flags =	FLAG_ETHER | FLAG_POINTTOPOINT | FLAG_FRAMING_RN | FLAG_NO_SETINT,
> +	.data =		RNDIS_DRIVER_DATA_DST_MAC_FIXUP,
> +	.bind =		rndis_bind,
> +	.unbind =	rndis_unbind,
> +	.status =	rndis_status,
> +	.rx_fixup =	rndis_rx_fixup,
> +	.tx_fixup =	rndis_tx_fixup,
> +};
> +
>   /*-------------------------------------------------------------------------*/
>   
>   static const struct usb_device_id	products [] = {
> @@ -613,6 +634,16 @@ static const struct usb_device_id	products [] = {
>   	USB_VENDOR_AND_INTERFACE_INFO(0x238b,
>   				      USB_CLASS_COMM, 2 /* ACM */, 0x0ff),
>   	.driver_info = (unsigned long)&rndis_info,
> +}, {
> +	/* ZTE WWAN modules */
> +	USB_VENDOR_AND_INTERFACE_INFO(0x19d2,
> +				      USB_CLASS_WIRELESS_CONTROLLER, 1, 3),
> +	.driver_info = (unsigned long)&zte_rndis_info,
> +}, {
> +	/* ZTE WWAN modules, ACM flavour */
> +	USB_VENDOR_AND_INTERFACE_INFO(0x19d2,
> +				      USB_CLASS_COMM, 2 /* ACM */, 0x0ff),
> +	.driver_info = (unsigned long)&zte_rndis_info,
>   }, {
>   	/* RNDIS is MSFT's un-official variant of CDC ACM */
>   	USB_INTERFACE_INFO(USB_CLASS_COMM, 2 /* ACM */, 0x0ff),
> diff --git a/include/linux/usb/rndis_host.h b/include/linux/usb/rndis_host.h
> index 809bccd08455..cc42db51bbba 100644
> --- a/include/linux/usb/rndis_host.h
> +++ b/include/linux/usb/rndis_host.h
> @@ -197,6 +197,7 @@ struct rndis_keepalive_c {	/* IN (optionally OUT) */
>   
>   /* Flags for driver_info::data */
>   #define RNDIS_DRIVER_DATA_POLL_STATUS	1	/* poll status before control */
> +#define RNDIS_DRIVER_DATA_DST_MAC_FIXUP	2	/* device ignores configured MAC address */
>   
>   extern void rndis_status(struct usbnet *dev, struct urb *urb);
>   extern int


-- 
Pozdrawiam/Kind regards,
Lech Perczak

