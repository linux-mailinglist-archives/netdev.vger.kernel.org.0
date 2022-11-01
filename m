Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34ABD614B2C
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 13:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiKAMyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 08:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiKAMyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 08:54:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21FF1B799
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 05:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667307188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zAuqpjNSQDmHK4eVVdNvYAUpPeJmn3ZvCnWYn2SThKI=;
        b=YK68wmMJYjB8Ej317xNdqQvnn4PkwjZT/AnSMQvW5CDzkaNv3qhS3HAFsyJtPYT7MOvE+p
        UJvB7t1Fu7Y9C37Th4qGMfhml7XcGPH6eSHYuMqDcM+uvkoP23u81ZcfjzZrc9g1WuV4UU
        v6OLn6LMi1DMAaBB0wKpTwWpGuGmlaQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-583-gOdaU-eINQ2BxBLIjbfDxA-1; Tue, 01 Nov 2022 08:53:01 -0400
X-MC-Unique: gOdaU-eINQ2BxBLIjbfDxA-1
Received: by mail-ej1-f70.google.com with SMTP id sb13-20020a1709076d8d00b0078d8e1f6f7aso7756321ejc.8
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 05:53:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zAuqpjNSQDmHK4eVVdNvYAUpPeJmn3ZvCnWYn2SThKI=;
        b=qol/LTChEqr4R3Yfh1mQ4MOYViHl0v31yrTy4rJ8uKFf0HJTLWg6jqQJ16NmBsrR/T
         9taHgiz3MO/ZcOgqUl/BVuMwVT2Cx8BGyEFzsfOYlaX3lP98S2eWcK6wh1E9YWC0SPNh
         sT1EnRnWlEqT8f2I9dz2QVDHqzesvfVMEcVgvRr06xflVkpphHxBOEizX29EdXpxXIhP
         D7odvoxUbSTocGPHzqb/ExVN++ZwlIQSGih29A9x6sZiDTaXqGg9rveNxqa3onHCCKfj
         Z9XX109R1tPaSkfVds3f9kMsT0/Cm09TEd2ZcSWdMbrzdd5VwxR8uZxzP3zSBSLQcROJ
         fItA==
X-Gm-Message-State: ACrzQf2n6v8LQmjM2ZDQc6yhSk8ze4rxD8NpRkpMq+rFTwbBtINBaFKj
        2qMd7DakKytjHnHL9Fk/0llOf5S6GWA8UEC67MJEZfhKJgVr7Uwia8SOsIWS1OseBP3ABpCV3+F
        yrdxkg4Y3nTt05RbL
X-Received: by 2002:aa7:da9a:0:b0:461:eea0:514c with SMTP id q26-20020aa7da9a000000b00461eea0514cmr117465eds.296.1667307178202;
        Tue, 01 Nov 2022 05:52:58 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4kxppzdaXroY6AxpsBc+e2cRbM2r7liAB8w9BfrQkNb5NS0h4fF4vLsR1YZY54iS1hSxYWnA==
X-Received: by 2002:aa7:da9a:0:b0:461:eea0:514c with SMTP id q26-20020aa7da9a000000b00461eea0514cmr117458eds.296.1667307176361;
        Tue, 01 Nov 2022 05:52:56 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id l10-20020a1709060cca00b007a1d4944d45sm4208809ejh.142.2022.11.01.05.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 05:52:55 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 53F3C723703; Tue,  1 Nov 2022 13:52:55 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <martin.lau@linux.dev>
Cc:     "Bezdeka, Florian" <florian.bezdeka@siemens.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "alexandr.lobakin@intel.com" <alexandr.lobakin@intel.com>,
        "anatoly.burakov@intel.com" <anatoly.burakov@intel.com>,
        "song@kernel.org" <song@kernel.org>,
        "Deric, Nemanja" <nemanja.deric@siemens.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "Kiszka, Jan" <jan.kiszka@siemens.com>,
        "magnus.karlsson@gmail.com" <magnus.karlsson@gmail.com>,
        "willemb@google.com" <willemb@google.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>, "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "mtahhan@redhat.com" <mtahhan@redhat.com>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "haoluo@google.com" <haoluo@google.com>
