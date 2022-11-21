Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F4A632D1A
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiKUTlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiKUTlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:41:32 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEBC1CB966
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:41:31 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id l127so13589644oia.8
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=K3eSnfUNfCF8VEUfrvOhaQJeZjovtmcW6nKUCmGcdRQ=;
        b=njnm/vfPQCUbblxZgxMqyKcAEgZslS33ZpMvRNoNtGdlQV5cMA2cVPt3b19v5IGBOK
         JIsrZOBdz+sawKaeBq2QaL9CpoDq1XFsRAQ9wk+is2JdTzuVC46Qt/MqwdT0oxeZpech
         zQzhttp7JZksFQTSfAqfLeilvKCrU9xey7206MC3D4oa+Q6mnfnoJlhnq6rKLGvTm15a
         AE3tzj1hc/DZmHRZn7JoyFPz7XfI3tU51ZLiEJzhmZpJbitENe8rnjY/k8DQ+JO1Isok
         eeR0DZOxKuOEPRjOGgfKt+GofgyQ13TSua87+L6XRdJECsC9gT1mHDFmSVKV3oL7tpsD
         hj0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K3eSnfUNfCF8VEUfrvOhaQJeZjovtmcW6nKUCmGcdRQ=;
        b=EGxl140XqB7mESltOuSHB4YkV55SMUNUw8ncm2LjKqV6iWYXPdT02EXNII51PUe1FE
         DrVaVJJ4JPLm5S00y1EP9Qj5374XsZprgGYPgX4OCd7pemjDSTPT17HskTlZkAnv3MzD
         FMe+SoK8HJp4BrJvkwpuhify4RDH4yNuH2oDjPNgkcAPhViROx9hzCMM354C1PApYeMa
         zX7p5PHNXJI1ZH4vA8+an2Bpv2S1C4j+Vh6DM9ruBxMcXcMfeUeqlWeYzSJRRylhJcWP
         ZldkCOskoMAnbHqBqHiw8QFXrziVWmH9ZSQ9wA/V/THSLMAGUpL5TSkCMep4fqgmIAN9
         z5CQ==
X-Gm-Message-State: ANoB5pkRXhg7AZAtI1rWqQD7JhrF8ZTUIkZUITmawgwJTCbZxiGRHVVa
        MhSOE/nP8LIE2DeGE6A8U9P1YZYRYfS5BEzUIlbIdQ==
X-Google-Smtp-Source: AA0mqf6sxAMT58ZxIrRzLd5B4NdbURNGFcWqmkWrWvMtzXfjHo5xbsq6uJHtfjOrnwB69fg95TSJrFlKGHpKeeOgbQU=
X-Received: by 2002:a05:6808:f09:b0:354:8922:4a1a with SMTP id
 m9-20020a0568080f0900b0035489224a1amr14866oiw.181.1669059691038; Mon, 21 Nov
 2022 11:41:31 -0800 (PST)
MIME-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com> <20221115030210.3159213-7-sdf@google.com>
 <e26f75dd-f52f-a69b-6754-54e1fe044a42@redhat.com> <CAKH8qBv8UtHZrgSGzVn3ZJSfkdv1H3kXGbakp9rCFdOABL=3BQ@mail.gmail.com>
 <871qpzxh0n.fsf@toke.dk> <CAKH8qBtDZo8Mmp=o_fomz97cXNGY6NgOOW8YbJCXx_+_dVf7uw@mail.gmail.com>
 <20221121104744.10e1afc8@kernel.org>
In-Reply-To: <20221121104744.10e1afc8@kernel.org>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 21 Nov 2022 11:41:19 -0800
Message-ID: <CAKH8qBuJiLhFy5UqFaXinStfP+jRthkUDXS4KBPUpMiQLP751Q@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next 06/11] xdp: Carry over xdp
 metadata into skb context
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        bpf@vger.kernel.org, brouer@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 10:47 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 21 Nov 2022 09:53:02 -0800 Stanislav Fomichev wrote:
> > > Jakub was objecting to putting it in the UAPI header, but didn't we
> > > already agree that this wasn't necessary?
> > >
> > > I.e., if we just define
> > >
> > > struct xdp_skb_metadata *bpf_xdp_metadata_export_to_skb()
> > >
> > > as a kfunc, the xdp_skb_metadata struct won't appear in any UAPI headers
> > > and will only be accessible via BTF? And we can put the actual data
> > > wherever we choose, since that bit is nicely hidden behind the kfunc,
> > > while the returned pointer still allows programs to access it.
> > >
> > > We could even make that kfunc smart enough that it checks if the field
> > > is already populated and just return the pointer to the existing data
> > > instead of re-populating it int his case (with a flag to override,
> > > maybe?).
> >
> > Even if we only expose it via btf, I think the fact that we still
> > expose a somewhat fixed layout is the problem?
> > I'm not sure the fact that we're not technically putting in the uapi
> > header is the issue here, but maybe I'm wrong?
> > Jakub?
>
> Until the device metadata access from BPF is in bpf-next the only
> opinion I have on this is something along the lines of "not right now".
>
> I may be missing some concerns / perspectives, in which case - when
> is the next "BPF office hours" meeting?

SG! Let's get back to it once we get the basic rx metadata sorted out.
I'll probably look at the tx part next though; that xdp->skb path is
of least priority for me.
