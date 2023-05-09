Return-Path: <netdev+bounces-1243-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FAAC6FCE01
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 20:50:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 461B51C20C4F
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 18:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DDF214A8C;
	Tue,  9 May 2023 18:50:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DC9AD39
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 18:50:33 +0000 (UTC)
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BFC2D62
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 11:50:32 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-965d73eb65fso949762466b.2
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 11:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683658230; x=1686250230;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1DJsNDsWsM86xzRN+oxbyuWgqyjxjy2fSs3sncWwu3s=;
        b=Gqbl/bOdv+hSrqTEoZ9zlGE/D7yoLSaFPSN7/as3T/IhaU6Nzamys9oPz2ALECSq31
         VXcr/+n+kCQp/mq7y9NkOwWdFSR3Ac4zCCsOWnNgJBa3Kgsf+GVdysKwSFAKm9JeYfsY
         nw3kHb93edVNWFEeqMdWYOK1maKjhBckT4OjFUWU3kuGzoMDwJCk9Nw9e9VFvaKXvs5V
         G+spg0BHzH9gw/d5gd1Zgdy3t/BnD5umVDPSuHI/gQfe9GHWX9gZNDLLF0oAKbQKIc2c
         6wi052mOG54cL7jtb4XBFPIS3OLkh+ybpgyUowTKrxaXTJp1rTKjvk8qOHjB8dMWF1uS
         gjkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683658230; x=1686250230;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1DJsNDsWsM86xzRN+oxbyuWgqyjxjy2fSs3sncWwu3s=;
        b=iXND0k6SSBk6ZVCibZRradRnC1kOGGF2RK2EJTUPyXdVOIWj7IdJxfFoHRkPnbJs1A
         ILSwuFBhDG3OAWr7b34k18uxB35Ed7J2cvyOhjyDAtHhIlexFuh4/SdxEW0sjGN38tvM
         rVT1818csm3eD/90wKGzn3qzJDG5csESq5+i0tSEFkMMmZ0MYxI3bNfZZQtS6PpI5gp3
         iYuZk6NMqvNc4naMKOCoMFsxC71zFbVOlnRVv3cSdKpU0Enz9G4/YWgs1Q+QjX4Hu/hs
         uEZGQtbCWV8TWw1q4kKisIFnZZe74ewfk9LA3P7+7Wda/dpeIP6Ahdlv9kQaoL8lnA0C
         mMrA==
X-Gm-Message-State: AC+VfDyoQxjWfGw0yoJw+ay8xsjLOzL+lh2W57zrefjGJyCp2bWTCBr5
	nA0YuQgu3KgUsAa3P4WrRcI=
X-Google-Smtp-Source: ACHHUZ56NPolk6Qx7msPf/oqyhaChyIhc2myNS7ULKs1hOBhR7eILGetmV1tqFSjAkMvjXoSXk3ZOw==
X-Received: by 2002:a17:906:fd8e:b0:961:a67:28d with SMTP id xa14-20020a170906fd8e00b009610a67028dmr12525413ejb.22.1683658230396;
        Tue, 09 May 2023 11:50:30 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id b16-20020a170906195000b0094e96e46cc0sm1640474eje.69.2023.05.09.11.50.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 May 2023 11:50:29 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: Very slow remove interface from kernel
From: Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <CANn89iKOm2WPoemiqCsWaMXMyGf9C5xXH=NaSidPSNCpKxf_jQ@mail.gmail.com>
Date: Tue, 9 May 2023 21:50:18 +0300
Cc: Ido Schimmel <idosch@idosch.org>,
 netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FE7CE62C-DBEB-4FE1-8ACB-C8B7DAF15710@gmail.com>
References: <371A6638-8D92-4891-8DF5-C0EA4FBC1977@gmail.com>
 <ZFoeZLOZbNZPUfcg@shredder>
 <CANn89i+=gWwebCHk2qwu12qC+yXTFUqOxWTfnqbJOAFjidcYeg@mail.gmail.com>
 <A4F00E57-AB0E-4211-B9E4-225093EB101F@gmail.com>
 <CANn89iKOm2WPoemiqCsWaMXMyGf9C5xXH=NaSidPSNCpKxf_jQ@mail.gmail.com>
