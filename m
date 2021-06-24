Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEA63B2BA3
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 11:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhFXJoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 05:44:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35364 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231971AbhFXJof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 05:44:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624527736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uAksdgkvAl83QhcaZ5u1TUc96NzTLFAv77eQ0MJL4qA=;
        b=VNuTpPYynoupJhGHSGUZsjtOfhJ+X27E5/o6Zl3QyC1PQYQj7zWZvCvUsLVLPpG4rIaFht
        8MK90/C94jKIBwbUDpgRiKRdZx4W3EO9ILRHvgQVzZB7yjLLdQBVAQk73hlbeDc3NMrEEv
        z6E6pEcx4xGR01Jcb55uxK4nX4C6mYE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-cyGWAUESO2KaAoL7wbk1cg-1; Thu, 24 Jun 2021 05:42:14 -0400
X-MC-Unique: cyGWAUESO2KaAoL7wbk1cg-1
Received: by mail-ed1-f71.google.com with SMTP id x10-20020aa7cd8a0000b0290394bdda92a8so3065426edv.8
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 02:42:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uAksdgkvAl83QhcaZ5u1TUc96NzTLFAv77eQ0MJL4qA=;
        b=aX1y3okOw4KPhX8u0DKlBMCi/B2P9Oc4hWdT36xBup3qFXRwoGbE9wHW1n4T6dp+6k
         u5pz5UkfkyqKTpGQJOp4HFzEfhVwnPwARYUGNDR6HhidPNSAxiAZV4H9gJmodqam+k5n
         nTnFq0NWU49OtHZVCTYtj4nH0azZqFAFLIjB+pTY7dqaZzotZlRjhkL+OO+xsI9uIwk9
         6LLqSdqWGZvK6iAOqzNd9Z4tFYxtXmW540bmsVu3f/yk7Kw5EYJdeVI3YtskqZWQeC9i
         3kkA+69/YoJRZ7zx8QL4PvWivJy2lYh31gkea0DL4ytrjpO5agt8m9fFi6D1SC3es0h8
         JuRQ==
X-Gm-Message-State: AOAM531IkuW+lRuQJ8iBlthB1rXccAonred/mUc+VZr13Xsl7vKaGu27
        KpTDIHkCi+EMTZLxdMuyYIH7pRnqrYn529mOa16eAtAlQDhZrNk7tAueDuF//aNx/E49gvv574v
        PCaI0IEe08AS1VlAQ
X-Received: by 2002:a17:906:3b13:: with SMTP id g19mr4340628ejf.360.1624527733568;
        Thu, 24 Jun 2021 02:42:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkIgaFo+cEAneEBsFGU7ZqCUWXwTc1DGoFncHchSkAA8jTAlAaIs+cWrq6evj6NxqqagJtrQ==
X-Received: by 2002:a17:906:3b13:: with SMTP id g19mr4340602ejf.360.1624527733365;
        Thu, 24 Jun 2021 02:42:13 -0700 (PDT)
Received: from [10.36.112.236] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id s3sm954597ejm.49.2021.06.24.02.42.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jun 2021 02:42:12 -0700 (PDT)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        dsahern@kernel.org, brouer@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v9 bpf-next 10/14] bpf: add multi-buffer support to xdp copy helpers
Date:   Thu, 24 Jun 2021 11:42:12 +0200
X-Mailer: MailMate (1.14r5816)
Message-ID: <34E2BF41-03E0-4DEC-ABF3-72C8FF7B4E4A@redhat.com>
In-Reply-To: <60d27716b5a5a_1342e208d5@john-XPS-13-9370.notmuch>
References: <cover.1623674025.git.lorenzo@kernel.org>
 <4d2a74f7389eb51e2b43c63df76d9cd76f57384c.1623674025.git.lorenzo@kernel.org>
 <60d27716b5a5a_1342e208d5@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23 Jun 2021, at 1:49, John Fastabend wrote:

> Lorenzo Bianconi wrote:
>> From: Eelco Chaudron <echaudro@redhat.com>
>>
>> This patch adds support for multi-buffer for the following helpers:
>>   - bpf_xdp_output()
>>   - bpf_perf_event_output()
>>
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>> ---
>
> Ah ok so at least xdp_output will work with all bytes. But this is
> getting close to having access into the frags so I think doing
> the last bit shouldn't be too hard?


Guess you are talking about multi-buffer access in the XDP program?

I did suggest an API a while back, https://lore.kernel.org/bpf/FD3E6E08-D=
E78-4FBA-96F6-646C93E88631@redhat.com/ but I had/have not time to work on=
 it. Guess the difficult part is to convince the verifier to allow the da=
ta to be accessed.

