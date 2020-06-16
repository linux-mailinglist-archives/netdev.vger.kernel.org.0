Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5681FAB85
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 10:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgFPImm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 04:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbgFPImm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 04:42:42 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3581C05BD43
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 01:42:41 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id t21so13618921edr.12
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 01:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Ns3ALrq7vq0Xby5o6WWlFusxvEnhPfE1DCHASM4MEKA=;
        b=B5N0QJAGQijBUbiugWX8RSEDaTS0SDQRimBt+gaaUvX1Phr241NTL12bk5OIDZiRLB
         REVCwmzXEi6/x3wthPUOurd3/MctqzJij8qABtNWZjRJ5/niC77aw95nZUw3oBUwS57y
         OSh8bIX5/L5aqqt95LP/dc6uZWTq2W0kuD25pEfjJVQdmEwps+HunGullei9xIUpWCfe
         R6ip3fvc2E34FtuZ4TdSYV9tyzmSBtR5ICbzqCKnRMz7eozKQa1Dl8VNbQg9bWDMaSWo
         lcCfCTSydnwIvH368oTtX5fwy77M58sj6UPWZO0WfcaZBIN+dfVbWFn+XHxkdEdzEV5Q
         tUAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Ns3ALrq7vq0Xby5o6WWlFusxvEnhPfE1DCHASM4MEKA=;
        b=kWnG+44V7ufFEGXlDHPmjXSyIW/q73pbM3Tpf2G/rc+UfnTlzHOZ57wi5v31ZICDoW
         WlTNfMafF7j0X/FGmvLqLPtfNk7sjUXfqLPr1sxo/gMYqiYeCjUupjU3Qy0vsJ+bEXzW
         DySuT15+048g7IHZ2SZDEB7zW9YHOcUntv1DxpFcqnt6W0ScWg/9DE8BGfVmfaJDATze
         wn8yPYLr8BVmchs3DWPii981/2tqG+DDn1khv2J7vRQCk1w6m6kiltrAjjOk1YBJ2uAz
         Qa4g/Io5SzHZQMfuGOHyDz0BLB2pQXU+yXKIdKlXeCf/LKdyLkazfhY0RUhYHAVwEtbA
         +LGw==
X-Gm-Message-State: AOAM532w93hvM4X0epOCPk6Pa0s6hsSQ7j7fMovf0KgdUfl+HRrrQPKo
        /HUcKHv05OO/sRSvfyD8ozxKrg==
X-Google-Smtp-Source: ABdhPJzN2o4uFA6ecgjWZEOjRo135HN4vC/+V65pbb496qd9y9/pH2iAqB6dm4uw1g7mMRY2U5F+BQ==
X-Received: by 2002:a50:98c1:: with SMTP id j59mr1649935edb.120.1592296960574;
        Tue, 16 Jun 2020 01:42:40 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id p13sm9801073edx.69.2020.06.16.01.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 01:42:39 -0700 (PDT)
Date:   Tue, 16 Jun 2020 10:42:39 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Xidong Wang <wangxidong_97@163.com>
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: Re: [ovs-dev] [PATCH 1/1] openvswitch: fix infoleak in conntrack
Message-ID: <20200616084237.GA28981@netronome.com>
References: <1592273581-31338-1-git-send-email-wangxidong_97@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1592273581-31338-1-git-send-email-wangxidong_97@163.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 07:13:01PM -0700, Xidong Wang wrote:
> From: xidongwang <wangxidong_97@163.com>
> 
> The stack object “zone_limit” has 3 members. In function
> ovs_ct_limit_get_default_limit(), the member "count" is
> not initialized and sent out via “nla_put_nohdr”.

Hi Xidong,

thanks for your patch.

It appears that the patch is a fix. So I think that subject should be
targeted at the net tree and thus the subject should include
"[PATCH net]". (The other option being to target the net-next tree
in which case the subject should include "[PATCH net-next]".)

Also, as a fix it would be useful to include a fixes tag that references
the patch that introduced the problem. This is to facilitate backporting
to -stable branches of released kernels. In this case the following seems
appropriate.

Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")

> Signed-off-by: xidongwang <wangxidong_97@163.com>
> ---
>  net/openvswitch/conntrack.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> index 4340f25..1b7820a 100644
> --- a/net/openvswitch/conntrack.c
> +++ b/net/openvswitch/conntrack.c
> @@ -2020,6 +2020,7 @@ static int ovs_ct_limit_get_default_limit(struct ovs_ct_limit_info *info,
>  {
>  	struct ovs_zone_limit zone_limit;
>  	int err;

There should be a blank line here.

> +	memset(&zone_limit, 0, sizeof(zone_limit));

Moreover, initializing the entire structure to zero only to overwrite
most of its fields immediately below seems a bit inefficient.

Perhaps it would be better to just initialise count.

>  	zone_limit.zone_id = OVS_ZONE_LIMIT_DEFAULT_ZONE;
>  	zone_limit.limit = info->default_limit;
	zone_limit.count = 0;

> -- 
> 2.7.4
> 
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
