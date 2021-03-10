Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A6F334166
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 16:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbhCJPVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 10:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232940AbhCJPV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 10:21:27 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1561C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 07:21:26 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id c10so39372081ejx.9
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 07:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DEO/Mig4J2xJeIyv81EkyumaNmNKz6sUy8OFSaizPZw=;
        b=Q2qLaX5ugQMDOVmkXfOLS+B5x7pDwqtWDy18s7X9tlbg4muG9XYI86qQlyqBNy0b/v
         mFkHBf2KH8H9RIeDQZ+c4mWlFfmjzscxq0RxI+IlA/qvQsNNfGW13qcNBd3AjalI0gkL
         g/7DM/WnGEFGA5eCsMJRYUT0pj17wBicli5AFYDnK376GJ1YtPnruLZ9svGecsnYMDfs
         BWF0ZmbXBKOxLqTDCuugDSp9nh4hOdKeNyx9ScQV92WMBtguhvCyYPAl1tDi9SSUEDmf
         3mBxV4PZRG8kx/C2iZgdUakvP+a+wB9lsmUutKbJ6AQeN0Xibf1Rgf/fOoe9K1LU336X
         ZQcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DEO/Mig4J2xJeIyv81EkyumaNmNKz6sUy8OFSaizPZw=;
        b=BeNuB0hEh22JwlXxFd0Eag2U5Cdxm1Z4eGOB8ecPLp/0rH3LndkivmsZAQT0BGDbl3
         LVYMCTUZ/wRzRcA6yRjiYprSgKNGkoBoDg5R5Kle38trnCQ4nX3TKeiUYrglVh3wnfB/
         0+sayWdBMDuaxdZh9TOeBlqZaZyNjQAsnEf/KoDe5lNGbO4RsOc2/Nq3IaMLc4+eOiGi
         SCXaXfxriS0o9WSOMcEop3ki1Fs3L0/MDdEWxM8WF970CFK2boFajMS+97xuaj7Kbv3z
         xur/wt3jg645GI/3s89ZCAXNpJvEkanVMfcn3MbfXDsOLinYZUkldk00KNYMyGY2JP/O
         Gy1g==
X-Gm-Message-State: AOAM531T74y16xyWjx7Si3Yl4gl48baP/gsps1Vq1G04mPcQy6aCwRq4
        BHp3kcpjIkDt0cVABMM4aJo=
X-Google-Smtp-Source: ABdhPJwzovZxoOwIcFICVD7KrFE3luV4ciDcdgUqrOwZ5oEilaBVVyuqJ154Oe0SSLmDqREG5MV6+g==
X-Received: by 2002:a17:906:d18e:: with SMTP id c14mr4089958ejz.62.1615389684360;
        Wed, 10 Mar 2021 07:21:24 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id v15sm5154953edw.28.2021.03.10.07.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 07:21:24 -0800 (PST)
Date:   Wed, 10 Mar 2021 17:21:23 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [PATCH net-next] net: add a helper to avoid issues with HW TX
 timestamping and SO_TXTIME
Message-ID: <20210310152123.np4mlvhopky3ruph@skbuf>
References: <20210310145044.614429-1-vladimir.oltean@nxp.com>
 <20210310151626.GE23735@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310151626.GE23735@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 07:16:26AM -0800, Richard Cochran wrote:
> On Wed, Mar 10, 2021 at 04:50:44PM +0200, Vladimir Oltean wrote:
> > As explained in commit 29d98f54a4fe ("net: enetc: allow hardware
> > timestamping on TX queues with tc-etf enabled"), hardware TX
> > timestamping requires an skb with skb->tstamp = 0. When a packet is sent
> > with SO_TXTIME, the skb->skb_mstamp_ns corrupts the value of skb->tstamp,
> > so the drivers need to explicitly reset skb->tstamp to zero after
> > consuming the TX time.
> >
> > Create a helper named skb_txtime_consumed() which does just that. All
>
> Bikeshedding about the name: "consumed" suggests much more to me than
> what is going on.
>
> How about this?   skb_reset_txtime();

Not really a native speaker, but what more does it suggest? As far as
the Ethernet driver is concerned, it needs to consume the TX time (by
putting it into the TX buffer descriptor or whatever) and say it did
that. From the perspective of a driver writer I think it is intuitive to
have it called that way.
