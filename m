Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FA22FACF9
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 22:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388946AbhARVvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 16:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388343AbhARVux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 16:50:53 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84602C061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 13:50:12 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id w1so25669637ejf.11
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 13:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5Ldq2W/Hf+GrYio+okGuvQrsHLbkllVq+dIJB0O1WKE=;
        b=uIfY0kZNqurC9L9YAcxR4K2WsMJgo1O+UGlKi2DZdiKWpE7SnBZonUCQZNiF/ryo/y
         iqkEAYqmaE8uJGiUAhNoupsge5Emc7srRUz9xVra7mnblJYjxSnjTSxwexqhnjW78/nc
         8+gNpOzYo1v4+cP4VKKlZg0L5k8b1HFDXheJcuYIRTHsWzCqZYhGlY/olnQTeXzHPSgS
         NQ64P6eTM8ep+SX4GaRLE9GGe6xsNQsGpOhOkZyxmcG41ozDOrHXHWBR+MfimImWEefY
         RARB9fn4CvhHr54bfdWdVuVN8HigpXJNHEHPatvBe0dWqSk422UsI8lT1UoQROYDj5vi
         CKYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5Ldq2W/Hf+GrYio+okGuvQrsHLbkllVq+dIJB0O1WKE=;
        b=eOYJHbtag/kMUzp43wjFc71IJSOEnPpesNV6PeA3mQh9bY2YRH70nvAwyxc/zVeVyb
         M2DanyWV3xXVb3IGoVMx1E564/gYB6XVy/JgiMSEYz3H3LPZBdmumibDejZhSqZwEvjm
         ho8lcjGkiRkgnp63Add17Jzrt5Qw4mmMfvnfgPhLBdzGpon2ulMsz9xAgJElqAnU9n68
         ovbL8jUGPzp3yIS5vlkkn6cxgAdKCqZA+jNtXgA2EOihr5WE78+J9396DT/F3zvHndaZ
         lTTa/GMcdBqQGHuC0KvmhV+3Ub3xMrw487IQvrT/elPX+areDs2dXfRzjbbnDMLxppfx
         9sRQ==
X-Gm-Message-State: AOAM53184306eW8mePFSvg/zwLOPJNQvbseRhRuTfiTkQRyOu1GcWZy4
        AqmbfNafMw6bo0nhgl/HyJ4=
X-Google-Smtp-Source: ABdhPJxIFeEg2Zp+5Gxsc4YJBPh1XJRk3cHRKV6RB/8mJyiDhTLkma+gkJa4KtUle1t5YMlmel6tPw==
X-Received: by 2002:a17:907:3f9e:: with SMTP id hr30mr1015415ejc.445.1611006611306;
        Mon, 18 Jan 2021 13:50:11 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id zk10sm1873092ejb.10.2021.01.18.13.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 13:50:10 -0800 (PST)
Date:   Mon, 18 Jan 2021 23:50:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, roopa@nvidia.com, netdev@vger.kernel.org,
        jiri@resnulli.us, idosch@idosch.org, stephen@networkplumber.org
Subject: Re: [RFC net-next 2/7] net: bridge: switchdev: Include local flag in
 FDB notifications
Message-ID: <20210118215009.jegmjjhlrooe2r2h@skbuf>
References: <20210116012515.3152-1-tobias@waldekranz.com>
 <20210116012515.3152-3-tobias@waldekranz.com>
 <20210117193009.io3nungdwuzmo5f7@skbuf>
 <87turejclo.fsf@waldekranz.com>
 <20210118192757.xpb4ad2af2xpetx3@skbuf>
 <87o8hmj8w0.fsf@waldekranz.com>
 <75ba13d0-bc14-f3b7-d842-cee2cd16d854@nvidia.com>
 <b5e2e1f7-c8dc-550b-25ec-0dbc23813444@nvidia.com>
 <ee159769-4359-86ce-3dca-78dff9d8366a@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee159769-4359-86ce-3dca-78dff9d8366a@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 11:39:27PM +0200, Nikolay Aleksandrov wrote:
> Apologies for the multiple emails, but wanted to leave an example:
> 
> 00:11:22:33:44:55 dev ens16 master bridge permanent
> 
> This must always exist and user-space must be able to create it, which
> might be against what you want to achieve (no BR_FDB_LOCAL entries with
> fdb->dst != NULL).

Can you give me an example of why it would matter that fdb->dst in this
case is set to ens16?
