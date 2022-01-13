Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA9A48D515
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 10:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbiAMJiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 04:38:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57050 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233239AbiAMJiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 04:38:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642066699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kQD5p5NWQMBrAGKB2/BCKP0vR7Lbdo15hUkgoApm5FE=;
        b=UllCIJOOdgxGhSFiObNnvtzuDoAZCwHFdWvlpQP+jPtWJo3ZxO0uP7p2CvGKUiOth0dydK
        kKw3j0FmbyvhjL2cCJSkLie7QMcx7+wFOftfMVvAZvorNLPkikIgQOKuW7knzu2+HE0dCu
        CC1d91GO4N6d6hl99fo9yuQBg3/7CSQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-mZJxdOm3NIypiB6b-p-K6w-1; Thu, 13 Jan 2022 04:38:18 -0500
X-MC-Unique: mZJxdOm3NIypiB6b-p-K6w-1
Received: by mail-ed1-f70.google.com with SMTP id o20-20020a056402439400b003f83cf1e472so4817149edc.18
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 01:38:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=kQD5p5NWQMBrAGKB2/BCKP0vR7Lbdo15hUkgoApm5FE=;
        b=lAj2kuL0xAEUEF2zMk4rZUXjRyzZyx3ZTWov68QvSq9E4a2FU3Oa/QzQHxzAf2U6OD
         iRl70sGth/bGrcID3TAIvpGJWj4EmIEiA13SZzpoLgo5rQFIMnu3WPBqnzarZ4eatcp4
         wTdRe8HpXY2oYVenDaNjPjp+LDCJSVbmexT98hvKS6UlEnofTiH3W9JFevV5CTmiZt9u
         3K1eM8oVUuJnvRbc6NM4U8S42WeFxlspJtIQkeuwyimsVpu8jSxFDQ7UiXqpT6KDxDt2
         Nw1936BLF63aXytzeM1e5XfGDtaU+44ku47x8iyl/WOBkeWFb0D/kF7xt/48nuyVcpG7
         y5nA==
X-Gm-Message-State: AOAM531k1EpiHCQgTVZSf5lxgVCqftoiv+Bs2cFxmIMbDCOj59OyXCg6
        Fnys4C45+I6w/FqDQ9Q2vy6Y7K8CQ2jKLV/LDtAXsqZ7Ktbzf0D/n9SFl8p5YB1tt744zU39uX5
        p44qquoYKhEygZDsV
X-Received: by 2002:a17:906:4c87:: with SMTP id q7mr3130180eju.460.1642066696786;
        Thu, 13 Jan 2022 01:38:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyt6GFpvdTxYI9MQLmn7UfjuXIcy3NkPau7VxfzbW1SJUobQ69lafcDRHzcW0Gq1aqSdE3ivQ==
X-Received: by 2002:a17:906:4c87:: with SMTP id q7mr3130156eju.460.1642066696478;
        Thu, 13 Jan 2022 01:38:16 -0800 (PST)
Received: from [192.168.2.20] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id 11sm676157ejv.220.2022.01.13.01.38.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jan 2022 01:38:15 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <47a3863b-080c-3ac2-ff2d-466b74d82c1c@redhat.com>
Date:   Thu, 13 Jan 2022 10:38:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shay Agroskin <shayagr@amazon.com>,
        john fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v21 bpf-next 18/23] libbpf: Add SEC name for xdp_mb
 programs
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Zvi Effron <zeffron@riotgames.com>
References: <cover.1641641663.git.lorenzo@kernel.org>
 <f9103d787144983524ba331273718e422a63a767.1641641663.git.lorenzo@kernel.org>
 <CAEf4BzbfDvH5CYNsWg9Dx7JcFEp4jNmNRR6H-6sJEUxDSy1zZw@mail.gmail.com>
 <Yd8bVIcA18KIH6+I@lore-desk>
 <CAEf4Bza+WO5U+Kw=S+GvQBgu5VHfPL29u7eLSQq34jvYzGnbBA@mail.gmail.com>
 <CAADnVQLGxjvOO3Ae3mGTWTyd0aHnACxYoF8daNi+z56NQyYQug@mail.gmail.com>
 <CAEf4BzZ4c1VwPf9oBRRdN7jdBWrk4pg=mw_50LMjLr99Mb0yfw@mail.gmail.com>
 <CAADnVQ+BiMy4TZNocfFSvazh-QTFwMD-3uQ9LLiku7ePLDn=MQ@mail.gmail.com>
 <CAC1LvL0CeTw+YKjO6r0f68Ly3tK4qhDyjV0ak82e0PpHURVQOw@mail.gmail.com>
 <Yd82J8vxSAR9tvQt@lore-desk> <8735lshapk.fsf@toke.dk>
