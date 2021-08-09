Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714FA3E42D5
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbhHIJfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234669AbhHIJe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 05:34:58 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FECC061796;
        Mon,  9 Aug 2021 02:34:37 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id l18so20532868wrv.5;
        Mon, 09 Aug 2021 02:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vjxCT+VJ0iUMgOfKLV2Avr5JuRXfNiXW4v7j2+9ljXo=;
        b=jIcKNRea72ZTofO1kxXWEISoqgUDKhrkqztw/Fm1UPM4Cyy6wKBo5pUxaM5c8m2xTF
         CpaE9PaIVutrEbligPqYOq+fxBSz4h+ph3u3sd36VceBkqOCraoPb8HaLl9RGaIWBfZV
         YlpSAZzuAnOyXYd4TbS7RRoC4xSZqF9QP4RxxSqsOQdqTyvnPJECum35Xc8eYbBZa2Kr
         zvQWgV30Dy8DIB4zVUyn1p7U1JrcPJwtLN2u6cxfMDtc0ViOw9Ip8U0GAHlBp1mtJLLw
         euJKXX0htb5TRY21gxtgly2ut6HHgyolFnMQRWgMx8nFK12UX101n1WMjSwjGVq4OwLF
         I6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vjxCT+VJ0iUMgOfKLV2Avr5JuRXfNiXW4v7j2+9ljXo=;
        b=LfC/cjhet7IuapOII513nuYE3PxI3sd1C6XoRqvyKgANTv4+IHhlDNlQ6wh07W9M4X
         fYV4XxVdVQ1gjA9y/i0nqds6xtOYbNWkCqZWqhmZKB+T95AZUs5Eme+pkQp80W+fNmtE
         8DPGyPKArPmqiuHxMxO8QYwMgNoiKGgw3L+SLMZOB2z8wNdN0Rl6LeezP70E0Ep/lJTx
         u+DzXmzEd+Kx63wlaP6ICaFBK5YbslWgaqo0UH1GSBsQKaChHLypaQQCBi91M+45sosu
         sErpQ9aJ4cmFai/LBRi+hHFnB8f3e/G9LRUQOTEtCFDSIT4dPkjbVITg1226Nbs6112o
         Z2XQ==
X-Gm-Message-State: AOAM533YtfkVdtF9K7uCDM/tq/J2ESplTdqbngZbeeqrhUvAB/GjDms2
        3/fLz/YXKTiy/D9Lv+JK6gzsSh0VQ8w=
X-Google-Smtp-Source: ABdhPJwJcUz69IuHP2soEK1Z4uum8Tr5ERBWvoVNlAmm+OyO3YcRONVXA8ElkmBRUXzzsLEVnjTgVw==
X-Received: by 2002:adf:8287:: with SMTP id 7mr7428804wrc.360.1628501675820;
        Mon, 09 Aug 2021 02:34:35 -0700 (PDT)
Received: from [10.0.0.18] ([37.165.146.152])
        by smtp.gmail.com with ESMTPSA id n10sm1651671wmq.3.2021.08.09.02.34.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 02:34:34 -0700 (PDT)
Subject: Re: [PATCH net-next] net: sock: add the case if sk is NULL
To:     yajun.deng@linux.dev, Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210806061136.54e6926e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210806063815.21541-1-yajun.deng@linux.dev>
 <489e6f1ce9f8de6fd8765d82e1e47827@linux.dev>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <79e7c9a8-526c-ae9c-8273-d1d4d6170b69@gmail.com>
Date:   Mon, 9 Aug 2021 11:34:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <489e6f1ce9f8de6fd8765d82e1e47827@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/9/21 8:12 AM, yajun.deng@linux.dev wrote:
> August 6, 2021 9:11 PM, "Jakub Kicinski" <kuba@kernel.org> wrote:
> 
>> On Fri, 6 Aug 2021 14:38:15 +0800 Yajun Deng wrote:
>>
>>> Add the case if sk is NULL in sock_{put, hold},
>>> The caller is free to use it.
>>>
>>> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
>>
>> The obvious complaint about this patch (and your previous netdev patch)
>> is that you're spraying branches everywhere in the code. Sure, it may
> 
> Sorry for that, I'll be more normative in later submission.
>> be okay for free(), given how expensive of an operation that is but
>> is having refcounting functions accept NULL really the best practice?
>>
>> Can you give us examples in the kernel where that's the case?
> 
> 0   include/net/neighbour.h         neigh_clone()
> 1   include/linux/cgroup.h          get_cgroup_ns() and put_cgroup_ns()  (This is very similar to my submission)
> 2   include/linux/ipc_namespace.h   get_ipc_ns()
> 3   include/linux/posix_acl.h       posix_acl_dup()
> 4   include/linux/pid.h             get_pid()
> 5   include/linux/user_namespace.h  get_user_ns()
> 

These helpers might be called with NULL pointers by design.

sock_put() and sock_hold() are never called with NULL.

Same for put_page() and hundreds of other functions.

By factorizing a conditional in the function, hoping to remove one in few callers,
we add more conditional branches (and increase code size)

