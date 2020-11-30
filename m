Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBE82C8740
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgK3O6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727771AbgK3O6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 09:58:34 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D7FC0613D2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 06:57:54 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id u12so16642336wrt.0
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 06:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ob/I2+lTNqu0iX3erLDSv6QM5dqJRM1YGvfiQ0Jm8Qc=;
        b=ZXbQY6t90VHTn/juSuMfIKzFlC3otTpTmsvpXbTTjzKSF6ph71eBWmEQgbD3+udT/8
         LhuMg+TNLJbbe+eBuRbYIIcuIR3ofRyEQQcA0qGUEOtVvwestF2H+lo0pJpzkXPTXxjL
         LiB61fGX7ktfvIPUq42bRFbB290Zahi/khNwNpEJEx7OuslMXdMJk4QXRYMJqtIRd+Ph
         isSSDuh7lLT5a1TRwjJfs6n1a78ippOt7mAnM9lGEKM7N/pF6N9OoVXnwRJw92Fb05il
         zUZ8yqp5ehsslF/HFnOBR+zcgXa09SJNf6AlwxmWPPS1Bp02nB9h7HVv5vc1bd9Odz7g
         Mfsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ob/I2+lTNqu0iX3erLDSv6QM5dqJRM1YGvfiQ0Jm8Qc=;
        b=U7ci2o91yCS4s1ohvujZLT1dYKZ6A/xPx5H6oDYDA9gZuro4FBK5w41IFZRMxMbRWp
         HQOfkhvR4yfe3fVEq1XfTrZR6MSl2QuG3Znl7GXCfbRSBnReUVuGhg8QFHhda87YfpFN
         qGaaILnWcilAdlBXodbPiGXveXIiyn9U5muS9j+xG6wbXsy99QJhT2qUkMUvkgH5McpM
         j83XMrK8RdR+XVJHQVgGi5yaubHkBM8cMLLm8t3203NNyC0Oosm4sX0xFzIAJ/cRthEo
         YrN0YbwGSPdoXuxenbQfT00Mn5tE9J2/Vizt0i2qAfA6d5i5Q0gUGbMcpFLG9YAiTEB6
         7Rrg==
X-Gm-Message-State: AOAM531NcW9rs9r7e8fGBbosGlipzzVys/UoXIh+RZpVg5E4s76Z9UGl
        QdUKPvS2uNu9oCOHgfkwL12BVExQ7gNebxe3qcpFpLABIFuwGckf
X-Google-Smtp-Source: ABdhPJzt4G/vo9Kb/nrgOBvOmMc5TWFK2TTilMyA2Wuy43CT4LLMuS+IWtwbsBRnAA3HO+a/V/Jy4AQWP87rKCEiISE=
X-Received: by 2002:a5d:510d:: with SMTP id s13mr28528845wrt.380.1606748272375;
 Mon, 30 Nov 2020 06:57:52 -0800 (PST)
MIME-Version: 1.0
References: <CAM1kxwi5m6i8hrtkw7nZYoziPTD-Wp03+fcsUwh3CuSc=81kUQ@mail.gmail.com>
 <4bb2cb8a-c3ef-bfa9-7b04-cb2cca32d3ee@samba.org> <CAM1kxwhUcXLKU=2hCVaBngOKRL_kgMX4ONy9kpzKW+ZBZraEYw@mail.gmail.com>
 <5d71d36c-0bfb-a313-07e8-0e22f7331a7a@samba.org> <CAM1kxwh1A3Fh6g7C=kxr67JLF325Cw5jY6CoL6voNhboV1wsVw@mail.gmail.com>
 <12153e6a-37b1-872f-dd82-399e255eef5d@samba.org>
In-Reply-To: <12153e6a-37b1-872f-dd82-399e255eef5d@samba.org>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Mon, 30 Nov 2020 09:57:16 -0500
Message-ID: <CACSApvZW-UN9_To0J-bO6SMYKJgF9oFvsKk14D-7Tx4zzc8JUw@mail.gmail.com>
Subject: Re: [RFC 0/1] whitelisting UDP GSO and GRO cmsgs
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Victor Stewart <v@nametag.social>,
        io-uring <io-uring@vger.kernel.org>,
        Luke Hsiao <lukehsiao@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jann Horn <jannh@google.com>, Arjun Roy <arjunroy@google.com>,
        netdev <netdev@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 5:52 AM Stefan Metzmacher <metze@samba.org> wrote:
