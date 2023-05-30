Return-Path: <netdev+bounces-6334-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 184D9715CBC
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:11:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AABC11C20BB0
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:11:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 326F217728;
	Tue, 30 May 2023 11:11:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F11174FF
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:11:56 +0000 (UTC)
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC9DE5;
	Tue, 30 May 2023 04:11:50 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-30ad48957f5so634949f8f.1;
        Tue, 30 May 2023 04:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685445108; x=1688037108;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=jGuM0Qb5XQCYlcPeCqFivWAij9A8iPVD0+94q09YcBM=;
        b=LlilW/Co/9Rjp+C0HtRQDmUGeJW41wZeIAC7pz4UyDqXOqOXpO7GOnEl/ksfPEyxGD
         Hw0qbTLhLPrRD17SBZo7Ppd02wNHZltBT9tMOkQbiytNmevIh2MQWPi6LAER/iY/D8CQ
         UZWThVIePWWkDW1CQJBSaK5Q5+uDhHZ7/SfERb+oY8hJSD2ECb/4i8Xqa8cbX8x/HGSS
         mfy5rVxQqnIYT+by+7SbO8wXWxooBZfmpduNAQatQgpKzrLT0nws0BNNg+wByWKuFo/9
         q06W76JxR6CTVNNFrWpV5f6l5YA90BD3y9OxcHxDQfF29EMm2K1UnwL8u11JWLuLL4BO
         WO7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685445108; x=1688037108;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jGuM0Qb5XQCYlcPeCqFivWAij9A8iPVD0+94q09YcBM=;
        b=jrdJkTPSWdL8WW0ckxszRdzAKP8KyFyV4t9oeA2k+xLSiT/fHEHdIOshNhvFKPPrN2
         9TCwO/jB6k9S9suOKKqQ3GTPi64FF2inDwMytRXv58P+u28ztszjCf1/sFI+p2W7/C8/
         wIjTa3EDfE22FtpSOHztlHx2Vat0iy11jqSDlJ4Xvzy8lmMkOW5AFIrIqpIvqkI0qCfp
         0UiOiVNHoYNn3mdUQQem9Iu9/LGOgt1RegRd5X5bRmXecq8Asvlg5OMYCYG/dHQHSTu+
         TMsGoyFL43H4rh+uet7utiHRhGJp0oAc7tuo91w/tGuqHC43j6szLEt1Ak688EBLNAke
         nOXg==
X-Gm-Message-State: AC+VfDwHwjs5TfxvTRwOuYMlAjn9uZ8wVzoUbE8XvSmZ+Xje6icIHTt7
	/2TksXkd5+oP035tkBJHbm4=
X-Google-Smtp-Source: ACHHUZ4vLiVqTIz+19OPvOyCpReIq5kCqDRhpf6w6/xbRRtee+eHK8ARwn5To3AmRXEHLQuWpuEKZQ==
X-Received: by 2002:adf:f3c5:0:b0:30a:e55c:1e8e with SMTP id g5-20020adff3c5000000b0030ae55c1e8emr1074539wrp.2.1685445108442;
        Tue, 30 May 2023 04:11:48 -0700 (PDT)
Received: from smtpclient.apple (212-5-158-75.ip.btc-net.bg. [212.5.158.75])
        by smtp.gmail.com with ESMTPSA id j18-20020a5d4492000000b002ffbf2213d4sm2927317wrq.75.2023.05.30.04.11.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 May 2023 04:11:47 -0700 (PDT)
From: George Valkov <gvalkov@gmail.com>
Message-Id: <A4F3E461-E5BE-4707-B63A-BD6AAC3DBD02@gmail.com>
Content-Type: multipart/mixed;
	boundary="Apple-Mail=_C11E7C7F-87BD-472F-9893-7A87CA263056"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [PATCH net-next v3 1/2] usbnet: ipheth: fix risk of NULL pointer
 deallocation
Date: Tue, 30 May 2023 14:11:36 +0300
In-Reply-To: <0f7a8b0c149daa49c34a817cc24d1d58acedb9f4.camel@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <simon.horman@corigine.com>,
 Jan Kiszka <jan.kiszka@siemens.com>,
 linux-usb <linux-usb@vger.kernel.org>,
 Linux Netdev List <netdev@vger.kernel.org>
