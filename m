Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C2C524DB9
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 15:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354103AbiELNFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 09:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353889AbiELNE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 09:04:58 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062CD20F4F1
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 06:04:58 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-d6e29fb3d7so6519229fac.7
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 06:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gY8yqmt9rxkC+ri2Ow7GDfEYtHoKglmDH8I5xpIy23Q=;
        b=ADpqkG9doKwUsc2LA9+EP89xf5epAj1JdS+aGo5Zrx6Qjhy1+9z12j6axoi1D7N8pP
         j5MPI8LHRl25VmP0YWDwcOvUljfz7zFN+T5KRq5k4QW1HzdbR0mn9KtRF984ON3xOCVS
         luoUDlDMJtzpEE63WPru580akeR2pEVyyjZatWRrCeLk3MtI92o/kj+CEfIsL1TBKnhh
         JQXeat3XGirEezl53fv73s2SaVAqndebq7SZVPIfRb2MmA8w7oHsH9aUpOgGOIk+PKVq
         CEZZlNyibbpA7DdUhqWQzkpgXsaqtnbQV1MEeGEz9TzHf2vgldKvmavne0U/nXyBh0wX
         blfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gY8yqmt9rxkC+ri2Ow7GDfEYtHoKglmDH8I5xpIy23Q=;
        b=oVCqTO5YDuo0aKirGat+iV3n9AQfhc/s6OAbsiXAeXehucuXi6gsjQeLy/flyXm8OG
         xs3xTHi+iYjtJrpsAV948scx2FIT+DLmN/vhiotG/7ZbX3Qn0Ffu4OIvXCGRd1VaKW8Q
         w+FJNcOiUVwCyF/zl1aXJZtaO54TZJT82x4ZUcVU9owdQ6MjU4G3hgAUdVPbYEccgtyw
         EeyDFmwb+2h9RBAPhkpXdMCldhXQWBMJsxgj46zYhpvbc4+1QDVhB4j4hmxAxmEf++CE
         m2McWQPd6NKs+4gxseyYhWk9kT7XtL/dUFl+xk5Z3+LDNGTTOoUA9r4Sa6+dIPdbBrbx
         aGvA==
X-Gm-Message-State: AOAM531TyJiIR/C8XlaRuChVE5+ifRN5OMWAq5KhXLbROxzH5xigZ2EE
        ZxCor+tmFwp7RQtsdukgcDc4dDPxEMie8e9se8ts8g==
X-Google-Smtp-Source: ABdhPJzaulsL4XHDnNpsA86HUhuwXPgr1/5bnMGQ21WysXS3sKlBemJ2mSIgjARKM8KTcg5ulG2p5CpHPxip4kjLq6g=
X-Received: by 2002:a05:6870:b61e:b0:ec:a426:bab5 with SMTP id
 cm30-20020a056870b61e00b000eca426bab5mr5441769oab.163.1652360697130; Thu, 12
 May 2022 06:04:57 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000076ecf305b9f8efb1@google.com> <000000000000ef073a05bdf398e0@google.com>
In-Reply-To: <000000000000ef073a05bdf398e0@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 12 May 2022 15:04:46 +0200
Message-ID: <CACT4Y+aydumbVJARxkeQuD5k8jowUwOehfQ9CEw8Uq+boOunUA@mail.gmail.com>
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in add_adv_patterns_monitor
To:     syzbot <syzbot+3ed6361bf59830ca9138@syzkaller.appspotmail.com>
Cc:     apusaka@chromium.org, dan.carpenter@oracle.com,
        davem@davemloft.net, finanzas1@logisticaenlinea.net,
        hdanton@sina.com, howardchung@google.com, johan.hedberg@gmail.com,
        johan.hedberg@intel.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, mcchou@chromium.org,
        mmandlik@chromium.org, netdev@vger.kernel.org, sashal@kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Mar 2021 at 09:27, syzbot
<syzbot+3ed6361bf59830ca9138@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit b4a221ea8a1f890b50838ef389d016c7ff280abc
> Author: Archie Pusaka <apusaka@chromium.org>
> Date:   Fri Jan 22 08:36:11 2021 +0000
>
>     Bluetooth: advmon offload MSFT add rssi support
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14ef5ad6d00000
> start commit:   b491e6a7 net: lapb: Add locking to the lapb module
> git tree:       net
> kernel config:  https://syzkaller.appspot.com/x/.config?x=be33d8015c9de024
> dashboard link: https://syzkaller.appspot.com/bug?extid=3ed6361bf59830ca9138
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10628ae8d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12964b80d00000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: Bluetooth: advmon offload MSFT add rssi support

That commit touches the crashed function:

#syz fix: Bluetooth: advmon offload MSFT add rssi support
