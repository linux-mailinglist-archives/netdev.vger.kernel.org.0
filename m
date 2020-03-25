Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 382DF192FF6
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 18:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbgCYR5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 13:57:04 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35681 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbgCYR5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 13:57:03 -0400
Received: by mail-pl1-f193.google.com with SMTP id g6so1106557plt.2;
        Wed, 25 Mar 2020 10:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=LcnFLGNBmm0IVLGhfPKr1/VuZRnu6FpgzCF+UvqP0dg=;
        b=PJPXcwrs1iBQ1K6mKKHgQyRGiROzE6kyMNZhGg2cDVCU7kiEafl+1O7Qhv3DPSIz8p
         Xmai1C2uEmOPLBPJ+I4SsZ2xDYM+eWewEDVUKZCwlEPAv7SSIqYfscn/sW7/d+5i+4IX
         xNWNWVrZDm8dPLm+J1sWqdMqP7rSiY5Ci53HJcwjUuaYX1nFaEYKWa2XV7CeQBCfzykv
         eMS4GRn0MKb1EyoprRgCk+X+I3bjO9LcJPKMrDrQN7wjKa8SoH6n3atjxeX2bFvI4BlV
         wE8xR/RnpU5HAncKphVv2vXTj10fzofC96NWpniNRWImw5agEv9jJz/exrhKNNEH3Qkq
         1GVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=LcnFLGNBmm0IVLGhfPKr1/VuZRnu6FpgzCF+UvqP0dg=;
        b=JQzSFx5BC9u8yUPDmf814EP9ps0Fq41b2fS1BLrvK3Xww4utvoGG2txRCaxm4yRyDx
         XOb/TwLuzUf7TUwQjN/IgNZRGuMaCYKc88EN1X9eT+VIMO83souc9N8HRqUfJxSdYjRa
         NGItdrCaJ3/zVBSWsMYULbxRHO26+k/v9KDIOeQaMifSqZJXnyWc9j+qym3QlCZZEq/K
         Pv+0rWewURrricWWbeSAtrh5f61BWfE/dDJgrXYRb56siTzeg1a6oC9ys8ZgFjJNgnzQ
         sNJThgbumdpKrjsYr/U8taerhh4PSH6LcX3HXgnPAjnfPm4IhGscYsyyw4C80DobprqI
         poag==
X-Gm-Message-State: ANhLgQ2bvpvlEkXPsPZAY+ONPRlh6XIDof+GRoQsH9KZN3LwgTaTN5Mf
        W9BrU/yHLMNhnkSZeeaz4Zk=
X-Google-Smtp-Source: ADFU+vvAbOxqcKt5RF7xOVnMxNSR4YmyrH64+IGiP1Bw17oAl7edlNDS7MO9MmbmG8Iwy66ff8TsXg==
X-Received: by 2002:a17:90a:14f:: with SMTP id z15mr4888654pje.137.1585159019204;
        Wed, 25 Mar 2020 10:56:59 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:b339])
        by smtp.gmail.com with ESMTPSA id g30sm630952pgn.40.2020.03.25.10.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 10:56:57 -0700 (PDT)
Date:   Wed, 25 Mar 2020 10:56:54 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200325175654.i4cyhtauyogvzvgf@ast-mbp>
References: <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
 <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
 <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk>
 <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk>
 <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
 <5e7a5e07d85e8_74a82ad21f7a65b88d@john-XPS-13-9370.notmuch>
 <87zhc4pw08.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87zhc4pw08.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 11:30:15AM +0100, Toke Høiland-Jørgensen wrote:
> 
> From a BPF application developer PoV I can totally understand the desire
> for unified APIs. But that unification can still be achieved at the
> libbpf level, while keeping network interface configuration done through
> netlink.

it cannot be done at libbpf level. The kernel is missing the ownership concept.
netlink vs other is irrelevant.