To: Eric Dumazet <edumazet@google.com>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Eric

i try on kernel 6.3.1=20


time for i in $(seq 2 4094); do ip link del link eth1 name vlan$i type =
vlan id $i; done

real	4m51.633s  =E2=80=94=E2=80=94 here i stop with Ctrl + C  -  and =
rerun  and second part finish after 3 min
user	0m7.479s
sys	0m0.367s


Config is very clean i remove big part of CONFIG options .

is there options to debug what is happen.

m


> On 9 May 2023, at 15:36, Eric Dumazet <edumazet@google.com> wrote:
>=20
> On Tue, May 9, 2023 at 1:10=E2=80=AFPM Martin Zaharinov =
<micron10@gmail.com> wrote:
>>=20
>> Hi
>>=20
>> in short, there is no way to make the kernel do it faster.
>=20
> Make sure your kernel does not include options you do not need.
>=20
>>=20
>> Before time with old kernel unregister device make more faster .
>>=20
>> with latest kernel >6.x this make very slow .
>>=20
>=20
> Yup, I feel your pain.
>=20
> Maybe you should start a bisection then...
>=20
> You might find that you have some CONFIG_ option that makes this
> operation very slow.
>=20
> Some layers (like hamradio and others) lack batch operations in their
> netdev removal handlers.
>=20
> For instance, on one machine I have access to and with my standard
> .config, your benchmark gives a not too bad result with pristine
> linux-6.3
>=20
> modprobe dummy
> ip link set dev dummy0 up
> for i in $(seq 2 4094); do ip link add link dummy0 name vlan$i type
> vlan id $i; done
> for i in $(seq 2 4094); do ip link set dev vlan$i up; done
> time for i in $(seq 2 4094); do ip link del link eth1 name vlan$i type
> vlan id $i; done
> real 0m55.808s
> user 0m0.788s
> sys 0m6.868s
>=20
> Without batching, I think one netdev removal needs three =
synchronize_net() calls
>=20
> I am reasonably certain numbers would not look so good if I booted a
> "make allyesconfig" kernel.
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>>=20
>> is there any chance to try to make this more fast.
>>=20
>>=20
>> m.
>>=20
>>=20
>>> On 9 May 2023, at 13:32, Eric Dumazet <edumazet@google.com> wrote:
>>>=20
>>> On Tue, May 9, 2023 at 12:20=E2=80=AFPM Ido Schimmel =
<idosch@idosch.org> wrote:
>>>>=20
>>>> On Tue, May 09, 2023 at 11:22:13AM +0300, Martin Zaharinov wrote:
>>>>> add vlans :
>>>>> for i in $(seq 2 4094); do ip link add link eth1 name vlan$i type =
vlan id $i; done
>>>>> for i in $(seq 2 4094); do ip link set dev vlan$i up; done
>>>>>=20
>>>>>=20
>>>>> and after that run :
>>>>>=20
>>>>> for i in $(seq 2 4094); do ip link del link eth1 name vlan$i type =
vlan id $i; done
>>>>>=20
>>>>>=20
>>>>> time for remove for this 4093 vlans is 5-10 min .
>>>>>=20
>>>>> Is there options to make fast this ?
>>>>=20
>>>> If you know you are going to delete all of them together, then you =
can
>>>> add them to the same group during creation:
>>>>=20
>>>> for i in $(seq 2 4094); do ip link add link eth1 name vlan$i up =
group 10 type vlan id $i; done
>>>>=20
>>>> Then delete the group:
>>>>=20
>>>> ip link del group 10
>>>>=20
>>>=20
>>> Another way is to create a netns for retiring devices,
>>> move devices to the 'retirens' when they need to go away.
>>>=20
>>> Then once per minute, delete the retirens and create a new one.
>>>=20
>>> -> This batches netdev deletions.
>>>=20
>>>=20
>>>> IIRC, in the past there was a patchset to allow passing a list of
>>>> ifindexes instead of a group number, but it never made its way =
upstream.
>>=20
>>=20


