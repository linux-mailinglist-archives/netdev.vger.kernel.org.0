Return-Path: <netdev+bounces-4177-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70BE270B7D3
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 10:37:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA66C1C209EB
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 08:37:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1DA06ADF;
	Mon, 22 May 2023 08:37:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0078A31
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 08:37:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C6FBB
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 01:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684744658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ULe3QhngoAVvRa/b5eatSIbIrZ5mn5rlreUM83YWtHk=;
	b=HaB5L/qUP6qSN+ugxrICARoTuDqDDEbnA2V0MxnCFz4oHwYjjY8pzUXRvS5tmVU034qRwX
	30922clIm+OfLNXmL0NwA6lCJS43rDI+yUSfAZkiJJodjSkKYVU6frAhE0/hgPp5FK0UHh
	mIAn0FkFnOpdkFLukSv3d0HVT/IjmH0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-JADSOJMzN9ChFxBPC58CgA-1; Mon, 22 May 2023 04:37:36 -0400
X-MC-Unique: JADSOJMzN9ChFxBPC58CgA-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-513f4c301e8so365602a12.2
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 01:37:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684744655; x=1687336655;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:cc:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ULe3QhngoAVvRa/b5eatSIbIrZ5mn5rlreUM83YWtHk=;
        b=k7JjWXnRVQA6HppsWJj+EBrAwud6yIUUu8UfT1qszxlhGwI4f0EaZdi/a2iC78NPbU
         eZDK73rjEvm1vethWTjnvruUyX0EPW2tQhLTM86oDVXOhScNZn3s0gDbw+1+rj23Fj5l
         +Eiufjqmqi0nJfrNALEME49eMUFdCjBzDvjCoEzB5ISVu1sWE3lNdivXWypuVT5QVPxf
         TJa3XkPqah9zuHs5gMZBU/XnDsQCicMHlWDK1HgeQQTkIZSIzfdcv6LkrMlgOcM9ESLA
         EXSHJWpCB1IzlEfDAD+xFGK1iNmYAUGNpUphS6WsQu1cjK10xA0PfOXfA61A2OZcHc0K
         ha1Q==
X-Gm-Message-State: AC+VfDxj3OHHhaJeV3sADutUDRX2rFsSPdz/Nmef8+RqQAPxQTtWntUN
	bTfh4rHxczo6FP1C4EG/Mud6OSGqmfontTlnJ7X/u5b3jHwLdn2cT3MRmrqPi+xRnfydn15L79t
	Zg2K+xSpbwfOdIS4k
X-Received: by 2002:aa7:d38c:0:b0:510:d6b3:a1ac with SMTP id x12-20020aa7d38c000000b00510d6b3a1acmr8453281edq.13.1684744655570;
        Mon, 22 May 2023 01:37:35 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5f18cr/MklnXamgE+eoXJg4tSU/Wtu6RdKgmQLwi6TTslgyXXsqPjGkEeqNYYjBLm9MG4X9A==
X-Received: by 2002:aa7:d38c:0:b0:510:d6b3:a1ac with SMTP id x12-20020aa7d38c000000b00510d6b3a1acmr8453239edq.13.1684744655189;
        Mon, 22 May 2023 01:37:35 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id d24-20020aa7d698000000b005067d089aafsm2716077edr.11.2023.05.22.01.37.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 May 2023 01:37:34 -0700 (PDT)
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <094f3178-2797-e297-64f8-aa0f7ef16b5f@redhat.com>
Date: Mon, 22 May 2023 10:37:33 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Cc: brouer@redhat.com, bpf@vger.kernel.org,
 Stanislav Fomichev <sdf@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
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
Subject: Re: [PATCH RESEND bpf-next 09/15] xdp: Add VLAN tag hint
To: Larysa Zaremba <larysa.zaremba@intel.com>,
 Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <20230512152607.992209-1-larysa.zaremba@intel.com>
 <20230512152607.992209-10-larysa.zaremba@intel.com>
 <b0694577-e2b3-f6de-cf85-aed99fdf2496@redhat.com> <ZGJZU89AK/3mFZXW@lincoln>
