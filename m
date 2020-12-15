Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5C92DABA5
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 12:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgLOLIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 06:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727637AbgLOLHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 06:07:50 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38867C0617A7
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 03:07:10 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id i18so20070261ioa.1
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 03:07:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=u7OGLhVMk80LTR4TV6/rL/KwLoi/lgU79kWXGcf0/qA=;
        b=rOHvA/EmGE9oY15EnEfy3yibHMQtHw4VCkiMzlcB3W/HjvaBOdWbLGTsB0iJ9CCfhu
         G73vl3/h35BbCR0UyvXKLecANslGqKzsWh8HaptT34l/O+Q4t/tC03IcDbADb4TAwMmy
         PuSvs7RTrU9/jRcZLc3AplgFpbGsiZOBIYskx/4I5hs6CXdxzisn92ybidEPD5t2DReB
         ySrcUzstvViaxWvbcWXvGJdbuOGzATZyYG6x4OGbXOc0xofCr8g4IAQ+XA1yii0XHpgb
         EEOZEzzUEgxXo/DubpixjeQOR9OghcVxk9Sfr/LR7esaKyy9adXK+8NO11QC3WHkzP7I
         VWgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=u7OGLhVMk80LTR4TV6/rL/KwLoi/lgU79kWXGcf0/qA=;
        b=Dv00M5lFQiQzZMMAXQoUHO8orwd/vbctseX6gOr30YP6CbXXSQIUSiZIYkpsBQSLLv
         lBSUn5GZLLzOQkztcvRrbYWMBc3P1zD8Kl/q9iDYkl6jd8mFfTwR3Cm0f9ZlTkDpLLEm
         +isGY3xc4C6/R/fo+A5OEYAUZTcntt4SOAZH70EB/tf6gNW6e54SWMWay3/rQOoiUgBo
         dkz0UOX2+iTiGHgehUsAfJt1wZCfch5NsFXDFlibjUFZoj05k/MWm3nIskIFltdYYncU
         yiVn6UqeM7QEJYIg3xHCo0P1u76gQ0Utjhrz68xgjEDNIf/Qr7biBgNwY1bstENN7cFp
         retw==
X-Gm-Message-State: AOAM532cwHt+BSEgt7bLiPFlZcKJaa7MPCdyM/y0vBgsNcOfzttILtEK
        5edxWMEtpxkzJ5R/d0iSaBLhmekfoKmb/VKlwE+bXg==
X-Google-Smtp-Source: ABdhPJxYyF+7vR9iFg61bX8i74sCvY88+pIMJQ4lEuKnlT0PD33amw5foxqGB5hg74PKVgOX1spczyyycnJd8qlpPc8=
X-Received: by 2002:a02:b60a:: with SMTP id h10mr17694639jam.99.1608030429239;
 Tue, 15 Dec 2020 03:07:09 -0800 (PST)
MIME-Version: 1.0
References: <20201208091910.37618-1-cambda@linux.alibaba.com>
 <20201212143259.581aadae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <25F89086-3260-48BD-BD69-CCE04821CAE4@linux.alibaba.com> <20201214180840.601055a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201214180840.601055a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 15 Dec 2020 12:06:57 +0100
Message-ID: <CANn89i+=QRibXsm6tw-eVwhB3wjOtgF-MtVu0G--K5=oWP97+A@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Limit logical shift left of TCP probe0 timeout
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Cambda Zhu <cambda@linux.alibaba.com>,
        netdev <netdev@vger.kernel.org>,
        Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 3:08 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 13 Dec 2020 21:59:45 +0800 Cambda Zhu wrote:
> > > On Dec 13, 2020, at 06:32, Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Tue,  8 Dec 2020 17:19:10 +0800 Cambda Zhu wrote:
> > >> For each TCP zero window probe, the icsk_backoff is increased by one=
 and
> > >> its max value is tcp_retries2. If tcp_retries2 is greater than 63, t=
he
> > >> probe0 timeout shift may exceed its max bits. On x86_64/ARMv8/MIPS, =
the
> > >> shift count would be masked to range 0 to 63. And on ARMv7 the resul=
t is
> > >> zero. If the shift count is masked, only several probes will be sent
> > >> with timeout shorter than TCP_RTO_MAX. But if the timeout is zero, i=
t
> > >> needs tcp_retries2 times probes to end this false timeout. Besides,
> > >> bitwise shift greater than or equal to the width is an undefined
> > >> behavior.
> > >
> > > If icsk_backoff can reach 64, can it not also reach 256 and wrap?
> >
> > If tcp_retries2 is set greater than 255, it can be wrapped. But for TCP=
 probe0,
> > it seems to be not a serious problem. The timeout will be icsk_rto and =
backoff
> > again. And considering icsk_backoff is 8 bits, not only it may always b=
e lesser
> > than tcp_retries2, but also may always be lesser than tcp_orphan_retrie=
s. And
> > the icsk_probes_out is 8 bits too. So if the max_probes is greater than=
 255,
> > the connection won=E2=80=99t abort even if it=E2=80=99s an orphan sock =
in some cases.
> >
> > We can change the type of icsk_backoff/icsk_probes_out to fix these pro=
blems.
> > But I think maybe the retries greater than 255 have no sense indeed and=
 the RFC
> > only requires the timeout(R2) greater than 100s at least. Could it be b=
etter to
> > limit the min/max ranges of their sysctls?
>
> All right, I think the patch is good as is, applied for 5.11, thank you!

It looks like we can remove the (u64) casts then.

Also if we _really_ care about icsk_backoff approaching 63, we also
need to change inet_csk_rto_backoff() ?

Was your patch based on a real world use, or some fuzzer UBSAN report ?

diff --git a/include/net/inet_connection_sock.h
b/include/net/inet_connection_sock.h
index 7338b3865a2a3d278dc27c0167bba1b966bbda9f..a2a145e3b062c0230935c293fc1=
900df095937d4
100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -242,9 +242,10 @@ static inline unsigned long
 inet_csk_rto_backoff(const struct inet_connection_sock *icsk,
                     unsigned long max_when)
 {
-        u64 when =3D (u64)icsk->icsk_rto << icsk->icsk_backoff;
+       u8 backoff =3D min_t(u8, 32U, icsk->icsk_backoff);
+       u64 when =3D (u64)icsk->icsk_rto << backoff;

-        return (unsigned long)min_t(u64, when, max_when);
+       return (unsigned long)min_t(u64, when, max_when);
 }

 struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool ke=
rn);
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 78d13c88720fda50e3f1880ac741cea1985ef3e9..fc6e4d40fd94a717d24ebd8aef7=
f7930a4551fe9
100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1328,9 +1328,8 @@ static inline unsigned long
tcp_probe0_when(const struct sock *sk,
 {
        u8 backoff =3D min_t(u8, ilog2(TCP_RTO_MAX / TCP_RTO_MIN) + 1,
                           inet_csk(sk)->icsk_backoff);
-       u64 when =3D (u64)tcp_probe0_base(sk) << backoff;

-       return (unsigned long)min_t(u64, when, max_when);
+       return min(tcp_probe0_base(sk) << backoff, max_when);
 }

 static inline void tcp_check_probe_timer(struct sock *sk)
