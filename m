Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1524A6A7A7B
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 05:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjCBE2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 23:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCBE2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 23:28:53 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F5D1350A;
        Wed,  1 Mar 2023 20:28:52 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id e194so2475494ybf.1;
        Wed, 01 Mar 2023 20:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677731332;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZuIWH1UlcVmwR9ojg9PVt2SFHPJ4aMre4PiT269fA+4=;
        b=je5NNE+XXRwcHZHJ+dmdxJk8Yd0lUpJZCdO2wjzHRJpmfO2CKj2XSq0WDDJdkTbOwm
         VG1jBPRVGhW9UbQJ2xa9nR3cbA2jnYNkENYCTCYsPeg9T+PXv5HNamjXY3tD84fbLZdh
         9Gs4U7MA+gZUdCXXIGQ1tu1EQwmpnN5g+acCaYpFCyhNMZcyNDDFegJjR5uiqLwFq6G0
         OEZs60lY6MJMan9+qYcESoD0RFWN9bpZ2cQIwXKqX2+T555sG5ZSnPGWiJZaqpLyBYt5
         kcyhjVsiY6imL3VD9lw47WlMz64PVECRk5knLugd4L3Ff2uakGSX4AH6BvrSgOzbXkRm
         MbWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677731332;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZuIWH1UlcVmwR9ojg9PVt2SFHPJ4aMre4PiT269fA+4=;
        b=O0q1ktp5pPgQ1Ou77fMVXvwu3O8L5AzGfWXdPy4sM3apem8eA7SiX5ib82uqUdhwxa
         vmEOljYKH1rqOW9kFdGRYas3Ro19FgUlmjagbMf+nORgf8DvCrmbtNYYD6gcp9pmw76C
         j/iu+y3NZjAsKu+BgrJnyXZehvyfat5JipQMLDEyi5nidrspTi1va2zU7SnhR22hVfcz
         XX+brMZJD2c9vN4xoPsR8tvZ4glA6f7wzgsFdT5okijhMAqM17TA2zg/mjgift+cIVGU
         G8cpuqwwkBGua1PNVea5ERIOBQwgDLSaWc29Z/Cgl/sRUMQ0u1wgWn1s+OvQ0CN2YhXX
         +Sug==
X-Gm-Message-State: AO0yUKUbaTcM9j1T4lYbOd8gJ1hQV6qOqujavqPpmYsNVv7n1xKPI7pQ
        Z4A8dcuVfNnILDBTpUvYFPgWw2BXdZTlYc08ED8=
X-Google-Smtp-Source: AK7set9oS76k9svUFe+eke+TsFLnCtgS7rVlk7+J+UnTJn6z96isbnAqUe9/xeru4Xs1fF1SIhXay10zU5Msqqc+Pug=
X-Received: by 2002:a25:fb0e:0:b0:ad0:a82:7ef2 with SMTP id
 j14-20020a25fb0e000000b00ad00a827ef2mr914209ybe.8.1677731331815; Wed, 01 Mar
 2023 20:28:51 -0800 (PST)
MIME-Version: 1.0
References: <20230301154953.641654-1-joannelkoong@gmail.com>
 <20230301154953.641654-11-joannelkoong@gmail.com> <CAADnVQJCYcPnutRvjJgShAEokfrXfC4DToPOTJRuyzA1R64mBg@mail.gmail.com>
In-Reply-To: <CAADnVQJCYcPnutRvjJgShAEokfrXfC4DToPOTJRuyzA1R64mBg@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Wed, 1 Mar 2023 20:28:40 -0800
Message-ID: <CAJnrk1YNMoTEaWA6=wDS3iV4sV0A-5Afnn+p50hEvX8jR6GLHw@mail.gmail.com>
Subject: Re: [PATCH v13 bpf-next 10/10] selftests/bpf: tests for using dynptrs
 to parse skb and xdp buffers
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 1, 2023 at 10:08=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Mar 1, 2023 at 7:51=E2=80=AFAM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
> >
> > 5) progs/dynptr_success.c
> >    * Add test case "test_skb_readonly" for testing attempts at writes
> >      on a prog type with read-only skb ctx.
> >    * Add "test_dynptr_skb_data" for testing that bpf_dynptr_data isn't
> >      supported for skb progs.
>
> I added
> +dynptr/test_dynptr_skb_data
> +dynptr/test_skb_readonly
> to DENYLIST.s390x and applied.

Thanks, I'm still not sure why s390x cannot load these programs. It is
being loaded in the same way as other tests like
test_parse_tcp_hdr_opt() are loading programs. I will keep looking
some more into this

>
> Thank you so much for all the hard work to make it happen.
> Great milestone!

Thank you to you, Andrii, Martin, Kumar, Jakub, and Toke (and kernel
test robot :P) for all your reviews and feedback on this patchset! It
was all extremely helpful
