Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBA5D11B3CB
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 16:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388233AbfLKPoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 10:44:13 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:42773 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731834AbfLKPoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 10:44:10 -0500
Received: by mail-il1-f193.google.com with SMTP id f6so19805924ilh.9
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 07:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YZVMb1TmRTBq0QLcYbr4Tnx6QkFSm0jZrcE6jKPYvs8=;
        b=vBCo05YnqmsVLyosM2cNbaKHHjHfHFqQdRnCvKPimi7IqjExuV4Jnk2LOlaKFriKOy
         kVCdg6XUUgIjQzXDwrIPQCro1YZEnaj22pHkPca8cEnVK/DUVNKbCWMKXqAB2fi7GWWd
         GWEwqo4U0u7oC/kWf2wtwbqGhY3tvpn2OZ5sAV91RVni/mMb3HK4EHOgopq8avC0D2yK
         5mtLhyx2FRilhd3/Oi36fw5rRJbL0PYJzdM3lngr2eHLMmZjBtcFIJLkkPRwK2nOuvzV
         /UMggPm+qCrugsv/SEfBXbZEXHqlM3jy4/Bna2my/ubORUCoy0HRGL0zbhsZL7kNpqYB
         O9OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YZVMb1TmRTBq0QLcYbr4Tnx6QkFSm0jZrcE6jKPYvs8=;
        b=KM4r5rh59YX5WTJoOgeXwzhhy16GjOSmpO5Xj1MBWQNNSsdVK/KNvYMQHsAUPk07Aj
         fy1IoaxnOvlE+nmBsR40RT54gyO9oWY3Cdr02YzjDZDZFluBvPkl21+sJFVcbLbOC2qN
         J5OwKj8eMToDHxFRLQ19f2WPtq9E4O2EVFsUhjCglb/kMLQfSjJH0Dmk+ub1mc1UrInj
         tzAonbOkhUFI5ePC7U6Uqcl8c3+4CPHrOEA4T9yho5YFgtbhOsbw3DeeFXznTyXf6WT8
         Q3uG+VMCfHOVv+rMcEX2D3C5WbC5njft0mi73Hogv1MI5YCMh59drKs1RZQ2SoMV41vC
         QxeA==
X-Gm-Message-State: APjAAAWiimMQgFm/4m/oWzDsi9UeQDSGsldSTb62hXlWr12rH0yMo7Et
        1Dyw140NZbCSAmnlMVAlQoU=
X-Google-Smtp-Source: APXvYqyESnN55UEjJFtYoM/5tS6vFxC0jE/wyUMPkn6nJVX44UbuEhZPFiCx2LZ9ytXLBdAvTJUFsQ==
X-Received: by 2002:a92:91cf:: with SMTP id e76mr3837418ill.197.1576079050045;
        Wed, 11 Dec 2019 07:44:10 -0800 (PST)
Received: from ?IPv6:2601:282:800:fd80:79bb:41c5:ccad:6884? ([2601:282:800:fd80:79bb:41c5:ccad:6884])
        by smtp.googlemail.com with ESMTPSA id g3sm580087ioq.75.2019.12.11.07.44.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 07:44:09 -0800 (PST)
Subject: Re: [PATCH net] ipv6/addrconf: only check invalid header values when
 NETLINK_F_STRICT_CHK is set
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Benc <jbenc@redhat.com>,
        David Miller <davem@davemloft.net>
References: <20191211142016.13215-1-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e27cd48c-c5cc-bcf7-d80a-c234d207be32@gmail.com>
Date:   Wed, 11 Dec 2019 08:44:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191211142016.13215-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/19 7:20 AM, Hangbin Liu wrote:
> In patch 4b1373de73a3 ("net: ipv6: addr: perform strict checks also for doit
> handlers") we add strict check for inet6_rtm_getaddr(). But we did the
> invalid header values check before checking if NETLINK_F_STRICT_CHK is
> set. This may break backwards compatibility if user already set the
> ifm->ifa_prefixlen, ifm->ifa_flags, ifm->ifa_scope in their netlink code.
> 
> I didn't move the nlmsg_len check becuase I thought it's a valid check.
> 
> Reported-by: Jianlin Shi <jishi@redhat.com>
> Fixes: 4b1373de73a3 ("net: ipv6: addr: perform strict checks also for doit handlers")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  net/ipv6/addrconf.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

Looks right to me.

Reviewed-by: David Ahern <dsahern@gmail.com>
