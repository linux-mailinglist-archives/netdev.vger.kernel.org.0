Return-Path: <netdev+bounces-1126-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FD626FC4A1
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:10:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29BEC281022
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:10:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7291CDDD0;
	Tue,  9 May 2023 11:10:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652407C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 11:10:16 +0000 (UTC)
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CE02D7D
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 04:10:14 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-50bc3088b7aso11099546a12.3
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 04:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683630613; x=1686222613;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DMZmVFP9wqEpQlUtUjQXSnpKL/j3DcsDG+KmFCIt95w=;
        b=nLZulqS6652NinHvcKrJ4YhmKuP5PfAahVmmZEZYRAjzVuDk9AIKxsop35S7QXQ1GC
         AqIYwV8KR1JEr+snmUEhTyKY4jtcHgK7v15SHG96pcMe997rNJc8plh20Y0BoOGemR3A
         zWUjdtX8sXxxWQvOKysL8ho4G0sjatcC4PMPaKiG/4B86G7TmBfHg87hNtkKgbO/dnyT
         RF/mb1yloQPOcrr8R5PFmxeZ5WBuXSs4SPeuK2SVkc8ZnhTiV+rI+AV3w4bd2Z3H3GCl
         zDvx3h5E6RjDtBffWRaQoEz6WDwcGkkNhZkOIjhrPapI6NXEcsuWcDlgKO1yxHkbwJDj
         jgKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683630613; x=1686222613;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DMZmVFP9wqEpQlUtUjQXSnpKL/j3DcsDG+KmFCIt95w=;
        b=a8UewZE75gkOM9W8SGyfxiCu3tg2DEZfrFV4/e04Rb9nPVyBGCa9REDVE+tyROwQ2O
         gf/vQpcrHCryKWDYyR//etjmiFMHEYVF3jaqsQJPGY4lxGwBbsd6uSn8zxHHNiccKntc
         mRMYfy6gL+VnTGEHibtECjKm7nVGm2DcJWrlA7su12zy1CWVEh315tOk3PPMFWwu2kFf
         0gG6oO9vAA8zf3M+rLNQAacH996xM/M+UOkTtGCdFgucQlzH9M5pwntRPTk0BQJP7rHP
         KSWFWOgH6eWvke1iDrGSXSHUA1UDIe96o0BhH/IJDsQDjmIE6uvvoxbzZVudclCEjpGZ
         RUqA==
X-Gm-Message-State: AC+VfDzA0SOYVI8WmFInYI4oYsSC0lcVjFnPfNznIym4CQnyxtdXHVeI
	5JEwbPuP3QqOHZO7hrU2A5o=
X-Google-Smtp-Source: ACHHUZ4PBoSAW9RJiFEGQSLAJhzEQyAdne+5SktHpCOwO/XmcBEztSoEukSg637WZ5Oeqe7uc3tlhg==
X-Received: by 2002:a05:6402:322:b0:50b:c689:8610 with SMTP id q2-20020a056402032200b0050bc6898610mr12188539edw.18.1683630613027;
        Tue, 09 May 2023 04:10:13 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id b4-20020aa7df84000000b0050673b13b58sm634725edy.56.2023.05.09.04.10.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 May 2023 04:10:12 -0700 (PDT)
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
In-Reply-To: <CANn89i+=gWwebCHk2qwu12qC+yXTFUqOxWTfnqbJOAFjidcYeg@mail.gmail.com>
Date: Tue, 9 May 2023 14:10:01 +0300
Cc: Ido Schimmel <idosch@idosch.org>,
 netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A4F00E57-AB0E-4211-B9E4-225093EB101F@gmail.com>
References: <371A6638-8D92-4891-8DF5-C0EA4FBC1977@gmail.com>
 <ZFoeZLOZbNZPUfcg@shredder>
 <CANn89i+=gWwebCHk2qwu12qC+yXTFUqOxWTfnqbJOAFjidcYeg@mail.gmail.com>
To: Eric Dumazet <edumazet@google.com>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi

in short, there is no way to make the kernel do it faster.

Before time with old kernel unregister device make more faster .

with latest kernel >6.x this make very slow .


is there any chance to try to make this more fast.


m.


> On 9 May 2023, at 13:32, Eric Dumazet <edumazet@google.com> wrote:
>=20
> On Tue, May 9, 2023 at 12:20=E2=80=AFPM Ido Schimmel =
<idosch@idosch.org> wrote:
>>=20
>> On Tue, May 09, 2023 at 11:22:13AM +0300, Martin Zaharinov wrote:
>>> add vlans :
>>> for i in $(seq 2 4094); do ip link add link eth1 name vlan$i type =
vlan id $i; done
>>> for i in $(seq 2 4094); do ip link set dev vlan$i up; done
>>>=20
>>>=20
>>> and after that run :
>>>=20
>>> for i in $(seq 2 4094); do ip link del link eth1 name vlan$i type =
vlan id $i; done
>>>=20
>>>=20
>>> time for remove for this 4093 vlans is 5-10 min .
>>>=20
>>> Is there options to make fast this ?
>>=20
>> If you know you are going to delete all of them together, then you =
can
>> add them to the same group during creation:
>>=20
>> for i in $(seq 2 4094); do ip link add link eth1 name vlan$i up group =
10 type vlan id $i; done
>>=20
>> Then delete the group:
>>=20
>> ip link del group 10
>>=20
>=20
> Another way is to create a netns for retiring devices,
> move devices to the 'retirens' when they need to go away.
>=20
> Then once per minute, delete the retirens and create a new one.
>=20
> -> This batches netdev deletions.
>=20
>=20
>> IIRC, in the past there was a patchset to allow passing a list of
>> ifindexes instead of a group number, but it never made its way =
upstream.



