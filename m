Return-Path: <netdev+bounces-4229-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1033870BC08
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 13:41:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D94841C208EB
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 11:41:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A1CED2F1;
	Mon, 22 May 2023 11:41:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09743BA27
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:41:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D3391
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 04:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684755708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XCoVn7ppCsfW0w+/vJ+0bLvd9vkfTR1n6Nckl2ntEFY=;
	b=SbWRYfGiYC9J5SfGc9zj54tIiE17JCzi2cAcdDQ59iAxu6JN1yLlWNG0SncU0yInX111Nk
	R4bViAmHbq+MB7pt3K9ryuZGWmfqUIKwK85+VmFv7s7zlyWgckgQJIxfNYvSXNwJfM8dhb
	Yr/VrvomBmeWG/O6ob+EvZ2MKYRXqYo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-_uGi8rphOrySi215ax8SeQ-1; Mon, 22 May 2023 07:41:47 -0400
X-MC-Unique: _uGi8rphOrySi215ax8SeQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-96fd3757c1dso133510666b.1
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 04:41:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684755706; x=1687347706;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XCoVn7ppCsfW0w+/vJ+0bLvd9vkfTR1n6Nckl2ntEFY=;
        b=Ar2B5x1fVJe0lpoehKMl2gimdn5sdxObq9ZjziIgp9wbKyW+vvXjIQ3uDK5TtZiFzU
         Xw272BXZF19B0jqT7gx2GxKfY0ELctqzzFsC8VEU76B2SN1swgOAq1hkMUCf7BBB+NaI
         5fwVo0PcMNuLacZt9deMiNcFiwG6e2+WKb/RK3kENKdY8c/Plial69lrf0lGZPst8iuN
         /dKBRkI/XOmLstKp4YMn/xF1XDfbjvP+ZpA470Y6Y1wAjrPsWaFNQjCn2Qvu7VwW2xcy
         /kLfnZCiYQLeLfg7aFXvNnPnRJQy4xGoaZX9jCyNAVIFuyXVRMzfQdAk3ECuNW5ZRLmA
         uupg==
X-Gm-Message-State: AC+VfDxVy8teLPZIM+pPVZKn1WoOdQYdDnBFLD24cXwzOr7vqSxcNWbe
	2vqYNjAXDXLgtJDFnwuUo7t2snx9MbptzK8V2sYoT66WV2jZHZPPgC9uQsl35qEwGohuuEhRR5S
	7UXFLUZjDRtZish2b
X-Received: by 2002:a17:906:db0d:b0:94f:1a23:2f1b with SMTP id xj13-20020a170906db0d00b0094f1a232f1bmr8806483ejb.24.1684755706362;
        Mon, 22 May 2023 04:41:46 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7kEr9SuDqWiEbnZsnBzZAAHBZaLG94azZPqviwtKlo0EM0qZLnGpvhLrmWW6uacj8eI75lGg==
X-Received: by 2002:a17:906:db0d:b0:94f:1a23:2f1b with SMTP id xj13-20020a170906db0d00b0094f1a232f1bmr8806456ejb.24.1684755706071;
        Mon, 22 May 2023 04:41:46 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id lx19-20020a170906af1300b0094f07545d40sm2980019ejb.220.2023.05.22.04.41.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 May 2023 04:41:45 -0700 (PDT)
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <fed6ef09-0f5b-8c3d-0484-bb0995d09282@redhat.com>
Date: Mon, 22 May 2023 13:41:43 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Cc: brouer@redhat.com, Larysa Zaremba <larysa.zaremba@intel.com>,
 bpf@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>,
 Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
 John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>,
 Jiri Olsa <jolsa@kernel.org>, Jesse Brandeburg <jesse.brandeburg@intel.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>,
 Anatoly Burakov <anatoly.burakov@intel.com>,
 Alexander Lobakin <alexandr.lobakin@intel.com>,
 Magnus Karlsson <magnus.karlsson@gmail.com>,
 Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
 netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND bpf-next 14/15] net, xdp: allow metadata > 32
