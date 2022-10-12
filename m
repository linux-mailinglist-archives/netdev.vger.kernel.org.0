Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5166F5FC6D5
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 15:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiJLNzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 09:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiJLNzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 09:55:19 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBD537FA9
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 06:55:14 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id g1so25839607lfu.12
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 06:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=srtJcSYN3G5DvUdbQGKekTY5ico+If7+rq0BZ74Ls10=;
        b=slnnTZJMht/OOCwVi0mPuVMdLFBR3hqeM0lKgxXM52w5wICq6d1GdAhb7sgBBhcVxr
         lg4pOwWfu0KptE468rbfduScA7Z+Czs5Qilg1km6DwbdA+JfQaHn0fhg//f+MH8xq7S5
         q1jhZmbPlQn+QJGmnGAZLI5li3vJsoDX8AWVqzh1FiqtRoI/99dGnJ3dFkzrCxNYhP35
         uAL+MGVcS0lZOvca++rqCOVIenRzqPnvgr+IFMXdpmuMc3Si6Gn4adC+7mk3HOAIlhU2
         FQcwZhmwrHMCUie2/a8rYp7fLOAiX7/AkRz1rPzw+MZ4pPNocp/u0/9bjWCepcjBvUI8
         3tqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=srtJcSYN3G5DvUdbQGKekTY5ico+If7+rq0BZ74Ls10=;
        b=kt/r29mEwCMETXZbf16EaoobwHEuS1E8fA/l9l3nkM7sitlYMQVPVD+oE8FLnkv9JJ
         BGiuD41sIDGUvaaxd0znqEzl+Geb2DPuABxoGGcA1PuV4ut7v16fasowvhDO2lO0qKth
         4GlLW6eQEqpDW47D+wsxR5Mpz5vX9E5Ibq8ZHPmVK6yt31wXxIM2dkk11hf9SBUJdK+L
         cevlnEWrvDOMvqCtHPa2zTfYG5Ht8Rv5cjAY5crsFlrz3BcPzaoYbKTWpPrnKxmEyjYU
         FM6C4n5ROvk4+JlJY/HEPjiHAwcV7bYsahuS/eRHpfkGNJ86ALhiLPqzoaWsfHV5gZun
         uT4g==
X-Gm-Message-State: ACrzQf1vL+8+HFkMUG2QDRVMdl8kRjihcdVoxPaOzb74bZzv3/96JYF1
        8WQMulLDSm3jHP5/5dKquGQp8vye+B0s93rcmLnlCxotvyS5cw==
X-Google-Smtp-Source: AMsMyM5MniXv8PCK7pBrIF8ft2PuL/n42xsZK13WIOppiH33JabcEsvwsygJDR58Ho6arOdL+b9Fsg6dd3KCPaAiYVA=
X-Received: by 2002:a05:6512:104c:b0:4a2:6cee:ae17 with SMTP id
 c12-20020a056512104c00b004a26ceeae17mr10080500lfb.417.1665582911531; Wed, 12
 Oct 2022 06:55:11 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c8900705ead19e41@google.com> <CACT4Y+Zuoo_rgf=DP90wgSVm909Qboj5kdYQjZELPDfdkQWJqA@mail.gmail.com>
 <Y0a88zDFLVeVzBPB@nanopsycho>
In-Reply-To: <Y0a88zDFLVeVzBPB@nanopsycho>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 12 Oct 2022 15:54:59 +0200
Message-ID: <CACT4Y+Z4CCBqyNJCNySYEWUFT-GOfEjYguBfUh_nb6aAe1w99Q@mail.gmail.com>
Subject: Re: [syzbot] kernel panic: kernel stack overflow
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     syzbot <syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Oct 2022 at 15:11, Jiri Pirko <jiri@resnulli.us> wrote:
>
> Wed, Oct 12, 2022 at 09:53:27AM CEST, dvyukov@google.com wrote:
> >On Wed, 12 Oct 2022 at 09:48, syzbot
> ><syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com> wrote:
> >>
> >> Hello,
> >>
> >> syzbot found the following issue on:
> >>
> >> HEAD commit:    bbed346d5a96 Merge branch 'for-next/core' into for-kernelci
> >> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=14a03a2a880000
> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=aae2d21e7dd80684
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=60748c96cf5c6df8e581
> >> compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
> >> userspace arch: arm64
> >>
> >> Unfortunately, I don't have any reproducer for this issue yet.
> >>
> >> Downloadable assets:
> >> disk image: https://storage.googleapis.com/syzbot-assets/11078f50b80b/disk-bbed346d.raw.xz
> >> vmlinux: https://storage.googleapis.com/syzbot-assets/398e5f1e6c84/vmlinux-bbed346d.xz
> >>
> >> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >> Reported-by: syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
> >
> >+Jiri
> >
> >It looks like the issue is with the team device. It seems to call
> >itself infinitely.
> >team_device_event was mentioned in stack overflow bugs in the past:
> >https://groups.google.com/g/syzkaller-bugs/search?q=%22team_device_event%22
>
> Hi, do you have dmesg output available by any chance?

Hi Jiri,

syzbot attaches dmesg output to every report under the "console output" link.
