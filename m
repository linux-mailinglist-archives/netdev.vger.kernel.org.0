Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F74F2540BC
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 10:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgH0IZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 04:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727961AbgH0IZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 04:25:42 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF018C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 01:25:41 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id r15so4449603wrp.13
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 01:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fNByeHVDbFMOoS5ytnGv8lYTbDplR4L0uTAVH8FeXIc=;
        b=Jg22yXHtJrmmzdSayxlM/zCN6OsSfAq7h2GvuU7W7Y2gwfiUPKRqMDkn09IkqPMZMA
         r8V+4Acu5BiYn2ZTgS11CT7Vi0+nGzRB1NKvaqOijPu5sPCGXGZ7WCHxzfd8yMF/CQ77
         +Kv3/VMrVJCs13N4SMYWudKSwwKKSpgMQaF643mGW+f44RSHBH9WOTAkmtIX34FV+r9t
         WpmM353Cz/ohkP0W8p3otwUbJ16T3OmMgEf58cdPelk4ZmS21C/AOraZ40zCwWbVamSH
         qsA8tBoU1s2DBxS7c0ujXyd94bPhqVwTJeE4c8OPSpysPvmGbGoWdfAwYC/Tz21Ns3+Q
         rwgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fNByeHVDbFMOoS5ytnGv8lYTbDplR4L0uTAVH8FeXIc=;
        b=XPkPoxp4JpIfhA6wHc8h88TJKbSBU4GsYIq20nAy+3PoxGl1R3vMx37gqtH/1AasdL
         P9P00yLyfZyvUOu3R8twPvTtxob7cVCfo8AMYuHFLcAlAagdj6srRw/Vsy3Ga7ZhRQUm
         EDa4P54ItmWGKOJz0uCJ+zEFlvylTM6qcvl2BfF/Q67M7j2mv392JIbWlSa9rH3btdRo
         ZFnKTMY03wJRzXRSdnr/yhzBvtBOHbenbGv72FKy6Z8hvc0kwZd7q0hTgLEtK34zO2hc
         uekvcAJBsVUFUNJmR11V8d028Zx8WnDgbqPNH/X02q5HO1iw3N6hqoPpqHrSzyS7c1WF
         NTtw==
X-Gm-Message-State: AOAM530VwBPhJoEZCqQJosGqvPzWUR48SjnrSns4xE0WIafoPAT6dHVE
        YcUycwU29SjEHzqDG0/fssg=
X-Google-Smtp-Source: ABdhPJzikUzl1kIXdD/a3Q2Ptvq4OjlgHmK9EvZIaGmR2S3S8k+2Y0omrIo/r4f/bkSlHgmBvLv9Gw==
X-Received: by 2002:a5d:5272:: with SMTP id l18mr18645010wrc.89.1598516740662;
        Thu, 27 Aug 2020 01:25:40 -0700 (PDT)
Received: from [192.168.8.147] ([37.171.26.29])
        by smtp.gmail.com with ESMTPSA id j5sm3808507wma.45.2020.08.27.01.25.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 01:25:40 -0700 (PDT)
Subject: Re: [PATCH] iavf: use kvzalloc instead of kzalloc for rx/tx_bi buffer
To:     Li RongQing <lirongqing@baidu.com>, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
References: <1598514788-31039-1-git-send-email-lirongqing@baidu.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6d89955c-78a2-fa00-9f39-78648d3558a0@gmail.com>
Date:   Thu, 27 Aug 2020 01:25:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1598514788-31039-1-git-send-email-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/27/20 12:53 AM, Li RongQing wrote:
> when changes the rx/tx ring to 4096, kzalloc may fail due to
> a temporary shortage on slab entries.
> 
> kvmalloc is used to allocate this memory as there is no need
> to have this memory area physical continuously.
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---


Well, fallback to vmalloc() overhead because order-1 pages are not readily available
when the NIC is setup (usually one time per boot)
is adding TLB cost at run time, for billions of packets to come, maybe for months.

Surely trying a bit harder to get order-1 pages is desirable.

 __GFP_RETRY_MAYFAIL is supposed to help here.