Content-Language: en-US
To: Alexander Lobakin <aleksander.lobakin@intel.com>,
 Jesper Dangaard Brouer <jbrouer@redhat.com>,
 Daniel Borkmann <daniel@iogearbox.net>
References: <20230512152607.992209-1-larysa.zaremba@intel.com>
 <20230512152607.992209-15-larysa.zaremba@intel.com>
 <ee1ad4f2-34ab-4377-14d5-532cb0687180@redhat.com> <ZGJnFxzDTV2qE4zZ@lincoln>
 <b9a879b2-bb62-ba18-0bdd-5c126a1086a9@intel.com>
 <a37db72f-2e83-c838-7c81-8f01a5a0df32@redhat.com>
 <5b817d49-eefa-51c9-3b51-01f1dba17d42@intel.com>
In-Reply-To: <5b817d49-eefa-51c9-3b51-01f1dba17d42@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 19/05/2023 18.35, Alexander Lobakin wrote:
> From: Jesper Dangaard Brouer <jbrouer@redhat.com>
> Date: Tue, 16 May 2023 17:35:27 +0200
> 
>>
>> On 16/05/2023 14.37, Alexander Lobakin wrote:
>>> From: Larysa Zaremba<larysa.zaremba@intel.com>
>>> Date: Mon, 15 May 2023 19:08:39 +0200
>>>
>>>> On Mon, May 15, 2023 at 06:17:02PM +0200, Jesper Dangaard Brouer wrote:
>>>>>
>>>>> On 12/05/2023 17.26, Larysa Zaremba wrote:
>>>>>> From: Aleksander Lobakin<aleksander.lobakin@intel.com>
>>>>>>
>>>>>> When using XDP hints, metadata sometimes has to be much bigger
>>>>>> than 32 bytes. Relax the restriction, allow metadata larger than 32
>>>>>> bytes
>>>>>> and make __skb_metadata_differs() work with bigger lengths.
>>>>>>
>>>>>> Now size of metadata is only limited by the fact it is stored as u8
>>>>>> in skb_shared_info, so maximum possible value is 255.
>>>>>
>>>>> I'm confused, IIRC the metadata area isn't stored "in skb_shared_info".
>>>>> The maximum possible size is limited by the XDP headroom, which is also
>>>>> shared/limited with/by xdp_frame.  I must be reading the sentence
>>>>> wrong,
>>>>> somehow.
>>>
>>> skb_shared_info::meta_size  is u8. Since metadata gets carried from
>>> xdp_buff to skb, this check is needed (it's compile-time constant
>>> anyway).
>>> Check for headroom is done separately already (two sentences below).
>>>
>>
>> Damn, argh, for SKBs the "meta_len" is stored in skb_shared_info, which
>> is located on another cacheline.
>> That is a sure way to KILL performance! :-(
> 
> Have you read the code? I use type_max(typeof_member(shinfo, meta_len)),
> what performance are you talking about?
> 

Not talking about your changes (in this patch).

I'm realizing that SKBs using metadata area will have a performance hit
due to accessing another cacheline (the meta_len in skb_shared_info).

IIRC Daniel complained about this performance hit (in the past), I guess
this explains it.  IIRC Cilium changed to use percpu variables/datastore
to workaround this.


> The whole xdp_metalen_invalid() gets expanded into:
> 
> 	return (metalen % 4) || metalen > 255;
> 
> at compile-time. All those typeof shenanigans are only to not open-code
> meta_len's type/size/max.
> 
>>
>> But only use for SKBs that gets created from xdp with metadata, right?
>>

Normal netstack processing actually access this skb_shinfo->meta_len in
gro_list_prepare().  As the caller dev_gro_receive() later access other
memory in skb_shared_info, then the GRO code path already takes this hit
to begin with.

--Jesper


