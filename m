Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9133A587679
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 06:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbiHBExZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 00:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbiHBExX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 00:53:23 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A52286EB;
        Mon,  1 Aug 2022 21:53:21 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id tl27so6086029ejc.1;
        Mon, 01 Aug 2022 21:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9nPFUyxCuFpzSwZzp2HcpFh6fZONUBRbOF8ktIAvim8=;
        b=DNvLL1DLOdUPVAFxPG9N2OpARIoi6u3PBVbuU8KFSWD+K/Z07RPnDG+66pd50UQtG3
         /E+5OVVAaaJm2rzJsFvGU42rffH+tOMViQLm6g/8ptAFUTZeeWuNix6h1EBv3tsNmHi6
         vUCaybs7Cxj4Ke/NjOnU+VwUf2n61HfzucHu0q9u0dCz3D7/E9UjkvmagLEiJ3s0UzEX
         nyOfvkJx7It9eGFqYo3wgdbnxKkcXBhlLuOEZq+TGt6NFHZ08jNwaczN6xFuXBZ449BO
         flzuxGDPnrCncMr4NovoIEnU+OZUaE4MTdQoZISyfTg9rK2pjXBs2xY5tSYIQ3kdXWIT
         iIbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9nPFUyxCuFpzSwZzp2HcpFh6fZONUBRbOF8ktIAvim8=;
        b=bmWqPWLJo8Bnpekxtf2VI3W4IInoiluFaQA3yL+aTCkV71iUjyCiTSwdHnNza7PRjP
         AdahR60Jt2ziCS+5GR71PCy6l5YqISnsQM6ZyiEB6vMSNUyAlrGw4nWXSVz8UMrqJDGQ
         Mr1Jagy25ggyCRJxxAmZnjLaLUpE7t0J5w6GbkNJ+qw/9yvdMGfDabuxUHK2Fce+LEKl
         CEVSBDzmA1+JEvYoFlTeVa5fDN+2KPI9Mqb1VoLJoEeJExWYx1bo/Gyq9QrdnssAcfTN
         BZ4G9IKiusPTbnsuAhHXp8RYSIEbfGsDg4vb9XI0ctKcMqDrtjLFZY08UIvMk5lYo/p6
         BU+A==
X-Gm-Message-State: AJIora/6de2ZYzcTh8fwUZ70xFdqM3tGGpdPnHnUHJMkEEm9XTGupxgv
        5g49md6sMh1DzPX24pJ54wE+o4mqQyxrvJr8WKQ=
X-Google-Smtp-Source: AGRyM1ss1DMtvzoXlZZzwgTaXc7NAfLchA5ocMZqtekrICN3VCSuGew/RANYZ/1iX2eM8S3k6t5j7U0LU7tR+9FELBw=
X-Received: by 2002:a17:907:608f:b0:72b:7db9:4dc6 with SMTP id
 ht15-20020a170907608f00b0072b7db94dc6mr14361431ejc.463.1659416000289; Mon, 01
 Aug 2022 21:53:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220726184706.954822-2-joannelkoong@gmail.com>
 <20220728233936.hjj2smwey447zqyy@kafai-mbp.dhcp.thefacebook.com>
 <CAJnrk1b2WoHV=iE3j4n_4=2NBP3GaoeD=v-Zt+p-M9N=LApsuQ@mail.gmail.com>
 <20220729213919.e7x6acvqnwqwfnzu@kafai-mbp.dhcp.thefacebook.com>
 <CAJnrk1YXSx11TGhKhAZ20R81pUsgBVeAooGJjTR7dR5iyP_eeQ@mail.gmail.com>
 <20220801193850.2qkf6uiic7nrwrfm@kafai-mbp.dhcp.thefacebook.com>
 <CAJnrk1ZCQ5nRB=jBUxPFyS4OhMvDX1t4ddFYX2LqkepMZg-12w@mail.gmail.com>
 <20220801223239.25z2krjm6ucid3fh@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzbjFOXFYeRHwnny1p-GWfMDiOqC6zGMSBjGkjY8RQi5Qw@mail.gmail.com>
 <20220801232314.shzlt7ws3sp7d744@kafai-mbp.dhcp.thefacebook.com>
 <20220802005621.d6sjq72l357eesp6@kafai-mbp.dhcp.thefacebook.com> <CAEf4BzZCAX7h_wMpd9-uQt4smGDj8ToxS=nM6Z+qoV7j-SSVJg@mail.gmail.com>
