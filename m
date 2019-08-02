Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F5D7FDC7
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 17:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730295AbfHBPpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 11:45:40 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:34568 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfHBPpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 11:45:39 -0400
Received: by mail-pg1-f174.google.com with SMTP id n9so30041442pgc.1
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 08:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gRWxpC3d228mN2uOQi6C91N8PXVis7UxrNODEnrWkBw=;
        b=rlRfWAfOiLipOkAL+FSORCt6xeNNHi6jBu/fy6spzKB7D+u2xEWDGtG9RU2vkvtiLm
         sPZdTyBs3N6tkRAQKLqsWBkJ/Z5NxpTAnO5stZRJ0tmQ2Mfa+XCqH7gwKLrxkrVLT7fg
         OADbG4Aa1oNm1ScQpedrMyzkqy8++8huU4ydP062NfxeywqR48BwrKaFoB67zRc+gB+T
         rd+RVY/ENb6e9NhCRaVgqncvLZC+0dn1Z/iHZw9AN2POBLqtFhNYt0VCN8l6TF02aEWH
         YysHTQN7iTbzFoBGlL/77+y5hujGtLbq+lbGXLgagST9x5nzVyZWQ5qqGo0zFlQNTTky
         mnIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gRWxpC3d228mN2uOQi6C91N8PXVis7UxrNODEnrWkBw=;
        b=ml+Yeu1NwILeBAzwiAZN2H5WhQUkULtzQjcTnl0L+UmQhkGTReLDknxXSe2127S41L
         qqM9dX0smou2GjgfuOPBftoth7QDBYlc+OsTxzbqI9VUFNEZeFZaaYKlhb1ofslNl2L3
         +pifRQADFln75rSIVLHh/2Q58HyOtvPsVX4gbjaLXueEDIolmMtgKFqGXf258OAWlATh
         6lyvZeCcV33ge7JfZZ3Q+i0vyd84DdD7BRMkYo669ra25tdp+JzxrRlohcGMtYbpV4RT
         6qvSNsLBAs3QaR6curXOTnIsSQjhzyPwRRQbFf1srxjq/Hg0hQdKwFlgy1/MYFYeNUM0
         DvBg==
X-Gm-Message-State: APjAAAX6YgM3HsXOxmLlZ1HfByBxBIj7QA+5o+lKEetqFBIV0kPvI4GW
        KbX2PtQ9CEyHws5WULDuYJU=
X-Google-Smtp-Source: APXvYqzCRkmvlNT93ekVAXVZbiKEPAsquQeZ9MCUDJOdqS9k8TrR5ioXKZ3g87wcwKdjOkQfNYo8pQ==
X-Received: by 2002:a63:7245:: with SMTP id c5mr111798141pgn.11.1564760738949;
        Fri, 02 Aug 2019 08:45:38 -0700 (PDT)
Received: from [172.27.227.195] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id u16sm8342297pgm.83.2019.08.02.08.45.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 08:45:38 -0700 (PDT)
Subject: Re: [patch net-next v2 1/3] net: devlink: allow to change namespaces
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, mlxsw@mellanox.com
References: <20190730085734.31504-1-jiri@resnulli.us>
 <20190730085734.31504-2-jiri@resnulli.us>
 <20190730153952.73de7f00@cakuba.netronome.com>
 <20190731192627.GB2324@nanopsycho>
 <c4f83be2-adee-1595-f241-de4c26ea55ca@gmail.com>
 <20190731194502.GC2324@nanopsycho>
 <087f584d-06c5-f4b9-722b-ccb72ce0e5de@gmail.com>
 <89dc6908-68b8-5b0d-0ef7-1eaf1e4e886b@gmail.com>
 <20190802074838.GC2203@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6f05d200-49d4-4eb1-cd69-bd88cf8b0167@gmail.com>
Date:   Fri, 2 Aug 2019 09:45:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190802074838.GC2203@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/19 1:48 AM, Jiri Pirko wrote:
> Wed, Jul 31, 2019 at 09:58:10PM CEST, dsahern@gmail.com wrote:
>> On 7/31/19 1:46 PM, David Ahern wrote:
>>> On 7/31/19 1:45 PM, Jiri Pirko wrote:
>>>>> check. e.g., what happens if a resource controller has been configured
>>>>> for the devlink instance and it is moved to a namespace whose existing
>>>>> config exceeds those limits?
>>>>
>>>> It's moved with all the values. The whole instance is moved.
>>>>
>>>
>>> The values are moved, but the FIB in a namespace could already contain
>>> more routes than the devlink instance allows.
>>>
>>
>>From a quick test your recent refactoring to netdevsim broke the
>> resource controller. It was, and is intended to be, per network namespace.
> 
> unifying devlink instances with network namespace in netdevsim was
> really odd. Netdevsim is also a device, like any other. With other
> devices, you do not do this so I don't see why to do this with netdevsim.
> 
> Now you create netdevsim instance in sysfs, there is proper bus probe
> mechanism done, there is a devlink instance created for this device,
> there are netdevices and devlink ports created. Same as for the real
> hardware.
> 
> Honestly, creating a devlink instance per-network namespace
> automagically, no relation to netdevsim devices, that is simply wrong.
> There should be always 1:1 relationshin between a device and devlink
> instance.
> 

Jiri: prior to your recent change netdevsim had a fib resource
controller per network namespace. Please return that behavior or revert
the change.
