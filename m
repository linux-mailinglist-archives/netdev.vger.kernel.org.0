Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1CB413A9A
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 21:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhIUTT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 15:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbhIUTT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 15:19:26 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3131BC061575
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 12:17:57 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id dj4so469346edb.5
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 12:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=riotgames.com; s=riotgames;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PMd93L89NYSvH94urHOISzem89NRj+7PHoHt6qu4LfE=;
        b=Td+I4T+wRg9EOact5W1N6cGUwQwhWh21p/ZHiMlpV/qOCeboVnoBK7hmYvz1H36cOT
         ejuAfiZGHntz2UjdjlLBrTZvUIEBpzGeY86MvpkhfnMiPWk5Rsso2oEm/B7AGbS5bUaO
         B04XH2zs/wUmoXJnD0l1YSGcBoRdxlV3r6q1U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PMd93L89NYSvH94urHOISzem89NRj+7PHoHt6qu4LfE=;
        b=KSo8P4SU0ccbaVIOdb6F6un0TcJy6RsI4HfFK7oAze0PHpPCNiufVb5cu/3JE4dFcX
         ISx81Lh5buAGhub187YQZ85k8jmnBTt6buOKJb8R8MBwTXhmuq/W/Y7ZSRNJgUI8ORdM
         kwDB82UKf8vQCDdKejgau4Pt7afOh19I7cYGLwXAAD9KCEq2eWxB2/+h9BcwhzYf44r4
         VNHxkKu8TnC1NlSSuGPT86U5oetlkpsLJPkx63kUnCy/C39AQ9qL6B1rW1EVHm+8Yc7b
         IbFxskRSC2ThNjpV/L3ejpp1OFH1ZwgUCzj23ZUlL/qTznKQ0xZRCj3v42JkrUFgekZ9
         oHKg==
X-Gm-Message-State: AOAM530Mryn9l2uMfJuLAPO/Du71xyBDboqSY1IroCuU62++1Erdptv9
        490BA7r8fvtRBWMCHVhM5bIljR5Kcm06zfQ8TKJSfg==
X-Google-Smtp-Source: ABdhPJyP6hqonPMSe+mSukHxsuQ90yCTfKGxBu/nAUVCsc7ye2y0hCWBpiT8XeggCPlsRoYeocV64XGpd5bOilIghLo=
X-Received: by 2002:a17:907:244a:: with SMTP id yw10mr35989082ejb.571.1632251875496;
 Tue, 21 Sep 2021 12:17:55 -0700 (PDT)
MIME-Version: 1.0
References: <87o88l3oc4.fsf@toke.dk> <CAC1LvL1xgFMjjE+3wHH79_9rumwjNqDAS2Yg2NpSvmewHsYScA@mail.gmail.com>
 <87ilyt3i0y.fsf@toke.dk>
In-Reply-To: <87ilyt3i0y.fsf@toke.dk>
From:   Zvi Effron <zeffron@riotgames.com>
Date:   Tue, 21 Sep 2021 12:17:44 -0700
Message-ID: <CAC1LvL3yQd_T5srJb78rGxv8YD-QND2aRgJ-p5vOQkbvrwJWSw@mail.gmail.com>
Subject: Re: Redux: Backwards compatibility for XDP multi-buff
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Lorenzo Bianconi <lbianconi@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 11:23 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Zvi Effron <zeffron@riotgames.com> writes:
>
> > On Tue, Sep 21, 2021 at 9:06 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Hi Lorenz (Cc. the other people who participated in today's discussion=
)
> >>
> >> Following our discussion at the LPC session today, I dug up my previou=
s
> >> summary of the issue and some possible solutions[0]. Seems no on
> >> actually replied last time, which is why we went with the "do nothing"
> >> approach, I suppose. I'm including the full text of the original email
> >> below; please take a look, and let's see if we can converge on a
> >> consensus here.
> >>
> >> First off, a problem description: If an existing XDP program is expose=
d
> >> to an xdp_buff that is really a multi-buffer, while it will continue t=
o
> >> run, it may end up with subtle and hard-to-debug bugs: If it's parsing
> >> the packet it'll only see part of the payload and not be aware of that
> >> fact, and if it's calculating the packet length, that will also only b=
e
> >> wrong (only counting the first fragment).
> >>
> >> So what to do about this? First of all, to do anything about it, XDP
> >> programs need to be able to declare themselves "multi-buffer aware" (b=
ut
> >> see point 1 below). We could try to auto-detect it in the verifier by
> >> which helpers the program is using, but since existing programs could =
be
> >> perfectly happy to just keep running, it probably needs to be somethin=
g
> >> the program communicates explicitly. One option is to use the
> >> expected_attach_type to encode this; programs can then declare it in t=
he
> >> source by section name, or the userspace loader can set the type for
> >> existing programs if needed.
> >>
> >> With this, the kernel will know if a given XDP program is multi-buff
> >> aware and can decide what to do with that information. For this we cam=
e
> >> up with basically three options:
> >>
> >> 1. Do nothing. This would make it up to users / sysadmins to avoid
> >>    anything breaking by manually making sure to not enable multi-buffe=
r
> >>    support while loading any XDP programs that will malfunction if
> >>    presented with an mb frame. This will probably break in interesting
> >>    ways, but it's nice and simple from an implementation PoV. With thi=
s
> >>    we don't need the declaration discussed above either.
> >>
> >> 2. Add a check at runtime and drop the frames if they are mb-enabled a=
nd
> >>    the program doesn't understand it. This is relatively simple to
> >>    implement, but it also makes for difficult-to-understand issues (wh=
y
> >>    are my packets suddenly being dropped?), and it will incur runtime
> >>    overhead.
> >>
> >> 3. Reject loading of programs that are not MB-aware when running in an
> >>    MB-enabled mode. This would make things break in more obvious ways,
> >>    and still allow a userspace loader to declare a program "MB-aware" =
to
> >>    force it to run if necessary. The problem then becomes at what leve=
l
> >>    to block this?
> >>
> >
> > I think there's another potential problem with this as well: what happe=
ns to
> > already loaded programs that are not MB-aware? Are they forcibly unload=
ed?
>
> I'd say probably the opposite: You can't toggle whatever switch we end
> up with if there are any non-MB-aware programs (you'd have to unload
> them first)...
>

