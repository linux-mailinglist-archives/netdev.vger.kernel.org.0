Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEC93DE261
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 00:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhHBWSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 18:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbhHBWSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 18:18:51 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57136C06175F;
        Mon,  2 Aug 2021 15:18:40 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id t9so23450946lfc.6;
        Mon, 02 Aug 2021 15:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0Y6mLId8/eNaU2rxoPkMHiRy8LVDM741u6TqTI08CsI=;
        b=CHcsBFqJZQAMXuAjzF2b+4iaxbrp7ylgY6pNGmlqoI/stOw2MZ/wCxZ+XvIEqITY+V
         0H9QnajKyk88xeZsureSZy7sKtGYkk7vej9sILgkXdLGM7dNnIOgmnzb25mQQF7tL+JJ
         FiNvCeJzH9PWhQLkG0lp+auwhCtmwSbNhtrbIQYReqXo4ctJEkAOquRz7+uK24R9F5qN
         kEpRSmSN2UNZDlMHe1xNI+Z0J3T1pmIeLEYtzBuMPDEgWz3iX9WwxrKu7BGPx6Lrl9Nd
         5eVjSuKMW9VW9QfEzqFT+3JsC/nEuFL/qOIA/7npBqx6uiIT8b1vt36r/1Dvn2+AdEdZ
         vXqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0Y6mLId8/eNaU2rxoPkMHiRy8LVDM741u6TqTI08CsI=;
        b=rREEfh7lX/H7imVrAgPTAheSVsbWKlfNxITngME3BBC3CTJbS/b0m/aMwA/CKaheWu
         W5OrMT58rI/aoEvACw+0sMe7FG6f0eNEoD8hUuXirNLKbhClRQHUr7RgcuJolLd6oCVo
         eSg5A8+AsoVNLAau4E/IPPtED1d1i8x5fFUza3+iBlvuNCoVWoRD1t1zZ2nZ+yjdd9tu
         1jRhRmRC1OMJeaMnqL1NoZ7nNZ4SODbuGO2xJ0UVoHfnxdrE1ORFOohOSUZ8EAfAz+3X
         dABl0pklg4PcpKL7ZW4qWyQebQal1jf+CsFivfVRmfhLW3OZIr6Gvz2+cuznHbFa6q7m
         nM3w==
X-Gm-Message-State: AOAM5300+u0DV6fhKSQNWUXNvzBUP/CdLTh/OiDD835TFcL789Kn6+Pw
        KdZDpwv1j78hkcD76huUMYM=
X-Google-Smtp-Source: ABdhPJxarDMzpPz27uQ5kENblh8KcS9u5e/v0B2bMsgkuZnKGLHBrMlnceBhOu+j0VJyYhrKRUacNQ==
X-Received: by 2002:a05:6512:b84:: with SMTP id b4mr6952061lfv.186.1627942718656;
        Mon, 02 Aug 2021 15:18:38 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.225.185])
        by smtp.gmail.com with ESMTPSA id l21sm948252ljc.94.2021.08.02.15.18.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 15:18:38 -0700 (PDT)
Subject: Re: [PATCH] net: pegasus: fix uninit-value in get_interrupt_interval
To:     davem@davemloft.net, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+02c9f70f3afae308464a@syzkaller.appspotmail.com
References: <20210730214411.1973-1-paskripkin@gmail.com>
 <YQaVS5UwG6RFsL4t@carbon> <20210801223513.06bede26@gmail.com>
 <YQhQe4bdoEAef8bj@carbon>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <56e4a418-2e33-43f1-45e6-fa1dcc92060f@gmail.com>
