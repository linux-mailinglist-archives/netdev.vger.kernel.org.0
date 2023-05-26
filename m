Return-Path: <netdev+bounces-5561-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 87F55712242
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:33:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32B0F1C20FE5
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:33:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB8353C04;
	Fri, 26 May 2023 08:33:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971BA23A4
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 08:33:37 +0000 (UTC)
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A745213A;
	Fri, 26 May 2023 01:33:35 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-3093aa2f2a5so52833f8f.0;
        Fri, 26 May 2023 01:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685090014; x=1687682014;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=nRhRobWF9Hr3G4ofrhF1TL7x8KZgTqCRAivN1RjHiAY=;
        b=dh885MJtpnnCAR1HoaRZO2f1Kcv/ajJu+pRmPCS3XXxbkXKTptXtn8eke3u6H2rgjU
         qbuP8xXu2PhgMUD2teehIpNL4V5xeuTfrtxvPeqNP9RtxI2U9wR9VVvAArbFb70vAbj2
         Bh0namDnVf+GEPbCOJSs7ohNjRAB5fgCzvsYDaviYp5ovvlYHtWzzIVOrerjvF7Bh3Pn
         6b08TZM3NiyGoOhVTHX0o0JV98wqST3FClZsy00SxlFNY1hJspRnpbyBpBuCxaGJlDWT
         JW4eLAt8tzL0O2VAZcGpcrGMN6w6rQHtE+UJlEdeW68Tx/FZVsbbzDcmnEloKyABGVw/
         aY2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685090014; x=1687682014;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nRhRobWF9Hr3G4ofrhF1TL7x8KZgTqCRAivN1RjHiAY=;
        b=P0737YF6ZPDI2ekbNZ1/d1Y9KlbngNz6sGQNjUKs2Zz78lCCxKmXeIwkS8BGCLufX/
         2GtWaRMXXLQR4iNyG0zkc8Jqv9xqoRx1OCzTWdRbSuGxzNb7tk2k9FJHUs4V102oBhYR
         MyZ3mds3Xu0IYFfPCIz5MytUEg1Cb152gQzJwKDpPtF0Rg1xZmGbiKTqC7qUJHCACO6i
         B8J9KNEKKiR25C+ZBzT2P1NjbAJeS9as+SS/ET9v5VvdV0QHo4m34yhubmf4c1clR8n3
         d0CXSMkm6n4Gbn2qw5Bf8ORRUNBEXBy/FhIorJS44og8y9JF3ANqOrdp7MlQbLEi3euG
         XwhQ==
X-Gm-Message-State: AC+VfDyD96bZ4q4T6jlrGchE5k3sW4O+/nhrs5YcIC0TmFpv+Pvl/tzB
	Suu0JpT8ksEJWKCy7C4hy3pF3xF0LIE2XA==
X-Google-Smtp-Source: ACHHUZ7MGzp+g/hoKuvONM19NevX3m9E9u8iKlkxmxt9F3MLjZSkqLfL1LEGk7gSjoo8624Dmg/y2g==
X-Received: by 2002:a5d:6910:0:b0:309:3a72:3cea with SMTP id t16-20020a5d6910000000b003093a723ceamr713191wru.0.1685090013739;
        Fri, 26 May 2023 01:33:33 -0700 (PDT)
Received: from smtpclient.apple (212-39-89-99.ip.btc-net.bg. [212.39.89.99])
        by smtp.gmail.com with ESMTPSA id k7-20020a5d66c7000000b00307a83ea722sm4280769wrw.58.2023.05.26.01.33.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 May 2023 01:33:33 -0700 (PDT)
From: George Valkov <gvalkov@gmail.com>
Message-Id: <C0FADE3B-5422-444A-8F09-32BE215B5E88@gmail.com>
Content-Type: multipart/mixed;
	boundary="Apple-Mail=_AE9305BA-4843-43E1-8A58-3CAC7A95C28A"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [PATCH net-next v2 1/2] usbnet: ipheth: fix risk of NULL pointer
 deallocation
Date: Fri, 26 May 2023 11:33:21 +0300
In-Reply-To: <ZHBlShZDu3C8VOl3@corigine.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 linux-usb <linux-usb@vger.kernel.org>,
 Linux Netdev List <netdev@vger.kernel.org>
To: Simon Horman <simon.horman@corigine.com>,
 Foster Snowhill <forst@pen.gy>
