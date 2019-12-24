Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5B1129D3C
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 05:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfLXEP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 23:15:26 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46428 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbfLXEPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 23:15:25 -0500
Received: by mail-pf1-f193.google.com with SMTP id n9so2289289pff.13;
        Mon, 23 Dec 2019 20:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P1nYoC8WCP45tYHKKFkQav2EZRqMASRYBf5CMJdawyk=;
        b=E7W3+7E/oihbNEZF3AlpMAeiHy500AN99wYMRWoNskg9XzLEyWh2++sk/UczmCVI9s
         v+vO8mDa7cceSdlEFklpg7YJL80SLmt5D5xeLaJ/QFhWHNWTSVHLK8Aq9qjKQSCer/KV
         MTQxjdTJ2pECs4YDf3ywpvcxrdd4qjsN9HgjCxmIL58tylgJ4eCj9326HPcmDr66zPun
         LX0R/XdnOJ9AvaX+/zQQ6bEQj1c3ngrlyTGPEP4XzuTUN/ydBopLx7BoeCxYPVkdo5nz
         o5BSIrk4LP1DlsLb+epotMLwb3Mm9BR36wIn3Hu2fYboAYoblxATNygIgsRsIzHR4tCR
         WTag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=P1nYoC8WCP45tYHKKFkQav2EZRqMASRYBf5CMJdawyk=;
        b=QxtgBlg8Zt/wFewjJtmpLWToYmsueTxn6tx1hXixsquGfrR+FsyWf10s9Pe6XD7ifl
         IaaCfev3Tku/64lSkwYDDc8bUWTQfx2KkNvnBj02OWmiUgfEg49o+b5Au1LNq6o3NImD
         BKBFtW88lOPykGgxiUaTN1ox8/CuYfBZzJRZpwHYUNqx6dPK8C/YvuAd9aloVUZZKgWg
         NTECJKfzIxvZPQ6NCTyMtqoYadKtKWmwA5q8KegZiBykAH1uR3PfnjthfMeC+FfScsgh
         pl0S4KZ4Shv7CKWHKb93Sk2mTy0yxOo2bTmb6/Mb4jFb5WjVkyM7Nm8AlSiI/Vk8S+0p
         b5Ig==
X-Gm-Message-State: APjAAAWMochHXf1i010duU6FjWRQaX/k0ViCtfHwF81FIDMpbMHAhHVA
        TiIxce+sd5IekkNcHZ55sH/09yCE
X-Google-Smtp-Source: APXvYqwR+3LjZZfSiEQpNV0YNfFGU1iyQy9BpOq9LHa7N2ydejHOOsNmXVJOCxO6CD3dR296P0jg/g==
X-Received: by 2002:a63:de4c:: with SMTP id y12mr34845536pgi.107.1577160924575;
        Mon, 23 Dec 2019 20:15:24 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id k23sm23050943pgg.7.2019.12.23.20.15.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Dec 2019 20:15:24 -0800 (PST)
Subject: Re: [PATCH net-next v8 03/14] ethtool: netlink bitset handling
To:     Michal Kubecek <mkubecek@suse.cz>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
References: <cover.1577052887.git.mkubecek@suse.cz>
 <0fcbf623c390b30ca34ab0f83645b86a88558b32.1577052887.git.mkubecek@suse.cz>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <b36ee759-2d7a-8237-6f3d-a93e8c22ba66@gmail.com>
Date:   Mon, 23 Dec 2019 20:15:22 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <0fcbf623c390b30ca34ab0f83645b86a88558b32.1577052887.git.mkubecek@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/22/2019 3:45 PM, Michal Kubecek wrote:
> The ethtool netlink code uses common framework for passing arbitrary
> length bit sets to allow future extensions. A bitset can be a list (only
> one bitmap) or can consist of value and mask pair (used e.g. when client
> want to modify only some bits). A bitset can use one of two formats:
> verbose (bit by bit) or compact.
> 
> Verbose format consists of bitset size (number of bits), list flag and
> an array of bit nests, telling which bits are part of the list or which
> bits are in the mask and which of them are to be set. In requests, bits
> can be identified by index (position) or by name. In replies, kernel
> provides both index and name. Verbose format is suitable for "one shot"
> applications like standard ethtool command as it avoids the need to
> either keep bit names (e.g. link modes) in sync with kernel or having to
> add an extra roundtrip for string set request (e.g. for private flags).
> 
> Compact format uses one (list) or two (value/mask) arrays of 32-bit
> words to store the bitmap(s). It is more suitable for long running
> applications (ethtool in monitor mode or network management daemons)
> which can retrieve the names once and then pass only compact bitmaps to
> save space.
> 
> Userspace requests can use either format; ETHTOOL_FLAG_COMPACT_BITSETS
> flag in request header tells kernel which format to use in reply.
> Notifications always use compact format.
> 
> As some code uses arrays of unsigned long for internal representation and
> some arrays of u32 (or even a single u32), two sets of parse/compose
> helpers are introduced. To avoid code duplication, helpers for unsigned
> long arrays are implemented as wrappers around helpers for u32 arrays.
> There are two reasons for this choice: (1) u32 arrays are more frequent in
> ethtool code and (2) unsigned long array can be always interpreted as an
> u32 array on little endian 64-bit and all 32-bit architectures while we
> would need special handling for odd number of u32 words in the opposite
> direction.
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
