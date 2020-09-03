Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C110825CC9F
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbgICVrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgICVrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 17:47:31 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A65C061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 14:47:30 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p37so3181513pgl.3
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 14:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=F7BljZUAIEa3VMbrJazt0L9sV4RdijSAf9FDYnnIDP0=;
        b=hKElvhRraLck58UTZnq6Xta/FQDqpZAqL2Swj0ssR2sVNExCppSO1b0Ff1lgyK/paV
         jcPPN2mfg4qSeFlvI6fITkfmqHwKzVb3emf+o6UzOoiAcm1DjBf9ymRA8GvYk4kIzVk9
         0HPWuBVqFBSqSPjXZgiFuA5kzRmC8rUZpZHLuTwd2ChGCd+IeDlOdYwMWYU9gFSn3Nr9
         R3mk7kSd7/Abfa2XIyTPV+Vi9nUlyNOUWwLNirR2YT7Ptzvh4CgVs9pMksZQndmQm0Kc
         WnTaJ3S0G7/a8FY4fqJachSH4fe7Tb1b+OQu/q2k13dfswIO+M3K41rMMfVvY2v687E5
         azmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=F7BljZUAIEa3VMbrJazt0L9sV4RdijSAf9FDYnnIDP0=;
        b=rP2/hBamufzUrDXwm7OGlMBgvCtwO6sxOWE+oxW7/Ff9gLBv+qT+7A1lC3Rxrwg6Wj
         DSB1AqVUV7rFlZhbhcClk60Yp+A/l6S/VTvPYjKPxV7MhOYbOL1HpA9+bgoExvioBxbE
         fG+k9O1isJLuBAkotTnTYh4xaUEfF7qzXTd7Trh5jVaAfWLWvi9n6dHq3Xia/6kE0url
         vbroNkzAr3GLxmMDwbxrAN8ZizGSF04jrz18pQ2KGIso2tvb0Q7ewfSGlMktx4fSwhsf
         Ohzz6Z9KLnnzp4WdrvEMxsl5kH5zyqMOxw0AWy2lq7aYrBNk7BUfIu2Ho3GqIakradRk
         cJAA==
X-Gm-Message-State: AOAM531BrkOE0ZM9Qa2TaMUQIdWioLsw3nVdqtbkRzujUqHAwdHqM16n
        mDcGJDpaQ/gRWinkcqgcFBsnxg==
X-Google-Smtp-Source: ABdhPJyTfSs7tQeFIUSql92Npe+n4mukLrJPll8V6O7DMXwBH4emDSKiMFcaP8EwEdeIfOyBhIhpHQ==
X-Received: by 2002:a17:902:6a8b:: with SMTP id n11mr6015067plk.156.1599169650157;
        Thu, 03 Sep 2020 14:47:30 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id c7sm891674pfj.100.2020.09.03.14.47.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 14:47:29 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] ionic: add devlink firmware update
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200902195717.56830-1-snelson@pensando.io>
 <20200902195717.56830-3-snelson@pensando.io>
 <20200903125350.4bc345e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <bd395a37-92b1-8d5f-eea5-66bb82a02e94@pensando.io>
 <20200903144559.4aae08f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <6ea33f91-3428-f948-1cf8-cb0e272ab041@pensando.io>
Date:   Thu, 3 Sep 2020 14:47:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200903144559.4aae08f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/3/20 2:45 PM, Jakub Kicinski wrote:
> On Thu, 3 Sep 2020 14:37:40 -0700 Shannon Nelson wrote:
>> On 9/3/20 12:53 PM, Jakub Kicinski wrote:
>>> On Wed,  2 Sep 2020 12:57:17 -0700 Shannon Nelson wrote:
>>>> Add support for firmware update through the devlink interface.
>>>> This update copies the firmware object into the device, asks
>>>> the current firmware to install it, then asks the firmware to
>>>> set the device to use the new firmware on the next boot-up.
>>> Activate sounds too much like fw-active in Moshe's patches.
>>>
>>> Just to be clear - you're not actually switching from the current
>>> FW to the new one here, right?
> Please answer this.

Correct, we're simply setting it up for use on the next reboot.

>
>>> If it's more analogous to switching between flash images perhaps
>>> selecting would be a better term?
>>>   
>>>> The install and activate steps are launched as asynchronous
>>>> requests, which are then followed up with status requests
>>>> commands.  These status request commands will be answered with
>>>> an EAGAIN return value and will try again until the request
>>>> has completed or reached the timeout specified.
>> I think I can find a way to reword that - perhaps "enable" would be
>> better than "activate"?
> I was saying "select". But "enable" is fine.

"Select" works fine as well.

Thanks,
sln