In-Reply-To: <CAEf4BzZCAX7h_wMpd9-uQt4smGDj8ToxS=nM6Z+qoV7j-SSVJg@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Mon, 1 Aug 2022 21:53:09 -0700
Message-ID: <CAJnrk1YVYtsovy+eJ3NqTDyX9O53rMuCw8RovcFp2imuqsGzMA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 1/3] bpf: Add skb dynptrs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, Jakub Kicinski <kuba@kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
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

On Mon, Aug 1, 2022 at 8:51 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Aug 1, 2022 at 5:56 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Mon, Aug 01, 2022 at 04:23:16PM -0700, Martin KaFai Lau wrote:
> > > On Mon, Aug 01, 2022 at 03:58:41PM -0700, Andrii Nakryiko wrote:
> > > > On Mon, Aug 1, 2022 at 3:33 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > >
> > > > > On Mon, Aug 01, 2022 at 02:16:23PM -0700, Joanne Koong wrote:
> > > > > > On Mon, Aug 1, 2022 at 12:38 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > > >
> > > > > > > On Mon, Aug 01, 2022 at 10:52:14AM -0700, Joanne Koong wrote:
> > > > > > > > > Since we are on bpf_dynptr_write, what is the reason
> > > > > > > > > on limiting it to the skb_headlen() ?  Not implying one
> > > > > > > > > way is better than another.  would like to undertand the reason
> > > > > > > > > behind it since it is not clear in the commit message.
> > > > > > > > For bpf_dynptr_write, if we don't limit it to skb_headlen() then there
> > > > > > > > may be writes that pull the skb, so any existing data slices to the
> > > > > > > > skb must be invalidated. However, in the verifier we can't detect when
> > > > > > > > the data slice should be invalidated vs. when it shouldn't (eg
> > > > > > > > detecting when a write goes into the paged area vs when the write is
> > > > > > > > only in the head). If the prog wants to write into the paged area, I
> > > > > > > > think the only way it can work is if it pulls the data first with
> > > > > > > > bpf_skb_pull_data before calling bpf_dynptr_write. I will add this to
> > > > > > > > the commit message in v2
> > > > > > > Note that current verifier unconditionally invalidates PTR_TO_PACKET
> > > > > > > after bpf_skb_store_bytes().  Potentially the same could be done for
> > > > > > > other new helper like bpf_dynptr_write().  I think this bpf_dynptr_write()
> > > > > > > behavior cannot be changed later, so want to raise this possibility here
> > > > > > > just in case it wasn't considered before.
> > > > > >
> > > > > > Thanks for raising this possibility. To me, it seems more intuitive
> > > > > > from the user standpoint to have bpf_dynptr_write() on a paged area
> > > > > > fail (even if bpf_dynptr_read() on that same offset succeeds) than to
> > > > > > have bpf_dynptr_write() always invalidate all dynptr slices related to
> > > > > > that skb. I think most writes will be to the data in the head area,
> > > > > > which seems unfortunate that bpf_dynptr_writes to the head area would
> > > > > > invalidate the dynptr slices regardless.
> > > > > >
> > > > > > What are your thoughts? Do you think you prefer having
> > > > > > bpf_dynptr_write() always work regardless of where the data is? If so,
> > > > > > I'm happy to make that change for v2 :)
> > > > > Yeah, it sounds like an optimization to avoid unnecessarily
> > > > > invalidating the sliced data.
> > > > >
> > > > > To be honest, I am not sure how often the dynptr_data()+dynptr_write() combo will
> > > > > be used considering there is usually a pkt read before a pkt write in
> > > > > the pkt modification use case.  If I got that far to have a sliced data pointer
> > > > > to satisfy what I need for reading,  I would try to avoid making extra call
> > > > > to dyptr_write() to modify it.
> > > > >
> > > > > I would prefer user can have similar expectation (no need to worry pkt layout)
> > > > > between dynptr_read() and dynptr_write(), and also has similar experience to
> > > > > the bpf_skb_load_bytes() and bpf_skb_store_bytes().  Otherwise, it is just
> > > > > unnecessary rules for user to remember while there is no clear benefit on
> > > > > the chance of this optimization.
> > > > >
> > > >
> > > > Are you saying that bpf_dynptr_read() shouldn't read from non-linear
> > > > part of skb (and thus match more restrictive bpf_dynptr_write), or are
> > > > you saying you'd rather have bpf_dynptr_write() write into non-linear
> > > > part but invalidate bpf_dynptr_data() pointers?
> > > The latter.  Read and write without worrying about the skb layout.
> > >
> > > Also, if the prog needs to call a helper to write, it knows the bytes are
> > > not in the data pointer.  Then it needs to bpf_skb_pull_data() before
> > > it can call write.  However, after bpf_skb_pull_data(), why the prog
> > > needs to call the write helper instead of directly getting a new
> > > data pointer and write to it?  If the prog needs to write many many
> > > bytes, a write helper may then help.
> > After another thought, other than the non-linear handling,
> > bpf_skb_store_bytes() / dynptr_write() is more useful in
> > the 'BPF_F_RECOMPUTE_CSUM | BPF_F_INVALIDATE_HASH' flags.
> >
> > That said,  my preference is still to have the same expectation on
> > non-linear data for both dynptr_read() and dynptr_write().  Considering
> > the user can fall back to use bpf_skb_load_bytes() and
> > bpf_skb_store_bytes(), I am fine with the current patch also.
> >
>
> Honestly, I don't have any specific preference, because I don't have
> much specific experience writing networking BPF :)
>
> But considering Jakub's point about trying to unify skb/xdp dynptr,
> while I can see how we might have symmetrical dynptr_{read,write}()
> for skb case (because you can pull skb), I believe this is not
> possible with XDP (e.g., multi-buffer one), so bpf_dynptr_write()
> would always be more limited for XDP case.
>
> Or maybe it is possible for XDP and I'm totally wrong here? I'm happy
> to be educated about this!

