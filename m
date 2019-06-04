Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9637134CAC
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 17:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbfFDPyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 11:54:54 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39727 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727422AbfFDPyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 11:54:54 -0400
Received: by mail-pl1-f194.google.com with SMTP id g9so8508845plm.6;
        Tue, 04 Jun 2019 08:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jRNjg7rYwJdFTreLCA3M8FHf9grYE2WZ9UXcOrvY/do=;
        b=q/5egsil23avZ9UpTSepFZzZUMo6LmVJD5vD99Bracl9o++jZcfBVCg87RXpfVfGrH
         kkON+vvmb/rrxXhVoJ+/DmCB1hZR4V3aqAnXySyUtgjvLu9FNVPzbKoq9dJ/yla+5Nys
         f9dcl/ozleR6UKaJ1VV8W2gkkf6UB6SDS3zJUng4g3YOKfIZEKPbjUSOc3Qf+QzMdP8L
         2Ai1ROuFY2Qdp9DD24O9qjTxfdSaB1ocFSbjI1oA61WRLuzHWsYnlutVRRNEuswMkkWs
         MTxzw0JcQ2UxfhHhBChm6O3ku9FuZdtP0L3oPAhhQYlBNky3NUgrXIbdQI4949Tewqdn
         33bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jRNjg7rYwJdFTreLCA3M8FHf9grYE2WZ9UXcOrvY/do=;
        b=FwbQA3VWW5/hgTRkIyDAnGqiMNzdV89WwHSykwF1en0WztnDNA3+y+S7mt0fdl/ISj
         7XRkPJxSWQdMJchUiuBL5YEHeJHUJ+QWU2urQSgvRSZfa4VK60Xim9loethRpHpG4aiH
         jK1pAfEtQIHsJDWgUQjt3GZJQ7QJcfYZwCpzNrZaw/hQ+dLvGomJMBl2Mca5YiVMgQK3
         v+u/+5wLkXidRnVfROp40jxoyovQ96nBlFb/F7OoCDsrdV/tRJW/2KI0PY/6kOd0zOUB
         rWlBDoY0SKfK66aqkM4Q1lwbmgGXpR/vt7d0/BoOpF+JLc8NwS6cYoC1oeudHJOBg7qe
         jQTw==
X-Gm-Message-State: APjAAAX2ku5FJaZRN5rjMGo/D5/ikpQU7UBzMeW0iclPvZ85m3BbxSYN
        PxBcSSi2G96vPof2rmTEDus=
X-Google-Smtp-Source: APXvYqzYE0GmcX09xdCG2S/WCbZW91EcfZpul2p/gl89XaaRfL3zASRBrqmqnQs4tS5cf5BcWdPi+A==
X-Received: by 2002:a17:902:2a29:: with SMTP id i38mr9898769plb.46.1559663693427;
        Tue, 04 Jun 2019 08:54:53 -0700 (PDT)
Received: from [172.20.52.202] ([2620:10d:c090:200::1:a068])
        by smtp.gmail.com with ESMTPSA id b15sm18172149pfi.141.2019.06.04.08.54.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 08:54:52 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Maciej Fijalkowski" <maciejromanfijalkowski@gmail.com>
Cc:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        songliubraving@fb.com, bpf <bpf@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 1/4] libbpf: fill the AF_XDP fill queue
 before bind() call
Date:   Tue, 04 Jun 2019 08:54:51 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <286FE15F-1633-4F9B-A78D-A53B3706C0C6@gmail.com>
In-Reply-To: <20190604170452.00001b29@gmail.com>
References: <20190603131907.13395-1-maciej.fijalkowski@intel.com>
 <20190603131907.13395-2-maciej.fijalkowski@intel.com>
 <76bc124c-46ed-f0a6-315e-1600c837aea0@intel.com>
 <20190604170452.00001b29@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4 Jun 2019, at 8:04, Maciej Fijalkowski wrote:

