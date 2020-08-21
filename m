Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3632124E40C
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 02:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgHVAAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 20:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbgHVAAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 20:00:22 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14387C061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 17:00:21 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id r21so2917734ota.10
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 17:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Zga9QKvYCNMPqGaK878RkuScGLfM6wFHT5YgfWSkVwI=;
        b=mOLFODjkWVAN2A28vUXTytHw6ccZP2QinEUHCjstBY3v0La0pLL4G3qi2qPov26C4x
         DpQqA/ifdWyJQEJ6fg7jhW+JHHIFZRmviThxsPRoy7ZF1uTlNCrt/lIZfzZoZpjTrrCH
         MU8zEzPF+dej/Jr4yBtSacyvkaXFKWgi2Cp1I8XKavaNipjvs94xZmZY/tUIx6flS2H9
         FXqOX/r6y0fcT5ZB3XPt6XDj2RjHL8D2pelyy+2ndFHyQXA+TXLThq6l6KbKpj5b56xJ
         UhyRJjrE7I5VKqM6gdGfNqBtF3mmSZpzRNrWGo8QVts2FFhWxgleUYRLEhrrkIlEcdtL
         JmCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zga9QKvYCNMPqGaK878RkuScGLfM6wFHT5YgfWSkVwI=;
        b=UKZpfzsUHhLqkp+zlIa9TbJKXrT0I3rch6d1jCpTvTT0XH7ZxiHk9W5lqfiy7bFdh+
         8pEgJLZ2ke27PGEwqHgInlvKOVNkBJQMu+2KJOvGm8BNFr/jnkjGVqGfQvTbpG0Eyf8Q
         OFC4+FQL90FxKuEjzKcbnlfUF9+R+nYU2fccAy5O2HjRFX6aKW13iw3tDJyNs6PsZu+N
         CO9sP7dAXX+eCJbCuV9yp5Dq0Q7Tcjov/DmhV2SAv5lhhHR+IWbMxIOCebjjBEoY5rTb
         cCSD1rGk/M1A02LO964B61pCEpncSlSCPSMUkkfW/7KOo3Jxuj5cb3icjNsj572bUrTn
         QUGQ==
X-Gm-Message-State: AOAM532Xp9Rnf9P/wRutKP0hC+2fzNl3xvaJIljFGMGdRUXN9ZAUCwRw
        2RhLQccWKTR8v7R+phjDs2k=
X-Google-Smtp-Source: ABdhPJxkAZkg9jhPM6tS3h9d7skcbGvZGtpX44beu0Y/XrjG2YtL1y/1izJlHCzW4A1K0yAwLByyOw==
X-Received: by 2002:a05:6830:18ec:: with SMTP id d12mr3528715otf.235.1598054418731;
        Fri, 21 Aug 2020 17:00:18 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:284:8202:10b0:a888:bc35:d7d6:9aca])
        by smtp.googlemail.com with ESMTPSA id y15sm665513oto.60.2020.08.21.17.00.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2020 17:00:17 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 0/6] devlink: Add device metric support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        roopa@nvidia.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        tariqt@nvidia.com, ayal@nvidia.com, mkubecek@suse.cz,
        Ido Schimmel <idosch@nvidia.com>
References: <20200817125059.193242-1-idosch@idosch.org>
 <20200818172419.5b86801b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <58a0356d-3e15-f805-ae52-dc44f265661d@gmail.com>
 <20200818203501.5c51e61a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <55e40430-a52f-f77b-0d1e-ef79386a0a53@gmail.com>
 <20200819091843.33ddd113@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <e4fd9b1c-5f7c-d560-9da0-362ddf93165c@gmail.com>
 <20200819110725.6e8744ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d0c24aad-b7f3-7fd9-0b34-c695686e3a86@gmail.com>
 <20200820090942.55dc3182@kicinski-fedora-PC1C0HJN>
 <20200821103021.GA331448@shredder>
 <20200821095303.75e6327b@kicinski-fedora-PC1C0HJN>
 <6030824c-02f9-8103-dae4-d336624fe425@gmail.com>
 <20200821165052.6790a7ba@kicinski-fedora-PC1C0HJN>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1e5cdd45-d66f-e8e0-ceb7-bf0f6f653a1c@gmail.com>
Date:   Fri, 21 Aug 2020 17:59:57 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200821165052.6790a7ba@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/20 5:50 PM, Jakub Kicinski wrote:
> On Fri, 21 Aug 2020 13:12:59 -0600 David Ahern wrote:
>> On 8/21/20 10:53 AM, Jakub Kicinski wrote:
>>> How many times do I have to say that I'm not arguing against the value
>>> of the data? 
>>>
>>> If you open up this interface either someone will police it, or it will
>>> become a dumpster.  
>>
>> I am not following what you are proposing as a solution. You do not like
>> Ido's idea of stats going through devlink, but you are not being clear
>> on what you think is a better way.
>>
>> You say vxlan stats belong in the vxlan driver, but the stats do not
>> have to be reported on particular netdevs. How then do h/w stats get
>> exposed via vxlan code?
> 
> No strong preference, for TLS I've done:

But you clearly *do* have a strong preference.

> 
> # cat /proc/net/tls_stat 

I do not agree with adding files under /proc/net for this.

> TlsCurrTxSw                     	0
> TlsCurrRxSw                     	0
> TlsCurrTxDevice                 	0
> TlsCurrRxDevice                 	0
> TlsTxSw                         	0
> TlsRxSw                         	0
> TlsTxDevice                     	0
> TlsRxDevice                     	0
> TlsDecryptError                 	0
> TlsRxDeviceResync               	0
> 
> We can add something over netlink, I opted for simplicity since global
> stats don't have to scale with number of interfaces. 
> 

IMHO, netlink is the right "channel" to move data from kernel to
userspace, and opting in to *specific* stats is a must have feature.

I think devlink is the right framework given that the stats are device
based but not specific to any particular netdev instance. Further, this
allows discrimination of hardware stats from software stats which if
tied to vxlan as a protocol and somehow pulled from the vxan driver
those would be combined into one (at least how my mind is thinking of this).

####

Let's say the direction is for these specific stats (as opposed to the
general problem that Ido and others are considering) to be pulled from
the vxlan driver. How does that driver get access to hardware stats?
vxlan is a protocol and not tied to devices. How should the connection
be made?
