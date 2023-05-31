Return-Path: <netdev+bounces-6862-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B5DB71874C
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:25:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 569B7281565
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:25:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39586182AB;
	Wed, 31 May 2023 16:25:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247F81773E
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 16:25:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA62DE2
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685550301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OQlOT5WJAJ1REsa3I4jJREd6saUINMYfAuaPfKmSS7A=;
	b=CfV/Xmc086o9wg6eqnyrZhjBjtdBxQuGM2J/8UEVB99phew26LX1N9N0W+jsyGcmq/Rssl
	xMYmIuKlB4YO7Y1489jBtoPWlKNkA15Hg0vNLE6fYKajszZk9TIpbrBiFXbb3gdo3WG/oV
	tZfChI3RgM5osX2ZD6HftgpuQ9HmkI4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-R-GyCHnTMkuNnc7JaQOmlw-1; Wed, 31 May 2023 12:24:58 -0400
X-MC-Unique: R-GyCHnTMkuNnc7JaQOmlw-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-50daa85e940so5299756a12.0
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:24:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685550296; x=1688142296;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OQlOT5WJAJ1REsa3I4jJREd6saUINMYfAuaPfKmSS7A=;
        b=IXMxIs4dtepN5S/JiP6saWPBOZPjEwIKLFm8vL9ecHZE6ZrNQz254LJiMOmu87smtR
         4OHXtr17rSQfUE/aTdH/jP2+l5i/3f6Mqp4KpP4c+xu3L5to/OekzD273guAK0sZyYmT
         9iRYdeS3IAsJDm00gSZQyx5DYMJ9HvedmF1oHoaawvokBD/qb1+8PdmnMeSXmAELBE2v
         nk1+18DCXT6OVBPKk7jAjtil7qtS3hFk+Fc/vKrY4gOk0g68TZxERoTrZ3kcA3QQZ7R/
         HURlq+PIYvYlRGe4MZCy2gpCRbPN3ZsFVQKU9aI5m8tJSAmokfMzmoF1bgy3w3O6IaPQ
         8waQ==
X-Gm-Message-State: AC+VfDxo4GPj0pIyI5n/Z9wFwyvLlcn67bAPCm3RDrP3kDz8fQ6HLyAx
	0DnSJ5kIbhUjK28mc+iTLliGF2c72hzXCxu/SvdRt8Ec4D5jtS2q5EFSM9uVF5tzMZ/xA7zL3F3
	u0f+3I6hKqPgobhMivc+BrRK3
X-Received: by 2002:aa7:df0d:0:b0:514:9e26:1f4b with SMTP id c13-20020aa7df0d000000b005149e261f4bmr4266565edy.0.1685550296022;
        Wed, 31 May 2023 09:24:56 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6rdfL8IF2U2gFCTXsZGBTisiNNfEAnSnM6ZEEsC38vGan3C9OYStxXC4X+Y289rEPEOdR46g==
X-Received: by 2002:aa7:df0d:0:b0:514:9e26:1f4b with SMTP id c13-20020aa7df0d000000b005149e261f4bmr4266529edy.0.1685550295220;
        Wed, 31 May 2023 09:24:55 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id s21-20020a056402015500b00501d73cfc86sm5981786edu.9.2023.05.31.09.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 09:24:54 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 80354BBD09C; Wed, 31 May 2023 18:24:52 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Lorenzo Bianconi <lorenzo@kernel.org>, Jesper Dangaard Brouer
 <brouer@redhat.com>
Cc: Tariq Toukan <ttoukan.linux@gmail.com>, Daniel Borkmann
 <borkmann@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Andrii
 Nakryiko <andrii.nakryiko@gmail.com>, bpf@vger.kernel.org, Tariq Toukan
 <tariqt@nvidia.com>, gal@nvidia.com, netdev@vger.kernel.org,
 echaudro@redhat.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH bpf-next] bpf/xdp: optimize bpf_xdp_pointer to avoid
 reading sinfo
In-Reply-To: <ZHdrLSDC7UfLKKfp@lore-desk>
References: <168554475365.3262482.9868965521545045945.stgit@firesoul>
 <ZHdrLSDC7UfLKKfp@lore-desk>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Wed, 31 May 2023 18:24:52 +0200
Message-ID: <87353ceaej.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Lorenzo Bianconi <lorenzo@kernel.org> writes:

>> Currently we observed a significant performance degradation in
>> samples/bpf xdp1 and xdp2, due XDP multibuffer "xdp.frags" handling,
>> added in commit 772251742262 ("samples/bpf: fixup some tools to be able
>> to support xdp multibuffer").
>> 
>> This patch reduce the overhead by avoiding to read/load shared_info
>> (sinfo) memory area, when XDP packet don't have any frags. This improves
>> performance because sinfo is located in another cacheline.
>> 
>> Function bpf_xdp_pointer() is used by BPF helpers bpf_xdp_load_bytes()
>> and bpf_xdp_store_bytes(). As a help to reviewers, xdp_get_buff_len() can
>> potentially access sinfo.
>> 
>> Perf report show bpf_xdp_pointer() percentage utilization being reduced
>> from 4,19% to 3,37% (on CPU E5-1650 @3.60GHz).
>> 
>> The BPF kfunc bpf_dynptr_slice() also use bpf_xdp_pointer(). Thus, it
>> should also take effect for that.
>> 
>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>> ---
>>  net/core/filter.c |   12 ++++++++----
>>  1 file changed, 8 insertions(+), 4 deletions(-)
>> 
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 968139f4a1ac..a635f537d499 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -3948,20 +3948,24 @@ void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off,
>>  
>>  void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
>>  {
>> -	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
>>  	u32 size = xdp->data_end - xdp->data;
>> +	struct skb_shared_info *sinfo;
>>  	void *addr = xdp->data;
>>  	int i;
>>  
>>  	if (unlikely(offset > 0xffff || len > 0xffff))
>>  		return ERR_PTR(-EFAULT);
>>  
>> -	if (offset + len > xdp_get_buff_len(xdp))
>> -		return ERR_PTR(-EINVAL);
>> +	if (likely((offset < size))) /* linear area */
>> +		goto out;
>
> Hi Jesper,
>
> please correct me if I am wrong but looking at the code, in this way
> bpf_xdp_pointer() will return NULL (and not ERR_PTR(-EINVAL)) if:
> - offset < size
> - offset + len > xdp_get_buff_len()
>
> doing so I would say bpf_xdp_copy_buf() will copy the full packet starting from
> offset leaving some part of the auxiliary buffer possible uninitialized.
> Do you think it is an issue?

Yeah, you're right, bpf_xdp_load_bytes() should fail if trying to read
beyond the frame, and in this case it won't for non-frags; that's a
change in behaviour we probably shouldn't be making...

-Toke


