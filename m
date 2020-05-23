Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E830C1DF6C9
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 13:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387759AbgEWLGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 07:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727805AbgEWLGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 07:06:38 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F376AC061A0E
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 04:06:37 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id n141so849177qke.2
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 04:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=920i5BdoLOb/IIp9PeKovVvoU7Hz3B0geMlXilsw7Gw=;
        b=qseDn46oCaYssYxI1gjkR2ljXE9/+dw9xWYolRdXzfTFWOc0quGw5xn0yWlMmeuGKy
         5W/RhrlLUBEwwmVAjNljO3RFKZE3LuhGChWalK0+4DMslbWOFHkn8Xeki4Ab+73JY/N1
         wOtgO1KbrY8QhceVM7m58lSza4ZggHGz82Nfk/7HW4lM7VEGOm29dQR+QzqQsuh+0lfk
         a9duPIFFNr2M9dDOA7b2Y909EunbR/zIRJy2R6con3vETiWRBHrlmr1gcpzh7JRLU/Gb
         c5mIFL72GRobrJQLkQzm7xEMPIpPXhMeKyMg3xvPoLPZOpf1m2SvyE43ZQKYuc+Hix43
         6fjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=920i5BdoLOb/IIp9PeKovVvoU7Hz3B0geMlXilsw7Gw=;
        b=mj0O2pbt5ITKLd2ZTGafhl8RP01wLfjMKtCEa7RGz4ba+goI8/jE3is71LAf2Ni09p
         me+W0uW95XUnCrHKRG3jVgIR6HVhxBs9nxSScROvSITvAUTq/L7FBAqaR9tqVdzuX6Bu
         FtkwLlSmifCcYeHVr7GNcVT9XzK1huZQCTWbLENqVyDhYRzephvR8zfzVI+DVzyGpuw7
         XEay8zal6BDJWcgDV0jrgJ6zNmMov04vIRWbcJb6AhMDl6bcByE3GovQPDQgEpdz9cXx
         H3YfM6ppb926MxlsYvA9W5A41fnJQUqxW/UDGBP25U1aFla1EVAaYQQb7z1CMYrM3KzW
         43jg==
X-Gm-Message-State: AOAM5326p+VIz3RUMGicCUrtsFcfjaaJnOy0/wxmOUWGSFU2AvpEZdhr
        rk23tNNkb7OzA2WBNKKzCVqc4q6TDrrcww==
X-Google-Smtp-Source: ABdhPJyOYO5Aylkms8zqH7HSwXp2jIAFtTloJ0G95k7NYp7XZBsiR4ZDrrmcwQCJJ4kkKTyF/GJM+Q==
X-Received: by 2002:a37:e102:: with SMTP id c2mr12376439qkm.296.1590231997062;
        Sat, 23 May 2020 04:06:37 -0700 (PDT)
Received: from [10.0.0.248] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id p25sm933371qtj.18.2020.05.23.04.06.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2020 04:06:36 -0700 (PDT)
Subject: Re: [PATCH net-next v2 0/4] Implement classifier-action terse dump
 mode
To:     Vlad Buslov <vlad@buslov.dev>, Jakub Kicinski <kuba@kernel.org>
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        Edward Cree <ecree@solarflare.com>, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net, jiri@resnulli.us,
        dcaratti@redhat.com, marcelo.leitner@gmail.com
References: <20200515114014.3135-1-vladbu@mellanox.com>
 <649b2756-1ddf-2b3e-cd13-1c577c50eaa2@solarflare.com>
 <vbf1rndz76r.fsf@mellanox.com>
 <20200521100214.700348e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87imgo9c8m.fsf@buslov.dev>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <ab8a9010-0dfe-1799-7c81-67b04a4784b1@mojatatu.com>
Date:   Sat, 23 May 2020 07:06:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <87imgo9c8m.fsf@buslov.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-22 12:16 p.m., Vlad Buslov wrote:
> On Thu 21 May 2020 at 20:02, Jakub Kicinski <kuba@kernel.org> wrote:
>> On Thu, 21 May 2020 17:36:12 +0300 Vlad Buslov wrote:
>>> Hi Edward, Cong,
>>>

>> Do you really need to dump classifiers? If you care about stats
>> the actions could be sufficient if the offload code was fixed
>> appropriately... Sorry I had to say that.
> 
> Technically I need neither classifier nor action. All I need is cookie
> and stats of single terminating action attached to filter (redirect,
> drop, etc.). This can be achieved by making terse dump output that data
> for last extension on filter. However, when I discussed my initial terse
> dump idea with Jamal he asked me not to ossify such behavior to allow
> for implementation of offloaded shared actions in future.
> 


Trying to recollect our discussion (please forgive me if i am
rehashing). old skule hardware model typically is ACL style with one
action - therefore concept of tying a counter with with
a classifier is common.

Other hardware i am familiar with tends to have a table of counters.
More an array with indices.
In the shared case using the same counter index from multiple
tables implies it is shared. Note "old skule" does not have
a concept of sharing.

So i was more worried about assuming the "old skule" model
at the expense of other hardware models.
We should be able to dump different tables from hardware.
Mostly these could be tables of actions. And counter tables
look like a gact action.

 From s/w:
If what is needed is to just dump explicit stats a gact
action with a cookie and an index would suffice.
i.e tc match foobar \
action continue cookie blah index 15 \
action ...
action mirred redirect ...

of course this now adds extra cycles in the s/w datapath but
advantage is it means you can cheaply either get
individual counters (get action gact index 15) or dump all gact actions
and filter in user space for your cookie. Or introduce a dump
cookie filter in the kernel (similar to the "time since" action
dump filter).

cheers,
jamal

> Speaking about shared action offload, I remember looking at some RFC
> patches by Edward implementing such functionality and allowing action
> stats update directly from act, as opposed to current design that relies
> on classifier to update action stats from hardware. Is that what you
> mean by appropriately fixing offload code? With such implementation,
> just dumping relevant action types would also work. My only concern is
> that the only way to dump actions is per-namespace as opposed to
> per-Qdisc of filters, which would clash with any other cls/act users on
> same machine/hypervisor.
> 
> 
> [...]
> 

