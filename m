Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4999E647C79
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 03:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiLIC5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 21:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiLIC5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 21:57:50 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40621A822
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 18:57:48 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id d82so2743507pfd.11
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 18:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZN6Ds0GTGoNBiJrF9Iw5CyP8TuCwXyyFiKu0u0AYj3o=;
        b=GyiB/ru/0wWy627fKFRf5xcbvQS0BJ8wjivpjdLr/jysYEYsWgTjKhZgqS613S0SYH
         3RH06S7roc5hcQ2Q/Rgsrc5POIfClXZ+C5qNT+Qf6u37GTguwWGJTo8ULTS9ZBAylSP/
         GpLP4GiSwaQXLCtUNM0cU8NZhL3HVlColoQBwrIGxO72Vfl0/0rTkUw/JpfvvwSeFwNC
         sBzbDLcEum7Z5NencBueTDev53cKyjRJ47rC92ZO6wpYXK0wjy7W1Q63xVUypB83ORRL
         Bx3Iu9G9X3E9RysOQOzjN7nx5thaYbL8isfylMs8WJKUBrCnQENKOmcrX4J30rIfqvW8
         BPKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZN6Ds0GTGoNBiJrF9Iw5CyP8TuCwXyyFiKu0u0AYj3o=;
        b=X0V/rt75ccmeejuCaR1QMVQPB6WjJchtMVZ8do8oqUSVFsB5cWvpti/zPhTCHE6fwT
         RIsBGccC57UfY4jQs26k0qPrUsFQCXk640ZczuwlFSOsn6yAhEKPHMcxYbjtgS1IDdCR
         NbcpBpol2eYDNYaXiHX1T/rOSMmM92xWQDkMOinMb4HaI/Ha8yeRoasiQunLfle4Ks8P
         mEbVtlYpysu2pZxQUeal4Rl+T2NF5zDRaoD2rcj9fW5YQKN+0gxliCvFPG3FU6zTXvCl
         p/O3Y0VoDyGp6TZkwE/YCpT7p87c4SKqvx9osqCAFRdNvXMgta1MIPt/WRyH/xMeIUPK
         lpXA==
X-Gm-Message-State: ANoB5pkqWDu/gvdSDE2JiJTXtl1gWuqfxc31A3rcacW7ygk1w/voU8mL
        8KFo6VwdBsneo+jQFiePiuHGScE0AiJjf1Es4LOYAQ==
X-Google-Smtp-Source: AA0mqf6h7cGJ0arIuPLaA3bnYaBrIgzkzfJ4sPigj43qbYngE+KpkAKk8+NEqmPC3E2BU2h8mlvavmvG1riFJPLdpV0=
X-Received: by 2002:a63:2160:0:b0:46f:f26e:e8ba with SMTP id
 s32-20020a632160000000b0046ff26ee8bamr71539985pgm.250.1670554668099; Thu, 08
 Dec 2022 18:57:48 -0800 (PST)
MIME-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com> <20221206024554.3826186-4-sdf@google.com>
 <20221207210019.41dc9b6b@kernel.org> <CAKH8qBtAQe=b1BLR5RKu7mBynQf0arp4G9+DtvcWVNKNK_27vA@mail.gmail.com>
 <20221208173053.1145a8cb@kernel.org>
In-Reply-To: <20221208173053.1145a8cb@kernel.org>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 8 Dec 2022 18:57:36 -0800
Message-ID: <CAKH8qBtV66xNT+Z1dR9=BmOHwv6=bd8dEjO7kXG2BWASGA0bhA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 03/12] bpf: XDP metadata RX kfuncs
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
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

On Thu, Dec 8, 2022 at 5:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 8 Dec 2022 11:07:43 -0800 Stanislav Fomichev wrote:
> > > >       bpf_free_used_maps(aux);
> > > >       bpf_free_used_btfs(aux);
> > > > -     if (bpf_prog_is_offloaded(aux))
> > > > +     if (bpf_prog_is_dev_bound(aux))
> > > >               bpf_prog_offload_destroy(aux->prog);
> > >
> > > This also looks a touch like a mix of terms (condition vs function
> > > called).
> >
> > Here, not sure, open to suggestions. These
> > bpf_prog_offload_init/bpf_prog_offload_destroy are generic enough
> > (now) that I'm calling them for both dev_bound/offloaded.
> >
> > The following paths trigger for both offloaded/dev_bound cases:
> >
> > if (bpf_prog_is_dev_bound()) bpf_prog_offload_init();
> > if (bpf_prog_is_dev_bound()) bpf_prog_offload_destroy();
> >
> > Do you think it's worth it having completely separate
> > dev_bound/offloaded paths? Or, alternatively, can rename to
> > bpf_prog_dev_bound_{init,destroy} but still handle both cases?
>
> Any offload should be bound, right? So I think functions which handle
> both can use the bound naming scheme, only the offload-specific ones
> should explicitly use offload?

Agreed. Will rename the common ones to dev_offload!
