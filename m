Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B50D523738
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 17:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343637AbiEKP0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 11:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343633AbiEKP0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 11:26:40 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB63B377E7;
        Wed, 11 May 2022 08:26:39 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id f3so2344639qvi.2;
        Wed, 11 May 2022 08:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q7Ehf8HVMk4hFN0gtPFwkycDqnQI5Sc0W9LhYQbeDYM=;
        b=LmYZT/lJddRubn1os+gEg6veGjF+5UlCsck5gVQNemN17Y4loTgv+VdRdwbmEc0Wk8
         Ir6mmtSK0EtnnVZROY/a39iIs9jGNW+YCvMPsk/SzOwy544uHqEPevezVFHwRU5Mq81E
         JjsQuN/SAQiVsfPUDdgrxpUYasG2lvlg8RVr51yQd/q2SVL3bQi8IslwFmZCGXZ9FNfQ
         SZFq08k/l6r+jHDofbsAv33vEt5LvgCh6DOwkaLIE6NPDqKKu4WzbddhTP1vLhZOWrZu
         sjBqV2KpTNWAZKAxnlakivDQBdkbTC/O+QyQO8fV3eAsveNbCSaMx4RQ33+hk6bau+KP
         F3FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q7Ehf8HVMk4hFN0gtPFwkycDqnQI5Sc0W9LhYQbeDYM=;
        b=1cK0xAkNEH2psqhOZ9aRB33aLe2wIPdhbUUIzt7CDmcn6lhIwNovkkPt/2YMZBDClS
         Sx82XACVasjK7nBxVBAjkeIaPQ9xn+ykF93ZAYAvm1TgQ2mbCG0kM8vfKcxkoM1cT94S
         dpR3O4myUn1p8td48jF8Vmjjs6QnRGv/vWvPaR+bkZCl0YHZ+yX/10YIYwoEHV4aRvlY
         WrEMdL+0Rn71NiPxvb/f/gPtekkkbAgou9+91BaYY+NSBghpVRlGzGDiwbaFvmrNCkmn
         dGn+Bv7wQ79jMO4fEs1vJFiHNL4OQtbGmKglR52hh8Fu8bRzDf+3XL6NyGlMR5n0G5vH
         TQ8w==
X-Gm-Message-State: AOAM532WpkCWegzJ+RTK/3CKsML1hfuWks3+NLPnYhRpBgK7Jvj035cR
        DYhVlBsmE5XHzgPuqEpD8LOoZKFSWTV8m19/QpM=
X-Google-Smtp-Source: ABdhPJwF57CnU/d5s+HYeo9V1/sXiaWr5X3zghUeHL0tHGbsDb4LSmLiBNA0xY9qvPjlaf7oIXvd7zm3n1aOgrDKtKg=
X-Received: by 2002:ad4:5ca3:0:b0:45a:89fb:3795 with SMTP id
 q3-20020ad45ca3000000b0045a89fb3795mr22749487qvh.63.1652282798755; Wed, 11
 May 2022 08:26:38 -0700 (PDT)
MIME-Version: 1.0
References: <1327f8f5696ff2bc60400e8f3b79047914ccc837.1651595019.git.lorenzo@kernel.org>
In-Reply-To: <1327f8f5696ff2bc60400e8f3b79047914ccc837.1651595019.git.lorenzo@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 11 May 2022 08:26:27 -0700
Message-ID: <CAADnVQK+1hOAZR-k1tQ6sNyhx-4pcKMp72uPuApC8KnSqzXdcQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] net: netfilter: add kfunc helper to update ct timeout
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

On Tue, May 3, 2022 at 9:29 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Introduce bpf_ct_refresh_timeout kfunc helper in order to update time
> nf_conn lifetime. Move timeout update logic in nf_ct_refresh_timeout
> utility routine.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Looks good, but selftest and Ack from Kumar is needed.
