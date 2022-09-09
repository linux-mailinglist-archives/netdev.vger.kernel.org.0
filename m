Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7B85B3812
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 14:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbiIIMow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 08:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiIIMov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 08:44:51 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA73F2B188;
        Fri,  9 Sep 2022 05:44:48 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d82so1545782pfd.10;
        Fri, 09 Sep 2022 05:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=VhZla9GFvX7C+5pJWeSUEDxGd4lVsApmfsr27FzTwyY=;
        b=EuLEo9EMaoB2IZaEKQSlXqdfMBKpBB3M+flHICO4O6pLeMy8EEIn7B9jCzqzglnYIu
         ppH17NbpqEsd49rVXV8PEK+NMm4VYN/g2FXv2j4k+me4ZOsH49HjsElQaWuWeA8/7TDY
         idVX5oahjgzUu4q9QjAVKr4K3di793PxJa6c5XIfSgULxjkxN2f3zlxgsA2peVlTaMDB
         LvfG+WUPU6e8KDjwel3mXCFRF6H5guC9ZsUZKc587EtNgk9lXt8yS4swdKafo951PaVX
         1XQKeGqR6BnZ8bW7ceKIZ67lVtQnmQkqD9GwHeOI6BV2OAvLTonsb3CitVU+bATDJ0IW
         ErtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=VhZla9GFvX7C+5pJWeSUEDxGd4lVsApmfsr27FzTwyY=;
        b=Ot5zJuAwLawWRjhusSOFdu8pDUCEFU0kxO2Lw9Z2F3Wicx+aYCXumCrvtlFm2JRUvO
         gH+LasyUHrmCdH1BQQb7AsGzg2JYf4yohlvHnfJ8+f7eOsY3SKy7qLDUqFFprj5Nm1rc
         WL/xMpWUnZtXawT06gdXgW1fNdQtVCVm4joAHEV1fqgAdGvtJwN4gX8pvrx4BLnemlnL
         Ks7LHDlpjmGb6eKcPFAgmDirElUvrpLOc7r5dTD73pTjEmCiBFtFZ9q1NsuBsCCy76kh
         ZL9xAGNM3rOifAxTPbJnhaFXnXokfra2byraeco/cky/MlPf6u/4o8ITQb9lPjzjrLeX
         XcFw==
X-Gm-Message-State: ACgBeo0LJ6xGBqXYGOOgrBxHe2rmlwZ7gQYnVM5LPNYcLjsLcQfbqvvB
        gztEs4sMUk0KAvwaGhCxIGbxtKlxt8pPxSsXuz0=
X-Google-Smtp-Source: AA6agR4czFXLfB5kg0j2ww0+x9ZnPVCyIqwzSXb55TDv+81vTM5U8TxLluZCf0VWG0xet2csgMMb15eDppj8cA+KqEw=
X-Received: by 2002:a05:6a00:1995:b0:52d:5c39:3f61 with SMTP id
 d21-20020a056a00199500b0052d5c393f61mr14026007pfl.83.1662727488296; Fri, 09
 Sep 2022 05:44:48 -0700 (PDT)
MIME-Version: 1.0
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <166256558657.1434226.7390735974413846384.stgit@firesoul> <CAJ8uoz3UcC2tnMtG8W6a3HpCKgaYSzSCqowLFQVwCcsr+NKBOQ@mail.gmail.com>
 <b5f0d10d-2d4e-34d6-1e45-c206cb6f5d26@redhat.com> <9aab9ef1-446d-57ab-5789-afffe27801f4@redhat.com>
 <CAJ8uoz0CD18RUYU4SMsubB8fhv3uOwp6wi_uKsZSu_aOV5piaA@mail.gmail.com>
 <e1ab2141-03cc-f97c-3788-59923a029203@redhat.com> <593cc1df-8b65-ae9e-37eb-091b19c4d00e@redhat.com>
 <CAJ8uoz1omnp888MoZT4AgiPVWo=Ef5nkQApzz7fqnqdcGgR6NA@mail.gmail.com> <51f40ca1-ccf2-bcc3-d20d-931ad0d22526@redhat.com>
