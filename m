Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7BFCC674
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 01:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731670AbfJDXUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 19:20:44 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42205 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729441AbfJDXUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 19:20:44 -0400
Received: by mail-pl1-f193.google.com with SMTP id e5so3812406pls.9
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 16:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4WNGXbv+Dno8i432FBPeJBS+BLVtDdAugxHg1V6x910=;
        b=tk5VUVDM2XNKOAlhWPeDGXU4ZKw0ieBSBiOkFKP1yJIki24uUkohKAJkkRhTCqGMZF
         uY4aQ6QsBaVNcWhmIx5BFr94JGNY1QObDxo5yTEdCP8qMYj9j3r2m+fFtRxEFTt8J+qU
         /nKA2+yyCT0DWu2eg+KYdTYZIGXYw9gt8FYDDIGy3Wsd2ZSu6SnitQ1M0RIjtRVRM73/
         +/sboY+0Wq4xcnrE0IXNGKDKyXd1wP+zkuitJ1DI9PcZqLLD8e07luRNhKgjoMakcpxj
         Oh2tV2hgM7CQpgF3ivkASrafLBaHCr5S/E3Ni9aMi/QDBSTDPS5f0DnrIuwOR989SYVT
         9Z6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4WNGXbv+Dno8i432FBPeJBS+BLVtDdAugxHg1V6x910=;
        b=S76hfd7MvFb33KMz9KSw6q88dhF8bQW/CzPWd9VftJ9ukBgWg+q+ffsgIyByeVub5H
         e9iZvKZ2ybSjzKcN4zAYwUFdbxjTiM2VIBYHk6Wr7NY1swJyA1Oxdtl4fVJhWMRgVosP
         eHFydxEpXSh4qbohid/NTsBmeushgwlRsyKqb9H365a+dN33jfNHh/Giundy3T1dKxNT
         qPK1aUx0laxkn18vq/DToIOxVYl8Qz5YmBSK2vhD3qrtJK4Ypyp7v5Uu8oajKJNYXwh8
         K5QcfaAahuDkhSj/TSd0c5CaVe0VxiAx0p26dUrtujNxdXcaSerjF1DIF22X7vCzFiM+
         jsRQ==
X-Gm-Message-State: APjAAAWbsLD8HJv+hBz1oClFLfXeSxM522Y9NSk+6iC5W3zH3QJOj7Gb
        Bt5MDDRpRGaaVKUCjFOywRw=
X-Google-Smtp-Source: APXvYqyZoK59RMOdvz8mXHUd0/OQLrdaXhhTH+2+/I48ipZusiaELXLrQ9BrrVrQH7UaH0WlnH+4lA==
X-Received: by 2002:a17:902:2e:: with SMTP id 43mr18369762pla.55.1570231243563;
        Fri, 04 Oct 2019 16:20:43 -0700 (PDT)
Received: from dahern-DO-MB.local (c-73-169-115-106.hsd1.co.comcast.net. [73.169.115.106])
        by smtp.googlemail.com with ESMTPSA id e9sm6277418pgs.86.2019.10.04.16.20.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 16:20:42 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 12/15] ipv4: Add "in hardware" indication to
 routes
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     Ido Schimmel <idosch@idosch.org>, Jiri Pirko <jiri@resnulli.us>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>
References: <20191002084103.12138-1-idosch@idosch.org>
 <20191002084103.12138-13-idosch@idosch.org>
 <CAJieiUiEHyU1UbX_rJGb-Ggnwk6SA6paK_zXvxyuYJSrah+8vg@mail.gmail.com>
 <20191002182119.GF2279@nanopsycho>
 <1eea9e93-dbd9-8b50-9bf1-f8f6c6842dcc@gmail.com>
 <20191003053750.GC4325@splinter>
 <e4f0dbf6-2852-c658-667b-65374e73a27d@gmail.com>
 <20191004144340.GA15825@splinter>
 <0ba448e3-3c27-d440-ee16-55f778b57bb1@gmail.com>
 <CAJieiUivWMD_QkqYA6Y08Ru3hCoy==MGaiNq7ma2K06WxgFuRg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <244dca29-67f2-9911-cc3f-56d132967ae6@gmail.com>
Date:   Fri, 4 Oct 2019 17:20:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAJieiUivWMD_QkqYA6Y08Ru3hCoy==MGaiNq7ma2K06WxgFuRg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/4/19 11:43 AM, Roopa Prabhu wrote:
> On Fri, Oct 4, 2019 at 9:38 AM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 10/4/19 8:43 AM, Ido Schimmel wrote:
>>>> Sounds like there are 2 cases for prefixes that should be flagged to the
>>>> user -- "offloaded" (as in traffic is offloaded) and  "in_hw" (prefix is
>>>> in hardware but forwarding is not offloaded).
>>> Sounds good. Are you and Roopa OK with the below?
>>>
>>> RTM_F_IN_HW - route is in hardware
>>> RTM_F_OFFLOAD - route is offloaded
>>>
>>> For example, host routes will have the first flag set, whereas prefix
>>> routes will have both flags set.
>>
>> if "offload" always includes "in_hw", then are both needed? ie., why not
>> document that offload means in hardware with offloaded traffic, and then
>> "in_hw" is a lesser meaning - only in hardware with a trap to CPU?
> 
> I was wondering if we can just call these RTM_F_OFFLOAD_TRAP or
> RTM_F_OFFLOAD_ASSIT or something along those lines.
> 
> My only concern with the proposed names is, both mean HW offload but
> only one uses HW in the name which can be confusing down the lane :).

sounds good to me.
