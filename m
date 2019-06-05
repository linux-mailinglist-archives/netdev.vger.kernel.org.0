Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC2D355AE
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 06:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfFED6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 23:58:00 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43585 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbfFED6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 23:58:00 -0400
Received: by mail-pl1-f196.google.com with SMTP id cl9so4080416plb.10
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 20:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OPvE1+UWt+12yPZpEgKvZsFtEEo1Y+wvIlSqX9qA3+A=;
        b=VKlvVRkUo38eYer1ZLeSs9TjrFEFKXuQ7PaBxRlN+MEzM0X6Wwbl36KtMpdRNiLt2b
         0IITLYXFktdaYH1NrqFfSdypwkYsn1rH9hlPGYeSLNrnbsAn3ByR+c/uq1GL+JzSJ2Kc
         IFDKakh99rgkW4PwOFw7DW0G3Ov+OH258yX4Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OPvE1+UWt+12yPZpEgKvZsFtEEo1Y+wvIlSqX9qA3+A=;
        b=Yp9WiBbAP8jOWzdq8s7MoNEWxyp1Pltp94Rj809XkH03STBVPDLDjViqaEMH4Fm8UX
         aLknSjV4NYCLvnHJRwxK2yVQ6YuEvq4J9mVEChR2JJU4dOZwdSi+cVPBvKopshOYH3kv
         dtdg6SwaU0gOa7mn47GsaTeo1IuWr7m2ESDzkFOPlO8IHms6hdHTZ7qU5DlY3szl88YR
         04lTff+/nTCmzohk+mOcogyXD9MbrCK4XP3eKvzJURW7P4xUqGgpNoMFPdh1+HTpB8kN
         ZdTrPoemdyrJK9FR/pr1G+KwQmxj/pyzm8QfQEmOXgD8JGaUZO7QaLD6gHZdvciIfgom
         xi9A==
X-Gm-Message-State: APjAAAWY/fVm8Do9QK995mzxK+J7Zy0HmYW0n9vnlGRAkkA2oPDwtNxk
        Ue7cBH+vCXgmQkUjsGG4iy04aw==
X-Google-Smtp-Source: APXvYqxhQa4/zwKK1lqnxyUehBD9rQ8LxYl+cGTo8uFcFnhjYb9gLv/ZeF2nlMovGiKRT6kpH77WVQ==
X-Received: by 2002:a17:902:b691:: with SMTP id c17mr18282366pls.107.1559707079847;
        Tue, 04 Jun 2019 20:57:59 -0700 (PDT)
Received: from [172.27.227.186] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id g8sm17380883pjp.17.2019.06.04.20.57.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 20:57:59 -0700 (PDT)
Subject: Re: [PATCH net] fib_rules: return 0 directly if an exactly same rule
 exists when NLM_F_EXCL not supplied
To:     Hangbin Liu <liuhangbin@gmail.com>, David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Yaro Slav <yaro330@gmail.com>,
        Thomas Haller <thaller@redhat.com>,
        Lorenzo Colitti <lorenzo@google.com>, astrachan@google.com,
        Greg KH <greg@kroah.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        mateusz.bajorski@nokia.com,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>
References: <20190507091118.24324-1-liuhangbin@gmail.com>
 <20190508.093541.1274244477886053907.davem@davemloft.net>
 <CAHo-OozeC3o9avh5kgKpXq1koRH0fVtNRaM9mb=vduYRNX0T7g@mail.gmail.com>
 <20190605014344.GY18865@dhcp-12-139.nay.redhat.com>
From:   David Ahern <dsa@cumulusnetworks.com>
Message-ID: <eef3b598-2590-5c62-e79d-76eb46fae5ff@cumulusnetworks.com>
Date:   Tue, 4 Jun 2019 21:57:56 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190605014344.GY18865@dhcp-12-139.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/4/19 7:43 PM, Hangbin Liu wrote:
> Hi David Ahern,
> 
> On Fri, May 31, 2019 at 06:43:42PM -0700, Maciej Żenczykowski wrote:
>> FYI, this userspace visible change in behaviour breaks Android.
>>
>> We rely on being able to add a rule and either have a dup be created
>> (in which case we'll remove it later) or have it fail with EEXIST (in
>> which case we won't remove it later).
>>
>> Returning 0 makes atomically changing a rule difficult.
>>
>> Please revert.
> What do you think? Should I rever this commit?

I think it is crazy to add multiple identical rules given the linear
effect on performance. But, since it breaks Android, it has to be reverted.
