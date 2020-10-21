Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D333294A8E
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 11:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437554AbgJUJau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 05:30:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60198 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391228AbgJUJau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 05:30:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603272648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0YOkWFZXN56bmLxCkgjeVL0JUnQdBq3x8hLD0ctbYaI=;
        b=ZlzGJbUWc4LsLlzOGmM1ec+GpMS1lyiUDyAwdBK7ZE4QfjTqrdw5hjMrAI2tyvXaafL89J
        3iMsVR9UHa7xEO72keMv9PXfFR2zL79Eyo+S8jL7WrENx0q32IXO/BNQ1WHBxuezM1F2Rl
        D5J0jEV0p7Tud7eAROJfRXTrZiE1W+4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-8rvgGUSJNhedHQzBsgCKbA-1; Wed, 21 Oct 2020 05:30:46 -0400
X-MC-Unique: 8rvgGUSJNhedHQzBsgCKbA-1
Received: by mail-wr1-f72.google.com with SMTP id v5so1701020wrr.0
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 02:30:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0YOkWFZXN56bmLxCkgjeVL0JUnQdBq3x8hLD0ctbYaI=;
        b=IbL9/tt3D4O/jmtIUFbkrtUqNet0NaY1bc+v22hNkd1f1KybYaGrEwJd2QDDwcqfAY
         ubDlyKLRZjnC/n7g7BNdEJeOA7mdlexTcK15dBp3v3DgewxhPZcO+8tJ23Z+7t1lq0bt
         oeeT/U5LCa9w8RjxbYRX5oBacYaWx3EpXyghOEuvyIGNq9GJ6ms0Pw/UNiAtu1q6t3aj
         i25AtH/8RwaaWe3GuO1JRsae1i6WopcfZfg/0A3yp0FAdeNKVYg1DEvqaN19XqqWxZp3
         EZdm3finzYl1ioJi8LIcpLL6mOnPbNGgMFfUiN3ZVDYrGRxOYI0ZeoMU2zD1GobIkc0i
         F5pQ==
X-Gm-Message-State: AOAM531ePijVwDgNLelsntnh8tHBx3yldjLvqD8vIDro10+iMjhgUGpk
        WLNq4UNSQEPsgTT81N1dAr5G1s2gBcP39+xguTewZ2k4ci3Rjbdg5blM/7Wo3PHSN2AyFYTV+1i
        2cidvSyacaC8GhrNT
X-Received: by 2002:a1c:6302:: with SMTP id x2mr2655198wmb.121.1603272644603;
        Wed, 21 Oct 2020 02:30:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRCCYw1P8htWPgcPrY6nv7DEFO1FPyL3G3UgafOsugYy7AN6xEXopwDiFX+YvHhKEG2aQw1w==
X-Received: by 2002:a1c:6302:: with SMTP id x2mr2655182wmb.121.1603272644441;
        Wed, 21 Oct 2020 02:30:44 -0700 (PDT)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id j13sm2807551wru.86.2020.10.21.02.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 02:30:43 -0700 (PDT)
Date:   Wed, 21 Oct 2020 11:30:41 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Alexander Ovechkin <ovov@yandex-team.ru>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net v2] mpls: load mpls_gso after mpls_iptunnel
Message-ID: <20201021093041.GC3789@linux.home>
References: <20201020114333.26866-1-ovov@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020114333.26866-1-ovov@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 02:43:33PM +0300, Alexander Ovechkin wrote:
> mpls_iptunnel is used only for mpls encapsuation, and if encaplusated
> packet is larger than MTU we need mpls_gso for segmentation.
> 
> Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
> Acked-by: Dmitry Yakunin <zeil@yandex-team.ru>
> ---
>  net/mpls/mpls_iptunnel.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/mpls/mpls_iptunnel.c b/net/mpls/mpls_iptunnel.c
> index 2def85718d94..ef59e25dc482 100644
> --- a/net/mpls/mpls_iptunnel.c
> +++ b/net/mpls/mpls_iptunnel.c
> @@ -300,5 +300,6 @@ static void __exit mpls_iptunnel_exit(void)
>  module_exit(mpls_iptunnel_exit);
>  
>  MODULE_ALIAS_RTNL_LWT(MPLS);
> +MODULE_SOFTDEP("post: mpls_gso");
>  MODULE_DESCRIPTION("MultiProtocol Label Switching IP Tunnels");
>  MODULE_LICENSE("GPL v2");

Then CONFIG_MPLS_IPTUNNEL should probably select CONFIG_NET_MPLS_GSO.
Currently, one can build mpls_iptunnel.ko without mpls_gso.ko.

Also, MPLS encapsulation can also be done with act_mpls.ko. So this
module should probably have this softdep too (and the Kconfig
dependency).

