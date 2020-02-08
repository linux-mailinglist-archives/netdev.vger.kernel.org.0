Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7F7D15655A
	for <lists+netdev@lfdr.de>; Sat,  8 Feb 2020 17:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbgBHQJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Feb 2020 11:09:40 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.165]:21501 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbgBHQJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Feb 2020 11:09:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1581178175;
        s=strato-dkim-0002; d=xenosoft.de;
        h=In-Reply-To:Date:Message-ID:References:Cc:To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=PdihAqfeKD54YbNb2He1peHtwOFZYOu4uAedog826qA=;
        b=Pk8Uo4ovKN1pL7kKOvCSgy7upAtqtwkcYqwT363YZgBKMuztnT7zY/i31di6xGLq3Z
        E8ukM+PciN7RvrbluR9s/NdqOXzC7kYfDueyc98VQgiAyE6msIXi7tGWhWivDvQkG9CA
        XcctgTZXp7ws980ZnAj+eMjLnTivU/t2KMvaiXxKxZBaribqEkwbLPCKVcswyan6klo6
        BruRqU/xBV8FEiQVZw0Ek5z+Uk6CZuowkvV4F4IYRdqwcVTZ21BfcQKn0ZEqoObAoMWT
        J1HTxjiZ736KS7SYQ/iTJTm7csaZyE52YfnXsWa9go9a+cOQZ7WWlmdScE2R6e2phWNz
        NA1w==
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGM4l4Hio94KKxRySfLxnHfJ+Dkjp5DdBJSrwuuqxvPgBLiaxlASBVL8WJv/OkCrDe9HRcQ=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a02:8109:89c0:ebfc:b8e6:ddd1:f1d2:d845]
        by smtp.strato.de (RZmta 46.1.12 AUTH)
        with ESMTPSA id 40bcf3w18G8eit4
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sat, 8 Feb 2020 17:08:40 +0100 (CET)
Subject: Re: Latest Git kernel: avahi-daemon[2410]: ioctl(): Inappropriate
 ioctl for device
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        DTML <devicetree@vger.kernel.org>,
        Darren Stevens <darren@stevens-zone.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev@ozlabs.org, "contact@a-eon.com" <contact@a-eon.com>,
        "R.T.Dickinson" <rtd2@xtra.co.nz>, Christoph Hellwig <hch@lst.de>,
        mad skateman <madskateman@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Christian Zigotzky <info@xenosoft.de>
References: <CAK8P3a39L5i4aEbKe9CiW6unbioL=T8GqXC007mXxUu+_j84FA@mail.gmail.com>
 <834D35CA-F0D5-43EC-97B2-2E97B4DA7703@xenosoft.de>
Message-ID: <b8e3a03c-4aeb-5582-78df-144450b03927@xenosoft.de>
Date:   Sat, 8 Feb 2020 17:08:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <834D35CA-F0D5-43EC-97B2-2E97B4DA7703@xenosoft.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: de-DE
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08 February 2020 at 07:59 am, Christian Zigotzky wrote:
>
>> On 7. Feb 2020, at 18:08, Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> ﻿On Fri, Feb 7, 2020 at 3:34 PM Christian Zigotzky
>> <chzigotzky@xenosoft.de> wrote:
>>> Hello Arnd,
>>>
>>> We regularly compile and test Linux kernels every day during the merge
>>> window. Since Thursday last week we have very high CPU usage because of
>>> the avahi daemon on our desktop Linux systems (Ubuntu, Debian etc). The
>>> avahi daemon produces a lot of the following log message. This generates
>>> high CPU usage.
>>>
>>> Error message: avahi-daemon[2410]: ioctl(): Inappropriate ioctl for device
>>>
>>> strace /usr/sbin/avahi-daemon:
>>>
>> Thanks a lot for the detailed analysis, with this I immediately saw
>> what went wrong in my
>> original commit and I sent you a fix. Please test to ensure that this
>> correctly addresses
>> the problem.
>>
>>         Arnd
> Hi Arnd,
>
> Thanks a lot for your patch! I will test it as soon as possible.
>
> Cheers,
> Christian

Hi Arnd,

I successfully compiled the latest Git kernel with your patch today. The 
avahi daemon works fine now. That means your patch has solved the avahi 
issue.

Thanks for your patch and have a nice weekend!

Cheers,
Christian