> On Tue, 4 Jun 2019 10:06:36 +0200
> Björn Töpel <bjorn.topel@intel.com> wrote:
>
>> On 2019-06-03 15:19, Maciej Fijalkowski wrote:
>>> Let's get into the driver via ndo_bpf with command set to 
>>> XDP_SETUP_UMEM
>>> with fill queue that already contains some available entries that 
>>> can be
>>> used by Rx driver rings. Things worked in such way on old version of
>>> xdpsock (that lacked libbpf support) and there's no particular 
>>> reason
>>> for having this preparation done after bind().
>>>
>>> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>>> Signed-off-by: Krzysztof Kazimierczak 
>>> <krzysztof.kazimierczak@intel.com>
>>> ---
>>>   samples/bpf/xdpsock_user.c | 15 ---------------
>>>   tools/lib/bpf/xsk.c        | 19 ++++++++++++++++++-
>>>   2 files changed, 18 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
>>> index d08ee1ab7bb4..e9dceb09b6d1 100644
>>> --- a/samples/bpf/xdpsock_user.c
>>> +++ b/samples/bpf/xdpsock_user.c
>>> @@ -296,8 +296,6 @@ static struct xsk_socket_info 
>>> *xsk_configure_socket(struct xsk_umem_info *umem)
>>>   	struct xsk_socket_config cfg;
>>>   	struct xsk_socket_info *xsk;
>>>   	int ret;
>>> -	u32 idx;
>>> -	int i;
>>>
>>>   	xsk = calloc(1, sizeof(*xsk));
>>>   	if (!xsk)
>>> @@ -318,19 +316,6 @@ static struct xsk_socket_info 
>>> *xsk_configure_socket(struct xsk_umem_info *umem)
>>>   	if (ret)
>>>   		exit_with_error(-ret);
>>>
>>> -	ret = xsk_ring_prod__reserve(&xsk->umem->fq,
>>> -				     XSK_RING_PROD__DEFAULT_NUM_DESCS,
>>> -				     &idx);
>>> -	if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
>>> -		exit_with_error(-ret);
>>> -	for (i = 0;
>>> -	     i < XSK_RING_PROD__DEFAULT_NUM_DESCS *
>>> -		     XSK_UMEM__DEFAULT_FRAME_SIZE;
>>> -	     i += XSK_UMEM__DEFAULT_FRAME_SIZE)
>>> -		*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx++) = i;
>>> -	xsk_ring_prod__submit(&xsk->umem->fq,
>>> -			      XSK_RING_PROD__DEFAULT_NUM_DESCS);
>>> -
>>>   	return xsk;
>>>   }
>>>
>>> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
>>> index 38667b62f1fe..57dda1389870 100644
>>> --- a/tools/lib/bpf/xsk.c
>>> +++ b/tools/lib/bpf/xsk.c
>>> @@ -529,7 +529,8 @@ int xsk_socket__create(struct xsk_socket 
>>> **xsk_ptr, const char *ifname,
>>>   	struct xdp_mmap_offsets off;
>>>   	struct xsk_socket *xsk;
>>>   	socklen_t optlen;
>>> -	int err;
>>> +	int err, i;
>>> +	u32 idx;
>>>
>>>   	if (!umem || !xsk_ptr || !rx || !tx)
>>>   		return -EFAULT;
>>> @@ -632,6 +633,22 @@ int xsk_socket__create(struct xsk_socket 
>>> **xsk_ptr, const char *ifname,
>>>   	}
>>>   	xsk->tx = tx;
>>>
>>> +	err = xsk_ring_prod__reserve(umem->fill,
>>> +				     XSK_RING_PROD__DEFAULT_NUM_DESCS,
>>> +				     &idx);
>>> +	if (err != XSK_RING_PROD__DEFAULT_NUM_DESCS) {
>>> +		err = -errno;
>>> +		goto out_mmap_tx;
>>> +	}
>>> +
>>> +	for (i = 0;
>>> +	     i < XSK_RING_PROD__DEFAULT_NUM_DESCS *
>>> +		     XSK_UMEM__DEFAULT_FRAME_SIZE;
>>> +	     i += XSK_UMEM__DEFAULT_FRAME_SIZE)
>>> +		*xsk_ring_prod__fill_addr(umem->fill, idx++) = i;
>>> +	xsk_ring_prod__submit(umem->fill,
>>> +			      XSK_RING_PROD__DEFAULT_NUM_DESCS);
>>> +
>>
>> Here, entries are added to the umem fill ring regardless if Rx is 
>> being
>> used or not. For a Tx only setup, this is not what we want, right?
>
> Right, but we have such behavior even without this patch. So I see two 
> options
> here:
> - if you agree with this patch, then I guess we would need to pass the 
> info to
>   libbpf what exactly we are setting up (txonly, rxdrop, l2fwd)?
> - otherwise, we should be passing the opt_bench onto 
> xsk_configure_socket and
>   based on that decide whether we fill the fq or not?
>
>>
>> Thinking out loud here; Now libbpf is making the decision which umem
>> entries that are added to the fill ring. The sample application has 
>> this
>> (naive) scheme. I'm not sure that all applications would like that
>> policy. What do you think?
>>
>
> I find it convenient to have the fill queue in "initialized" state if 
> I am
> making use of it, especially in case when I am doing the ZC so I must 
> give the
> buffers to the driver via fill queue. So why would we bother other 
> applications
> to provide it? I must admit that I haven't used AF_XDP with other apps 
> than the
> example one, so I might not be able to elaborate further. Maybe other 
> people
> have different feelings about it.

I use the library for setting up all the ring bookkeeping, but use my 
own
application (and xdp program).  So I'd prefer not having the library do 
this -
as Björn notes, for some cases, the fill ring may not be populated.  I 
also
have some other use cases where I may not want to populate the fill ring 
until
later.


While convenient, I think there's a limit to what the library should be 
doing
for the user.
-- 
Jonathan
