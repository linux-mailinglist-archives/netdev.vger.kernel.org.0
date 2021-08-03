Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F363DF317
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbhHCQqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234340AbhHCQqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:46:11 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87BD1C061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 09:45:59 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id m9so28901137ljp.7
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 09:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cVCOgBhxK6ej5ZJaiVJqX12xy9igmesO+8WGEFSAVz8=;
        b=ZDWR5PYYeXhAig0MN2Q0LBRsuDg4ObbPAn10CjAICzN4ePeCwaiTPZuLtzRxUDd0OE
         5O0xPi1+p41hbETT0oG0B/G9iQuhhaPlc9bH1fezuJzxsV5LCXTYB5IFjpxcfR/bIQbe
         BtFtgwc46+hL8IJXj1bwn5IXnPp5IjRjJd6Hnw/gttWFn6mPClJqWQiTlALZI2cPmlBp
         DbxFyYYFix+o4S5u4xh8BDv3yE1LuumdIc2k+JnITChLZT6Lbj7PFUQDGURKmnLDM5J+
         GM2UoEjnV1mLQCS4pkHQQKJTmppuPXVwJElQBnW2eDB/CI4kwQJRPTzkAYBsuZraI3Uu
         nQ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cVCOgBhxK6ej5ZJaiVJqX12xy9igmesO+8WGEFSAVz8=;
        b=g+MvHkl7Hzqw027ZQ+RGDyTQm8DNmWg0xA2Tk4MpyhHbE3kITPaZsgsNzRte0OMExf
         v6s7XXVHZEOmz1o16aKlSMeqwQf76lUGwvChJXWldynonS4IuqgGL7h/ED5Rk6ypkdqv
         z9WPmoQbv4k6GMeHI5us9d95no5Y1DVCj6/8vuDJDezHkDz2jQTwGppa1LIa6G9BcUg+
         C4zowp03vBMfTYTaF24udaMrBki1Vy+2UDd/TFalAcweJZHL2fFcv76jrBuDPEokyPHV
         rmIp6pRKq0wLNj79pXKSWqO8tTnFgM/22C+sB+pwpoEquTSnKP0mamPpQ83Yv9QHvoKF
         GX3g==
X-Gm-Message-State: AOAM531PaI2Z2bPkF5g3x4ypJPmkOm/8C1/fxwnuP4hZxO63wpm0xIed
        xnlF7usAjVmokuo6u7iP0+SMeeyPar0=
X-Google-Smtp-Source: ABdhPJySVcERBzgB+WSXQYkyIawC7+ereHHh7KtZJIVuBVln7/rnZTzjWC/H9tjNzJtQk9KUgoB5qA==
X-Received: by 2002:a05:651c:1246:: with SMTP id h6mr15250087ljh.123.1628009157916;
        Tue, 03 Aug 2021 09:45:57 -0700 (PDT)
Received: from localhost.localdomain ([94.103.226.235])
        by smtp.gmail.com with ESMTPSA id g11sm1140695ljl.139.2021.08.03.09.45.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 09:45:57 -0700 (PDT)
Subject: Re: [PATCH net v2 1/2] Check the return value of get_geristers() and
 friends;
To:     Petko Manolov <petko.manolov@konsulko.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        Petko Manolov <petkan@nucleusys.com>
References: <20210803161853.5904-1-petko.manolov@konsulko.com>
 <20210803161853.5904-2-petko.manolov@konsulko.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <69cedfb2-fc76-0afb-3a48-f24f238d5330@gmail.com>
Date:   Tue, 3 Aug 2021 19:45:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210803161853.5904-2-petko.manolov@konsulko.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/21 7:18 PM, Petko Manolov wrote:
> From: Petko Manolov <petkan@nucleusys.com>
> 
> Certain call sites of get_geristers() did not do proper error handling.  This
> could be a problem as get_geristers() typically return the data via pointer to a
> buffer.  If an error occured the code is carelessly manipulating the wrong data.
> 
> Signed-off-by: Petko Manolov <petkan@nucleusys.com>
> ---
>   drivers/net/usb/pegasus.c | 104 ++++++++++++++++++++++++++------------
>   1 file changed, 72 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
> index 9a907182569c..06e3ae6209b0 100644
> --- a/drivers/net/usb/pegasus.c
> +++ b/drivers/net/usb/pegasus.c
> @@ -132,9 +132,15 @@ static int get_registers(pegasus_t *pegasus, __u16 indx, __u16 size, void *data)
>   static int set_registers(pegasus_t *pegasus, __u16 indx, __u16 size,
>   			 const void *data)
>   {
> -	return usb_control_msg_send(pegasus->usb, 0, PEGASUS_REQ_SET_REGS,
> +	int ret;
> +
> +	ret = usb_control_msg_send(pegasus->usb, 0, PEGASUS_REQ_SET_REGS,
>   				    PEGASUS_REQT_WRITE, 0, indx, data, size,
>   				    1000, GFP_NOIO);
> +	if (ret < 0)
> +		netif_dbg(pegasus, drv, pegasus->net, "%s failed with %d\n", __func__, ret);
> +
> +	return ret;
>   }
>   
>   /*
> @@ -145,10 +151,15 @@ static int set_registers(pegasus_t *pegasus, __u16 indx, __u16 size,
>   static int set_register(pegasus_t *pegasus, __u16 indx, __u8 data)
>   {
>   	void *buf = &data;
> +	int ret;
>   
> -	return usb_control_msg_send(pegasus->usb, 0, PEGASUS_REQ_SET_REG,
> +	ret = usb_control_msg_send(pegasus->usb, 0, PEGASUS_REQ_SET_REG,
>   				    PEGASUS_REQT_WRITE, data, indx, buf, 1,
>   				    1000, GFP_NOIO);
> +	if (ret < 0)
> +		netif_dbg(pegasus, drv, pegasus->net, "%s failed with %d\n", __func__, ret);
> +
> +	return ret;
>   }
>   
>   static int update_eth_regs_async(pegasus_t *pegasus)
> @@ -188,10 +199,9 @@ static int update_eth_regs_async(pegasus_t *pegasus)
>   
>   static int __mii_op(pegasus_t *p, __u8 phy, __u8 indx, __u16 *regd, __u8 cmd)
>   {
> -	int i;
> -	__u8 data[4] = { phy, 0, 0, indx };
> +	int i, ret = -ETIMEDOUT;
>   	__le16 regdi;
> -	int ret = -ETIMEDOUT;
> +	__u8 data[4] = { phy, 0, 0, indx };
>   
>   	if (cmd & PHY_WRITE) {
>   		__le16 *t = (__le16 *) & data[1];
> @@ -211,8 +221,9 @@ static int __mii_op(pegasus_t *p, __u8 phy, __u8 indx, __u16 *regd, __u8 cmd)
>   		goto fail;
		^^^^^^^^^

I really don't want You to spin this series one more time, but ret 
initialization is missed here again :) Maybe, it's not really important 
here...

And Fixes or CC stable is missed too


With regards,
Pavel Skripkin
