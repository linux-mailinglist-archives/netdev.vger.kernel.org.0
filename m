Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA71D3918
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 08:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfJKGDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 02:03:33 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51594 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfJKGDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 02:03:30 -0400
Received: by mail-wm1-f67.google.com with SMTP id 7so9100960wme.1
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 23:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cdZ4gbFSs1uF+DaliFg13F0BLC5IEe/qlJamjD4FsEU=;
        b=Zc0HgwL13aSkhOLXhVeIm09URSrjQlSHj1qxNdGdwa+CPiIty3D51wltAxvFXChBxG
         BG6Amhse5DFBPhgNQV5L9mGDAjuKKzqcb0ukeQoRsYd5GYxmiAfo9iAAB3n0AZzwQGSH
         tlK49W0DqMx9Ya4W0tU5D0vlim2F1FhtFS16o7nlY3G4MCYNxe8eqtYszwiu1wTAE7nz
         yYY0vjGatXmaBrXZcKXcMuYjJ/81tUFqsIujiGRc4+OOKMT/YV2dq+S5SpusTE398gUr
         WIU2Vgdar73hobWlweP2in3F61+CEdgqTplbItwds64/Xitlk4Qhvv8NrK45KEE+elMX
         DQLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cdZ4gbFSs1uF+DaliFg13F0BLC5IEe/qlJamjD4FsEU=;
        b=GVMEUl7Ctv18qA9H9UyqP0F1XcOZFwaU2Ppv8bI8Wd8aqdNPhgit9467ibHNqhAGI0
         nzxtY1EGLJmPMudkbc4thcv60NsFugkbNzDQLWO0zDn7bajFR96KhjCJLeT5VfAnfPGU
         uXlzlcpwyr5xXHUknGTCjltH6DitIF8qi+CYeUZfE3h3lpfoqIQ9ycxbzn5qi+2OMyPr
         G/+l67q2+fgtmxT99fDuEZNQM8FFfpfeyxLH5Mv+mFN9sqjQP32aoVP+ZeOz67BvD4xi
         PH7dJYSUvynDzUPXhVSRjkO8IqBBsUvM9xCAlhiOWChVtAvYrJSTgXxFiOLmo36Mes4B
         98rw==
X-Gm-Message-State: APjAAAU3ESDjaEOti0uvEzbDhDtsXq8Gd7ZNgwaZOH4S6oPhx5r1BwfD
        4gQFj/JVQWwliis8Gu7H808=
X-Google-Smtp-Source: APXvYqwrc+IitivU5wCWhVjzgGZvKPd7wpGJhsroTTkcyGwnwcZEuHCMKzTtG6fXViBsuXjuvBTvQw==
X-Received: by 2002:a1c:444:: with SMTP id 65mr1761013wme.84.1570773808441;
        Thu, 10 Oct 2019 23:03:28 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:f8:d1f0:105b:6f8f? (p200300EA8F26640000F8D1F0105B6F8F.dip0.t-ipconnect.de. [2003:ea:8f26:6400:f8:d1f0:105b:6f8f])
        by smtp.googlemail.com with ESMTPSA id a3sm13029971wmc.3.2019.10.10.23.03.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 23:03:27 -0700 (PDT)
Subject: Re: [PATCH net] r8169: fix jumbo packet handling on resume from
 suspend
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mariusz Bialonczyk <manio@skyboo.net>
References: <05ef825e-6ab2-cc25-be4e-54d52acd752f@gmail.com>
 <20191010163630.0afb5dd8@cakuba.netronome.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <03561754-aec2-7015-4b4d-32707bf3bd2d@gmail.com>
Date:   Fri, 11 Oct 2019 08:03:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191010163630.0afb5dd8@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.10.2019 01:36, Jakub Kicinski wrote:
> On Wed, 9 Oct 2019 20:55:48 +0200, Heiner Kallweit wrote:
>> Mariusz reported that invalid packets are sent after resume from
>> suspend if jumbo packets are active. It turned out that his BIOS
>> resets chip settings to non-jumbo on resume. Most chip settings are
>> re-initialized on resume from suspend by calling rtl_hw_start(),
>> so let's add configuring jumbo to this function.
>> There's nothing wrong with the commit marked as fixed, it's just
>> the first one where the patch applies cleanly.
>>
>> Fixes: 7366016d2d4c ("r8169: read common register for PCI commit")
>> Reported-by: Mariusz Bialonczyk <manio@skyboo.net>
>> Tested-by: Mariusz Bialonczyk <manio@skyboo.net>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> Applied, somewhat begrudgingly - this really isn't the way the Fixes
> tag should be used, but I appreciate it may be hard at this point to
> pin down a commit to blame given how many generations of HW this driver
> supports and how old it is.. perhaps I should have removed the tag in
> this case, hm.
> 
> Since the selected commit came in 5.4 I'm not queuing for stable.
> 
The issue seems to have been there forever, but patch applies from a
certain kernel version only. I agree that using the Fixes tag to provide
this information is kind of a misuse. How would you prefer to get that
information, add a comment below the commit message similar to the list
of changes in a new version of a patch series?

Heiner

