Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57CF587616
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 05:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbiHBDvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 23:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232170AbiHBDvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 23:51:53 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1F61EAFD;
        Mon,  1 Aug 2022 20:51:51 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id b96so5743254edf.0;
        Mon, 01 Aug 2022 20:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=aknSbmtx9GZBsEVN+nD/tmP8Ue7dUO3IiP2H96xy50g=;
        b=i3UCo5l16RLXOguWEigG+qH4iaCECPbTgP1D7pIFmAkMbeljsk5uix1ZsFAI+DkSPW
         Zzx/siylk9oKypfUjqZQkjXQNFS5X9dfiRdDmJS/rbHOxzK0YgYBMLnb4we29+L6rGd1
         TFJE4K03n3JmkXJa2NX/hXgWpC/pBX8agtVMbApFT0El2jRPfIkVtikDYCuaMZADT0L/
         c27GOOCbgXENsQQw+23NTshPJ5dn4pGIJSA4E8WGHPVLwc623jwfqkrwozr6bmd8gh9m
         zRsOsCpdoZg2SxXnQ/A/xZjBZiSD2pJbk0gV9bwRiu7UQ6284lSnQkIDRiaWlo3kEvcR
         EEmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=aknSbmtx9GZBsEVN+nD/tmP8Ue7dUO3IiP2H96xy50g=;
        b=Q65MKbBDErHT+DCSm6IeXS7R0f4YMsCmr59fPfVYuvOhxvosOe9bo7zR7PJUOLETYI
         bgzcOyPlFLQ2XjDTfU+miJDzqyqpjwjmqEtC78Y2kfsI2mtZiKZotgTa64CduC+j2Bc7
         VcNl3z4FlywxR2s61lQy23WvA9ESD6OeTnZneGTv3mHflncip3rJGLP31EtRqjW3uTGT
         drW9uqUDejXlImPDD1XyJgw6Gck6hNbGPUDa13clLDN9FpmjLZhgXg+GfTaSgKYz38Jp
         yz7YoIVYouA8A/WU6J2fhjrQ1oo0ci09ple3K32cuBciWx2wsr4qcS1VV+18FOkUqYkl
         haPQ==
X-Gm-Message-State: ACgBeo3A4UrsJAdyejVkpnn6H5knPBuK5oVA90mI9szHvkSt0JmEHcwk
        t/vLiUm4znTQI1j6K01wtuq/G4l8PwX/60Wkt0AOeNkU
X-Google-Smtp-Source: AA6agR5309XHfmcJIKjQbEekXag6MzM8PvzpjMAPwKjfTOSUC0wqoBswewYMh3uBMsT/8cTkq8bSVz6HSpXWH2A9fvk=
X-Received: by 2002:aa7:ccc4:0:b0:43d:9e0e:b7ff with SMTP id
 y4-20020aa7ccc4000000b0043d9e0eb7ffmr8380082edt.14.1659412310200; Mon, 01 Aug
 2022 20:51:50 -0700 (PDT)
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
 <20220801232314.shzlt7ws3sp7d744@kafai-mbp.dhcp.thefacebook.com> <20220802005621.d6sjq72l357eesp6@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220802005621.d6sjq72l357eesp6@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Aug 2022 20:51:38 -0700
Message-ID: <CAEf4BzZCAX7h_wMpd9-uQt4smGDj8ToxS=nM6Z+qoV7j-SSVJg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 1/3] bpf: Add skb dynptrs
To:     Martin KaFai Lau <kafai@fb.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     Joanne Koong <joannelkoong@gmail.com>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
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

