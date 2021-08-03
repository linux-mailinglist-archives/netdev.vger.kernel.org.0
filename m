Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F063DF16F
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236808AbhHCPaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236678AbhHCP3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 11:29:11 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E53C061764
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 08:28:58 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id f42so1151757lfv.7
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 08:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bF0IKp1x6+vyXjL7w7fWxeVGPrc00ljuT2/z3PeDzBQ=;
        b=ug3Hv2syP6snkQ6/4UBNllUaQtWXjg8cGuxgxQzF82qqbEr93jvkpKYA6O306pN0m8
         4n0mwBj86/LxyjN2UgeyEW3T5H8bahC3hXE4Pcl569m+k3uSdB/4aOsooGyGNoyEchuy
         1oeJPznTBrI8PXyg3iQf7XUmUdyhqXT+QRAviwaB+uxzTGJRlUlmywQ/Qt3nhfOHTRmq
         wsnv4OLZldaFwFXfRWAiiakjMSz3Fb3YUTv67ohT8Q6WcSFoDu5P4xpYAj3vFFWIOKYb
         ewShqnZJ0neUYyBnv+QbF53AhWV9WWl5cCej4qyst6jaAyoD1lPd7wDoIXSF76AM042Z
         jLRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bF0IKp1x6+vyXjL7w7fWxeVGPrc00ljuT2/z3PeDzBQ=;
        b=fuH+N+sjNY3R1ipLjniamrgbskyqwYXc04ZEj6cZ2/JxzGUzcK4Q3CXLs3Obg47tLA
         8zvRF29GBxGRk1hhsjwbEpdD9lFssh3hRXYtU6FxnG1f/DBis9AZNjdDTDTKsccn5AEx
         sGDK5FBmmIv6Zq/AFtoFFoNouKfio9Ss4nFb4YvSLVofAPiT0qeY0HSrGpdmAIjh69zQ
         Kzda7v+nnF7iNTfFbTJ16Q+Vqw8AHqFMEs2VAAYr7ug11nqdLowxpH62zzxd0sGYnr4N
         Fggc+iP6fr4oFsT6/YaRMU94jYq1fbRw2e3N+DNIxcViOuIlNfuN+gGEwRxZm6nkARvj
         5uAQ==
X-Gm-Message-State: AOAM531P/MOZfNJlB4/5/1nbXDvObuMpIYO154Kf9wgXNh3ovtzvXeE/
        j2MCqknLhPmLW4vrU0U3MyFL+fRiZbs=
X-Google-Smtp-Source: ABdhPJzlJItaBTDMCmIDef8js2jBHljRboaH6/QxMa2mr/MG+Ftr6ioYJlwrb7Hmlj8lVrW5fWbtgQ==
X-Received: by 2002:a19:a40c:: with SMTP id q12mr5697842lfc.203.1628004536645;
        Tue, 03 Aug 2021 08:28:56 -0700 (PDT)
Received: from localhost.localdomain ([94.103.226.235])
        by smtp.gmail.com with ESMTPSA id bt28sm166695lfb.195.2021.08.03.08.28.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 08:28:56 -0700 (PDT)
Subject: Re: [PATCH net 1/2] net: usb: pegasus: Check the return value of
 get_geristers() and friends;
To:     Petko Manolov <petko.manolov@konsulko.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        Petko Manolov <petkan@nucleusys.com>
References: <20210803150317.5325-1-petko.manolov@konsulko.com>
 <20210803150317.5325-2-petko.manolov@konsulko.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <eeb03520-f57a-1c78-fe84-0b72edea371f@gmail.com>
Date:   Tue, 3 Aug 2021 18:28:55 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210803150317.5325-2-petko.manolov@konsulko.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/21 6:03 PM, Petko Manolov wrote:
> From: Petko Manolov <petkan@nucleusys.com>
> 
> Certain call sites of get_geristers() did not do proper error handling.  This
> could be a problem as get_geristers() typically return the data via pointer to a
> buffer.  If an error occured the code is carelessly manipulating the wrong data.
> 
> Signed-off-by: Petko Manolov <petkan@nucleusys.com>

Hi, Petko!

This patch looks good to me, but I found few small mistakes

> ---
>   drivers/net/usb/pegasus.c | 102 ++++++++++++++++++++++++++------------
>   1 file changed, 70 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
> index 9a907182569c..924be11ee72c 100644
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

...

	if (i >= REG_TIMEOUT)
		goto fail;       <--- ret needs initialization here

...


