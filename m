Return-Path: <netdev+bounces-7238-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7D6871F3F7
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 22:37:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AC731C2115C
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 20:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5816D23D7B;
	Thu,  1 Jun 2023 20:37:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE0023D76
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 20:37:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4261B134
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 13:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685651858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b01Oazl7JiDVcsGgKiDqMrNKj5SCQRNAK+gkRLeif6k=;
	b=hm8sxf2KpMUWQ+1meHnhQsUEtuh64WH8AecmW5JvACQJNaaJnKJZX3yigpDPotGf0V6h9c
	hL1yuN/6L3woI47GvJg89v+92PawJB5/OCWkeGTMjztJhgO2iW/iaWi6ejHknOUq57VrDe
	fGdLAmBo+GBkM5cWHTt7M1PXg5EQfJ8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-J6p4bJOsMfS4Kvf92biouw-1; Thu, 01 Jun 2023 16:37:35 -0400
X-MC-Unique: J6p4bJOsMfS4Kvf92biouw-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-514b3b99882so930914a12.2
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 13:37:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685651854; x=1688243854;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b01Oazl7JiDVcsGgKiDqMrNKj5SCQRNAK+gkRLeif6k=;
        b=CO0/qb4zFL9F9PonAa1qTVxnaDHvMFVlJhs54VZbFeFREw4Lw4um4gP1s8pTicMAu7
         iU1Y9QkxVP+bpDHLNUmzd/QIoo0pP2LDcYkRqB47igovvpZYlaVPx988FYvrnRUWJk7p
         dnEQLCVNvjRWbTTvl8BbHYnuI/w/PSPdi3xwxPLhevn4dqz8J8AT+Bk33f12BFDjfPSv
         uLolY2ZTh7aZrh0vIj/8zPr+J5ep2agAM3ZdB/GCa11NUsMNx42nl55nGFVcAUitd0Tb
         urnTMflHYai2WFEjAWyXUIU7bpLgZOSdU7FAjTPDRkAgbfZEwqhIujdnI/7+OLhcAyou
         bJ2g==
X-Gm-Message-State: AC+VfDwGTe5zenjkN0265Ty2TGYQPO+uJbkzunMkdaODv/8n0WZ7ZrRA
	fMqzNDajRHG23W/z+KeYUSt8AB08MLRj3slVhi2vbLmX0Rs82m8V+P1+5gidUXF8uk772y2+hwq
	GEHELQBpq7w8ofeiS
X-Received: by 2002:a05:6402:b13:b0:510:f6e0:7d9f with SMTP id bm19-20020a0564020b1300b00510f6e07d9fmr674164edb.13.1685651853674;
        Thu, 01 Jun 2023 13:37:33 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ71ozjVU3xqn0gn++2aKcpPYxcQQGLLFK2gjuaeWIusLV2sAeqSsdfjZyQ8uqGurbHFeJOZJg==
X-Received: by 2002:a05:6402:b13:b0:510:f6e0:7d9f with SMTP id bm19-20020a0564020b1300b00510f6e07d9fmr674148edb.13.1685651852754;
        Thu, 01 Jun 2023 13:37:32 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id r6-20020aa7d586000000b005153b12c9f7sm2207288edq.32.2023.06.01.13.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 13:37:32 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 8A388BBD28D; Thu,  1 Jun 2023 22:37:31 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Jesper Dangaard Brouer <brouer@redhat.com>, Tariq Toukan
 <ttoukan.linux@gmail.com>, Daniel Borkmann <borkmann@iogearbox.net>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko
 <andrii.nakryiko@gmail.com>, bpf@vger.kernel.org
Cc: Jesper Dangaard Brouer <brouer@redhat.com>, Tariq Toukan
 <tariqt@nvidia.com>, gal@nvidia.com, lorenzo@kernel.org,
 netdev@vger.kernel.org, echaudro@redhat.com,
 andrew.gospodarek@broadcom.com
Subject: Re: [PATCH bpf-next V2] bpf/xdp: optimize bpf_xdp_pointer to avoid
 reading sinfo
In-Reply-To: <168563651438.3436004.17735707525651776648.stgit@firesoul>
References: <168563651438.3436004.17735707525651776648.stgit@firesoul>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Thu, 01 Jun 2023 22:37:31 +0200
Message-ID: <87bkhydilw.fsf@toke.dk>
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

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> Currently we observed a significant performance degradation in
> samples/bpf xdp1 and xdp2, due XDP multibuffer "xdp.frags" handling,
> added in commit 772251742262 ("samples/bpf: fixup some tools to be able
> to support xdp multibuffer").
>
> This patch reduce the overhead by avoiding to read/load shared_info
> (sinfo) memory area, when XDP packet don't have any frags. This improves
> performance because sinfo is located in another cacheline.
>
> Function bpf_xdp_pointer() is used by BPF helpers bpf_xdp_load_bytes()
> and bpf_xdp_store_bytes(). As a help to reviewers, xdp_get_buff_len() can
> potentially access sinfo, but it uses xdp_buff_has_frags() flags bit check
> to avoid accessing sinfo in no-frags case.
>
> The likely/unlikely instrumentation lays out asm code such that sinfo
> access isn't interleaved with no-frags case (checked on GCC 12.2.1-4).
> The generated asm code is more compact towards the no-frags case.
>
> The BPF kfunc bpf_dynptr_slice() also use bpf_xdp_pointer(). Thus, it
> should also take effect for that.
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Thanks for fixing this!

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>