Date:   Tue, 3 Aug 2021 01:18:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQhQe4bdoEAef8bj@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/21 11:07 PM, Petko Manolov wrote:
> On 21-08-01 22:35:13, Pavel Skripkin wrote:
>> On Sun, 1 Aug 2021 15:36:27 +0300
>> Petko Manolov <petkan@nucleusys.com> wrote:
>> 
>> > On 21-07-31 00:44:11, Pavel Skripkin wrote:
>> > > Syzbot reported uninit value pegasus_probe(). The problem was in missing
>> > > error handling.
>> > > 
>> > > get_interrupt_interval() internally calls read_eprom_word() which can fail
>> > > in some cases. For example: failed to receive usb control message. These
>> > > cases should be handled to prevent uninit value bug, since
>> > > read_eprom_word() will not initialize passed stack variable in case of
>> > > internal failure.
>> > 
>> > Well, this is most definitelly a bug.
>> > 
>> > ACK!
>> > 
>> > 
>> > 		Petko
>> > 
>> > 
>> 
>> Thank you, Petko!
>> 
>> 
>> BTW: I found a lot uses of {get,set}_registers without error checking. I
>> think, some of them could be fixed easily (like in enable_eprom_write), but, I
>> guess, disable_eprom_write is not so easy. For example, if we cannot disable
>> eprom should we retry? If not, will device get in some unexpected state?
>> 
>> Im not familiar with this device, but I can prepare a patch to wrap all these
>> calls with proper error checking
> 
> Here goes a preliminary patch that should apply on top of your, maybe with just
> a few warnings.  This is a review only diff, not the real patch.  It's against
> 5.14-rc4.
> 
> I am mildly curious why syzbot didn't catch the same type of bug in
> enable_net_traffic() and setup_pegasus_II() for example.
> 
> 
> 		Petko
> 
> ---
> 
> diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
> index 9a907182569c..eafbe8107907 100644
> --- a/drivers/net/usb/pegasus.c
> +++ b/drivers/net/usb/pegasus.c
> @@ -26,6 +26,8 @@
>    *		...
>    *		v0.9.3	simplified [get|set]_register(s), async update registers
>    *			logic revisited, receive skb_pool removed.
> + *		v1.0.1	add error checking for set_register(s)(), see if calling
> + *			get_registers() has failed and print a message accordingly.
>    */
>   
>   #include <linux/sched.h>
> @@ -45,7 +47,7 @@
>   /*
>    * Version Information
>    */
> -#define DRIVER_VERSION "v0.9.3 (2013/04/25)"
> +#define DRIVER_VERSION "v1.0.1 (2021/08/01)"
>   #define DRIVER_AUTHOR "Petko Manolov <petkan@nucleusys.com>"
>   #define DRIVER_DESC "Pegasus/Pegasus II USB Ethernet driver"
>   
> @@ -132,9 +134,15 @@ static int get_registers(pegasus_t *pegasus, __u16 indx, __u16 size, void *data)
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
> @@ -145,10 +153,15 @@ static int set_registers(pegasus_t *pegasus, __u16 indx, __u16 size,
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
> @@ -188,10 +201,9 @@ static int update_eth_regs_async(pegasus_t *pegasus)
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
> @@ -211,8 +223,9 @@ static int __mii_op(pegasus_t *p, __u8 phy, __u8 indx, __u16 *regd, __u8 cmd)
>   		goto fail;
>   	if (cmd & PHY_READ) {
>   		ret = get_registers(p, PhyData, 2, &regdi);
> +		if (ret < 0)
> +			goto fail;
>   		*regd = le16_to_cpu(regdi);
> -		return ret;
>   	}
>   	return 0;
>   fail:
> @@ -235,9 +248,13 @@ static int write_mii_word(pegasus_t *pegasus, __u8 phy, __u8 indx, __u16 *regd)
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
> @@ -251,10 +268,9 @@ static void mdio_write(struct net_device *dev, int phy_id, int loc, int val)
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
> @@ -262,21 +278,25 @@ static int read_eprom_word(pegasus_t *pegasus, __u8 index, __u16 *retdata)
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
> @@ -324,10 +344,10 @@ static int write_eprom_word(pegasus_t *pegasus, __u8 index, __u16 data)
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
> @@ -367,19 +387,21 @@ static void set_ethernet_addr(pegasus_t *pegasus)
>   	return;
>   err:
>   	eth_hw_addr_random(pegasus->net);
> -	dev_info(&pegasus->intf->dev, "software assigned MAC address.\n");
> +	netif_dbg(pegasus, drv, pegasus->net, "software assigned MAC address.\n");
>   
>   	return;
>   }

Not related to the patch, but, maybe, we should remove this return?

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
> @@ -402,22 +424,29 @@ static inline int reset_mac(pegasus_t *pegasus)
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
> @@ -435,11 +464,16 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
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
> @@ -447,9 +481,9 @@ static void read_bulk_callback(struct urb *urb)
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
> @@ -1049,6 +1083,7 @@ static __u8 mii_phy_probe(pegasus_t *pegasus)
>   
>   static inline void setup_pegasus_II(pegasus_t *pegasus)
>   {
> +	int ret;
>   	__u8 data = 0xa5;
>   
>   	set_register(pegasus, Reg1d, 0);
> @@ -1060,7 +1095,9 @@ static inline void setup_pegasus_II(pegasus_t *pegasus)
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
> @@ -1075,6 +1112,8 @@ static inline void setup_pegasus_II(pegasus_t *pegasus)
>   		set_register(pegasus, Reg81, 6);
>   	else
>   		set_register(pegasus, Reg81, 2);
> +fail:
> +	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
>   }
>   
>   static void check_carrier(struct work_struct *work)
> 

Looks good to me.

Build test didn't generate any warnings (tested on top of v5.14-rc4 with 
yours and mine patches applied). Smatch didn't generate any warnings as 
well.

I found two more places, where read_mii_word() is used without error 
checking: pegasus_ioctl() and mii_phy_probe(). If I understand 
correctly, mii_phy_probe() is more dangerous one, since it's used in 
->probe().


With regards,
Pavel Skripkin
