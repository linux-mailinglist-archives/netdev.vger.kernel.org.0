Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A681D5F83
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 10:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgEPIFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 04:05:21 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:42295 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgEPIFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 04:05:18 -0400
Received: from mail-qt1-f169.google.com ([209.85.160.169]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MOzKm-1jjnzE1jmG-00PLfI; Sat, 16 May 2020 10:05:16 +0200
Received: by mail-qt1-f169.google.com with SMTP id l1so4048449qtp.6;
        Sat, 16 May 2020 01:05:16 -0700 (PDT)
X-Gm-Message-State: AOAM532VibKF4/2/BF6/1duo02ZNy9/sYzv0Xb1UmSyVhdTnzJqWN7rh
        idN0POucJzbMeRxBjhbMqDuDk/Iq7vjDX71EkvQ=
X-Google-Smtp-Source: ABdhPJzct24g4mpN9gpM4i7DaXHCW2Xqi8zVHyBRMbDZ7Puz/Cm9d+otXgxqxSRnTqKcQF3dvBXbvx/icBjJxPlrxS4=
X-Received: by 2002:aed:2441:: with SMTP id s1mr7403983qtc.304.1589616315121;
 Sat, 16 May 2020 01:05:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200512174607.9630-1-anders.roxell@linaro.org>
 <CAADnVQK6cka9i_GGz3OcjaNiEQEZYwgCLsn-S_Bkm-OWPJZb_w@mail.gmail.com>
 <alpine.LRH.2.21.2005141243120.53197@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
 <CAADnVQJRsknY7+3zwXR-N4e6oC6E87Z32Msg4EXaM8iyB=R3qQ@mail.gmail.com> <CAADnVQ+WXa62R6A=nk1kOTbX8MqkbMEKDx=5KCdx5Th0NnFm7Q@mail.gmail.com>
In-Reply-To: <CAADnVQ+WXa62R6A=nk1kOTbX8MqkbMEKDx=5KCdx5Th0NnFm7Q@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 16 May 2020 10:04:58 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3CBtitXnzQf3gLx4mXuvDoVZiwwi33iCDNvtG-0jBSwQ@mail.gmail.com>
Message-ID: <CAK8P3a3CBtitXnzQf3gLx4mXuvDoVZiwwi33iCDNvtG-0jBSwQ@mail.gmail.com>
Subject: Re: [PATCH] security: fix the default value of secid_to_secctx hook
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     James Morris <jamorris@linux.microsoft.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:AqpyKWFvkSAq/chYHJ1S6aFi63tGfszEKAkHOotjMzvBtowJs6y
 C227rx/0GQGqSl/wm//F/dud78C3k6WYyTK4jUqeqlxG5GJlfhTN6Y65xq4I9Xjvh9WOhQR
 81VKpJrO2VMsFnskPWf43X/PPjtfo0sgKhjgoAahIiZhGvSWXUCuSXPKxc4n7NEq/XM/MiT
 AiveJ68sn0EJGq+FXljGw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Ef8iDSEESXM=:AizQ6/FlKghmVlvGaER7GE
 taNsyzHdlicKO3ETUrtIfcTFHlMLpZGKVHPJqeFMg6xIO8lgff272vptSiiEt0ojTKxkySzvC
 HD61gLRc/RcI4gQIswx/k0QjpXz8X1uQsY1GArObaWZweKr9gE3uexcY+LPxTQzGvnff/vBeD
 xiVu2nv6lEjZiTFJ1nTxO8RPwTmC7CDGavazirOzfdFwq2VDoypGXsQojbhWISvUYL0RG3MiN
 1TxxEGIO/aNtlxrhHGBcvQl5yUcFtmK0lCR69Y1MJXzVBFf5zzKwf0y2yDe4C/GKmDuyR4rax
 OjZbOhdo3p95DH90gIU87itdsMPiet5kpm32xT0k13S+kw90eGp6ZCgPZ3uR2q/agm/5fCOQF
 HCNt3gH2TZma6rSVAXQ5gbtjdktmP1y9JoxUSkb90e+59+Ru3PKGdDSLmFDHs4RXX7sSW523e
 6r2Q0STGhNvNYiDmK2k6g0d+OC1tdLrUCFNCsiPkwNw2snXBSTwB6IqKMuUujNID6eky/5CT+
 D96AKhP6PvgS3YvLvT3ie2YUMXf2rUzH5yk1WLjDSECeLvI3Ofnc8i8Eo0rxDJrZ9nDJZltX2
 OE1sw5H6FKMpckB0Xsk55/uB/AKz17tx9RxTKk4JDobDugC/crG3Y96n9y7kKkApQyoty3PWv
 fdO0thGG/W3ZYXZFUQDgdCouosXQ+vY4Lsnnx6KBvczIoBIgMZv8JOW4lvFCbuC4EW4wU1iGk
 aCHyDK11JggIFBJL9wnEWE8Ymb71DpBjfyd/CsJ6WqSyOF2sES/i5p1rdcZvx7UV+9ChFS0Ga
 uI7uZsUq2lM59TDHVYh5Z4cc6y8+0TRJKuMAtlNpp+2PWiJSOw=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 16, 2020 at 1:29 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, May 14, 2020 at 12:47 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, May 14, 2020 at 12:43 PM James Morris
> > <jamorris@linux.microsoft.com> wrote:
> > >
> > > On Wed, 13 May 2020, Alexei Starovoitov wrote:
> > >
> > > > James,
> > > >
> > > > since you took the previous similar patch are you going to pick this
> > > > one up as well?
> > > > Or we can route it via bpf tree to Linus asap.
> > >
> > > Routing via your tree is fine.
> >
> > Perfect.
> > Applied to bpf tree. Thanks everyone.
>
> Looks like it was a wrong fix.
> It breaks audit like this:
> sudo auditctl -e 0
> [   88.400296] audit: error in audit_log_task_context
> [   88.400976] audit: error in audit_log_task_context
> [   88.401597] audit: type=1305 audit(1589584951.198:89): op=set
> audit_enabled=0 old=1 auid=0 ses=1 res=0
> [   88.402691] audit: type=1300 audit(1589584951.198:89):
> arch=c000003e syscall=44 success=yes exit=52 a0=3 a1=7ffe42a37400
> a2=34 a3=0 items=0 ppid=2250 pid=2251 auid=0 uid=0 gid=0 euid=0 suid=0
> fsuid=0 egid=0 sgid=0 fsgid=0 tty=ttyS0 se)
> [   88.405587] audit: type=1327 audit(1589584951.198:89):
> proctitle=617564697463746C002D650030
> Error sending enable request (Operation not supported)
>
> when CONFIG_LSM= has "bpf" in it.

Do you have more than one LSM enabled? It looks like
the problem with security_secid_to_secctx() is now that it
returns an error if any of the LSMs fail and the caller expects
it to succeed if at least one of them sets the secdata pointer.

The problem earlier was that the call succeeded even though
no LSM had set the pointer.

What is the behavior we actually expect from this function if
multiple LSM are loaded?

       Arnd
