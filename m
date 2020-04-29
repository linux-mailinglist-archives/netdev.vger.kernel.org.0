Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258F61BD3CC
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 06:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgD2Ejp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 00:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726305AbgD2Ejp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 00:39:45 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06982C03C1AC;
        Tue, 28 Apr 2020 21:39:44 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id u22so378687plq.12;
        Tue, 28 Apr 2020 21:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lyFtnZQVTaf898sv8REwcIZmGQU2Ez1Yvu0JPQ5LadE=;
        b=jkEqFFc34LoLBwNtM6M3/UbuZIkji5fmP6q8aSToKhnQEmnIZmqOsRteo9jBAKthDF
         fX8/PVyGJsXBvz1ozGMSOHpk8MBzBPWSqDxRzavWYPCb1VZ7rjZE7skVS5nKAnQw0MRi
         xizcX6H6YgskGKPW9lJMmRECNdE6y60jgnrdk4yA7EMzZ4LMZf2Iec44XlPO9HLxQ9Z2
         TxJPv3iKcM6J6RBbKUTMeaJIgX6TgY+qNRL611S9pMnb94mmid4bWzqVQJfWZtNI4AaQ
         CHOZ1/qIjY3O94oj1KHgm0TaW+AyUbK7magFLY4M3VCVcKLqxcv1UFghETCzXytgM6ON
         vPLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lyFtnZQVTaf898sv8REwcIZmGQU2Ez1Yvu0JPQ5LadE=;
        b=uAQv6G+c2K3laIeYwgQiK6DGMhAl3IY/2T9CJWyFc65Re78R7xA1FAr5OVwYXkG5hq
         mpemLdsC7HW262o40FI5f636JSs6mK58v6W6k4FzYhsiVAeXWqChUQCu3HPtQFsiydX/
         VAehGYSsNSg5qP40qq/e2LFNGPgNn9jcou+FD0LPbHm1NauaNPu5ZvMy0/vioy+/NWDU
         GEUpLH2VPFogk6Lkt1OWsVvLg+fsv2dhIHjZCyP3YdOw0SZelbcxjJKRutCMDhPDOtk/
         uXh/z/CwFBUoneu35AKSbUt5eEQMIPpCMDOUyzrbaeOTXyJa7mn7/xTUvudBxPlENItz
         QY+g==
X-Gm-Message-State: AGi0Puav8BwahY3pU5RS1mzKyHl/AGskS1ZCVZI9rq0bSK/w4VNfW5O+
        5tcEW1iM3boZ57wc2kWZ9MyQpbtM
X-Google-Smtp-Source: APiQypK9lwddneoW+HGaPzpUGieWJMiouKLQh6DezVsCQ3vuNinC/MWtzZ/Q1iizdXq6m1so1eVpTQ==
X-Received: by 2002:a17:90a:d808:: with SMTP id a8mr990509pjv.6.1588135183561;
        Tue, 28 Apr 2020 21:39:43 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:562d])
        by smtp.gmail.com with ESMTPSA id u5sm8237047pgi.70.2020.04.28.21.39.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 21:39:42 -0700 (PDT)
Date:   Tue, 28 Apr 2020 21:39:40 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kernel-team@fb.com
Subject: Re: [PATCH v7 bpf-next 1/3] bpf: sharing bpf runtime stats with
 BPF_ENABLE_STATS
Message-ID: <20200429043940.6dirzvgh26o2hrul@ast-mbp.dhcp.thefacebook.com>
References: <20200429035841.3959159-1-songliubraving@fb.com>
 <20200429035841.3959159-2-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429035841.3959159-2-songliubraving@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 08:58:39PM -0700, Song Liu wrote:
> +
> +static int bpf_enable_stats(union bpf_attr *attr)
> +{

CHECK_ATTR() is missing which makes it non-extensible.

> +	switch (attr->enable_stats.type) {
> +	case BPF_STATS_RUNTIME_CNT:
> +		return bpf_enable_runtime_stats();
> +	default:
> +		break;
> +	}
> +	return -EINVAL;
> +}
