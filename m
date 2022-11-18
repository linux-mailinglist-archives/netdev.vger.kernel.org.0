Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD93062EA48
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240036AbiKRAaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbiKRAaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:30:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929F16E56F
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 16:29:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668731360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+itpjDcga9mH0LamyY/OkXi7TD9WUdNLP2cV3k9ii9k=;
        b=i0ONzmrUpE9/3Q43a/TClHQOF/8AkP1SbZL3inSKq+L91TQ2dkqYUfSkfrpIhQwoK+fd6X
        h2JhdjYXrqH5eDiVdGH2GPl+8hRCV/gEDG1NWtS+U9eyaEtIqN68HmE1WFO68AC7CoKm8x
        11aGwaQlk1H/o18a7uqLaYIRai1gXi4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-453-zpEkV6mQPRefzw0acPnzQw-1; Thu, 17 Nov 2022 19:29:19 -0500
X-MC-Unique: zpEkV6mQPRefzw0acPnzQw-1
Received: by mail-ej1-f72.google.com with SMTP id gt15-20020a1709072d8f00b007aaac7973fbso1983629ejc.23
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 16:29:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+itpjDcga9mH0LamyY/OkXi7TD9WUdNLP2cV3k9ii9k=;
        b=H22B3kGq8nLbJRaADd+m9D9gjtQ8B+olThFpJuVeGxX8RDTS0KT4WkTalrdp5i6g4y
         /u8jRC6f+bNccqN/5KsDULU7in6KkQYs8C4Uul9k4/4TBInLX04lgwmqiWNn5SJRWbCU
         yHkuuxykBxqEirYThee5Px884nnsm627fkpicmHRJ6AO86ZwMo04yXP9gwyPyzwMfXDT
         H9ZmTfTWkXh3JfeAf8hRi5etwYwEZBBfxWlSvJybmpPUD3+6Osm+VA+5XNGGg6bwhwjB
         FsFjPDNAMOCr7gpUOSIZt9fOUa2P58khwEAepJnkNBvphOhLJIKOW8lmr50llmHEwWpR
         Mfcw==
X-Gm-Message-State: ANoB5pk8xiuGuC4oajRQRONRFElxALw10gw8eCfq4qYD1EMtAkLHKxOI
        tX0g4xFHXsDw4TFiSVk2NgIoaysYYLlCSbAAx2bOiUkZacVMxlGjqTHVJEN7OwKFE32Zq5oAiqq
        of8YGFOEaSRxHWXG+
X-Received: by 2002:a05:6402:e0d:b0:466:4168:6ea7 with SMTP id h13-20020a0564020e0d00b0046641686ea7mr4041713edh.273.1668731357201;
        Thu, 17 Nov 2022 16:29:17 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7JF1PQRWwlPFnvVEFf83RM2J/Pz35scEZj/jJa/EJHPfBYm4P9LtURCOCKlui+6HqGeE+lxA==
X-Received: by 2002:a05:6402:e0d:b0:466:4168:6ea7 with SMTP id h13-20020a0564020e0d00b0046641686ea7mr4041673edh.273.1668731356233;
        Thu, 17 Nov 2022 16:29:16 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id en17-20020a056402529100b00467960d7b62sm1131575edb.35.2022.11.17.16.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 16:29:15 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0F97E7A702D; Fri, 18 Nov 2022 01:29:15 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next 05/11] veth: Support rx
 timestamp metadata for xdp
In-Reply-To: <CAADnVQJ=MbwUOTtmYb_VmTEBA8SdYXJryfGoYv2W2US3_Es=kA@mail.gmail.com>
References: <20221115030210.3159213-1-sdf@google.com>
 <20221115030210.3159213-6-sdf@google.com> <87h6z0i449.fsf@toke.dk>
 <CAKH8qBsEGD3L0XAVzVHcTW6k_RhEt74pfXrPLANuznSAJw7bEg@mail.gmail.com>
 <8735ajet05.fsf@toke.dk>
 <CAKH8qBsg4aoFuiajuXmRN3VPKYVJZ-Z5wGzBy9pH3pV5RKCDzQ@mail.gmail.com>
 <6374854883b22_5d64b208e3@john.notmuch>
 <34f89a95-a79e-751c-fdd2-93889420bf96@linux.dev> <878rkbjjnp.fsf@toke.dk>
 <6375340a6c284_66f16208aa@john.notmuch>
 <CAKH8qBs1rYXf0GGto9hPz-ELLZ9c692cFnKC9JLwAq5b7JRK-A@mail.gmail.com>
 <637576962dada_8cd03208b0@john.notmuch>
 <CAKH8qBtOATGBMPkgdE0jZ+76AWMsUWau360u562bB=cGYq+gdQ@mail.gmail.com>
 <CAADnVQKTXuBvP_2O6coswXL7MSvqVo1d+qXLabeOikcbcbAKPQ@mail.gmail.com>
 <CAKH8qBvTdnyRYT+ocNS_ZmOfoN+nBEJ5jcBcKcqZ1hx0a5WrSw@mail.gmail.com>
 <87wn7t4y0g.fsf@toke.dk>
 <CAADnVQJMvPjXCtKNH+WCryPmukgbWTrJyHqxrnO=2YraZEukPg@mail.gmail.com>
 <CAKH8qBsPinmCO0Ny1hva7kp4+C7XFdxZLPBYEHXQWDjJ5SSoYw@mail.gmail.com>
 <874juxywih.fsf@toke.dk>
 <CAADnVQJ=MbwUOTtmYb_VmTEBA8SdYXJryfGoYv2W2US3_Es=kA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 18 Nov 2022 01:29:15 +0100
Message-ID: <87sfihxfz8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Thu, Nov 17, 2022 at 3:46 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> >
>> > Ack. I can replace the unrolling with something that just resolves
>> > "generic" kfuncs to the per-driver implementation maybe? That would at
>> > least avoid netdev->ndo_kfunc_xxx indirect calls at runtime..
>>
>> As stated above, I think we should keep the unrolling. If we end up with
>> an actual CALL instruction for every piece of metadata that's going to
>> suck performance-wise; unrolling is how we keep this fast enough! :)
>
> Let's start with pure kfuncs without requiring drivers
> to provide corresponding bpf asm.
> If pure kfuncs will indeed turn out to be perf limiting
> then we'll decide on how to optimize them.

I'm ~90% sure we'll need that optimisation, but OK, we can start from a
baseline of having them be function calls...

-Toke

