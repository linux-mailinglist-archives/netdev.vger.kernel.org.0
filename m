Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 253ACB3CED
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 16:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387986AbfIPOyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 10:54:07 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43857 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfIPOyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 10:54:07 -0400
Received: by mail-pg1-f193.google.com with SMTP id u72so132665pgb.10
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 07:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v7/uJExwcRTggpNgGIMd1Qn2PalG5gJyradeWupA+nY=;
        b=VDdTmDf7QyNzhQtkhBGuvLSpKwMvQCJTbBx+lAIS4b/t9nuUydzUR3OhfKCPuZ+SmA
         vk3g8X4Pb/C1oY4JUB+Ak+TsilxxDhS/V6eTUBTH6J3PDP452CQhkBC3rQTrdnpMqGvj
         voH+DWBwGeAGiKap21208WwpBpOQDAEnyeU5tjij7HdYMQCbUEJUNm9sd4qdyfrpM7Tc
         KODJ7FfrVWucjsZC6DdxK3GEiC93/z4n8ZGlxkEk72cqqZC8P+qN6LY4lDf/Ek7kRkkw
         11I3x0BBA0WMB0hm5sOr+fix+yQg37M99Ot3+tTFYrOaiA712ygxEvmLYMXMzIeVudHG
         yaeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v7/uJExwcRTggpNgGIMd1Qn2PalG5gJyradeWupA+nY=;
        b=AwAgZGZTVyxhIh5zDSSiL9WG5EH+PjhNgvLQKV1M5eGm7lXOiH+0N5zb2UtdKLQtaG
         9LpgxCrjlEem6Gwj1DJUI0vMU7eGBK2P6FXD1gCzKKSUOl1l8uY2Erc3gVFYvZ5MClk4
         l/aDN89/W+7gVfZLEkgozJola8C3fi75LhLlwRRqQzlA+PBUe8aNWBiLaNBXrYqIE6aV
         gnLXG/IDJl8ORL0uBIzTN3SdFBHC2cy7xH6V58v/veoj7QvX5C462tsBTlW6kwA3lB0y
         kVt2JjrPQyDgngb4/tE5UuGGK+gO0Dj8oraMPbLgfoeVu+mvR1DOsJoHYPOy1Uz4igzp
         wfvw==
X-Gm-Message-State: APjAAAU93IDerSa7sfTYTW1l+LFDNdq16YqV+H3j1ix1HGUX3x4GXsJv
        2ZjS8VHD+eBU9VmXAkhpAZ8=
X-Google-Smtp-Source: APXvYqynfs+iKt6NiiSJKY0CPCFn9VU3bfkSYXFJ0vwzf4nxxP3//lYjv70dsX3P/BzhMmxobeGXxg==
X-Received: by 2002:a17:90b:318:: with SMTP id ay24mr151791pjb.28.1568645646370;
        Mon, 16 Sep 2019 07:54:06 -0700 (PDT)
Received: from [172.27.227.245] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id c14sm47307pjr.20.2019.09.16.07.54.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 07:54:05 -0700 (PDT)
Subject: Re: [patch net-next 02/15] net: fib_notifier: make FIB notifier
 per-netns
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
References: <20190914064608.26799-1-jiri@resnulli.us>
 <20190914064608.26799-3-jiri@resnulli.us>
 <87139e84-4310-6632-c5d5-64610d4cc56e@gmail.com>
 <20190916053801.GG2286@nanopsycho.orion>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <178785ef-f8f9-3a04-2e91-abdfb2b93b6d@gmail.com>
Date:   Mon, 16 Sep 2019 08:54:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190916053801.GG2286@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/15/19 11:38 PM, Jiri Pirko wrote:
>> This is still more complicated than it needs to be. Why lump all
>> fib_notifier_ops into 1 dump when they are separate databases with
>> separate seq numbers? Just dump them 1 at a time and retry that 1
>> database as needed.
> 
> Well I think that what you describe is out of scope of this patch. It is
> another optimization of fib_notifier. The aim of this patchset is not
> optimization of fib_notifier, but devlink netns change. This patchset is
> just a dependency.
> 
> Can't we do optimization in another patchset? I already struggled to
> keep this one within 15-patch limit.
> 

sure, but it seems to me it is less work to churn this code all at once
and you are already doing the testing. The fib notifier changes can
always be done as a prep set.

