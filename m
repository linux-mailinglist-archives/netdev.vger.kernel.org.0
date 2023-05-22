Return-Path: <netdev+bounces-4357-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC36570C2CC
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:55:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6797A280FEB
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:55:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D228154A9;
	Mon, 22 May 2023 15:55:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6728014286;
	Mon, 22 May 2023 15:55:28 +0000 (UTC)
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2948A107;
	Mon, 22 May 2023 08:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=3XGsqEuFdWjxpRIwiAwzbMYLJommpBUmf64o8Q70T54=; b=T3DhWwZvaaFpz7BUKGUYfo2SjO
	mnHOu0gFWqbJdNvvfVMzsr7HWt0aV5MpevFsuyJDWdKAo8zr+5Rr3x+VXBd7yRgncbklJv2GjuJE3
	t2VSzBIMvOhxun/YpvaQFaAGsDsRp6wyc394DMMtDoEB8tgIWkvIcOAgv4NdzapSXJ0iQCe54RrPd
	0zPEZgqJx3JbokWMmV+2Ogv8aCbxI9qghhH2GTaSbJzclGz2cCUQYjURJYo+VbsDvxjitAIFTXL5r
	6iyrrvcncV1twi+CoqplMGnBBFpIZ34k0ah6ZLAyhs3Hzf4qz8B01wfMdibZXOOQCYQn9Jyzya9HV
	lJdNJQmw==;
Received: from sslproxy06.your-server.de ([78.46.172.3])
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1q17sN-000HgE-IO; Mon, 22 May 2023 17:55:11 +0200
Received: from [85.1.206.226] (helo=linux.home)
	by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <daniel@iogearbox.net>)
	id 1q17sM-000UFQ-IZ; Mon, 22 May 2023 17:55:10 +0200
Subject: Re: [PATCH RESEND bpf-next 14/15] net, xdp: allow metadata > 32
To: Alexander Lobakin <aleksander.lobakin@intel.com>,
 Jesper Dangaard Brouer <jbrouer@redhat.com>
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
References: <20230512152607.992209-1-larysa.zaremba@intel.com>
 <20230512152607.992209-15-larysa.zaremba@intel.com>
 <ee1ad4f2-34ab-4377-14d5-532cb0687180@redhat.com> <ZGJnFxzDTV2qE4zZ@lincoln>
 <b9a879b2-bb62-ba18-0bdd-5c126a1086a9@intel.com>
 <a37db72f-2e83-c838-7c81-8f01a5a0df32@redhat.com>
 <5b817d49-eefa-51c9-3b51-01f1dba17d42@intel.com>
 <fed6ef09-0f5b-8c3d-0484-bb0995d09282@redhat.com>
 <d53f0150-d74b-7cf6-8fe7-324131b43982@intel.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <106900e6-ab94-b37f-dc9d-f0a4242bb90f@iogearbox.net>
Date: Mon, 22 May 2023 17:55:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <d53f0150-d74b-7cf6-8fe7-324131b43982@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26915/Mon May 22 09:23:18 2023)
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/22/23 5:28 PM, Alexander Lobakin wrote:
> From: Jesper Dangaard Brouer <jbrouer@redhat.com>
> Date: Mon, 22 May 2023 13:41:43 +0200
>> On 19/05/2023 18.35, Alexander Lobakin wrote:
>>> From: Jesper Dangaard Brouer <jbrouer@redhat.com>
>>> Date: Tue, 16 May 2023 17:35:27 +0200
> 
> [...]
> 
>> Not talking about your changes (in this patch).
>>
>> I'm realizing that SKBs using metadata area will have a performance hit
>> due to accessing another cacheline (the meta_len in skb_shared_info).
>>
>> IIRC Daniel complained about this performance hit (in the past), I guess
>> this explains it.  IIRC Cilium changed to use percpu variables/datastore
>> to workaround this.
> 
> Why should we compare metadata of skbs on GRO anyway? I was disabling it
> the old hints series (conditionally, if driver asks), moreover...
> ...if metadata contains full checksum, GRO will be broken completely due
> to this comparison (or any other frame-unique fields. VLAN tags and
> hashes are okay).

This is when BPF prog on XDP populates metadata with custom data when it
wants to transfer information from XDP to skb aka tc BPF prog side. percpu
data store may not work here as it is not guaranteed that skb might end up
on same CPU.

>>> The whole xdp_metalen_invalid() gets expanded into:
>>>
>>>      return (metalen % 4) || metalen > 255;
>>>
>>> at compile-time. All those typeof shenanigans are only to not open-code
>>> meta_len's type/size/max.
>>>
>>>>
>>>> But only use for SKBs that gets created from xdp with metadata, right?
>>>>
>>
>> Normal netstack processing actually access this skb_shinfo->meta_len in
>> gro_list_prepare().  As the caller dev_gro_receive() later access other
>> memory in skb_shared_info, then the GRO code path already takes this hit
>> to begin with.
> 
> You access skb_shinfo() often even before running XDP program, for
> example, when a frame is multi-buffer. Plus HW timestamps are also
> there, and so on.

