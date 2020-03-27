Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11284194F95
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 04:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgC0DLY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 26 Mar 2020 23:11:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34852 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgC0DLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 23:11:23 -0400
Received: from mail-pl1-f200.google.com ([209.85.214.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jHfOz-0004aQ-Qx
        for netdev@vger.kernel.org; Fri, 27 Mar 2020 03:11:22 +0000
Received: by mail-pl1-f200.google.com with SMTP id x1so5626793pln.12
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 20:11:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=vcPbgKJFNBF/8OZqL1JZORYE0AqNLU0C16CcoGlMb4U=;
        b=OISQaya4gUZCIjCMvory2TRU8cnFBnbgXuWlMNg/AiAINuapN1U9UaLingrRUjqqYr
         Wq0WoOvF62LQawHoXh/q/A0UJ/Uq/0DDDKW6J7qVRT0urmraP9euODERHfqAHAmjd0/6
         Q7aXTvzMJpRJ3eD25yQsGx91ETmdo5fe5TL0ynfAW8Yd6/TA+KGc57EuDKg6fZDHZT7r
         N7JQSUBMyBeCDWMdAy/WXCUtlShEhKcJHFzEi2kWSc3QMvqBshwu0SvSok0ytbF0qO2r
         bBqnML0mlJcwsl3JCZz49JA32lKtbbDyGrjnVRTtcw9WA9hJuOqnZQfmS9kevwEHchkC
         e/hg==
X-Gm-Message-State: ANhLgQ3YzDnUv/Tf/7KwkWQC4PIyzBLJoHR/9LXeelz/5nx7LdcbKwIv
        muX3XT1usivGG7mYlYsPalrnewADmWirGlkrah829bqY0DgzFIG5O3+oC0bSQECUqKE1vkNsQZI
        t5/2ApfHOQG9fYTR9C4yQtQ4csg+VqFNAdg==
X-Received: by 2002:a17:902:8ec1:: with SMTP id x1mr11368399plo.325.1585278680453;
        Thu, 26 Mar 2020 20:11:20 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vs4op9fy3xKomc3EgFRFOTZcnMtRNhP4jpF/07IDEBFVOd2yoJDw5eP5W8jTaXlCj6OKkxZIw==
X-Received: by 2002:a17:902:8ec1:: with SMTP id x1mr11368367plo.325.1585278680067;
        Thu, 26 Mar 2020 20:11:20 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id 11sm2844685pfz.91.2020.03.26.20.11.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Mar 2020 20:11:19 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH] ethtool: Report speed and duplex as unknown when device
 is runtime suspended
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <d6c5a1c4-e41f-d239-e0b0-15eba3e78274@gmail.com>
Date:   Fri, 27 Mar 2020 11:11:16 +0800
Cc:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        alexander.duyck@gmail.com,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <84A954EF-4DF6-4F1C-88CE-9B4C0D1ACE5B@canonical.com>
References: <20200327024552.22170-1-kai.heng.feng@canonical.com>
 <d6c5a1c4-e41f-d239-e0b0-15eba3e78274@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 27, 2020, at 10:56, Florian Fainelli <f.fainelli@gmail.com> wrote:
> 
> 
> 
> On 3/26/2020 7:45 PM, Kai-Heng Feng wrote:
>> Device like igb gets runtime suspended when there's no link partner. We
>> can't get correct speed under that state:
>> $ cat /sys/class/net/enp3s0/speed
>> 1000
>> 
>> In addition to that, an error can also be spotted in dmesg:
>> [  385.991957] igb 0000:03:00.0 enp3s0: PCIe link lost
>> 
>> Since device can only be runtime suspended when there's no link partner,
>> we can directly report the speed and duplex as unknown.
>> 
>> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>> Cc: Aaron Brown <aaron.f.brown@intel.com>
>> Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> 
> I would push this to the responsibility of the various drivers instead
> of making this part of the standard ethtool implementation.

My original approach [1] is to ask device to runtime resume before calling __ethtool_get_link_ksettings().
Unfortunately it will cause a deadlock if the runtime resume routine wants to hold rtnl_lock.

However, it should be totally fine (and sometimes necessary) to be able to hold rtnl_lock in runtime resume routine as Alexander explained [2].
As suggested, this patch handles the situation directly in __ethtool_get_link_ksettings().

[1] https://lore.kernel.org/lkml/20200207101005.4454-2-kai.heng.feng@canonical.com/
[2] https://lkml.org/lkml/2020/3/26/989

Kai-Heng

> -- 
> Florian

