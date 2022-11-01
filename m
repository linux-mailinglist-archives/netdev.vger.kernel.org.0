Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132966152E3
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 21:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiKAUMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 16:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiKAUMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 16:12:51 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188B21E3D4
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 13:12:48 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id z9so8412252ilu.10
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 13:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bvaFCWDzelTHWj7mwYi/8ESb/N/Ne8dDqFD20Kon46M=;
        b=njZdKw6U6Jyuy8tEgQ/XCPas9CWcUd2zr0ffkf5rMJHjBxUDrVG7YiT7EvAnu03JIP
         b6xj3ihPmNIex7wehVxoimfQSWACGe6CHjRdK562gf2Sg/2A+/W10R1nU2YKEXCkr6Xu
         islhyjv4mQZ3sAi1iPN2286b8ZcoPO6EySJYQ6qRSGcNbNZWXmMPIARsLOnef5TEdWsx
         iBPmOewwHVoDZO3bdFReKPXhLl+iCZNrrZTBQYphftl26wEuOwV2T6TiPFRFuInkxHR4
         4Jx6dJppJau+vnmUcUpQJt3ZLb9JbzaJrRwsuXe+ackY5X3vn/l3I7tq8599vKhJ17oW
         yw7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bvaFCWDzelTHWj7mwYi/8ESb/N/Ne8dDqFD20Kon46M=;
        b=MI/0l9sQc8Nt8HGyV8WwYqNRDTNQRxa3h3Qghb7XV1vPcBI6/Zr55Hi6a/vzF18A3u
         9frgKOq9Fsm2EKAVjn4r6ADBx9MyAgQrFrqJgILMVMyfd6RK9ewJht4z7Hbn8FjaF8ur
         4z1XX+4oU0WdCZPKYFtMogh6kQwukyi5m784I1VsFGjhoYFawmbH6z35nkqRdA1GfiFz
         DqkJj29FmqIwWNDq4cIwxecAJ+oEJHO4z9ijBJi9mXRr7THJS9QZ3s+ngm1xZZNybnAN
         gIyB5k9VGXwqHgFjXMmnrV/KBBrIJL49YEFPQwg2IaQcGc37yHcT29sD3CfVzRJTu1CE
         wo1A==
X-Gm-Message-State: ACrzQf2xGLvldifOA/KizITO3SbX80p8K8C+g0FRLOveAC3Hgm2f2QOx
        Fgb0KXFyJ1MaCkglTMPFzctKKsul8aOsGvON0iSrQw==
X-Google-Smtp-Source: AMsMyM6TLighgp/Y6c5poI69dk+z6lY/0D+KWEGtu2geoDhMMNV8imfiqFa6E/lxNtA6zQaBCzS19ncUaodxUiJ/eY0=
X-Received: by 2002:a05:6e02:1a41:b0:2fa:969d:fcd0 with SMTP id
 u1-20020a056e021a4100b002fa969dfcd0mr12825254ilv.6.1667333567310; Tue, 01 Nov
 2022 13:12:47 -0700 (PDT)
MIME-Version: 1.0
References: <20221027200019.4106375-1-sdf@google.com> <635bfc1a7c351_256e2082f@john.notmuch>
 <20221028110457.0ba53d8b@kernel.org> <CAKH8qBshi5dkhqySXA-Rg66sfX0-eTtVYz1ymHfBxSE=Mt2duA@mail.gmail.com>
 <635c62c12652d_b1ba208d0@john.notmuch> <20221028181431.05173968@kernel.org>
 <5aeda7f6bb26b20cb74ef21ae9c28ac91d57fae6.camel@siemens.com>
 <875yg057x1.fsf@toke.dk> <CAKH8qBvQbgE=oSZoH4xiLJmqMSXApH-ufd-qEKGKD8=POfhrWQ@mail.gmail.com>
 <77b115a0-bbba-48eb-89bd-3078b5fb7eeb@linux.dev> <CAKH8qBsGB1G60cu91Au816gsB2zF8T0P-yDwxbTEOxX0TN3WgA@mail.gmail.com>
 <0c00ba33-f37b-dfe6-7980-45920ffa273b@linux.dev>
In-Reply-To: <0c00ba33-f37b-dfe6-7980-45920ffa273b@linux.dev>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 1 Nov 2022 13:12:36 -0700
Message-ID: <CAKH8qBvJQNmp2qqTTcsMqujqO+HvKRGELCvqxg=3d6o_PTrZ=A@mail.gmail.com>
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

