Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B082A116338
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 18:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfLHReh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Dec 2019 12:34:37 -0500
Received: from mail-io1-f49.google.com ([209.85.166.49]:39552 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbfLHReg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Dec 2019 12:34:36 -0500
Received: by mail-io1-f49.google.com with SMTP id c16so12289539ioh.6
        for <netdev@vger.kernel.org>; Sun, 08 Dec 2019 09:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1PVpFjMg2fLBQP40RWVTCOez99/FevTs3HxT851d66A=;
        b=Ywr/bCGH8qQTt4azNEjodYwJgaD4Si0jjWxX4oCsNPXc2GYdubiPfoC8+MsTBWaAZb
         mflHTkcIPU28hkFayZTMdJK/uhDyVQd+2ofSz2hUQDvTz0ViU97oO/cRxi71bGKusJBF
         CGNQWYDJSkD26id1ITD6A4IVWkYrbFaELwPyuuee7T5Z70+sbkzVlbejAaXil/OYtd67
         U+fgVRPDclMi6hJjJjx2rF0GPyrGRhVbwhcmIx3nhb9px/cs8hdQb23V1nNHRtfk3rgz
         qCMDkjPQGaj4saX0QRgbLmcvSmsbZPRfIvoHLHntwE2RUaFCChFSmOExrgY95crAl7CM
         pc4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1PVpFjMg2fLBQP40RWVTCOez99/FevTs3HxT851d66A=;
        b=UB8Q8zYgOX7YhwUuQMq1CtFtGnIj1gGNvZN8OU/WMJSt3cQ7dITWyAMX98+YbLjCvl
         9ADJmrikheESVaOU8Zq4xnmKfy7G/12WGRwwRg+KzMns5FaTD+rZqcsf55yPY9iLkDq1
         9Pk2xrDXtd/YR8Rw7HxtV2dqojqVp9o6NsRI+EbVsgcbXb9UCa7FvQMw1PdDYaTUdwcZ
         SA3IBq4Kt6WlLtRc4+caIFYaRGi3CC9MHTBf1Efi3mr54fqshcRBf7zyc7Di3OZ6n0aD
         41qDSBzfZwwLGuKePeHyu5cE3rzxMjodz6xcmDxBxFUoDsBeGCzqO9n7e/5cG5NvkJgd
         vH6g==
X-Gm-Message-State: APjAAAWvoMe28AY8/LoBARIuK2MeFdpE47iEes+j5ZrGJidwZIiBMD2v
        YC3YMaJjlS8+ouUEdnZan3Ts/X6Q
X-Google-Smtp-Source: APXvYqzi9XAr5MIgMBSr/AIWS0gvxLf3rggmZFWiDFUWTRoZr4v2Na+Kn5iBainRw0iPMMjvjD9hWw==
X-Received: by 2002:a02:85e8:: with SMTP id d95mr23757619jai.92.1575826475817;
        Sun, 08 Dec 2019 09:34:35 -0800 (PST)
Received: from ?IPv6:2601:284:8202:10b0:f4b6:617:457d:720b? ([2601:284:8202:10b0:f4b6:617:457d:720b])
        by smtp.googlemail.com with ESMTPSA id p21sm1066392iol.3.2019.12.08.09.34.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Dec 2019 09:34:35 -0800 (PST)
Subject: Re: how udp source address gets selected when default gateway is
 configured with multipath-routing
To:     Mohan R <mohan43u@gmail.com>, netdev@vger.kernel.org
References: <CAFYqD2pjwCBd5TxNP0wXxKvwYLnr20cYDjK3S0rHM=Fx6si6-Q@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <84230a27-69b8-0aba-216c-997bc9a8192f@gmail.com>
Date:   Sun, 8 Dec 2019 10:34:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAFYqD2pjwCBd5TxNP0wXxKvwYLnr20cYDjK3S0rHM=Fx6si6-Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/19 11:37 PM, Mohan R wrote:
> Hi,
> 
> I have a simple multipath-routing setup,
> 
> default
>         nexthop via 192.168.15.1 dev enp4s0 weight 1
>         nexthop via 10.0.1.1 dev wlp2s0 weight 1
> 10.0.1.0/24 dev wlp2s0 proto kernel scope link src 10.0.1.251
> 10.0.3.0/24 dev wlp0s29u1u2 proto kernel scope link src 10.0.3.1
> 10.3.1.0/24 dev wg9000 proto kernel scope link src 10.3.1.2
> 192.168.0.0/16 dev enp4s0 proto kernel scope link src 192.168.15.251
> 
> here enp4s0 (192.168.0.0/16) and wlp2s0 (10.0.1.0/24) are connected to
> two different ISPs.
> 
> DNS works fine when I access internet through my internal subnet
> (10.0.3.0/24), but  when I try 'ping google.com' in this machine, the
> DNS request to 1.1.1.1 (which is my nameserver in resolv.conf) to
> resolve 'google.com' is sent through enp4s0 interface but the source
> address in that DNS request contains 10.0.1.251 (wlp2s0's local ip
> address).
> 
> If I have single nexthop in default route, everything works fine.
> 
> How can I make sure that kernel picks the correct source ip for the dns request?
> 

This is a known problem. A route lookup is done to set the source
address and then a second lookup is done to route the packet. The
lookups will have different hash values (since saddr == 0 in the first)
and can land on different legs of the multipath route.
