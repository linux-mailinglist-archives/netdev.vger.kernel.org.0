Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1836F253A4A
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 00:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgHZWg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 18:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgHZWg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 18:36:28 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05ABC061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 15:36:27 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id a65so3416396wme.5
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 15:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r3dDVIspGiyYxqCa2kdTtpJdpJrrzjbP7NltGCcuyno=;
        b=fpyZ1LbtdaXvuKuLkYJ/+AGNLZxmS4zg29NmtUKIIVlRilZLgQfde2wu6MSeVyXPrX
         TaJ+nYsMHEx3JJbMx9jI9UmHpV7Pn52nUPTHY+QdotDgt+UH6iZ45ExrJayafHgZ+5XQ
         eCJxyFaidNVvMDKRM0yQ+3AnTm/Wzx7eWQoY8l4ubAYiS3uJ+NnFi4oI4wodf/yc1h4s
         TK94srJcSSK686VjzHe0iIz4+vG7zPIT8s9O8Pvb7dNtgesh7QqBf1IPr+c1V67Ir+Q4
         bMMQrxlld5E5v3d5QO+I1ZaU90LOV9raftOokbQJ/pPdkN7tvF69P5z+3/v9Izomce+f
         gCiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=r3dDVIspGiyYxqCa2kdTtpJdpJrrzjbP7NltGCcuyno=;
        b=ukonubpTs6fhr3B8S5ruoqAV+/xDoVbxFCNP5JCnbL+FkLo9kO+pMDFeM60+7/ZXYT
         x3YIMLWD+wMWF3t0X86vBUhqmPeXgzvpL2arh2SyfDc+viq82Y2JkcFoU9cmr7WD3Rtn
         dQraTWxWZP2fM6VGqJihzFPigy2HtZk7XKl5S3ldggSRe5tJI5ILjJ7iZQ63pVdzj+oW
         9mMKMRkfNiMtD0Gk1WkG45ACt96PCQPYJfFAWDfF2HeYTgy3PaJwpcNjjh4zPZ1Z/iHt
         r+mgWy/NblRQ/FkbGaTGtnBPAQm84nBIWTCRiCqPFYoUkl9IHJ+BpnA30+N4n1VJPQnI
         GJ5w==
X-Gm-Message-State: AOAM532WOpvP8RiFqwFXMwoXptCSkDhlBSiPOEohsvJ2ZJfuA3MAv2eX
        Thw+1VNgqNLv2f7CPvf638qOlP29Om9GZQ==
X-Google-Smtp-Source: ABdhPJxuD+71K8YypkUmvbgRmyqp0siJIVZE/WgBr5rDF959Yf7aKfkFa05aztG+79Xc4VNrP7qAiQ==
X-Received: by 2002:a1c:c90d:: with SMTP id f13mr9171024wmb.25.1598481386557;
        Wed, 26 Aug 2020 15:36:26 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:590d:8a36:840b:ee6c? ([2a01:e0a:410:bb00:590d:8a36:840b:ee6c])
        by smtp.gmail.com with ESMTPSA id 70sm651492wme.15.2020.08.26.15.36.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 15:36:25 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v2] gtp: add notification mechanism
To:     Harald Welte <laforge@gnumonks.org>
Cc:     netdev@vger.kernel.org, osmocom-net-gprs@lists.osmocom.org,
        Gabriel Ganne <gabriel.ganne@6wind.com>, kuba@kernel.org,
        davem@davemloft.net, pablo@netfilter.org
References: <20200825143556.23766-1-nicolas.dichtel@6wind.com>
 <20200825155715.24006-1-nicolas.dichtel@6wind.com>
 <20200825170109.GH3822842@nataraja>
 <bd834ad7-b06e-69f0-40a6-5f4a21a1eba2@6wind.com>
 <20200826185202.GZ3739@nataraja>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <0e2c4c04-a6dc-d081-2bdd-09f8d78607c4@6wind.com>
Date:   Thu, 27 Aug 2020 00:36:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200826185202.GZ3739@nataraja>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 26/08/2020 à 20:52, Harald Welte a écrit :
> Hi Nicolas,
> 
> On Wed, Aug 26, 2020 at 09:47:54AM +0200, Nicolas Dichtel wrote:
>>> Sending (unsolicited) notifications about all of those seems quite heavyweight to me.
>>
>> There is no 'unsolicited' notifications with this patch. Notifications are sent
>> only if a userspace application has subscribed to the gtp mcast group.
>> ip routes or conntrack entries are notified in the same way and there could a
>> lot of them also (more than 100k conntrack entries for example).
> 
> Ok, thanks for reminding me of that.  However, even if those events are
> not sent/multicasted, it still looks like the proposed patch is
> unconditionally allocating a netlink message and filling it with
> information about the PDP.  That alone looks like adding significant
> overhead to every user - even the majority of current use cases where
> nobody is listening/subscribing to that multicast group.
I don't think that this is a significant overhead. This is added in the control
path. When a PDP context is added, the rtnl lock is took, this is another
magnitude of overhead than a kmalloc().

> 
> Wouldn't it make sense to only allocate + fill those messages if we
> actually knew a subscriber existed?
In fact, this is actually how the netlink framework works.
