Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309DE5F4D9F
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 04:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiJECPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 22:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiJECPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 22:15:40 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A873E474C7
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 19:15:35 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id g13so4993468ile.0
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 19:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=bF3rfNlwAuWQX7FF97PUYgRoxYjQCp+FQ9YtbL3rEM8=;
        b=f2Sydn540oSzJJmHHZb4OXECOqRdiYpOcytDuEJI99EvyNB/U4JiHK1EREcNiLDI4K
         ALqouMshmN6HqclSyyXUqDwwEvaYQKz1K/5FVU+rlWhk8F01j9nHyO99IQRSfwEqo0gl
         RlnDxh4l4iedse7nJKLVkoXD3qhY8kp6ueil/iio1d54ckUjsV2plqwr4bw0rdrN5e+X
         r0RkvHsuCS1RCcF+wRju/9ghvzd9HqYPJ5fqzJlCOLAZRKLuWQn6hlKJ5llvmcxA/EmT
         jb2c2hTou9LXZSdJQLZb59FkfpzA9P96d4H8WhmhUwC7Baw1D/s3FmDigKver6k3HDri
         88UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=bF3rfNlwAuWQX7FF97PUYgRoxYjQCp+FQ9YtbL3rEM8=;
        b=VZ737GZzFvd+76c1M7dhoEAZfcOileafGtcyl0Gksqxmwgjvc9NnQnEVNNzP9JgIUI
         jF5Pnu8vTE1X/ujN651ok0yzt25QDYdHkboGA+shsX/m8C/EnJy63tNAzK9SAD3cvCNS
         m+6eEnitstkirPL5dXEaGWqT1bgQt5QVL91rkymMcq+VPkZgGXbaU3dZVL2L4GA1bmuQ
         gkTs7wB+8tve1hL6KGFBjmsrsZhYPS2KGc37OUXeVNRENkZQxWx0WW9ZXjpQXrm0j8TM
         gCmP2D4doaH9XYDjqaNqcKh+H+6ROz8Q26lppMV8DxyLr2ROAxbb+r9W0ctSk3/kMcTY
         0fag==
X-Gm-Message-State: ACrzQf1wEpHGF86Nu7fkNkHc6o7WYFQi1M71vkMuyV8rqJKlmuKpIAv3
        mJMwDHnNFRd6j04u6n4CQYtmimFPKxS7mrlxAdDJqA==
X-Google-Smtp-Source: AMsMyM58qwYn1L3swp5KOVyV1TYqz3USmDJ53no2y3Fo2AXus4qnffPbPjgbAJeyRQxcgM6T6ud2uPcXjosICMHQp+A=
X-Received: by 2002:a92:ca0c:0:b0:2f9:204:7a0d with SMTP id
 j12-20020a92ca0c000000b002f902047a0dmr13639413ils.194.1664936135004; Tue, 04
 Oct 2022 19:15:35 -0700 (PDT)
MIME-Version: 1.0
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <Yzt2YhbCBe8fYHWQ@google.com> <35fcfb25-583a-e923-6eee-e8bbcc19db17@redhat.com>
 <CAKH8qBuYVk7QwVOSYrhMNnaKFKGd7M9bopDyNp6-SnN6hSeTDQ@mail.gmail.com>
 <5ccff6fa-0d50-c436-b891-ab797fe7e3c4@linux.dev> <20221004175952.6e4aade7@kernel.org>
 <CAKH8qBtdAeHqbWa33yO-MMgC2+h2qehFn8Y_C6ZC1=YsjQS-Bw@mail.gmail.com> <20221004182451.6804b8ca@kernel.org>
In-Reply-To: <20221004182451.6804b8ca@kernel.org>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 4 Oct 2022 19:15:24 -0700
Message-ID: <CAKH8qBtTPNULZDLd2n1r2o7XZwvs_q5OkNqhdq0A+b5zkHRNMw@mail.gmail.com>
Subject: Re: [PATCH RFCv2 bpf-next 00/18] XDP-hints: XDP gaining access to HW
 offload hints via BTF
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Oct 4, 2022 at 6:24 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 4 Oct 2022 18:02:56 -0700 Stanislav Fomichev wrote:
> > +1, sounds like a good alternative (got your reply while typing)
> > I'm not too versed in the rx_desc/rx_queue area, but seems like worst
> > case that bpf_xdp_get_hwtstamp can probably receive a xdp_md ctx and
> > parse it out from the pre-populated metadata?
>
> I'd think so, worst case the driver can put xdp_md into a struct
> and container_of() to get to its own stack with whatever fields
> it needs.

Ack, seems like something worth exploring then.

The only issue I see with that is that we'd probably have to extend
the loading api to pass target xdp device so we can pre-generate
per-device bytecode for those kfuncs? And this potentially will block
attaching the same program to different drivers/devices?
Or, Martin, did you maybe have something better in mind?

> > Btw, do we also need to think about the redirect case? What happens
> > when I redirect one frame from a device A with one metadata format to
> > a device B with another?
>
> If there is a program on Tx then it'd be trivial - just do the
> info <-> descriptor translation in the opposite direction than Rx.
> TBH I'm not sure how it'd be done in the current approach, either.

Yeah, I don't think it magically works in any case. I'm just trying to
understand whether it's something we care to support out of the box or
can punt to the bpf programs themselves and say "if you care about
forwarding metadata, somehow agree on the format yourself".

> Now I questioned the BTF way and mentioned the Tx-side program in
> a single thread, I better stop talking...

Forget about btf, hail to the new king - kfunc :-D