In-Reply-To: <51f40ca1-ccf2-bcc3-d20d-931ad0d22526@redhat.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 9 Sep 2022 14:44:37 +0200
Message-ID: <CAJ8uoz01z8=RBPHo1zy-ZPDDX_fmuMFOraU4o0R5e0QLrWDsyQ@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH RFCv2 bpf-next 17/18] xsk: AF_XDP
 xdp-hints support in desc options
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     brouer@redhat.com, Maryam Tahhan <mtahhan@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org, Alexander Lobakin <alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 9, 2022 at 2:35 PM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
>
> On 09/09/2022 12.14, Magnus Karlsson wrote:
> > On Fri, Sep 9, 2022 at 11:42 AM Jesper Dangaard Brouer
> > <jbrouer@redhat.com> wrote:
> >>
> >>
> >> On 09/09/2022 10.12, Maryam Tahhan wrote:
> >>> <snip>
> >>>>>>>
> >>>>>>> * Instead encode this information into each metadata entry in the
> >>>>>>> metadata area, in some way so that a flags field is not needed (-1
> >>>>>>> signifies not valid, or whatever happens to make sense). This has the
> >>>>>>> drawback that the user might have to look at a large number of entries
> >>>>>>> just to find out there is nothing valid to read. To alleviate this, it
> >>>>>>> could be combined with the next suggestion.
> >>>>>>>
> >>>>>>> * Dedicate one bit in the options field to indicate that there is at
> >>>>>>> least one valid metadata entry in the metadata area. This could be
> >>>>>>> combined with the two approaches above. However, depending on what
> >>>>>>> metadata you have enabled, this bit might be pointless. If some
> >>>>>>> metadata is always valid, then it serves no purpose. But it might if
> >>>>>>> all enabled metadata is rarely valid, e.g., if you get an Rx timestamp
> >>>>>>> on one packet out of one thousand.
> >>>>>>>
> >>>>>
> >>>>> I like this option better! Except that I have hoped to get 2 bits ;-)
> >>>>
> >>>> I will give you two if you need it Jesper, no problem :-).
> >>>>
> >>>
> >>> Ok I will look at implementing and testing this and post an update.
> >>
> >> Perfect if you Maryam have cycles to work on this.
> >>
> >> Let me explain what I wanted the 2nd bit for.  I simply wanted to also
> >> transfer the XDP_FLAGS_HINTS_COMPAT_COMMON flag.  One could argue that
> >> is it redundant information as userspace AF_XDP will have to BTF decode
> >> all the know XDP-hints. Thus, it could know if a BTF type ID is
> >> compatible with the common struct.   This problem is performance as my
> >> userspace AF_XDP code will have to do more code (switch/jump-table or
> >> table lookup) to map IDs to common compat (to e.g. extract the RX-csum
> >> indication).  Getting this extra "common-compat" bit is actually a
> >> micro-optimization.  It is up to AF_XDP maintainers if they can spare
> >> this bit.
> >>
> >>
> >>> Thanks folks
> >>>
> >>>>> The performance advantage is that the AF_XDP descriptor bits will
> >>>>> already be cache-hot, and if it indicates no-metadata-hints the AF_XDP
> >>>>> application can avoid reading the metadata cache-line :-).
> >>>>
> >>>> Agreed. I prefer if we can keep it simple and fast like this.
> >>>>
> >>
> >> Great, lets proceed this way then.
> >>
> >>> <snip>
> >>>
> >>
> >> Thinking ahead: We will likely need 3 bits.
> >>
> >> The idea is that for TX-side, we set a bit indicating that AF_XDP have
> >> provided a valid XDP-hints layout (incl corresponding BTF ID). (I would
> >> overload and reuse "common-compat" bit if TX gets a common struct).
> >
> > I think we should reuse the "Rx metadata valid" flag for this since
> > this will not be used in the Tx case by definition. In the Tx case,
> > this bit would instead mean that the user has provided a valid
> > XDP-hints layout. It has a nice symmetry, on Rx it is set by the
> > kernel when it has put something relevant in the metadata area. On Tx,
> > it is set by user-space if it has put something relevant in the
> > metadata area.
>
> I generally like reusing the bit, *BUT* there is the problem of
> (existing) applications ignoring the desc-options bit and forwarding
> packets.  This would cause the "Rx metadata valid" flag to be seen as
> userspace having set the "TX-hints-bit" and kernel would use what is
> provided in metadata area (leftovers from RX-hints).  IMHO that will be
> hard to debug for end-users and likely break existing applications.

Good point. I buy this. We need separate Rx and Tx bits.

> > We can also reuse this bit when we get a notification
> > in the completion queue to indicate if the kernel has produced some
> > metadata on tx completions. This could be a Tx timestamp for example.
> >
>
> Big YES, reuse "Rx metadata valid" bit when we get a TX notification in
> completion queue.  This will be okay because it cannot be forgotten and
> misinterpreted as the kernel will have responsibility to update this bit.
>
> > So hopefully we could live with only two bits :-).
> >
>
> I still think we need three bits ;-)
> That should be enough to cover the 6 states:
>   - RX hints
>   - RX hints and compat
>   - TX hints
>   - TX hints and compat
>   - TX completion
>   - TX completion and compat
>
>
> >> But lets land RX-side first, but make sure we can easily extend for the
> >> TX-side.
>
