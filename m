Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9AB6647A7C
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiLIAH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:07:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLIAHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:07:54 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC6422535;
        Thu,  8 Dec 2022 16:07:53 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id n21so7797339ejb.9;
        Thu, 08 Dec 2022 16:07:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z1CwUhBKmLcc3xJp3He22HceM+mQGWDmDbOf77l5NqM=;
        b=gxJbp+K+xSIY2Tw7y11kyN08+NF9vOjJGyOJz/OzimhKI+CYgouud592Mm0a3Z1aM6
         +6i6BISH02DtViIB1QnVegxqZPIZvi640JecDglTb6WUp3OpBbGemk8ufEoHC0g9VnnO
         GcM1DkDyyN40ZQ0UWvPusB1dKEh2a0u5w5Dil3VcXeRpbfz73eQRvl8+dmHCI7YsiYjP
         ACK2zDeuIosWoDIIy8SlS6J3xvZ+grUvhfABUXskgtVt8ks+LPaLUy2ITv3iqahOPtjc
         TeokU3Q3tq4j0BBAQaGI9wqf+UAzc5/3i2MI+XzoaeVgAkw5Ygr719TviaW4ubzB9zeG
         72IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z1CwUhBKmLcc3xJp3He22HceM+mQGWDmDbOf77l5NqM=;
        b=58r2LvnAADeBLN0mRHpwdcdnAE5ICRuV/WPT7K1BDCHWXDg0J83oSWYAMP1A/wpyr6
         P/7s4HdVpUIOpgppe9c+XnDq2vsE/AQu6E+xcpZhsvfM9sJmkfLar/mDObVzl2H5o1ME
         2ujte85HQ3VRXGNrh74OPw0CJ5IcXsUHQa6L/GIaka3rTEe4SFdbMOSbF+0imoZVKWPY
         lhcIYXIgTdx1fJsHuX3lrrqUlzgrM8LLnmtvPCAzAw9dcHY2nINnCq8gpxY3Webyezsk
         4t3R3hRNzSDAnhf8CXjjygh0217Tfxg2mKMyG1f1ZykqYUYR/YloYPLM9T9ltxfO3XhG
         1bKw==
X-Gm-Message-State: ANoB5pkH3NLrxLVn3reAr0j7jN4Xy4l5Eh1cA+8Ip4rxeeeTAfyaIlBf
        JS8yjeVvJeF6KL8LinsHlNJZveoebnk8g09XzA8=
X-Google-Smtp-Source: AA0mqf5MBoRl5V/v1iYdBNTpKJISTGcSH8pQUcix3SxBfo+HxXBJiIUnBX1QhChef6NXc79hZt3TSPH2rCTGnvxh3Ro=
X-Received: by 2002:a17:907:76cb:b0:7c0:870b:3dda with SMTP id
 kf11-20020a17090776cb00b007c0870b3ddamr35410213ejc.676.1670544471573; Thu, 08
 Dec 2022 16:07:51 -0800 (PST)
MIME-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com> <20221206024554.3826186-12-sdf@google.com>
 <875yellcx6.fsf@toke.dk> <CAKH8qBv7nWdknuf3ap_ekpAhMgvtmoJhZ3-HRuL8Wv70SBWMSQ@mail.gmail.com>
 <87359pl9zy.fsf@toke.dk>
In-Reply-To: <87359pl9zy.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 8 Dec 2022 16:07:39 -0800
Message-ID: <CAADnVQ+=71Y+ypQTOgFTJWY7w3YOUdY39is4vpo3aou11=eMmw@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v3 11/12] mlx5: Support RX XDP metadata
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Stanislav Fomichev <sdf@google.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        Network Development <netdev@vger.kernel.org>
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

On Thu, Dec 8, 2022 at 4:02 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> writes:
>
> > On Thu, Dec 8, 2022 at 2:59 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
> >>
> >> Stanislav Fomichev <sdf@google.com> writes:
> >>
> >> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> >
> >> > Support RX hash and timestamp metadata kfuncs. We need to pass in th=
e cqe
> >> > pointer to the mlx5e_skb_from* functions so it can be retrieved from=
 the
> >> > XDP ctx to do this.
> >>
> >> So I finally managed to get enough ducks in row to actually benchmark
> >> this. With the caveat that I suddenly can't get the timestamp support =
to
> >> work (it was working in an earlier version, but now
> >> timestamp_supported() just returns false). I'm not sure if this is an
> >> issue with the enablement patch, or if I just haven't gotten the
> >> hardware configured properly. I'll investigate some more, but figured
> >> I'd post these results now:
> >>
> >> Baseline XDP_DROP:         25,678,262 pps / 38.94 ns/pkt
> >> XDP_DROP + read metadata:  23,924,109 pps / 41.80 ns/pkt
> >> Overhead:                   1,754,153 pps /  2.86 ns/pkt
> >>
> >> As per the above, this is with calling three kfuncs/pkt
> >> (metadata_supported(), rx_hash_supported() and rx_hash()). So that's
> >> ~0.95 ns per function call, which is a bit less, but not far off from
> >> the ~1.2 ns that I'm used to. The tests where I accidentally called th=
e
> >> default kfuncs cut off ~1.3 ns for one less kfunc call, so it's
> >> definitely in that ballpark.
> >>
> >> I'm not doing anything with the data, just reading it into an on-stack
> >> buffer, so this is the smallest possible delta from just getting the
> >> data out of the driver. I did confirm that the call instructions are
> >> still in the BPF program bytecode when it's dumped back out from the
> >> kernel.
> >>
> >> -Toke
> >>
> >
> > Oh, that's great, thanks for running the numbers! Will definitely
> > reference them in v4!
> > Presumably, we should be able to at least unroll most of the
> > _supported callbacks if we want, they should be relatively easy; but
> > the numbers look fine as is?
>
> Well, this is for one (and a half) piece of metadata. If we extrapolate
> it adds up quickly. Say we add csum and vlan tags, say, and maybe
> another callback to get the type of hash (l3/l4). Those would probably
> be relevant for most packets in a fairly common setup. Extrapolating
> from the ~1 ns/call figure, that's 8 ns/pkt, which is 20% of the
> baseline of 39 ns.
>
> So in that sense I still think unrolling makes sense. At least for the
> _supported() calls, as eating a whole function call just for that is
> probably a bit much (which I think was also Jakub's point in a sibling
> thread somewhere).

imo the overhead is tiny enough that we can wait until
generic 'kfunc inlining' infra is ready.

We're planning to dual-compile some_kernel_file.c
into native arch and into bpf arch.
Then the verifier will automatically inline bpf asm
of corresponding kfunc.
