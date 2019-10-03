Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F27DCA060
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 16:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730336AbfJCObL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 10:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbfJCObK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 10:31:10 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B56220865;
        Thu,  3 Oct 2019 14:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570113070;
        bh=ja887EgzBcZzPkb4rXU45yrEXXzEuRz1I3W6sB1AWUk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=YO+x/CU8yx5nIEieP2GQwzeKy8Bhu3L1P4StryiRUy79wgYddP6O1muAn0fbCoZMX
         2PnZCz4yke0tVLVa6mS6ypabRHZMvmWWV/GYoVVntzXrSGAqXh0JjsU6jaQLw3QYmC
         BH/XTSfQ6UqXIHe8QlaBHC0GmWhiOyfGua+RydXY=
Subject: Re: Linux 5.4 kselftest known issues - update
To:     Shuah Khan <skhan@linuxfoundation.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Brauner <christian@brauner.io>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        bgolaszewski@baylibre.com, Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        shuah <shuah@kernel.org>
References: <a293684f-4ab6-51af-60b1-caf4eb97ff05@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <2a835150-d7f1-1c4a-80cb-d385f799dd14@kernel.org>
Date:   Thu, 3 Oct 2019 08:30:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <a293684f-4ab6-51af-60b1-caf4eb97ff05@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/26/19 11:41 AM, Shuah Khan wrote:
> Here are the know kselftest issues on Linux 5.4 with
> top commit commit 619e17cf75dd58905aa67ccd494a6ba5f19d6cc6
> on x86_64:
> 
> The goal is to get these addressed before 5.4 comes out.

All of these issues are now fixed, except the bpf llvm dependency.
These fixes should all be in linux-next if they haven't already.

> 
> 3 build failures and status:
> 
> pidfd - undefined reference to `pthread_create' collect2: error: ld 
> returned 1 exit status
> 
> Fixed: https://patchwork.kernel.org/patch/11159517/

In
> 
> bfp (two issues)
> 
> 1. "make TARGETS=bpf kselftest" build fails
> Makefile:127: tools/build/Makefile.include: No such file or directory

https://patchwork.kernel.org/patch/11163601/
In bpf fixes tree

> 
> This is due to recent kbuild changes and I have a patch ready to send.
> 
> 2. Related to llvm latest version dependency. This is a hard dependency.
> Unless users upgrade to latest llvvm, bpf test won't run. The new llvm
> might not be supported on all distros yet, in which case bpf will not
> get tested in some rings and on some architectures.
> 
> gpio
> 
> "make TARGETS=gpio kselftest" build fails
> 
> Makefile:23: tools/build/Makefile.include: No such file or directory

https://patchwork.kernel.org/patch/11163603/

> 
> This is due to recent kbuild changes and I have a patch ready to send.
> 
> kvm
> 
> "make TARGETS=kvm kselftest" build fails due --no-pie flags.

https://patchwork.kernel.org/patch/11171893/

I haven't found any new ones on x86_64 as of 5.4-rc1

thanks,
-- Shuah
