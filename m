Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E613D87B9
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 08:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbhG1GOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 02:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232985AbhG1GOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 02:14:05 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC36C061757;
        Tue, 27 Jul 2021 23:14:04 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ds11-20020a17090b08cbb0290172f971883bso8447399pjb.1;
        Tue, 27 Jul 2021 23:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HFtqBh3AzPDg30WEMBgyL27C+XnWPP05l4OdVS5va+k=;
        b=EVtXQu4G5iBgujHQWxFLU2Ir7PB69hHsT5LXrFODAmTNTHbNyySb+wca4uHFE63MfG
         cZwxRyOgwtp2v0xWu+UjXLh7EqUPIcXlHwsg/mg5fM1Mbbgr/hy0ousG9N10ySP5Sipd
         eRcZXW4qVpOi7nMrTbv1kavI1e7NSMckZjBaFPiaWtxVTuT7fV26oON+owZtA6SQXvoo
         8D0YRfDzIZE0bwuQo25Ak4GmYH+HOZB777WrDRuOhxr71lKwRP7RL5bZipY9DsuIUSLT
         z8ZmBxwPbyXLByN+KleRtIBMMzASvK7bqK0lcKG0LuyXHB6LS3nXEryvWuKfNb0gE1xs
         IYBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HFtqBh3AzPDg30WEMBgyL27C+XnWPP05l4OdVS5va+k=;
        b=jgHkiNscivGsTLzhYABmvU0aKi+Ux54kslfrezL3YFtlWUbz9xB28ttgn8FRDBY8IZ
         rtfHgNhjPVkImWfowWn2QfSe0rbpCSfX/qBDcuL2qqfDVCWCmswL60AYkWjArnqoykSM
         6M8nm+WiyWKDegGaKW7bhLq5KDAeGERerwtXURSyXG5iQzh7eWdVDbVE/G4iRFuTGFX8
         3QxH5b8sElQJoaanNPHi59b5aveoJDeQkgb/OoI/QHa4Vo3z7E1XlPuNTN/Wg1Qj6x9h
         NvrZ1a+xdqHR5B4DxCaWTq2OipMWl/Y/9xEstksfT/yydg2/F6s5Lzo2yX1h3UhJOa5C
         VWtg==
X-Gm-Message-State: AOAM530T2N7lx+4Zhc0FTHq6EuBTASWZO/PA7jouotj7aUxJerpFumpx
        ay0Tn3v4Vhzh8JGdDV5BSAGHrKic6zx8RMmmeBk=
X-Google-Smtp-Source: ABdhPJwQtqTMPkc66YW7IA7vch37TNRJpgC4mzcBMH64oG0GKCXmPSgQzBmi2xEbjSH3FcFLNMQ7KLPImi9ZsqwRRog=
X-Received: by 2002:a17:90a:d58f:: with SMTP id v15mr7937074pju.117.1627452844205;
 Tue, 27 Jul 2021 23:14:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210727131753.10924-1-magnus.karlsson@gmail.com>
 <20210727131753.10924-5-magnus.karlsson@gmail.com> <8d3d2bdb-3750-80dd-3874-def189e0e51f@fb.com>
In-Reply-To: <8d3d2bdb-3750-80dd-3874-def189e0e51f@fb.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 28 Jul 2021 08:13:53 +0200
Message-ID: <CAJ8uoz3=J8V-frhiSvP6OrYqkrsSY0n3ZrQT5ALxU4w3aCzGvQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 04/17] selftests: xsk: set rlimit per thread
To:     Yonghong Song <yhs@fb.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Ciara Loftus <ciara.loftus@intel.com>,
        Jussi Maki <joamaki@gmail.com>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 8:39 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/27/21 6:17 AM, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Set rlimit per thread instead of on the main thread. The main thread
> > does not register any umem area so do not need this.
>
> I think setrlimit() is per process. Did I miss anything?

No, you are correct. I must have gotten confused by the heat or
something. Will remove this patch from the set.

Thanks!

> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >   tools/testing/selftests/bpf/xdpxceiver.c | 9 +++++----
> >   1 file changed, 5 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> > index 4d8ee636fc24..2100ab4e58b7 100644
> > --- a/tools/testing/selftests/bpf/xdpxceiver.c
> > +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> > @@ -252,6 +252,7 @@ static void gen_eth_frame(struct xsk_umem_info *umem, u64 addr)
> >
> >   static void xsk_configure_umem(struct ifobject *data, void *buffer, int idx)
> >   {
> > +     const struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
> >       struct xsk_umem_config cfg = {
> >               .fill_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
> >               .comp_size = XSK_RING_CONS__DEFAULT_NUM_DESCS,
> > @@ -263,6 +264,10 @@ static void xsk_configure_umem(struct ifobject *data, void *buffer, int idx)
> >       struct xsk_umem_info *umem;
> >       int ret;
> >
> > +     ret = XSK_UMEM__DEFAULT_FRAME_SIZE;
> > +     if (setrlimit(RLIMIT_MEMLOCK, &_rlim))
> > +             exit_with_error(errno);
> > +
> >       umem = calloc(1, sizeof(struct xsk_umem_info));
> >       if (!umem)
> >               exit_with_error(errno);
> > @@ -1088,13 +1093,9 @@ static void run_pkt_test(int mode, int type)
> >
> >   int main(int argc, char **argv)
> >   {
> > -     struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
> >       bool failure = false;
> >       int i, j;
> >
> > -     if (setrlimit(RLIMIT_MEMLOCK, &_rlim))
> > -             exit_with_error(errno);
> > -
> >       for (int i = 0; i < MAX_INTERFACES; i++) {
> >               ifdict[i] = malloc(sizeof(struct ifobject));
> >               if (!ifdict[i])
> >
