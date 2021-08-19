Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBE93F1700
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 12:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238302AbhHSKD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 06:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238230AbhHSKDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 06:03:21 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECD3C061756;
        Thu, 19 Aug 2021 03:02:45 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id r2so5413185pgl.10;
        Thu, 19 Aug 2021 03:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p7kWXvSmoloU2K6nNyPWXg8W3dUuuVuFZv9y/d1mgQw=;
        b=G9Wja6RgiNUAVtIfv2DDIZw3ACdbj23CTXFLRWaFiVxK5BxU2YgJHG5WZnh6Fms7UE
         lKcq2oYyOHx7/GW8lonw0o8CpkAdgGOW8o1ck+4rhdSczx5my40A689EFcsu0quxE7EB
         7NR3ycEBhV7Uzu80ldYyH8nOsI8ZLn8fHjJhvwjv3dL3thyt8x4W2WV5U/ls9kKaAE9+
         ypuVtCUsieF2w65nH6bmNoZfOy0K7r5S1TDKdxmeiQ51Oeymr4YTJU3d/8FReJaEPSU4
         K1C+DpGDPCL9erge/3LFFbFxWouOBzFeaXdrBk1U5/yJyHKQHfGgGwz9kH6TnK6R4o94
         AJkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p7kWXvSmoloU2K6nNyPWXg8W3dUuuVuFZv9y/d1mgQw=;
        b=HdH4X1tzQcBPLD59alNqIHDA1NAUNWwrRHdVEa/tBdenmpM6LgCSmi/HZ2XTdoRIjo
         yQwUWdwKxmV/pKlGozyMuYnqXGZrOqPWU59BmPOfX7M1umWNriISX1RD1BQgVYWuovC1
         XiAMDp0Xf7JWCeCsozX44xDUAml7Iha/vOkWHB6rwjAZzDB93/E0m9HmgOG7DWMs2dnr
         cazv133Qg9A1b9NKaGjqYfD3Ma/ae0tpdv9InFJpMXT+7W8/+9BJ1ek43NJZKZs01AfI
         /+ulLRdm5jwtuZTJHUxY2MfwaDmFQTcUN7Qcg1rhSyl5aIcz98Mfu5vRpAncm0KZLJoj
         +Mfw==
X-Gm-Message-State: AOAM532BUrloaH+Yq5A7k/hKPt59j6sveDZYF5Qe2VP7xcIouu3HAkQI
        CfWJhQqjK37rYF8XnQaZIMkJV6NHBB4jueXQCHY=
X-Google-Smtp-Source: ABdhPJzgp15uFC6qWXGQRmrE4V97s6N3Ut8pcqv0PCbmSu2gJE3avmuSNLyV3HL9tsVKWPlb6/ez9D2baiuRpGQDzUY=
X-Received: by 2002:a65:63c2:: with SMTP id n2mr13612758pgv.292.1629367364712;
 Thu, 19 Aug 2021 03:02:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210817092729.433-1-magnus.karlsson@gmail.com>
 <20210817092729.433-13-magnus.karlsson@gmail.com> <20210819092849.GB32204@ranger.igk.intel.com>
In-Reply-To: <20210819092849.GB32204@ranger.igk.intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 19 Aug 2021 12:02:33 +0200
Message-ID: <CAJ8uoz28+uM9OMq0JKi2bOXR0F9E66LFuYahnTMUaxnRJDtRMQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 12/16] selftests: xsk: remove cleanup at end
 of program
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Ciara Loftus <ciara.loftus@intel.com>,
        bpf <bpf@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 11:43 AM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Tue, Aug 17, 2021 at 11:27:25AM +0200, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Remove the cleanup right before the program/process exits as this will
> > trigger the cleanup without us having to write or maintain any
> > code. The application is not a library, so let us benefit from that.
>
> Not a fan of that, I'd rather keep things tidy, but you're right that
> dropping this logic won't hurt us.

My strategy here was that all functions should clean up themselves and
be tidy, the exception to that being the main function as if it
exists, the program is gone and libc will clean up the allocations for
us. Maybe a bit pragmatic, but I do prefer less code in this case. On
the other hand,
I do not have any strong objections to keeping the code. Just think it
is unnecessary. But if we hide the allocations in a function, then I
would need to deallocate them later for it to look clean (according to
the above logic). Maybe that will improve readabilty. Will try it out.

/Magnus

> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >  tools/testing/selftests/bpf/xdpxceiver.c | 29 +++++-------------------
> >  1 file changed, 6 insertions(+), 23 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> > index 8ff24472ef1e..c1bb03e0ca07 100644
> > --- a/tools/testing/selftests/bpf/xdpxceiver.c
> > +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> > @@ -1041,28 +1041,24 @@ static void run_pkt_test(int mode, int type)
> >  int main(int argc, char **argv)
> >  {
> >       struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
> > -     bool failure = false;
> >       int i, j;
> >
> >       if (setrlimit(RLIMIT_MEMLOCK, &_rlim))
> >               exit_with_error(errno);
> >
> > -     for (int i = 0; i < MAX_INTERFACES; i++) {
> > +     for (i = 0; i < MAX_INTERFACES; i++) {
> >               ifdict[i] = malloc(sizeof(struct ifobject));
> >               if (!ifdict[i])
> >                       exit_with_error(errno);
> >
> >               ifdict[i]->ifdict_index = i;
> >               ifdict[i]->xsk_arr = calloc(2, sizeof(struct xsk_socket_info *));
> > -             if (!ifdict[i]->xsk_arr) {
> > -                     failure = true;
> > -                     goto cleanup;
> > -             }
> > +             if (!ifdict[i]->xsk_arr)
> > +                     exit_with_error(errno);
> > +
> >               ifdict[i]->umem_arr = calloc(2, sizeof(struct xsk_umem_info *));
> > -             if (!ifdict[i]->umem_arr) {
> > -                     failure = true;
> > -                     goto cleanup;
> > -             }
> > +             if (!ifdict[i]->umem_arr)
> > +                     exit_with_error(errno);
> >       }
> >
> >       setlocale(LC_ALL, "");
> > @@ -1081,19 +1077,6 @@ int main(int argc, char **argv)
> >               }
> >       }
> >
> > -cleanup:
> > -     for (int i = 0; i < MAX_INTERFACES; i++) {
> > -             if (ifdict[i]->ns_fd != -1)
> > -                     close(ifdict[i]->ns_fd);
> > -             free(ifdict[i]->xsk_arr);
> > -             free(ifdict[i]->umem_arr);
> > -             free(ifdict[i]);
> > -     }
> > -
> > -     if (failure)
> > -             exit_with_error(errno);
> > -
> >       ksft_exit_pass();
> > -
> >       return 0;
> >  }
> > --
> > 2.29.0
> >
