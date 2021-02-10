Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A805D317014
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 20:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbhBJTZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 14:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233168AbhBJTYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 14:24:49 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B1DC061756
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 11:24:09 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id l18so1736261pji.3
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 11:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/uAnyvL669kTvZm/eLYNXLLc91kj5fgzHDhp1mLyIMM=;
        b=p1FtkTqBHcM2u4AvT4q5xpul7CIxr8PvC3HDtmF+LshTe/VMUJKQqLaay0xgDXdAvu
         6kB9957Dg1y1kRqk+yT2gVRO7BXE5vhSXTquhmhWD7QniNAr5J7a1vJwrdhgo0VQ5D5x
         hTB7lfDF+YXzwtLSS/oggCl29mC7/CfS20BS6qonAbEnwGCFRsSLhE0TEfESSXNfSte3
         0Wkkodc7v6kEJn+SlcoCpyI8CrwqG3NnIf2j4vM1jLVLVutcw9kAge9sv8Uz2e8OLd6q
         KvYE++tMNyhO8IJyartnCkNglV7b7mEFeAVE9P2eWSwCTjMtTVQZxVMvkQsO2Uyu/+Iv
         4N6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/uAnyvL669kTvZm/eLYNXLLc91kj5fgzHDhp1mLyIMM=;
        b=se6TJJ2rR/xvgOFsJy4t2K09DgtzDmYhhmNRGhDVGP8OR0CvOCDFlyipHSn9rVCyYM
         S6mvt199ESwa/xppORKoxvIlsd2QLllOAdHwOk6hcqs3sR29hCtM6C9HoW+x/w9DzVwa
         mfwpLAuV2Upyuv5EOOGaD6s+w4D2Ru/70Hv06ojayiOrNQvlzk6TPUJ3Ugagn7X4X2nr
         mmOXzV8LS+NkIn/kY6p7TXifPL5wl3u41VXzudiQ2kqFmMc2HtJrOQR3XidRpO+6yvGX
         TeX5c95PmvLXqvs4bvbIO+LEXLrIAhjWOmLeMqScQAX7RckYUZF5H6M1RE+Tpirv93YE
         2eUQ==
X-Gm-Message-State: AOAM532lFli/nAEL6KJBU/X54eXwCz8SmZO/ehOTyG3gf23N2wXxkX6C
        3a+GVx0d4AOLXVkADYqfCdpHQe67ticZWEXg/pt/pw==
X-Google-Smtp-Source: ABdhPJyi/1hxkoKP1mjohzOM661uSKI6e83m32wncHCaMaY5KTfFy4jpclCoeL3t2KHSjwDLt7QuNwvyciwrBLviOv8=
X-Received: by 2002:a17:90a:ee97:: with SMTP id i23mr392578pjz.85.1612985049122;
 Wed, 10 Feb 2021 11:24:09 -0800 (PST)
MIME-Version: 1.0
References: <20210206203648.609650-1-arjunroy.kdev@gmail.com>
 <20210206152828.6610da2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210207082654.GC4656@unreal> <20210208104143.60a6d730@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <09fa284e-ea02-a6ca-cd8f-6d90dff2fa00@gmail.com> <20210208185323.11c2bacf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <af35d535-8d58-3cf3-60e3-1764e409308b@gmail.com> <20210209085909.32d27f0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAOFY-A3wgGfBM0gia66VJY_iUBueWN1a4Ai8v9MT+at_pcH7-w@mail.gmail.com> <3d3a2949-0ce6-01d9-a1f1-2f48720d99a9@gmail.com>
