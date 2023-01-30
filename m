Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82ECC681FD6
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 00:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjA3Xp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 18:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjA3Xpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 18:45:55 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCF92B610;
        Mon, 30 Jan 2023 15:45:53 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id m8so3525515edd.10;
        Mon, 30 Jan 2023 15:45:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=K9VOT142oF1CR1Ax5dNwKVoSH2mYxiMG43ulowgTfdM=;
        b=ifmLcLYLQjQQls0ws954fkLlIyYomtftNUNRivmMHoFEjzo+JOMGe2dk1q9S/UWfNx
         amGL6PWdYFEnpHjeZHwfGrrJSQIK09s41CP1XPxSSrZ099s519ePBt1PZ8LwuGp7IFwV
         ctQ0QhaeWJzwwijBriFIrkaI0alDLmw/rTWOwmy50t+AFzdjz3Fe54L2638LKDJdTzvm
         +l6AZRXTh3JcmsM+HZr7bLe6ewZSiiNes0GXVT2ha7nu6d0PROs03px5MJlvGwIaKlne
         DIoQ4xB/hylrT0L2uhOq9D5eeOnfNJ3CJFYg0IlkecGTB/NpkTwdsJFjyGyhWMpeiwr3
         lmkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K9VOT142oF1CR1Ax5dNwKVoSH2mYxiMG43ulowgTfdM=;
        b=tvcML2QlqW8uH5TVFO8j04zaVgNIJbaW3WprRM2ylLNMspaLGd6aQ3UAOMXlh9SICO
         Jfqy8+lrGEUUXmTQyDQbneQ6QXRdKhignwmGlJm+QSKgp3V8BKi7Vaz4VNYoAmH7cMH0
         TuJtKCfbla4+9KwuNWOqN1t83c3I0sY5ppn77sDNytEN4C7CljJuVzhAzmfWauoePATu
         DBh2IHkvwq2FdNJThTDGHizQcBEkh9QjjsF3bEDfF71RFA08XBDpXwEQ8W4ImIY9iQ4u
         QtDY9pE9K6/aI2+ceA8DlHsbHWWR/K1GaUJfwXhU1No3LLuyx1OEMqIhQvf0qK/thnbY
         twUg==
X-Gm-Message-State: AFqh2kqh+3lV+R8AIw2TZWwSzoKoWzIyctqlAuQUAOk/ToIT36h03a6i
        +DLsZp9Nn56gLgn/CWCycep1i29cdRid8mOfiJL6HhjX
X-Google-Smtp-Source: AMrXdXsMszPcJ+OGXCw+F0NthlgRQBnBUZoZJBZ1wp3U+BMzxLaDjnqsjok0Dp4PZDTCCsaTSihjgsHbokVoXVEJmIE=
X-Received: by 2002:a50:a44e:0:b0:49e:36d1:16e with SMTP id
 v14-20020a50a44e000000b0049e36d1016emr10053591edb.42.1675122351676; Mon, 30
 Jan 2023 15:45:51 -0800 (PST)
MIME-Version: 1.0
References: <20230127135755.79929-1-mathieu.desnoyers@efficios.com> <560824bd-da2d-044c-4f71-578fc34a47cd@linuxfoundation.org>
In-Reply-To: <560824bd-da2d-044c-4f71-578fc34a47cd@linuxfoundation.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 30 Jan 2023 15:45:40 -0800
Message-ID: <CAADnVQLV+BERfHNUeii=sZfU+z4WF-jsWUN8aMtzv0tYxh9Rcw@mail.gmail.com>
Subject: Re: [PATCH 00/34] selftests: Fix incorrect kernel headers search path
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 2:46 PM Shuah Khan <skhan@linuxfoundation.org> wrote:
>
> On 1/27/23 06:57, Mathieu Desnoyers wrote:
> > Hi,
> >
> > This series fixes incorrect kernel header search path in kernel
> > selftests.
> >
> > Near the end of the series, a few changes are not tagged as "Fixes"
> > because the current behavior is to rely on the kernel sources uapi files
> > rather than on the installed kernel header files. Nevertheless, those
> > are updated for consistency.
> >
> > There are situations where "../../../../include/" was added to -I search
> > path, which is bogus for userspace tests and caused issues with types.h.
> > Those are removed.
> >
> > Thanks,
> >
> > Mathieu
> >
> > Mathieu Desnoyers (34):
>
> The below patches are now applied to linux-kselftest next for Linux 6.3-rc1
>
> >    selftests: arm64: Fix incorrect kernel headers search path
> >    selftests: clone3: Fix incorrect kernel headers search path
> >    selftests: core: Fix incorrect kernel headers search path
> >    selftests: dma: Fix incorrect kernel headers search path
> >    selftests: dmabuf-heaps: Fix incorrect kernel headers search path
> >    selftests: drivers: Fix incorrect kernel headers search path
> >    selftests: filesystems: Fix incorrect kernel headers search path
> >    selftests: futex: Fix incorrect kernel headers search path
> >    selftests: gpio: Fix incorrect kernel headers search path
> >    selftests: ipc: Fix incorrect kernel headers search path
> >    selftests: kcmp: Fix incorrect kernel headers search path
> >    selftests: media_tests: Fix incorrect kernel headers search path
> >    selftests: membarrier: Fix incorrect kernel headers search path
> >    selftests: mount_setattr: Fix incorrect kernel headers search path
> >    selftests: move_mount_set_group: Fix incorrect kernel headers search
> >      path
> >    selftests: perf_events: Fix incorrect kernel headers search path
> >    selftests: pid_namespace: Fix incorrect kernel headers search path
> >    selftests: pidfd: Fix incorrect kernel headers search path
> >    selftests: ptp: Fix incorrect kernel headers search path
> >    selftests: rseq: Fix incorrect kernel headers search path
> >    selftests: sched: Fix incorrect kernel headers search path
> >    selftests: seccomp: Fix incorrect kernel headers search path
> >    selftests: sync: Fix incorrect kernel headers search path
> >    selftests: user_events: Fix incorrect kernel headers search path
> >    selftests: vm: Fix incorrect kernel headers search path
> >    selftests: x86: Fix incorrect kernel headers search path
> >    selftests: iommu: Use installed kernel headers search path
> >    selftests: memfd: Use installed kernel headers search path
> >    selftests: ptrace: Use installed kernel headers search path
> >    selftests: tdx: Use installed kernel headers search path
> >
>
> These will be applied by maintainers to their trees.

Not in this form. They break the build.

> >    selftests: bpf: Fix incorrect kernel headers search path # 02/34
> >    selftests: net: Fix incorrect kernel headers search path # 17/34
> >    selftests: powerpc: Fix incorrect kernel headers search path # 21/34
> >    selftests: bpf docs: Use installed kernel headers search path # 30/34
>
> thanks,
> -- Shuah
