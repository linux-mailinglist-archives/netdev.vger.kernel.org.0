Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69628261399
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 17:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730446AbgIHPfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 11:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730429AbgIHPf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 11:35:26 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD83FC08E81F
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 07:34:36 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id y13so3123692iow.4
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 07:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=orEBYYAxFTCxN/5phl8j62Mf7DLDvkafjGIa12TpiAM=;
        b=hC3+uWdRl7M34mUSmAZ84NwRbnqnRj43Qv+sO1AurFoOpXzUTEvlneAwy5eVQZT87S
         zJdj7Fbkl2n1ZwVqeXCAsiS+p6C2I3gJIBzjoWJ95mzP4E83ADt6YZQaVxA27dtgng9b
         iHmsQwL7sCMpO7k2GWuVhR2c+M9k93VRYUJ+YHG9i0ttd+ViOi4twP1VDmA4UkGrQH+L
         vdWfi7XghtxKOJ1H1Ul/ZKv2wDWQACPiUKLvQ9WjaBGU0xonQpowp+kMpOPypOG3qTxy
         STe2u7ElIs5caQS8NHRH4+Xx0Yab/UiGICPbzeFhB65WsEQqz2enYDvC23WuaXw1Rov+
         9JpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=orEBYYAxFTCxN/5phl8j62Mf7DLDvkafjGIa12TpiAM=;
        b=bB32UgASirVQ9SCPQeidWDlVQTsxjU41h+UmZEoRCEXkpi5gnd8hoQr0lzg2cLv1aP
         7DNfwDQTMPsG/+qICOnIP471GDkzYGf9ppKUoBBL/PUul79tAUHqUVeSErUv84qxgE/T
         ZStdMKqGwgoHAmcxH0wP7vfxNN/r75okNPp4cH3Mh/C2IzYxVTwTAKpY+yeLT42iASZy
         MKdDG1rG0tbog5YUeuSc7hAur+iduPlaHge2kA8M0kjjiYokeR7UZ4dADlv/IedKw7GW
         xsMoszt9nyaFO+y8QZxTB6M+qtyzI2iBOVHJ84uhAzQhX/qru/GEIwZ9NDhGEM2gm3Yd
         qwjg==
X-Gm-Message-State: AOAM532ZUSC2kSrGR1cemjY9N0lW60D+VZCLlkI3lPRo/8Rd++7c4WhF
        vNkX2GcwmnmXBNcxfYsqNDE=
X-Google-Smtp-Source: ABdhPJzYT072zO2/zUg3YDeZCz3EtgHa+9HQ0BDc9AsBiMEJB4GsnN4YHQSlQv/OIRI9/xStc61gHw==
X-Received: by 2002:a02:ab85:: with SMTP id t5mr23920024jan.51.1599575676189;
        Tue, 08 Sep 2020 07:34:36 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id a21sm8490460ioh.12.2020.09.08.07.34.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 07:34:35 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 02/22] nexthop: Convert to blocking
 notification chain
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-3-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7c68aa2c-758a-0140-e0af-597eebba5954@gmail.com>
Date:   Tue, 8 Sep 2020 08:34:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908091037.2709823-3-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 3:10 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Currently, the only listener of the nexthop notification chain is the
> VXLAN driver. Subsequent patches will add more listeners (e.g., device
> drivers such as netdevsim) that need to be able to block when processing
> notifications.
> 
> Therefore, convert the notification chain to a blocking one. This is
> safe as notifications are always emitted from process context.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  include/net/netns/nexthop.h |  2 +-
>  net/ipv4/nexthop.c          | 13 +++++++------
>  2 files changed, 8 insertions(+), 7 deletions(-)

Reviewed-by: David Ahern <dsahern@gmail.com>

