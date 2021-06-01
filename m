Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5023397BE2
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 23:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbhFAVvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 17:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234656AbhFAVvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 17:51:39 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DD8C061574
        for <netdev@vger.kernel.org>; Tue,  1 Jun 2021 14:49:56 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id b145-20020a1c80970000b029019c8c824054so2463506wmd.5
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 14:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FCh94KI+vQhjHscQDZfqaz1ydz4wQP9gfrzVtNEpjcg=;
        b=ExZt7fNto2SHjbPvcJNC+VKAbVbfLkHT3kq0vjErlYMpA5CDxj1X7LBwHiTGpDoA7l
         gw3s9OUhRpqgcYqaDKMKP6FDo17lvDbgRvKMDTv29JLCM4nkDXAY7y4rK+jTYkzGwdqK
         UJ5Fq0JlIU0SQqii35VdSxJi0GLjy2tkoYsmgf/NO7tcH6fLTkqIJlmDDwgsTFuVPtDm
         FqWopGqzrCq3ZpF4yteLYbv7xfSaBDLSy/VAdaP/u2jpHIgeXZWn5Y6Ugh/DzvV0cDpC
         0wxhyAw2KHJO0JYFAwNQGNjw9s3JIBoRBjWrNehp4RH/vmLcM3cHBbrAHxtLPWcIa+Jr
         ZfmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FCh94KI+vQhjHscQDZfqaz1ydz4wQP9gfrzVtNEpjcg=;
        b=cI/zaIiHcB21wNj6y1w+rHcWeB3Q0CkPS1QV+OGJbWOR/8dF8zsc1xEBFQDs6LU7cU
         fNT433tSKpsTWILZ923eg6dOu86N9OAQwcncys7g7NmkVQiffKZRKUb2Do6f/X1VTd3v
         +rgzvPdXKtlkds9cRwtLYy2mN3fKVMytC+60Cf2mYissV4LqplPmC74/n5+zYeo0jSDX
         yEe/Ix2XBLCA6tk/JtOewXFXtvn4gKbKSIEDmhdROLat0J7Rpj8+LJ/oxSsO9byUe8E+
         SPR+8KcTBWyEKiee9q1DSwmyRgxbEdOYmmK4U/TyfYwXwvPC2m11yJoLEO6Cj6OumV8x
         KgEw==
X-Gm-Message-State: AOAM533eZ32NhBrfWjWteyoc1tmgMZMSeljJOrwdTN1w45+PfSaqOomI
        BXGGjQ83GXA5YHO5UfMmeNQ=
X-Google-Smtp-Source: ABdhPJzMVA1OI/YGLqufCmdmCx5AfmZSOCZbbmA1HBLFnvpYMob+bEEyVXGrITWgv5S4kDk4CQ9XNA==
X-Received: by 2002:a05:600c:283:: with SMTP id 3mr29106705wmk.174.1622584194971;
        Tue, 01 Jun 2021 14:49:54 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:c00:7413:c444:b8f3:1878? (p200300ea8f2f0c007413c444b8f31878.dip0.t-ipconnect.de. [2003:ea:8f2f:c00:7413:c444:b8f3:1878])
        by smtp.googlemail.com with ESMTPSA id f13sm4348114wrt.86.2021.06.01.14.49.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 14:49:54 -0700 (PDT)
To:     Nikolai Zhubr <zhubr.2@gmail.com>
Cc:     Arnd Bergmann <arnd@kernel.org>, netdev <netdev@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
References: <60B24AC2.9050505@gmail.com>
 <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com>
 <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com>
 <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com>
 <60B3CAF8.90902@gmail.com>
 <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com>
 <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com>
 <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com>
 <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com>
 <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com>
 <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com>
 <60B65BBB.2040507@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: Realtek 8139 problem on 486.
Message-ID: <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com>
Date:   Tue, 1 Jun 2021 23:48:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <60B65BBB.2040507@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.06.2021 18:09, Nikolai Zhubr wrote:
> Hi all,
> 
> 01.06.2021 14:42, Heiner Kallweit:
> [...]
>> Great, so you have a solution for your problem, as i would expect that this
>> setting also makes 8139too in newer kernels usable for you.
> 
> Well, not exactly, although I'm definitely getting close to some sort of satisfactory solution, and I appreciate all the helpfull replies.
> 
> Relying on this BIOS setting is still not good, because yet another motherboard I've just tested today does not have it (or at least in no evident form anyway).
> 
>> This hardware is so old that it's not very likely someone spends effort on this.
> 
> Now I'd like to ask, is quality reliable fix still wanted in mainline or rather not? Because I'll personally do my best to create/find a good fix anyway, but if it is of zero interest for mainline, I'll probably not invest much time into communicating it. My understanding was that default rule is "if broken go fix it" but due to the age of both code and hardware, maybe it is considered frozen or some such (I'm just not aware really).
> 
Driver 8139too has no maintainer. And you refer to "mainline" like to a number of developers
who are paid by somebody to maintain all drivers in the kernel. That's not the case in general.
You provided valuable input, and if you'd contribute to improving 8139too and submit patches for
fixing the issue you're facing, this would be much appreciated.
> 
> Thank you,
> 
> Regards,
> Nikolai

Heiner
