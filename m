Return-Path: <netdev+bounces-6331-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7426715CAB
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:10:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62C3228112B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:10:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A775A174FC;
	Tue, 30 May 2023 11:10:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5A34A0C
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:10:08 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF124B0;
	Tue, 30 May 2023 04:10:06 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f705976afbso4193005e9.1;
        Tue, 30 May 2023 04:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685445005; x=1688037005;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=U3nxQl10l/SUhY3CCaY6+jTnP9nSdr+AvpeEnlCHIvk=;
        b=U4Z33RtOodjSO0YCkNYhZsLpDf1NbX0mNaIuafMA7g+7Qi+nz+7MreC2AGU8TpKeNg
         ykb9Wc3FC0SJF5vR76q7npdyqTdICYrAOAwY1n6sReQHJx+vkxkH7SQYVgHjbkLsV1rZ
         kTts3m3d7yB92aqcAd2s63cv7RanS+/AYU7dN8wSXoM6WNWwJozCcn0yx558OV5pLoxc
         CE0E9//LIyV+153HdqA4KF/+TdWTPWmCDCuOHE5xMRSI57kiLAYd9QZ+ahHgf7byYmiD
         1qN83LIPHDIYerH8Ej6+shceZx9NlJSknEndb0W1CHNl2kMdl2Tzw7w946Pj4LRVttQB
         I64A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685445005; x=1688037005;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U3nxQl10l/SUhY3CCaY6+jTnP9nSdr+AvpeEnlCHIvk=;
        b=R6yL+gr/osm7QdE7j4em6YBXShErNFy/3/jgpAJqs+Nz8NhSKPuMOPX/LuqBso0C4x
         yOgKcPtjw8mF+LuOBKKOO29NU0WCBU7UUxLBViGT8NC6HkK1T7vAyKs1iUm1P4BxTwoJ
         MpRSHuRpHFA5ZowH3N/4F2XIjkW/YDrkjvrkaU3JA45p44a547nIkiaOSgx28smCq1zf
         qkxvHkuTAuLH5VlPjWjxgvNBNFa0o3/m8uOw9FnnQIp4MovhokHYnm5pVZear4WJ+G1Q
         CQBl72fpHiGHCoJJSgXdOI5UQrda4Ufqi+6jQkfkl/AYBKWNKp9F4mojYAsSpA+V0iAz
         ecAA==
X-Gm-Message-State: AC+VfDwR+EFAxAoajWORpjZAG8mBnBVuZH/cSjU3RXMVQQ0ODPI/0pEp
	jb3hkOhODH70IZZDL+FrKB65c2Oz4Ru88Q==
X-Google-Smtp-Source: ACHHUZ4QpfjAr0sha/VfkBxgDhZ8M8i7vAgcW3F7kfW6koZ/7MFLLmu15GqWs4OyMOsyTxk5x5Rsew==
X-Received: by 2002:adf:db4b:0:b0:306:5f2a:8a65 with SMTP id f11-20020adfdb4b000000b003065f2a8a65mr1142778wrj.4.1685445005002;
        Tue, 30 May 2023 04:10:05 -0700 (PDT)
Received: from smtpclient.apple (212-5-158-75.ip.btc-net.bg. [212.5.158.75])
        by smtp.gmail.com with ESMTPSA id g15-20020adff40f000000b00307972e46fasm2903641wro.107.2023.05.30.04.10.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 May 2023 04:10:04 -0700 (PDT)
From: George Valkov <gvalkov@gmail.com>
Message-Id: <C6FF2A09-5208-4A0E-9D63-26F4CC1FE20D@gmail.com>
Content-Type: multipart/mixed;
	boundary="Apple-Mail=_783AABD0-D117-4490-B46D-E8E3ED159AD1"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [PATCH net-next v3 1/2] usbnet: ipheth: fix risk of NULL pointer
 deallocation
Date: Tue, 30 May 2023 14:09:52 +0300
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


--Apple-Mail=_783AABD0-D117-4490-B46D-E8E3ED159AD1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

Thanks Paolo! Something like that?


--Apple-Mail=_783AABD0-D117-4490-B46D-E8E3ED159AD1
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

--Apple-Mail=_783AABD0-D117-4490-B46D-E8E3ED159AD1
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


--Apple-Mail=_783AABD0-D117-4490-B46D-E8E3ED159AD1--

