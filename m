Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF955AC6A4
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 23:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbiIDVZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 17:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiIDVZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 17:25:19 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD9D17065;
        Sun,  4 Sep 2022 14:25:18 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id d68so5612886iof.11;
        Sun, 04 Sep 2022 14:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=BSMZBY4/3gH7uO1/BILGDymt4kytX9ztv6JihbwwrbU=;
        b=dxP/2nWK1NX47iTiZlG5S68hPW5rM+GiQTpT4CPZNYiCBNIUcnLkmwQbQJZ6lUoo4W
         uR5AbxWVo/oUsip9PcKY2Of/kox2lH+iv/H+oVv2pfBWQ7IaxVY6ICVAG9gUSovGrOGc
         m3zp2HGsxVQ1lSohUsNVdY3/c2b48jO0S5ATtQQZOvVglAGsvljrIWhb5HdjWlFlc/Ya
         g6gA1u3o2iYeXmV1+XNbLtoSHtBQ8+TAO829CSWFGd7UJHA4TBVZg1lDiYqee+WdsVDa
         WoicIzCZNT8lc7zZa5KbDcizjwAO/oF/VRj7yCY8RxOFPjcIb3BhpT2b1SUqHCKQixkA
         Oxzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=BSMZBY4/3gH7uO1/BILGDymt4kytX9ztv6JihbwwrbU=;
        b=2AY7vF/dqiXSPCJwUNUR0Z+iXhMI4OkG740CTRBlIq8DP7Sm1fgl1yQkHb9nY3LUfw
         lgYjSmpwPz4YNjhjsJju5LljWLhxd+D/aiMxVus0D292AwDxQzqS2IvS7ImKrS1n5iyz
         ZPwCX+Iuyk+5XkvF1LrqvFK+SbXIRVaZ/H2aeLPqEVLKLK4lYOU2eMcGRMFIw9s7Vzg2
         BFlEGiSUIaxuiCAwZCXfgtTmFhQY4jpprr1MFygu0dOgcw4vpe6BBbalRqZRVlldrY/q
         /ayBk2ag6zbvOCCdg132hueH5ZjCMK/q3uhT2ia3NelScU3tzyYQNpfc1OwoEfZGSG01
         Vx8Q==
X-Gm-Message-State: ACgBeo3tGMcg76awBA9pAQLJzgZ8Oj7+G9SvKWiX80+5LcwlK1GPdYxj
        uhNiBCI+8h3utbpyyXfDrtXVZBBfgYU4RJOchO8=
X-Google-Smtp-Source: AA6agR42p5IFUBgpmnU7SBtykqwXLgbpkP8KoUtCZS7Qv+J/zdgQwHlJyEAD55USwwdWirweduYdbpBzlxiEuL5Y4LQ=
X-Received: by 2002:a05:6638:3802:b0:351:d8a5:6d58 with SMTP id
 i2-20020a056638380200b00351d8a56d58mr2390336jav.206.1662326717854; Sun, 04
 Sep 2022 14:25:17 -0700 (PDT)
MIME-Version: 1.0
References: <CABG=zsBEh-P4NXk23eBJw7eajB5YJeRS7oPXnTAzs=yob4EMoQ@mail.gmail.com>
 <20220831230157.7lchomcdxmvq3qqw@kafai-mbp.dhcp.thefacebook.com> <CABG=zsCQBVga6Tjcc-Y1x0U=0xAjYHH_j8ncFJPOG2XvxSP2UQ@mail.gmail.com>
In-Reply-To: <CABG=zsCQBVga6Tjcc-Y1x0U=0xAjYHH_j8ncFJPOG2XvxSP2UQ@mail.gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Sun, 4 Sep 2022 23:24:41 +0200
Message-ID: <CAP01T76ry6etJ2Zi02a2+ZtGJxrc=rky5gMqFE7on_fuOe8A8A@mail.gmail.com>
Subject: Re: [RFC] Socket termination for policy enforcement and load-balancing
To:     Aditi Ghag <aditivghag@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
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

