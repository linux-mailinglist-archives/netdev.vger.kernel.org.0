Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAC55D44D
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfGBQdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:33:55 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34400 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfGBQdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 12:33:55 -0400
Received: by mail-pg1-f194.google.com with SMTP id p10so7956078pgn.1;
        Tue, 02 Jul 2019 09:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a415cj+b469zojRykaFTgJuk67+7doyx69wFdjDpJOY=;
        b=KDcNjbg4tCf09CM1qjB3T4yBFXSqzYjGS/02Vj44JBBvrTFK/PDOpUUIRtsYjVYMzP
         aZwQSgFsr/qZ0CXqX1Hnf4Ucc5Q38p/RJRheLdpJPsVgOpClEntnYK+Rh+5DVqJB/LHf
         2HoZ8xdBNIEBtPuCGiFYr5kLbgKc0itUSdZRTFewu9o2FV4o4/GC+wk0wNrn64rqDeCn
         obadnDEsKY/gj45BJD1HuVXR/by8FEKYU7ElkWeViVtEmX0Cqa+I9CmBkynwh1WJoqDj
         BeWMQp+jhr7IWDxApDTEr8isfhII7TmTnhRJp/ozsCkHMbFkbwW7Na7l97h79jR8ZVff
         zoqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a415cj+b469zojRykaFTgJuk67+7doyx69wFdjDpJOY=;
        b=Y3u2H1HOSDqOsW2X8fhEWgIchhACh1TQtVIcvxDtgMAP8C3ji4jqTk17R+Ff0Xn2oe
         WbED+9iRTaJ8GIGn9DzVkSghUuVsXLD95VxauzV/ThSiSF6w6YDiEbgJ1iSorZcbd6ts
         bF+sb8bKEJH9j0yL4LfOBXaPja0/zL3AXsrf8zyXnMcyfbbgig/ubQyZFiJ28yc0kctD
         CNgka3MyL3ildxRVRwIdRfiqaeqmyxylIGt7D5QnULvtcoIHXSbtrIbtVFKmplEGVjW/
         CqYPA9E7VBnTlQjgcTuBkTv2LqzIXnLv+51CrSoJm6S8SVui8r3xFrMdRcMYVzUg2NaR
         JbVQ==
X-Gm-Message-State: APjAAAV8A2RTjOBbg+BKNV6IRh90Zs3E6hsFzk2vKxLsntZbUXLAh3m1
        rOFQGVtXSyPcow0KOZSuomo=
X-Google-Smtp-Source: APXvYqyDgbS/Z9bd2qR8BGLK6xdWObcgdOJwjUCu9r46yWdWK9T+m6JJ+0w1c3n+qvxTk2OqvO/isg==
X-Received: by 2002:a17:90a:208e:: with SMTP id f14mr6668866pjg.57.1562085234323;
        Tue, 02 Jul 2019 09:33:54 -0700 (PDT)
Received: from [172.20.54.151] ([2620:10d:c090:200::ef17])
        by smtp.gmail.com with ESMTPSA id a64sm11720662pgc.53.2019.07.02.09.33.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 09:33:53 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Richardson, Bruce" <bruce.richardson@intel.com>
Cc:     "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        "Laatz, Kevin" <kevin.laatz@intel.com>, netdev@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        "Loftus, Ciara" <ciara.loftus@intel.com>
Subject: Re: [PATCH 00/11] XDP unaligned chunk placement support
Date:   Tue, 02 Jul 2019 09:33:52 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <3510BE85-6B1B-4BB4-9640-ECEE2572DB4E@gmail.com>
In-Reply-To: <59AF69C657FD0841A61C55336867B5B07ED8B210@IRSMSX103.ger.corp.intel.com>
References: <20190620083924.1996-1-kevin.laatz@intel.com>
 <FA8389B9-F89C-4BFF-95EE-56F702BBCC6D@gmail.com>
 <ef7e9469-e7be-647b-8bb1-da29bc01fa2e@intel.com>
 <20190627142534.4f4b8995@cakuba.netronome.com>
 <f0ca817a-02b4-df22-d01b-7bc07171a4dc@intel.com>
 <BAE24CBF-416D-4665-B2C9-CE1F5EAE28FF@gmail.com>
 <07e404eb-f712-b15a-4884-315aff3f7c7d@intel.com>
 <20190701142002.1b17cc0b@cakuba.netronome.com>
 <59AF69C657FD0841A61C55336867B5B07ED8B210@IRSMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; markup=markdown
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2 Jul 2019, at 2:27, Richardson, Bruce wrote:

