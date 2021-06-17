Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDD73AB9D6
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 18:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhFQQoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 12:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhFQQoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 12:44:08 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C99C061574;
        Thu, 17 Jun 2021 09:41:59 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id n20so4904424edv.8;
        Thu, 17 Jun 2021 09:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S/RmYi7Df+pYDaIS8rW4MBaEGE9Nms87HmOfi8Ktcms=;
        b=jZ5HX7gvG9C0GaBjO6BTExFYEsDZudzDUPA4nkr+gn9evWjECuS7ejyPtfAPjvA5U3
         98gP3dp338Zr9wljC+tj7+7mAqvukarAOCOJ5PPlKvBQ7xBfSO5ML8r2echufouvOT77
         UbqG+aPwln32nS2BkTvvDRl5dwQaDpK8k13ojRnrfkCj7G3LdhSlJKrgYmw3eMNaChrD
         KRBgDwS1nzUY+2lmlHQxJ4SHAlkYzYaSZTi3AXazMes4BpzGxUvNNdgSzhyQyl7RZYHK
         /CaWEVTc5v0VEvr0bNWfmAuJYFRzGw8jtgJ0DsXBDM6ISt9qyluvkYNMzYbJbYSwxyal
         O/KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S/RmYi7Df+pYDaIS8rW4MBaEGE9Nms87HmOfi8Ktcms=;
        b=M8NWVSE7iqGR2QsLTw+Nh0laqNt5MJYQROubo4eBNHxDp1/6Yd0hnwERiTu65LmRMP
         zRNKRaWAZE1D9fKFdYmtxfDAInrBz1lnZ0eGxQUB+yPWxF1zLfR8ZpefLItsdqYCNoQB
         jGq8v+qCylCNEyFkwQo/8P/F8VUA5ye/KB0trWOpaf9302F5SGS/jJbieoxEPl+w7LdB
         LMskiDq1HzJocUuevvJZsyE2B8m5dAAepCeylk6AcOy6J0HxClRJqfHpTvXqG+vNIf7E
         +hooM0PLuknZDbITfFTo1yChxqUra8FTTmyvKFjWV1gCGfO1T09O3Wdwh4YMBFcngF2p
         nQZw==
X-Gm-Message-State: AOAM530B1PPCYlTY5gjXAewDRaHB+VBS3dNr29tmNqH8W8zs35QZRoXS
        9rbCbTFDQ64/uZgpRefHGOg=
X-Google-Smtp-Source: ABdhPJzA8XsBYthG4Mvw9HreUxbiUzaaCp9z6jIWZuHi1nGCSUuQ4UYFb5z2fTwAuO+DhgFfNoiKcg==
X-Received: by 2002:a05:6402:4242:: with SMTP id g2mr7795877edb.350.1623948118265;
        Thu, 17 Jun 2021 09:41:58 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id e18sm4037148ejh.64.2021.06.17.09.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 09:41:57 -0700 (PDT)
Date:   Thu, 17 Jun 2021 19:41:55 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris Sukholitko <boris.sukholitko@broadcom.com>
Subject: Re: [PATCH net-next] net/sched: cls_flower: fix resetting of ether
 proto mask
Message-ID: <20210617164155.li3fct6ad45a6j7h@skbuf>
References: <20210617161435.8853-1-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617161435.8853-1-vadym.kochan@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 07:14:35PM +0300, Vadym Kochan wrote:
> In case of matching 'protocol' the rule does not work:
> 
>     tc filter add dev $DEV ingress prio 1 protocol $PROTO flower skip_sw action drop
> 
> so clear the ether proto mask only for CVLAN case.
> 
> The issue was observed by testing on Marvell Prestera Switchdev driver
> with recent 'flower' offloading feature.
> 
> Fixes: 0dca2c7404a9 ("net/sched: cls_flower: Remove match on n_proto")
> CC: Boris Sukholitko <boris.sukholitko@broadcom.com>
> Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> ---

You resent the patch very quickly, did you find out why Boris' patch was
working in the first place?
