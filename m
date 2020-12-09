Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6EA82D4004
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 11:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730047AbgLIKdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 05:33:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729865AbgLIKdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 05:33:01 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8DEC0613CF;
        Wed,  9 Dec 2020 02:32:21 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id bo9so1337714ejb.13;
        Wed, 09 Dec 2020 02:32:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9b0dzPnx2nVNu95AjqFC5uS68mxGFLtloECAzqENJGE=;
        b=NN/AoD3sFWyM3KAyRSH5GqFqGmvLbLUqP3RmPKrnvJXCM5yAHc8Vl+Qykn5jF5slWx
         21nuFTR6xEedICgsERShj5Po5EcLR10QHUYMG4V9bc1FWB3ak9EpXs6VhLt1NFPckCGn
         rwXz0MzgaGliqnfKPAyAfRalXWKrj4ZreKifxW6KiejQEED3j0xIcIcRYPO29Mcwr+dM
         OhGskj03xlRHl7YsLO9WZT5dU3fqLVplbhB/DdJRl1+PidbBb/KvLQzcQv0Ezz0q7wbg
         R1F99Fd4oayYIFHB2Dxt3XAic69pvwAjluZVfTxcB3f+3zIeC5aztAy7aKXQRRURISb2
         4GTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9b0dzPnx2nVNu95AjqFC5uS68mxGFLtloECAzqENJGE=;
        b=uJxPLaoo4m9OZrSXvYgxkS7ucQ7QtG08ZGZnjBGK8PzgKdKQ3gPiVVhohasy2kaixO
         UPxOY5wqbMl/RBetK6+b+jMnnbOpO20N+W9so97Gb9iTcopa/iyelhcTmJRWAQWzlciG
         X80bnyjBj6OA40t6EHau4KK1D26OIGx/Um+5u/gz2FcTX/x3wJBCiXFo3HVBqPLkSNFu
         f6BlTV+YyvBjios8ed8eJrGIcqO4Jo8gTCIn6QDe1N+J2RkAbWMpjUwmeVJBjdldNK5v
         pMTN8qIZAxTWfNyQkggrBzkqHUo/VQ0niwwE3aw8p2GsZUyftopdx4/ZNyzo6tsnpaJj
         uPaw==
X-Gm-Message-State: AOAM5329kAxJ/2WW5ZxfJdE9Ggm0WXXQo+KVId6mV32f3s/472NROdW8
        epeSEaqj8Pm46gTsAwi4pyE=
X-Google-Smtp-Source: ABdhPJxDfne3MCLW8lqMhu7PCzOhlGQaZEsCoVcwXwLFOwJ3RF3bW7wlGIFLr/60iGERVezoc8YbAQ==
X-Received: by 2002:a17:906:b306:: with SMTP id n6mr1432527ejz.473.1607509940268;
        Wed, 09 Dec 2020 02:32:20 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id b11sm1190073edk.15.2020.12.09.02.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 02:32:19 -0800 (PST)
Date:   Wed, 9 Dec 2020 12:32:18 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com
Subject: Re: [PATCH net-next] net: sja1105: simplify the return
 sja1105_cls_flower_stats()
Message-ID: <20201209103218.j3umjoorccer43j4@skbuf>
References: <20201209092504.20470-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209092504.20470-1-zhengyongjun3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 05:25:04PM +0800, Zheng Yongjun wrote:
> Simplify the return expression.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
