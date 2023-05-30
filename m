Return-Path: <netdev+bounces-6469-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CC60716641
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:10:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2CF41C20CFB
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C98723D4E;
	Tue, 30 May 2023 15:08:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B32D17AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:08:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D52BE49
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 08:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685459194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6xsn9burZdF7vVWYZ/Jp3eS0KE/KPi8RqUiXJi9Zy40=;
	b=cgghuLq2vEMEId15VAYL92pbaNunXi7Zr0JTRb3EQNj08DkjekSXfRmOaJqEpKEz65NyHc
	JrQRSoTPRWS+ykeBnk/zl/5qzA9VKMYNIxiNFmTLYC6/qGSr54yctibA+IiEjex3WP3DIC
	aLxJzabSlBAoWiSK+K3gqpgp2iMddM8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-owRyfDaCN-S6tS2JJX-kwA-1; Tue, 30 May 2023 11:06:28 -0400
X-MC-Unique: owRyfDaCN-S6tS2JJX-kwA-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-510526d2a5fso7011910a12.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 08:06:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685459181; x=1688051181;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6xsn9burZdF7vVWYZ/Jp3eS0KE/KPi8RqUiXJi9Zy40=;
        b=gBvJjCgTziQTrBfmlcKGmMR7VnvCHJt01XShUYabv8cQhpWO0PMwS5RiFdr/bPW2/B
         NSmkVNRiSinWyGgLYA2EJHk24OPpBkbqmx27WtPRrj58HpYNnSwkC5I12jm0SSyhOOtn
         H55+TOtxw7kdOuPaoUgYfRMeErDmtbXqQA+ecTPfs0wjXinsdwdud/hmJHyE0/i3bVSH
         5Q6ajC+ju4oNCr3hCNqET0XNY1ZTSACgjZ5UBLlVAHrliq13pWhQClpaJQa0XohckUGo
         4yvJr0NkhhefFpkXTS938s5Puw19794254OfFWhwzCSb/WMsh6138xSPUUdIRKCkr3yJ
         6CLw==
X-Gm-Message-State: AC+VfDzP+u0kTK5+jFPVHqqymL2tX+R3hIV+6MZCzX+ijJwBCaOs1ajH
	OrB2UXc3Ml4u5hfucTyI56bcbS1Nue/ZptxIOb3QL2l550b52h3OXZ8MOJDQ+00k8kmSNSMwD9D
	RlSeUy3bx2r6opDp0
X-Received: by 2002:a17:907:784:b0:96f:a412:8b03 with SMTP id xd4-20020a170907078400b0096fa4128b03mr2483065ejb.5.1685459179991;
        Tue, 30 May 2023 08:06:19 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6xqGDQe56I9G09lU+Lf+GpoSkQ3T+HAdCAAsn02J99GHYwGt1T/QJ1WQeImfuuNWcVHaT+Iw==
X-Received: by 2002:a17:907:784:b0:96f:a412:8b03 with SMTP id xd4-20020a170907078400b0096fa4128b03mr2483007ejb.5.1685459179234;
        Tue, 30 May 2023 08:06:19 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id o2-20020a1709062e8200b0094f698073e0sm7331418eji.123.2023.05.30.08.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 08:06:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 914EEBBCCBA; Tue, 30 May 2023 17:05:00 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Tariq Toukan <ttoukan.linux@gmail.com>, Jesper Dangaard Brouer
 <jbrouer@redhat.com>, Alexei Starovoitov <ast@kernel.org>, John Fastabend
 <john.fastabend@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Cc: brouer@redhat.com, Daniel Borkmann <daniel@iogearbox.net>, Jesper
 Dangaard Brouer <hawk@kernel.org>, bpf@vger.kernel.org, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>, Nimrod Oren
 <noren@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Lorenzo Bianconi
 <lorenzo.bianconi@redhat.com>, drosen@google.com, Joanne Koong
 <joannelkoong@gmail.com>, henning.fehrmann@aei.mpg.de,
 oliver.behnke@aei.mpg.de
