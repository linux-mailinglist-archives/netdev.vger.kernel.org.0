Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473B42F773F
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 12:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbhAOLLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 06:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbhAOLLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 06:11:31 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFE3C061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 03:10:50 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id r12so1368454ejb.9
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 03:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D6tLOy/JmvviYCR2OlAuIlfQsz4EPra/tBDRSdmg7h8=;
        b=oQoKth1NdBbfR6QarwLR1xtoL835FCZhy2BIG909N4ZPU9HJ1ccJHVxCNWiIHdMKkI
         DWFtBuidrWnUWhZeBx9duJfuNPPNZRSDBDW/UI/88hVvcECzKzRV3v2zAdqMxHkiF8g1
         ws9q4yi2kp6EotbkJ/i5gDFjdNFY1IVIWIBChYHvHi9YEi1Xus7IUTutBEx5gxEa+rfe
         +hXdGKiIa4K5k3LpJHfi3CJGQEJKtHZt4jLWPMbWXkO8fIhYtNTGaa7P/wmJH4y31VjT
         afJKbFFx4q5QANASADwIkmPqUMKZ2yCwrpqerpMi5RtCWgNtIhhiukVO8vGSuRaZJkhJ
         d4kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D6tLOy/JmvviYCR2OlAuIlfQsz4EPra/tBDRSdmg7h8=;
        b=ojH/d4LqxUw9vHXil126eBJK0A3HO/MSpLu1gs+F1oms71qq95TgFWoHk7y0qpx0+T
         h54I43MlT9YW3CABesxE8bSy0ZF6U4p+T4ag0rWT/EvtHxiQt7Wkibvvf2TCRp5clIZs
         UJRJc7jcugfHrbHIWYiPGItFGSPWPtIneta2mBmUHx1A4uDSphQgt8wYbH5/4lsnDn8C
         Mj50LGsm/rUs1rOIx2xqYs33UFqwIgT2r1YUGcOKz4F3n+Z4+LRbrAeA+duKoXwr/E39
         ffoE1u/7K/ZE4BEgdgWPU5IBLei/BiMiD1eYx7IcKQGRGoTb7Q9+cnS1dl1Wb/YdrbPQ
         fenQ==
X-Gm-Message-State: AOAM533D8eJyLPDfcedQbqYp8CqBpLjSZXlTiUY/bWmk499VW/wtUoLW
        N9bQy7LOl5OrblYPl81SoKo=
X-Google-Smtp-Source: ABdhPJzkv1S773swcsRnQeaSGM5QzVqxZlcQ7KdNf9qI3zWe6MYdsNqJAzN5XCTzsnxjDKu0Ha1yQQ==
X-Received: by 2002:a17:906:3f8d:: with SMTP id b13mr8263845ejj.464.1610709049466;
        Fri, 15 Jan 2021 03:10:49 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id i18sm3440338edt.68.2021.01.15.03.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 03:10:48 -0800 (PST)
Date:   Fri, 15 Jan 2021 13:10:47 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: dsa: mv88e6xxx: Provide dummy
 implementations for trunk setters
Message-ID: <20210115111047.iahmq7wrmh4esbsm@skbuf>
References: <20210115105834.559-1-tobias@waldekranz.com>
 <20210115105834.559-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115105834.559-2-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 11:58:33AM +0100, Tobias Waldekranz wrote:
> Support for Global 2 registers is build-time optional. In the case
> where it was not enabled the build would fail as no "dummy"
> implementation of these functions was available.
> 
> Fixes: 57e661aae6a8 ("net: dsa: mv88e6xxx: Link aggregation support")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>
