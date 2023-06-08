Return-Path: <netdev+bounces-9397-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F00E5728C0B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 01:55:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC55A281397
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:55:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0DAB38CD0;
	Thu,  8 Jun 2023 23:55:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFB12A711;
	Thu,  8 Jun 2023 23:55:05 +0000 (UTC)
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1166C2D48;
	Thu,  8 Jun 2023 16:55:04 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2b1b084620dso12334861fa.0;
        Thu, 08 Jun 2023 16:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686268502; x=1688860502;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QNHnwv3qBjwav6e7vyBTs2Fp4wl6kVhQuzNliqjos+Q=;
        b=WJuxBs/23SwuGn6KnBw5Ke/S3yzBATxKyRD84745/ed+ereoFsERgMhQ1FjADpKfFq
         X+uIptsHn7jTlnPM2o8+znB/zl9Y83TJcu17epdNbksEqWpPZsQIAb80rMxhaWFckOHn
         TPCbovwTS9ceU+/CRXk+QwywVaHsvq21FLxFaTVLMzkOVUIVVzrc5EpC5VausFnv5TiO
         rBx9MUp3OFLT9mbFXKO4RGqNCiKZmQZ6PoZzMipzP6aKkY3aMI6fawFG7nWF058iyMnY
         YW25zSMJJ1exCpf1hm/jkB/6DVsPGNfzzkNtVCPK8huaNm0oj1cSbAq+RCmtnQnd2jhu
         eJzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686268502; x=1688860502;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QNHnwv3qBjwav6e7vyBTs2Fp4wl6kVhQuzNliqjos+Q=;
        b=hi4cQd4S1PPbfE3LG+dSiOtfeUNiU+vH6b9rOPkyx/y7rHMkWTrVEkxk37XBV6eX7y
         zOj04A9UjioBWVo+bcOSi8nZiT9FQqwr0GUdOlX2T6ND+Xkd62LJxrv9cBzmuxm04cw3
         xFwMw5FLvEdFHLOUk7rdDsrTR3dhGgPvWgIDt5ATDJ4K+PfHxY+5EyubiOYn4Di4q0KF
         N8ZbFMIsMiiMyEEllTyjPTOSfVV4XTwvzcGBkr1Wz/L4SLudI/y+UrPgxYiHe/Yzihpj
         2IoooCK/t5f/LwlrutQ39q8GyR6luE8HY2+Qz48pttqfaO9dvwEElGchFQgO/Fgma4w6
         mzBg==
X-Gm-Message-State: AC+VfDyyMjreTFZna1vApQhhXtuvL5VYW4oKfz0VFytNm4pe3ENlqbgt
	z/OiaaHJChlX2otQXVH4qQ3VOs8yjCq4zdjv8Qo=
X-Google-Smtp-Source: ACHHUZ7kDbUzge+oSL+PVvGVqC72X7BfYq6ahovC/jaoSNCL0EUJwZW7dR9ZhJsar5DMhwjFZnpsJbz61h+qr4EvwXI=
X-Received: by 2002:a2e:83d5:0:b0:2b1:b301:e63f with SMTP id
 s21-20020a2e83d5000000b002b1b301e63fmr64776ljh.2.1686268501845; Thu, 08 Jun
 2023 16:55:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230607192625.22641-1-daniel@iogearbox.net> <20230607192625.22641-2-daniel@iogearbox.net>
 <ZIIOr1zvdRNTFKR7@google.com> <CAEf4BzbEf+U53UY6o+g5OZ6rg+T65_Aou4Nvrdbo-8sAjmdJmA@mail.gmail.com>
 <ZIJNlxCX4ksBFFwN@google.com> <CAEf4BzYbr5G8ZGnWEndiZ1-7_XqYfKFTorDvvafwZY0XJUn7cw@mail.gmail.com>
 <ZIJe5Ml6ILFa6tKP@google.com>
In-Reply-To: <ZIJe5Ml6ILFa6tKP@google.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 8 Jun 2023 16:54:50 -0700
Message-ID: <CAADnVQLL8bQxXkGfwc4BTTkjoXx2k_dANhwa0u0kbnkVgm730A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/7] bpf: Add generic attach/detach/query API
 for multi-progs
To: Stanislav Fomichev <sdf@google.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Nikolay Aleksandrov <razor@blackwall.org>, 
	John Fastabend <john.fastabend@gmail.com>, Jakub Kicinski <kuba@kernel.org>, Daniel Xu <dxu@dxuuu.xyz>, 
	Joe Stringer <joe@cilium.io>, =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, bpf <bpf@vger.kernel.org>, 
	Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 8, 2023 at 4:06=E2=80=AFPM Stanislav Fomichev <sdf@google.com> =
wrote:
>
> I'm not really concerned about our production environment. It's pretty
> controlled and restricted and I'm pretty certain we can avoid doing
> something stupid. Probably the same for your env.
>
> I'm mostly fantasizing about upstream world where different users don't
> know about each other and start doing stupid things like F_FIRST where
> they don't really have to be first. It's that "used judiciously" part
> that I'm a bit skeptical about :-D
>
> Because even with this new ordering scheme, there still should be
> some entity to do relative ordering (systemd-style, maybe CNI?).
> And if it does the ordering, I don't really see why we need
> F_FIRST/F_LAST.

+1.
I have the same concerns as expressed during lsfmmbpf.
This first/last is a foot gun.
It puts the whole API back into a single user situation.
Without "first api" the users are forced to talk to each other
and come up with an arbitration mechanism. A daemon to control
the order or something like that.
With "first api" there is no incentive to do so.