On Tue, Nov 1, 2022 at 10:05 AM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 10/31/22 6:59 PM, Stanislav Fomichev wrote:
> > On Mon, Oct 31, 2022 at 3:57 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
> >>
> >> On 10/31/22 10:00 AM, Stanislav Fomichev wrote:
> >>>> 2. AF_XDP programs won't be able to access the metadata without using a
> >>>> custom XDP program that calls the kfuncs and puts the data into the
> >>>> metadata area. We could solve this with some code in libxdp, though; if
> >>>> this code can be made generic enough (so it just dumps the available
> >>>> metadata functions from the running kernel at load time), it may be
> >>>> possible to make it generic enough that it will be forward-compatible
> >>>> with new versions of the kernel that add new fields, which should
> >>>> alleviate Florian's concern about keeping things in sync.
> >>>
> >>> Good point. I had to convert to a custom program to use the kfuncs :-(
> >>> But your suggestion sounds good; maybe libxdp can accept some extra
> >>> info about at which offset the user would like to place the metadata
> >>> and the library can generate the required bytecode?
> >>>
> >>>> 3. It will make it harder to consume the metadata when building SKBs. I
> >>>> think the CPUMAP and veth use cases are also quite important, and that
> >>>> we want metadata to be available for building SKBs in this path. Maybe
> >>>> this can be resolved by having a convenient kfunc for this that can be
> >>>> used for programs doing such redirects. E.g., you could just call
> >>>> xdp_copy_metadata_for_skb() before doing the bpf_redirect, and that
> >>>> would recursively expand into all the kfunc calls needed to extract the
> >>>> metadata supported by the SKB path?
> >>>
> >>> So this xdp_copy_metadata_for_skb will create a metadata layout that
> >>
> >> Can the xdp_copy_metadata_for_skb be written as a bpf prog itself?
> >> Not sure where is the best point to specify this prog though.  Somehow during
> >> bpf_xdp_redirect_map?
> >> or this prog belongs to the target cpumap and the xdp prog redirecting to this
> >> cpumap has to write the meta layout in a way that the cpumap is expecting?
> >
> > We're probably interested in triggering it from the places where xdp
> > frames can eventually be converted into skbs?
> > So for plain 'return XDP_PASS' and things like bpf_redirect/etc? (IOW,
> > anything that's not XDP_DROP / AF_XDP redirect).
> > We can probably make it magically work, and can generate
> > kernel-digestible metadata whenever data == data_meta, but the
> > question - should we?
> > (need to make sure we won't regress any existing cases that are not
> > relying on the metadata)
>
> Instead of having some kernel-digestible meta data, how about calling another
> bpf prog to initialize the skb fields from the meta area after
> __xdp_build_skb_from_frame() in the cpumap, so
> run_xdp_set_skb_fileds_from_metadata() may be a better name.
>
> The xdp_prog@rx sets the meta data and then redirect.  If the xdp_prog@rx can
> also specify a xdp prog to initialize the skb fields from the meta area, then
> there is no need to have a kfunc to enforce a kernel-digestible layout.  Not
> sure what is a good way to specify this xdp_prog though...

Not sure also about whether doing it at this point is too late or not?
Need to take a closer look at all __xdp_build_skb_from_frame call sites...
Also see Toke/Dave discussing potentially having helpers to override
some of that metadata. In this case, having more control on the user
side makes sense..

I'll probably start with an explicit helper for now, just to
see if the overall approach is workable. Maybe we can have a follow up
discussion about doing it more transparently.

> >>> the kernel will be able to understand when converting back to skb?
> >>> IIUC, the xdp program will look something like the following:
> >>>
> >>> if (xdp packet is to be consumed by af_xdp) {
> >>>     // do a bunch of bpf_xdp_metadata_<metadata> calls and assemble your
> >>> own metadata layout
> >>>     return bpf_redirect_map(xsk, ...);
> >>> } else {
> >>>     // if the packet is to be consumed by the kernel
> >>>     xdp_copy_metadata_for_skb(ctx);
> >>>     return bpf_redirect(...);
> >>> }
> >>>
> >>> Sounds like a great suggestion! xdp_copy_metadata_for_skb can maybe
> >>> put some magic number in the first byte(s) of the metadata so the
> >>> kernel can check whether xdp_copy_metadata_for_skb has been called
> >>> previously (or maybe xdp_frame can carry this extra signal, idk).
>
