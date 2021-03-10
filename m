Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77E133414C
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 16:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbhCJPRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 10:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbhCJPQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 10:16:30 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A7BC061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 07:16:30 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id a22-20020a17090aa516b02900c1215e9b33so7392297pjq.5
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 07:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=d3YQamIFLpbCQuL45ZRdtQhVMsaQL2rzI8zDhnA7epg=;
        b=dfdXukufR6dqSB1+dfwHLoCXhOZitksHNte5WOBQcYgadxYW8lqKVV+sS/GwuGCKyE
         3OOeTBwPiH39C6VVs3yiglrMgnPa6BxdHZHHHRgvXdMI/6BgA7hMbbAj3RfGZIktYvga
         xHa+M6wkjdefz9Am+c7qdhxg9HI6iWORDMzaR0dvGDNMNvxvD0szSxQjdtavIG4knWYt
         01Qdvn0blp31OlLpz+GoDS2DMWiuY6Qc38fFqrQjtQsoJePZ3AU++vb/bjaJlnxtRXNr
         lz2jurxbt7ub0fPEpWgJZsMzrtul01mjYZS3R2uP5RQXWKnJS9Jw+546SHkKbEAZ7PJm
         qmzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=d3YQamIFLpbCQuL45ZRdtQhVMsaQL2rzI8zDhnA7epg=;
        b=KsBm0CPZqtGTocNQwb4Vec7jh9Jewl5rq760JPowmeweBMAVHa8jb7VC4aVtVeGpwv
         NqcA4QFhfi9fRHcCUNX4mP1SlkCS990JVQ8vWIc3E4zH3jvSQLliZKE1ssa5QiypOm2D
         QM/lnLJMZNYtFixkaRKKkQT1m3Dv0byg3DKGG31+uZ8wPuT2pFT/dnMUymQaWf7iX4Sw
         KBO1kM7MLmRzkQwbN3iiuI1IiVrODOdrstF119AUZa0ICCtHo8lvemR4y7yAH2mnSS/T
         Zg5J856ixPdbRvZWlVOCi4L2rUKvSGvWyIkWZXkpx99bepj6NqmXlGlBpqEPewLbpxxk
         BArg==
X-Gm-Message-State: AOAM531QxUzPh8XGBneIMPFBv/pcOptFR0JKp+by7Rr/1A6k5+qPIyEU
        NuktowlZCcan1NiUYt4RA90=
X-Google-Smtp-Source: ABdhPJxcWkO7fonMUvhIta3KYxJvls66MJPTJPV6nYbdMvAEIT/GgnsQYUVgmVfiqQA73NZh8dOEbQ==
X-Received: by 2002:a17:902:bc49:b029:e6:6750:7fab with SMTP id t9-20020a170902bc49b02900e667507fabmr138805plz.4.1615389389546;
        Wed, 10 Mar 2021 07:16:29 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:645:c000:8:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id c21sm17283189pgh.0.2021.03.10.07.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 07:16:28 -0800 (PST)
Date:   Wed, 10 Mar 2021 07:16:26 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [PATCH net-next] net: add a helper to avoid issues with HW TX
 timestamping and SO_TXTIME
Message-ID: <20210310151626.GE23735@hoboy.vegasvil.org>
References: <20210310145044.614429-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310145044.614429-1-vladimir.oltean@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 04:50:44PM +0200, Vladimir Oltean wrote:
> As explained in commit 29d98f54a4fe ("net: enetc: allow hardware
> timestamping on TX queues with tc-etf enabled"), hardware TX
> timestamping requires an skb with skb->tstamp = 0. When a packet is sent
> with SO_TXTIME, the skb->skb_mstamp_ns corrupts the value of skb->tstamp,
> so the drivers need to explicitly reset skb->tstamp to zero after
> consuming the TX time.
> 
> Create a helper named skb_txtime_consumed() which does just that. All

Bikeshedding about the name: "consumed" suggests much more to me than
what is going on.

How about this?   skb_reset_txtime();

Thanks,
Richard
