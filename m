Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62E723C807
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 10:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgHEIpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 04:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727808AbgHEIpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 04:45:07 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5768FC061757
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 01:45:07 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id a1so573352vsp.4
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 01:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o5bGfUkI0TnoG29U72+wYqyFdj5RODR1Ju6c+jix9G0=;
        b=kf0kPEaVVqjO+tibXO/BrYddVQyTvWLUZ/24XavuNmMYdFT6EOU3UN6FYcxjZH3qwW
         1NbL1hXeQvxv2HC+PZC40EULkvoRbTkdfu79/p4gZo3AqKSYl/VdcCXLKnTF0O8CDUik
         M8vI9JmDpxfYcDW8JwkO/EsjsgLg1exmXaBS4VAWQdLepewlrOqU0uqSvBzuO4oav4ZR
         /KZl/mgrSgkP1i0KZ8pZieCtdscu2Mbt/6Olxe8dZTpGEJmQiS5iiTUKlUXMwpH0BkQj
         0KouMItchhDfWeLk4CZlydh7yomaBu6t4nqtICtNGC+uhuVoorrA29jAEIlONK9OAL2T
         fIvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o5bGfUkI0TnoG29U72+wYqyFdj5RODR1Ju6c+jix9G0=;
        b=JI28k4MvnVXfhJ5XZ7YdqE4pHXLNk9j3Dr/04YxxS+oDXB0MqF+MAB3CgR2/izseQc
         /HMbLISLMj+UcicNL8nPESzIbQT6oxEgBCadTKeuc9NN/9fQXlgU4ugnFJ8zchCZm19A
         iuFxCfxVuZ54ZPaCHb/x8xkD5ExZVwdM3MqZ8e4qk0scgdWsVU8OCVWqu1tGzkHmU4hP
         tnavHpH0cx0e6hVGEiQaRV3PZyAGqGrVEFHrhnhaMyeU2iRoydYeAkgmEWUI3hdb+5FS
         SG1kdN+couldjnenkbbPjCZOFFTeikpfRCf4Lt5BEIysm9g7sed0s34e4AngjDksh5Kf
         lT5A==
X-Gm-Message-State: AOAM530sCOdrjURp4uv327nbjHQwkkST87Yeijij36PJCiQDlM6fI+rY
        oKtvb4rWnejoqAz4rTSzGnY1yEa7hWE=
X-Google-Smtp-Source: ABdhPJyjnkVSN8bnmIDjsePNqAtuFV8oAddc2cmsmcVHgupwvdwk0+KJHVPk8RqFdj1zpCfYbXbF/Q==
X-Received: by 2002:a05:6102:30ba:: with SMTP id y26mr1075103vsd.122.1596617105698;
        Wed, 05 Aug 2020 01:45:05 -0700 (PDT)
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com. [209.85.222.43])
        by smtp.gmail.com with ESMTPSA id m139sm266008vke.28.2020.08.05.01.45.04
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 01:45:04 -0700 (PDT)
Received: by mail-ua1-f43.google.com with SMTP id y17so7528763uaq.6
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 01:45:04 -0700 (PDT)
X-Received: by 2002:ab0:242:: with SMTP id 60mr1283334uas.37.1596617104040;
 Wed, 05 Aug 2020 01:45:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200804123012.378750-1-colin.king@canonical.com>
 <b99004ea-cd9d-bec3-5f9f-82dcb00a6284@gmail.com> <CA+FuTSd9K+s1rXUFpb_RWEC-uAgwU1Vz44zaUPaZK0cfsX4kwA@mail.gmail.com>
 <fc66cf3c-b4be-f098-3a2b-aef36b90835d@canonical.com>
In-Reply-To: <fc66cf3c-b4be-f098-3a2b-aef36b90835d@canonical.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 5 Aug 2020 10:44:27 +0200
X-Gmail-Original-Message-ID: <CA+FuTSfVOPiiBi2AcyiyNHoOpbKg4dPWCNvjg=-UuP+GA2c5FA@mail.gmail.com>
Message-ID: <CA+FuTSfVOPiiBi2AcyiyNHoOpbKg4dPWCNvjg=-UuP+GA2c5FA@mail.gmail.com>
Subject: Re: [PATCH] selftests/net: skip msg_zerocopy test if we have less
 than 4 CPUs
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 5, 2020 at 10:22 AM Colin Ian King <colin.king@canonical.com> wrote:
>
> On 05/08/2020 09:06, Willem de Bruijn wrote:
> > On Wed, Aug 5, 2020 at 2:54 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >>
> >>
> >>
> >> On 8/4/20 5:30 AM, Colin King wrote:
> >>> From: Colin Ian King <colin.king@canonical.com>
> >>>
> >>> The current test will exit with a failure if it cannot set affinity on
> >>> specific CPUs which is problematic when running this on single CPU
> >>> systems. Add a check for the number of CPUs and skip the test if
> >>> the CPU requirement is not met.
> >>>
> >>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> >>> ---
> >>>  tools/testing/selftests/net/msg_zerocopy.sh | 5 +++++
> >>>  1 file changed, 5 insertions(+)
> >>>
> >>> diff --git a/tools/testing/selftests/net/msg_zerocopy.sh b/tools/testing/selftests/net/msg_zerocopy.sh
> >>> index 825ffec85cea..97bc527e1297 100755
> >>> --- a/tools/testing/selftests/net/msg_zerocopy.sh
> >>> +++ b/tools/testing/selftests/net/msg_zerocopy.sh
> >>> @@ -21,6 +21,11 @@ readonly DADDR6='fd::2'
> >>>
> >>>  readonly path_sysctl_mem="net.core.optmem_max"
> >>>
> >>> +if [[ $(nproc) -lt 4 ]]; then
> >>> +     echo "SKIP: test requires at least 4 CPUs"
> >>> +     exit 4
> >>> +fi
> >>> +
> >>>  # No arguments: automated test
> >>>  if [[ "$#" -eq "0" ]]; then
> >>>       $0 4 tcp -t 1
> >>>
> >>
> >> Test explicitly uses CPU 2 and 3, right ?
> >>
> >> nproc could be 500, yet cpu 2 or 3 could be offline
> >>
> >> # cat /sys/devices/system/cpu/cpu3/online
> >> 0
> >> # echo $(nproc)
> >> 71
> >
> > The cpu affinity is only set to bring some stability across runs.
> >
> > The test does not actually verify that a run with zerocopy is some
> > factor faster than without, as that factor is hard to choose across
> > all platforms. As a result the automated run mainly gives code coverage.
> >
> > It's preferable to always run. And on sched_setaffinity failure log a
> > message about possible jitter and continue. I can send that patch, if
> > the approach sounds good.
> >
> That's sounds preferable to my bad fix for sure :-)

Certainly not a bad fix! Thanks for addressing the issue. Alternative
approach at

http://patchwork.ozlabs.org/project/netdev/patch/20200805084045.1549492-1-willemdebruijn.kernel@gmail.com/
