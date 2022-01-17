Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037E14910A8
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 20:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242863AbiAQTb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 14:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiAQTbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 14:31:24 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F825C061574;
        Mon, 17 Jan 2022 11:31:24 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id br17so61572700lfb.6;
        Mon, 17 Jan 2022 11:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=DZ5wjKqdD4TOpUJAi2NdV3t9go691za/EKfx/PAIrRE=;
        b=gz4T71ovmCihp7dBpcmrTTPBkYOr+u0E/lranh7viHqlkXAxn5JmP3Vz0EkFmH/2o4
         mGcXhut6ILLGgIik6IUbmwP2LpTY2Dh/2S2Kq933rbrrXTxZsVUr/9QYg/Lo/YexYc4Z
         /hJNUt4Fmx/75kdh5OSOj9Unr0NE14n+sL89QFQ02PDzOoD2FiB7kj2MSC2f0RPSLJLF
         u1qfungfAeyu7+hmzzPZ/bu+J3u88gNzwrpdlyO/4OUnXml7WnfhoWqnZCtXLVUZV860
         0m2+oPhI1++jDlSMigukoiiTeb68ByNNLtcH0naA9bLyuhv1/LgsWHehdm9HYSB83JNR
         SlPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DZ5wjKqdD4TOpUJAi2NdV3t9go691za/EKfx/PAIrRE=;
        b=D9bF0w1DMhYNVxtqApB9LAn9fjl5/4SZz4hTAZ2GG6iwJ5kTW0qCna1VHQPfpEt2hO
         eOLQyyrbF1bw0CGBetRSlRQcsrNR4Rf6zG3ZHutYAqGaTLT3dHpVEswjBln8hNqFPcqn
         8hNtFaQBkmTemLLkC3TInnsVP+TR2QjILUXAkkS5RJuhC1EaqoyUlzJPJJ5YhW8M+zGR
         5IR2QPcRR+FmFGz+SA5dMv0/ifgcUb1aogl5UsUWdKUp/IsvLMbVLjZz47hL5CFfG2Fr
         fkT4o6hxpTb6etElVZKXQPwVUR2OjqDpGOaAGSQIX0nrzCtALtBz7s47r9efU1rUaapo
         8gEg==
X-Gm-Message-State: AOAM530swVELMmdK5gn4TJMKvBvoCZB6Gl6LnxjWdrljcpijEWcFSuet
        YLOtl3pfPRvKC4B9Z9ls6hg=
X-Google-Smtp-Source: ABdhPJyKektrJbGLvmoZ62wrAIbR18BnJfnmPO7YAgypNVCdZWt+/9v1QVkY8Fr2BqM4fBI3dg4zaA==
X-Received: by 2002:ac2:5a41:: with SMTP id r1mr17741335lfn.44.1642447882595;
        Mon, 17 Jan 2022 11:31:22 -0800 (PST)
Received: from [192.168.1.11] ([94.103.227.208])
        by smtp.gmail.com with ESMTPSA id g33sm1299771lfv.91.2022.01.17.11.31.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 11:31:22 -0800 (PST)
Message-ID: <d2a4ad77-3ade-9319-f99c-82201c4268e5@gmail.com>
Date:   Mon, 17 Jan 2022 22:31:21 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH RFT] net: asix: add proper error handling of usb read
 errors
Content-Language: en-US
To:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        andrew@lunn.ch, oneukum@suse.com, robert.foss@collabora.com,
        freddy@asix.com.tw
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+6ca9f7867b77c2d316ac@syzkaller.appspotmail.com
References: <20220105131952.15693-1-paskripkin@gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20220105131952.15693-1-paskripkin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/22 16:19, Pavel Skripkin wrote:
> Syzbot once again hit uninit value in asix driver. The problem still the
> same -- asix_read_cmd() reads less bytes, than was requested by caller.
> 
> Since all read requests are performed via asix_read_cmd() let's catch
> usb related error there and add __must_check notation to be sure all
> callers actually check return value.
> 
> So, this patch adds sanity check inside asix_read_cmd(), that simply
> checks if bytes read are not less, than was requested and adds missing
> error handling of asix_read_cmd() all across the driver code.
> 
> Fixes: d9fe64e51114 ("net: asix: Add in_pm parameter")
> Reported-and-tested-by: syzbot+6ca9f7867b77c2d316ac@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---

gentle ping :)

