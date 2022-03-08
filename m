Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048A14D1962
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244540AbiCHNl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:41:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234369AbiCHNl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:41:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 70996496B4
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 05:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646746830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PvIz0oH5ghTkMuuKn7KDKQOpc3bAif4RIMI3seszmXA=;
        b=VkOJ2SDxEmGse36tWiNQL6joTYlmfjzKkM30wvwAUX0PxP9oHg1xGBHpcTxB7Vs5+Hw+2y
        zBQtB8TvfpD9npYwa/cXvAx8i84Gac3qqWlJRI7B1hBG0V7Hm+SgJ+EdJSJGu4nW8W7jih
        XCUKfXym0PX2qtZpyeDnQbNTh/71I9w=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-lereWSOQN6OE1vtz5cylJA-1; Tue, 08 Mar 2022 08:40:29 -0500
X-MC-Unique: lereWSOQN6OE1vtz5cylJA-1
Received: by mail-ej1-f71.google.com with SMTP id go11-20020a1709070d8b00b006cf0d933739so8694884ejc.5
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 05:40:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=PvIz0oH5ghTkMuuKn7KDKQOpc3bAif4RIMI3seszmXA=;
        b=Wbu1soIDyvGq5+l5xiDq1ublEbEOEEGpiN6fS/Cte0mFsTjL+M+R9jqLs7SrYSoxFe
         QMiy0PnpCetiUa6raVSA7f6j++w7JTBFFU3LYNLUwIIeqHsKsaICQU5H8b8qHZRjIsPV
         4HWoWc00DxMzKzhVAYl/n6/2w/i/KYmAME3pzBnL9784316CmArWllD01ysBS/p/5Toj
         uff0sRh+JS2kO6HphBbTmPQKlXXYrWGLliZS86S88I8LV6HGrtlzbIxEA3yCrHb1cozL
         eB/+NCZ5XXe9tSImKoZitIbzyUaTWDcUf3F3renFgwmYuurm+itSIF9S+zUwBAMvoUOs
         VXow==
X-Gm-Message-State: AOAM530BqnlaZLgJn743qCDSpz2H1RoHY5SlWQQ4G5rK8vswfJsAqkfH
        UCoe3rc4X7tKfcJVT3myOLi5gvzZ3gz4fPL9NrcRf9gAxC5qDLrECsUPKN4DTQPIzLPC1Wln2Cf
        VsxAtIwxOqwWI/F0m
X-Received: by 2002:a17:906:edbd:b0:6b6:bd54:235c with SMTP id sa29-20020a170906edbd00b006b6bd54235cmr13506213ejb.363.1646746827216;
        Tue, 08 Mar 2022 05:40:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyFajPGF/cyRkXd8nck3k31hNg6jgvLdu++0Df3BKFHfh3BAem4gPBLzJZ0U3tgpCAQu80MUw==
X-Received: by 2002:a17:906:edbd:b0:6b6:bd54:235c with SMTP id sa29-20020a170906edbd00b006b6bd54235cmr13506046ejb.363.1646746824525;
        Tue, 08 Mar 2022 05:40:24 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id l20-20020a1709066b9400b006dabdbc8350sm4555508ejr.30.2022.03.08.05.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 05:40:23 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5882D1928AB; Tue,  8 Mar 2022 14:40:23 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Lorenz Bauer <linux@lmb.io>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 0/5] Introduce bpf_packet_pointer helper
In-Reply-To: <20220308070828.4tjiuvvyqwmhru6a@apollo.legion>
References: <20220306234311.452206-1-memxor@gmail.com>
 <CAEf4BzaPhtUGhR1vTSNGVLAudA7fUDWqZZFDfFvHXi2MOdrN5w@mail.gmail.com>
 <20220308070828.4tjiuvvyqwmhru6a@apollo.legion>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 08 Mar 2022 14:40:23 +0100
Message-ID: <87lexky33s.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:

> On Tue, Mar 08, 2022 at 11:18:52AM IST, Andrii Nakryiko wrote:
>> On Sun, Mar 6, 2022 at 3:43 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>> >
>> > Expose existing 'bpf_xdp_pointer' as a BPF helper named 'bpf_packet_pointer'
>> > returning a packet pointer with a fixed immutable range. This can be useful to
>> > enable DPA without having to use memcpy (currently the case in
>> > bpf_xdp_load_bytes and bpf_xdp_store_bytes).
>> >
>> > The intended usage to read and write data for multi-buff XDP is:
>> >
>> >         int err = 0;
>> >         char buf[N];
>> >
>> >         off &= 0xffff;
>> >         ptr = bpf_packet_pointer(ctx, off, sizeof(buf), &err);
>> >         if (unlikely(!ptr)) {
>> >                 if (err < 0)
>> >                         return XDP_ABORTED;
>> >                 err = bpf_xdp_load_bytes(ctx, off, buf, sizeof(buf));
>> >                 if (err < 0)
>> >                         return XDP_ABORTED;
>> >                 ptr = buf;
>> >         }
>> >         ...
>> >         // Do some stores and loads in [ptr, ptr + N) region
>> >         ...
>> >         if (unlikely(ptr == buf)) {
>> >                 err = bpf_xdp_store_bytes(ctx, off, buf, sizeof(buf));
>> >                 if (err < 0)
>> >                         return XDP_ABORTED;
>> >         }
>> >
>> > Note that bpf_packet_pointer returns a PTR_TO_PACKET, not PTR_TO_MEM, because
>> > these pointers need to be invalidated on clear_all_pkt_pointers invocation, and
>> > it is also more meaningful to the user to see return value as R0=pkt.
>> >
>> > This series is meant to collect feedback on the approach, next version can
>> > include a bpf_skb_pointer and exposing it as bpf_packet_pointer helper for TC
>> > hooks, and explore not resetting range to zero on r0 += rX, instead check access
>> > like check_mem_region_access (var_off + off < range), since there would be no
>> > data_end to compare against and obtain a new range.
>> >
>> > The common name and func_id is supposed to allow writing generic code using
>> > bpf_packet_pointer that works for both XDP and TC programs.
>> >
>> > Please see the individual patches for implementation details.
>> >
>>
>> Joanne is working on a "bpf_dynptr" framework that will support
>> exactly this feature, in addition to working with dynamically
>> allocated memory, working with memory of statically unknown size (but
>> safe and checked at runtime), etc. And all that within a generic
>> common feature implemented uniformly within the verifier. E.g., it
>> won't need any of the custom bits of logic added in patch #2 and #3.
>> So I'm thinking that instead of custom-implementing a partial case of
>> bpf_dynptr just for skb and xdp packets, let's maybe wait for dynptr
>> and do it only once there?
>>
>
> Interesting stuff, looking forward to it.
>
>> See also my ARG_CONSTANT comment. It seems like a pretty common thing
>> where input constant is used to characterize some pointer returned
>> from the helper (e.g., bpf_ringbuf_reserve() case), and we'll need
>> that for bpf_dynptr for exactly this "give me direct access of N
>> bytes, if possible" case. So improving/generalizing it now before
>> dynptr lands makes a lot of sense, outside of bpf_packet_pointer()
>> feature itself.
>
> No worries, we can continue the discussion in patch 1, I'll split out the arg
> changes into a separate patch, and wait for dynptr to be posted before reworking
> this.

This does raise the question of what we do in the meantime, though? Your
patch includes a change to bpf_xdp_{load,store}_bytes() which, if we're
making it, really has to go in before those hit a release and become
UAPI.

One option would be to still make the change to those other helpers;
they'd become a bit slower, but if we have a solution for that coming,
that may be OK for a single release? WDYT?

-Toke