On Sun, 4 Sept 2022 at 20:55, Aditi Ghag <aditivghag@gmail.com> wrote:
>
> On Wed, Aug 31, 2022 at 4:02 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Wed, Aug 31, 2022 at 09:37:41AM -0700, Aditi Ghag wrote:
> > > - Use BPF (sockets) iterator to identify sockets connected to a
> > > deleted backend. The BPF (sockets) iterator is network namespace aware
> > > so we'll either need to enter every possible container network
> > > namespace to identify the affected connections, or adapt the iterator
> > > to be without netns checks [3]. This was discussed with my colleague
> > > Daniel Borkmann based on the feedback he shared from the LSFMMBPF
> > > conference discussions.
> > Being able to iterate all sockets across different netns will
> > be useful.
> >
> > It should be doable to ignore the netns check.  For udp, a quick
> > thought is to have another iter target. eg. "udp_all_netns".
> > From the sk, the bpf prog should be able to learn the netns and
> > the bpf prog can filter the netns by itself.
> >
> > The TCP side is going to have an 'optional' per netns ehash table [0] soon,
> > not lhash2 (listening hash) though.  Ideally, the same bpf
> > all-netns iter interface should work similarly for both udp and
> > tcp case.  Thus, both should be considered and work at the same time.
> >
> > For udp, something more useful than plain udp_abort() could potentially
> > be done.  eg. directly connect to another backend (by bpf kfunc?).
> > There may be some details in socket locking...etc but should
> > be doable and the bpf-iter program could be sleepable also.
>
> This won't be effective for connected udp though, will it? Interesting thought
> around using bpf kfunc!
>
> > fwiw, we are iterating the tcp socket to retire some older
> > bpf-tcp-cc (congestion control) on the long-lived connections
> > by bpf_setsockopt(TCP_CONGESTION).
> >
> > Also, potentially, instead of iterating all,
> > a more selective case can be done by
> > bpf_prog_test_run()+bpf_sk_lookup_*()+udp_abort().
>
> Can you elaborate more on the more selective iterator approach?
>
> On a similar note, are there better ways as alternatives to the
> sockets iterator approach.
> Since we have BPF programs executed on cgroup BPF hooks (e.g.,
> connect), we already know what client
> sockets are connected to a backend. Can we somehow store these socket
> pointers in a regular BPF map, and
> when a backend is deleted, use a regular map iterator to invoke
> sock_destroy() for these sockets? Does anyone have
> experience using the "typed pointer support in BPF maps" APIs [0]?

I am not very familiar with how socket lifetime is managed, it may not
be possible in case lifetime is managed by RCU only,
or due to other limitations.
Martin will probably be able to comment more on that.

Apart from that, from the BPF side, it referenced kptr won't work out
of the box, you will need to add support for each type you want to
support.

But the way you're describing should work well. Ideally you would inc
a ref and move it into map from the hook program, and just xchg out
the sk to destroy from map value during iteration and then pass it to
sock_destroy helper to release it (instead of sk_release).

First task for this will be teaching kptr_xchg to work with
non-PTR_TO_BTF_ID arguments. You can use the same process as how
translation is done to in-kernel PTR_TO_BTF_ID by reg2btf_ids in
kernel/bpf/btf.c for socket types for kfuncs.
Usually socket types will be PTR_TO_SOCKET or PTR_TO_TCP_SOCK etc,
they can be mapped using that table to the btf_id of in-kernel type
they shadow.

From there, it will be about writing the right dtor for the socket
type which can work in all contexts the dtor for the socket is called
from map implementations, and registering it, and probably also
restricting the kptr_xchg for socket to certain known contexts to make
life easier.

>
> [0] https://lwn.net/ml/bpf/20220424214901.2743946-1-memxor@gmail.com/
