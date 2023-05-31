Return-Path: <netdev+bounces-6797-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC27071812F
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:14:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5435C1C20E90
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 13:14:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F0D214296;
	Wed, 31 May 2023 13:14:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A36DA936
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 13:14:55 +0000 (UTC)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E2C97;
	Wed, 31 May 2023 06:14:53 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f6148e501dso11265285e9.1;
        Wed, 31 May 2023 06:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685538892; x=1688130892;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FE8vfd27NzOmqDwn14Kq37kbonQDA4TclFm5GJMMesY=;
        b=pEAZzgkaxcYXgx4U/3TAYbqgzPplz3n6NKWwKRPJE4/YDe6dO1ewmXrk3giub39laW
         2h5+dZc/n4kx0OC5rILRtfKNmX8pv2tS5AfHvxjsAjxtX9N8vVMT/N9a2UxT2FxGmOCg
         P+AzAGm8BO/K1fg6saJYNFnmyUVbJsSo8sWAeP6AFy95rp5PCdseJXG88rlh7AhGTc4B
         4Glfagh+T7yPkUCwH91bVQOP2HhjM/ra3XlFSb5RXdwxJLwSbZSly39XjYe9VGpKd+Xq
         JPPFkR0fF2LDq5DMntpRT57NEwJuKuQBtI9MAm57uOVS8caHwhfwbX7xBLGzFN5Crjrj
         xa7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685538892; x=1688130892;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FE8vfd27NzOmqDwn14Kq37kbonQDA4TclFm5GJMMesY=;
        b=OgcExBLFtfMkRIjwJusS5jJOS22g8QiuoPEysIdmH15C5ULWCofDcHZUF/BXu5CV1s
         uDZR4DmR+Yd0bwSUYEhxJ8FufsbyQ95opMJpL3iD4chQ1pKVREmTvMYylWHWNueJqaRt
         miX0rBdJ2YehFTAGo29A80d24tIjOyfJTK9uDbED3Lx/B+3C60vHCQQoT8l1oU95w7wE
         CW3FbzRFQrm6xneOyrAG8oi5d2oZqdvo8M9EuSFXHkgbQFVpY5TC6v+6nmC/6uOrdvWY
         MzPHsBENH+bDgfRy1jGPbm9dZsx9Aqiq902ebeha1zKIgSdPOsmc97LxSqsdK1kOpncU
         /rIQ==
X-Gm-Message-State: AC+VfDy85LRLkYnsyrnQclH/Awe/dDVcvp5hPiG7kutMS44hYPgvotkO
	+l0yYITb9CuGWI+zZH1zyLA=
X-Google-Smtp-Source: ACHHUZ7dMovGUs1BxbKlpaWffWIPQ0cccdzVna+phGPIAR9+3tuDG6FTBI97B8V04TwRUYShFz0X8A==
X-Received: by 2002:a05:600c:1f86:b0:3f6:335:d8e1 with SMTP id je6-20020a05600c1f8600b003f60335d8e1mr2588709wmb.2.1685538891967;
        Wed, 31 May 2023 06:14:51 -0700 (PDT)
Received: from smtpclient.apple (212-5-158-116.ip.btc-net.bg. [212.5.158.116])
        by smtp.gmail.com with ESMTPSA id h6-20020a1ccc06000000b003f7191da579sm103779wmb.42.2023.05.31.06.14.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 May 2023 06:14:51 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [PATCH net-next v3 2/2] usbnet: ipheth: add CDC NCM support
From: George Valkov <gvalkov@gmail.com>
In-Reply-To: <e7159f2e39e79e51da123d09cfbcc21411dad544.camel@redhat.com>
Date: Wed, 31 May 2023 16:14:38 +0300
Cc: Foster Snowhill <forst@pen.gy>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <simon.horman@corigine.com>,
 Jan Kiszka <jan.kiszka@siemens.com>,
 linux-usb <linux-usb@vger.kernel.org>,
 Linux Netdev List <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <9D068F77-4349-4285-BDE8-3DCFC45DB7E6@gmail.com>
References: <20230527130309.34090-1-forst@pen.gy>
 <20230527130309.34090-2-forst@pen.gy>
 <e7159f2e39e79e51da123d09cfbcc21411dad544.camel@redhat.com>
To: Paolo Abeni <pabeni@redhat.com>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Georgi Valkov
httpstorm.com
nano RTOS



> On 30 May 2023, at 1:58 PM, Paolo Abeni <pabeni@redhat.com> wrote:
>=20
> Hi,
>=20
> On Sat, 2023-05-27 at 15:03 +0200, Foster Snowhill wrote:
>> @@ -116,12 +124,12 @@ static int ipheth_alloc_urbs(struct =
ipheth_device *iphone)
>> if (rx_urb =3D=3D NULL)
>> goto free_tx_urb;
>>=20
>> - tx_buf =3D usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE,
>> + tx_buf =3D usb_alloc_coherent(iphone->udev, IPHETH_TX_BUF_SIZE,
>>    GFP_KERNEL, &tx_urb->transfer_dma);
>> if (tx_buf =3D=3D NULL)
>> goto free_rx_urb;
>>=20
>> - rx_buf =3D usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE + =
IPHETH_IP_ALIGN,
>> + rx_buf =3D usb_alloc_coherent(iphone->udev, IPHETH_RX_BUF_SIZE,
>>    GFP_KERNEL, &rx_urb->transfer_dma);
>> if (rx_buf =3D=3D NULL)
>> goto free_tx_buf;
>=20
> Here the driver already knows if the device is in NCM or legacy mode,
> so perhaps we could select the buffer size accordingly? You would
> probably need to store the actual buffer size somewhere to keep the
> buffer handling consistent and simple in later code.
>=20
>> @@ -373,12 +489,10 @@ static netdev_tx_t ipheth_tx(struct sk_buff =
*skb, struct net_device *net)
>> }
>>=20
>> memcpy(dev->tx_buf, skb->data, skb->len);
>> - if (skb->len < IPHETH_BUF_SIZE)
>> - memset(dev->tx_buf + skb->len, 0, IPHETH_BUF_SIZE - skb->len);
>>=20
>> usb_fill_bulk_urb(dev->tx_urb, udev,
>>  usb_sndbulkpipe(udev, dev->bulk_out),
>> -  dev->tx_buf, IPHETH_BUF_SIZE,
>> +  dev->tx_buf, skb->len,
>>  ipheth_sndbulk_callback,
>>  dev);
>> dev->tx_urb->transfer_flags |=3D URB_NO_TRANSFER_DMA_MAP;
>=20
> This chunk looks unrelated from NCM support, and unconditionally
> changes the established behaviour even with legacy mode, why?
>=20
> Does that works even with old(er) devices?

Yes,
Tested-on: iPhone 7 Plus, iOS 15.7.6
Testen-on: iPhone 4s, iOS 8.4
Tested-on: iPhone 3G, iOS 4.2.1

All work without any issues.


