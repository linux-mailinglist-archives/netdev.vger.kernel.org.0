Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C622D93C0
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 09:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438991AbgLNIAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 03:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728424AbgLNIAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 03:00:38 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CDBC0613CF
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 23:59:53 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id r14so15445351wrn.0
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 23:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=kd2t0wHqIQ2cj+dKNHtEGVRul+Ifi0yJni6DE5YuQHA=;
        b=wegBNaYi2LEXQTZqN+s9suhDO3YTw8I2ZPtsCck5/XgByP1fijIOmu0AfQoP8rf+t1
         YhO0WeDLvGQjqnglnIgNYXUgF0/7MJwaokukVmFe77bCjmbjCNprf1IXNldiDbwwHeo+
         SnglmV2EiHnSFvHo8FpEen6lFmnv8XRacAc0+Bn0RCeC7jWvloA2XwcSa896Wpb3QRt6
         XG1N13XLiK5Fq9MPdwJ7MXShoLGljxPxntzFSMOJE2RD6GurGY4e3TkwnSqYN0r4QHZS
         p3Cr9sQWg7VPYpWJQKHoN9TlX7fAj8pOH+/wFD3uK7g4aASsiZwxZrWaNQbLDp0kGVHV
         c0iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=kd2t0wHqIQ2cj+dKNHtEGVRul+Ifi0yJni6DE5YuQHA=;
        b=k9VtRXCj922yHZujLxx+gELHHGCT+2WUQnSTatyQcXTo9Fp5cZEGXxSqOXcb5qY/Yj
         R9mxipYKXAhHZRPszljZRa0c5g3AWYTS05DQshG+0HksRJzBZmaefX8+1MMQ0/0j7JPR
         F66sv6LAaMBwg3EaAD/cyM9MbdCUmxUFOvhjXabcLOH/Wu9OJqdr85UhophqXQRQ0rjo
         B2nEI/EGCeLqGE656WzUv2Ub4Rsi1hDIFKwJKaw0TftjOW4+tPz/52W0FqjIddItscbi
         qUg6+8TQrfZdgF970PsEpz17rV/InDxCwVqIrkwoDz/uh4nAed/WS9dwKDi/Cw7nqXZf
         pWLQ==
X-Gm-Message-State: AOAM5306ixOIcDstZ9dU7N6g9e3EeSBohygpnigVBliqsbw3urKyLK+P
        3PUNV7UbibGg1zI+OMaN7kdedA==
X-Google-Smtp-Source: ABdhPJyUla4wDf8IEmiN8xdqzOem+EOqdjvkE6hO29s06UgDBEcoG6bRKExngLb1bGDR97cqiHMw2g==
X-Received: by 2002:adf:ebd2:: with SMTP id v18mr27309701wrn.322.1607932792601;
        Sun, 13 Dec 2020 23:59:52 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id b13sm23428554wrt.31.2020.12.13.23.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 23:59:52 -0800 (PST)
Date:   Mon, 14 Dec 2020 08:59:51 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, jiri@nvidia.com,
        netdev@vger.kernel.org, davem@davemloft.net, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 13/15] mlxsw: spectrum_router_xm: Introduce
 basic XM cache flushing
Message-ID: <20201214075951.GQ3055@nanopsycho.orion>
References: <20201211170413.2269479-1-idosch@idosch.org>
 <20201211170413.2269479-14-idosch@idosch.org>
 <20201211202427.5871de8a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201212172502.GA2431723@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201212172502.GA2431723@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Dec 12, 2020 at 06:25:02PM CET, idosch@idosch.org wrote:
>On Fri, Dec 11, 2020 at 08:24:27PM -0800, Jakub Kicinski wrote:
>> On Fri, 11 Dec 2020 19:04:11 +0200 Ido Schimmel wrote:
>> > From: Jiri Pirko <jiri@nvidia.com>
>> > 
>> > Upon route insertion and removal, it is needed to flush possibly cached
>> > entries from the XM cache. Extend XM op context to carry information
>> > needed for the flush. Implement the flush in delayed work since for HW
>> > design reasons there is a need to wait 50usec before the flush can be
>> > done. If during this time comes the same flush request, consolidate it
>> > to the first one. Implement this queued flushes by a hashtable.
>> > 
>> > Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
>> 
>> 32 bit does not like this patch:
>
>Thanks
>
>Jiri, looks like this fix is needed:

Okay, will send you fixed version. Thx.


>
>diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
>index b680c22eff7d..d213af723a2a 100644
>--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
>+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
>@@ -358,7 +358,7 @@ mlxsw_sp_router_xm_cache_flush_node_destroy(struct mlxsw_sp *mlxsw_sp,
> 
> static u32 mlxsw_sp_router_xm_flush_mask4(u8 prefix_len)
> {
>-       return GENMASK(32, 32 - prefix_len);
>+       return GENMASK(31, 32 - prefix_len);
> }
> 
> static unsigned char *mlxsw_sp_router_xm_flush_mask6(u8 prefix_len)
>
>> 
>> In file included from ../include/linux/bitops.h:5,
>>                  from ../include/linux/kernel.h:12,
>>                  from ../drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c:4:
>> ../drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c: In function ‘mlxsw_sp_router_xm_flush_mask4’:
>> ../include/linux/bits.h:36:11: warning: right shift count is negative [-Wshift-count-negative]
>>    36 |   (~UL(0) >> (BITS_PER_LONG - 1 - (h))))
>>       |           ^~
>> ../include/linux/bits.h:38:31: note: in expansion of macro ‘__GENMASK’
>>    38 |  (GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))
>>       |                               ^~~~~~~~~
>> ../drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c:361:9: note: in expansion of macro ‘GENMASK’
>>   361 |  return GENMASK(32, 32 - prefix_len);
>>       |         ^~~~~~~
>> ../drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c:361:16: warning: shift count is negative (-1)
>> In file included from ../include/linux/bitops.h:5,
>>                  from ../include/linux/kernel.h:12,
>>                  from ../drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c:4:
>> ../drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c: In function ‘mlxsw_sp_router_xm_flush_mask4’:
>> ../include/linux/bits.h:36:11: warning: right shift count is negative [-Wshift-count-negative]
>>    36 |   (~UL(0) >> (BITS_PER_LONG - 1 - (h))))
>>       |           ^~
>> ../include/linux/bits.h:38:31: note: in expansion of macro ‘__GENMASK’
>>    38 |  (GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))
>>       |                               ^~~~~~~~~
>> ../drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c:361:9: note: in expansion of macro ‘GENMASK’
>>   361 |  return GENMASK(32, 32 - prefix_len);
>>       |         ^~~~~~~
