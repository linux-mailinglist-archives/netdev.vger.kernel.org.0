Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D83594EAC
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 04:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbiHPCcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 22:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233066AbiHPCb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 22:31:58 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10127422D0;
        Mon, 15 Aug 2022 15:47:59 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id r4so11286597edi.8;
        Mon, 15 Aug 2022 15:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=9PqDuOywOMmDjaYZKurMwbkgvWbllc3+022Ldgo4u3A=;
        b=a4rrToQkGyoBigN89W8tVXwF/+LRvqkK1hB7E3VOIdIP+OPJNmhPyYamNf9x2GOdtt
         BHD6crzswEbRWkW4+HokJf/RMpvnfpZdw3yz6vYt9GjK23ZV4UF3rIX7L2csb5Uhei5V
         WDrqWDr7AbEFF1cpjyzlnqZVWIMX3XYJzDAlWIWhHhB6/BympUmhOZy/KLhHSpYihqIL
         8dpdvi2ZX5ef7XgV/2et07ceYwvOOOeNzG3GKGGk9pXTONOzOCnjXt2hsZwe+JORDigH
         iznaDa6tTl80WXygFn/HxLAVY7CCPWexfGv/BqUKB4O5g/Ug77AxLRb6RrjFAaCAKkwM
         c6OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=9PqDuOywOMmDjaYZKurMwbkgvWbllc3+022Ldgo4u3A=;
        b=gopFzNcuvzx/Xvq3K5x/tPhrAxxzx1uLFy50JsaT/hkBoXiSCywZ6v4aXrmHHOTfCC
         bSoJfWxws5V3grLsl301y7pDBhik43OrRpgLgHmikVstD5qorzPkYO5yV6P3rHxwHVoI
         slyQHmUAU0w5buZdZj0S6VqM1Xf9DwSWqoLF8XINKPYMz++hZ68ZAncfW1KkzvlYjfHC
         YJp34jpq2OlC+BlIO6Ojw24WKi79wQTXo6OIoI2sjPI6Pdt4UeObFNQ4Rh7AJ3hDRMOk
         JSDrleGLz7Eji1W+63InT0IU+1Ks6bEiAus3lP3U9XvVoDTWMCqs5KVlrMoeSe4rUa0E
         qBxA==
X-Gm-Message-State: ACgBeo11tEHK+vkEIqcwb1wR+PsRp/ORPn4xYI7zdkbfCz24GYmCzMEb
        ausC1S3vqaCPtJnMKUwmtJ0qG05P6te1QRQvnkc=
X-Google-Smtp-Source: AA6agR5Noec/RrVP9Mn6nUbr357drzDp+0QtwTJ6fKpyaR5rGhJZqywEzjyPWUU6XNmxd38Ju8TEhnQqdlQ7sJ1akhM=
X-Received: by 2002:a05:6402:27ca:b0:43e:ce64:ca07 with SMTP id
 c10-20020a05640227ca00b0043ece64ca07mr16896124ede.66.1660603677431; Mon, 15
 Aug 2022 15:47:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1660592020.git.dxu@dxuuu.xyz> <f850bb7e20950736d9175c61d7e0691098e06182.1660592020.git.dxu@dxuuu.xyz>
 <871qth87r1.fsf@toke.dk> <20220815224011.GA9821@breakpoint.cc>
In-Reply-To: <20220815224011.GA9821@breakpoint.cc>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 15 Aug 2022 15:47:46 -0700
Message-ID: <CAADnVQLB1SQoYAYEzU_VuJ=q3azeyhBiK-NkU5OZC7rrumi0xQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] bpf: Add support for writing to nf_conn:mark
To:     Florian Westphal <fw@strlen.de>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>,
        Daniel Xu <dxu@dxuuu.xyz>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 3:40 PM Florian Westphal <fw@strlen.de> wrote:
>
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@kernel.org> wrote:
> > > Support direct writes to nf_conn:mark from TC and XDP prog types. Thi=
s
> > > is useful when applications want to store per-connection metadata. Th=
is
> > > is also particularly useful for applications that run both bpf and
> > > iptables/nftables because the latter can trivially access this metada=
ta.
> > >
> > > One example use case would be if a bpf prog is responsible for advanc=
ed
> > > packet classification and iptables/nftables is later used for routing
> > > due to pre-existing/legacy code.
> > >
> > > Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> >
> > Didn't we agree the last time around that all field access should be
> > using helper kfuncs instead of allowing direct writes to struct nf_conn=
?
>
> I don't see why ct->mark needs special handling.
>
> It might be possible we need to change accesses on nf/tc side to use
> READ/WRITE_ONCE though.

+1
I don't think we need to have a hard rule.
If fields is safe to access directly than it's faster
to let bpf prog read/write it.
There are no backward compat concerns. If conntrack side decides
to make that field special we can disallow direct writes in
the same kernel version. These accesses, just like kfuncs, are unstable.