>   drivers/net/usb/asix.h         |  4 ++--
>   drivers/net/usb/asix_common.c  | 19 +++++++++++++------
>   drivers/net/usb/asix_devices.c | 21 ++++++++++++++++++---
>   3 files changed, 33 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
> index 2a1e31defe71..4334aafab59a 100644
> --- a/drivers/net/usb/asix.h
> +++ b/drivers/net/usb/asix.h
> @@ -192,8 +192,8 @@ extern const struct driver_info ax88172a_info;
>   /* ASIX specific flags */
>   #define FLAG_EEPROM_MAC		(1UL << 0)  /* init device MAC from eeprom */
>   
> -int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
> -		  u16 size, void *data, int in_pm);
> +int __must_check asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
> +			       u16 size, void *data, int in_pm);
>   
>   int asix_write_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
>   		   u16 size, void *data, int in_pm);
> diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
> index 71682970be58..524805285019 100644
> --- a/drivers/net/usb/asix_common.c
> +++ b/drivers/net/usb/asix_common.c
> @@ -11,8 +11,8 @@
>   
>   #define AX_HOST_EN_RETRIES	30
>   
> -int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
> -		  u16 size, void *data, int in_pm)
> +int __must_check asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
> +			       u16 size, void *data, int in_pm)
>   {
>   	int ret;
>   	int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);
> @@ -27,9 +27,12 @@ int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
>   	ret = fn(dev, cmd, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>   		 value, index, data, size);
>   
> -	if (unlikely(ret < 0))
> +	if (unlikely(ret < size)) {
> +		ret = ret < 0 ? ret : -ENODATA;
> +
>   		netdev_warn(dev->net, "Failed to read reg index 0x%04x: %d\n",
>   			    index, ret);
> +	}
>   
>   	return ret;
>   }
> @@ -79,7 +82,7 @@ static int asix_check_host_enable(struct usbnet *dev, int in_pm)
>   				    0, 0, 1, &smsr, in_pm);
>   		if (ret == -ENODEV)
>   			break;
> -		else if (ret < sizeof(smsr))
> +		else if (ret < 0)
>   			continue;
>   		else if (smsr & AX_HOST_EN)
>   			break;
> @@ -579,8 +582,12 @@ int asix_mdio_read_nopm(struct net_device *netdev, int phy_id, int loc)
>   		return ret;
>   	}
>   
> -	asix_read_cmd(dev, AX_CMD_READ_MII_REG, phy_id,
> -		      (__u16)loc, 2, &res, 1);
> +	ret = asix_read_cmd(dev, AX_CMD_READ_MII_REG, phy_id,
> +			    (__u16)loc, 2, &res, 1);
> +	if (ret < 0) {
> +		mutex_unlock(&dev->phy_mutex);
> +		return ret;
> +	}
>   	asix_set_hw_mii(dev, 1);
>   	mutex_unlock(&dev->phy_mutex);
>   
> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> index 4514d35ef4c4..6b2fbdf4e0fd 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -755,7 +755,12 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
>   	priv->phy_addr = ret;
>   	priv->embd_phy = ((priv->phy_addr & 0x1f) == 0x10);
>   
> -	asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG, 0, 0, 1, &chipcode, 0);
> +	ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG, 0, 0, 1, &chipcode, 0);
> +	if (ret < 0) {
> +		netdev_dbg(dev->net, "Failed to read STATMNGSTS_REG: %d\n", ret);
> +		return ret;
> +	}
> +
>   	chipcode &= AX_CHIPCODE_MASK;
>   
>   	ret = (chipcode == AX_AX88772_CHIPCODE) ? ax88772_hw_reset(dev, 0) :
> @@ -920,11 +925,21 @@ static int ax88178_reset(struct usbnet *dev)
>   	int gpio0 = 0;
>   	u32 phyid;
>   
> -	asix_read_cmd(dev, AX_CMD_READ_GPIOS, 0, 0, 1, &status, 0);
> +	ret = asix_read_cmd(dev, AX_CMD_READ_GPIOS, 0, 0, 1, &status, 0);
> +	if (ret < 0) {
> +		netdev_dbg(dev->net, "Failed to read GPIOS: %d\n", ret);
> +		return ret;
> +	}
> +
>   	netdev_dbg(dev->net, "GPIO Status: 0x%04x\n", status);
>   
>   	asix_write_cmd(dev, AX_CMD_WRITE_ENABLE, 0, 0, 0, NULL, 0);
> -	asix_read_cmd(dev, AX_CMD_READ_EEPROM, 0x0017, 0, 2, &eeprom, 0);
> +	ret = asix_read_cmd(dev, AX_CMD_READ_EEPROM, 0x0017, 0, 2, &eeprom, 0);
> +	if (ret < 0) {
> +		netdev_dbg(dev->net, "Failed to read EEPROM: %d\n", ret);
> +		return ret;
> +	}
> +
>   	asix_write_cmd(dev, AX_CMD_WRITE_DISABLE, 0, 0, 0, NULL, 0);
>   
>   	netdev_dbg(dev->net, "EEPROM index 0x17 is 0x%04x\n", eeprom);




With regards,
Pavel Skripkin
