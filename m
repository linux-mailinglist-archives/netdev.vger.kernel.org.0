Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C823264D3A8
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 00:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiLNXrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 18:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiLNXrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 18:47:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD71187
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 15:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671061595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DCzldWN/5cZ2JoAWZJugna0y9Vh9nWLOhmVhul+oqOk=;
        b=jDsdCXIqXpoHy4V49kVrnDVsprEKWAxb6/J8qA3xajiugXc3G94YV7O6lnCAodC595q/bY
        9ypDjxQ8CZ6PYw5ARKWViZpBbtDcpltssaYj1myLHEEkePeUi2LFky8ohrTLOiLD8t0nCv
        6SC1a9ImS+tn016fa+UUP2/Elk0HGCI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-610-h8J2PUY6NSS-rI7q8Auopw-1; Wed, 14 Dec 2022 18:46:28 -0500
X-MC-Unique: h8J2PUY6NSS-rI7q8Auopw-1
Received: by mail-ed1-f70.google.com with SMTP id x20-20020a05640226d400b0046cbe2b85caso10477540edd.3
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 15:46:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DCzldWN/5cZ2JoAWZJugna0y9Vh9nWLOhmVhul+oqOk=;
        b=XGUXBfqTcxqcUCgoLQVNGZy6weXp25XoDCm/GMv0KVRtOGqdPmxipe8TdyLodwRoBm
         BSWIz1NSYLNjURCEifOsaqVA1V0fkQ757aOMimBcl2tV83eZ+9Rg1zX4UHREK/BGQklS
         OsJP7UrYNoHZAuGsAKHe0Oht5vYXO3YOHM7VRCJ38r8vfxZvLgqZ6Pnsk2C9MRz25xSG
         XMmJIrUDG4QzhG4GdwjxgyY7X6HFIWSCpdawQ27FvH/8CuM4mSTlnixLlT9H6WTKZzoL
         rqJqOXBhctbX+JiS1EqkZ2gBdpaMgVYP56rwdXtpTwnEUAh1pGuVdCNmzVpe+nrPN/C8
         5Vjg==
X-Gm-Message-State: ANoB5pkvziEgdIuimUT4gyKYWCedljLqji+IH4Rztwu4AaGQHgTPUL3Y
        7V8Ck9xLwBQdykTxXDM8EYmz+XzSuvGqDRn5J6uPC8c/fBr+aHt5HRUB7edfCz5Vs5wfJQJ8TEF
        UgQLMXBj3z+wu78Oq
X-Received: by 2002:aa7:db91:0:b0:461:9075:4161 with SMTP id u17-20020aa7db91000000b0046190754161mr21220476edt.15.1671061585937;
        Wed, 14 Dec 2022 15:46:25 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7pBlQ2i0qP1De1qzz2UYRP1C/T5yT57y4dH7rQWDDbGIxTpFhIM14u64IWVSzOvPMkZlsnFA==
X-Received: by 2002:aa7:db91:0:b0:461:9075:4161 with SMTP id u17-20020aa7db91000000b0046190754161mr21220454edt.15.1671061585065;
        Wed, 14 Dec 2022 15:46:25 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id dc20-20020a170906c7d400b007c0f90a9cc5sm6407157ejb.105.2022.12.14.15.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 15:46:23 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3DD2B82F671; Thu, 15 Dec 2022 00:46:23 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     David Vernet <void@manifault.com>, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v4 01/15] bpf: Document XDP RX
 metadata
In-Reply-To: <CAKH8qBuv0pZUT-w3LVKoss6XixdNP9cbZpxe9UWghdpbWDXtgA@mail.gmail.com>
References: <20221213023605.737383-1-sdf@google.com>
 <20221213023605.737383-2-sdf@google.com> <Y5iqTKnhtX2yaSAq@maniforge.lan>
 <CAKH8qBvjwMXvTg3ij=6wk2yu+=oWcRizmKf_YtW_yp5+W2F_=g@mail.gmail.com>
 <87fsdigtow.fsf@toke.dk>
 <CAKH8qBuv0pZUT-w3LVKoss6XixdNP9cbZpxe9UWghdpbWDXtgA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 15 Dec 2022 00:46:23 +0100
Message-ID: <87r0x1eegg.fsf@toke.dk>
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

