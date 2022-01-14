Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E13248ED0C
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 16:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239385AbiANPUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 10:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236022AbiANPUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 10:20:01 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68BBC061574;
        Fri, 14 Jan 2022 07:20:00 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id bg19-20020a05600c3c9300b0034565e837b6so3671994wmb.1;
        Fri, 14 Jan 2022 07:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9qFR11nHm+mhLAm3o9SpfomQXzxlqFjZg2rE8HQK518=;
        b=EKlgr34LKZ98bPASCBMZGjdPQDoh5Eg4rIu8TfP0G8iiYVTKmaX0lhr36pnp3ey/j1
         CDS/je9FWYN3bieeoqUXTWKj8QAsgu1tzHapYnFBxB5PfsbmdCAqo6+WWJTIAsMWCmRc
         VIAgLy9pzAH10q3QWBr7CHz7s4+duuq1KQPryh2wXce0TYfP+5tL1YlkVZqyYV73/vhR
         05i4ax74+8oqKViVOdNlTPmW2S0Ps8zLRyoVINGStPrnOHtvw58ssKjYGE0yewKzupQm
         eirsDOJ+1UTBTiPQfvNJK95IpaiYcL9Gcm/M44157vWtiMmhSJwQbkXJd3pKmbq7d933
         yy6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9qFR11nHm+mhLAm3o9SpfomQXzxlqFjZg2rE8HQK518=;
        b=4B3/js9/hEelksWnJ21bOZgsBFJ8QlKUgrpPBByP1wvquWaIqIUJIM22fEUcLpmUf9
         UTLRQyVAa6FFiDTcy/Df0RrgGJlkdXSvwMawiAVyE7shqpxOqviR6IMXn/6kbIXmu1G5
         AhdQ0m62plYx3/+2H4mZ+n3DIW9sTma0Ibzy/H3S4bp3WIdoCXu/C/2w5vA4PGGI3xHg
         F5jO2Un/w0uO20mH4Hf9J0iglwEHwEHwBMBRAt1xWFWS/OkD/h9iuxSLJgBY8M+OG1xq
         lrc9E93Xeg2yB4LplyyOa3IhJmrtifzfCmTVcW1JcmG8vngDJXAGn4/n6gNlpfqWy2GT
         6Wig==
X-Gm-Message-State: AOAM533qmoh42EF+CMTIb4Ne7xqxUyoNo0og9mORKNyhDZ7iWHYh6l3O
        OIjmqh+SIw4+N1gwAkbDjEA=
X-Google-Smtp-Source: ABdhPJwWTvziN65ut2nn+sItdfWdB5xZ3sOfKHkPhccz78JQHUN0womPbkHco3aujJRpWGwd+n9qdQ==
X-Received: by 2002:a05:600c:3b0e:: with SMTP id m14mr15766244wms.130.1642173599419;
        Fri, 14 Jan 2022 07:19:59 -0800 (PST)
Received: from [10.0.0.5] ([37.169.14.29])
        by smtp.gmail.com with ESMTPSA id r13sm5484767wrn.101.2022.01.14.07.19.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 07:19:58 -0800 (PST)
Message-ID: <8fc4701f-c151-0545-c047-a5df90575d69@gmail.com>
Date:   Fri, 14 Jan 2022 07:19:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net] ax25: use after free in ax25_connect
Content-Language: en-US
To:     Hangyu Hua <hbh25y@gmail.com>, jreuter@yaina.de,
        ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220111042048.43532-1-hbh25y@gmail.com>
 <f35292c0-621f-3f07-87ed-2533bfd1496e@gmail.com>
 <f48850cb-8e26-afa0-576c-691bb4be5587@gmail.com>
 <571c72e8-2111-6aa0-1bd7-e0af7fc50539@gmail.com>
 <80007b3e-eba8-1fbe-302d-4398830843dd@gmail.com>
 <ff65d70b-b6e1-3b35-8bd0-92f6f022cd5d@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <ff65d70b-b6e1-3b35-8bd0-92f6f022cd5d@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/13/22 22:54, Hangyu Hua wrote:
> Any suggestions for this patch ? Guys.
>
> I think putting sk_to_ax25 after lock_sock(sk) here will avoid any 
> possilbe race conditions like other functions in ax25_proto_ops. CTING) {
>

As explained, your patch is not needed.

You failed to describe how a race was possible.

Just moving code around wont help.

How about providing a stack trace or some syzbot repro ?

