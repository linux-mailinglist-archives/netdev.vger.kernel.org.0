Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 799DFF4200
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 09:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730364AbfKHIUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 03:20:44 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42544 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfKHIUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 03:20:44 -0500
Received: by mail-lj1-f196.google.com with SMTP id n5so5238343ljc.9
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 00:20:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QG9zESozXuPqax0Su22O3OuOKh63DOSfZk/pA62adHY=;
        b=tb4SJdKVM/w0afIl2iDuSX1FsRMT3D5VW7rb46sbKMYFjCDJ7FG4wbT+OmmYHd9Np+
         mAn67I7zY5tlX5PbhNUT9ZUgvP5KhWQDjKCATuXQa8qTt0eOnlE3Pqa610+pSZrmYtDs
         6PkyyKCSTj7M+vwQ4+/OFkc29lK/eXpbnf2vjAmCIBAjzcxy2doAC8x0Tqut3x2C+7zT
         nP+XezvW/C+sH7/eLPd7VC652IqObU6nbzKPRE9jRYarWSJsUhkF4+YySPGDBK0rdxPe
         Y+GnIwsIx320akOFEEnwpR2jHL0sR5N/QQbq9YnBnKfiFkYtmPQPKN+W8PdUopjyyQcJ
         2LnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QG9zESozXuPqax0Su22O3OuOKh63DOSfZk/pA62adHY=;
        b=GoWyK5p7hcJuMoK/aToAcyb8GpGiF0UHTXRH8Rju5a+4wO3Ht2pqZ4YqZDI+tdCVKh
         6QPeaGIkAOwiMLnR0jt4Mltq//ClHtLZ6T7neR/AMCDHeDZLlVt72seWWqfT5UFmRkir
         8559dJrrj6HSorQo+lLMbHUpgsx7Q/zM9Tu3ms2/Q8ldKUYvZB79tA/jnHT5DNTfLowF
         wjm+j84eMMEUEpH77bRFsAHBMPApjra/jgN/lnd7olcx3033DTpZbOQsYndux9ifBO7t
         S7b6DccU11pH8mNEjRcoxsG2O3N4i92SY00Hw2YjyDGzGp5zZUxAqfOSFgQ6354dJKBk
         ScSQ==
X-Gm-Message-State: APjAAAWb2hbBXChDTbrtJpeTHEDhXSPWQXVTEvtiQc+LR0ecWrfymKui
        kda6ixr2WLRXgfExfn8bLtZS0w==
X-Google-Smtp-Source: APXvYqyq6o5NlSxHPqiqstI0v5ozYcuJbwWvebOQkf/OT4itQMED7hNHHM+1S1k07Hx73vma7ozOdw==
X-Received: by 2002:a2e:8595:: with SMTP id b21mr286960lji.155.1573201242525;
        Fri, 08 Nov 2019 00:20:42 -0800 (PST)
Received: from [10.0.156.104] ([195.22.87.57])
        by smtp.gmail.com with ESMTPSA id 68sm2523544ljf.26.2019.11.08.00.20.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Nov 2019 00:20:41 -0800 (PST)
Subject: Re: [PATCH v3 1/6] rtnetlink: allow RTM_SETLINK to reference other
 namespaces
To:     =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS1?=
         =?UTF-8?B?4KS+4KSwKQ==?= <maheshb@google.com>
Cc:     nicolas.dichtel@6wind.com, linux-netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
References: <20191107132755.8517-1-jonas@norrbonn.se>
 <20191107132755.8517-2-jonas@norrbonn.se>
 <CAF2d9jjRLZ07Qx0NJ9fi1iUpHn+qYEJ+cacKgBmeZ2FvZLObEQ@mail.gmail.com>
From:   Jonas Bonn <jonas@norrbonn.se>
Message-ID: <fff51fa7-5c42-7fa7-6208-d911b18bd91e@norrbonn.se>
Date:   Fri, 8 Nov 2019 09:20:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <CAF2d9jjRLZ07Qx0NJ9fi1iUpHn+qYEJ+cacKgBmeZ2FvZLObEQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mahesh,

On 07/11/2019 21:36, Mahesh Bandewar (महेश बंडेवार) wrote:
> On Thu, Nov 7, 2019 at 5:30 AM Jonas Bonn <jonas@norrbonn.se> wrote:
>>
>>
>> +       /* A hack to preserve kernel<->userspace interface.
>> +        * It was previously allowed to pass the IFLA_TARGET_NETNSID
>> +        * attribute as a way to _set_ the network namespace.  In this
>> +        * case, the device interface was assumed to be in the  _current_
>> +        * namespace.
>> +        * If the device cannot be found in the target namespace then we
>> +        * assume that the request is to set the device in the current
>> +        * namespace and thus we attempt to find the device there.
>> +        */
> Could this bypasses the ns_capable() check? i.e. if the target is
> "foo" but your current ns is bar. The process may be "capable" is foo
> but the interface is not found in foo but present in bar and ends up
> modifying it (especially when you are not capable in bar)?

I don't think so.  There was never any capable-check for the "current" 
namespace so there's no change in that regard.

I do think there is an issue with this hack that I can't see any 
workaround for.  If the user specifies an interface (by name or index) 
for another namespace that doesn't exist, there's a potential problem if 
that name/index happens to exist in the "current" namespace.  In that 
case, one many end up inadvertently modifying the interface in the 
current namespace.  I don't see how to avoid that while maintaining the 
backwards compatibility.

My absolute preference would be to drop this compat-hack altogether. 
iproute2 doesn't use a bare TARGET_NETNSID in this manner (for changing 
namespaces) and I didn't find any other users by a quick search of other 
prominent Netlink users:  systemd, network-manager, connman.  This 
compat-hack is there for the _potential ab-user_ of the interface, not 
for any known such.

> 
>> +       if (!dev && tgt_net) {
>> +               net = sock_net(skb->sk);
>> +               if (ifm->ifi_index > 0)
>> +                       dev = __dev_get_by_index(net, ifm->ifi_index);
>> +               else if (tb[IFLA_IFNAME])
>> +                       dev = __dev_get_by_name(net, ifname);
>> +       }


/Jonas