>   	if (cmd & PHY_READ) {
>   		ret = get_registers(p, PhyData, 2, &regdi);
> +		if (ret < 0)
> +			goto fail;
>   		*regd = le16_to_cpu(regdi);
> -		return ret;
>   	}
>   	return 0;
>   fail:
> @@ -235,9 +246,13 @@ static int write_mii_word(pegasus_t *pegasus, __u8 phy, __u8 indx, __u16 *regd)
>   static int mdio_read(struct net_device *dev, int phy_id, int loc)
>   {
>   	pegasus_t *pegasus = netdev_priv(dev);
> +	int ret;
>   	u16 res;
>   
> -	read_mii_word(pegasus, phy_id, loc, &res);
> +	ret = read_mii_word(pegasus, phy_id, loc, &res);
> +	if (ret < 0)
> +		return ret;
> +
>   	return (int)res;
>   }
>   
> @@ -251,10 +266,9 @@ static void mdio_write(struct net_device *dev, int phy_id, int loc, int val)
>   
>   static int read_eprom_word(pegasus_t *pegasus, __u8 index, __u16 *retdata)
>   {
> -	int i;
> -	__u8 tmp = 0;
> +	int ret, i;
>   	__le16 retdatai;
> -	int ret;
> +	__u8 tmp = 0;
>   
>   	set_register(pegasus, EpromCtrl, 0);
>   	set_register(pegasus, EpromOffset, index);
> @@ -262,21 +276,25 @@ static int read_eprom_word(pegasus_t *pegasus, __u8 index, __u16 *retdata)
>   
>   	for (i = 0; i < REG_TIMEOUT; i++) {
>   		ret = get_registers(pegasus, EpromCtrl, 1, &tmp);
> +		if (ret < 0)
> +			goto fail;
>   		if (tmp & EPROM_DONE)
>   			break;
> -		if (ret == -ESHUTDOWN)
> -			goto fail;
>   	}
> -	if (i >= REG_TIMEOUT)
> +	if (i >= REG_TIMEOUT) {
> +		ret = -ETIMEDOUT;
>   		goto fail;
> +	}
>   
>   	ret = get_registers(pegasus, EpromData, 2, &retdatai);
> +	if (ret < 0)
> +		goto fail;
>   	*retdata = le16_to_cpu(retdatai);
>   	return ret;
>   
>   fail:
> -	netif_warn(pegasus, drv, pegasus->net, "%s failed\n", __func__);
> -	return -ETIMEDOUT;
> +	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
> +	return ret;
>   }
>   
>   #ifdef	PEGASUS_WRITE_EEPROM
> @@ -324,10 +342,10 @@ static int write_eprom_word(pegasus_t *pegasus, __u8 index, __u16 data)
>   	return ret;
>   
>   fail:
> -	netif_warn(pegasus, drv, pegasus->net, "%s failed\n", __func__);
> +	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
>   	return -ETIMEDOUT;
>   }
> -#endif				/* PEGASUS_WRITE_EEPROM */
> +#endif	/* PEGASUS_WRITE_EEPROM */
>   
>   static inline int get_node_id(pegasus_t *pegasus, u8 *id)
>   {
> @@ -367,19 +385,21 @@ static void set_ethernet_addr(pegasus_t *pegasus)
>   	return;
>   err:
>   	eth_hw_addr_random(pegasus->net);
> -	dev_info(&pegasus->intf->dev, "software assigned MAC address.\n");
> +	netif_dbg(pegasus, drv, pegasus->net, "software assigned MAC address.\n");
>   
>   	return;
>   }
>   
>   static inline int reset_mac(pegasus_t *pegasus)
>   {
> +	int ret, i;
>   	__u8 data = 0x8;
> -	int i;
>   
>   	set_register(pegasus, EthCtrl1, data);
>   	for (i = 0; i < REG_TIMEOUT; i++) {
> -		get_registers(pegasus, EthCtrl1, 1, &data);
> +		ret = get_registers(pegasus, EthCtrl1, 1, &data);
> +		if (ret < 0)
> +			goto fail;
>   		if (~data & 0x08) {
>   			if (loopback)
>   				break;
> @@ -402,22 +422,29 @@ static inline int reset_mac(pegasus_t *pegasus)
>   	}
>   	if (usb_dev_id[pegasus->dev_index].vendor == VENDOR_ELCON) {
>   		__u16 auxmode;
> -		read_mii_word(pegasus, 3, 0x1b, &auxmode);
> +		ret = read_mii_word(pegasus, 3, 0x1b, &auxmode);
> +		if (ret < 0)
> +			goto fail;
>   		auxmode |= 4;
>   		write_mii_word(pegasus, 3, 0x1b, &auxmode);
>   	}
>   
>   	return 0;
> +fail:
> +	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
> +	return ret;
>   }
>   
>   static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
>   {
> -	__u16 linkpart;
> -	__u8 data[4];
>   	pegasus_t *pegasus = netdev_priv(dev);
>   	int ret;
> +	__u16 linkpart;
> +	__u8 data[4];
>   
> -	read_mii_word(pegasus, pegasus->phy, MII_LPA, &linkpart);
> +	ret = read_mii_word(pegasus, pegasus->phy, MII_LPA, &linkpart);
> +	if (ret < 0)
> +		goto fail;
>   	data[0] = 0xc8; /* TX & RX enable, append status, no CRC */
>   	data[1] = 0;
>   	if (linkpart & (ADVERTISE_100FULL | ADVERTISE_10FULL))
> @@ -435,11 +462,16 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
>   	    usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS2 ||
>   	    usb_dev_id[pegasus->dev_index].vendor == VENDOR_DLINK) {
>   		u16 auxmode;
> -		read_mii_word(pegasus, 0, 0x1b, &auxmode);
> +		ret = read_mii_word(pegasus, 0, 0x1b, &auxmode);
> +		if (ret < 0)
> +			goto fail;
>   		auxmode |= 4;
>   		write_mii_word(pegasus, 0, 0x1b, &auxmode);
>   	}
>   
> +	return 0;
> +fail:
> +	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
>   	return ret;
>   }
>   
> @@ -447,9 +479,9 @@ static void read_bulk_callback(struct urb *urb)
>   {
>   	pegasus_t *pegasus = urb->context;
>   	struct net_device *net;
> +	u8 *buf = urb->transfer_buffer;
>   	int rx_status, count = urb->actual_length;
>   	int status = urb->status;
> -	u8 *buf = urb->transfer_buffer;
>   	__u16 pkt_len;
>   
>   	if (!pegasus)
> @@ -998,8 +1030,7 @@ static int pegasus_ioctl(struct net_device *net, struct ifreq *rq, int cmd)
>   		data[0] = pegasus->phy;
>   		fallthrough;
>   	case SIOCDEVPRIVATE + 1:
> -		read_mii_word(pegasus, data[0], data[1] & 0x1f, &data[3]);
> -		res = 0;
> +		res = read_mii_word(pegasus, data[0], data[1] & 0x1f, &data[3]);
>   		break;
>   	case SIOCDEVPRIVATE + 2:
>   		if (!capable(CAP_NET_ADMIN))
> @@ -1033,22 +1064,25 @@ static void pegasus_set_multicast(struct net_device *net)
>   
>   static __u8 mii_phy_probe(pegasus_t *pegasus)
>   {
> -	int i;
> +	int i, ret;
>   	__u16 tmp;
>   
>   	for (i = 0; i < 32; i++) {
> -		read_mii_word(pegasus, i, MII_BMSR, &tmp);
> +		ret = read_mii_word(pegasus, i, MII_BMSR, &tmp)

Semicolon missing

> +		if (ret < 0)
> +			goto out;


Should be "goto fail;"			

>   		if (tmp == 0 || tmp == 0xffff || (tmp & BMSR_MEDIA) == 0)
>   			continue;
>   		else
>   			return i;
>   	}
> -
> +fail:
>   	return 0xff;
>   }
>   
>   static inline void setup_pegasus_II(pegasus_t *pegasus)
>   {
> +	int ret;
>   	__u8 data = 0xa5;
>   
>   	set_register(pegasus, Reg1d, 0);
> @@ -1060,7 +1094,9 @@ static inline void setup_pegasus_II(pegasus_t *pegasus)
>   		set_register(pegasus, Reg7b, 2);
>   
>   	set_register(pegasus, 0x83, data);
> -	get_registers(pegasus, 0x83, 1, &data);
> +	ret = get_registers(pegasus, 0x83, 1, &data);
> +	if (ret < 0)
> +		goto fail;
>   
>   	if (data == 0xa5)
>   		pegasus->chip = 0x8513;
> @@ -1075,6 +1111,8 @@ static inline void setup_pegasus_II(pegasus_t *pegasus)
>   		set_register(pegasus, Reg81, 6);
>   	else
>   		set_register(pegasus, Reg81, 2);

There should be "return" before fail label, I guess.

> +fail:
> +	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
>   }
>   
>   static void check_carrier(struct work_struct *work)
>




With regards,
Pavel Skripkin
