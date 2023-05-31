Return-Path: <netdev+bounces-6837-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 60C7C7185F4
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:18:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD7EB1C20DA8
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:18:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C62D171A4;
	Wed, 31 May 2023 15:18:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBD316438
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:18:13 +0000 (UTC)
X-Greylist: delayed 479 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 31 May 2023 08:18:06 PDT
Received: from ci74p00im-qukt09082502.me.com (ci74p00im-qukt09082502.me.com [17.57.156.15])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956CD13E
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pen.gy; s=sig1;
	t=1685545807; bh=JUj4mjEaKZ9F8+bIZI/ye5Fq3ZjW6y4YvwpnDxx5GRg=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	b=WIJ6mXVTARqEMk7U1j6Y4flyZ2y/EjUPUQ8OtqpR1cnc+q/OcI9E5AcaB4UEXuk4d
	 9nieyn9WTPc6vYnP6EbEK+UNotRQtwT/9jQDV5Shc4Zelc8a3CyOY/UuYQPufVInLU
	 jktz8W6G4xoKrQ6t84Gv8A34MtXHnBkkp22Nq6ryvljwWqRuoeOzqrWWD6sMwKCDDu
	 ZEg1fKu4tKosHXxIbI6pUzfIilLALhPodVAvF7Hl9HazuJmLvZYIV1PMIb2J5/bfmn
	 IbsauQmMxUQ0bBneNXimu5ufHB5sdAkFW3ROAn7xEqYiqe1pzOuhQmijmt0Qe2yhTN
	 B4Sy9eDMP88GQ==
Received: from [192.168.40.3] (ci77p00im-dlb-asmtp-mailmevip.me.com [17.57.156.26])
	by ci74p00im-qukt09082502.me.com (Postfix) with ESMTPSA id A373111C05A4;
	Wed, 31 May 2023 15:10:04 +0000 (UTC)
Message-ID: <581e4f2e-c6e3-026b-7a51-968afb616a7e@pen.gy>
Date: Wed, 31 May 2023 17:10:01 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 2/2] usbnet: ipheth: add CDC NCM support
Content-Language: en-GB
To: Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>
Cc: Georgi Valkov <gvalkov@gmail.com>,
 Simon Horman <simon.horman@corigine.com>, Jan Kiszka
 <jan.kiszka@siemens.com>, linux-usb@vger.kernel.org, netdev@vger.kernel.org
References: <20230527130309.34090-1-forst@pen.gy>
 <20230527130309.34090-2-forst@pen.gy>
 <Hpg7Nwtv7aepWNQuwyGiCoXT2ScF0xBHsfvNBP7ytjXH6O-UIgpz_V7NoHsO00bS5bzlq_W5LUeEOhRO4eZd6w==@protonmail.internalid>
 <e7159f2e39e79e51da123d09cfbcc21411dad544.camel@redhat.com>
From: Foster Snowhill <forst@pen.gy>
Autocrypt: addr=forst@pen.gy; keydata=
 xjMEYB86GRYJKwYBBAHaRw8BAQdAx9dMHkOUP+X9nop8IPJ1RNiEzf20Tw4HQCV4bFSITB7N
 G2ZvcnN0QHBlbi5neSA8Zm9yc3RAcGVuLmd5PsKPBBAWCgAgBQJgHzoZBgsJBwgDAgQVCAoC
 BBYCAQACGQECGwMCHgEAIQkQfZTG0T8MQtgWIQTYzKaDAhzR7WvpGD59lMbRPwxC2EQWAP9M
 XyO82yS1VO/DWKLlwOH4I87JE1wyUoNuYSLdATuWvwD8DRbeVIaCiSPZtnwDKmqMLC5sAddw
 1kDc4FtMJ5R88w7OOARgHzoZEgorBgEEAZdVAQUBAQdARX7DpC/YwQVQLTUGBaN0QuMwx9/W
 0WFYWmLGrrm6CioDAQgHwngEGBYIAAkFAmAfOhkCGwwAIQkQfZTG0T8MQtgWIQTYzKaDAhzR
 7WvpGD59lMbRPwxC2BqxAQDWMSnhYyJTji9Twic7n+vnady9mQIy3hdB8Dy1yDj0MgEA0DZf
 OsjaMQ1hmGPmss4e3lOGsmfmJ49io6ornUzJTQ0=
In-Reply-To: <e7159f2e39e79e51da123d09cfbcc21411dad544.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: JEwYAIrrxLlPk3B3LZ5SKVe_lE7UtcU7
X-Proofpoint-ORIG-GUID: JEwYAIrrxLlPk3B3LZ5SKVe_lE7UtcU7
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.790,17.11.62.513.0000000_definitions?=
 =?UTF-8?Q?=3D2022-01-12=5F03:2020-02-14=5F02,2022-01-12=5F03,2021-12-02?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=243 spamscore=0 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 mlxscore=0 clxscore=1030
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2305310129
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Paolo,

Thank you for the review!

>> -	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN,
>> +	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_RX_BUF_SIZE,
> 
> Here the driver already knows if the device is in NCM or legacy mode,
> so perhaps we could select the buffer size accordingly? You would
> probably need to store the actual buffer size somewhere to keep the
> buffer handling consistent and simple in later code.

Agreed, I will make the buffer size dynamic in the next revision.

The RX buffer size is 1516 bytes for legacy mode (2 bytes padding +
1514 bytes Ethernet frame), and 65536 bytes for NCM mode.

>>  	memcpy(dev->tx_buf, skb->data, skb->len);
>> -	if (skb->len < IPHETH_BUF_SIZE)
>> -		memset(dev->tx_buf + skb->len, 0, IPHETH_BUF_SIZE - skb->len);
>>
>>  	usb_fill_bulk_urb(dev->tx_urb, udev,
>>  			  usb_sndbulkpipe(udev, dev->bulk_out),
>> -			  dev->tx_buf, IPHETH_BUF_SIZE,
>> +			  dev->tx_buf, skb->len,
>>  			  ipheth_sndbulk_callback,
>>  			  dev);
>>  	dev->tx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> 
> This chunk looks unrelated from NCM support, and unconditionally
> changes the established behaviour even with legacy mode, why?
> 
> Does that works even with old(er) devices?

I see Georgi Valkov said he tested v3 of the patch on older iOS devices
and confirmed it working. I'll chat with him to get some USB traffic
captures, to check what is macOS' behaviour with such devices (to make
sure we behave the same way as the official driver). I also wanted to
investigate a bit, when was NCM support even added to iOS.

Personally I remember testing this in legacy mode a while ago, before
I implemented NCM. I will re-test it again in legacy mode in addition
to Georgi's efforts.

From my side, I think it's reasonable to split this out into a separate
patch, since it technically applies to the legacy mode as well, and
doesn't (directly) relate to NCM support, as you pointed out.

There's no reason to send the full buffer every time including padding,
but I'll check out traffic captures on macOS + older devices, maybe
that's what they're doing.

