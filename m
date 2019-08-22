Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C52349A414
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 01:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfHVXv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 19:51:26 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:32980 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727423AbfHVXv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 19:51:26 -0400
Received: by mail-wr1-f66.google.com with SMTP id u16so6984379wrr.0
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 16:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D8DEMhJsceThQgnQdRYaXbSGMpK/srHz0aLyKFI43WY=;
        b=RYoM+c4RzsatjH3WUcJnm4On/cU3TAOqhJI5rCYEvvIfHHxIBdHhyrLABg8gQTMpvd
         6DXig7Khh7esCENfvPvF1ZcpKhO/FYp6LeooTV+HF0z8+vP7raHdq4LBu7uuh917VC+h
         +Qstb01fJX6Dx07SFePxAATaXlAsZJqLihOQZEcrAxXEqxP2B4qlFOWHvuIcpS/C2ARk
         7ccjkGgIKBoHz+SmZ3IyGP3RAxhGDO5nbp8hPnTj1603W9wdo+plsiwQ+ZRwa16ZRe1x
         m3nseNYR5DGxeQIkcXlzEKxl2CXAufzIX1gLglEAkE1JwGbea/LA/NCkgYt9gytwFDBz
         EPOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D8DEMhJsceThQgnQdRYaXbSGMpK/srHz0aLyKFI43WY=;
        b=Sq35dbGxjXhtyFJ8GBsy7b56yyyf7eEFELDLY298F2+07RJaNUH5B4xWRjSKj2WsQr
         mCL4wVqf2yuYAR7biED24GiUHZkOI2JDB7H4Fge7KsZNLWJvQESBR0qJVOd5TCs4ycwc
         8sDqbtUMe7wHWQHJJFshAK6HtxE1nzqVK5Zf9trL3jyFu6rOImv4seVYtYUrLSt9LJ16
         RFFP/eoDnNRZeA8sCuo0/HnB/ALP52LMaXs/5fV8u72b17pFGU/UuHBByOg6ORbPapvA
         hlbppG/iN5th0oI8uspzxkmiDFrRsUesCUBRpOlu7wMZc9zVooPaOXo9CgPzUS216mSJ
         mOFQ==
X-Gm-Message-State: APjAAAWOKOCdfoOzfYyahJD4tJP8EIjOmvedbYR2ikxm7OLGnYB5IQjg
        Bpu/Qmnsh6vn+Jb07fhR/Oo=
X-Google-Smtp-Source: APXvYqyuKHMw3geAetconYayv5qj60tFc7l1Mq6rL4lYyYbmtbbTUkGqVZ3uZRmJBX5nJdwvwINn3Q==
X-Received: by 2002:a5d:4fc4:: with SMTP id h4mr1387965wrw.64.1566517884126;
        Thu, 22 Aug 2019 16:51:24 -0700 (PDT)
Received: from [192.168.1.2] ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id n14sm3227090wra.75.2019.08.22.16.51.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 16:51:23 -0700 (PDT)
Subject: Re: [PATCH net-next 6/6] net: dsa: clear VLAN flags for CPU port
To:     Vivien Didelot <vivien.didelot@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch
References: <20190822201323.1292-1-vivien.didelot@gmail.com>
 <20190822201323.1292-7-vivien.didelot@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Message-ID: <aee63928-a99e-3849-c8b4-dee9b660247c@gmail.com>
Date:   Fri, 23 Aug 2019 02:51:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822201323.1292-7-vivien.didelot@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/22/19 11:13 PM, Vivien Didelot wrote:
> When the bridge offloads a VLAN on a slave port, we also need to
> program its dedicated CPU port as a member of the VLAN.
> 
> Drivers may handle the CPU port's membership as they want. For example,
> Marvell as a special "Unmodified" mode to pass frames as is through
> such ports.
> 
> Even though DSA expects the drivers to handle the CPU port membership,
> they are unlikely to program such VLANs untagged, and certainly not as
> PVID. This patch clears the VLAN flags before programming the CPU port.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>   net/dsa/slave.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 8267c156a51a..48df48f76c67 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -332,6 +332,12 @@ static int dsa_slave_vlan_add(struct net_device *dev,
>   	if (err)
>   		return err;
>   
> +	/* We need the dedicated CPU port to be a member of the VLAN as well.
> +	 * Even though drivers often handle CPU membership in special ways,
> +	 * CPU ports are likely to be tagged, so clear the VLAN flags.
> +	 */
> +	vlan.flags = 0;
> +

How does this work exactly?
If I run 'sudo bridge vlan add vid 1 dev swp4 pvid untagged', then the 
CPU port starts sending VLAN-tagged traffic. I see this in tcpdump on 
the DSA master port, but if I tcpdump on swp4, the VLAN tag is removed. 
Who is doing that?

>   	err = dsa_port_vlan_add(dp->cpu_dp, &vlan, trans);
>   	if (err)
>   		return err;
> 