References: <20230525194255.4516-1-forst@pen.gy>
 <ZHBlShZDu3C8VOl3@corigine.com>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--Apple-Mail=_AE9305BA-4843-43E1-8A58-3CAC7A95C28A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On 26 May 2023, at 10:52 AM, Simon Horman <simon.horman@corigine.com> =
wrote:
>=20
> On Thu, May 25, 2023 at 09:42:54PM +0200, Foster Snowhill wrote:
>> From: Georgi Valkov <gvalkov@gmail.com>
>>=20
>> The cleanup precedure in ipheth_probe will attempt to free a
>> NULL pointer in dev->ctrl_buf if the memory allocation for
>> this buffer is not successful. Rearrange the goto labels to
>> avoid this risk.
>=20
> Hi Georgi and Foster,
>=20
> kfree will ignore a NULL argument, so I think the existing code is =
safe.
> But given the name of the label I do agree there is scope for a =
cleanup
> here.

It=E2=80=99s good to know that precaution has been taken in kfree to =
avoid this, yet at my opinion knowingly attempting to free a NULL =
pointer is a red flag and bad design. Likely a misplaced label.

> Could you consider rewording the patch description accordingly?

What would you like me to use as title and description? Can I use this?

usbnet: ipheth: avoid kfree with a NULL pointer

The cleanup precedure in ipheth_probe will attempt to free a
NULL pointer in dev->ctrl_buf if the memory allocation for
this buffer is not successful. While kfree ignores NULL pointers,
and the existing code is safe, it is a better design to rearrange
the goto labels and avoid this.


>> Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
>=20
> If Georgi is the author of the patch, which seems to be the case,
> then the above is correct. But as the patch is being posted by Foster
> I think it should be followed by a Signed-off-by line for Foster.

Yes, I discovered the potential issue and authored the patch to help. =
We=E2=80=99ll append Signed-off-by Foster as you suggested. Thanks =
Simon!

Something like that?


--Apple-Mail=_AE9305BA-4843-43E1-8A58-3CAC7A95C28A
Content-Disposition: attachment;
	filename=0001-usbnet-ipheth-avoid-kfree-with-a-NULL-pointer.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="0001-usbnet-ipheth-avoid-kfree-with-a-NULL-pointer.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=2015dc5cec0d239d30856dc6d9b9a7a9528342cde0=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Georgi=20Valkov=20<gvalkov@gmail.com>=0ADate:=20=
Thu,=2025=20May=202023=2021:23:12=20+0200=0ASubject:=20[PATCH=20net-next=20=
v3=201/2]=20usbnet:=20ipheth:=20avoid=20kfree=20with=20a=20NULL=20=
pointer=0A=0AThe=20cleanup=20precedure=20in=20ipheth_probe=20will=20=
attempt=20to=20free=20a=0ANULL=20pointer=20in=20dev->ctrl_buf=20if=20the=20=
memory=20allocation=20for=0Athis=20buffer=20is=20not=20successful.=20=
While=20kfree=20ignores=20NULL=20pointers,=0Aand=20the=20existing=20code=20=
is=20safe,=20it=20is=20a=20better=20design=20to=20rearrange=0Athe=20goto=20=
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

--Apple-Mail=_AE9305BA-4843-43E1-8A58-3CAC7A95C28A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii




Georgi Valkov
httpstorm.com
nano RTOS

> Link: =
https://www.kernel.org/doc/html/latest/process/submitting-patches.html?hig=
hlight=3Dsigned+off#developer-s-certificate-of-origin-1-1
>=20
>> ---
>> drivers/net/usb/ipheth.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
>> index 6a769df0b..8875a3d0e 100644
>> --- a/drivers/net/usb/ipheth.c
>> +++ b/drivers/net/usb/ipheth.c
>> @@ -510,8 +510,8 @@ static int ipheth_probe(struct usb_interface =
*intf,
>>        ipheth_free_urbs(dev);
>> err_alloc_urbs:
>> err_get_macaddr:
>> -err_alloc_ctrl_buf:
>>        kfree(dev->ctrl_buf);
>> +err_alloc_ctrl_buf:
>> err_endpoints:
>>        free_netdev(netdev);
>>        return retval;
>=20
> --=20
> pw-bot: cr



--Apple-Mail=_AE9305BA-4843-43E1-8A58-3CAC7A95C28A--

