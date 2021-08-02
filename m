Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086C53DDFC1
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 21:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhHBTBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 15:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbhHBTBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 15:01:03 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B999FC06175F
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 12:00:52 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id b11so17293144wrx.6
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 12:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RSAbdeLmmZT/JVoS+anFEIJOsWGzgMsKPRm3uQ30QqU=;
        b=vNGvn0yCbJOrcyRM7tPBzMuwpTYzHsM5hM6FyjM9qPiMnjU4gjjbR+RZBSqf3foKOE
         zHELGZzuCCkmLTkL1HdLC1jxaRMuPI9FGEP4Jh2p4kPoaXKrpU7qwFA+gGYxlZvZvDB/
         1MvBxnfX2NppR0hrT3YeLD4Q8eV+JRoZG6m70aknWGVIiym7gYheGBNSpmaRJ1QnXleY
         aO9a8598EtcYBqwIP1NHnCvnKuaSzU2umKuXVPNdT7/YulRJNFf1tbKzhKUv6J4aIIsV
         M6ibv4/Ir3UHqN98DTYug66pkPGOkgHE35P7eYUaeg6R4s2H7n+fqEtGdBfA2PMIzdYi
         VR3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RSAbdeLmmZT/JVoS+anFEIJOsWGzgMsKPRm3uQ30QqU=;
        b=anPXIzboUxieWO9Wyzal/dQY0u46AFeF8JWNKo/LXFVtQGbKkw9MCbdj7BXbtFZZDD
         LLix+HB8VUP1KGUnAv8HMwXH3+lzEDmT26a8jKmmrxMAUV/qM6kQ7ncyaIfj59MkUDm5
         SyYuGS8HyRvGrpZUZBZlSr0XV/Zw8TBuXVAh7wYnORNgDwHCnJK5FuIo1v7CyE01ujmS
         iD40MH8ATbpDdu2568jDaui3zsA+4q9lf9XUJu55tlYLTzxOKIcdwysDibm+b9GyiPH9
         hDYhNd+kQHqnm0HUUWlWgBHz61n3bcdAfRlYtbIrt9bKTSeGLpvUm+MVN3h18BFX1Jnm
         9hcg==
X-Gm-Message-State: AOAM532vOkeWKumwomGvhCBKC4i2rDYyVIDFbZ/QPYIK0J6PrtBqUOOb
        YxSwqPtC4pqlo1caqpAEmu4yTqytH15cmQ==
X-Google-Smtp-Source: ABdhPJx9JVSZ/fpIb3fde2xWFuGl5DK69ujmNkMdix89fH4e4hKVAoyjfNnY0sIhoDjH+ImM4Yrhmg==
X-Received: by 2002:a5d:59ab:: with SMTP id p11mr18738712wrr.238.1627930851185;
        Mon, 02 Aug 2021 12:00:51 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:849c:826e:7c2c:c5ad? (p200300ea8f10c200849c826e7c2cc5ad.dip0.t-ipconnect.de. [2003:ea:8f10:c200:849c:826e:7c2c:c5ad])
        by smtp.googlemail.com with ESMTPSA id v18sm10964684wml.24.2021.08.02.12.00.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 12:00:50 -0700 (PDT)
Subject: Re: [PATCH net-next 0/4] ethtool: runtime-resume netdev parent before
 ethtool ops
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <106547ef-7a61-2064-33f5-3cc8d12adb34@gmail.com>
 <8bcca610-601d-86d0-4d74-0e5055431738@gmail.com>
 <20210802071531.34a66e68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b5ab0494-fd2a-8cc8-2f8f-07e1fe5e325d@gmail.com>
 <20210802095446.22364041@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <69438f4b-34f0-3027-d1af-d8cf6e7943c6@gmail.com>
Date:   Mon, 2 Aug 2021 21:00:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210802095446.22364041@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.08.2021 18:54, Jakub Kicinski wrote:
> On Mon, 2 Aug 2021 18:42:28 +0200 Heiner Kallweit wrote:
>> On 02.08.2021 16:15, Jakub Kicinski wrote:
>>> On Sun, 1 Aug 2021 18:25:52 +0200 Heiner Kallweit wrote:  
>>>> Patchwork is showing the following warning for all patches in the series.
>>>>
>>>> netdev/cc_maintainers	warning	7 maintainers not CCed: ecree@solarflare.com andrew@lunn.ch magnus.karlsson@intel.com danieller@nvidia.com arnd@arndb.de irusskikh@marvell.com alexanderduyck@fb.com
>>>>
>>>> This seems to be a false positive, e.g. address ecree@solarflare.com
>>>> doesn't exist at all in MAINTAINERS file.  
>>>
>>> It gets the list from the get_maintainers script. It's one of the less
>>> reliable tests, but I feel like efforts should be made primarily
>>> towards improving get_maintainers rather than improving the test itself.
>>>   
>> When running get_maintainers.pl for any of the patches in the series
>> I don't get these addresses. I run get_maintainers w/o options, maybe
>> you set some special option? That's what I get when running get_maintainers:
>>
>> "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING [GENERAL])
>> Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING [GENERAL])
>> Stephen Rothwell <sfr@canb.auug.org.au> (commit_signer:1/2=50%,authored:1/2=50%,added_lines:3144/3159=100%)
>> Heiner Kallweit <hkallweit1@gmail.com> (commit_signer:1/2=50%,authored:1/2=50%,removed_lines:3/3=100%)
>> netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
>> linux-kernel@vger.kernel.org (open list)
> 
> Mm. Maybe your system doesn't have some perl module? Not sure what it
> may be. With tip of net-next/master:
> 
> $ ./scripts/get_maintainer.pl /tmp/te/0002-ethtool-move-implementation-of-ethnl_ops_begin-compl.patch
> "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING [GENERAL],commit_signer:12/16=75%,commit_signer:15/18=83%)
> Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING [GENERAL],commit_signer:11/16=69%,authored:9/16=56%,added_lines:127/198=64%,removed_lines:41/57=72%,commit_signer:14/18=78%,authored:11/18=61%,added_lines:74/84=88%,removed_lines:35/52=67%)
> Heiner Kallweit <hkallweit1@gmail.com> (commit_signer:3/16=19%,authored:3/16=19%,added_lines:46/198=23%,removed_lines:13/57=23%,authored:1/18=6%,removed_lines:13/52=25%)
> Fernando Fernandez Mancera <ffmancera@riseup.net> (commit_signer:1/16=6%,authored:1/16=6%)
> Vladyslav Tarasiuk <vladyslavt@nvidia.com> (commit_signer:1/16=6%,added_lines:11/198=6%,commit_signer:1/18=6%)
> Yangbo Lu <yangbo.lu@nxp.com> (authored:1/16=6%,added_lines:10/198=5%,authored:1/18=6%)
> Johannes Berg <johannes.berg@intel.com> (authored:1/16=6%)
> Zheng Yongjun <zhengyongjun3@huawei.com> (commit_signer:1/18=6%)
> Andrew Lunn <andrew@lunn.ch> (commit_signer:1/18=6%)
> Danielle Ratson <danieller@nvidia.com> (authored:1/18=6%)
> Ido Schimmel <idosch@nvidia.com> (authored:1/18=6%)
> netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
> linux-kernel@vger.kernel.org (open list)
> 

Ah, maybe it's because I typically don't work with the full git repo
but just do a "git clone --depth 1". 
