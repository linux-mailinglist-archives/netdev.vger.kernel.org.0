Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87FB74983FA
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243238AbiAXQAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238633AbiAXQAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 11:00:20 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CFCC06173D;
        Mon, 24 Jan 2022 08:00:20 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id jx6so22705274ejb.0;
        Mon, 24 Jan 2022 08:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K0FoJSMd0q5aAHDINIfD95Kn6kjRMdod5UGu62F45TQ=;
        b=ddFaZQcZLyWjCWQGGH/BNG3Wowb100D8yGgOJNZw4nQceUKP6yWkRV+y8nIOnc8DQW
         HiQmjE3aaPJ8ezImjw61GDFZ+W8/aF8bLxzAY3757Z7C8S3aEZY/rov/sj0NKb3mjEKy
         Y/FzMgXe7myvinWtCBcMhja6kB9JZygbudngMoz+2p9ON+Gj2MbLI6uDUZCCzjO1hYL0
         KZdNmP2x5zn87OQjC0nq3A3Yah+AsfRDCNp70bqt2WfeF/ZyTMIjQD7YJwouth3ARepz
         s1paO4FpS0n1iAR19OrNSuQbxkOmtBLAZtvXycDHA/heIaW8A6Vc8yUUK1iShhf23ExS
         /A9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K0FoJSMd0q5aAHDINIfD95Kn6kjRMdod5UGu62F45TQ=;
        b=ZrWdAZn9WItktqxytbCYUcVxfHLIVfI290xL7RV3TTapLwyCLj3k33ASXsLVUF985G
         HR6G3Vpz4t7bkwhU4pq0wh6EQpbniB3R+zN2jOyYwDRkgnr4n6k3dFb01ULZ3GM+0Aah
         n2h0e5biH7f+acXAp2UcwUx2Oon4GkgYhZ9409bo2IA10Ku1ZRQQklGAkBe4A+ctAn5l
         wHdDrugOSrmXfIpcgAWIc5rLcS9S3wwWu+G8fdpCrYSjQJfrnI7sjke9sBN63UxEWh4P
         p532dLWQxPR3zmkmIZr3DZeK19Hq8ovCe+Wi4mKkE14EBLW/bAOrphiUXEdkff7ROttx
         LY1A==
X-Gm-Message-State: AOAM533G55s4GzsvN8NatInEMAV8rWFSsqECGZSDjHEjw0RmJdsTh7B2
        0GQf7QGkZB+WJN9ltd2FT5p0zsOQS8Y=
X-Google-Smtp-Source: ABdhPJzn/arVtr+v4DnT6Cmfhs0yLjvy1cjfSSNPLlo5Nzz+at0qIubNiphQW7cDxWZ5Du7WQxjjwA==
X-Received: by 2002:a17:907:6d94:: with SMTP id sb20mr4189415ejc.139.1643040018289;
        Mon, 24 Jan 2022 08:00:18 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id d6sm4616801eds.25.2022.01.24.08.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 08:00:17 -0800 (PST)
Date:   Mon, 24 Jan 2022 18:00:16 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 03/16] net: dsa: tag_qca: convert to FIELD macro
Message-ID: <20220124160016.ygy37uf2tefagm2c@skbuf>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-4-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220123013337.20945-4-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 23, 2022 at 02:33:24AM +0100, Ansuel Smith wrote:
> Convert driver to FIELD macro to drop redundant define.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
