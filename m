Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002046142FF
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 03:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiKAB76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 21:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKAB75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 21:59:57 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF9F10FED
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 18:59:56 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id p184so11256771iof.11
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 18:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tz2IvL4GW+A3brfA0AhzvjM7rEyd8FHY7/DmEU+TeH0=;
        b=T7WFWydh0LD3vChB+GqXb24P/X7ei44KzKvR+TqHO0dBFvi1ARAMzt/YdIkeyK5D0B
         6SpyKlYkdBkTL+ptY4jMEbHc8Z2nBKaFn2Kkny8zJ6VG3WVZeE8EIkTGPP+Y+/dAJiN9
         B5d9kgTK45V9q7DumxvznM0dMrK9k7b/YNdzR0kCpNl1NcSA1uIJ2PFskkhzdfcriAC7
         cTysy9ebws1XNyQluguVdoeKSDhL+Ll6HPXVJa0d0kIgMVNSGdioRezPNB+Dgzpez9DP
         1cgJIpCoSa9DrLsvVlRsKc96vLaNdva8AHLt2u18+xRBNSH38thtssS/YYKp98VGAdm9
         IdBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tz2IvL4GW+A3brfA0AhzvjM7rEyd8FHY7/DmEU+TeH0=;
        b=hQyJJVzi+9rgcVsQxVhBBs0NMCktpSkD8ofcJes80mWC+6sOMqaN+pcEQAkgbJsM6D
         Ir4zJHJDCDvITdv/WgYJmcPrWeWvT3oJZnfPpDo/eTzavgCB1S/rdcodA07KeWFbGbMV
         CBG1C+GcovU47Nhpl17OBMoD7jqdxfftP35FyGoCBugOQZItCWa0v4tjPOJ+6a3KX559
         k0OASEDzlzspNGKoqFZiLxysfuAyUXTyRXQNaHPGUEYnto8OQ8dImRBqGo6R19MFSiFx
         zso05M7QF5VTOv/SGe8dQZHFhpabW5OWZtuI5KbnHE+K5sKE6JtjV5mZ/3m0MzWdGLK+
         pgpg==
X-Gm-Message-State: ACrzQf3+f+EEabtQ/bSeQDcswQZtkkkdPEs6iTeG31YX6GsgXzS5Xc81
        T/aSeqvlJkqyXp2s0fB7ybwFpxIGeZzYiQHU4B+lDg==
X-Google-Smtp-Source: AMsMyM50fMCh4OLS6CKka+IBqOHJTMPLVNjRYGU0Vk4PSoQ7dXSO1vU905rE0hcc/k1KpEbbppvxgUw01IoBR3QG3LY=
X-Received: by 2002:a02:ad18:0:b0:372:e2a5:3a54 with SMTP id
 s24-20020a02ad18000000b00372e2a53a54mr40880jan.106.1667267995551; Mon, 31 Oct
 2022 18:59:55 -0700 (PDT)
MIME-Version: 1.0
References: <20221027200019.4106375-1-sdf@google.com> <635bfc1a7c351_256e2082f@john.notmuch>
 <20221028110457.0ba53d8b@kernel.org> <CAKH8qBshi5dkhqySXA-Rg66sfX0-eTtVYz1ymHfBxSE=Mt2duA@mail.gmail.com>
 <635c62c12652d_b1ba208d0@john.notmuch> <20221028181431.05173968@kernel.org>
 <5aeda7f6bb26b20cb74ef21ae9c28ac91d57fae6.camel@siemens.com>
 <875yg057x1.fsf@toke.dk> <CAKH8qBvQbgE=oSZoH4xiLJmqMSXApH-ufd-qEKGKD8=POfhrWQ@mail.gmail.com>
 <77b115a0-bbba-48eb-89bd-3078b5fb7eeb@linux.dev>
In-Reply-To: <77b115a0-bbba-48eb-89bd-3078b5fb7eeb@linux.dev>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 31 Oct 2022 18:59:44 -0700
Message-ID: <CAKH8qBsGB1G60cu91Au816gsB2zF8T0P-yDwxbTEOxX0TN3WgA@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [RFC bpf-next 0/5] xdp: hints via kfuncs
To:     Martin KaFai Lau <martin.lau@linux.dev>
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
        "haoluo@google.com" <haoluo@google.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 3:57 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 10/31/22 10:00 AM, Stanislav Fomichev wrote:
> >> 2. AF_XDP programs won't be able to access the metadata without using a
> >> custom XDP program that calls the kfuncs and puts the data into the
> >> metadata area. We could solve this with some code in libxdp, though; if
> >> this code can be made generic enough (so it just dumps the available
> >> metadata functions from the running kernel at load time), it may be
> >> possible to make it generic enough that it will be forward-compatible
> >> with new versions of the kernel that add new fields, which should
> >> alleviate Florian's concern about keeping things in sync.
> >
> > Good point. I had to convert to a custom program to use the kfuncs :-(
> > But your suggestion sounds good; maybe libxdp can accept some extra
> > info about at which offset the user would like to place the metadata
> > and the library can generate the required bytecode?
> >
> >> 3. It will make it harder to consume the metadata when building SKBs. I
> >> think the CPUMAP and veth use cases are also quite important, and that
> >> we want metadata to be available for building SKBs in this path. Maybe
> >> this can be resolved by having a convenient kfunc for this that can be
> >> used for programs doing such redirects. E.g., you could just call
> >> xdp_copy_metadata_for_skb() before doing the bpf_redirect, and that
> >> would recursively expand into all the kfunc calls needed to extract the
> >> metadata supported by the SKB path?
> >
> > So this xdp_copy_metadata_for_skb will create a metadata layout that
>
> Can the xdp_copy_metadata_for_skb be written as a bpf prog itself?
> Not sure where is the best point to specify this prog though.  Somehow during
> bpf_xdp_redirect_map?
> or this prog belongs to the target cpumap and the xdp prog redirecting to this
> cpumap has to write the meta layout in a way that the cpumap is expecting?

We're probably interested in triggering it from the places where xdp
frames can eventually be converted into skbs?
So for plain 'return XDP_PASS' and things like bpf_redirect/etc? (IOW,
anything that's not XDP_DROP / AF_XDP redirect).
We can probably make it magically work, and can generate
kernel-digestible metadata whenever data == data_meta, but the
question - should we?
(need to make sure we won't regress any existing cases that are not
relying on the metadata)






> > the kernel will be able to understand when converting back to skb?
> > IIUC, the xdp program will look something like the following:
> >
> > if (xdp packet is to be consumed by af_xdp) {
> >    // do a bunch of bpf_xdp_metadata_<metadata> calls and assemble your
> > own metadata layout
> >    return bpf_redirect_map(xsk, ...);
> > } else {
> >    // if the packet is to be consumed by the kernel
> >    xdp_copy_metadata_for_skb(ctx);
> >    return bpf_redirect(...);
> > }
> >
> > Sounds like a great suggestion! xdp_copy_metadata_for_skb can maybe
> > put some magic number in the first byte(s) of the metadata so the
> > kernel can check whether xdp_copy_metadata_for_skb has been called
> > previously (or maybe xdp_frame can carry this extra signal, idk).
