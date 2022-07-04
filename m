Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA10B565C9F
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 19:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiGDROD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 13:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiGDROB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 13:14:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 47DC965D6
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 10:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656954838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dNFZBk2MReDVOF2gT6UYM02hb0KdZvS6at3FbBoI3pM=;
        b=PArGwWa2AIQ6Ws1O5kEobm8vkhA56MI4clSOkzrGxO95KE2Gq1cwLIstvzQBcdcLp5J0gv
        gOvoUeytuZne1cFZtZVvRzkMet/xX64+OEELCNHWKn+ET7JdnoEp9yx3pQwdI7eW1buQGq
        4D3EiAop7tfEcvq85JflVW/9YC2DXMU=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-hJALR_8yPbWL32CgEovPaA-1; Mon, 04 Jul 2022 13:13:57 -0400
X-MC-Unique: hJALR_8yPbWL32CgEovPaA-1
Received: by mail-lf1-f72.google.com with SMTP id j3-20020a05651231c300b00482a2d17bd3so1551762lfe.9
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 10:13:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=dNFZBk2MReDVOF2gT6UYM02hb0KdZvS6at3FbBoI3pM=;
        b=HgFNRT78c3SbnX2Tit9AA7cqYnYXTk5+aFRbGm26IWVqJjS5V1hPsDRJ4zng1PyImc
         wEGSXog7Bsd6/hAZg71hWDysxr7XqgZsJnJxKsCkTSvHrc4nck4TnZFYazeujWPaFZ81
         szFMNsUSr0d36NEkuqS9BggPb/4btAr5Ln1inxboWYRoGm0fgvy9t0RzWy92kqcVNJ2n
         mSzcFklOInXozgnco6RPhzMzqmN5FZDUgkw6Vsh+8va9ulgVzthcuxANXTHr3VoPWH/Y
         bFtWsMfSuAEVBDHZwmmT389NVitVFU8KwhMtYxL3q8fQQBNw8XNa1oVQ73r6Xumed9XS
         Ru/w==
X-Gm-Message-State: AJIora/wzQ2EoQuNQXSriSMwZHNPQjMNaqRZr4jBZ+gK1hGvxtC1ql/9
        Pmn9vRi36rNQ+Y7BkVm9jdo14+xL6Kcs0H94qx6KHt9rRTs7YrgX5p9TO5j4t6hsvPg71+tBup/
        QL8m6+jIaT8UR0YJu
X-Received: by 2002:a2e:b751:0:b0:25b:da59:96b9 with SMTP id k17-20020a2eb751000000b0025bda5996b9mr16564759ljo.176.1656954835698;
        Mon, 04 Jul 2022 10:13:55 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tHu1DJfF7/r9dEXd50aOLye631DC1z4l08yWjIoREL+G9uEz5rjyOO5svoU/MfRlDuSC4GRQ==
X-Received: by 2002:a2e:b751:0:b0:25b:da59:96b9 with SMTP id k17-20020a2eb751000000b0025bda5996b9mr16564722ljo.176.1656954835371;
        Mon, 04 Jul 2022 10:13:55 -0700 (PDT)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id j13-20020ac253ad000000b0047f7f4cb583sm5200739lfh.288.2022.07.04.10.13.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 10:13:54 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <0cd3fd67-e179-7c27-a74f-255a05359941@redhat.com>
Date:   Mon, 4 Jul 2022 19:13:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Cc:     brouer@redhat.com, John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: Re: [xdp-hints] Re: [PATCH RFC bpf-next 00/52] bpf, xdp: introduce
 and use Generic Hints/metadata
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
 <62bbedf07f44a_2181420830@john.notmuch> <87iloja8ly.fsf@toke.dk>
 <20220704154440.7567-1-alexandr.lobakin@intel.com>
In-Reply-To: <20220704154440.7567-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 04/07/2022 17.44, Alexander Lobakin wrote:
>> Agreed. This incremental approach is basically what Jesper's
>> simultaneous series makes a start on, AFAICT? Would be nice if y'all
>> could converge the efforts :) >
> I don't know why at some point Jesper decided to go on his own as he
> for sure was using our tree as a base for some time, dunno what
> happened then. Regarding these two particular submissions, I didn't
> see Jesper's RFC when sending mine, only after when I went to read
> some stuff.
> 

Well, I have written to you (offlist) that the git tree didn't compile,
so I had a hard time getting it into a working state.  We had a
ping-pong of stuff to fix, but it wasn't and you basically told me to
switch to using LLVM to compile your kernel tree, I was not interested
in doing that.

I have looked at the code in your GitHub tree, and decided that it was
an over-engineered approach IMHO.  Also simply being 52 commits deep
without having posted this incrementally upstream were also a
non-starter for me, as this isn't the way-to-work upstream.

To get the ball rolling, I have implemented the base XDP-hints support
here[1] with only 9 patches (including support for two drivers).

IMHO we need to start out small and not intermix these huge refactoring
patches.  E.g. I'm not convinced renaming net/{core/xdp.c => bpf/core.c}
is an improvement.

-Jesper

[1] 
https://lore.kernel.org/bpf/165643378969.449467.13237011812569188299.stgit@firesoul/

