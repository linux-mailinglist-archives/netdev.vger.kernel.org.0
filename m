Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA74B3DDDE5
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 18:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbhHBQm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 12:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbhHBQm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 12:42:58 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBDEC061760
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 09:42:48 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id k38-20020a05600c1ca6b029025af5e0f38bso3057570wms.5
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 09:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FyJvT6pGVVrBKsgS32jneIpAcXCWLaq6QxlR+8kBFDo=;
        b=TUWjxWLn6D+CvM7re69xjc2REdz8cFCVsv1VyOtCwZrs6Hj4spxmXEnAmCi48i3bLl
         qpzXIMl+KyEnd+7v1ZD/4sBtEkYfvWIIqOlLE4Udj/xg1YNCyk9I5WC+1GJ43J6axRlz
         EWEJWDiDTbSGwWMv8ca1rnjNluBH2BVIXLLv1+Qwg5KkaOEY3vpEMUVfyQ0TRlXvHNja
         ZI4ZsERHTu78TOjMMKyu6OIjJzXvJxJnPKgQBky8MwcF0A+c326Vx/EHl2Jqvm9XWZvh
         bSra5+CFttsJXM/6p2ZXSrZlyD98q7pqiJiNzu6ZuB/eYHrvZWTgp5dKgqTcvYFy/C5n
         IzDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FyJvT6pGVVrBKsgS32jneIpAcXCWLaq6QxlR+8kBFDo=;
        b=qCMWw31T8aLG5XDHECpxNPvbqVBi0qxWLuD5r7VgX/JggBIu3Qe3Yy4egcMR0jmlGe
         k0+QTdFsP8IZPaVCXHlK5ptlsz3VoZaHotDMvGscDBsdmQvGpn0tuJBLMikv4EFCP96O
         0xfyp3/jl15dTBv44xoJQYowDQnSiF7sTg/RL8G7OgYchfv9vqgYKcKd7ZLGIPMG+JVb
         J8uW2UFRGYdW2HbwpZve8/iCb4GpN3P/fjvFDEaZI9nDEMduuAA4mdilDTm1t3VAIcy5
         FuuDWvc0TaF6Cymx2/hKpTc/O2b+zHRMuW110GWUBKUxw0eoiqcaCjhzO9fWRquxFZcc
         4F+A==
X-Gm-Message-State: AOAM532F2BOvlR9RnuD2Su3Qfn+iKFqGmAcoeVW42cvbOF0gORvC8m6F
        luAm1L5bTOM0vqEnd+9voO+NzrPaovtz0w==
X-Google-Smtp-Source: ABdhPJyErWSeD666Hn3HlBateo/gKLAGzPrmOA9ak3HHC5Z+WjTE+O+ZUIFHaXEENc+jjGTUUTNsPg==
X-Received: by 2002:a1c:5449:: with SMTP id p9mr17673403wmi.101.1627922567304;
        Mon, 02 Aug 2021 09:42:47 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:31b9:1387:a0dc:6571? (p200300ea8f10c20031b91387a0dc6571.dip0.t-ipconnect.de. [2003:ea:8f10:c200:31b9:1387:a0dc:6571])
        by smtp.googlemail.com with ESMTPSA id b20sm8987109wmj.48.2021.08.02.09.42.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 09:42:46 -0700 (PDT)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <106547ef-7a61-2064-33f5-3cc8d12adb34@gmail.com>
 <8bcca610-601d-86d0-4d74-0e5055431738@gmail.com>
 <20210802071531.34a66e68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 0/4] ethtool: runtime-resume netdev parent before
 ethtool ops
Message-ID: <b5ab0494-fd2a-8cc8-2f8f-07e1fe5e325d@gmail.com>
Date:   Mon, 2 Aug 2021 18:42:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210802071531.34a66e68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.08.2021 16:15, Jakub Kicinski wrote:
> On Sun, 1 Aug 2021 18:25:52 +0200 Heiner Kallweit wrote:
>> Patchwork is showing the following warning for all patches in the series.
>>
>> netdev/cc_maintainers	warning	7 maintainers not CCed: ecree@solarflare.com andrew@lunn.ch magnus.karlsson@intel.com danieller@nvidia.com arnd@arndb.de irusskikh@marvell.com alexanderduyck@fb.com
>>
>> This seems to be a false positive, e.g. address ecree@solarflare.com
>> doesn't exist at all in MAINTAINERS file.
> 
> It gets the list from the get_maintainers script. It's one of the less
> reliable tests, but I feel like efforts should be made primarily
> towards improving get_maintainers rather than improving the test itself.
> 
When running get_maintainers.pl for any of the patches in the series
I don't get these addresses. I run get_maintainers w/o options, maybe
you set some special option? That's what I get when running get_maintainers:

"David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING [GENERAL])
Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING [GENERAL])
Stephen Rothwell <sfr@canb.auug.org.au> (commit_signer:1/2=50%,authored:1/2=50%,added_lines:3144/3159=100%)
Heiner Kallweit <hkallweit1@gmail.com> (commit_signer:1/2=50%,authored:1/2=50%,removed_lines:3/3=100%)
netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
linux-kernel@vger.kernel.org (open list)
