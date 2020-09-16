Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD7E26CCAD
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbgIPUsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbgIPRBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 13:01:14 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26F1C014D06;
        Wed, 16 Sep 2020 06:38:27 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 34so3885592pgo.13;
        Wed, 16 Sep 2020 06:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=RPMmBa/zuVIVa6YT0Ct/PRYo3W8xK4AI2YIowuyMAz8=;
        b=fHilp9TKndRfRIpIEW7pskStpJIx9tJimZ/y0pA9ypEvUHuYNm+18QlWmYOouD1tX0
         LCK9aNAEI5YK+8CxLy6PgjIyLZmIZKfqvdx8B+9dwUnu8GnDSki3ejFJDcxMtw4ZvZkD
         o58I2PumQyjbrEwCBsQvpOvIod2iRymYkDGLSlbDNe4W6UpmWWVqCwY2nBO6TgvF0l4g
         KHU2qC9MgZICr7bfyPlIUWcx9aqQb6z72coEyRXs4xC52mJuXIJ47/9zIuWZe9xlXciN
         rWrQ0jdnFJUZre4qzzTb/8uUrDgfCghNIQGgFqFdkhyrVn5mG75WLqiOFP8ZrHLbyxL8
         NelQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=RPMmBa/zuVIVa6YT0Ct/PRYo3W8xK4AI2YIowuyMAz8=;
        b=jfTHcUUvW1CA4vlmQzW1747Vme3acmyrR3wNr4HC65JdygXqIXH7fDntCYyEB+f4i8
         QOTQNC6c28ILk0iygOtM069qUUUne4a3FBHnWoT05EQUq3zaNhp635qY/iX5GOj2OneX
         kUtt8blkzqNfd/fYrsDofD7iD4au/6oi/Ywr73rYPRzzoXfdz0hMAk2enY6UVBlXSFf9
         AL4KJLZx0ONwZ+GA9hIcgPg3I37DQErwYXyJv2jeW6uLdTyrrYmaoE5t7HKfP0FxbL+Z
         0dT5Oq/iFHY9g7QA6qJso1RCbzaN5FBHMSoaH1YiOJQ8ewHZWJKr+gF0BPR0QOMIDXol
         0X5w==
X-Gm-Message-State: AOAM531Dw56MEgBasnOcUr5nIuOy12nC75STWwx/VKsehDoX4SYaetoC
        AcfZy4lkMfMbgI3cSMSomRkrRNVSgiKjVukRLFE=
X-Google-Smtp-Source: ABdhPJw8pDY+mq6BWskzMRd1QiEHrMA+qZcz43pBqGlrejs0IcKqbHwaajsxiVnJqEydNRZeG2HCHg==
X-Received: by 2002:a63:30c:: with SMTP id 12mr18613171pgd.66.1600263506704;
        Wed, 16 Sep 2020 06:38:26 -0700 (PDT)
Received: from [192.168.0.104] ([49.207.198.18])
        by smtp.gmail.com with ESMTPSA id e62sm16987968pfh.76.2020.09.16.06.38.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2020 06:38:26 -0700 (PDT)
Subject: Re: [Linux-kernel-mentees][PATCH] rtl8150: set memory to all 0xFFs on
 failed register reads
To:     Petko Manolov <petkan@nucleusys.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200916050540.15290-1-anant.thazhemadam@gmail.com>
 <20200916061946.GA38262@p310>
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <780e991d-864d-0491-f440-12a926920a8a@gmail.com>
Date:   Wed, 16 Sep 2020 19:08:21 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200916061946.GA38262@p310>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 16/09/20 11:49 am, Petko Manolov wrote:
> On 20-09-16 10:35:40, Anant Thazhemadam wrote:
>> get_registers() copies whatever memory is written by the
>> usb_control_msg() call even if the underlying urb call ends up failing.
> Not true, memcpy() is only called if "ret" is positive.
Right. I'm really sorry I fumbled and messed up the commit message
there. Thank you for pointing that out.
>> If get_registers() fails, or ends up reading 0 bytes, meaningless and junk 
>> register values would end up being copied over (and eventually read by the 
>> driver), and since most of the callers of get_registers() don't check the 
>> return values of get_registers() either, this would go unnoticed.
> usb_control_msg() returns negative on error (look up usb_internal_control_msg() 
> to see for yourself) so it does not go unnoticed.

When I said "this would go unnoticed", I meant get_register() failing would
go unnoticed, not that usb_control_msg() failing would go unnoticed.
I agree that get_registers() notices usb_control_msg() failing, and
appropriately returns the return value from usb_control_msg().
But there are many instances where get_registers() is called but the return
value of get_registers() is not checked, to see if it failed or not; hence, "this
would go unnoticed".

> If for some reason it return zero, nothing is copied.  Also, if usb transfer fail 
> no register values are being copied anywhere.

True.
Now consider set_ethernet_addr(), and suppose get_register() fails when
invoked from inside set_ethernet_addr().
As you said, no value is copied back, which means no value is copied back
into node_id, which leaves node_id uninitialized. This node_id (still
uninitialized) is then blindly copied into dev->netdev->dev_addr; which
is less than ideal and could also quickly prove to become an issue, right?

> Your patch also allows for memcpy() to be called with 'size' either zero or 
> greater than the allocated buffer size. Please, look at the code carefully.
Oh. I apologize for this. This can be reverted relatively easily.
>> It might be a better idea to try and mirror the PCI master abort
>> termination and set memory to 0xFFs instead in such cases.
> I wasn't aware drivers are now responsible for filling up the memory with 
> anything.  Does not sound like a good idea to me.
Since we copy the correct register values when get_register() doesn't fail,
I thought it might be a slightly better alternative to fill node_id with 0xFFs,
instead of leaving it go uninitialized in case get_registers() fails.

Also, what are the odds that a successful get_register() call would see
0xFFs being copied?
If that's very real scenario, then I admit this doesn't work at all.

The only other alternative approach I can think of that can handle the
issue I highlighted above, is to introduce checking for get_registers()'s
return values nearly everywhere it gets called.
Would that be a more preferable and welcome approach?

Thank you for your time.

Thanks,
Anant


