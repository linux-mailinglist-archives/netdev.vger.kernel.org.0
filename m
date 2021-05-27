Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FD8393431
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 18:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236618AbhE0Qlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 12:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236559AbhE0Qly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 12:41:54 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C16C061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 09:40:20 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id e8so411946qvp.7
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 09:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=NSOnF1ZkKeHv4axFJknBqEdlVFSN3kUHTbKyaHG9iDE=;
        b=fAe0iKFodHZdUXmptRlj+vhJTfFnMObedlgJKji0s5dbbvaNPcxcpOGXVXYHPlcEKx
         X/1eDHjcttzpvvrz29nBL5OG+bSC1Smp4HBWQSJy+yKZ0OPpiKRp3Cj60YibaETbbw84
         c07xwk4yLQjcWUrKDS3A97g/s/j/onEEu6+wtMZg14FGBvWvBzHRv0UrXrD7mACe030Q
         ERjYKFQ3bLz9sXuDvUhjJ2nQur7VtLZDcXC6wAbSTvUn/ImihZ0mV+GEu9zXL7k3wH1Y
         7HpiJ4enHQJLHfln3CEcVbrCea3GvD0/Jcx2MolihTHNG6U/CXicQjCcBaUnaxxDjCIN
         XFNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=NSOnF1ZkKeHv4axFJknBqEdlVFSN3kUHTbKyaHG9iDE=;
        b=TTSLNLYPAa5kRTLHBE7YGZX4W4pSEoEz2oLGotHPkHvA7eJ5jA5WteYNc/NtpMwo/8
         FSzSndW7KLAXCsaqd4IngzbAhB2/4db/2aMTCAyEZnQkUUFwUewxXCgeyu7KlZcYQbvi
         5pa2MNc1wm6R2l8WJX2XWyck7Ews9ZDfyL/HHS3Hwknn6cqVIbNy7wrdWIMjq2W997Vf
         i6uQZg/B6DZzXdDwJW7ZXYMQIYWNyPidixnrvF7EKSeJwfrHLmBoUTO8F3T6ON2RUfwY
         SCmL/sZYWwi6Y15oVn+7hSV7y+DtsC5pYTgZU8zuhRM2NVG07JWdRakUsuTchlhhgQIQ
         qrvQ==
X-Gm-Message-State: AOAM530j+kP5xrfwQrVkZJR4ZcsR7GRADNy2skpQDIP9BFA1S7cE0PeO
        dhrLWSGDTAeGjKeImdj4KYJ4kXL2vuz5yA==
X-Google-Smtp-Source: ABdhPJwOfLB1Qq2A79qh9HZ/Qapx6Ptsyu8l19Vqpm2LxhkWXJXmBuR1W6ZjwxAD8azVXsdRLy6moA==
X-Received: by 2002:ad4:5be5:: with SMTP id k5mr2116869qvc.55.1622133619786;
        Thu, 27 May 2021 09:40:19 -0700 (PDT)
Received: from horizon.localdomain ([177.220.174.185])
        by smtp.gmail.com with ESMTPSA id g6sm1659802qkm.120.2021.05.27.09.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 09:40:19 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 96FA7C169D; Thu, 27 May 2021 13:40:16 -0300 (-03)
Date:   Thu, 27 May 2021 13:40:16 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Ariel Levkovich <lariel@nvidia.com>
Cc:     netdev@vger.kernel.org, paulb@nvidia.com, jiri@resnulli.us
Subject: Re: [PATCH net] net/sched: act_ct: Fix ct template allocation for
 zone 0
Message-ID: <YK/LcLVMhFDe/7KF@horizon.localdomain>
References: <20210526170110.54864-1-lariel@nvidia.com>
 <YK76nZpfTBO904lU@horizon.localdomain>
 <021dab3f-9ca3-ffeb-b18a-24c9207a7000@nvidia.com>
 <YK+/zn0R+M4lYfC+@horizon.localdomain>
 <5db2e2b3-c768-661a-dc05-fa850c8d066a@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5db2e2b3-c768-661a-dc05-fa850c8d066a@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 12:14:21PM -0400, Ariel Levkovich wrote:
...
> I meant if there's no ct_clear action.
> 
> Assume we already when through zone X in some previous action.
> 
> In such case skb->_nfct has that zone's id.
> 
> Now, if we go to zone=0, we skip this entirely, since p->tmpl is NULL :
> 
> /* Associate skb with specified zone. */
>                 if (tmpl) {
>                         nf_conntrack_put(skb_nfct(skb));
> nf_conntrack_get(&tmpl->ct_general);
>                         nf_ct_set(skb, tmpl, IP_CT_NEW);
>                 }
> 
> 
> And then in nf_conntrack_in it continues with the previous zone:
> 
> err = nf_conntrack_in(skb, &state)
> 
>    calling ->   ret = resolve_normal_ct(tmpl, skb, dataoff,
>                                   protonum, state);
> 
>            calling -> zone = nf_ct_zone_tmpl(tmpl, skb, &tmp);
> 
> 
> I encountered it by accident while running one of our test which was buggy
> 
> but due to the zone=0 bug the bug in the test was hidden and test passed.
> 
> Once I enabled my fix to alloc templated for zone=0 it was exposed.
> 
> The test doesn't use ct_clear between zones.

I see now, thanks. When you had said without ct_clear, I thought only
about the first run through ct. Didn't think there would be this
implicit ct_clear expectation. It could also erase _nfct if zone==0,
but agree, too much especial handling for zone 0.

Seems it needs both fixes then, while this patch is good as is.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