My understanding is that it's possible for XDP because the data in the
frags are mapped [eg we can use skb_frag_address() to get the address
and then copy into it with direct memcpys [0]] whereas skb frags are
unmapped (eg access into the frag requires kmapping [1]).

Maybe one solution is to add a function that does the mapping + write
to a skb frag without pulling it to the head. This would allow
bpf_dynptr_write to all data without needing to invalidate any dynptr
slices. But I don't know whether this is compatible with recomputing
the checksum or not, maybe the written data needs to be mapped (and
hence part of head) so that it can be used to compute the checksum [2]
- I'll read up some more on the checksumming code.

I like your point Martin that if people are using bpf_dynptr_write,
then they probably aren't using data slices much anyways so it
wouldn't be too inconvenient that their slices are invalidated (eg if
they are using bpf_dynptr_write it's to write into the skb frag, at
which point they would need to call pull before bpf_dynptr_write,
which would lead to same scenario where the data slices are
invalidated). My main concern was that slices would be invalidated for
bpf_dynptr_writes on data in the head area, but you're right that that
shouldn't be too likely since they'd just be using a direct data slice
access instead to read/write. I'll change it so that bpf_dynptr_write
always succeeds and it'll always invalidate the data slices for v2.

[0] https://elixir.bootlin.com/linux/v5.19/source/net/core/filter.c#L3846
[1] https://elixir.bootlin.com/linux/v5.19/source/net/core/skbuff.c#L2367
[2] https://elixir.bootlin.com/linux/v5.19/source/include/linux/skbuff.h#L3839

>
> > >
> > > >
> > > > I guess I agree about consistency and that it seems like in practice
> > > > you'd use bpf_dynptr_data() to work with headers and stuff like that
> > > > at known locations, and then if you need to modify the rest of payload
> > > > you'd do either bpf_skb_load_bytes()/bpf_skb_store_bytes() or
> > > > bpf_dynptr_read()/bpf_dynptr_write() which would invalidate
> > > > bpf_dynptr_data() pointers (but that would be ok by that time).
> > > imo, read, write and then go back to read is less common.
> > > writing bytes without first reading them is also less common.
