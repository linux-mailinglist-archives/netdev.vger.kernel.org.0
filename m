Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E47A5FC7F5
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 17:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiJLPIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 11:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiJLPIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 11:08:30 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98884AE201
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 08:08:28 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id k2so38663617ejr.2
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 08:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RGf8qC9lukm2LVi/CWzyaHMiHq83MAHlUofYRds4pG0=;
        b=tqUzlnCLPp+pvbwGoVsJh/o3GtZzt1rmqMkQ+DLB1pNE8G39OPM7QUWEcTzkZEXo7N
         /eHDXYidHBR70jm0KW3Nazmbie9aFNjyjRo5+4akT536lwkuv2qX+bv4I6+BZTv06hB3
         5P+r+G8K1mBb9CCLVLjfWiYcAmgK/XZDPrIFYxXsPMztsnD0yg3xv2d79Q1KLZyc8KaO
         DZHy+WBLsDuV4OsxsBkdumkL2fxrynNCovfSFqqhNtdW/x1HxJl9GPOFhdMOay2M5Bjg
         cHwV1pTGb5wvR+y38uvNVK3OYtJ7q7VSn1hKFHFxBy3jB9sU/PT2NjB6rESS+IqcoLDe
         7wQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RGf8qC9lukm2LVi/CWzyaHMiHq83MAHlUofYRds4pG0=;
        b=fHbq8a/EZhQovN5N8SvaK5s5oyUuyOh2Vj7u8VjTR1TZ2TOuUv3adCqLP3t5BdA3NL
         3343Y93OPa33i6xRz0Rs3tQEHqfz4MLC3TYC0jev1bmKck4I4Vazel33qj7uZLeMtSBT
         vYZHdCHZY5IvOEHHI1UBfhxDUPBKHPy35TUi11Fu+78aABqjRQopFpc4MxI5ecvYLwbe
         5UdGNR2wY+AtzB8mOlIQsXRXEp8Z0RUeehbwrOr4gFYttX7aTJgG4YLK1dpkBDhqpOeV
         tibTNiqmu8wbwqt6efZiXrnDlg7xRljNDQK46M9DRl0wEBwpa3s7Vgw3xq31+qDJqKAz
         zEjQ==
X-Gm-Message-State: ACrzQf04SLnLtkZo17OCa0PykD+iWT3l+OSPvH9l5e75FPyCMMel59vq
        GDLeFmjeeQ/iA6LvNgvt8wR1vA==
X-Google-Smtp-Source: AMsMyM4VQixoT+QrPq07x6Gl6Da2H+6MoMOKLmBFVV5ujOgDem2fMcMt69WbAwJLOTBZBtz/SD4VsQ==
X-Received: by 2002:a17:907:2c5b:b0:78d:3f8a:19d0 with SMTP id hf27-20020a1709072c5b00b0078d3f8a19d0mr22345925ejc.369.1665587307068;
        Wed, 12 Oct 2022 08:08:27 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id w21-20020aa7da55000000b0044e01e2533asm11384424eds.43.2022.10.12.08.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 08:08:26 -0700 (PDT)
Date:   Wed, 12 Oct 2022 17:08:24 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] kernel panic: kernel stack overflow
Message-ID: <Y0bYaPsJDG1KvqKG@nanopsycho>
References: <000000000000c8900705ead19e41@google.com>
 <CACT4Y+Zuoo_rgf=DP90wgSVm909Qboj5kdYQjZELPDfdkQWJqA@mail.gmail.com>
 <Y0a88zDFLVeVzBPB@nanopsycho>
 <CACT4Y+Z4CCBqyNJCNySYEWUFT-GOfEjYguBfUh_nb6aAe1w99Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+Z4CCBqyNJCNySYEWUFT-GOfEjYguBfUh_nb6aAe1w99Q@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 12, 2022 at 03:54:59PM CEST, dvyukov@google.com wrote:
>On Wed, 12 Oct 2022 at 15:11, Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Wed, Oct 12, 2022 at 09:53:27AM CEST, dvyukov@google.com wrote:
>> >On Wed, 12 Oct 2022 at 09:48, syzbot
>> ><syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com> wrote:
>> >>
>> >> Hello,
>> >>
>> >> syzbot found the following issue on:
>> >>
>> >> HEAD commit:    bbed346d5a96 Merge branch 'for-next/core' into for-kernelci
>> >> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
>> >> console output: https://syzkaller.appspot.com/x/log.txt?x=14a03a2a880000
>> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=aae2d21e7dd80684
>> >> dashboard link: https://syzkaller.appspot.com/bug?extid=60748c96cf5c6df8e581
>> >> compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
>> >> userspace arch: arm64
>> >>
>> >> Unfortunately, I don't have any reproducer for this issue yet.
>> >>
>> >> Downloadable assets:
>> >> disk image: https://storage.googleapis.com/syzbot-assets/11078f50b80b/disk-bbed346d.raw.xz
>> >> vmlinux: https://storage.googleapis.com/syzbot-assets/398e5f1e6c84/vmlinux-bbed346d.xz
>> >>
>> >> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> >> Reported-by: syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
>> >
>> >+Jiri
>> >
>> >It looks like the issue is with the team device. It seems to call
>> >itself infinitely.
>> >team_device_event was mentioned in stack overflow bugs in the past:
>> >https://groups.google.com/g/syzkaller-bugs/search?q=%22team_device_event%22
>>
>> Hi, do you have dmesg output available by any chance?
>
>Hi Jiri,
>
>syzbot attaches dmesg output to every report under the "console output" link.

I see. I guess the debug messages are not printed out, I don't see them
there. Would it be possible to turn them on?
