Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3469562AE62
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 23:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbiKOWdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 17:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbiKOWcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 17:32:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A84BED
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 14:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668551484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pJmNXPp6LKbLV1/7iK18cP0hnwLnprb5IV7cNfNC70k=;
        b=H2mE83X3H50LK1AAnmZitpF7B1/J9OngzWbrk82lxgQ/aED4QtHszdKkG7lVMtfk935GyR
        a6RD90ERWmdzlAJ0AG3J617LGkDlTpkdeHxPsscWZwCv3Ae2wNqBAfr7uVr9xVTCQUGoFV
        7DlfgOd53LUdnVKiy9Tyq716evKA/zc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-313-q3BVANXSOnaHWHU214wuLg-1; Tue, 15 Nov 2022 17:31:23 -0500
X-MC-Unique: q3BVANXSOnaHWHU214wuLg-1
Received: by mail-ej1-f70.google.com with SMTP id hp16-20020a1709073e1000b007adf5a83df7so8255396ejc.1
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 14:31:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pJmNXPp6LKbLV1/7iK18cP0hnwLnprb5IV7cNfNC70k=;
        b=wl0GJUrzuuMs2/t0gghAz5wjPbEJhnj88iFE96CHvfF7TKRWMZIJUWQjfPwPhOtZSC
         mYV3MDgt0DdkaimiPLCPrBQhJj9h6PF4ke7PRL80dr/PqLvEDRrlI1J5l+JDTXrdoGu9
         W6s++IkGJQJHbYU4UbLAJgQ9CdpROmJYUojlK+d9mFWQ7IGPtCWzX6YU5x8j2YCOES+J
         2DERUZ7H4OrzPLcdrsYeUUXceT75cm8Th7mljhKSVd61zIyCqkVrZvXj4oi4EoHwiuqq
         1WBHgG809phIMAch/xBjIEU+8DaF/UsgInCTMbd1uGvYVtXY8Zb0x8PrhS1pTbNYgnyl
         MpwA==
X-Gm-Message-State: ANoB5plNuPu/J5BdztRuQW4GgywrI4QIH5fPxMRKEyBKKecYOq5vOvlt
        MPiQM99eLhQH88JiepsHtj4NNQ1qugmdTNf+LN+fuiGYj3EBieWhNlUVNYIDMoAPp/gAolgNx/q
        pG/3O971TSik/fJ4K
X-Received: by 2002:a17:906:8385:b0:7ad:8035:ae3d with SMTP id p5-20020a170906838500b007ad8035ae3dmr15568064ejx.46.1668551480921;
        Tue, 15 Nov 2022 14:31:20 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5cKn9LxWnWYRHp2/avkxz4II6DYsHD6dVz4O0FXSxYE6XoeL8CyodjK/ugPYHIHG0uyPAzUg==
X-Received: by 2002:a17:906:8385:b0:7ad:8035:ae3d with SMTP id p5-20020a170906838500b007ad8035ae3dmr15567998ejx.46.1668551479511;
        Tue, 15 Nov 2022 14:31:19 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id e20-20020a170906315400b0077b2b0563f4sm6123623eje.173.2022.11.15.14.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 14:31:18 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 96E997A6D4B; Tue, 15 Nov 2022 23:31:17 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] Re: [PATCH bpf-next 00/11] xdp: hints via kfuncs
In-Reply-To: <CAKH8qBszV6Ni_k8JYOxtAQ2j79qe5KVryAzDqtb1Ng8+TW=+7A@mail.gmail.com>
References: <20221115030210.3159213-1-sdf@google.com>
 <87mt8si56i.fsf@toke.dk>
 <CAKH8qBszV6Ni_k8JYOxtAQ2j79qe5KVryAzDqtb1Ng8+TW=+7A@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 15 Nov 2022 23:31:17 +0100
Message-ID: <875yffetoq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> writes:

> On Tue, Nov 15, 2022 at 7:54 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Stanislav Fomichev <sdf@google.com> writes:
>>
>> > - drop __randomize_layout
>> >
>> >   Not sure it's possible to sanely expose it via UAPI. Because every
>> >   .o potentially gets its own randomized layout, test_progs
>> >   refuses to link.
>>
>> So this won't work if the struct is in a kernel-supplied UAPI header
>> (which would include the __randomize_layout tag). But if it's *not* in a
>> UAPI header it should still be included in a stable form (i.e., without
>> the randomize tag) in vmlinux.h, right? Which would be the point:
>> consumers would be forced to read it from there and do CO-RE on it...
>
> So you're suggesting something like the following in the uapi header?
>
> #ifndef __KERNEL__
> #define __randomize_layout
> #endif
>
> ?

I actually just meant "don't put struct xdp_metadata in an UAPI header
file at all". However, I can see how that complicates having the
skb_metadata pointer in struct xdp_md, so if the above works, that's
fine with me as well :)

> Let me try to add some padding arguments to xdp_skb_metadata plus the
> above to see how it goes.

Cool!

-Toke

