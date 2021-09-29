Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6139A41C4AC
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 14:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343796AbhI2M1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 08:27:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54590 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343717AbhI2M0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 08:26:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632918314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uI/0WlYY8vMsj143/o4E79xg22XyarAwimk7GbeUUQs=;
        b=I05NR/Ey15CHXLWrE55jMtRcgpe2UFZCBnUWJvBlfmOkV5VG/RBfIeLYpsupGk4hc5eazW
        upggnQw3uvbgegpdA2+XynVKxoum/riSE1xQKkic83XYyz7f/BroRyo2tpWs1sk5kPZ/Eg
        SI2QYaRIShjfmIkgtMU/fBGz8RXyDwc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-0DvRRSDyN4O8zIke4EKYHw-1; Wed, 29 Sep 2021 08:25:13 -0400
X-MC-Unique: 0DvRRSDyN4O8zIke4EKYHw-1
Received: by mail-ed1-f71.google.com with SMTP id s12-20020a05640217cc00b003cde58450f1so2233791edy.9
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 05:25:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=uI/0WlYY8vMsj143/o4E79xg22XyarAwimk7GbeUUQs=;
        b=EhYJyEX+HGWZxcVLzDty711phDwOR0rm38ofmk09jC5DBPB/nDWMoZ1Y/YsnSlBmGl
         MRo+gDecXWSTcYBzEe9wAzZov1zMKXdUiEudCwgguxq1igNkNXGOpPAtDNmIqvLvKt78
         cHcpjbSwt02jDt2SCjBq7bw1jjqvnP6UVcwjbZ5znA7jbNvhTMfpAzToA0TYZANtiFhq
         7pbU7btII/1FEGgmIbVAAx5MuQHIybDbtZenrSns2j4jSTZG/AMoFF/ZKnBKxSVnIAdY
         mUEi8ApwD9QWMIrN94ziakaC2EaIOpmzphF4i+bd/aRcYgx8Z1cLCZL6ZtcF53cfdhtL
         OOPQ==
X-Gm-Message-State: AOAM531Zmiz1pW45OF1yW8LAPCNibOgiScosJQfGrjL4v3GzKeVpnkgH
        +0fCSPTiSf/Ekj+7oavAkoaD7btay5O/7LJw+3A6rni2YlNe4N//8e0y+hWi1j7VGOkI6+iUYLP
        X3DIYHBnj7RUp1Asz
X-Received: by 2002:a17:906:c20d:: with SMTP id d13mr13420138ejz.259.1632918311737;
        Wed, 29 Sep 2021 05:25:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw80ZOlpqn0F1UPIS55c47A5S38y4EDnGJD4pmAocG3NhaGW50rfnySxLwboHMIZfAY/U/YTQ==
X-Received: by 2002:a17:906:c20d:: with SMTP id d13mr13420095ejz.259.1632918311455;
        Wed, 29 Sep 2021 05:25:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id k17sm1334589ejk.68.2021.09.29.05.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 05:25:10 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 450B718034F; Wed, 29 Sep 2021 14:25:09 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v14 bpf-next 00/18] mvneta: introduce XDP multi-buffer
 support
In-Reply-To: <CACAyw98tVmuRbMr5RpPY_0GmU_bQAH+d9=UoEx3u5g+nGSwfYQ@mail.gmail.com>
References: <cover.1631289870.git.lorenzo@kernel.org>
 <20210916095539.4696ae27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YUSrWiWh57Ys7UdB@lore-desk>
 <20210917113310.4be9b586@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAADnVQL15NAqbswXedF0r2om8SOiMQE80OSjbyCA56s-B4y8zA@mail.gmail.com>
 <20210917120053.1ec617c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAADnVQKbrkOxfNoixUx-RLJEWULJLyhqjZ=M_X2cFG_APwNyCg@mail.gmail.com>
 <614511bc3408b_8d5120862@john-XPS-13-9370.notmuch>
 <8735q25ccg.fsf@toke.dk>
 <20210920110216.4c54c9a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87lf3r3qrn.fsf@toke.dk>
 <20210920142542.7b451b78@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87ilyu50kl.fsf@toke.dk>
 <CACAyw98tVmuRbMr5RpPY_0GmU_bQAH+d9=UoEx3u5g+nGSwfYQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 29 Sep 2021 14:25:09 +0200
Message-ID: <87sfxnin6i.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer <lmb@cloudflare.com> writes:

> On Mon, 20 Sept 2021 at 23:46, Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>> > The draft API was:
>> >
>> > void *xdp_mb_pointer_flush(struct xdp_buff *xdp_md, u32 flags,
>> >                            u32 offset, u32 len, void *stack_buf)
>> >
>> > Which does not take the ptr returned by header_pointer(), but that's
>> > easy to add (well, easy other than the fact it'd be the 6th arg).
>>
>> I guess we could play some trickery with stuffing offset/len/flags into
>> one or two u64s to save an argument or two?
>
> Adding another pointer arg seems really hard to explain as an API.
> What happens if I pass the "wrong" ptr? What happens if I pass NULL?
>
> How about this: instead of taking stack_ptr, take the return value
> from header_pointer as an argument.

Hmm, that's a good point; I do think that passing the return value from
header pointer is more natural as well (you're flushing pointer you just
wrote to, after all).

> Then use the already existing (right ;P) inlining to do the following:
>
>    if (md->ptr + args->off !=3D ret_ptr)
>      __pointer_flush(...)

The inlining is orthogonal, though, right? The helper can do this check
whether or not it's a proper CALL or not (although obviously for
performance reasons we do want it to inline, at least eventually). In
particular, I believe we can make progress on this patch series without
working out the inlining :)

> This means that __pointer_flush has to deal with aliased memory
> though, so it would always have to memmove. Probably OK for the "slow"
> path?

Erm, not sure what you mean here? Yeah, flushing is going to take longer
if you ended up using the stack pointer instead of writing directly to
the packet. That's kinda intrinsic? Or am I misunderstanding you?

-Toke