>
> Am 28.11.20 um 20:03 schrieb Victor Stewart:
> > On Thu, Nov 26, 2020 at 7:36 AM Stefan Metzmacher <metze@samba.org> wrote:
> >>
> >> Am 23.11.20 um 17:29 schrieb Victor Stewart:
> >>> On Mon, Nov 23, 2020 at 4:13 PM Stefan Metzmacher <metze@samba.org> wrote:
> >>>>
> >>>> Hi Victor,
> >>>>
> >>>> wouldn't it be enough to port the PROTO_CMSG_DATA_ONLY check to the sendmsg path?
> >>>>
> >>>> UDP sockets should have PROTO_CMSG_DATA_ONLY set.
> >>>>
> >>>> I guess that would fix your current problem.
> >>>
> >>> that would definitely solve the problem and is the easiest solution.
> >>>
> >>> but PROTO_CMSG_DATA_ONLY is only set on inet_stream_ops and
> >>> inet6_stream_ops but dgram?
> >>
> >> I guess PROTO_CMSG_DATA_ONLY should be added also for dgram sockets.
> >>
> >> Did you intend to remove the cc for the mailing list?
> >>
> >> I think in addition to the io-uring list, cc'ing netdev@vger.kernel.org
> >> would also be good.
> >
> > whoops forgot to reply all.
> >
> > before I CC netdev, what does PROTO_CMSG_DATA_ONLY actually mean?
>
> I don't really know, but I guess it means that, any supported CMSG type
> on that socket won't do any magic depending on the process state, like
> fd passing with SOL_SOCKET/SCM_RIGHTS or SCM_CREDENTIALS. The CMSG buffer
> would just be a plain byte array, which may only reference state attached
> to the specific socket or packet.
>
> I'd guess that the author and/or reviewers can clarify that, let's see what
> they'll answer.
>
> > I didn't find a clear explanation anywhere by searching the kernel, only
> > that it was defined as 1 and flagged on inet_stream_ops and
> > inet6_stream_ops.
> >
> > there must be a reason it was not initially included for dgrams?
>
> I can't think of any difference I guess the author just tried to get add support for the specific usecase
> that didn't work (MSG_ZEROCOPY in this case, most likely only tested with a tcp workload):
>
> commit 583bbf0624dfd8fc45f1049be1d4980be59451ff
> Author: Luke Hsiao <lukehsiao@google.com>
> Date:   Fri Aug 21 21:41:04 2020 -0700
>
>     io_uring: allow tcp ancillary data for __sys_recvmsg_sock()
>
>     For TCP tx zero-copy, the kernel notifies the process of completions by
>     queuing completion notifications on the socket error queue. This patch
>     allows reading these notifications via recvmsg to support TCP tx
>     zero-copy.
>
>     Ancillary data was originally disallowed due to privilege escalation
>     via io_uring's offloading of sendmsg() onto a kernel thread with kernel
>     credentials (https://crbug.com/project-zero/1975). So, we must ensure
>     that the socket type is one where the ancillary data types that are
>     delivered on recvmsg are plain data (no file descriptors or values that
>     are translated based on the identity of the calling process).

Thank you for CCing us.

The reason for PROTO_CMSG_DATA_ONLY is explained in the paragraph
above in the commit message.  PROTO_CMSG_DATA_ONLY is basically to
allow-list a protocol that is guaranteed not to have the privilege
escalation in https://crbug.com/project-zero/1975.  TCP doesn't have
that issue, and I believe UDP doesn't have that issue either (but
please audit and confirm that with +Jann Horn).

If you couldn't find any non-data CMSGs for UDP, you should just add
PROTO_CMSG_DATA_ONLY to inet dgram sockets instead of introducing
__sys_whitelisted_cmsghdrs as Stefan mentioned.

Thanks,
Soheil

>     This was tested by using io_uring to call recvmsg on the MSG_ERRQUEUE
>     with tx zero-copy enabled. Before this patch, we received -EINVALID from
>     this specific code path. After this patch, we could read tcp tx
>     zero-copy completion notifications from the MSG_ERRQUEUE.
>
>     Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
>     Signed-off-by: Arjun Roy <arjunroy@google.com>
>     Acked-by: Eric Dumazet <edumazet@google.com>
>     Reviewed-by: Jann Horn <jannh@google.com>
>     Reviewed-by: Jens Axboe <axboe@kernel.dk>
>     Signed-off-by: Luke Hsiao <lukehsiao@google.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
>
> > but yes if there's nothing standing in the way of adding it for
> > dgrams, and it covers UDP_SEGMENT and UDP_GRO then that's of course
> > the least friction solution here.
>
> Yes, it would avoid whitelisting new specific usecases.
>
> metze
>
>
