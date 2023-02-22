Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40D969F151
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 10:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbjBVJY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 04:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjBVJYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 04:24:25 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFBDA5D5
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 01:24:15 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id t13so6949878wrv.13
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 01:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Io3lv0duoV3ZR9ihqxb3m/dgEq+IIF9Apg+YmC2CGzU=;
        b=KiRDNXkIBLHKZ1UTJeob2F3isbz4fTuvhNaXSIdzNo4b5INuZf9ePG2WVGvhmtGn3a
         XMarrs59+kSk7I1P6hw2zoFVhyPiC/eqrId0F/q8pT0wRHXgVtiw/hGOX7r4UJXCBVJe
         K5JGnX1ijAu1r4v6hAxSpS++sda2QlbW0sLB+E0nQ6qZlHZBxyMZj+BUxXHom8+ioGTQ
         TKdHrD6pRLr3Yfdki1RJ1RD83bIaMCAj1snj6J7HHTReBAnd0Jhf44uXqtiBu3j2cIQw
         8q0WfXhiAzKE0oM9C9TX0/19cJdJwgeFHfXWUbsfvwxjBS//ovUw8/EOtL9J4VA+VHYy
         i/QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Io3lv0duoV3ZR9ihqxb3m/dgEq+IIF9Apg+YmC2CGzU=;
        b=7c903ffuP7TUZB7aVrsruEEL3hG9EZT2xOy+O5buZEZ6/b9XiMoyCnS4S6PCYke5Qq
         nyvc3BgP/Lq7J8KgpJ4csHCkl+KiIjiqo6Ib7d+SayklRtDmATQzXX26BLzQRiOvLcfH
         CpUOKJFlWcB/ZHX9D367yM/DdPYB8cttse0WC21dd7QMETxuBlrabnVX8KJXYmQv5MOu
         DfTBvpFspdURVExlidoOHXtpJQ9gTTKqtDD3zECUnWmHB/+d+gCn3NxpusMJ5Xa0ZiHO
         vDSYadXAUrVHYHuUhNKfEIea4rS/Iq23DJoZYDpcsuxKIx6wPvsuEhvb+hCXKUBehJOB
         XZNg==
X-Gm-Message-State: AO0yUKVJOCmngPRlSo23g60XkHP+qHl/IK50NkiZrPj02jhO+JfQux0c
        SXDEXWcMOOVEJrwxMso1Obs=
X-Google-Smtp-Source: AK7set+oC/P+cbR/wSCNtia6zhvUVCBfKOYQ6IGN06Xxv84TuJsjBbicxhPWPunKm5vsKOtBgQpVUg==
X-Received: by 2002:a5d:5511:0:b0:2c3:e7d8:245c with SMTP id b17-20020a5d5511000000b002c3e7d8245cmr5658654wrv.13.1677057853939;
        Wed, 22 Feb 2023 01:24:13 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id e9-20020adff349000000b002c704271b05sm4353828wrp.66.2023.02.22.01.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 01:24:13 -0800 (PST)
Date:   Wed, 22 Feb 2023 09:24:11 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, Yalin Li <yalli@redhat.com>
Subject: Re: [PATCH net-next v4 0/4] sfc: support unicast PTP
Message-ID: <Y/XfO8xhwxn30NMM@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, Yalin Li <yalli@redhat.com>
References: <20230221125217.20775-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230221125217.20775-1-ihuguet@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 01:52:13PM +0100, Íñigo Huguet wrote:
> Unicast PTP was not working with sfc NICs.
> 
> The reason was that these NICs don't timestamp all incoming packets,
> but instead they only timestamp packets of the queues that are selected
> for that. Currently, only one RX queue is configured for timestamp: the
> RX queue of the PTP channel. The packets that are put in the PTP RX
> queue are selected according to firmware filters configured from the
> driver.
> 
> Multicast PTP was already working because the needed filters are known
> in advance, so they're inserted when PTP is enabled. This patches
> add the ability to dynamically add filters for unicast addresses,
> extracted from the TX PTP-event packets.
> 
> Since we don't know in advance how many filters we'll need, some info
> about the filters need to be saved. This will allow to check if a filter
> already exists or if a filter is too old and should be removed.
> 
> Note that the previous point is unnecessary for multicast filters, but
> I've opted to change how they're handled to match the new unicast's
> filters to avoid having duplicate insert/remove_filters functions,
> once for each type of filter.
> 
> Tested: With ptp4l, all combinations of IPv4/IPv6, master/slave and
> unicast/multicast
> 
> Reported-by: Yalin Li <yalli@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>

When you repost after net-next is open again please add my
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

Thanks!

> 
> v2:
>  - fixed missing IS_ERR
>  - added doc of missing fields in efx_ptp_rxfilter
> v3:
>  - dropped pointless static inline in source file
>  - removed the now unused PTP_RXFILTERS_LEN
>  - follow reverse xmas tree convention in xmit_skb_mc
>  - pass expiry as argument to the insert_filter functions and keep returning an
>    integer error code from them, and not pointers, as suggested by Martin
>  - moved the unicast filters expiration check to the end of the worker function
>    to avoid increasing TX latency, as suggested by Martin
>  - added check to avoid inserting unicast filters when doing multicast PTP
> v4:
>  - fixed filter leak, catched by Edward
> 
> Íñigo Huguet (4):
>   sfc: store PTP filters in a list
>   sfc: allow insertion of filters for unicast PTP
>   sfc: support unicast PTP
>   sfc: remove expired unicast PTP filters
> 
>  drivers/net/ethernet/sfc/ptp.c | 272 +++++++++++++++++++++++++++------
>  1 file changed, 223 insertions(+), 49 deletions(-)
> 
> --
> 2.34.3
