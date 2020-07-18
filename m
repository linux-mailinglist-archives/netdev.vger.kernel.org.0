Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B4F224DD8
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 22:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgGRUga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 16:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgGRUg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 16:36:29 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC8BC0619D2;
        Sat, 18 Jul 2020 13:36:29 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ch3so8099936pjb.5;
        Sat, 18 Jul 2020 13:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bk2QSR1SuLlLo+kcm5baN1Xf8lfAD0BCwF2zEj5OvgI=;
        b=cEN169Ljx0z2eMiuFm4ls2BJZyDql8ita1d1jL8fkjGmmlXoyInNKBQIrIw1zjSn9x
         ZK3rHJciUVRSYIUTRxbfLmASYiifjy1uRSD2TPA7Dnb/Io9NthetjtsyOxbG5KN01tSE
         5Fae9RSGHPUJ9S4H+vsXQjanhPwjr1Frf1jL+ivPrm5VASeMJPvjTnMwl8iIe2DdNwtb
         OakJV23lvxbFQntJH+V/2upiyMNpt5NxTXDjiE2NWdh8F7Z2+/dzt7S7xI/wqOpvN4ts
         C6bvPWDA0I3bi35eK5UCn0rYVqjJk2Lyg//6IZOsAdJXy4QJg7BOWNYFfSKUHG0GO965
         SHZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bk2QSR1SuLlLo+kcm5baN1Xf8lfAD0BCwF2zEj5OvgI=;
        b=UgwNLoJC4xCqkuDaKkXXKNsDF6HloQMXS1JPvE4233JK1p1j07GAsgCmseAS/KvYM6
         ZG7n8uA/kCTjSPuOWFUrzxBeyjCYaM4y4R32ULQCLuEl6j+YY8PErncMXOIJYHTRPE1s
         31LxOTVjA6eagO528noNP4p3dPiVAESkcpc2lkKCR6Pwzr6MOHbpDjyPsIALrbpp7wL1
         T3Oqj7eknKbrK3kdaJ9nZK9qYDTHAZzglD0+ioNYvlY1ribSSZOeDdtoGVNhMZMiK0Cj
         ZOzD77oBDlGqwMKlYgpW71RD1gFHpS41NaRgF/DOVOPBSEecn3MSUyUHv86m/XH0HEev
         FrSQ==
X-Gm-Message-State: AOAM531bzC6V352wxyw428f98uoRneDuW0pOV7pGX/OjILAt0YQ3Kkiv
        Fh7EMIshxIdaUQKoJKIaDKc+7Vso
X-Google-Smtp-Source: ABdhPJxV18hqicPRNLCtLq6tx02zh1hg/C/XIKs7z89+YOShPtmGkPPq7MqhfFpx1NsC7VbdTgampw==
X-Received: by 2002:a17:90a:2b0f:: with SMTP id x15mr10843455pjc.230.1595104588486;
        Sat, 18 Jul 2020 13:36:28 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id k26sm10868029pgt.90.2020.07.18.13.36.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jul 2020 13:36:27 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] net: Wrap ndo_do_ioctl() to prepare for DSA
 stacked ops
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        open list <linux-kernel@vger.kernel.org>
References: <20200718030533.171556-1-f.fainelli@gmail.com>
 <20200718030533.171556-2-f.fainelli@gmail.com>
 <20200718203010.6dg5chsor5rufkaa@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a8b08bf9-2f45-8816-4056-2da42d4d9e24@gmail.com>
Date:   Sat, 18 Jul 2020 13:36:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200718203010.6dg5chsor5rufkaa@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/2020 1:30 PM, Vladimir Oltean wrote:
> Hi Florian,
> 
> On Fri, Jul 17, 2020 at 08:05:30PM -0700, Florian Fainelli wrote:
>> In preparation for adding another layer of call into a DSA stacked ops
>> singleton, wrap the ndo_do_ioctl() call into dev_do_ioctl().
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
> 
> I missed most of the context, but this looks interesting. Am I correct
> in saying that this could save us from having to manually pass
> phy_mii_ioctl() and that it could be generically handled here?

The motivation for this work started with the realization while
untangling the ethtool/netlink and PHY library that tests like those:
dev->netdev_ops == &foo_ops would be defeated by the way DSA overloads
the DSA net_device operations. A better solution needed to be found.

You are correct that we could just put a call to phy_mii_ioctl() here as
well and avoid having drivers have to use phy_do_ioctl_running or roll
their own.
-- 
Florian
