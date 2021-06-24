Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794E13B2B58
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 11:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbhFXJ3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 05:29:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21135 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230438AbhFXJ3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 05:29:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624526806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GIuAW01cKS1OnZV8RMNx2Mi1DilXa0t5oJqTvg7N4GM=;
        b=TxDPYveuIQR16XeUZoxZVXPqgyyHtQ6tLIEQGuI3ER43MdI/E70+7nze+/o17zDQdjSIjB
        Y8DbLLaedy1FfQx4xTAkTH+hqM4CcfUo8aJA0B1WfkzFsHX/zYYNQAyF0fwIoBEj3bmTMC
        araInfU9dnBLqHSVDXr1OPskMqhGG6Q=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-dD2BtSxFPke4xwvH5Nm1aA-1; Thu, 24 Jun 2021 05:26:45 -0400
X-MC-Unique: dD2BtSxFPke4xwvH5Nm1aA-1
Received: by mail-ed1-f69.google.com with SMTP id z5-20020a05640235c5b0290393974bcf7eso3026556edc.2
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 02:26:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GIuAW01cKS1OnZV8RMNx2Mi1DilXa0t5oJqTvg7N4GM=;
        b=MDm+pOhf3g/0lGe85qGRNFpzlTMd1hBaWtTUcEirfPcRBFjKZX+2pu3kM8w9b6GTXO
         EAvKLQAhN82jX0K+C4HXt3PWiVEw5qhYieWuNlAI32lfTb3Ozwppbe27Ra8ZmHCV/TRw
         gEXpt/f60kQ1ZLo0L+aRGX0tIs57+ipBeiOSC6I8JRt36w3l8AxzOJ4Ih+FbppT63cV1
         iIyYbmhfrbzyDPNhbNR20pF8AWMPCQUCbzNFujAcwAJZdOTamahutt39nWubN48OGSnQ
         MP6b/bbjDVuzFcxdu/P3b2VcOIvicQXj8idpHy2iDMJmsgu3pcJ2KVKB8Q9BttytnXDm
         Jrig==
X-Gm-Message-State: AOAM532gp3zK93FKza6GCD5iZ6QBMTmh1auN5ImFj3XH4P4u8E56bz/A
        wX36lmIKgMMDx3+r1bIkxJkt+OZmuqVD6a5lRMjnAH7u32HXYpOdezCYuXu6gENyh8SIlN2F4mf
        /aOh1BTGMe4B9Q0QA
X-Received: by 2002:a17:906:a20b:: with SMTP id r11mr4309450ejy.221.1624526802177;
        Thu, 24 Jun 2021 02:26:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8E+0cai8MQR04OQxOX2CPQPfA42Ue3UnJYcd/aSqSVey3Y/2g+42Y3U5KRP717THGCq3z5w==
X-Received: by 2002:a17:906:a20b:: with SMTP id r11mr4309434ejy.221.1624526801991;
        Thu, 24 Jun 2021 02:26:41 -0700 (PDT)
Received: from [10.36.112.236] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id o5sm1539546edt.44.2021.06.24.02.26.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jun 2021 02:26:41 -0700 (PDT)
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
Subject: Re: [PATCH v9 bpf-next 08/14] bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
Date:   Thu, 24 Jun 2021 11:26:39 +0200
X-Mailer: MailMate (1.14r5816)
Message-ID: <4F52EE5B-1A3F-46CE-9A39-98475CA6B684@redhat.com>
In-Reply-To: <60d2744ee12c2_1342e208f7@john-XPS-13-9370.notmuch>
References: <cover.1623674025.git.lorenzo@kernel.org>
 <863f4934d251f44ad85a6be08b3737fac74f9b5a.1623674025.git.lorenzo@kernel.org>
 <60d2744ee12c2_1342e208f7@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23 Jun 2021, at 1:37, John Fastabend wrote:

> Lorenzo Bianconi wrote:
>> From: Eelco Chaudron <echaudro@redhat.com>
>>
>> This change adds support for tail growing and shrinking for XDP multi-=
buff.
>>
>
> It would be nice if the commit message gave us some details on how the
> growing/shrinking works in the multi-buff support.

Will add this to the next rev.

>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>> ---
>>  include/net/xdp.h |  7 ++++++
>>  net/core/filter.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++=
+
>>  net/core/xdp.c    |  5 ++--
>>  3 files changed, 72 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/net/xdp.h b/include/net/xdp.h
>> index 935a6f83115f..3525801c6ed5 100644
>> --- a/include/net/xdp.h
>> +++ b/include/net/xdp.h
>> @@ -132,6 +132,11 @@ xdp_get_shared_info_from_buff(struct xdp_buff *xd=
p)
>>  	return (struct skb_shared_info *)xdp_data_hard_end(xdp);
>>  }
>>
>> +static inline unsigned int xdp_get_frag_tailroom(const skb_frag_t *fr=
ag)
>> +{
>> +	return PAGE_SIZE - skb_frag_size(frag) - skb_frag_off(frag);
>> +}
>> +
>>  struct xdp_frame {
>>  	void *data;
>>  	u16 len;
>> @@ -259,6 +264,8 @@ struct xdp_frame *xdp_convert_buff_to_frame(struct=
 xdp_buff *xdp)
>>  	return xdp_frame;
>>  }
>>
>> +void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_dir=
ect,
>> +		  struct xdp_buff *xdp);
>>  void xdp_return_frame(struct xdp_frame *xdpf);
>>  void xdp_return_frame_rx_napi(struct xdp_frame *xdpf);
>>  void xdp_return_buff(struct xdp_buff *xdp);
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index caa88955562e..05f574a3d690 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -3859,11 +3859,73 @@ static const struct bpf_func_proto bpf_xdp_adj=
ust_head_proto =3D {
>>  	.arg2_type	=3D ARG_ANYTHING,
>>  };
>>
>> +static int bpf_xdp_mb_adjust_tail(struct xdp_buff *xdp, int offset)
>> +{
>> +	struct skb_shared_info *sinfo;
>> +
>> +	if (unlikely(!xdp_buff_is_mb(xdp)))
>> +		return -EINVAL;
>> +
>> +	sinfo =3D xdp_get_shared_info_from_buff(xdp);
>> +	if (offset >=3D 0) {
>> +		skb_frag_t *frag =3D &sinfo->frags[sinfo->nr_frags - 1];
>> +		int size;
>> +
>> +		if (unlikely(offset > xdp_get_frag_tailroom(frag)))
>> +			return -EINVAL;
>> +
>> +		size =3D skb_frag_size(frag);
>> +		memset(skb_frag_address(frag) + size, 0, offset);
>> +		skb_frag_size_set(frag, size + offset);
>> +		sinfo->data_len +=3D offset;
>
> Can you add some comment on how this works? So today I call
> bpf_xdp_adjust_tail() to add some trailer to my packet.
> This looks like it adds tailroom to the last frag? But, then
> how do I insert my trailer? I don't think we can without the
> extra multi-buffer access support right.

You are right, we need some kind of multi-buffer access helpers.

> Also data_end will be unchanged yet it will return 0 so my
> current programs will likely be a bit confused by this.

Guess this is the tricky part, applications need to be multi-buffer aware=
=2E If current applications rely on bpf_xdp_adjust_tail(+) to determine m=
aximum frame length this approach might not work. In this case, we might =
need an additional helper to do tail expansion with multi buffer support.=


But then the question arrives how would mb unaware application behave in =
general when an mb packet is supplied?? It would definitely not determine=
 the correct packet length.

>> +	} else {

