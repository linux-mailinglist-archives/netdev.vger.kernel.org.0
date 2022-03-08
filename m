Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027614D1FD5
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 19:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349443AbiCHSNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 13:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349456AbiCHSNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 13:13:34 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7521713DD6;
        Tue,  8 Mar 2022 10:12:35 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id r20so26189767ljj.1;
        Tue, 08 Mar 2022 10:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to;
        bh=AyFkmnjwJtbQ1OUH9crr4u8t2jQPuRzriml4H+F7bdA=;
        b=hcO3uWvue8jZ/iVqW8aY5eERrVsXQR9fgGe0TtHu3uqRLTPh0vWmvUMKQiyDVNj/jR
         ctnCJfDgxyX0ztygx2CjrUdd5ZIzYG6wjWF9kCxaUDchn3oMlfRDDMKW+omRBHaE4qRy
         HTPiWt1FIBidhuNdN98BJFDlGggGIl+gtifwoQt1k1wALMsHW7ak9XwOSLZOCXJU6Cpz
         BQavlzzlpnkvGr74/ezLl1pQYONXVT5tU1s6zDAgGwk82pT7VGnXnfhudI+9+SQQxrAp
         jKo+VhOjER7liu0zPim+ut8eJfsOXmhh3W8xOCvrp7yblGxb4R4Jydxz8iPim/owCtO2
         fOmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to;
        bh=AyFkmnjwJtbQ1OUH9crr4u8t2jQPuRzriml4H+F7bdA=;
        b=fqvDD5nn12olUzeqzA7NME766rR9v4V1Vp+ZafO3yD8g4Ns38Z1hGItuvgDKTGu1jZ
         23XNO+YvYq5rhABc02iNOBto/c1jInXNskrYT7yE1VEa3Y/VhZyKJixw/CLcLloyk+it
         81MdG32l8ar6aLqly8ylwOiXTvi1l3h2ir/ROC/S9OLgnqg2zJwHAVo767REeKhki5PP
         qOVSyTqrKWI6O+PXQcZO4w3eb6re4yAfMW7N+0MT6vvP6oYYp1twIs0As4bc9gFy1PqR
         dGIKISK7dZ0oEfeIsPW54Rzl0WkRxPq1/0afjuDnrtSqF1nkMAwj+DjzBkMgunrh+db9
         BChw==
X-Gm-Message-State: AOAM530xDIDfG8t237HLWZGuwCgMa70Ftp4JgR3lTep7d2eeynDkXlQZ
        O0ZkS99N0eKEyQ6gnwUfLAM=
X-Google-Smtp-Source: ABdhPJzH2ZKwts82VaHKuLfTbUAQhHuDDj/Dw6QoA7HRAP44DtB82EimsJoqw4fsHk2BL3EwzLnQOw==
X-Received: by 2002:a2e:3911:0:b0:246:3fec:bb3e with SMTP id g17-20020a2e3911000000b002463fecbb3emr11495221lja.337.1646763150820;
        Tue, 08 Mar 2022 10:12:30 -0800 (PST)
Received: from [192.168.1.11] ([94.103.229.107])
        by smtp.gmail.com with ESMTPSA id bt23-20020a056512261700b00443e7fa1c26sm3609793lfb.261.2022.03.08.10.12.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 10:12:30 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------0kTuiRdFeR90XioQw3UoZwvE"
Message-ID: <ef9d2a7e-932b-9389-ce4c-82b9d74952c8@gmail.com>
Date:   Tue, 8 Mar 2022 21:12:28 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [syzbot] KASAN: use-after-free Read in port100_send_complete
Content-Language: en-US
To:     syzbot <syzbot+16bcb127fb73baeecb14@syzkaller.appspotmail.com>,
        krzysztof.kozlowski@canonical.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000cb6dd805d9b8cbb8@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <000000000000cb6dd805d9b8cbb8@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------0kTuiRdFeR90XioQw3UoZwvE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/22 21:03, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    38f80f42147f MAINTAINERS: Remove dead patchwork link
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14b0d321700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=542b2708133cc492
> dashboard link: https://syzkaller.appspot.com/bug?extid=16bcb127fb73baeecb14
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a63d21700000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17d21be1700000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+16bcb127fb73baeecb14@syzkaller.appspotmail.com
> 
> port100 5-1:0.0: NFC: Urb failure (status -71)
> ==================================================================
> BUG: KASAN: use-after-free in port100_send_complete+0x16e/0x1a0 drivers/nfc/port100.c:935
> Read of size 1 at addr ffff88801bb59540 by task ksoftirqd/2/26

We need to kill urbs on disconnect, since urbs callbacks they may access 
freed memory

#syz test
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master




With regards,
Pavel Skripkin
--------------0kTuiRdFeR90XioQw3UoZwvE
Content-Type: text/plain; charset=UTF-8; name="ph"
Content-Disposition: attachment; filename="ph"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmZjL3BvcnQxMDAuYyBiL2RyaXZlcnMvbmZjL3BvcnQx
MDAuYwppbmRleCBkN2RiMWEwZTZiZTEuLjAwZDhlYTZkY2I1ZCAxMDA2NDQKLS0tIGEvZHJp
dmVycy9uZmMvcG9ydDEwMC5jCisrKyBiL2RyaXZlcnMvbmZjL3BvcnQxMDAuYwpAQCAtMTYx
Miw3ICsxNjEyLDkgQEAgc3RhdGljIGludCBwb3J0MTAwX3Byb2JlKHN0cnVjdCB1c2JfaW50
ZXJmYWNlICppbnRlcmZhY2UsCiAJbmZjX2RpZ2l0YWxfZnJlZV9kZXZpY2UoZGV2LT5uZmNf
ZGlnaXRhbF9kZXYpOwogCiBlcnJvcjoKKwl1c2Jfa2lsbF91cmIoZGV2LT5pbl91cmIpOwog
CXVzYl9mcmVlX3VyYihkZXYtPmluX3VyYik7CisJdXNiX2tpbGxfdXJiKGRldi0+b3V0X3Vy
Yik7CiAJdXNiX2ZyZWVfdXJiKGRldi0+b3V0X3VyYik7CiAJdXNiX3B1dF9kZXYoZGV2LT51
ZGV2KTsKIAo=

--------------0kTuiRdFeR90XioQw3UoZwvE--
