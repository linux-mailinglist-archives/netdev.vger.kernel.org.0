Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96561954FA
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 05:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbfHTDUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 23:20:11 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43381 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728647AbfHTDUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 23:20:11 -0400
Received: by mail-pf1-f193.google.com with SMTP id v12so2437584pfn.10
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 20:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gXKfBZ5XFrU2iaTr9ihjobWtIDf2aqYEDa8SpLIkEOw=;
        b=rioBWZ7kvZ1fpx6pv5vPRSU0j0joE8sJiG4/UC/XT2HxrxcTJUc6CCp0E/FGZesEf5
         RPL+YB7RDoUHyazBT+Za8te8+Aurf0L9JJ9YVH1vc55hCFUl14jK08K07vQXUTeQ7JxG
         mtRjFnibn21YL/5pU0THNGswdmorQWUDkxzdI8hEotmrDVD4DCcV/9X74zXOEVSWYk7R
         huUUYenYO12IYkFafdItywz4uaWtRPg/GkVFORSN5w8eRVSQbObDBF9+1f7oOyHruAL3
         bH8pNL7eZ5oba7ZTswIOe+FWqbjsPN4KFAKgkz0btC3s76zzHyHWAFmYuLX1DKejr+Rb
         SJlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gXKfBZ5XFrU2iaTr9ihjobWtIDf2aqYEDa8SpLIkEOw=;
        b=d1jzPjbmgh4v2f2LzfC1ddBWzOaukMWhYnzth9wnou6BYP1SfSg2Y+YST6ZCz0dq2L
         M6XqIVN9xkZYbnO0Ru/6YFAG93G3t0J/VK1aw65ctW/iZQl503hYXgZ2Ccsjo/oDZER3
         5c04IRH4aQuR1Fw/+lQwk5xTju/4uy3fyofMpg08iSaQxiQztk1nWTrE047gsJ21suem
         zYX0rkfk/39VF7B72CecumSXFd/7HPJ32UqdukQl6ROPmoEDiwLOProcd7OeOy5LNiVB
         WQXNeV57iKYlIW9eKGjZ+XNxaWnu884OB0FHb053+brRohrPvNb/8II6UQm5m6dBLPAT
         Y9rw==
X-Gm-Message-State: APjAAAWIFLcLsiD+bnneM7SELCkUQASpzH88dBJAGrw/maEYjvu3BV6L
        K4CH8w2rxuv8IsgTgqumDFSNCa8L
X-Google-Smtp-Source: APXvYqynz/IuKJrTy0Oi6O3rOnfyDtnHg1ErCA6Mhiw7cvmK58habOlQm25U245NkjU79D/iC/auDQ==
X-Received: by 2002:a17:90a:8a11:: with SMTP id w17mr12198016pjn.139.1566271210303;
        Mon, 19 Aug 2019 20:20:10 -0700 (PDT)
Received: from [10.230.7.147] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id b3sm20191821pfp.65.2019.08.19.20.20.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 20:20:09 -0700 (PDT)
Subject: Re: [PATCH net-next 5/6] net: dsa: Allow proper internal use of VLANs
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, idosch@idosch.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190820000002.9776-1-olteanv@gmail.com>
 <20190820000002.9776-6-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <cd365947-a057-a915-8e5d-0a3f1b43b5da@gmail.com>
Date:   Mon, 19 Aug 2019 20:20:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190820000002.9776-6-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/2019 5:00 PM, Vladimir Oltean wrote:
> Below commit:
> 
> commit 2ea7a679ca2abd251c1ec03f20508619707e1749
> Author: Andrew Lunn <andrew@lunn.ch>
> Date:   Tue Nov 7 00:04:24 2017 +0100
> 
>     net: dsa: Don't add vlans when vlan filtering is disabled
> 
>     The software bridge can be build with vlan filtering support
>     included. However, by default it is turned off. In its turned off
>     state, it still passes VLANs via switchev, even though they are not to
>     be used. Don't pass these VLANs to the hardware. Only do so when vlan
>     filtering is enabled.
> 
>     This fixes at least one corner case. There are still issues in other
>     corners, such as when vlan_filtering is later enabled.
> 
>     Signed-off-by: Andrew Lunn <andrew@lunn.ch>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> stubs out SWITCHDEV_OBJ_ID_PORT_VLAN objects notified by the bridge core
> to DSA drivers when vlan_filtering is 0.
> 
> This is generally a good thing, because it allows dsa_8021q to make
> private use of VLANs in that mode.
> 
> So it makes sense to move the check for the bridge presence and
> vlan_filtering setting one layer above. We don't want calls from
> dsa_8021q to be prevented by this, only from the bridge core.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
