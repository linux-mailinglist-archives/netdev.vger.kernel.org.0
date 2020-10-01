Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF91280307
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732620AbgJAPkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 11:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731885AbgJAPkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 11:40:51 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2381C0613D0;
        Thu,  1 Oct 2020 08:40:50 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id r24so5058538ljm.3;
        Thu, 01 Oct 2020 08:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kuMjPWKiD2oqELTx7IGcIvbf+zcqAAlUMunKUA7pXBM=;
        b=OgXqqs/if/KAcvhxEHGSGv/dlra1C3gr45obQlUiBKp1PDs8l0B1Q1lpgVusdfW643
         AIkM6fDuqWwsLbMouYv+WgH75nJxxb183cuQE49mgKPG6YBkM8uelUYBp/jvP9NdCNF4
         dOTJT25WtWcQeIs+oxvsYwZlQG09byGbip5OO54YfYapyeH6cYh6g24Ab8bTaWQJyMRV
         i6GrDLyzLKS3kGbgqvNWbmuVkOl5afe/NSzWdcLIlo4Y8Hj4WnCVhAnmRNLN+2SnAvYk
         J4OLYojD5tEDmBd1RgiPuLlcrARkv+cLSlGJssglkCEpc8n+BfW2Caz2laWPdW0LRvIP
         Z5og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kuMjPWKiD2oqELTx7IGcIvbf+zcqAAlUMunKUA7pXBM=;
        b=luLdTH3Kue4Zc9fZmzd01lAUC888ISI+CBhgm4pLzCHBgE6dW6Rt+dMMxm+z1kxqzj
         ft+d2KvzTL9rBmsXMd85fxTSp8y0P11f6/iY1lwaq3/aEBM+d+3dsla4yoCth8v7q1Ji
         l1E+prHRC0Ee63h1pKZHnGswjDEiukZSMbE75G2Td4gaOX8QHUmqi3xfkTb4G9999jjj
         S47NZgplbhLIjfTeP7DTTLTZUBcfsdiKbKsWtlYCg9ypaFrgCIxQiLnVPBVnWfpo9cDs
         3O5ctrslMC0dfI+BQzIbXMZLyk4eqes4v6zCeh6mLv6M0iBy3lOy1wqrhhxJFJKyluXu
         CCfQ==
X-Gm-Message-State: AOAM532ZBt3JhbsjaEEkQ28VX81CmASUkvYTHlaerhKtMcntl516iuVF
        v6TV2qeYgM2iwe+S6QoaXWp83mB6V2oAISAfpy0=
X-Google-Smtp-Source: ABdhPJxez8ZO6JFpsIPGzov/HGpjjWEmromf4jskS1png2k/hO796iLcslAfOAAVwjcaxhobFC2WuAC4anO4T5abL0E=
X-Received: by 2002:a2e:808f:: with SMTP id i15mr2333354ljg.51.1601566848933;
 Thu, 01 Oct 2020 08:40:48 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1601478613.git.lorenzo@kernel.org> <5e248485713d2470d97f36ad67c9b3ceedfc2b3f.1601478613.git.lorenzo@kernel.org>
 <20200930191121.jm62rlopekegbjx5@ast-mbp.dhcp.thefacebook.com> <20201001150535.GE13449@lore-desk>
In-Reply-To: <20201001150535.GE13449@lore-desk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 1 Oct 2020 08:40:36 -0700
Message-ID: <CAADnVQ+syU=oF1C3eDp-ggP-D1PyH1JvJdNFjxm4ABZ0JGyYNQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 06/12] bpf: helpers: add multibuffer support
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sameehj@amazon.com,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, shayagr@amazon.com,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 1, 2020 at 8:05 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> > On Wed, Sep 30, 2020 at 05:41:57PM +0200, Lorenzo Bianconi wrote:
>
> Hi Alexei,
>
> > > From: Sameeh Jubran <sameehj@amazon.com>
> > >
> > > The implementation is based on this [0] draft by Jesper D. Brouer.
> > >
> > > Provided two new helpers:
> > >
> > > * bpf_xdp_get_frag_count()
> > > * bpf_xdp_get_frags_total_size()
> > >
> > > + * int bpf_xdp_get_frag_count(struct xdp_buff *xdp_md)
> > > + * Description
> > > + *         Get the number of fragments for a given xdp multi-buffer.
> > > + * Return
> > > + *         The number of fragments
> > > + *
> > > + * int bpf_xdp_get_frags_total_size(struct xdp_buff *xdp_md)
> > > + * Description
> > > + *         Get the total size of fragments for a given xdp multi-buffer.
> > > + * Return
> > > + *         The total size of fragments for a given xdp multi-buffer.
> > >   */
> > >  #define __BPF_FUNC_MAPPER(FN)              \
> > >     FN(unspec),                     \
> > > @@ -3737,6 +3749,8 @@ union bpf_attr {
> > >     FN(inode_storage_delete),       \
> > >     FN(d_path),                     \
> > >     FN(copy_from_user),             \
> > > +   FN(xdp_get_frag_count),         \
> > > +   FN(xdp_get_frags_total_size),   \
> > >     /* */
> >
> > Please route the set via bpf-next otherwise merge conflicts will be severe.
>
> ack, fine
>
> in bpf-next the following two commits (available in net-next) are currently missing:
> - 632bb64f126a: net: mvneta: try to use in-irq pp cache in mvneta_txq_bufs_free
> - 879456bedbe5: net: mvneta: avoid possible cache misses in mvneta_rx_swbm
>
> is it ok to rebase bpf-next ontop of net-next in order to post all the series
> in bpf-next? Or do you prefer to post mvneta patches in net-next and bpf
> related changes in bpf-next when it will rebased ontop of net-next?

bpf-next will receive these patches later today,
so I prefer the whole thing on top of bpf-next at that time.