In-Reply-To: <3d3a2949-0ce6-01d9-a1f1-2f48720d99a9@gmail.com>
From:   Arjun Roy <arjunroy@google.com>
Date:   Wed, 10 Feb 2021 11:23:58 -0800
Message-ID: <CAOFY-A1vTnr9TwZZ8a4WYSQqGLfPkb6v_W5bEMY=MWh27=c0Dw@mail.gmail.com>
Subject: Re: [net-next v2] tcp: Explicitly mark reserved field in
 tcp_zerocopy_receive args.
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 8:35 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 2/9/21 4:46 PM, Arjun Roy wrote:
> > On Tue, Feb 9, 2021 at 8:59 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >>
> >> On Mon, 8 Feb 2021 20:20:29 -0700 David Ahern wrote:
> >>> On 2/8/21 7:53 PM, Jakub Kicinski wrote:
> >>>> On Mon, 8 Feb 2021 19:24:05 -0700 David Ahern wrote:
> >>>>> That would be the case for new userspace on old kernel. Extending the
> >>>>> check to the end of the struct would guarantee new userspace can not ask
> >>>>> for something that the running kernel does not understand.
> >>>>
> >>>> Indeed, so we're agreeing that check_zeroed_user() is needed before
> >>>> original optlen from user space gets truncated?
> >>>
> >>> I thought so, but maybe not. To think through this ...
> >>>
> >>> If current kernel understands a struct of size N, it can only copy that
> >>> amount from user to kernel. Anything beyond is ignored in these
> >>> multiplexed uAPIs, and that is where the new userspace on old kernel falls.
> >>>
> >>> Known value checks can only be done up to size N. In this case, the
> >>> reserved field is at the end of the known struct size, so checking just
> >>> the field is fine. Going beyond the reserved field has implications for
> >>> extensions to the API which should be handled when those extensions are
> >>> added.
> >>
> >> Let me try one last time.
> >>
> >> There is no check in the kernels that len <= N. User can pass any
> >> length _already_. check_zeroed_user() forces the values beyond the
> >> structure length to be known (0) rather than anything. It can only
> >> avoid breakages in the future.
> >>
> >>> So, in short I think the "if (zc.reserved)" is correct as Leon noted.
> >>
> >> If it's correct to check some arbitrary part of the buffer is zeroed
> >> it should be correct to check the entire tail is zeroed.
> >
> > So, coming back to the thread, I think the following appears to be the
> > current thoughts:
> >
> > 1. It is requested that, on the kernel as it stands today, fields
> > beyond zc.msg_flags (including zc.reserved, the only such field as of
> > this patch) are zero'd out. So a new userspace asking to do specific
> > things would fail on this old kernel with EINVAL. Old userspace would
> > work on old or new kernels. New of course works on new kernels.
> > 2. If it's correct to check some arbitrary field (zc.reserved) to be
> > 0, then it should be fine to check this for all future fields >=
> > reserved in the struct. So some advanced userspace down the line
> > doesn't get confused.
> >
> > Strictly speaking, I'm not convinced this is necessary - eg. 64 bytes
> > struct right now, suppose userspace of the future gives us 96 bytes of
> > which the last 32 are non-zero for some feature or the other. We, in
> > the here and now kernel, truncate that length to 64 (as in we only
> > copy to kernel those first 64 bytes) and set the returned length to
> > 64. The understanding being, any (future, past or present) userspace
> > consults the output value; and considers anything byte >= the returned
> > len to be untouched by the kernel executing the call (ie. garbage,
> > unacted upon).
> >
> > So, how would this work for old+new userspace on old+new kernel?
> >
> > A) old+old, new+new: sizes match, no issue
> > B) new kernel, old userspace: That's not an issue. We have the
> > switch(len) statement for that.
> > C) old kernel, new userspace: that's the 96 vs. 64 B example above -
> > new userspace would see that the kernel only operated on 64 B and
> > treat the last 32 B as garbage/unacted on.
> >
> > In this case, we would not give EINVAL on case C, as we would if we
> > returned EINVAL on a check_zeroed_user() case for fields past
> > zc.reserved. We'd do a zerocopy operating on just the features we know
> > about, and communicate to the user that we only acted on features up
> > until this byte offset.
> >
> > Now, given this is the case, we still have the padding confusion with
> > zc.reserved and the current struct size, so we have to force it to 0
> > as we are doing. But I think we don't need to go beyond this so far.
> >
> > Thus, my personal preference is to not have the check_zeroed_user()
> > check. But if the consensus demands it, then it's an easy enough fix.
> > What are your thoughts?
> >
>
> bpf uses check_zeroed_user to make sure extensions to its structs are
> compatible, so yes, this is required.

Very well; I shall send out a v3 patch with this.

>
> Also, you need to address legitimate msg_flags as I mentioned in another
> response.

I meant to respond to this earlier but forgot. v3 will address this as well.

-Arjun
