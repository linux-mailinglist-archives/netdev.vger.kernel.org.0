Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFAB5F635F
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 11:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbiJFJPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 05:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbiJFJPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 05:15:04 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A6216591;
        Thu,  6 Oct 2022 02:15:03 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id l1so1139303pld.13;
        Thu, 06 Oct 2022 02:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v5p60joemBNwmRSG3Q1r6EW52GlBbR302YqVKam2nZs=;
        b=Pzz+uIBEGjFrnQm52eyWZvE3hOnDKn6oG8bYooEK6NK6tJw2+BwkhU+sNdKny/xHST
         orfhkvO3NgtyiLDq5rfqT4d0BcZou/lJGEztDHJC4egdgn4+O5xdEb+xRzdxnoCQ87wO
         XIpF+KKWtTmpvTLEBLBz4D7OyfxFBAqlnig9bZ+2CzAwUvvMzkrAYPtk0/X+7MI4fMbv
         +xhATh59lOQtLudRDw4ugrNH1jQg6DF/e+b94j5wQTYX5PFGrzUiux8FdszDtCmW0mil
         SAF32n8YSkXE30nIvS2t/1IQ0L0JLR0zFQO8dFl0sHHQ06jvmghUX3yLndW6lc5Hc2Lr
         xuUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v5p60joemBNwmRSG3Q1r6EW52GlBbR302YqVKam2nZs=;
        b=GmcrqYi2W0CjrzBWEsPZJcZYii961cHnInUhlTds7E8NOFapBtfXLB3F763boZ+1xT
         2YVAmiYXU7QTsXzPYnIXHre3q5NiqBDgggHmOcleYMLnhKQ5vsdSfyHtfVHFF0JZJcym
         ptjSjMaL721SsXIYU/nfsjSJovAsbg5JWL4nt2pMB91Ucz4UT34Q5KijAE29F7oNa+CM
         ZPCyCJ+l6NRXKK7rxj9WmM2P1yEnb2+UOzCNu4K9YJcTuhlVpXWMPYwm/K7tJWHvk3uw
         NRhV98pVMHeXmtP+zPoBz+rNanB0W2SSJ+QoP1hNtyFVrVonYx25Uh3uguLaTtloFg2k
         r1fw==
X-Gm-Message-State: ACrzQf278bmrSAvGrCIYyMV/HidHE8AJkyAr2vUHGn+K8WEmO8OjU0dN
        HpfT2q+USU6MM7W/SvwQZ5QodFFGRbDtTc0biKg=
X-Google-Smtp-Source: AMsMyM7nQGi+O4jfqUexx3Jaxsz1NtFMmIAQmXrZ6rHAQbLDMuS7oGtZrFKN7eOLNlxAOUX0Ng30w0xQEIa7eKVSphM=
X-Received: by 2002:a17:902:aa8b:b0:178:8f1d:6936 with SMTP id
 d11-20020a170902aa8b00b001788f1d6936mr3884386plr.168.1665047703161; Thu, 06
 Oct 2022 02:15:03 -0700 (PDT)
MIME-Version: 1.0
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <Yzt2YhbCBe8fYHWQ@google.com> <35fcfb25-583a-e923-6eee-e8bbcc19db17@redhat.com>
 <CAKH8qBuYVk7QwVOSYrhMNnaKFKGd7M9bopDyNp6-SnN6hSeTDQ@mail.gmail.com>
 <5ccff6fa-0d50-c436-b891-ab797fe7e3c4@linux.dev> <20221004175952.6e4aade7@kernel.org>
 <CAKH8qBtdAeHqbWa33yO-MMgC2+h2qehFn8Y_C6ZC1=YsjQS-Bw@mail.gmail.com>
 <20221004182451.6804b8ca@kernel.org> <CAKH8qBtTPNULZDLd2n1r2o7XZwvs_q5OkNqhdq0A+b5zkHRNMw@mail.gmail.com>
 <e29082a8-bbd5-6ee3-34bf-c16d0f6ed45a@linux.dev>
