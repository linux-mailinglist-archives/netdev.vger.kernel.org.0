Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B29D1882D6
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436493AbfHISp5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 9 Aug 2019 14:45:57 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35308 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbfHISp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:45:57 -0400
Received: by mail-ed1-f65.google.com with SMTP id w20so95931290edd.2
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 11:45:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=/z+ZqOKzdJHhy2EFeVYfuYX66TbJD6jqRIB4c/yziqU=;
        b=QpXZ/b/iRlFjvokmJtWjl5h41DX+KWe98tEkGo6kaQZ7Q883xrit02tlX75XE1iiNM
         xhgfPczwVJ3CgSMmkn0qKnb+A5Im2AWiO/GQkapUXAqTN1VgKHH40na6CUv9+Rof04/Q
         sfFxeOFwTSNagIbkEFKJOrbjyeWOdoVVkWlVgJEfwZC53mqbXTplR/VcCmn1ErSKyI7i
         ZOkGksUWTp1ArrByZOY7MrciVtF62MmSbyMDZ0iT1qCOwoSX3QRa+ayoVWM8CPdI1FZz
         gKaLRdveg32fgGaJay2QdotgPypkEmUWJZ2HRiS+AfAOfczQpoTh9glAPUSYQ6COizax
         Eevg==
X-Gm-Message-State: APjAAAW8KkmwpOvjFufBPYkOKlg2mw4Pj5UCfHeCbNjJPTpAixyS6msG
        pslitx2x/uqWZ65h47FuzV8/Zw==
X-Google-Smtp-Source: APXvYqxBJB1yQDcQYuKOExnJSclr9oZCFafLdwKbIb58ypGMtsfuuB1zIw9uQPiuV3D61KVtZ6E0/g==
X-Received: by 2002:a50:87d0:: with SMTP id 16mr23349559edz.133.1565376355479;
        Fri, 09 Aug 2019 11:45:55 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id o1sm355472eji.19.2019.08.09.11.45.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 11:45:54 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2E3DD180BF7; Fri,  9 Aug 2019 20:45:54 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Y Song <ys114321@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBl?= =?utf-8?B?bA==?= 
        <bjorn.topel@gmail.com>, Yonghong Song <yhs@fb.com>,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next v5 0/6] xdp: Add devmap_hash map type
In-Reply-To: <20190808220516.1adeca9a@carbon>
References: <156415721066.13581.737309854787645225.stgit@alrua-x1> <CAADnVQJpYeQ68V5BE2r3BhbraBh7G8dSd8zknFUJxtW4GwNkuA@mail.gmail.com> <87k1bnsbds.fsf@toke.dk> <CAH3MdRWk_bZVpBUZ8=xsMNw2hUwnQ3Yv-otu9M+7f1Cwr-t1UA@mail.gmail.com> <20190808220516.1adeca9a@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 09 Aug 2019 20:45:54 +0200
Message-ID: <87a7ciqisd.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Thu, 8 Aug 2019 12:57:05 -0700
> Y Song <ys114321@gmail.com> wrote:
>
>> On Thu, Aug 8, 2019 at 12:43 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>> >
>> > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>> >  
>> > > On Fri, Jul 26, 2019 at 9:06 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:  
>> > >>
>> > >> This series adds a new map type, devmap_hash, that works like the existing
>> > >> devmap type, but using a hash-based indexing scheme. This is useful for the use
>> > >> case where a devmap is indexed by ifindex (for instance for use with the routing
>> > >> table lookup helper). For this use case, the regular devmap needs to be sized
>> > >> after the maximum ifindex number, not the number of devices in it. A hash-based
>> > >> indexing scheme makes it possible to size the map after the number of devices it
>> > >> should contain instead.
>> > >>
>> > >> This was previously part of my patch series that also turned the regular
>> > >> bpf_redirect() helper into a map-based one; for this series I just pulled out
>> > >> the patches that introduced the new map type.
>> > >>
>> > >> Changelog:
>> > >>
>> > >> v5:
>> > >>
>> > >> - Dynamically set the number of hash buckets by rounding up max_entries to the
>> > >>   nearest power of two (mirroring the regular hashmap), as suggested by Jesper.  
>> > >
>> > > fyi I'm waiting for Jesper to review this new version.  
>> >
>> > Ping Jesper? :)  
>> 
>> Toke, the patch set has been merged to net-next.
>> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=d3406913561c322323ec2898cc58f55e79786be7
>> 
>
> Yes, and I did review this... :-)

Oops, my bad; seems I accidentally muted this thread and didn't see
Jesper's review and Alexei's message about merging it. Sorry about
that...

-Toke
