Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F265B49E90E
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 18:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244632AbiA0Rbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 12:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbiA0Rbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 12:31:53 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99409C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 09:31:52 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id n8so6799187lfq.4
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 09:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=Xawp1TwtSo/uo/1tbPqTEzWBuDJ4Y6t+ZX2/4mqpc+o=;
        b=tvJb51SK9pl9ihres+CxFmedKvEw9bFtuhVR5WdFnCRdDOTuIEMwabJE1kAZ5hmw9k
         TY28PIoWYpejGKA2zB6kDzlh6wFuzsVoFcRWRbXhVTVQpUv2RpezpOw6Qi8k28/x3LhM
         1bZMx1x/Kw8Ieybgn5Lyl7NsR1ymit5pUoq6I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=Xawp1TwtSo/uo/1tbPqTEzWBuDJ4Y6t+ZX2/4mqpc+o=;
        b=a/r4tdVO74Q8WQUYRiClFJd+T5lqnHWPc8XAiyRb3jFF4m6ogq9XNLcu1SWdR6jFaQ
         kX5R2b/t4LWtsEP91T4kEYjrPuf2Whyc3lRQF0Uhkg5KIlpSWCedUWjx+JGAEKXJAXjZ
         vPTrS0riC0dIiV+QPjrsNPWD9d/Kyrvnq7HqRENwjq59vjdyXd5Yjq6Vwdu4Sr9kMJRA
         FNrRICmDLjONYDeRNOfV4rqnAEBGIPYa+OMwDxE36sI56e9KmatklGbuamzCLCcl+BAc
         qAJzwVnJstIG8ieMwNwVtrfUrpnkihWuwCkSGGisDdk7sr5spBxsf2RiqnWyueF4ZV2g
         8BsA==
X-Gm-Message-State: AOAM530ytaDiVFip5qWyloADHaWSIaXHLRNTFV0x+xO6OerHQwHRxt0i
        Bk9EqERKcaFUWAbETPHNScc1zg==
X-Google-Smtp-Source: ABdhPJwPFC+0A5GkkdbCXcsa0Ip2DOjbqTjkpo4pPeBBj03PC4LuT64RBW9Hc31DrO3FWxxzkR4DOw==
X-Received: by 2002:a05:6512:3408:: with SMTP id i8mr3356039lfr.17.1643304710661;
        Thu, 27 Jan 2022 09:31:50 -0800 (PST)
Received: from cloudflare.com ([2a01:110f:4809:d800::e00])
        by smtp.gmail.com with ESMTPSA id i1sm958936ljn.39.2022.01.27.09.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 09:31:49 -0800 (PST)
References: <20220113070245.791577-1-imagedong@tencent.com>
 <87sftbobys.fsf@cloudflare.com>
 <20220125224524.fkodqvknsluihw74@kafai-mbp.dhcp.thefacebook.com>
 <CAADnVQKbYCCYjCMhEV7p1YzkAVSKvg-1VKfWVQYVL0TaESNxBQ@mail.gmail.com>
 <20220125235320.fx775qsdtqon272v@kafai-mbp.dhcp.thefacebook.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Menglong Dong <menglong8.dong@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "Network Development" <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mengen Sun <mengensun@tencent.com>, flyingpeng@tencent.com,
        mungerjiang@tencent.com, Menglong Dong <imagedong@tencent.com>
Subject: Re: [PATCH bpf-next] bpf: Add document for 'dst_port' of 'struct
 bpf_sock'
In-reply-to: <20220125235320.fx775qsdtqon272v@kafai-mbp.dhcp.thefacebook.com>
Date:   Thu, 27 Jan 2022 18:31:48 +0100
Message-ID: <8735l9rsor.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 12:53 AM CET, Martin KaFai Lau wrote:
> On Tue, Jan 25, 2022 at 03:02:37PM -0800, Alexei Starovoitov wrote:
>> On Tue, Jan 25, 2022 at 2:45 PM Martin KaFai Lau <kafai@fb.com> wrote:
>> >
>> > On Tue, Jan 25, 2022 at 08:24:27PM +0100, Jakub Sitnicki wrote:
>> > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> > > > index b0383d371b9a..891a182a749a 100644
>> > > > --- a/include/uapi/linux/bpf.h
>> > > > +++ b/include/uapi/linux/bpf.h
>> > > > @@ -5500,7 +5500,11 @@ struct bpf_sock {
>> > > >     __u32 src_ip4;
>> > > >     __u32 src_ip6[4];
>> > > >     __u32 src_port;         /* host byte order */
>> > > > -   __u32 dst_port;         /* network byte order */
>> > > > +   __u32 dst_port;         /* low 16-bits are in network byte order,
>> > > > +                            * and high 16-bits are filled by 0.
>> > > > +                            * So the real port in host byte order is
>> > > > +                            * bpf_ntohs((__u16)dst_port).
>> > > > +                            */
>> > > >     __u32 dst_ip4;
>> > > >     __u32 dst_ip6[4];
>> > > >     __u32 state;
>> > >
>> > > I'm probably missing something obvious, but is there anything stopping
>> > > us from splitting the field, so that dst_ports is 16-bit wide?
>> > >
>> > > I gave a quick check to the change below and it seems to pass verifier
>> > > checks and sock_field tests.
>> > >
>> > > IDK, just an idea. Didn't give it a deeper thought.
>> > >
>> > > --8<--
>> > >
>> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> > > index 4a2f7041ebae..344d62ccafba 100644
>> > > --- a/include/uapi/linux/bpf.h
>> > > +++ b/include/uapi/linux/bpf.h
>> > > @@ -5574,7 +5574,8 @@ struct bpf_sock {
>> > >       __u32 src_ip4;
>> > >       __u32 src_ip6[4];
>> > >       __u32 src_port;         /* host byte order */
>> > > -     __u32 dst_port;         /* network byte order */
>> > > +     __u16 unused;
>> > > +     __u16 dst_port;         /* network byte order */
>> > This will break the existing bpf prog.
>> 
>> I think Jakub's idea is partially expressed:
>> +       case offsetof(struct bpf_sock, dst_port):
>> +               bpf_ctx_record_field_size(info, sizeof(__u16));
>> +               return bpf_ctx_narrow_access_ok(off, size, sizeof(__u16));
>> 
>> Either 'unused' needs to be after dst_port or
>> bpf_sock_is_valid_access() needs to allow offset at 'unused'
>> and at 'dst_port'.
>> And allow u32 access though the size is actually u16.
>> Then the existing bpf progs (without recompiling) should work?
> Yes, I think that should work with the existing bpf progs.
> I suspect putting 'dst_port' first and then followed by 'unused'
> may be easier.  That will also serve as a natural doc for the
> current behavior (the value is in the lower 16 bits).

You're right. I can't count. Now fixed in [1].

>
> It can be extended to bpf_sk_lookup? bpf_sk_lookup can read at any
> offset of these 4 bytes, so may need to read 0 during
> convert_ctx_accesses?

Let's see what the feedback to [1] will be.

[1] https://lore.kernel.org/bpf/20220127172448.155686-1-jakub@cloudflare.com/T/#t