In-Reply-To: <e29082a8-bbd5-6ee3-34bf-c16d0f6ed45a@linux.dev>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 6 Oct 2022 11:14:52 +0200
Message-ID: <CAJ8uoz2ng=wv=dWQqxomQX4h11QsYq=scU++MSJ3Q0PMQWuzWQ@mail.gmail.com>
Subject: Re: [PATCH RFCv2 bpf-next 00/18] XDP-hints: XDP gaining access to HW
 offload hints via BTF
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 5, 2022 at 9:27 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 10/4/22 7:15 PM, Stanislav Fomichev wrote:
> > On Tue, Oct 4, 2022 at 6:24 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >>
> >> On Tue, 4 Oct 2022 18:02:56 -0700 Stanislav Fomichev wrote:
> >>> +1, sounds like a good alternative (got your reply while typing)
> >>> I'm not too versed in the rx_desc/rx_queue area, but seems like worst
> >>> case that bpf_xdp_get_hwtstamp can probably receive a xdp_md ctx and
> >>> parse it out from the pre-populated metadata?
> >>
> >> I'd think so, worst case the driver can put xdp_md into a struct
> >> and container_of() to get to its own stack with whatever fields
> >> it needs.
> >
> > Ack, seems like something worth exploring then.
> >
> > The only issue I see with that is that we'd probably have to extend
> > the loading api to pass target xdp device so we can pre-generate
> > per-device bytecode for those kfuncs?
>
> There is an existing attr->prog_ifindex for dev offload purpose.  May be we can
> re-purpose/re-use some of the offload API.  How this kfunc can be presented also
> needs some thoughts, could be a new ndo_xxx.... not sure.
> > And this potentially will block attaching the same program
>  > to different drivers/devices?
> > Or, Martin, did you maybe have something better in mind?
>
> If the kfunc/helper is inline, then it will have to be per device.  Unless the
> bpf prog chooses not to inline which could be an option but I am also not sure
> how often the user wants to 'attach' a loaded xdp prog to a different device.
> To some extend, the CO-RE hints-loading-code will have to be per device also, no?
>
> Why I asked the kfunc/helper approach is because, from the set, it seems the
> hints has already been available at the driver.  The specific knowledge that the
> xdp prog missing is how to get the hints from the rx_desc/rx_queue.  The
> straight forward way to me is to make them (rx_desc/rx_queue) available to xdp
> prog and have kfunc/helper to extract the hints from them only if the xdp prog
> needs it.  The xdp prog can selectively get what hints it needs and then
> optionally store them into the meta area in any layout.

This sounds like a really good idea to me, well worth exploring. To
only have to pay, performance wise, for the metadata you actually use
is very important. I did some experiments [1] on the previous patch
set of Jesper's and there is substantial overhead added for each
metadata enabled (and fetched from the NIC). This is especially
important for AF_XDP in zero-copy mode where most packets are directed
to user-space (if not, you should be using the regular driver that is
optimized for passing packets to the stack or redirecting to other
devices). In this case, the user knows exactly what metadata it wants
and where in the metadata area it should be located in order to offer
the best performance for the application in question. But as you say,
your suggestion could potentially offer a good performance upside to
the regular XDP path too.

[1] https://lore.kernel.org/bpf/CAJ8uoz1XVqVCpkKo18qbkh6jq_Lejk24OwEWCB9cWhokYLEBDQ@mail.gmail.com/


> NETIF_F_XDP_HINTS_BIT probably won't be needed and one less thing to worry in
> production.
>
> >
> >>> Btw, do we also need to think about the redirect case? What happens
> >>> when I redirect one frame from a device A with one metadata format to
> >>> a device B with another?
> >>
> >> If there is a program on Tx then it'd be trivial - just do the
> >> info <-> descriptor translation in the opposite direction than Rx.
>
> +1
>
> >> TBH I'm not sure how it'd be done in the current approach, either.
>
> Yeah, I think we need more selftest to show how things work.
>
> >
> > Yeah, I don't think it magically works in any case. I'm just trying to
> > understand whether it's something we care to support out of the box or
> > can punt to the bpf programs themselves and say "if you care about
> > forwarding metadata, somehow agree on the format yourself".
> >
> >> Now I questioned the BTF way and mentioned the Tx-side program in
> >> a single thread, I better stop talking...
> >
> > Forget about btf, hail to the new king - kfunc :-D
>