How would we communicate that issue? dmesg? I'm not very familiar with how
sysctl change failure causes are communicated to users, so this might be a
solved problem, but if I run `sysctl -w net.xdp.multibuffer 1` (or whatever
ends up actually being the toggle) to active multi-buffer, and it fails bec=
ause
there's a loaded non-aware program, that seems like a potential for a lot o=
f
administrator pain.

> >>    Doing this at the driver level is not enough: while a particular
> >>    driver knows if it's running in multi-buff mode, we can't know for
> >>    sure if a particular XDP program is multi-buff aware at attach time=
:
> >>    it could be tail-calling other programs, or redirecting packets to
> >>    another interface where it will be processed by a non-MB aware
> >>    program.
> >>
> >>    So another option is to make it a global toggle: e.g., create a new
> >>    sysctl to enable multi-buffer. If this is set, reject loading any X=
DP
> >>    program that doesn't support multi-buffer mode, and if it's unset,
> >>    disable multi-buffer mode in all drivers. This will make it explici=
t
> >>    when the multi-buffer mode is used, and prevent any accidental subt=
le
> >>    malfunction of existing XDP programs. The drawback is that it's a
> >>    mode switch, so more configuration complexity.
> >>
> >
> > Could we combine the last two bits here into a global toggle that doesn=
't
> > require a sysctl? If any driver is put into multi-buffer mode, then the=
 system
> > switches to requiring all programs be multi-buffer? When the last multi=
-buffer
> > enabled driver switches out of multi-buffer, remove the system-wide
> > restriction?
>
> Well, the trouble here is that we don't necessarily have an explicit
> "multi-buf mode" for devices. For instance, you could raise the MTU of a
> device without it necessarily involving any XDP multi-buffer stuff (if
> you're not running XDP on that device). So if we did turn "raising the
> MTU" into such a mode switch, we would end up blocking any MTU changes
> if any XDP programs are loaded. Or having an MTU change cause a
> force-unload of all XDP programs.

Maybe I missed something then, but you had stated that "while a particular
driver knows if it's running in multi-buff mode" so I assumed that the driv=
er
would be able to tell when to toggle the mode on.

I had been thinking that when a driver turned multi-buffer off, it could
trigger a check of all drivers, but that also seems like it could just be a
global refcount of all the drivers that have requested multi-buffer mode. W=
hen
a driver enables multi-buffer for itself, it increments the refcount, and w=
hen
it disables, it decrements. A non-zero count means the system is in
multi-buffer mode.

Obviously this is more complex than just requiring the administrator to ena=
ble
the system-wide mode.

>
> Neither of those are desirable outcomes, I think; and if we add a
> separate "XDP multi-buff" switch, we might as well make it system-wide?
>

> > Regarding my above question, if non-MB-aware XDP programs are not forci=
bly
> > unloaded, then a global toggle is also insufficient. An existing non-MB=
-aware
> > XDP program would still beed to be rejected at attach time by the
> > driver.
>
> See above.
>
> -Toke
>

--Zvi