To: Paolo Abeni <pabeni@redhat.com>,
 Foster Snowhill <forst@pen.gy>
References: <20230527130309.34090-1-forst@pen.gy>
 <0f7a8b0c149daa49c34a817cc24d1d58acedb9f4.camel@redhat.com>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--Apple-Mail=_C11E7C7F-87BD-472F-9893-7A87CA263056
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

Hi Paolo!
Sorry, I attached the old version by mistake. Here is the new version:


--Apple-Mail=_C11E7C7F-87BD-472F-9893-7A87CA263056
Content-Disposition: attachment;
	filename=0001-usbnet-ipheth-cleanup-the-initialization-error-path.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="0001-usbnet-ipheth-cleanup-the-initialization-error-path.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=2009300ea33347fb07097417e3586494b632267a19=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Georgi=20Valkov=20<gvalkov@gmail.com>=0ADate:=20=
Thu,=2025=20May=202023=2021:23:12=20+0200=0ASubject:=20[PATCH=20net-next=20=
v4=201/2]=20usbnet:=20ipheth:=20cleanup=20the=20initialization=20error=20=
path=0A=0AThe=20cleanup=20precedure=20in=20ipheth_probe=20will=20attempt=20=
to=20free=20a=0ANULL=20pointer=20in=20dev->ctrl_buf=20if=20the=20memory=20=
allocation=20for=0Athis=20buffer=20is=20not=20successful.=20While=20=
kfree=20ignores=20NULL=20pointers,=0Aand=20the=20existing=20code=20is=20=
safe,=20it=20is=20a=20better=20design=20to=20rearrange=0Athe=20goto=20=
labels=20and=20avoid=20this.=0A=0ASigned-off-by:=20Georgi=20Valkov=20=
<gvalkov@gmail.com>=0ASigned-off-by:=20Foster=20Snowhill=20=
<forst@pen.gy>=0A---=0A=20drivers/net/usb/ipheth.c=20|=202=20+-=0A=201=20=
file=20changed,=201=20insertion(+),=201=20deletion(-)=0A=0Adiff=20--git=20=
a/drivers/net/usb/ipheth.c=20b/drivers/net/usb/ipheth.c=0Aindex=20=
6a769df0b421..8875a3d0e6d9=20100644=0A---=20a/drivers/net/usb/ipheth.c=0A=
+++=20b/drivers/net/usb/ipheth.c=0A@@=20-510,8=20+510,8=20@@=20static=20=
int=20ipheth_probe(struct=20usb_interface=20*intf,=0A=20=09=
ipheth_free_urbs(dev);=0A=20err_alloc_urbs:=0A=20err_get_macaddr:=0A=
-err_alloc_ctrl_buf:=0A=20=09kfree(dev->ctrl_buf);=0A=
+err_alloc_ctrl_buf:=0A=20err_endpoints:=0A=20=09free_netdev(netdev);=0A=20=
=09return=20retval;=0A--=20=0A2.40.1=0A=0A=

--Apple-Mail=_C11E7C7F-87BD-472F-9893-7A87CA263056
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii



Georgi Valkov
httpstorm.com
nano RTOS



> On 30 May 2023, at 2:02 PM, Paolo Abeni <pabeni@redhat.com> wrote:
> 
> Hi, 
> 
> On Sat, 2023-05-27 at 15:03 +0200, Foster Snowhill wrote:
>> From: Georgi Valkov <gvalkov@gmail.com>
>> 
>> The cleanup precedure in ipheth_probe will attempt to free a
>> NULL pointer in dev->ctrl_buf if the memory allocation for
>> this buffer is not successful. While kfree ignores NULL pointers,
>> and the existing code is safe, it is a better design to rearrange
>> the goto labels and avoid this.
>> 
>> Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
>> Signed-off-by: Foster Snowhill <forst@pen.gy>
> 
> If you are going to repost (due to changes in patch 2) please update
> this patch subj, too. Currently is a bit confusing, something alike
> "cleanup the initialization error path" would be more clear.
> 
> Thanks,
> 
> Paolo
> 


--Apple-Mail=_C11E7C7F-87BD-472F-9893-7A87CA263056--

