Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2DD4864A6
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 13:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239090AbiAFM5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 07:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239070AbiAFM5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 07:57:39 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD302C061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 04:57:39 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id c2so2476419pfc.1
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 04:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=U07lySvzzSL8oeUX1Mr+2awCcuK5/WaEEpmfdNy1fRI=;
        b=qyORkTLjjuSqb3GcfNxpEZwsNGwpULiS0djpSBNCH7QmFVeb0KXRilQCxgqb8VCjw9
         3369nYEoBmjTrAXFCpcLWBuX0MnRVeqJHGHJ12RSuyKTn8ji4ELQmaNhvmd0L5NZCghZ
         E5UvK9jiB8mHC2rzzgAA2HIysRV2p6dRNDVufCwgg8eV0nlD7R83+iQ35KCQkM0qHz6E
         GX0cmLLv5PU10ztD/UrPulv5+2HejCERtQv84fzTeE9Gu4HhQUweVAfW18BU9tRyRw24
         2Sh5czcEgeQJslhjRgpKCM4QcJY5lUZJ+FU+FD5Nu2i2q47jGksD6+Qei1pPYRHc1Xz4
         e3Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=U07lySvzzSL8oeUX1Mr+2awCcuK5/WaEEpmfdNy1fRI=;
        b=aUpsg8nC6vmmuzFZYWof2ZkaICcMnfkUvHtZDkB/LKhsBjHraGSkjnV/BkeyY5EuML
         gGaJeWeuEI/eJHAm3NwTzcNaNsebdTofp9XTGkK1MqLbDJrTLu8/VRYQrwTe1BEsZwEZ
         6Ggb6VjPEUkNt+tAL8s+GRf04mY6+QXe3eItk49s04aufCT6pTl284xwKDikrxu2BY1t
         OR6SSdJjAGk34iDjm8cYGbdkkGaeSLwZgvvDO335MDkL3TTyLKg2ol74CpbJfW5JTN4V
         +8vTUoBYFHyW5nNok9Wct/xrC5CofG56T8XuUTYWo29v9N1ADtFXASVp5xYVMAnLCwzt
         eb0w==
X-Gm-Message-State: AOAM532nUO/qudrUrgBsjy4cPLEBJHdpcy1RWN8n/PFKDsfDyn+ZZYu2
        uIpWaZK8Z0wZnboGiAwRdcY=
X-Google-Smtp-Source: ABdhPJxcpCgpMO1EFWyUMf1+0jzJAOxzEzhImK2j1wUashf9EgYV8v8s3U+BMFumI6FjMMSXf2xV9g==
X-Received: by 2002:aa7:88d4:0:b0:4bb:7a6:3de1 with SMTP id k20-20020aa788d4000000b004bb07a63de1mr59882272pff.54.1641473859168;
        Thu, 06 Jan 2022 04:57:39 -0800 (PST)
Received: from [192.168.99.7] (i220-99-138-239.s42.a013.ap.plala.or.jp. [220.99.138.239])
        by smtp.googlemail.com with ESMTPSA id s207sm2114471pgs.74.2022.01.06.04.57.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jan 2022 04:57:38 -0800 (PST)
Message-ID: <f1d8f965-d369-3438-38f8-b65fb79c9f91@gmail.com>
Date:   Thu, 6 Jan 2022 21:57:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH net-next] veth: Do not record rx queue hint in veth_xmit
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, laurent.bernaille@datadoghq.com,
        maciej.fijalkowski@intel.com, eric.dumazet@gmail.com,
        pabeni@redhat.com, john.fastabend@gmail.com, willemb@google.com,
        davem@davemloft.net, kuba@kernel.org
References: <ef4cf3168907944502c81d8bf45e24eea1061e47.1641427152.git.daniel@iogearbox.net>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
In-Reply-To: <ef4cf3168907944502c81d8bf45e24eea1061e47.1641427152.git.daniel@iogearbox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/06 9:46, Daniel Borkmann wrote:

Thank you for the fix.

> (unless configured in non-default manner).

Just curious, is there any special configuration to record rx queue index on veth 
after your patch?

Anyway,

Acked-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
