Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D268F6835FD
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 20:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbjAaTCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 14:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbjAaTCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 14:02:30 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E01559751
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 11:02:09 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id g9so10935295pfo.5
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 11:02:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iSlbitpVXsAiKWUKOS8hJcan2Um7j/V24BYCeu085pQ=;
        b=fdvPWwMKP2aLjGaQ8NVXQsaovrWw5foZPtc/QP3r0wy9C/u06t1dfcKtwtMmDD5F12
         FZtTLNPDw3In1StcXGAVJ/mdFvbA5qNHADV86MCamiZ2ZXKKoSnJojUGhMsTROxc8Glx
         h/jH0cBg1T8J/4agw+jc7V2tSXMa4jlHuI0aqLB9xLcIg/DW+447kH2fy6uA69JJj0pq
         3C8evbw5mt/b6SWNqaHToBxE1pxuL5ABD9QJCyQmMeOCjaOJUt9SryikrP80SnjoHrVI
         0m8djGD8QPjdeDR7Q1jOFvpKMkqm9ls/AgKR0zufuSnHKzp8/HfJ+WiARA1P+nCdBP+c
         4mqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iSlbitpVXsAiKWUKOS8hJcan2Um7j/V24BYCeu085pQ=;
        b=uQ6MEHv4Di6suICpk4FZ4PXz1I3mwQ1AyOk1x4I4jEwjsb9D6GxmcrtUdXN+r4QGWW
         ywK6QbOlME6/FygCj7bp+ibjtOAi1jSepbbIW9I/ceZa/9eotPXOx33LcN2PY2IegERH
         umt3Fu42FU84t9TSkB9qPOQOr/YqWLW56RFQVo/QixNkTE1DFcrUVl/2/IDcHwJslp5e
         ftOUODEgoOG5SFe198VxBuE/4dIg3VL7N8nsWwdvs20ZUs/AX8BB8nuxMrJZ7jQPvp8y
         N0FnWSbhLqgrF7LYcJfm2+cSrN7klkkGWHmUAovQrwrvZp9OKRpUs/UvWp8ufzp9scpr
         kUSA==
X-Gm-Message-State: AFqh2koUmkJ/p9uJCGsOMnS3yhKVQ2DFo+IYSAJm/TZibD5CDmzmAruq
        BIitD71v6Tf7sw668iAiJNnQ3sI++fYfkF+zEgZc7Q==
X-Google-Smtp-Source: AMrXdXsQiX/y+zxoMR4fjq09QC3yLQ82xRlHwgrrx86+hvYct8MxPYHtPo6KhXYHINBUEQsWoCXJoGqyQKakDT8vxoI=
X-Received: by 2002:a63:946:0:b0:4cf:7ba0:dd5a with SMTP id
 67-20020a630946000000b004cf7ba0dd5amr6008626pgj.119.1675191728977; Tue, 31
 Jan 2023 11:02:08 -0800 (PST)
MIME-Version: 1.0
References: <167482734243.892262.18210955230092032606.stgit@firesoul>
 <87cz70krjv.fsf@toke.dk> <CAKH8qBtc0TRorF2zsD0dZjgredpzcmczK=KMgt1mpEX_mQG2Kg@mail.gmail.com>
 <839c6cbb-1572-b3a8-57eb-2aa2488101dd@redhat.com>
In-Reply-To: <839c6cbb-1572-b3a8-57eb-2aa2488101dd@redhat.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 31 Jan 2023 11:01:57 -0800
Message-ID: <CAKH8qBtcDqru=_g1h17ogu26FTwRLOgyyNTO-5PY2Ur2o7vhXw@mail.gmail.com>
Subject: Re: [xdp-hints] [PATCH bpf-next RFC V1] selftests/bpf:
 xdp_hw_metadata clear metadata when -EOPNOTSUPP
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, dsahern@gmail.com,
        willemb@google.com, void@manifault.com, kuba@kernel.org,
        xdp-hints@xdp-project.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 5:00 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
>
> On 27/01/2023 18.18, Stanislav Fomichev wrote:
> > On Fri, Jan 27, 2023 at 5:58 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Jesper Dangaard Brouer <brouer@redhat.com> writes:
> >>
> >>> The AF_XDP userspace part of xdp_hw_metadata see non-zero as a signal=
 of
> >>> the availability of rx_timestamp and rx_hash in data_meta area. The
> >>> kernel-side BPF-prog code doesn't initialize these members when kerne=
l
> >>> returns an error e.g. -EOPNOTSUPP.  This memory area is not guarantee=
d to
> >>> be zeroed, and can contain garbage/previous values, which will be rea=
d
> >>> and interpreted by AF_XDP userspace side.
> >>>
> >>> Tested this on different drivers. The experiences are that for most
> >>> packets they will have zeroed this data_meta area, but occasionally i=
t
> >>> will contain garbage data.
> >>>
> >>> Example of failure tested on ixgbe:
> >>>   poll: 1 (0)
> >>>   xsk_ring_cons__peek: 1
> >>>   0x18ec788: rx_desc[0]->addr=3D100000000008000 addr=3D8100 comp_addr=
=3D8000
> >>>   rx_hash: 3697961069
> >>>   rx_timestamp:  9024981991734834796 (sec:9024981991.7348)
> >>>   0x18ec788: complete idx=3D8 addr=3D8000
> >>>
> >>> Converting to date:
> >>>   date -d @9024981991
> >>>   2255-12-28T20:26:31 CET
> >>>
> >>> I choose a simple fix in this patch. When kfunc fails or isn't suppor=
ted
> >>> assign zero to the corresponding struct meta value.
> >>>
> >>> It's up to the individual BPF-programmer to do something smarter e.g.
> >>> that fits their use-case, like getting a software timestamp and marki=
ng
> >>> a flag that gives the type of timestamp.
> >>>
> >>> Another possibility is for the behavior of kfunc's
> >>> bpf_xdp_metadata_rx_timestamp and bpf_xdp_metadata_rx_hash to require
> >>> clearing return value pointer.
> >>
> >> I definitely think we should leave it up to the BPF programmer to reac=
t
> >> to failures; that's what the return code is there for, after all :)
> >
> > +1
>
> +1 I agree.
> We should keep this default functions as simple as possible, for future
> "unroll" of BPF-bytecode.
>
> I the -EOPNOTSUPP case (default functions for drivers not implementing
> kfunc), will likely be used runtime by BPF-prog to determine if the
> hardware have this offload hint, but it comes with the overhead of a
> function pointer call.
>
> I hope we can somehow BPF-bytecode "unroll" these (default functions) at
> BPF-load time, to remove this overhead, and perhaps even let BPF
> bytecode do const propagation and code elimination?
>
>
> > Maybe we can unconditionally memset(meta, sizeof(*meta), 0) in
> > tools/testing/selftests/bpf/progs/xdp_hw_metadata.c?
> > Since it's not a performance tool, it should be ok functionality-wise.
>
> I know this isn't a performance test, but IMHO always memsetting
> metadata area is a misleading example.  We know from experience that
> developer simply copy-paste code examples, even quick-n-dirty testing
> example code.
>
> The specific issue in this example can lead to hard-to-find bugs, as my
> testing shows it is only occasionally that data_meta area contains
> garbage. We could do a memset, but it deserves a large code comment, why
> this is needed, so people copy-pasting understand. I choose current
> approach to keep code close to code people will copy-paste.

SG, I don't think it matters, but agreed that having this stated
explicitly could help with a blind copy-paste :-)
Then maybe repost with the TODO's removed from the kfucs? We seem to
agree that it's the user's job to manage the final buffer..

> --Jesper
>