>
>>  kernel/trace/bpf_trace.c                      |   3 +
>>  net/core/filter.c                             |  72 +++++++++-
>>  .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    | 127 ++++++++++++-----=
-
>>  .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |   2 +-
>>  4 files changed, 160 insertions(+), 44 deletions(-)
>>
>> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
>> index d2d7cf6cfe83..ee926ec64f78 100644
>> --- a/kernel/trace/bpf_trace.c
>> +++ b/kernel/trace/bpf_trace.c
>> @@ -1365,6 +1365,7 @@ static const struct bpf_func_proto bpf_perf_even=
t_output_proto_raw_tp =3D {
>>
>>  extern const struct bpf_func_proto bpf_skb_output_proto;
>>  extern const struct bpf_func_proto bpf_xdp_output_proto;
>> +extern const struct bpf_func_proto bpf_xdp_get_buff_len_trace_proto;
>>
>>  BPF_CALL_3(bpf_get_stackid_raw_tp, struct bpf_raw_tracepoint_args *, =
args,
>>  	   struct bpf_map *, map, u64, flags)
>> @@ -1460,6 +1461,8 @@ tracing_prog_func_proto(enum bpf_func_id func_id=
, const struct bpf_prog *prog)
>>  		return &bpf_sock_from_file_proto;
>>  	case BPF_FUNC_get_socket_cookie:
>>  		return &bpf_get_socket_ptr_cookie_proto;
>> +	case BPF_FUNC_xdp_get_buff_len:
>> +		return &bpf_xdp_get_buff_len_trace_proto;
>>  #endif
>>  	case BPF_FUNC_seq_printf:
>>  		return prog->expected_attach_type =3D=3D BPF_TRACE_ITER ?
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index b0855f2d4726..f7211b7908a9 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -3939,6 +3939,15 @@ const struct bpf_func_proto bpf_xdp_get_buff_le=
n_proto =3D {
>>  	.arg1_type	=3D ARG_PTR_TO_CTX,
>>  };
>>
>> +BTF_ID_LIST_SINGLE(bpf_xdp_get_buff_len_bpf_ids, struct, xdp_buff)
>> +
>> +const struct bpf_func_proto bpf_xdp_get_buff_len_trace_proto =3D {
>> +	.func		=3D bpf_xdp_get_buff_len,
>> +	.gpl_only	=3D false,
>> +	.arg1_type	=3D ARG_PTR_TO_BTF_ID,
>> +	.arg1_btf_id	=3D &bpf_xdp_get_buff_len_bpf_ids[0],
>> +};
>> +
>>  BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
>>  {
>>  	void *data_hard_end =3D xdp_data_hard_end(xdp); /* use xdp->frame_sz=
 */
>> @@ -4606,10 +4615,56 @@ static const struct bpf_func_proto bpf_sk_ance=
stor_cgroup_id_proto =3D {
>>  };
>>  #endif
>>
>> -static unsigned long bpf_xdp_copy(void *dst_buff, const void *src_buf=
f,
>> +static unsigned long bpf_xdp_copy(void *dst_buff, const void *ctx,
>>  				  unsigned long off, unsigned long len)
>>  {
>> -	memcpy(dst_buff, src_buff + off, len);
>> +	struct xdp_buff *xdp =3D (struct xdp_buff *)ctx;
>> +	struct skb_shared_info *sinfo;
>> +	unsigned long base_len;
>> +
>> +	if (likely(!xdp_buff_is_mb(xdp))) {
>> +		memcpy(dst_buff, xdp->data + off, len);
>> +		return 0;
>> +	}
>> +
>> +	base_len =3D xdp->data_end - xdp->data;
>> +	sinfo =3D xdp_get_shared_info_from_buff(xdp);
>> +	do {
>> +		const void *src_buff =3D NULL;
>> +		unsigned long copy_len =3D 0;
>> +
>> +		if (off < base_len) {
>> +			src_buff =3D xdp->data + off;
>> +			copy_len =3D min(len, base_len - off);
>> +		} else {
>> +			unsigned long frag_off_total =3D base_len;
>> +			int i;
>> +
>> +			for (i =3D 0; i < sinfo->nr_frags; i++) {
>> +				skb_frag_t *frag =3D &sinfo->frags[i];
>> +				unsigned long frag_len, frag_off;
>> +
>> +				frag_len =3D skb_frag_size(frag);
>> +				frag_off =3D off - frag_off_total;
>> +				if (frag_off < frag_len) {
>> +					src_buff =3D skb_frag_address(frag) +
>> +						   frag_off;
>> +					copy_len =3D min(len,
>> +						       frag_len - frag_off);
>> +					break;
>> +				}
>> +				frag_off_total +=3D frag_len;
>> +			}
>> +		}
>> +		if (!src_buff)
>> +			break;
>> +
>> +		memcpy(dst_buff, src_buff, copy_len);
>> +		off +=3D copy_len;
>> +		len -=3D copy_len;
>> +		dst_buff +=3D copy_len;
>
> This block reads odd to be because it requires looping over the frags
> multiple times? Why not something like this,
>
>   if (off < base_len) {
>    src_buff =3D xdp->data + off
>    copy_len =3D min...
>    memcpy(dst_buff, src_buff, copy_len)
>    off +=3D copylen
>    len -=3D copylen
>    dst_buff +=3D copylen;
>   }
>
>   for (i =3D 0; i , nr_frags; i++) {
>      frag =3D ...
>      ...
>      if frag_off < fraglen
>         ...
>         memcpy()
>         update(off, len, dst_buff)
>   }
>
>
> Maybe use a helper to set off,len and dst_buff if worried about the
> duplication. Seems cleaner than walking through 0..n-1 frags for
> each copy.

You are right it looks odd, will re-write this in the next iteration.

>> +	} while (len);
>> +
>>  	return 0;
>>  }

