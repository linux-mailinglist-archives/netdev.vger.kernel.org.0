Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75897527310
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 18:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbiENQmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 12:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234291AbiENQml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 12:42:41 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39046BC90;
        Sat, 14 May 2022 09:42:40 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id m1so9513104qkn.10;
        Sat, 14 May 2022 09:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YzZf4CIuSRuke7K8PFWObNccQOsJydtLLune2imVRSY=;
        b=FsOBk/p91UfFDfai2dq8nks2do3hbcpTnl2zoi3Nzvcp1EftU2RJm9UYxZq0pluxRO
         cVmy2PNmM33l8NgA2st1vLMsI82IAFxJNa92hAzO6sF/oUUAmxAw7biD1NBieeup7fSW
         uNYtqiHeVwB0c5tE/csK098NomIywxATHjnKsCPjAQaaNfRijGENelwTuZxt7LZhWVhe
         +PUQ8iowoTCatBW9nD8BPpl+F3suZxwJeyPr7iKVox6QHnXPoVbSBtaqRsU9adG+xupT
         LUIeqZy+7ADhXLmpjh84PtNUe9CnvMH8Lu48iRAoFmelB2cJeD409EM0PVeE3v+HXTcx
         2JqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YzZf4CIuSRuke7K8PFWObNccQOsJydtLLune2imVRSY=;
        b=3B+uDjTquCzjtwTuCj89sdVY2iEUpLuWcLrLxKWOCwJ/7fDHmXdQk3IXtZwHlGKfOw
         IdBj9ejj5+2ifd7EnXuE2in6rxDS59pPs2k4wIQK6IR6fAcRiW2Vny303yJ7RsuOJGS9
         QW87Z2+qsgufG+9TvYmzitLLELAWuDTeMmhqfiyza2O5mgKC4zoa3sLGO6WCYLT8BRX/
         Ftwvt6DCTfe7mIayKXmdA1e6iE90oRRwWrt4d198m2qPq9rCyUxu6Df6sF+qixFYcA2V
         hEMql8bFvG6+SIHlxq7waAzWBEHxaRrS8GEUha73hQAgJrdgAH8QcEIWBJLD0vYQmOVo
         8yBw==
X-Gm-Message-State: AOAM530etPJxMXd9nrxly0UVDHzPy2UUx9o1wPZO71chAyIgsCJF0X3R
        AdYhrT3K6EFrXs4GJBxE6eW8hT+LWVJZn3BodVCM62fK
X-Google-Smtp-Source: ABdhPJzb0fPyN12Vpt3BNTHN4hsFSpw9Y14g/udGKRMAXLfR3PgjoqFQSybkueB/7tA6k/v+rL3UBLDswnDszpZxJFM=
X-Received: by 2002:a05:620a:919:b0:69f:e373:3de8 with SMTP id
 v25-20020a05620a091900b0069fe3733de8mr7176608qkv.27.1652546559287; Sat, 14
 May 2022 09:42:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1652372970.git.lorenzo@kernel.org> <4841edea5de2ce5898092c057f61d45dec3d9a34.1652372970.git.lorenzo@kernel.org>
 <CAADnVQKys77rY+FLkGJwdmdww+h2pGosx08RxVvYwwkjZLSwEQ@mail.gmail.com> <Yn+HBKbo5eoYBPzj@lore-desk>
In-Reply-To: <Yn+HBKbo5eoYBPzj@lore-desk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 14 May 2022 09:42:28 -0700
Message-ID: <CAADnVQJbOZAg-nGrVutwCA5r=VATXVOXD5Y2EtbfkZHtCsrBbg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/2] selftests/bpf: add selftest for
 bpf_ct_refresh_timeout kfunc
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
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

On Sat, May 14, 2022 at 3:40 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> > On Thu, May 12, 2022 at 9:34 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > >
> > > Install a new ct entry in order to perform a successful lookup and
> > > test bpf_ct_refresh_timeout kfunc helper.
> > >
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> >
> > CI is failing:
> > test_bpf_nf_ct:FAIL:flush ct entries unexpected error: 32512 (errno 2)
> > test_bpf_nf_ct:FAIL:create ct entry unexpected error: 32512 (errno 2)
> >
> > Please follow the links from patchwork for details.
>
> Hi Alexei,
>
> tests failed because conntrack is not installed on the system:
>
> 2022-05-14T00:12:09.0799053Z sh: line 1: conntrack: command not found
>
> Is it ok to just skip the test if conntrack is not installed on the system
> or do you prefer to directly send netlink messages to ct in order to add a
> new ct entry?

It will take a long time to update x86 and s390 images.
Maybe we should add a kfunc that creates a ct entry?
