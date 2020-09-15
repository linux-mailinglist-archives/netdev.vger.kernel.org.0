Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1737A26B072
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgIOWL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbgIOWLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 18:11:09 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139F9C06174A
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 15:11:09 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id o68so2781017pfg.2
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 15:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=P2z/Mk2qi+7OvW+/ZS+Qmc9TNG/Von5hC9FK5mZUlXA=;
        b=Y/XXppNUumA7Qo7wBFjFsjWR30rKzFI5jFAbz5fxQnKusGnXUXnj8YRjrMYKnTv+0y
         TAdWLIoltVqnNlrc6eS7tlVJpkcsWjYPoA69sd7nlgAKNUQ0VVnRe3fiTGOauidJl+Rt
         XziOJw7nRhPiwl4BBci4ublJkmwsk/8Q50z+TgxCkoWMbtr2WiFnmoz2V0nKwTN3OKe+
         pbkxOjMMY9DDaGEtIN2/w3CHBpkTD2bEK1iqpJf5cCCkec8UW7DqNizfSZ9Klaycq8sQ
         AYMfNJjiaUsm4+0UdU7+yf0qjSoh2Hg1CP1u5WIC0r6+SofOpwogPESWqxWhkaw+wmm4
         BmNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=P2z/Mk2qi+7OvW+/ZS+Qmc9TNG/Von5hC9FK5mZUlXA=;
        b=EqlIH96F3OqL2YL7kGQJiyAEPnEoTVo/z++XZ43URWongp/KThjZQMEjOgz8XhhFwO
         vtvEFTIJsnLwz4LgwFMRkozCLEYEXV3O/IReaNzbF3ttOFxB6ObhvIKH9eczlSMOY1IX
         kJxPFa6L6mxeZq6PMUps1lr+TXTnykob0cxqXFOCynR52xYD9iJfeEQ/bC6IEMx8Rnyl
         Gs1Fq7pXZR+n9fDOXBZUh3dVhGHR2RwtZMmjmaHvLrD1LW4WtQucBzMJ/r4rloUPf0+D
         ltHBtO1cTjRjrsXv64/RkfDzXaVOMdNPOpLuuWQ8KtNjaxXc7F0rp/ZI3OzfFfeZiRy5
         IelQ==
X-Gm-Message-State: AOAM530/D51Qkn17wZZeSnqHD7WV4kVrYC6F+6b2woCwsLkDcMw+vhPi
        o9OaH97ORtjryuFOFvEK7OcD6w==
X-Google-Smtp-Source: ABdhPJxNWVjysYn0lUGaNaddFjaoG5tTQLd3336JQOaDpdD+QFsJsms6TcqA5JxhPXwcF0vk3bBpGA==
X-Received: by 2002:a62:503:0:b029:13e:d13d:a0f9 with SMTP id 3-20020a6205030000b029013ed13da0f9mr19469602pff.21.1600207868419;
        Tue, 15 Sep 2020 15:11:08 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id bb6sm441857pjb.15.2020.09.15.15.11.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2020 15:11:07 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
To:     Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20200908224812.63434-1-snelson@pensando.io>
 <581f2161-1c55-31ae-370b-bbea5a677862@pensando.io>
 <20200909122233.45e4c65c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3d75c4be-ae5d-43b0-407c-5df1e7645447@pensando.io>
 <20200910105643.2e2d07f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a04313f7-649e-a928-767c-b9d27f3a0c7c@intel.com>
 <20200914163605.750b0f23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3b18d92f-3a0a-c0b0-1b46-ecfd4408038c@pensando.io>
 <7e44037cedb946d4a72055dd0898ab1d@intel.com>
 <f4e4e9c3-b293-cef1-bb84-db7fe691882a@pensando.io>
 <20200915085045.446b854b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <4b5e3547f3854fd399b26a663405b1f8@intel.com>
 <ad9b1163-fe3b-6793-c799-75a9c4ce87f9@pensando.io>
 <20200915103913.46cebf69@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1dfa16c8-8bb6-a429-6644-68fd94fc2830@intel.com>
 <20200915120025.0858e324@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <33d4fe46-9f67-998f-8bda-fc74c32eb910@pensando.io>
Date:   Tue, 15 Sep 2020 15:11:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200915120025.0858e324@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/15/20 12:00 PM, Jakub Kicinski wrote:
> On Tue, 15 Sep 2020 11:44:07 -0700 Jacob Keller wrote:
>> Exactly how I saw it.
>>
>> Basically, the timeout should take effect as long as the (component,
>> msg) pair stays the same.
>>
>> So if you send percentage reports with the same message and component,
>> then the timeout stays in effect. Once you start a new message, then the
>> timeout would be reset.
> I don't think I agree with that. As I said that'd make the timeout not
> match the reality of what happens in the driver.

I have an asynchronous FW interaction where the driver sends one FW 
command to start the fw-install and sends several more FW commands to 
check on the status until either it gets a done or error status or too 
many seconds have elapsed.  How would you suggest this gets modeled?

In the model you are suggesting, the driver can only do a single 
status_notify with a timeout before the initial async FW command, then 
no other status_notify messages until the driver gets the done/error 
status, or the time has elapsed, regardless of how long that might 
take.  The user will only see the timeout ticking, but no activity from 
the driver.  This allows the user to see what the deadline is, but 
doesn't reassure them that the process is still moving.

I'm suggesting that the driver might send some intermediate 
status_notify messages in order to assure the user that things are not 
stalled out.  Driving a spinner would be nice, but we don't have that 
concept in this interface, so poking the done/total values could be used 
for that.  In order to not reset the timeout on each of these 
intermediate updates, we pass the same timeout value.

At this point I'm going to try a patchset that implements the basics 
that we already have agreed upon, and this detail can get worked out 
later, as I believe it doesn't change the internal implementation.

sln



