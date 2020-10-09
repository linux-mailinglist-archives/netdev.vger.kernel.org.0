Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D2A288546
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 10:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732867AbgJII3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 04:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732860AbgJII3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 04:29:24 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B7EC0613D2
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 01:29:23 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id l15so8443346wmh.1
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 01:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Jf3dlfL24JvZ4wqAkyRgtbDLd0MzeM7MSauLKAUYU5A=;
        b=ZGlGujfciKxLzz4iXDwa+yCbbAx3XJkyu7/sH/eIEV1F/HHH9a1B1MJy1hhqbOfGQm
         cI5a/ffDCdM5RXvYtUDYUKE/j2a58prQ1wHfvm6jBvFWR4ys8U3VQBdgDKhW0ofh60aQ
         PIaWgJUCbdAPwVWbCT9GHRycvt6eweLubPe8iFyDqlBLF/uwoTPg+H/jmLOjjNQSDFld
         HeQo2IZMG7QmdiWnFrRrbDCMUCpKIvjjwkIlSwtEpJMgCKdyYR1j90IzQ5yoyingg7V9
         9dxBmm7r0OMmbCmkKE5kqaa5oFap4CkPTB+jTSjgFgwJnvML+x+gdxe1nkMpRG2PRigs
         tbtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jf3dlfL24JvZ4wqAkyRgtbDLd0MzeM7MSauLKAUYU5A=;
        b=ZdaIysXvZnGXllX9KuDE2d56vB435env00Vltknnn+/SytO5PYt0v05AnpFf8ql0A7
         0g6Kzv66lnFiN/lXhT90olUpchQvoEZX2jQ9sJ/zqngBR8FhHz4TuQaTVdQKtFHx0A9X
         bm93+uJbPvbtcIuiN5+zbUE7qE9gC7yrYA1oWkCC2nfcOEcquDoHUmQdUG7mgxqg3VcS
         7ycxCkGf/dRNDEGtShSp8vltu9Sm6d2Q6KbdDSHJeMg37s97FgWFOggA+JXsPvdyKDez
         +u42ws/70yUZ7JhK/iTyYT6xLesA7XLZuS8zux1HE/laYfnKqq6h0ODcYSOJGYVf2QJd
         jL5Q==
X-Gm-Message-State: AOAM5335oOjdFDCScpN8w/1QhseSl623TF88fsaDatpZOKrN7niuSrXv
        zGA03cZCFofRtn9p37OqrCoWKkydwyM=
X-Google-Smtp-Source: ABdhPJxh9+0cP2RtHp9ijvgcHUxriajEt9bLcKGk7jXNZx1CH5ugi+ADFStmFEEddV3VETOO6FnsxA==
X-Received: by 2002:a1c:c28a:: with SMTP id s132mr12608802wmf.67.1602232162407;
        Fri, 09 Oct 2020 01:29:22 -0700 (PDT)
Received: from [192.168.8.147] ([37.173.23.174])
        by smtp.gmail.com with ESMTPSA id c14sm10676902wrv.12.2020.10.09.01.29.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 01:29:21 -0700 (PDT)
Subject: Re: [Bug 209423] WARN_ON_ONCE() at rtl8169_tso_csum_v2()
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <bug-209423-201211-atteo0d1ZY@https.bugzilla.kernel.org/>
 <80adc922-f667-a1ab-35a6-02bf1acfd5a1@gmail.com>
 <CANn89i+ZC5y_n_kQTm4WCWZsYaph4E2vtC9k_caE6dkuQrXdPQ@mail.gmail.com>
 <733a6e54-f03c-0076-1bdc-9b0d4ec1038c@gmail.com>
 <CANn89iJ2zqH=_fvJQ8dhG4nBVnKNB7SjHnHDLv+0iR7UwgxTsw@mail.gmail.com>
 <b6ff841a-320c-5592-1c2b-650e18dfe3e0@gmail.com>
 <CANn89iJ2KxQKZmT2ShVZRTjdgyYkF_2ZWBraTZE4TJVtUKh--Q@mail.gmail.com>
 <9e4b2b1f-c2d9-dbd0-c7ce-49007ddd7af2@gmail.com>
 <CANn89iJwwDCkdmFFAkXav+HNJQEEKZsp8PKvEuHc4gNJ=4iCoQ@mail.gmail.com>
 <77541223-8eaf-512c-1930-558e8d23eb33@gmail.com>
 <CANn89i+dtetSScxtSRWX8BEgcW_uJ7vzvb+8sW57b7DJ3r=fXQ@mail.gmail.com>
 <dbad301f-7ee8-c861-294c-2c0fac33810a@gmail.com>
 <186242a7-4e63-dccc-0879-1069823f079a@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <683da991-2666-ed40-26a7-32e1e6858c24@gmail.com>
Date:   Fri, 9 Oct 2020 10:29:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <186242a7-4e63-dccc-0879-1069823f079a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/8/20 10:54 PM, Heiner Kallweit wrote:
> On 08.10.2020 21:07, Eric Dumazet wrote:
>>
>>
>> On 10/8/20 8:50 PM, Eric Dumazet wrote:
>>>
>>>
>>> OK, it would be nice to know what is the input interface
>>>
>>> if4 -> look at "ip link | grep 4:"
>>>
>>> Then identifying the driver that built such a strange packet (32000
>>> bytes allocated in skb->head)
>>>
>>> ethtool -i ifname
>>>
>>
>> According to https://bugzilla.kernel.org/show_bug.cgi?id=209423
>>
>> iif4 is the tun200 interface used by openvpn.
>>
>> So this might be a tun bug, or lack of proper SKB_GSO_DODGY validation
>> in our stack for buggy/malicious packets.
>>
>>
> 
> Following old commit sounds like it might be related:
> 622e0ca1cd4d ("gro: Fix bogus gso_size on the first fraglist entry")
> 
> This code however was removed later in 58025e46ea2d ("net: gro: remove
> obsolete code from skb_gro_receive()")
> 

GRO wont keep in its queues a GSO packet
dev_gro_receive()
...
NAPI_GRO_CB(skb)->flush = skb_is_gso(skb) || skb_has_frag_list(skb);
...

Also note that tun no longer can inject a packet with a length of 134 bytes pretending
to have gso_size == 538

Look at virtio_net_hdr_to_skb() and commits
6dd912f82680 ("net: check untrusted gso_size at kernel entry")
7c6d2ecbda83 ("net: be more gentle about silly gso requests coming from user")

Really looking at the skb layout I suspect some usbnet bug and a use-after-free.

ASAN build might help.