> On Wed, Dec 14, 2022 at 2:34 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Stanislav Fomichev <sdf@google.com> writes:
>>
>> > On Tue, Dec 13, 2022 at 8:37 AM David Vernet <void@manifault.com> wrot=
e:
>> >>
>> >> On Mon, Dec 12, 2022 at 06:35:51PM -0800, Stanislav Fomichev wrote:
>> >> > Document all current use-cases and assumptions.
>> >> >
>> >> > Cc: John Fastabend <john.fastabend@gmail.com>
>> >> > Cc: David Ahern <dsahern@gmail.com>
>> >> > Cc: Martin KaFai Lau <martin.lau@linux.dev>
>> >> > Cc: Jakub Kicinski <kuba@kernel.org>
>> >> > Cc: Willem de Bruijn <willemb@google.com>
>> >> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
>> >> > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
>> >> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
>> >> > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
>> >> > Cc: Maryam Tahhan <mtahhan@redhat.com>
>> >> > Cc: xdp-hints@xdp-project.net
>> >> > Cc: netdev@vger.kernel.org
>> >> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
>> >> > ---
>> >> >  Documentation/bpf/xdp-rx-metadata.rst | 90 +++++++++++++++++++++++=
++++
>> >> >  1 file changed, 90 insertions(+)
>> >> >  create mode 100644 Documentation/bpf/xdp-rx-metadata.rst
>> >> >
>> >> > diff --git a/Documentation/bpf/xdp-rx-metadata.rst b/Documentation/=
bpf/xdp-rx-metadata.rst
>> >> > new file mode 100644
>> >> > index 000000000000..498eae718275
>> >> > --- /dev/null
>> >> > +++ b/Documentation/bpf/xdp-rx-metadata.rst
>> >>
>> >> I think you need to add this to Documentation/bpf/index.rst. Or even
>> >> better, maybe it's time to add an xdp/ subdirectory and put all docs
>> >> there? Don't want to block your patchset from bikeshedding on this
>> >> point, so for now it's fine to just put it in
>> >> Documentation/bpf/index.rst until we figure that out.
>> >
>> > Maybe let's put it under Documentation/networking/xdp-rx-metadata.rst
>> > and reference form Documentation/networking/index.rst? Since it's more
>> > relevant to networking than the core bpf?
>> >
>> >> > @@ -0,0 +1,90 @@
>> >> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> >> > +XDP RX Metadata
>> >> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> >> > +
>> >> > +XDP programs support creating and passing custom metadata via
>> >> > +``bpf_xdp_adjust_meta``. This metadata can be consumed by the foll=
owing
>> >> > +entities:
>> >>
>> >> Can you add a couple of sentences to this intro section that explains
>> >> what metadata is at a high level?
>> >
>> > I'm gonna copy-paste here what I'm adding, feel free to reply back if
>> > still unclear. (so we don't have to wait another week to discuss the
>> > changes)
>> >
>> > XDP programs support creating and passing custom metadata via
>> > ``bpf_xdp_adjust_meta``. The metadata can contain some extra informati=
on
>> > about the packet: timestamps, hash, vlan and tunneling information, et=
c.
>> > This metadata can be consumed by the following entities:
>>
>> This is not really accurate, though? The metadata area itself can
>> contain whatever the XDP program wants it to, and I think you're
>> conflating the "old" usage for arbitrary storage with the driver-kfunc
>> metadata support.
>>
>> I think we should clear separate the two: the metadata area is just a
>> place to store data (and is not consumed by the stack, except that
>> TC-BPF programs can access it), and the driver kfuncs are just a general
>> way to get data out of the drivers (and has nothing to do with the
>> metadata area, you can just get the data into stack variables).
>>
>> While it would be good to have a documentation of the general metadata
>> area stuff somewhere, I don't think it necessarily have to be part of
>> this series, so maybe just stick to documenting the kfuncs?
>
> Maybe I can reword to something like below?
>
> The metadata can be used to store some extra information about the
> packet timestamps, hash, vlan and tunneling information, etc.
>
> This way we are not actually defining what it is, but hinting about
> how it's commonly used?

Sent another reply to the original patch with some comments that are
hopefully a bit more constructive :)

-Toke

