Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0983E2EFCD8
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 02:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbhAIBs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 20:48:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbhAIBs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 20:48:27 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7C6C061574
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 17:47:47 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id r4so6596033pls.11
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 17:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aaqRdHJ4GsdnanF5hWrehjMvSeEJ+sSQku5gpMV9QQo=;
        b=FgxzkUqnIA+y766SM7CJRLrr6qIQYO03mMWnXH6mBsoEMk0qDi0KObfsiLqwfOtAPH
         U+JpYe+w2oultNwXnNjigWTh4bFXmmBe+v0/Tm7zQj7p2/b5kR7Dx9cXVnWDx1vShsXT
         IRkMPVlgYQlt2k86Y51QagR7UPuSNZ1XYKE4Taap6o4pxkqWR47e4XH6NFR8O0bbg4a/
         rV+CjohK7aO35PCJwK52MEgzIfNHEi/J8VW+inz9r2/XMY+Sm064JNMVEkXmaXsxtD15
         iYcx9F+V4Npdyi7bXop/cF4KV8/R/974+asvQZwLHK/qw23qw9aQ1jSHY8cy3SZu5EYh
         pyLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aaqRdHJ4GsdnanF5hWrehjMvSeEJ+sSQku5gpMV9QQo=;
        b=ErZSP4EBEJ1Bp6wgpEXzq2le7KiGM/t2KSce9fOrXwfnmQ1XffJLm4gLbMAapZbGjx
         Ecofefrf90IGyPgMtMSnOjgoJtEyWz25ZKlm5mK7Hlm8uwCV8DTbBZvNWR2eJPQdNomH
         TdabzwQVNS85O7JvsRRlxT5D9X+MpQ+0Zmty6NrtwVy1p/2J9ivgvWhMez4QYVXZKkaF
         r+SGRu2MCckJ0pkONh9tVHkBRkdZt4bf5oN+yxQEXxqElOcChG9acANITJwlhrylgsJb
         knwg48pnRu+YZCgSRpPWQRn/2rHv4qfigcipjHTijm+UMkX73NyAxDllMaDrJkV9JgRn
         1kPw==
X-Gm-Message-State: AOAM532ngGgA4DbZUl/ZMPUVEX6vIkppedFk3JKttjYMfGlbqjTxbsQ8
        wmU8s+B4iNlXVEvXT+wO7hU=
X-Google-Smtp-Source: ABdhPJzoVNlznt/DJZCAOO0KFrDymrriQoA+0icq5NFIQ3qbGs3cbGt09dz466TTaQW2m/TGS9gJdA==
X-Received: by 2002:a17:90a:1057:: with SMTP id y23mr6486033pjd.97.1610156867050;
        Fri, 08 Jan 2021 17:47:47 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q23sm11000497pfg.18.2021.01.08.17.47.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 17:47:46 -0800 (PST)
Subject: Re: [PATCH net-next] net: dsa: dsa_legacy_fdb_{add,del} can be static
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20210108233054.1222278-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7727cc9c-5d02-491b-1f28-139b2fb32018@gmail.com>
Date:   Fri, 8 Jan 2021 17:47:44 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108233054.1222278-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/2021 3:30 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Introduced in commit 37b8da1a3c68 ("net: dsa: Move FDB add/del
> implementation inside DSA") in net/dsa/legacy.c, these functions were
> moved again to slave.c as part of commit 2a93c1a3651f ("net: dsa: Allow
> compiling out legacy support"), before actually deleting net/dsa/slave.c
> in 93e86b3bc842 ("net: dsa: Remove legacy probing support"). Along with
> that movement there should have been a deletion of the prototypes from
> dsa_priv.h, they are not useful.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
