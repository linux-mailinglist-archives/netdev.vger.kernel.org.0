Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A81475764
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 12:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236849AbhLOLJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 06:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbhLOLJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 06:09:35 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B831C061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 03:09:35 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so15701771wme.4
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 03:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=L1zTZfy5R5AxjabiDJiR41FG+zupuU39SJPF4EBNFgA=;
        b=LAvK6vXFBDboVWQKVBtjavuScl9Zy+eZIPflBHVaXRybahq/2ejV2227BZQHtQUNZ8
         SABswwrmIUcY6AssL35zCD9tkLLjy+SHGvI6gCxUhbEsM395Ne53ZaX2t04yU/YK2ze1
         AfsRP+tgyWWKPWvpFR8VaWSPFm/HCupBQnQGaDj/bAqeNYiew3wQ19bq8T3ykMUA1tK/
         1hAt/ioVH5xUChSBRTtJZMe3OUhjwqN/HdD+1Ze1RldWXtVxX4KsDU+FbE0zlc1wa5io
         TEwMgD7CUo89G7gOea3W90flWfCjv+7AT7m/9blHGP3LN44xFBdwcSe0Ql9yeYBc8Uwf
         h0Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=L1zTZfy5R5AxjabiDJiR41FG+zupuU39SJPF4EBNFgA=;
        b=zokNHmj2Pl3OnX/2NLe1bkQpCoM95KAf3O12YHlSn7cdH5tH82yBE2gEb1hEAUIYsg
         cDTLg5sGkOV1e15mB9YGKo7/c7PzJMErowV06GOoKa+0+zxlt0rgq8G2UtXDRtdiVue8
         zVF0C0kxgKC/EeSN1MIXMr70aUV6QFfHfqos+aEbzZ0flDzRl5nlZpylxNhrD9dYgQL6
         b7D+xS/dliOF4gcEW0jR8L1MFxzGpJBYP4oSt54Y5d+vbXk+tCinoMGux+U8jG8Z6GPz
         tB8IvvqZDPTVp+BZb1wRS1XE9Y5dUV5q89kSosU8bQxNy53th77WX5NLAMTD7rcVWIzk
         TVrw==
X-Gm-Message-State: AOAM531b6+RG/JvpJY/mHQrg+rf54k0ke6C8/vC6r0UbcKsKyxYZ0Qp0
        fglR5TkuEsOLF1bYkyQmSFU=
X-Google-Smtp-Source: ABdhPJwSlbOAdio0NFild6Qy88wHq3SGoJ6QbEtG4fj3WZjx6VJrUrEHt91GhBUrrgBBxcWDveGM9A==
X-Received: by 2002:a05:600c:3844:: with SMTP id s4mr4188548wmr.165.1639566573925;
        Wed, 15 Dec 2021 03:09:33 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id k37sm1581616wms.21.2021.12.15.03.09.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 03:09:33 -0800 (PST)
Message-ID: <14d361d8-c06d-e332-1a08-56eb727ded5c@gmail.com>
Date:   Wed, 15 Dec 2021 12:09:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3 net-next 01/23] lib: add reference counting tracking
 infrastructure
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        Vlastimil Babka <vbabka@suse.cz>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
 <20211205042217.982127-2-eric.dumazet@gmail.com>
 <a6b342b3-8ce1-70c8-8398-fceaee0b51ff@gmail.com>
 <CANn89iLCaPLhrGi5FyDppfzqdtsow2i6c5+E7pjtd47hwgvpGA@mail.gmail.com>
 <CANn89iLzZaVObgj-OSG7bT2V8q2AdqUekc2aoiwG7QeRyemNLw@mail.gmail.com>
 <45c1b738-1a2f-5b5f-2f6d-86fab206d01c@suse.cz>
 <CANn89iK+a5+Y=qCAERMBKAL8WRmZw3UOQiwoerse1cmxbTbFZw@mail.gmail.com>
From:   Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <CANn89iK+a5+Y=qCAERMBKAL8WRmZw3UOQiwoerse1cmxbTbFZw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15. 12. 21, 12:08, Eric Dumazet wrote:
> Reported-by: Jiri Slab <jirislaby@gmail.com>

(I am not the allocator :P.)

-- 
js
