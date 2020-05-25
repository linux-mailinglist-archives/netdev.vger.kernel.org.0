Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FF71E106E
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 16:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403997AbgEYOYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 10:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403993AbgEYOYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 10:24:41 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E30AC05BD43
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 07:24:41 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id l1so13848034qtp.6
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 07:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gY2b3G7zzjaeKWiOVEf3qZyrUuVH0WOnEyfFY0mYKfM=;
        b=kRFjBeRVtl4XXuqRo69Tnsh3px6MA4AgFQ80oMaivnNZ3++fnmSBpDPCDcsQYLJlQl
         SpBCv4YVJGxAklg1ZojSuaM4mZOruB6TxvH2Jce/Fy5+3LwKNCN8wQVb6PI8qMBeCaOU
         bm1WmgF1gXUdSC7VgMx/P1sOTImVWw8h5LGztIbHDNDFwrYPcJi5c1noXj2i2sKQkGgS
         ZYMrBZWFCSDPmlEBP/slxYiC/zgVXsFuxi0GJFxGp+KhByKWtiR8RAcK26VFVIJBk2Sp
         0DWSsNcoCew1Dq463++bnKYBgWyTH14f41qkPWNQsroUHtlS/1SSE5gjNkoicvL/LW56
         2nww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gY2b3G7zzjaeKWiOVEf3qZyrUuVH0WOnEyfFY0mYKfM=;
        b=P5CuE8Aa/4kGN3f/xq2xxom/YNjs/eTKvK/axdw0yGSSZNYb1afcRlHjAsICyMDY+J
         RpRJcrWoB6gl7qnuTIiZuE5zeNKGVz8eQ9w0j9Ph4vATfXmTx7MpB+4G/cgIe41Iddwx
         KBaKlHIVuiKl+zWgMNoQU1A9pZKrac3TYLPpmsVRiIbDqi0ruCoh9QU1bJMowLIgLLMr
         k08mFl83Hpj6h6rhKtHQDwnExnQWPX/BiCILHkV61LMybIBlCP0gfrY2FM68li7xczX7
         A9e1CRODJD+cOI8Mbwg5kOSPf5bDqhyF3QsCHtH/K4az8jX/b7IzEy3YZ5lZ/uytG+CK
         UZrw==
X-Gm-Message-State: AOAM532uozvP1txC8nUISbWLK7wbWprdOVkpejQFbW+OfLVPqnlvmEtz
        6rJW2QVS1sDG96DrQaIOrPo7MA==
X-Google-Smtp-Source: ABdhPJwQHxbhaiXBRTUEChZJz+ZbZk+SOiPrl37fqQicXJJQDf/qkPYeFHi/XJDU4T/KEsoDMu57LA==
X-Received: by 2002:ac8:326d:: with SMTP id y42mr28154227qta.243.1590416680466;
        Mon, 25 May 2020 07:24:40 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id v1sm11464263qkb.19.2020.05.25.07.24.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 May 2020 07:24:39 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jdE1v-0005Ro-Do; Mon, 25 May 2020 11:24:39 -0300
Date:   Mon, 25 May 2020 11:24:39 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Maor Gottlieb <maorg@mellanox.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH mlx5-next 01/14] net/mlx5: Export resource dump interface
Message-ID: <20200525142439.GA20904@ziepe.ca>
References: <20200513095034.208385-1-leon@kernel.org>
 <20200513095034.208385-2-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513095034.208385-2-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 12:50:21PM +0300, Leon Romanovsky wrote:
> From: Maor Gottlieb <maorg@mellanox.com>
> 
> Export some of the resource dump API, so it could be
> used by the mlx5_ib driver as well.

This description doesn't really match the patch, is this other stuff
dead code?

Jason
