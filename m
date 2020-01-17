Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57C4E1402BF
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 05:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730400AbgAQEDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 23:03:08 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34182 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729130AbgAQEDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 23:03:07 -0500
Received: by mail-lj1-f195.google.com with SMTP id z22so25012411ljg.1;
        Thu, 16 Jan 2020 20:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2qrl+j6DERXl1/dt16MS5ePfNi/65p8mG5jAoiX3ros=;
        b=NmECmhm3ulv84HxSYBfXaWloo5bGo4yZowRYnfRP3MNYrnh3X5DoDv681F80GLfSva
         4W+TjN2HivYjXMpfTJOmo38CRsIDSB49aMfwA5m2Fh7mEVVSZelWZDCBo9NGb313Bj2H
         3hPWU1vqMroA1+myPyzdhMPSKjNZ0hdJp7TXSbMOD0r/nfi6PjR7eJOzTU1P6vnzrEtZ
         LLqT5dxk3Y26j+faRCfT4LABzh3nIc1m84qiIEuKSTE1qnU6kn9Ic4MX4wdIolEF+jHG
         Qxt8xlfXEOhAtaIzAdAr0CUwu8CvTuJCqOiaxKzRpPgsFAgcmW8j+LUmv+eu/Lc24m8G
         PxBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2qrl+j6DERXl1/dt16MS5ePfNi/65p8mG5jAoiX3ros=;
        b=HRICgyCKtUDMF0ZU91usiOrOcoNPE7kTDx3H12F2yAdarz+MhnhMIcoSZBQplkLUEg
         rJWCtasVpN6hs88Cd8DR4pzk40QeO3sbog/3Tjn40NGWh156iQnZrXfMD51WS3pSjnfA
         xKHFo5CEANSwF3oJrjRgcUvMJaZjl9j7r69PTzvUk8H6YLrfGmcVbVoULiN1d/5FKUqT
         wKUWfySBS2hhSlHJSP/aClIf1I4ji88OvQrJQXBTSxDXjdLNqdFw/t3pWWTd0WZDPGOR
         4k7LQJ0QoUvn7viUFFFuteEgUJVGnJ+4CeasKg+18tXh6MdyxMZ327bbYGdVloY+rDYe
         JW2g==
X-Gm-Message-State: APjAAAWMTSy2lBc9SHLfaStBCHeIJ3BAYq/KqBe0YkJa3XrriKmJPUlW
        MUKCQngC78cpGKA5rRme7lYgO+A1LHPF7p8fUBw=
X-Google-Smtp-Source: APXvYqyAQI4n7N1An3pzSYeQW4EjoTPS6f5tBzeEG/v72r7VYr47RwPU6Eb8eh25BP3UhyGkIyyNIjXMM7jBQ5eqqAg=
X-Received: by 2002:a2e:58c:: with SMTP id 134mr4410026ljf.12.1579233785193;
 Thu, 16 Jan 2020 20:03:05 -0800 (PST)
MIME-Version: 1.0
References: <20200117004103.148068-1-andriin@fb.com>
In-Reply-To: <20200117004103.148068-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 16 Jan 2020 20:02:53 -0800
Message-ID: <CAADnVQKOeqWhhs40zpGAa5t5Ms8bT4QLwWOoJSP2LZ+TNuP1Xg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: revert bpf_helper_defs.h inclusion regression
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 7:52 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Revert bpf_helpers.h's change to include auto-generated bpf_helper_defs.h
> through <> instead of "", which causes it to be searched in include path.=
 This
> can break existing applications that don't have their include path pointi=
ng
> directly to where libbpf installs its headers.
>
> There is ongoing work to make all (not just bpf_helper_defs.h) includes m=
ore
> consistent across libbpf and its consumers, but this unbreaks user code a=
s is
> right now without any regressions. Selftests still behave sub-optimally
> (taking bpf_helper_defs.h from libbpf's source directory, if it's present
> there), which will be fixed in subsequent patches.
>
> Fixes: 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.h are taken f=
rom selftests dir")
> Reported-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
