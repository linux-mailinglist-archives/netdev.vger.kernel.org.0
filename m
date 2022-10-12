Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A6A5FC60D
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 15:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiJLNLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 09:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiJLNLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 09:11:23 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D057CAE5C
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 06:11:18 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id m15so24350392edb.13
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 06:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WKQQtExmcOLWJbhqtQgzF7tmbKZpiaFY7Ige0YjH1nY=;
        b=i9jyVgYjohPbZJBBUKOy9AQ1bIE2sxwGeFhlKacN0CKp6j7lE2YnsEBQn0R5EbRNSg
         K/DXFwi94Ff1wlz5KPlaKeuqXImzT/XpLHVBjIEuTi7lFIQT4Qb4UctXDDhtz4REI2VY
         jDcEswUf9KKDN8tZDYWiSv5dmqDEpel6tnHs4Y0CvlksVR0631lNK3RgCT5+0Hm3+3v2
         hZ1ua1VBq2Nkqiug7iyxZReJOgjcDIkSI57BLgKQ7i/Ct+WXkmtvFgk5DSyeyL3h16ij
         6dONj17RbCw3bCWIvJRdtYXjXL7avHFUGZBEmNiA8oavPog5kb4lIN1PxVVKNRDcbWLo
         A4og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WKQQtExmcOLWJbhqtQgzF7tmbKZpiaFY7Ige0YjH1nY=;
        b=33qhnllKSlqkHCoA5Az2TAVWBpL8L5HUUjgKvqpWs+3fyun6sii5jFYRrB/yQK/9H4
         ITWCVehSkARtXTAPTapq1ewDuLgmVALPj63rbQ9535cRwhW/Cq+zmMMQshcY8PysiNVx
         jvt5uFKoz0FIUpbeVwukDD3mnHlYIv4HJKGEhNmdAdKPEiAWRwhi59JdJZlk/SsE+vUR
         xg3DZYINHYUpT3r9uu6BXG67XBWuNMSW6inpNr07dkSdp3ngJGaHRovu0Zdt73CI1ngW
         Ol5CfkMr/yhKHkGw73DzyQgikThcfnvM7M3IyhLBo4fmuFCgag+tW4ATqUEzza6QJLj6
         S+NQ==
X-Gm-Message-State: ACrzQf294EhnYZZlGjvhlGGPeDnsKsGuQg8ivZGqa6LBzooS2tAjUbGx
        6wuQqsMIBFp+kcnaQMoaB72tFw==
X-Google-Smtp-Source: AMsMyM5KqRXpTLXDa5m8/kJHxu/67hkgCD2LtrByuyJYLBa4aR+qffWT3+vOUSsVxsJx7oY/r3MLXA==
X-Received: by 2002:aa7:d28c:0:b0:459:3cc5:3cb8 with SMTP id w12-20020aa7d28c000000b004593cc53cb8mr28360444edq.261.1665580276644;
        Wed, 12 Oct 2022 06:11:16 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id 21-20020a170906309500b0078d22b0bcf2sm1230039ejv.168.2022.10.12.06.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 06:11:16 -0700 (PDT)
Date:   Wed, 12 Oct 2022 15:11:15 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] kernel panic: kernel stack overflow
Message-ID: <Y0a88zDFLVeVzBPB@nanopsycho>
References: <000000000000c8900705ead19e41@google.com>
 <CACT4Y+Zuoo_rgf=DP90wgSVm909Qboj5kdYQjZELPDfdkQWJqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+Zuoo_rgf=DP90wgSVm909Qboj5kdYQjZELPDfdkQWJqA@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 12, 2022 at 09:53:27AM CEST, dvyukov@google.com wrote:
>On Wed, 12 Oct 2022 at 09:48, syzbot
><syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com> wrote:
>>
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    bbed346d5a96 Merge branch 'for-next/core' into for-kernelci
>> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
>> console output: https://syzkaller.appspot.com/x/log.txt?x=14a03a2a880000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=aae2d21e7dd80684
>> dashboard link: https://syzkaller.appspot.com/bug?extid=60748c96cf5c6df8e581
>> compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
>> userspace arch: arm64
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/11078f50b80b/disk-bbed346d.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/398e5f1e6c84/vmlinux-bbed346d.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
>
>+Jiri
>
>It looks like the issue is with the team device. It seems to call
>itself infinitely.
>team_device_event was mentioned in stack overflow bugs in the past:
>https://groups.google.com/g/syzkaller-bugs/search?q=%22team_device_event%22

Hi, do you have dmesg output available by any chance?

Thanks!