On Mon, Aug 1, 2022 at 5:56 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Mon, Aug 01, 2022 at 04:23:16PM -0700, Martin KaFai Lau wrote:
> > On Mon, Aug 01, 2022 at 03:58:41PM -0700, Andrii Nakryiko wrote:
> > > On Mon, Aug 1, 2022 at 3:33 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > On Mon, Aug 01, 2022 at 02:16:23PM -0700, Joanne Koong wrote:
> > > > > On Mon, Aug 1, 2022 at 12:38 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > >
> > > > > > On Mon, Aug 01, 2022 at 10:52:14AM -0700, Joanne Koong wrote:
> > > > > > > > Since we are on bpf_dynptr_write, what is the reason
> > > > > > > > on limiting it to the skb_headlen() ?  Not implying one
> > > > > > > > way is better than another.  would like to undertand the reason
> > > > > > > > behind it since it is not clear in the commit message.
> > > > > > > For bpf_dynptr_write, if we don't limit it to skb_headlen() then there
> > > > > > > may be writes that pull the skb, so any existing data slices to the
> > > > > > > skb must be invalidated. However, in the verifier we can't detect when
> > > > > > > the data slice should be invalidated vs. when it shouldn't (eg
> > > > > > > detecting when a write goes into the paged area vs when the write is
> > > > > > > only in the head). If the prog wants to write into the paged area, I
> > > > > > > think the only way it can work is if it pulls the data first with
> > > > > > > bpf_skb_pull_data before calling bpf_dynptr_write. I will add this to
> > > > > > > the commit message in v2
> > > > > > Note that current verifier unconditionally invalidates PTR_TO_PACKET
> > > > > > after bpf_skb_store_bytes().  Potentially the same could be done for
> > > > > > other new helper like bpf_dynptr_write().  I think this bpf_dynptr_write()
> > > > > > behavior cannot be changed later, so want to raise this possibility here
> > > > > > just in case it wasn't considered before.
> > > > >
> > > > > Thanks for raising this possibility. To me, it seems more intuitive
> > > > > from the user standpoint to have bpf_dynptr_write() on a paged area
> > > > > fail (even if bpf_dynptr_read() on that same offset succeeds) than to
> > > > > have bpf_dynptr_write() always invalidate all dynptr slices related to
> > > > > that skb. I think most writes will be to the data in the head area,
> > > > > which seems unfortunate that bpf_dynptr_writes to the head area would
> > > > > invalidate the dynptr slices regardless.
> > > > >
> > > > > What are your thoughts? Do you think you prefer having
> > > > > bpf_dynptr_write() always work regardless of where the data is? If so,
> > > > > I'm happy to make that change for v2 :)
> > > > Yeah, it sounds like an optimization to avoid unnecessarily
> > > > invalidating the sliced data.
> > > >
> > > > To be honest, I am not sure how often the dynptr_data()+dynptr_write() combo will
> > > > be used considering there is usually a pkt read before a pkt write in
> > > > the pkt modification use case.  If I got that far to have a sliced data pointer
> > > > to satisfy what I need for reading,  I would try to avoid making extra call
> > > > to dyptr_write() to modify it.
> > > >
> > > > I would prefer user can have similar expectation (no need to worry pkt layout)
> > > > between dynptr_read() and dynptr_write(), and also has similar experience to
> > > > the bpf_skb_load_bytes() and bpf_skb_store_bytes().  Otherwise, it is just
> > > > unnecessary rules for user to remember while there is no clear benefit on
> > > > the chance of this optimization.
> > > >
> > >
> > > Are you saying that bpf_dynptr_read() shouldn't read from non-linear
> > > part of skb (and thus match more restrictive bpf_dynptr_write), or are
> > > you saying you'd rather have bpf_dynptr_write() write into non-linear
> > > part but invalidate bpf_dynptr_data() pointers?
> > The latter.  Read and write without worrying about the skb layout.
> >
> > Also, if the prog needs to call a helper to write, it knows the bytes are
> > not in the data pointer.  Then it needs to bpf_skb_pull_data() before
> > it can call write.  However, after bpf_skb_pull_data(), why the prog
> > needs to call the write helper instead of directly getting a new
> > data pointer and write to it?  If the prog needs to write many many
> > bytes, a write helper may then help.
> After another thought, other than the non-linear handling,
> bpf_skb_store_bytes() / dynptr_write() is more useful in
> the 'BPF_F_RECOMPUTE_CSUM | BPF_F_INVALIDATE_HASH' flags.
>
> That said,  my preference is still to have the same expectation on
> non-linear data for both dynptr_read() and dynptr_write().  Considering
> the user can fall back to use bpf_skb_load_bytes() and
> bpf_skb_store_bytes(), I am fine with the current patch also.
>

Honestly, I don't have any specific preference, because I don't have
much specific experience writing networking BPF :)

But considering Jakub's point about trying to unify skb/xdp dynptr,
while I can see how we might have symmetrical dynptr_{read,write}()
for skb case (because you can pull skb), I believe this is not
possible with XDP (e.g., multi-buffer one), so bpf_dynptr_write()
would always be more limited for XDP case.

Or maybe it is possible for XDP and I'm totally wrong here? I'm happy
to be educated about this!

> >
> > >
> > > I guess I agree about consistency and that it seems like in practice
> > > you'd use bpf_dynptr_data() to work with headers and stuff like that
> > > at known locations, and then if you need to modify the rest of payload
> > > you'd do either bpf_skb_load_bytes()/bpf_skb_store_bytes() or
> > > bpf_dynptr_read()/bpf_dynptr_write() which would invalidate
> > > bpf_dynptr_data() pointers (but that would be ok by that time).
> > imo, read, write and then go back to read is less common.
> > writing bytes without first reading them is also less common.