Content-Language: en-US
In-Reply-To: <ZGJZU89AK/3mFZXW@lincoln>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 15/05/2023 18.09, Larysa Zaremba wrote:
> On Mon, May 15, 2023 at 05:36:12PM +0200, Jesper Dangaard Brouer wrote:
>>
>>
>> On 12/05/2023 17.26, Larysa Zaremba wrote:
>>> Implement functionality that enables drivers to expose VLAN tag
>>> to XDP code.
>>>
>>> Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
>>> ---
>> [...]
>>
>>> diff --git a/net/core/xdp.c b/net/core/xdp.c
>>> index 41e5ca8643ec..eff21501609f 100644
>>> --- a/net/core/xdp.c
>>> +++ b/net/core/xdp.c
>>> @@ -738,6 +738,30 @@ __bpf_kfunc int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32 *hash,
>>>    	return -EOPNOTSUPP;
>>>    }
>>
>> Remember below becomes part of main documentation on HW metadata hints:
>>   - https://kernel.org/doc/html/latest/networking/xdp-rx-metadata.html
>>
>> Hint compiling locally I use:
>>   make SPHINXDIRS="networking" htmldocs
>>
>>> +/**
>>> + * bpf_xdp_metadata_rx_ctag - Read XDP packet inner vlan tag.
>>
>> Is bpf_xdp_metadata_rx_ctag a good function name for the inner vlan tag?
>> Like wise below "stag".
>>
>> I cannot remember if the C-tag or S-tag is the inner or outer vlan tag.
>>
>> When reading BPF code that use these function names, then I would have
>> to ask Google for help, or find-and-read this doc.
>>
>> Can we come-up with a more intuitive name, that e.g. helps when reading
>> the BPF-prog code?
> 
> Well, my reasoning for such naming is that if someone can configure s-tag
> stripping in ethtool with 'rx-vlan-stag-hw-parse', they shouldn't have any
> problem with understanding those function names.
> 

Naming is hard.  My perspective is conveying the meaning without having
to be knowledgeable about ethtool VLAN commands.  My perspective is a
casual BPF-programmer that reads "bpf_xdp_metadata_rx_stag()".
Hopefully we can choose a name that says "vlan" somewhere, such that the
person reading this doesn't have to lookup and find the documentation to
deduct this code is related to VLANs.

> One possible improvement that comes to mind is maybe (similarly ethtool) calling
> c-tag just 'tag' and letting s-tag stay 'stag'. Because c-tag is this default
> 802.1q tag, which is supported by various hardware, while s-tag is significantly
> less widespread.
> 
> But there are many options, really.
> 
> What are your suggestions?
>

One suggestion is (the symmetrical):
  * bpf_xdp_metadata_rx_vlan_inner_tag
  * bpf_xdp_metadata_rx_vlan_outer_tag

As you say above the first "inner" VLAN tag is just the regular 802.1Q
VLAN tag.  The concept of C-tag and S-tag is from 802.1ad that
introduced the concept of double tagging.

Thus one could argue for shorter names like:
  * bpf_xdp_metadata_rx_vlan_tag
  * bpf_xdp_metadata_rx_vlan_outer_tag


>>
>>> + * @ctx: XDP context pointer.
>>> + * @vlan_tag: Return value pointer.
>>> + *
>>
>> IMHO right here, there should be a description.
>>
>> E.g. for what a VLAN "tag" means.  I assume a "tag" isn't the VLAN id,
>> but the raw VLAN tag that also contains the prio numbers etc.
>>
>> It this VLAN tag expected to be in network-byte-order ?
>> IMHO this doc should define what is expected (and driver devel must
>> follow this).
> 
> Will specify that.
> 
>>
>>> + * Returns 0 on success or ``-errno`` on error.
>>> + */
>>> +__bpf_kfunc int bpf_xdp_metadata_rx_ctag(const struct xdp_md *ctx, u16 *vlan_tag)
>>> +{
>>> +	return -EOPNOTSUPP;
>>> +}
>>> +
>>> +/**
>>> + * bpf_xdp_metadata_rx_stag - Read XDP packet outer vlan tag.
>>> + * @ctx: XDP context pointer.
>>> + * @vlan_tag: Return value pointer.
>>> + *

(p.s. Googling I find multiple definitions of what the "S" in S-tag
means. The most reliable or statistically consistent seems to be
"Service tag", or "Service provider tag".)

The description for the renamed "bpf_xdp_metadata_rx_vlan_outer_tag"
should IMHO explain that the outer VLAN tag is often refered to as the 
S-tag (or Service-tag) in Q-in-Q (802.1ad) terminology.  Perhaps we can 
even spell out that some hardware support (and must be configured via 
ethtool) to extract this stag.

A dump of the tool rx-vlan related commands:

   $ ethtool -k i40e2 | grep rx-vlan
   rx-vlan-offload: on
   rx-vlan-filter: on [fixed]
   rx-vlan-stag-hw-parse: off [fixed]
   rx-vlan-stag-filter: off [fixed]




>>> + * Returns 0 on success or ``-errno`` on error.
>>
>> IMHO we should provide more guidance to expected return codes, and what
>> they mean.  IMHO driver developers must only return codes that are
>> described here, and if they invent a new, add it as part of their patch.
> 
> That's a good suggestion, I will expand the comment to describe error codes used
> so far.
> 
>>
>> See, formatting in bpf_xdp_metadata_rx_hash and check how this gets
>> compiled into HTML.
>>
>>
>>> + */
>>> +__bpf_kfunc int bpf_xdp_metadata_rx_stag(const struct xdp_md *ctx, u16 *vlan_tag)
>>> +{
>>> +	return -EOPNOTSUPP;
>>> +}
>>> +
>>
> 


