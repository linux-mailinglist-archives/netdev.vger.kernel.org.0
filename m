Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A2D62EA01
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234966AbiKRADs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235086AbiKRADT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:03:19 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4F285EED;
        Thu, 17 Nov 2022 16:03:07 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id e13so4917277edj.7;
        Thu, 17 Nov 2022 16:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CC+7vBXHGdFVqaUi/5ScLBYfTiVfdcPIJ8NhD12IG5g=;
        b=QmL2QNUk8kIxg7DMWGsCbWdosmwbUPz6SinIwC3OQm3U82iJfzqBJIU1cKXdakmjth
         jJAHdiIH3Zhmq/DIbOSJlRuVGxjMjWgKFc6rM64SexwSCf0GEQafRNF1Jz47oStxfxg2
         X44dxI2Rtqmy672JQY5XJdszrmXI1VXqRGwGDewVYRerLfhMKujlBi/pbkzyBAUhm2r0
         VV7n5D0efO4MTudqg79kjA5pVbizZ3yIbCUBrcApHSJJTS8wyoRgiPI+cm27Gg/AZGiC
         dNgjaedB0/qVC3Dq1tkhke4REbdKS+/9HrNQPLe0DnVecpn+wR/6lYxcVB/b+ApmxzuU
         DCdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CC+7vBXHGdFVqaUi/5ScLBYfTiVfdcPIJ8NhD12IG5g=;
        b=DpUUd8OnVtidUZ7SbHmLevtEFRlEjqLVaYUNY8pczzQWkJ1wngsDGXlodDz/KNhn1X
         2vOHInLyz+gn2NmyxmhuKHmuKyKD4sdWxEQqkjDaXK9Xi85qplHRM2Sct0qErXkY0swK
         vYCfph+gfJXIU5COYcmOG0wBqkF8n/QuFEUd/6oF0y/6cse/NIdSd2GFXR9iXWe4fsLW
         qGKISx47e7iqm1sNK7if2z6oh7wWl/kogyyzz9Yx6G9Dt+gmYqqfsuDQd1eygnwuc2r7
         idHsPEwX6wbb9dqd4kUhhtfj+MRwlhRGgIG5JLtqtv7jCl+NM9srp3VC0UEcy0yr3oPX
         tKEw==
X-Gm-Message-State: ANoB5pmYqg9qq+wdTEEER3zynvdGLdTkTHCpTn4Y6vopWsfEU1YuLQ2V
        5nYX5eV6IYQ2BWHaGH1JQPhPjM/2zGe9Y1bhdU8=
X-Google-Smtp-Source: AA0mqf5+LxZoZnW3rPh8xbGePYov+M/+njRFrT0KT6r6c2LbpWRvPv4hlOScP8HWjeef8y10CAQKKKE4UoNrZrGtQ3A=
X-Received: by 2002:a05:6402:389:b0:459:2515:b27b with SMTP id
 o9-20020a056402038900b004592515b27bmr4156991edv.338.1668729786295; Thu, 17
 Nov 2022 16:03:06 -0800 (PST)
MIME-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com> <20221115030210.3159213-6-sdf@google.com>
 <87h6z0i449.fsf@toke.dk> <CAKH8qBsEGD3L0XAVzVHcTW6k_RhEt74pfXrPLANuznSAJw7bEg@mail.gmail.com>
 <8735ajet05.fsf@toke.dk> <CAKH8qBsg4aoFuiajuXmRN3VPKYVJZ-Z5wGzBy9pH3pV5RKCDzQ@mail.gmail.com>
 <6374854883b22_5d64b208e3@john.notmuch> <34f89a95-a79e-751c-fdd2-93889420bf96@linux.dev>
 <878rkbjjnp.fsf@toke.dk> <6375340a6c284_66f16208aa@john.notmuch>
 <CAKH8qBs1rYXf0GGto9hPz-ELLZ9c692cFnKC9JLwAq5b7JRK-A@mail.gmail.com>
 <637576962dada_8cd03208b0@john.notmuch> <CAKH8qBtOATGBMPkgdE0jZ+76AWMsUWau360u562bB=cGYq+gdQ@mail.gmail.com>
 <CAADnVQKTXuBvP_2O6coswXL7MSvqVo1d+qXLabeOikcbcbAKPQ@mail.gmail.com>
 <CAKH8qBvTdnyRYT+ocNS_ZmOfoN+nBEJ5jcBcKcqZ1hx0a5WrSw@mail.gmail.com>
 <87wn7t4y0g.fsf@toke.dk> <CAADnVQJMvPjXCtKNH+WCryPmukgbWTrJyHqxrnO=2YraZEukPg@mail.gmail.com>
 <CAKH8qBsPinmCO0Ny1hva7kp4+C7XFdxZLPBYEHXQWDjJ5SSoYw@mail.gmail.com> <874juxywih.fsf@toke.dk>
In-Reply-To: <874juxywih.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 17 Nov 2022 16:02:54 -0800
Message-ID: <CAADnVQJ=MbwUOTtmYb_VmTEBA8SdYXJryfGoYv2W2US3_Es=kA@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next 05/11] veth: Support rx timestamp
 metadata for xdp
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>, David Ahern <dsahern@gmail.com>,
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

On Thu, Nov 17, 2022 at 3:46 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> >
> > Ack. I can replace the unrolling with something that just resolves
> > "generic" kfuncs to the per-driver implementation maybe? That would at
> > least avoid netdev->ndo_kfunc_xxx indirect calls at runtime..
>
> As stated above, I think we should keep the unrolling. If we end up with
> an actual CALL instruction for every piece of metadata that's going to
> suck performance-wise; unrolling is how we keep this fast enough! :)

Let's start with pure kfuncs without requiring drivers
to provide corresponding bpf asm.
If pure kfuncs will indeed turn out to be perf limiting
then we'll decide on how to optimize them.
