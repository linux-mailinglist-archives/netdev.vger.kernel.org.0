Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0EE2DA234
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 22:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503714AbgLNVBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 16:01:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503630AbgLNVAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 16:00:44 -0500
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65C5C061793
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 13:00:04 -0800 (PST)
Received: by mail-vk1-xa41.google.com with SMTP id m67so1833040vkg.7
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 13:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S6Azrne2gwBOsw/2DZExuRk7zhJphTc9nE0FgDt5TBs=;
        b=IBvLw+3ABHVlnQ+baHXr0SkKfBBlelE5oAlwhwYa24ecW8FfhyfzG80awPcF7SMoZj
         buGYkn9w1nHwDs2TLbShmHXeX1MGoAWbWT7iapfEmhvYb6KEUDM25W7hK34GHfEJ5UTo
         9X6tTex0PVjgz4YWupbk8RjntAyQXCZf8ISlYaOQmxcdGetjJFCXML4JKAeQR08yRWDw
         XNvh03l8R/2QQGlgPyRp3AzGbvW1U2LB6DdcfzcUfg3q43vSL1FbTFr+8rVJlHeS/wbb
         FMntiePTC+Tsz+qz0j/FwicQNtMdcMxwQ6wVolJsb9Oz0Hi8Pb0d9PqugxnloBl0WHVF
         CLPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S6Azrne2gwBOsw/2DZExuRk7zhJphTc9nE0FgDt5TBs=;
        b=dJjlE732olxGPpIBR/PFXoRiBNZShMdqXGd6YRETlJMXVAJh7+UJij5ZSuBpl9oHH6
         QrDLxuh8qvScitmxB/9DITzZIRvqXd+X81DJq71WgoB/AZAvUjB1JgGeqYMT/+8Byoyu
         gxC25XRppkNxFcU+/1PrcNpzXhALr3gOzAC2Bs4ETzSgBMtjAR6xqG/9BGawgrz1M9G6
         clkLTGh9SPu9KYwiYFITsVnJP8NvSZmCH5DyxqufQfyH7EIrQs+gCdVyVD4fWIG0200Z
         tn1xwGb5TAVspShsWRb0onYF8Ug0i9Zrf5sL6zEAGBJ4DfSQI5aeURxnxy36dK3CKIVO
         PlrA==
X-Gm-Message-State: AOAM532RJzLbOAO++9m/oVHLE4pXX9i1zDyjnsU+0hpTGUASNzHT166J
        /jBI3x/wBuYdHKimdLKCLYLWYSOYk+M=
X-Google-Smtp-Source: ABdhPJzHtNfTK3FAZlvBIC2lOe4Xr0iNNvjracAgd5o6GQcp39KqE5CnFnvLFuXZ6rZDvJIJtxkfWQ==
X-Received: by 2002:ac5:ce9b:: with SMTP id 27mr27131558vke.9.1607979603335;
        Mon, 14 Dec 2020 13:00:03 -0800 (PST)
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com. [209.85.222.50])
        by smtp.gmail.com with ESMTPSA id 84sm1676305vkz.34.2020.12.14.13.00.02
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 13:00:02 -0800 (PST)
Received: by mail-ua1-f50.google.com with SMTP id s23so5930865uaq.10
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 13:00:02 -0800 (PST)
X-Received: by 2002:ab0:7386:: with SMTP id l6mr8297845uap.141.1607979601681;
 Mon, 14 Dec 2020 13:00:01 -0800 (PST)
MIME-Version: 1.0
References: <CAF=yD-JqVEQTKzTdO1BaR_2w6u2eyc6FvtghFb9bp3xYODHnqg@mail.gmail.com>
 <1b2494af-2c56-8ee2-7bc0-923fcad1cdf8@virtuozzo.com>
In-Reply-To: <1b2494af-2c56-8ee2-7bc0-923fcad1cdf8@virtuozzo.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 14 Dec 2020 15:59:24 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeicMroDHZGFuWQxhpwVBOztwWLMnzVTZKXPQ2EY9VmRA@mail.gmail.com>
Message-ID: <CA+FuTSeicMroDHZGFuWQxhpwVBOztwWLMnzVTZKXPQ2EY9VmRA@mail.gmail.com>
Subject: Re: [PATCH v2] net: drop bogus skb with CHECKSUM_PARTIAL and offset
 beyond end of trimmed packet
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 2:21 PM Vasily Averin <vvs@virtuozzo.com> wrote:
>
> syzbot reproduces BUG_ON in skb_checksum_help():
> tun creates (bogus) skb with huge partial-checksummed area and
> small ip packet inside. Then ip_rcv trims the skb based on size
> of internal ip packet, after that csum offset points beyond of
> trimmed skb. Then checksum_tg() called via netfilter hook
> triggers BUG_ON:
>
>         offset = skb_checksum_start_offset(skb);
>         BUG_ON(offset >= skb_headlen(skb));
>
> To work around the problem this patch forces pskb_trim_rcsum_slow()
> to return -EINVAL in described scenario. It allows its callers to
> drop such kind of packets.
>
> Link: https://syzkaller.appspot.com/bug?id=b419a5ca95062664fe1a60b764621eb4526e2cd0
> Reported-by: syzbot+7010af67ced6105e5ab6@syzkaller.appspotmail.com
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> ---
> v2: drop bogus packets instead change its CHECKSUM_PARTIAL to CHECKSUM_NONE

Thanks for revising.

As far as I can tell, this goes back to the original introduction of
that user interface to set checksum offload, so

Fixes: 296f96fcfc16 ("Net driver using virtio")

For next time, please also mark network fixes as [PATCH net]. With that

Acked-by: Willem de Bruijn <willemb@google.com>