>> -----Original Message-----
>> From: Jakub Kicinski [mailto:jakub.kicinski@netronome.com]
>> Sent: Monday, July 1, 2019 10:20 PM
>> To: Laatz, Kevin <kevin.laatz@intel.com>
>> Cc: Jonathan Lemon <jonathan.lemon@gmail.com>; 
>> netdev@vger.kernel.org;
>> ast@kernel.org; daniel@iogearbox.net; Topel, Bjorn
>> <bjorn.topel@intel.com>; Karlsson, Magnus 
>> <magnus.karlsson@intel.com>;
>> bpf@vger.kernel.org; intel-wired-lan@lists.osuosl.org; Richardson, 
>> Bruce
>> <bruce.richardson@intel.com>; Loftus, Ciara <ciara.loftus@intel.com>
>> Subject: Re: [PATCH 00/11] XDP unaligned chunk placement support
>>
>> On Mon, 1 Jul 2019 15:44:29 +0100, Laatz, Kevin wrote:
>>> On 28/06/2019 21:29, Jonathan Lemon wrote:
>>>> On 28 Jun 2019, at 9:19, Laatz, Kevin wrote:
>>>>> On 27/06/2019 22:25, Jakub Kicinski wrote:
>>>>>> I think that's very limiting.  What is the challenge in 
>>>>>> providing
>>>>>> aligned addresses, exactly?
>>>>> The challenges are two-fold:
>>>>> 1) it prevents using arbitrary buffer sizes, which will be an 
>>>>> issue
>>>>> supporting e.g. jumbo frames in future.
>>>>> 2) higher level user-space frameworks which may want to use 
>>>>> AF_XDP,
>>>>> such as DPDK, do not currently support having buffers with 'fixed'
>>>>> alignment.
>>>>>     The reason that DPDK uses arbitrary placement is that:
>>>>>         - it would stop things working on certain NICs which 
>>>>> need
>>>>> the actual writable space specified in units of 1k - therefore we
>>>>> need 2k
>>>>> + metadata space.
>>>>>         - we place padding between buffers to avoid 
>>>>> constantly
>>>>> hitting the same memory channels when accessing memory.
>>>>>         - it allows the application to choose the actual 
>>>>> buffer
>>>>> size it wants to use.
>>>>>     We make use of the above to allow us to speed up processing
>>>>> significantly and also reduce the packet buffer memory size.
>>>>>
>>>>>     Not having arbitrary buffer alignment also means an AF_XDP
>>>>> driver for DPDK cannot be a drop-in replacement for existing
>>>>> drivers in those frameworks. Even with a new capability to allow 
>>>>> an
>>>>> arbitrary buffer alignment, existing apps will need to be modified
>>>>> to use that new capability.
>>>>
>>>> Since all buffers in the umem are the same chunk size, the original
>>>> buffer address can be recalculated with some multiply/shift math.
>>>> However, this is more expensive than just a mask operation.
>>>
>>> Yes, we can do this.
>>
>> That'd be best, can DPDK reasonably guarantee the slicing is uniform?
>> E.g. it's not desperate buffer pools with different bases?
>
> It's generally uniform, but handling the crossing of (huge)page 
> boundaries
> complicates things a bit. Therefore I think the final option below
> is best as it avoids any such problems.
>
>>
>>> Another option we have is to add a socket option for querying the
>>> metadata length from the driver (assuming it doesn't vary per 
>>> packet).
>>> We can use that information to get back to the original address 
>>> using
>>> subtraction.
>>
>> Unfortunately the metadata depends on the packet and how much info 
>> the
>> device was able to extract.  So it's variable length.
>>
>>> Alternatively, we can change the Rx descriptor format to include the
>>> metadata length. We could do this in a couple of ways, for example,
>>> rather than returning the address as the start of the packet, 
>>> instead
>>> return the buffer address that was passed in, and adding another
>>> 16-bit field to specify the start of packet offset with that buffer.
>>> If using another 16-bits of the descriptor space is not desirable, 
>>> an
>>> alternative could be to limit umem sizes to e.g. 2^48 bits (256
>>> terabytes should be enough, right :-) ) and use the remaining 16 
>>> bits
>>> of the address as a packet offset. Other variations on these 
>>> approach
>>> are obviously possible too.
>>
>> Seems reasonable to me..
>
> I think this is probably the best solution, and also has the advantage 
> that
> a buffer retains its base address the full way through the cycle of Rx 
> and Tx.

I like this as well - it also has the advantage that drivers can keep
performing adjustments on the handle, which ends up just modifying the
offset.
-- 
Jonathan