Subject: Re: [PATCH bpf-next 1/2] samples/bpf: fixup xdp_redirect tool to be
 able to support xdp multibuffer
In-Reply-To: <dc19366d-8516-9f2a-b6ed-d9323e9250c9@gmail.com>
References: <20230529110608.597534-1-tariqt@nvidia.com>
 <20230529110608.597534-2-tariqt@nvidia.com>
 <63d91da7-4040-a766-dcd7-bccbb4c02ef4@redhat.com>
 <4ceac69b-d2ae-91b5-1b24-b02c8faa902b@gmail.com>
 <3168b14c-c9c1-b11b-2500-2ff2451eb81c@redhat.com>
 <dc19366d-8516-9f2a-b6ed-d9323e9250c9@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Tue, 30 May 2023 17:05:00 +0200
Message-ID: <878rd597xf.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Tariq Toukan <ttoukan.linux@gmail.com> writes:

> On 30/05/2023 15:40, Jesper Dangaard Brouer wrote:
>>=20
>>=20
>> On 30/05/2023 14.17, Tariq Toukan wrote:
>>>
>>> On 30/05/2023 14:33, Jesper Dangaard Brouer wrote:
>>>>
>>>>
>>>> On 29/05/2023 13.06, Tariq Toukan wrote:
>>>>> Expand the xdp multi-buffer support to xdp_redirect tool.
>>>>> Similar to what's done in commit
>>>>> 772251742262 ("samples/bpf: fixup some tools to be able to support=20
>>>>> xdp multibuffer")
>>>>> and its fix commit
>>>>> 7a698edf954c ("samples/bpf: Fix MAC address swapping in xdp2_kern").
>>>>>
>>>>
>>>> Have you tested if this cause a performance degradation?
>>>>
>>>> (Also found possible bug below)
>>>>
>>>
>>> Hi Jesper,
>>>
>>> This introduces the same known perf degradation we already have in=20
>>> xdp1 and xdp2.
>>=20
>> Did a quick test with xdp1, the performance degradation is around 18%.
>>=20
>>  =C2=A0Before: 22,917,961 pps
>>  =C2=A0After:=C2=A0 18,798,336 pps
>>=20
>>  =C2=A0(1-(18798336/22917961))*100 =3D 17.97%
>>=20
>>=20
>>> Unfortunately, this is the API we have today to safely support=20
>>> multi-buffer.
>>> Note that both perf and functional (noted below) degradation should be=
=20
>>> eliminated once replacing the load/store operations with dynptr logic=20
>>> that returns a pointer to the scatter entry instead of copying it.
>>>
>>=20
>> Well, should we use dynptr logic in this patch then?
>>=20
>
> AFAIU it's not there ready to be used...
> Not sure what parts are missing, I'll need to review it a bit deeper.
>
>> Does it make sense to add sample code that does thing in a way that is=20
>> sub-optimal and we want to replace?
>> ... (I fear people will copy paste the sample code).
>>=20
>
> I get your point.
> As xdp1 and xdp2 are already there, I thought that we'd want to expose=20
> multi-buffer samples in XDP_REDIRECT as well. We use these samples for=20
> internal testing.

Note that I am planning to send a patch to remove these utilities in the
not-so distant future. We have merged the xdp-bench utility into
xdp-tools as of v1.3.0, and that should contain all functionality of
both the xdp1/2 utilities and the xdp_redirect* utilities, without being
dependent on the (slowly bitrotting) samples/bpf directory.

The only reason I haven't sent the patch to remove the utilities yet is
that I haven't yet merged the multibuf support (WiP PR here:
https://github.com/xdp-project/xdp-tools/pull/314).

I'll try to move that up on my list of things to get done, but in the
meantime I'd advice against expending too much effort on improving these
tools :)

-Toke


