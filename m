Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD813B2F7B
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 14:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhFXNAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 09:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbhFXNAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 09:00:05 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A972C061756
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 05:57:44 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id u5-20020a7bc0450000b02901480e40338bso4800774wmc.1
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 05:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MCa72yMdHXGjGihv0hcDwVjOwX3qoCsp/TCZUGiyEnk=;
        b=TIExZny+xagkJdssKAd3jS8wGhSkUlYDI5hsq2ZM+iJi2C/QQEP8SJyuCI1hur7nTJ
         4Ls14QrMhP5QWHAn9pwfhrdRP+UNTrIoccNS0xnrmWe6e37QoavbDf9Y72E/0jWpXt7g
         5NsS2hgZ8o+pel7fYqYU2NIMW8DB99s717K+YUyuDLiqhSBklQMm7POxsJnRxy4ioKmd
         gz9UdhbKhJWVsGmnf8DHoC+A93Yz7kD9IOibXAywOOSCmHsuxUBD77Uq+SvlgsKylv12
         97Vh3XoApp1YQrL/+etXNsaZizYmq4GH3b5OrILojDmXhEtBssflY9Grt4XMsNKRyqjF
         DNng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=MCa72yMdHXGjGihv0hcDwVjOwX3qoCsp/TCZUGiyEnk=;
        b=MdTWzmXxNDwk9COaxEO5LhXMxSrQXbhcPLcKfYe3AW5LmJ10QiNyrBSey1EqE1PaIQ
         pHccv0t/FMxNbSfBDPMaR9zIbsU70Pghc6BL43bwBC+CVfLFXzr/GiBoNZJf05pcI/zF
         SrL/8Zd6GqZv9PiCi/7xlf3wDTrbil/WpQKMS5luLo5nAcmeDzJLXc8sLLJ/DQgcKTyu
         qSokJ8xwCzIg9ICQxyVm5GjemMnQE4/+0IPSBo+Qq0tS0f+cIZ15CDVG9O2xzNrraEyg
         Fbrq4ZrXfmwpDzvVPb3f6mO/uIKqZXPP1D0SIQ+Q0icg/k/49+iguDOvF7NgBmQllKUp
         nD9Q==
X-Gm-Message-State: AOAM531HHBpwoC1yI5gZ5eZraPi6Nv13/hThdYVDfVwkW+0lxGs7V7Ge
        Xp8pL/XnVSczjS42DCauH97Yqw==
X-Google-Smtp-Source: ABdhPJwKRGU0zCbiJEFf8qoOi/UEAEX5xKJMMqB/j90+DxmWeR9Dm+bqOMo4JdGOpr2wWcg9SaHjsQ==
X-Received: by 2002:a05:600c:2907:: with SMTP id i7mr4149323wmd.139.1624539463471;
        Thu, 24 Jun 2021 05:57:43 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:108a:5c8a:bec4:9763? ([2a01:e0a:410:bb00:108a:5c8a:bec4:9763])
        by smtp.gmail.com with ESMTPSA id m67sm9115639wmm.17.2021.06.24.05.57.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 05:57:42 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: Issues during assigning addresses on point to point interfaces
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Phil Sutter <phil@nwl.cc>
References: <20210606151008.7dwx5ukrlvxt4t3k@pali>
 <20210624124545.2b170258@dellmb>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <d3995a21-d9fe-9393-a10e-8eddccec2f47@6wind.com>
Date:   Thu, 24 Jun 2021 14:57:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210624124545.2b170258@dellmb>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 24/06/2021 à 12:45, Marek Behún a écrit :
> On Sun, 6 Jun 2021 17:10:08 +0200
> Pali Rohár <pali@kernel.org> wrote:
> 
>> Hello!
>>
>> Seems that there is a bug during assigning IP addresses on point to
>> point interfaces.
>>
>> Assigning just one local address works fine:
>>
>>     ip address add fe80::6 dev ppp1 --> inet6 fe80::6/128 scope link
>>
>> Assigning both local and remote peer address also works fine:
>>
>>     ip address add fe80::7 peer fe80::8 dev ppp1 ---> inet6 fe80::7
>> peer fe80::8/128 scope link
>>
>> But trying to assign just remote peer address does not work. Moreover
>> "ip address" call does not fail, it returns zero but instead of
>> setting remote peer address, it sets local address:
>>
>>     ip address add peer fe80::5 dev ppp1 --> inet6 fe80::5/128 scope
>> link
>>
> 
> Adding some other people to Cc in order to get their opinions.
> 
> It seems this bug is there from the beginning, from commit
> caeaba79009c2 ("ipv6: add support of peer address")
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=caeaba79009c2
> 
> Maybe some older user-space utilities use IFA_ADDRESS instead of
> IFA_LOCAL, and this was done in order to be compatible with them?
If I remember well, there was an issue in the uAPI.
IFA_LOCAL is supposed to be the address of the interface and IFA_ADDRESS is
supposed to be the endpoint of a point-to-point interface.
However, in case of IPv6, it was not the case. In netlink messages generated by
the kernel, IFA_ADDRESS was used instead of IFA_LOCAL.
The patch tried to keep the backward compatibility and the symmetry between msg
from userland and notification from the kernel.


Regards,
Nicolas
