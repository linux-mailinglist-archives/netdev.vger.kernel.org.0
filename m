Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E854360FEE
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 18:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbhDOQNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 12:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbhDOQNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 12:13:10 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28DFC061574;
        Thu, 15 Apr 2021 09:12:45 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id b8-20020a17090a5508b029014d0fbe9b64so14668594pji.5;
        Thu, 15 Apr 2021 09:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fLYZ3TGu+U2cqNxJUa06Ydja+nOM+ESe0f7phSdkibE=;
        b=izDHic+Ya67E8D4TQGUlZTtR/lOnvyfnIi6yPQuhEOu4u3tRs/8uiSW+EPbfVyAS4r
         HJf/Y5HiRICNA3gzMgMZFAmgKI5sb7xW8Ra+/MCZRG/luSc+ZtuKLZ9DRgkb3pzHxtRw
         Tu+aQ3qHqIIeIyz5e+Erof1Qct1CI5hQS8qfDC5anaWvg8G+0VvsfvogGg/ToxglBeuW
         NbYtAV7axkv0U6NFKrxbZiCYHhl4tWoCCk538Pigkz8GhNLD5GoNguZAnFKLyorJJqeC
         rmNzs+R+zEzTmphWtpbqKPWADjOL78hMrXhe9otZrJJ595lv+WTalRShMylDwhvt4AeH
         gmnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fLYZ3TGu+U2cqNxJUa06Ydja+nOM+ESe0f7phSdkibE=;
        b=czXmtZv+8gZWLZdjFIEzYIzZwgnPeFelq+Of/YVk0RmwcOUBoJItzN8d6HabpjHd/W
         gMwa+W8418XRIdKSHVRzZN+6cKjtjU+wiZnSpOEY21E/6LPu/ciVTFTWEjQ7G/InbItA
         UqbcQ0uZPYN3mJgSOxPS7HDrHwoETyQCz09Wa3SctGMjUBCuZmqxwjDlfB+/PvwLVnMV
         5N0W+Y41q3/mIuAcOuSJpAOJkdhFflNNcqW6OJVD2wKUouhFbktiKXO8GT46ZgVcOtH/
         +2TeBMSZZ67LQKigAlwuyKkavnRwL8UyReK+i4Nl93T9QpnMWVlWHmkP6wLTzIMieIfE
         za4Q==
X-Gm-Message-State: AOAM530n6tphWKweuMwT35cc8PeOItrR6v3oCAXX6eM4crUylJjS1tfC
        Ys5KrLWel2qX7m6U8dCsBA3qbbmj98g=
X-Google-Smtp-Source: ABdhPJzr6ibUWAsE9Trk9Hr52JRyL9NTpUqtwjN0uCyK1GkDnYx1KVZcBcL+RmOjREICnsvUTfmwBQ==
X-Received: by 2002:a17:902:7d86:b029:eb:4d1c:aa9e with SMTP id a6-20020a1709027d86b02900eb4d1caa9emr4615395plm.51.1618503164983;
        Thu, 15 Apr 2021 09:12:44 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x26sm2575329pfm.134.2021.04.15.09.12.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 09:12:44 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 2/5] net: dsa: mv88e6xxx: Allow dynamic
 reconfiguration of tag protocol
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
References: <20210415092610.953134-1-tobias@waldekranz.com>
 <20210415092610.953134-3-tobias@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dd41eebe-583d-6b52-5699-623d487e97a5@gmail.com>
Date:   Thu, 15 Apr 2021 09:12:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210415092610.953134-3-tobias@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/2021 2:26 AM, Tobias Waldekranz wrote:
> For devices that supports both regular and Ethertyped DSA tags, allow
> the user to change the protocol.
> 
> Additionally, because there are ethernet controllers that do not
> handle regular DSA tags in all cases, also allow the protocol to be
> changed on devices with undocumented support for EDSA. But, in those
> cases, make sure to log the fact that an undocumented feature has been
> enabled.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
