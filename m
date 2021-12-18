Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDAD8479DE3
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 23:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhLRWBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 17:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhLRWBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 17:01:37 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46985C061574;
        Sat, 18 Dec 2021 14:01:37 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id b22so12509765lfb.9;
        Sat, 18 Dec 2021 14:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=q+tRSqXFgdNTVl/AwgMOBZY24VIGMpI8AG0ElAf90yw=;
        b=RUyOXkN+w63uisEN5vH8JLKQarShuUlt91m2RnTJ+q6anMWV62kb96+HB2/iutIdrK
         LruFVcQcrgxPGr0BI+CAmq4CR26j/VL0x3BloyYv5bacPYY2zwauSs2nxTQtRZ29pqjG
         CG7QI7/2BnDg5QNOO0IEuTxwM8TJhrNogIcoZ+vuNevqrMYlouxetRSBThZPjtwfDgwB
         AQ1GI6O4v6f82PBAaWBK0yyEaZ7kRVM8PurS2lmF4tUpTeDzs3Q2PJNltyD5W4fucCz0
         2RD/X7NoYwg4N8DNDduLAroIcKYdpI9AO3ZeJYBzmo70/9b0yfGN6oeUY6VphKSViHSu
         IvBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=q+tRSqXFgdNTVl/AwgMOBZY24VIGMpI8AG0ElAf90yw=;
        b=CdZZuzHChnXs5USTJtlJpXd4dORQxP7L7+0XeLOBsmED3JFlxWfDkuHKhfFSURr9V8
         w8Qn248lcINK1hQM76yMfZMhu5tUK6U2ujeIRiyv3lgLqL4HvXwSgdXHIQWilMTDIeZ1
         2nIN0AHjLozhwpnpFDRqjdunBuJJA2EHDK4EvewgKighTQD2bFETSZMkgRPvZqeBJ1ti
         iRo+3uyeh+4MvjJP//S2mMXTB44Vz5PKF0Guegn7gzQ4GTk+KLeuU9BhUbI3LU9f+/v+
         pBUWFnet/kDe+7wnRuBNNiTHkTLnQqXjY1I3cFVT+gk5g2ka3MaUiEjaUziWvU11HBq8
         sgFw==
X-Gm-Message-State: AOAM532udFk6TSr2AgK4bJujVIRxCGk3io0MfVepXZGhbygo8KC7WM/m
        iSf3Dec+2P4BA0n1i1FZoGk=
X-Google-Smtp-Source: ABdhPJxTnY9OmCOVeqpYrcQ/ob18rt7ACRgT92dnY8s366lGYGa3z7Ovblwl5PO1or01ZazDlL0cLg==
X-Received: by 2002:a19:c3c3:: with SMTP id t186mr861761lff.57.1639864895488;
        Sat, 18 Dec 2021 14:01:35 -0800 (PST)
Received: from [192.168.1.11] ([94.103.229.239])
        by smtp.gmail.com with ESMTPSA id t25sm2094348ljd.24.2021.12.18.14.01.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Dec 2021 14:01:35 -0800 (PST)
Message-ID: <4a4b7a7c-5f88-b30d-360b-d6d70e7fc69f@gmail.com>
Date:   Sun, 19 Dec 2021 01:01:34 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [syzbot] KMSAN: uninit-value in asix_mdio_read (2)
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     syzbot <syzbot+f44badb06036334e867a@syzkaller.appspotmail.com>,
        davem@davemloft.net, glider@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux@rempel-privat.de, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <00000000000021160205d369a962@google.com>
 <13821c8b-c809-c820-04f0-2eadfdef0296@gmail.com> <Yb5Vu8+45wh5FiCQ@lunn.ch>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <Yb5Vu8+45wh5FiCQ@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/19/21 00:42, Andrew Lunn wrote:
> On Sun, Dec 19, 2021 at 12:14:30AM +0300, Pavel Skripkin wrote:
>> On 12/18/21 14:07, syzbot wrote:
>> > Hello,
>> > 
>> > syzbot found the following issue on:
>> > 
>> > HEAD commit:    b0a8b5053e8b kmsan: core: add dependency on DEBUG_KERNEL
>> > git tree:       https://github.com/google/kmsan.git master
>> > console output: https://syzkaller.appspot.com/x/log.txt?x=13a4d133b00000
>> > kernel config:  https://syzkaller.appspot.com/x/.config?x=46a956fc7a887c60
>> > dashboard link: https://syzkaller.appspot.com/bug?extid=f44badb06036334e867a
>> > compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
>> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=149fddcbb00000
>> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17baef25b00000
>> > 
>> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> > Reported-by: syzbot+f44badb06036334e867a@syzkaller.appspotmail.com
>> > 
>> 
>> The last unhanded case is asix_read_cmd() == 0. Let's handle it...
> 
> That does not look correct, i think.
> 
> asix_read_cmd() == 0 means no error from the read itself. If there is
> no error, we should look at the value of smsr and test for bit

As far as I understand asix_read_cmd() == 0 means 0 bytes was read, 
since it just returns usb_control_msg() return value. I don't know if 
usb_control_msg() can ever return 0, but looks like it's the only 
unhanded case

> AX_HOST_EN. Doing a continue means we just ignore the value returned
> by the good read.
> 
> I think the correct fix is to look at the value of i. If we have
> exceeded 30, we should return -ETIMEDOUT.
> 

Sorry, I don't get how it can help. Report says, that on following line

	else if (smsr & AX_HOST_EN)

smsr is uninitialized. How value of i can help here?

Can you, please, explain if you don't mind :)

Thanks


With regards,
Pavel Skripkin
