Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3DC2B8274
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbgKRQ6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:58:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbgKRQ6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 11:58:43 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA73C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 08:58:43 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id 1so3373986wme.3
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 08:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OytZM9hptUdqtMzFdTg4WEZizJON99Eg20ghykuO9vc=;
        b=WNrGUqhHS4yZ/pEL+CxEc5saR+1VXRMaC+JB5Eo34fMw+1U319UKbGToZScnXSKe+q
         wA1k2m8Q1MWZiltsu8Fo6kDt7CENeMcPw/nCBz66dZWQ6spIm6b8URGWkI6Ud+8Vdqkf
         +oECZih6Na8JcDVeQBxoWIXQYGXCt6Hl+cZJbpkNhEiAT8OPX+EvZwwsZ+nEQKEDyBJX
         av/gTZMAbbbCPBAGlH6AXxfqvBzvyXPval3fgCKeaTabFhOmukmyKilg3RV1dB0yNq48
         eCcU+46hrLQDMq2HEPQU8mkHTRGR52odDTUS/A7mlqWiX1PgSqe1wZ/g06x8uzuBTz7S
         ATIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=OytZM9hptUdqtMzFdTg4WEZizJON99Eg20ghykuO9vc=;
        b=AvVeVMlyEh+2HLM7yR7rRuppVqMiPfmLtpilb1W/+j3Bs7j0PA+zvq4FWnflCQn2/h
         0He8PviuVqBHrl5UxpnD6zzsdvPl9l8GHBkpddoGpG9wmKclQqovIFIkKQkjMhkEPKeN
         R7q4UfhW2USP97t2Ue5dwAZ0iK1MsX8YdORTl9W07jCse3Wp3s6qc2NkVAmXF0yuP5yL
         qT9wHAtQdn2xholbn8DyxDoxJFNZ1j5KOjPHh/bDSVO99c9ZMIeX4Efz+7vz80XHChBQ
         s3nXqfNn/jF+BLxgItGri+9JrwqLt9Y4lT8+4z+9ezrwRNpt7rKFlBrVqBDQ3OqNMnqP
         +4bQ==
X-Gm-Message-State: AOAM530CPwR5JYl0Dc7JVXQ9LIbNyB4FkSTt5OL71kRNB4EjygmnXbZv
        V29i3XvyGkgofUcmbrL/4VnF3g==
X-Google-Smtp-Source: ABdhPJzmP2nVMybvb5jiiNCLz0yOAMvMCp/v8aKfzwDUpeZe4ei7pclGFqXCekzBLYwSbiiX2b3qFA==
X-Received: by 2002:a1c:4d0f:: with SMTP id o15mr15589wmh.142.1605718721834;
        Wed, 18 Nov 2020 08:58:41 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:580d:332b:4e93:1d8a? ([2a01:e0a:410:bb00:580d:332b:4e93:1d8a])
        by smtp.gmail.com with ESMTPSA id w10sm35477290wra.34.2020.11.18.08.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 08:58:40 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next] net-loopback: allow lo dev initial state to be
 controlled
To:     David Ahern <dsahern@gmail.com>,
        =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+?=
         =?UTF-8?B?4KSwKQ==?= <maheshb@google.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jian Yang <jianyang.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        Jian Yang <jianyang@google.com>,
        Eric Dumazet <edumazet@google.com>
References: <20201111204308.3352959-1-jianyang.kernel@gmail.com>
 <20201114101709.42ee19e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9jgYgUa4DPVT8CSsbMs9HFjE5fn_U8-P=JuZeOecfiYt-g@mail.gmail.com>
 <20201116123447.2be5a827@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9ji24VkLipTCFSAU+L8yqKt9nfPSNfks9_V1Tnb0ztPrfA@mail.gmail.com>
 <20201117171830.GA286718@shredder.lan>
 <CAF2d9jhJq76KWaMGZLTTX4rLGvLDp+jLxCG9cTvv6jWZCtcFAA@mail.gmail.com>
 <b3445db2-5c64-fd31-b555-6a49b0fa524e@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <7e16f1f3-2551-dff5-8039-bcede955bbfc@6wind.com>
Date:   Wed, 18 Nov 2020 17:58:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b3445db2-5c64-fd31-b555-6a49b0fa524e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 18/11/2020 à 02:12, David Ahern a écrit :
[snip]
> If there is no harm in just creating lo in the up state, why not just do
> it vs relying on a sysctl? It only affects 'local' networking so no real
> impact to containers that do not do networking (ie., packets can't
> escape). Linux has a lot of sysctl options; is this one really needed?
> 
+1

And thus, it will benefit to everybody.
