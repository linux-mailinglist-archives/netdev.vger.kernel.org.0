Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80BD4133D42
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 09:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbgAHIf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 03:35:58 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:54687 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726313AbgAHIf5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 03:35:57 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 47t2dP2tfYz9v3gf;
        Wed,  8 Jan 2020 09:35:53 +0100 (CET)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=fxUelGuu; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id I0TjIRBHFA-4; Wed,  8 Jan 2020 09:35:53 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 47t2dP1Xwtz9v3gS;
        Wed,  8 Jan 2020 09:35:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1578472553; bh=pyCqgPPZ7kRofrDb80nScePrylWdxYR2l2/ULCClPrs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=fxUelGuuZbXfGsWb57/3BxUjvtvdC/2QbyAEo6YqIvKJAL5rv4xC8YAPDeq7nhud3
         dkB/UdAQUigd1rFWPHMhgX/6Fa4jCdXgPI62S3zygNDeTcqR1ZOBKH62ej2i0cflHq
         zb2g6a/VdTBtVa3azjNLc7pwBVFpYUnXR94BgWzQ=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 2FF4A8B7EC;
        Wed,  8 Jan 2020 09:35:54 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id PkGUzhhRpTGx; Wed,  8 Jan 2020 09:35:54 +0100 (CET)
Received: from [172.25.230.100] (po15451.idsi0.si.c-s.fr [172.25.230.100])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id BE1C98B7EA;
        Wed,  8 Jan 2020 09:35:53 +0100 (CET)
Subject: Re: [RFT 00/13] iomap: Constify ioreadX() iomem argument
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Rich Felker <dalias@libc.org>, Jiri Slaby <jirislaby@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Jason Wang <jasowang@redhat.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        virtualization@lists.linux-foundation.org,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        netdev <netdev@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Dave Jiang <dave.jiang@intel.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Helge Deller <deller@gmx.de>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        Dave Airlie <airlied@redhat.com>,
        Matt Turner <mattst88@gmail.com>,
        arcml <linux-snps-arc@lists.infradead.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Allen Hubbe <allenbh@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        alpha <linux-alpha@vger.kernel.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Richard Henderson <rth@twiddle.net>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>, Jon Mason <jdmason@kudzu.us>,
        linux-ntb@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>
References: <1578415992-24054-1-git-send-email-krzk@kernel.org>
 <CAMuHMdW4ek0OYQDrrbcpZjNUTTP04nSbwkmiZvBmKcU=PQM9qA@mail.gmail.com>
 <CAMuHMdUBmYtJKtSYzS_5u67hVZOqcKSgFY1rDGme6gLNRBJ_gA@mail.gmail.com>
 <CAJKOXPfq9vS4kSyx1jOPHBvi9_HjviRv0LU2A8ZwdmqgUuebHQ@mail.gmail.com>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <2355489c-a207-1927-54cf-85c04b62f18f@c-s.fr>
Date:   Wed, 8 Jan 2020 09:35:54 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <CAJKOXPfq9vS4kSyx1jOPHBvi9_HjviRv0LU2A8ZwdmqgUuebHQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 08/01/2020 à 09:18, Krzysztof Kozlowski a écrit :
> On Wed, 8 Jan 2020 at 09:13, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>
>> Hi Krzysztof,
>>
>> On Wed, Jan 8, 2020 at 9:07 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>> On Tue, Jan 7, 2020 at 5:53 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
>>>> The ioread8/16/32() and others have inconsistent interface among the
>>>> architectures: some taking address as const, some not.
>>>>
>>>> It seems there is nothing really stopping all of them to take
>>>> pointer to const.
>>>
>>> Shouldn't all of them take const volatile __iomem pointers?
>>> It seems the "volatile" is missing from all but the implementations in
>>> include/asm-generic/io.h.
>>
>> As my "volatile" comment applies to iowrite*(), too, probably that should be
>> done in a separate patch.
>>
>> Hence with patches 1-5 squashed, and for patches 11-13:
>> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> I'll add to this one also changes to ioreadX_rep() and add another
> patch for volatile for reads and writes. I guess your review will be
> appreciated once more because of ioreadX_rep()
> 

volatile should really only be used where deemed necessary:

https://www.kernel.org/doc/html/latest/process/volatile-considered-harmful.html

It is said: " ...  accessor functions might use volatile on 
architectures where direct I/O memory access does work. Essentially, 
each accessor call becomes a little critical section on its own and 
ensures that the access happens as expected by the programmer."

Christophe
