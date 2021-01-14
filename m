Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8162A2F5933
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbhANDVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 22:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbhANDVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 22:21:11 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3844CC061786
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 19:20:31 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id d189so4511697oig.11
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 19:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5zEv12SJH52ppQuWGHa7jgRM/gACncKQhprtSFyLFJ4=;
        b=A26LSFFR8ea1j6hBTA7H7z/YMDZoRJ+nIyKQGXe3g+o+VzTQAWafI/ZIj2RTkrrSlK
         3+pWA6t/2ghuzScZVKcbAtFALvivPkhFMyKD7nQUt4Pw8TlXukqJpkoppdGznRMc+dZF
         YUqomth3pqKtpdFJIMw418oWhp4CGDfj93Ni28Laj61RvuJeBqt2ypRG1BMD1X1emmaK
         c9D1VbFAbXkbIF3dBjecUbh1jIPPH9jGLA6DUFn0/E5y4btHRJIEuiGBHyfygx4kag+g
         lseTi7UgiVF2wAiI/aTHky0ODF13jdaMBHB/BVeRgxQbvqUtsYJYOH7k3rUx7Ud51KHL
         avOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5zEv12SJH52ppQuWGHa7jgRM/gACncKQhprtSFyLFJ4=;
        b=ls9WhKi18cqhHJy02Vub9lD5wV+xJGTiPis4TWTT25mFKXb6vi3XkO6nXggt7t6eTh
         G9dQ+TApoNU6IFmqXqWYbxKJ0B6XnzwsJpwTOnR951b36tlJjY9RwQWCrQYaKabTRhZg
         +TBIBqi57TSPCU580tOWfoqezQjALW+s17q3XbOdgu949F610l6pUPMzdhozg9sG4ywm
         szKaWM6cp2R+aKVZlIgjbVHaaoYhf/9LY/GaSMMvKLpEXDg9c2qv1O8g77slSEhFSdtm
         yCzmQMF7fiExlVa9etiU9F8xRbgc4dwbSQLIyvVAs9VNWtWnHKWkiJ5b9fpqNtkYRDsD
         RiCg==
X-Gm-Message-State: AOAM532gt7kzvk5yz1gelxdFK0cdozmm8Up5zf7sQPyQxVHZ1DLztPc/
        KxA9QGChGbzEPvtFW1OF9HBkPl/fBOg=
X-Google-Smtp-Source: ABdhPJxTBWFzw97tn70PjUPrjtW8zK2EStY93J0cit8Tcn67fnKEEPwIUKlAN/6VaM9mK4AK5958aQ==
X-Received: by 2002:aca:f255:: with SMTP id q82mr1404920oih.138.1610594430472;
        Wed, 13 Jan 2021 19:20:30 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id o135sm844270ooo.38.2021.01.13.19.20.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 19:20:29 -0800 (PST)
Subject: Re: [PATCH iproute2-next] ip: don't use program name to select
 command
To:     Matteo Croce <mcroce@linux.microsoft.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
References: <20210111190545.45606-1-mcroce@linux.microsoft.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a8212b0b-a77f-0354-f44b-3bc94a42a0b8@gmail.com>
Date:   Wed, 13 Jan 2021 20:20:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210111190545.45606-1-mcroce@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/21 12:05 PM, Matteo Croce wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> ip has an ancient behaviour of looking at its program name to determine
> the command to run. If the name is longer than 2 characters, the first two
> letters are stripped and the others are interpreted as the command name:
> 
>     $ ln -s /sbin/ip iproute
>     $ ln -s /sbin/ip ipa
>     $ ./iproute
>     default via 192.168.55.1 dev wlp0s20f3 proto dhcp metric 600
>     192.168.55.0/24 dev wlp0s20f3 proto kernel scope link src 192.168.55.26 metric 600
>     192.168.122.0/24 dev virbr0 proto kernel scope link src 192.168.122.1 linkdown
>     $ ./ipa show dev lo
>     1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
>         link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>         inet 127.0.0.1/8 scope host lo
>            valid_lft forever preferred_lft forever
> 
> This creates problems when the ip binary is renamed. For example, Yocto
> renames it to 'ip.iproute2' when also the busybox implementation is
> present, giving the following error:
> 
>     $ ip.iproute2
>     Object ".iproute2" is unknown, try "ip help".
> 
> Since noone is using it, remove this undocumented feature.
> 
> Signed-off-by: Matteo Croce <mcroce@microsoft.com>
> ---
>  ip/ip.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/ip/ip.c b/ip/ip.c
> index 40d2998a..9b772307 100644
> --- a/ip/ip.c
> +++ b/ip/ip.c
> @@ -311,9 +311,6 @@ int main(int argc, char **argv)
>  
>  	rtnl_set_strict_dump(&rth);
>  
> -	if (strlen(basename) > 2)
> -		return do_cmd(basename+2, argc, argv);
> -
>  	if (argc > 1)
>  		return do_cmd(argv[1], argc-1, argv+1);
>  
> 

This has been around for too long to just remove it. How about adding an
option to do_cmd that this appears to be guess based on basename? If the
guess is wrong, fallback to the next do_cmd.
