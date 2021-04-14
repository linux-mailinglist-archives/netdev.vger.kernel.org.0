Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7C935EEE7
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 10:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349497AbhDNH5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 03:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245671AbhDNH5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 03:57:01 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DE5C061574;
        Wed, 14 Apr 2021 00:56:40 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id 12so18912832wrz.7;
        Wed, 14 Apr 2021 00:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SpLJtv0mv9suk55xID/pQeN9GSpqgc6D9yqRFUf5Thk=;
        b=c41erE4JVHboGjqFMjR5AL8vaphwFBYm+I5H8OcRqnMw8lOmQK8vjYKRvi6L2Y4HAh
         AS+xuJzHm8ZuhQu9O/AZfkAY+uGf5UxweWip+LMOwyiTLbbwXYl9vV1MCoUk+dYkVqt+
         aKAjtkPgTo2hM3mP/vTmIjPEVnzXYIHs4Hmpk3ktwzauMe90yhuzWYi0j2elGDlNHxxX
         FZxVm0e/YiRuST0yPtVM1YL9RflLNmO4fvdZNWiH1GDcoJ9mY1oQL0wojZ/oSq3An02l
         LyYoi/dkuaotPPXlVyeNIgBmCc8DdELZrL3pJonbNYXSOl360HrtlGfUgB13RqQAZk5F
         NaUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SpLJtv0mv9suk55xID/pQeN9GSpqgc6D9yqRFUf5Thk=;
        b=Hv5TaTDb29aqUmU2NaeJdRqbApC+vATOXjwxhLSWjfz1KuVzPRHdv5R0hVSFy8hIre
         J1OlE1jtjqJLgw3wNVI+7PlnWYBM2R1oszqLwFR/5EKekM371wzht/0l1u900EKu5yvQ
         Wd3ulQoNv1+ksveBB/WWXXA3jKKq/WLXpzFsEJA5R1V+P3HcaQjqt3VH8e65FtSI+RvA
         zLUawFdV3435NCE0gmrLAljT7YMR+CEjSWy6wJ8GI5blx57TJDX+1NVTQgaWd2Bm8ta9
         xYHZy7dBegxp55PvThFLeoFDQdiY7DybK2axU/hKl7MX+iNkCanfP+lswLOltT9HsZVU
         wNcQ==
X-Gm-Message-State: AOAM533thhnWU8hl/67UN2nMi+jW5BUpwmDEMyNU3n86mnq99I48Lt0A
        xGT2leY81lLEpXqy1EvzHfFheIzHHbJHKA==
X-Google-Smtp-Source: ABdhPJwob5UoP9jdV4g+OFuz6mv6yAjeza60UQetOFHFwhvIuuTIhX7XtPPMwQNtI3+Sp92wK/ETxg==
X-Received: by 2002:adf:cd8c:: with SMTP id q12mr17364997wrj.328.1618386999545;
        Wed, 14 Apr 2021 00:56:39 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:c95a:c5e7:2490:ebe3? (p200300ea8f384600c95ac5e72490ebe3.dip0.t-ipconnect.de. [2003:ea:8f38:4600:c95a:c5e7:2490:ebe3])
        by smtp.googlemail.com with ESMTPSA id o125sm4608415wmo.24.2021.04.14.00.56.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 00:56:39 -0700 (PDT)
Subject: Re: [PATCH net] r8169: don't advertise pause in jumbo mode
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Roman Mamedov <rm+bko@romanrm.net>
References: <e249e2fb-ba51-a62e-f2e7-5011c3790830@gmail.com>
 <YHaen5PAzfNcnnOG@kroah.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <d038efe3-724e-f732-0171-f4321837a0cb@gmail.com>
Date:   Wed, 14 Apr 2021 09:56:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YHaen5PAzfNcnnOG@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14.04.2021 09:49, Greg KH wrote:
> On Wed, Apr 14, 2021 at 09:40:51AM +0200, Heiner Kallweit wrote:
>> It has been reported [0] that using pause frames in jumbo mode impacts
>> performance. There's no available chip documentation, but vendor
>> drivers r8168 and r8125 don't advertise pause in jumbo mode. So let's
>> do the same, according to Roman it fixes the issue.
>>
>> [0] https://bugzilla.kernel.org/show_bug.cgi?id=212617
>>
>> Fixes: 9cf9b84cc701 ("r8169: make use of phy_set_asym_pause")
>> Reported-by: Roman Mamedov <rm+bko@romanrm.net>
>> Tested-by: Roman Mamedov <rm+bko@romanrm.net>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>> This patch doesn't apply cleanly on some kernel versions, but the needed
>> changes are trivial.
>> ---
>>  drivers/net/ethernet/realtek/r8169_main.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>
> 
Until recently the procedure in netdev has been to annotate the patch as
"net" and not cc stable. IIRC there is an experiment to cc stable.
If this isn't applicable any longer and the old process still applies,
then please ignore the cc'ed stable.