Subject: Re: [xdp-hints] Re: [RFC bpf-next 0/5] xdp: hints via kfuncs
In-Reply-To: <CAKH8qBsGB1G60cu91Au816gsB2zF8T0P-yDwxbTEOxX0TN3WgA@mail.gmail.com>
References: <20221027200019.4106375-1-sdf@google.com>
 <635bfc1a7c351_256e2082f@john.notmuch>
 <20221028110457.0ba53d8b@kernel.org>
 <CAKH8qBshi5dkhqySXA-Rg66sfX0-eTtVYz1ymHfBxSE=Mt2duA@mail.gmail.com>
 <635c62c12652d_b1ba208d0@john.notmuch>
 <20221028181431.05173968@kernel.org>
 <5aeda7f6bb26b20cb74ef21ae9c28ac91d57fae6.camel@siemens.com>
 <875yg057x1.fsf@toke.dk>
 <CAKH8qBvQbgE=oSZoH4xiLJmqMSXApH-ufd-qEKGKD8=POfhrWQ@mail.gmail.com>
 <77b115a0-bbba-48eb-89bd-3078b5fb7eeb@linux.dev>
 <CAKH8qBsGB1G60cu91Au816gsB2zF8T0P-yDwxbTEOxX0TN3WgA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 01 Nov 2022 13:52:55 +0100
Message-ID: <87wn8e4z14.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> writes:

> On Mon, Oct 31, 2022 at 3:57 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>>
>> On 10/31/22 10:00 AM, Stanislav Fomichev wrote:
>> >> 2. AF_XDP programs won't be able to access the metadata without using a
>> >> custom XDP program that calls the kfuncs and puts the data into the
>> >> metadata area. We could solve this with some code in libxdp, though; if
>> >> this code can be made generic enough (so it just dumps the available
>> >> metadata functions from the running kernel at load time), it may be
>> >> possible to make it generic enough that it will be forward-compatible
>> >> with new versions of the kernel that add new fields, which should
>> >> alleviate Florian's concern about keeping things in sync.
>> >
>> > Good point. I had to convert to a custom program to use the kfuncs :-(
>> > But your suggestion sounds good; maybe libxdp can accept some extra
>> > info about at which offset the user would like to place the metadata
>> > and the library can generate the required bytecode?
>> >
>> >> 3. It will make it harder to consume the metadata when building SKBs. I
>> >> think the CPUMAP and veth use cases are also quite important, and that
>> >> we want metadata to be available for building SKBs in this path. Maybe
>> >> this can be resolved by having a convenient kfunc for this that can be
>> >> used for programs doing such redirects. E.g., you could just call
>> >> xdp_copy_metadata_for_skb() before doing the bpf_redirect, and that
>> >> would recursively expand into all the kfunc calls needed to extract the
>> >> metadata supported by the SKB path?
>> >
>> > So this xdp_copy_metadata_for_skb will create a metadata layout that
>>
>> Can the xdp_copy_metadata_for_skb be written as a bpf prog itself?
>> Not sure where is the best point to specify this prog though.  Somehow during
>> bpf_xdp_redirect_map?
>> or this prog belongs to the target cpumap and the xdp prog redirecting to this
>> cpumap has to write the meta layout in a way that the cpumap is expecting?
>
> We're probably interested in triggering it from the places where xdp
> frames can eventually be converted into skbs?
> So for plain 'return XDP_PASS' and things like bpf_redirect/etc? (IOW,
> anything that's not XDP_DROP / AF_XDP redirect).
> We can probably make it magically work, and can generate
> kernel-digestible metadata whenever data == data_meta, but the
> question - should we?
> (need to make sure we won't regress any existing cases that are not
> relying on the metadata)

So I was thinking about whether we could have the kernel do this
automatically, and concluded that this was probably not feasible in
general, which is why I suggested the explicit helper. My reasoning was
as follows:

For straight XDP_PASS in the driver we don't actually need to do
anything today, as the driver itself will build the SKB and read any
metadata it needs from the HW descriptor[0].

This leaves packets that are redirected (either to a veth or a cpumap so
we build SKBs from them later); here the problem is that we buffer the
packets (for performance reasons) so that the redirect doesn't actually
happen until after the driver exits the NAPI loop. At which point we
don't have access to the HW descriptors anymore, so we can't actually
read the metadata.

This means that if we want to execute the metadata gathering
automatically, we'd have to do it in xdp_do_redirect(). Which means that
we'll have to figure out, at that point, whether the XDP frame is likely
to be converted to an SKB. This will add at least one branch (and
probably more) that will be in-path for every redirected frame.

Hence, making it up to the XDP program itself to decide whether it will
need the metadata for SKB conversion seems like a better choice, as long
as we make it easy for the XDP program to do this. Instead of a helper,
this could also simply be a new flag to the bpf_redirect{,_map}()
helpers (either opt-in or opt-out depending on the overhead), which
would be even simpler?

I.e.,

return bpf_redirect_map(&cpumap, 0, BPF_F_PREPARE_SKB_METADATA);

-Toke


[0] As an aside, in the future drivers may want to take advantage of the
XDP-specific metadata reading also when building SKBs (so it doesn't
have to implement it in both BPF and C code). For this, we could expose
a new internal helper function that the drivers could call to simply
execute the XDP-to-skb metadata helpers the same way the stack/helper
does.