In-Reply-To: <8735lshapk.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/01/2022 23.04, Toke Høiland-Jørgensen wrote:
> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> 
>>> On Wed, Jan 12, 2022 at 11:47 AM Alexei Starovoitov
>>> <alexei.starovoitov@gmail.com> wrote:
>>>>
>>>> On Wed, Jan 12, 2022 at 11:21 AM Andrii Nakryiko
>>>> <andrii.nakryiko@gmail.com> wrote:
>>>>>
>>>>> On Wed, Jan 12, 2022 at 11:17 AM Alexei Starovoitov
>>>>> <alexei.starovoitov@gmail.com> wrote:
>>>>>>
>>>>>> On Wed, Jan 12, 2022 at 10:24 AM Andrii Nakryiko
>>>>>> <andrii.nakryiko@gmail.com> wrote:
>>>>>>>
>>>>>>> On Wed, Jan 12, 2022 at 10:18 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>>>>>>>>
>>>>>>>>> On Sun, Jan 9, 2022 at 7:05 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>>>>>>>>>>
>>>>>>>>>> Introduce support for the following SEC entries for XDP multi-buff
>>>>>>>>>> property:
>>>>>>>>>> - SEC("xdp_mb/")
>>>>>>>>>> - SEC("xdp_devmap_mb/")
>>>>>>>>>> - SEC("xdp_cpumap_mb/")
>>>>>>>>>
>>>>>>>>> Libbpf seemed to went with .<suffix> rule (e.g., fentry.s for
>>>>>>>>> sleepable, seems like we'll have kprobe.multi or  something along
>>>>>>>>> those lines as well), so let's stay consistent and call this "xdp_mb",
>>>>>>>>> "xdp_devmap.mb", "xdp_cpumap.mb" (btw, is "mb" really all that
>>>>>>>>> recognizable? would ".multibuf" be too verbose?). Also, why the "/"
>>>>>>>>> part? Also it shouldn't be "sloppy" either. Neither expected attach
>>>>>>>>> type should be optional.  Also not sure SEC_ATTACHABLE is needed. So
>>>>>>>>> at most it should be SEC_XDP_MB, probably.
>>>>>>>>
>>>>>>>> ack, I fine with it. Something like:
>>>>>>>>
>>>>>>>>          SEC_DEF("lsm.s/",               LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
>>>>>>>>          SEC_DEF("iter/",                TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
>>>>>>>>          SEC_DEF("syscall",              SYSCALL, 0, SEC_SLEEPABLE),
>>>>>>>> +       SEC_DEF("xdp_devmap.multibuf",  XDP, BPF_XDP_DEVMAP, 0),
>>>>>>>>          SEC_DEF("xdp_devmap/",          XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE),
>>>>>>>> +       SEC_DEF("xdp_cpumap.multibuf",  XDP, BPF_XDP_CPUMAP, 0),
>>>>>>>>          SEC_DEF("xdp_cpumap/",          XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE),
>>>>>>>> +       SEC_DEF("xdp.multibuf",         XDP, BPF_XDP, 0),
>>>>>>>
>>>>>>> yep, but please use SEC_NONE instead of zero
>>>>>>>
>>>>>>>>          SEC_DEF("xdp",                  XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
>>>>>>>>          SEC_DEF("perf_event",           PERF_EVENT, 0, SEC_NONE | SEC_SLOPPY_PFX),
>>>>>>>>          SEC_DEF("lwt_in",               LWT_IN, 0, SEC_NONE | SEC_SLOPPY_PFX),
>>>>>>>>
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
>>>>>>>>>> Acked-by: John Fastabend <john.fastabend@gmail.com>
>>>>>>>>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>>>>>>>>> ---
>>>>>>>>>>   tools/lib/bpf/libbpf.c | 8 ++++++++
>>>>>>>>>>   1 file changed, 8 insertions(+)
>>>>>>>>>>
>>>>>>>>>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>>>>>>>>>> index 7f10dd501a52..c93f6afef96c 100644
>>>>>>>>>> --- a/tools/lib/bpf/libbpf.c
>>>>>>>>>> +++ b/tools/lib/bpf/libbpf.c
>>>>>>>>>> @@ -235,6 +235,8 @@ enum sec_def_flags {
>>>>>>>>>>          SEC_SLEEPABLE = 8,
>>>>>>>>>>          /* allow non-strict prefix matching */
>>>>>>>>>>          SEC_SLOPPY_PFX = 16,
>>>>>>>>>> +       /* BPF program support XDP multi-buff */
>>>>>>>>>> +       SEC_XDP_MB = 32,
>>>>>>>>>>   };
>>>>>>>>>>
>>>>>>>>>>   struct bpf_sec_def {
>>>>>>>>>> @@ -6562,6 +6564,9 @@ static int libbpf_preload_prog(struct bpf_program *prog,
>>>>>>>>>>          if (def & SEC_SLEEPABLE)
>>>>>>>>>>                  opts->prog_flags |= BPF_F_SLEEPABLE;
>>>>>>>>>>
>>>>>>>>>> +       if (prog->type == BPF_PROG_TYPE_XDP && (def & SEC_XDP_MB))
>>>>>>>>>> +               opts->prog_flags |= BPF_F_XDP_MB;
>>>>>>>>>
>>>>>>>>> I'd say you don't even need SEC_XDP_MB flag at all, you can just check
>>>>>>>>> that prog->sec_name is one of "xdp.mb", "xdp_devmap.mb" or
>>>>>>>>> "xdp_cpumap.mb" and add the flag. SEC_XDP_MB doesn't seem generic
>>>>>>>>> enough to warrant a flag.
>>>>>>>>
>>>>>>>> ack, something like:
>>>>>>>>
>>>>>>>> +       if (prog->type == BPF_PROG_TYPE_XDP &&
>>>>>>>> +           (!strcmp(prog->sec_name, "xdp_devmap.multibuf") ||
>>>>>>>> +            !strcmp(prog->sec_name, "xdp_cpumap.multibuf") ||
>>>>>>>> +            !strcmp(prog->sec_name, "xdp.multibuf")))
>>>>>>>> +               opts->prog_flags |= BPF_F_XDP_MB;
>>>>>>>
>>>>>>> yep, can also simplify it a bit with strstr(prog->sec_name,
>>>>>>> ".multibuf") instead of three strcmp
>>>>>>
>>>>>> Maybe ".mb" ?
>>>>>> ".multibuf" is too verbose.
>>>>>> We're fine with ".s" for sleepable :)
>>>>>
>>>>>
>>>>> I had reservations about "mb" because the first and strong association
>>>>> is "megabyte", not "multibuf". And it's not like anyone would have
>>>>> tens of those programs in a single file so that ".multibuf" becomes
>>>>> way too verbose. But I don't feel too strongly about this, if the
>>>>> consensus is on ".mb".
>>>>
>>>> The rest of the patches are using _mb everywhere.
>>>> I would keep libbpf consistent.
>>>
>>> Should the rest of the patches maybe use "multibuf" instead of "mb"? I've been
>>> following this patch series closely and excitedly, and I keep having to remind
>>> myself that "mb" is "multibuff" and not "megabyte". If I'm having to correct
>>> myself while following the patch series, I'm wondering if future confusion is
>>> inevitable?
>>>
>>> But, is it enough confusion to be worth updating many other patches? I'm not
>>> sure.
>>>
>>> I agree consistency is more important than the specific term we're consistent
>>> on.
>>
>> I would prefer to keep the "_mb" postfix, but naming is hard and I am
>> polarized :)
> 
> I would lean towards keeping _mb as well, but if it does have to be
> changed why not _mbuf? At least that's not quite as verbose :)

I dislike the "mb" abbreviation as I forget it stands for multi-buffer.
I like the "mbuf" suggestion, even-though it conflicts with (Free)BSD 
mbufs (which is their SKB).

I prefer/support the .<suffix> idea from Andrii.
Which would then be ".mbuf" for my taste.

--Jesper
p.s. I like the bikeshed red, meaning I don't feel too strongly about this.

