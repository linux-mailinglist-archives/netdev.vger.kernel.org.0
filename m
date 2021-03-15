Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFCB33B263
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 13:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhCOMSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 08:18:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24491 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229723AbhCOMSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 08:18:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615810710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yRrmpZIkJnyN15plU+shVn7xF4o8Az14TkOFAdcVE7I=;
        b=D7GmojMxxTTGGKFzGPYwcPcrblo/fb01b9d+98HwbMJKDGtjqR9VvBeG26T2q2X/hxBceT
        BChNJpuCQDo7CTcpdwHic5J6xsZg3sLXXLutkSt0vOmTv5uaa73mucOuQg1Zty1AEqWTZ8
        Hn7lt6rd+HFVtgc+S6kdMAWs0G+cQDA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-K7I2VqQbP0mk79bhpvKRog-1; Mon, 15 Mar 2021 08:18:29 -0400
X-MC-Unique: K7I2VqQbP0mk79bhpvKRog-1
Received: by mail-wr1-f70.google.com with SMTP id f3so15003886wrt.14
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 05:18:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=yRrmpZIkJnyN15plU+shVn7xF4o8Az14TkOFAdcVE7I=;
        b=ZKcQpY2W+Le3WRllPERLalpTysi0243BoCm4WU6fGbAYyHwXfZluhv3zWjZEpVSMvo
         yF0Yovg8B8H0dXt0WnZSH6WbAQNh5WkTTxIC3LgIuGEmnHOMI1XWJ/v0rmuyorFI3sSy
         CVf448FtaXlhutEygNh4aGqOK248WPja9UYC8kj6sii7YZuy6QSfct/2Qr3Pdv1jBf9d
         wL9ccXrdaxF2ByA9kMgdOQz5vEzZGQfAa//18yzOHJybPXHsKC0/3UJKnfElsK65xL9o
         PAFYQ1YD1Khwtwp7oDAle+pZOlb3JZWzkEadCQ/3MD+M/CKwHYmylrIwfqZsp9mqN0Aj
         BkAQ==
X-Gm-Message-State: AOAM533gMun+QOodQVeJ2QxIl/ZOBH2gXbMBqafEYv2gMOPNTRdLrAm4
        x7W7PDzRZudnappHvvTxdYVltzYNE0ZMi3u477/v6KNfj6flk/k0JnbRxosQDVZAliXHW5gLAM2
        hamXHqS53pFjrsgy3
X-Received: by 2002:a05:600c:4844:: with SMTP id j4mr25702088wmo.179.1615810707862;
        Mon, 15 Mar 2021 05:18:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrxyQh8a6zSszabQ63MdjbOFNY+eB5Go98cKMHJh+2kxZ/UHof+27/wnQ9LmlfhmzUQtku2w==
X-Received: by 2002:a05:600c:4844:: with SMTP id j4mr25702078wmo.179.1615810707688;
        Mon, 15 Mar 2021 05:18:27 -0700 (PDT)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id q19sm19206068wrg.80.2021.03.15.05.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 05:18:27 -0700 (PDT)
Date:   Mon, 15 Mar 2021 13:18:24 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     lyl2019@mail.ustc.edu.cn
Cc:     Tom Parkin <tparkin@katalix.com>, paulus@samba.org,
        davem@davemloft.net, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [BUG] net/ppp: A use after free in ppp_unregister_channe
Message-ID: <20210315121824.GC4296@linux.home>
References: <6057386d.ca12.1782148389e.Coremail.lyl2019@mail.ustc.edu.cn>
 <20210312101258.GA4951@katalix.com>
 <2ad7aaa2.fcad.17826e87afb.Coremail.lyl2019@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2ad7aaa2.fcad.17826e87afb.Coremail.lyl2019@mail.ustc.edu.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 10:47:53PM +0800, lyl2019@mail.ustc.edu.cn wrote:
> 
> 
> 
> > -----原始邮件-----
> > 发件人: "Tom Parkin" <tparkin@katalix.com>
> > 发送时间: 2021-03-12 18:12:58 (星期五)
> > 收件人: lyl2019@mail.ustc.edu.cn
> > 抄送: paulus@samba.org, davem@davemloft.net, linux-ppp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
> > 主题: Re: [BUG] net/ppp: A use after free in ppp_unregister_channe
> > 
> > Thanks for the report!
> > 
> > On  Thu, Mar 11, 2021 at 20:34:44 +0800, lyl2019@mail.ustc.edu.cn wrote:
> > > File: drivers/net/ppp/ppp_generic.c
> > > 
> > > In ppp_unregister_channel, pch could be freed in ppp_unbridge_channels()
> > > but after that pch is still in use. Inside the function ppp_unbridge_channels,
> > > if "pchbb == pch" is true and then pch will be freed.
> > 
> > Do you have a way to reproduce a use-after-free scenario?
> > 
> > From static analysis I'm not sure how pch would be freed in
> > ppp_unbridge_channels when called via. ppp_unregister_channel.
> > 
> > In theory (at least!) the caller of ppp_register_net_channel holds 
> > a reference on struct channel which ppp_unregister_channel drops.
> > 
> > Each channel in a bridged pair holds a reference on the other.
> > 
> > Hence on return from ppp_unbridge_channels, the channel should not have
> > been freed (in this code path) because the ppp_register_net_channel
> > reference has not yet been dropped.
> > 
> > Maybe there is an issue with the reference counting or a race of some
> > sort?
> > 
> > > I checked the commit history and found that this problem is introduced from
> > > 4cf476ced45d7 ("ppp: add PPPIOCBRIDGECHAN and PPPIOCUNBRIDGECHAN ioctls").
> > > 
> > > I have no idea about how to generate a suitable patch, sorry.
> 
> This issue was reported by a path-sensitive static analyzer developed by our Lab,
> thus i have not a crash or bug log.
> 
> As the return type of ppp_unbridge_channels() is a int, can we return a value to
> inform caller that the channel is freed?

I don't think this is going to improve anything, as
ppp_unregister_channel() couldn't take any corrective action anyway.

