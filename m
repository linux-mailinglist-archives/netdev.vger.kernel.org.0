Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296823B317C
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhFXOif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbhFXOie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 10:38:34 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F005C061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 07:36:14 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id h9so7555584oih.4
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 07:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GgunliXPEwff0RKxEiN1J3KRr0eB3DJG3ZFXRas/V3I=;
        b=Zvx56x6zcZaTgyaRjgdWwZd9al8fjol7n37wvs7PvBzNqqt3NPYe0CqlH8RB+FHdfC
         YSZMvL6NfiWg5gTC4fmR+g6oLWCdDQc4MFbasqap/gf3Fg8hUauJfcB0LCBk97QsDnVe
         K4WbbcwhsgO5iIn7K2CKQb9vrbyx4H4EtnNRlVy465Ni1DUd8TbaHfEX7ddIn0sGEoW5
         N0KXh3hcpBIYWHt/UbnpP728A6I6hrsCwfzaJWnAflap9SsxOHSZ9xjFbl+S8d0BBpYZ
         JKgBRH4IHjt4e9XE2l1EyTPbD23orAveucJOUGTC9OnS5Z5KDv08PVirBmGE3IaFPMaT
         pPHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GgunliXPEwff0RKxEiN1J3KRr0eB3DJG3ZFXRas/V3I=;
        b=c6xxPUOhELoXr4rsPJU4MEVN5cxDbni/+V/3/nA5bRV5965MGVXM9IYHGLtDhkjbzZ
         wRx/D/q0s4JPfv+BoLUfdzyxTvZMJ9jNurhO/yC/88gKEikBlub8s/NAvUPWyy0pZU0U
         8KUNo7y1nnxLubSDcUcd3aagPtW0H4Erf8DqUlRmWMfGBDx5fMHp8mRvd8hFPe7rqNCo
         bUzwFal8Ah7IsFXgugMNEn4qO49nsEbwL4E1+I64dKsdkX+CB056weUzp/imJHNJvzyp
         NMFS13BFMjA5BC7wpBE0QzUscVSVsEijh6bQfpcjXaZw3hxO+AWibDxSgao1SwJnFgia
         C0nQ==
X-Gm-Message-State: AOAM5336uhsmS9sh0kb165QxyySowWZdLaecVNJ9NAAjXaDoOOyNzTUA
        I+ZKQP243trACmjYSG64ASw=
X-Google-Smtp-Source: ABdhPJxFFZUEtbd9g9REHuLxpHtufZK+FFG+wxNLzeNVYG8fmopCIuARiO57XLpKZHBv+d6e675Nig==
X-Received: by 2002:a05:6808:128b:: with SMTP id a11mr1373916oiw.123.1624545373779;
        Thu, 24 Jun 2021 07:36:13 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id o2sm625549oom.26.2021.06.24.07.36.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 07:36:13 -0700 (PDT)
Subject: Re: [PATCH net] ip6_tunnel: fix GRE6 segmentation
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, vfedorenko@novek.ru
References: <20210622015254.1967716-1-kuba@kernel.org>
 <33902f8c-e14a-7dc6-9bde-4f8f168505b5@gmail.com>
 <20210622152451.7847bc24@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <592a8a33-dfb8-c67f-c9e6-0e1bab37b00d@gmail.com>
 <20210623091458.40fb59c6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <5011b8aa-8bbf-9172-0982-599afed69c5d@gmail.com>
 <20210624133915.GA4606@pc-32.home>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <18a17215-e4e4-a1ef-b2d0-a934dca2b21c@gmail.com>
Date:   Thu, 24 Jun 2021 08:36:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210624133915.GA4606@pc-32.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/21 7:39 AM, Guillaume Nault wrote:
> On Wed, Jun 23, 2021 at 12:28:05PM -0600, David Ahern wrote:
>> On 6/23/21 10:14 AM, Jakub Kicinski wrote:
>>> Noob question, why do we need that 2 sec wait with IPv6 sometimes?
>>> I've seen it randomly in my local testing as well I wasn't sure if 
>>> it's a bug or expected.
>>
>> It is to let IPv6 DAD to complete otherwise the address will not be
>> selected as a source address. That typically results in test failures.
>> There are sysctl settings that can prevent the race and hence the need
>> for the sleep.
> 
> But Jakub's script uses "nodad" in the "ip address add ..." commands.
> Isn't that supposed to disable DAD entirely for the new address?
> Why would it need an additional "sleep 2"?
> 

it should yes. I think the selftests have acquired a blend of nodad,
sysctl and sleep. I'm sure it could be cleaned up and made consistent.
