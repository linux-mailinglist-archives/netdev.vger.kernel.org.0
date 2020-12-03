Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C472CCFE3
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 07:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgLCGy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 01:54:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgLCGy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 01:54:57 -0500
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D35FC061A4D;
        Wed,  2 Dec 2020 22:54:17 -0800 (PST)
Received: by mail-oo1-xc41.google.com with SMTP id l10so277966ooh.1;
        Wed, 02 Dec 2020 22:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X1l/f2x//rkF0gR6REiziKpvyYPMdtiC0VlBvu6kIQw=;
        b=UsLSfbj/b1BIE0GZj9LX1OlogLEBEzLzAbX04SBkuve6l/RvR80GVIGr/46nsS7dx9
         sucQrKuFhviZmO1eKfgS3Xv5QsisR7f4YyCSrLV6/7gSUxcBQWP+7snjj80X5I176agE
         O12pTM1PIPDUVj3rgzvT2ENKkiKKGvpmUFbAX9D5OYE3hFodS8wBhYvFQf09i2Yh3UPq
         Cjx/M2GaIhpODvUobZKP2FaTEf+/BdWmGZ8foZswqii2Y0B2om5buhLmkgIxN5+XCXt0
         6ZTXXw/egYj3JxPCKN1jzRbp4Rz/AYmMwl1tqYMUexN25SqKrjew0lVuGPanj5ijY2aL
         CL0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X1l/f2x//rkF0gR6REiziKpvyYPMdtiC0VlBvu6kIQw=;
        b=rq1vX4tQq3uBVDawXk4vjuZxgGsSM9eVjI/im3orbqmr9Kv7NNIAHPXkxWbjtXgjcq
         lr1EPhkWLgJXjuN3lI/XIxPMAjbl4qxOYWIXT0Rutmjo2bj5WcD3F1w9rbknGT7LwduS
         5RlmpMUKiPhFyqjSxs4w+OVTumZ6Mq+N3cs/lR5Z6yyo+T2ZyBYyelJYKCsl5xqnKcuH
         sak+KbVvOzkVAuXiuBmruv+jg+chRz8by8RRnB+nGIszpms9jsbWdZyGP6aWmOv0WuLD
         EucbF0JXdH0UmMvcvdrOQKRMSQr9mC9iDRDAwJNJezD7qle8iQDbQn4+1ojV+BgZ/oQw
         lR/g==
X-Gm-Message-State: AOAM533905XOi8JL4omLm42UIETMrkU6vGu6BsagHOJyuin3PPErcTgm
        2Gkqi9Is0/5z/6LW4nH8TdWiWuaRB3vNyUAa7U+p3DiKLkoqxdA5
X-Google-Smtp-Source: ABdhPJz3bor/aBc1zwcva1uSZJB29Y/D+3VeQcvWPykt2ZWwPqper6tGSvhcF2RHnTFHAIEzMcff49hUOD2tP7VEjlA=
X-Received: by 2002:a4a:d023:: with SMTP id w3mr1167114oor.23.1606978456476;
 Wed, 02 Dec 2020 22:54:16 -0800 (PST)
MIME-Version: 1.0
References: <20201202103923.12447-1-mariuszx.dudek@intel.com>
 <20201202103923.12447-3-mariuszx.dudek@intel.com> <CAADnVQKorj773WzJLKvLxAXiKNdqr3dTL_A5GLns9FBrZQ5rxQ@mail.gmail.com>
In-Reply-To: <CAADnVQKorj773WzJLKvLxAXiKNdqr3dTL_A5GLns9FBrZQ5rxQ@mail.gmail.com>
From:   Mariusz Dudek <mariusz.dudek@gmail.com>
Date:   Thu, 3 Dec 2020 07:54:04 +0100
Message-ID: <CADm5B_Oyw0W0twccz2kOM96iYrO-PC-f17pX=Jdy8D-0EdD5FA@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 2/2] samples/bpf: sample application for eBPF
 load and socket creation split
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Mariusz Dudek <mariuszx.dudek@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 3, 2020 at 3:50 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Dec 2, 2020 at 2:39 AM <mariusz.dudek@gmail.com> wrote:
> >  int main(int argc, char **argv)
> >  {
> > +       struct __user_cap_header_struct hdr = { _LINUX_CAPABILITY_VERSION_3, 0 };
> > +       struct __user_cap_data_struct data[2] = { { 0 } };
> >         struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
> >         bool rx = false, tx = false;
> >         struct xsk_umem_info *umem;
> >         struct bpf_object *obj;
> > +       int xsks_map_fd = 0;
> >         pthread_t pt;
> >         int i, ret;
> >         void *bufs;
> >
> >         parse_command_line(argc, argv);
> >
> > -       if (setrlimit(RLIMIT_MEMLOCK, &r)) {
> > -               fprintf(stderr, "ERROR: setrlimit(RLIMIT_MEMLOCK) \"%s\"\n",
> > -                       strerror(errno));
> > -               exit(EXIT_FAILURE);
> > +       if (opt_reduced_cap) {
> > +               if (capget(&hdr, data)  < 0)
> > +                       fprintf(stderr, "Error getting capabilities\n");
> > +
> > +               data->effective &= CAP_TO_MASK(CAP_NET_RAW);
> > +               data->permitted &= CAP_TO_MASK(CAP_NET_RAW);
> > +
> > +               if (capset(&hdr, data) < 0)
> > +                       fprintf(stderr, "Setting capabilities failed\n");
> > +
> > +               if (capget(&hdr, data)  < 0) {
> > +                       fprintf(stderr, "Error getting capabilities\n");
> > +               } else {
> > +                       fprintf(stderr, "Capabilities EFF %x Caps INH %x Caps Per %x\n",
> > +                               data[0].effective, data[0].inheritable, data[0].permitted);
> > +                       fprintf(stderr, "Capabilities EFF %x Caps INH %x Caps Per %x\n",
> > +                               data[1].effective, data[1].inheritable, data[1].permitted);
> > +               }
> > +       } else {
> > +               if (setrlimit(RLIMIT_MEMLOCK, &r)) {
> > +                       fprintf(stderr, "ERROR: setrlimit(RLIMIT_MEMLOCK) \"%s\"\n",
> > +                               strerror(errno));
> > +                       exit(EXIT_FAILURE);
> > +               }
>
> Due to this hunk the patch had an unpleasant conflict with Roman's set
> and I had to drop this set from bpf-next.
> Please rebase and resend.
>
> But it made me look into this change...why did you make rlimit conditional here?
> That doesn't look right.

RLIMIT_MEMLOCK was conditioned before, so I didn't change it. It is
not in my branch "if (opt_reduced_cap)" because RLIMIT_MEMLOCK
requires additional CAP_IPC_LOCK and my main task was to made it
possible to use xsk_socket creation and this example with only
CAP_NET_RAW.

As described in the cover letter "In case your umem is larger or equal
process limit for MEMLOCK you need either increase the limit or
CAP_IPC_LOCK capability."
