Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261E93A1145
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236594AbhFIKjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 06:39:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43319 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232850AbhFIKjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 06:39:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623235060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GXhuyr8heOXQm5DhE+A2Fq3L85+vZLqOuEIP9E5CaCk=;
        b=QpF7HR/7zOGh61YOtlY8dqcVkUj+yYVo4cmQJvAskdE/cJnbqHCDWYPV11ObBsIUrvcyT3
        pysNVP/he+CVTa66STgetI7XHG5fjnSOw3u2IFroXl+sGkTRKqZVXKW6hm+MTP+b/Lghub
        in61uffd3xSL54ub9vSD66/PiBsF31g=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-jo-kQ6ZoPWiskM4hPmx7gA-1; Wed, 09 Jun 2021 06:37:39 -0400
X-MC-Unique: jo-kQ6ZoPWiskM4hPmx7gA-1
Received: by mail-wr1-f71.google.com with SMTP id x9-20020adfffc90000b02901178add5f60so10605398wrs.5
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 03:37:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=GXhuyr8heOXQm5DhE+A2Fq3L85+vZLqOuEIP9E5CaCk=;
        b=NTpKI5C8c9FNUUfOpObwOge4X5Ga4th4oT5xUqG63G71EB9T3bLPi1iU/dEEt1AgY/
         3R1OOBbS1AjC0N3A/0RoSbHRRdvMjZ/L1NFns6K/MpQ7K14+k/009V58OiKSSldiJE71
         PzJ55BerXPhwX/JU7s8B2CRXTnEnwg+/bszlCjC0ZqXGJ9jIuqcRY0g1apK/Lny74iwO
         B2IDI+F2QeqJK3OiWLfoceaDT+BRBbkDeFErBn1L0ggunlyOzt4AZMPVIZwNMX4HpoNE
         jXS9Cgz8GR4KTuTiQpYTnMxQiAxmxYpV/BaTLdH6bBhzPa/MhmMX8+FZ2C43vn6rNZES
         uVZQ==
X-Gm-Message-State: AOAM532LDK4+lbPCqcT0Un/ZfimIN+bd2rOljmyLsUNRUnP0ayjHh4IP
        xGDw0E2PrPlrnIK2ws5/YtYVcBvnFl3Ux0lUAx4fsELp9BX3Fj5Fxdv3xfNMt1M+HiqT+T2RIrB
        Ri4ntY9rGUrG/wf1z
X-Received: by 2002:a5d:4984:: with SMTP id r4mr27081033wrq.152.1623235058405;
        Wed, 09 Jun 2021 03:37:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxx5QPJlJibMJq5KkrldmC0yuk9Qgb+mpFY3QEuhdJz4/D402+HjHMF51cTVSM1EXp++YpYXw==
X-Received: by 2002:a5d:4984:: with SMTP id r4mr27081015wrq.152.1623235058237;
        Wed, 09 Jun 2021 03:37:38 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c611d.dip0.t-ipconnect.de. [91.12.97.29])
        by smtp.gmail.com with ESMTPSA id l5sm5668999wmi.46.2021.06.09.03.37.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 03:37:37 -0700 (PDT)
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Greg KH <greg@kroah.com>, Christoph Lameter <cl@gentwo.de>
Cc:     Theodore Ts'o <tytso@mit.edu>, Jiri Kosina <jikos@kernel.org>,
        ksummit@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org
References: <YH2hs6EsPTpDAqXc@mit.edu>
 <nycvar.YFH.7.76.2104281228350.18270@cbobk.fhfr.pm>
 <YIx7R6tmcRRCl/az@mit.edu>
 <alpine.DEB.2.22.394.2105271522320.172088@gentwo.de>
 <YK+esqGjKaPb+b/Q@kroah.com>
 <c46dbda64558ab884af060f405e3f067112b9c8a.camel@HansenPartnership.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
Message-ID: <b32c8672-06ee-bf68-7963-10aeabc0596c@redhat.com>
Date:   Wed, 9 Jun 2021 12:37:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <c46dbda64558ab884af060f405e3f067112b9c8a.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.05.21 16:58, James Bottomley wrote:
> On Thu, 2021-05-27 at 15:29 +0200, Greg KH wrote:
>> On Thu, May 27, 2021 at 03:23:03PM +0200, Christoph Lameter wrote:
>>> On Fri, 30 Apr 2021, Theodore Ts'o wrote:
>>>
>>>> I know we're all really hungry for some in-person meetups and
>>>> discussions, but at least for LPC, Kernel Summit, and
>>>> Maintainer's Summit, we're going to have to wait for another
>>>> year,
>>>
>>> Well now that we are vaccinated: Can we still change it?
>>>
>>
>> Speak for yourself, remember that Europe and other parts of the world
>> are not as "flush" with vaccines as the US currently is :(
> 
> The rollout is accelerating in Europe.  At least in Germany, I know
> people younger than me are already vaccinated. 

And I know people younger than you in Germany personally ( ;) ) that are 
not vaccinated yet and might not even get the first shot before 
September, not even dreaming about a second one + waiting until the 
vaccine is fully in effect.

So yes, sure, nobody can stop people that think the pandemic is over 
("we are vaccinated") from meeting in person. Just make sure to not 
ignore the poor souls that really won't be traveling this year, because 
"we are not vaccinated".

-- 
Thanks,

David / dhildenb

