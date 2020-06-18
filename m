Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16ED91FDA43
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 02:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgFRAa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 20:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726815AbgFRAa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 20:30:28 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287F0C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 17:30:27 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id q2so1772998wrv.8
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 17:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NuPoYD3XxKVNo0OyT5NpLyy3dAMoBD1dCL0z8TCxG5o=;
        b=L9zMwdcGfgwZ7tiSwewXbN6/aNuBNH6qlWxaNTt97O1IP5G4LD45mBuBXVAf8AbJvQ
         WxrzBmAaZb4hsSPrlsBq3v+BVmrP234GslGDj1pjomgO3J0v33rXjncVkFqamy93OdkW
         HRP+dSEaJlDostVWppFvTHE5c121ID030S84cMMdSpP7va1IKpHRcv6ooR/QeWXAOGSY
         hPfA8ohpd+SuSKnI3t66HA2ci1CO2rl6LurVb507sn2H10QrfvET+ddjDjr5LYXw+TAi
         DSxKJKBikdve024zaEXo7CgSz0JPeLC9pT4Xy2aGwhiMw7rFww6utOKycAvPdzELB6Sa
         frsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NuPoYD3XxKVNo0OyT5NpLyy3dAMoBD1dCL0z8TCxG5o=;
        b=Mwtcu/6Jo2Lwbe3T3EIuLUnP0m77yOfSN1s9T21qUq/1Nq4en49fC02uOh1SyDW7bJ
         fLVm563dlhNiIiXefTSyULQpCPP0YOVQ9PnEEvqs4qsju3iJS8LRxhohXDAjtwP2BxxS
         XPiL7lvT1EEZmWZi65WX6TzCwHqNoiahV4lAWpQD9l1G3+fI3IHTdYtZKtITAdWnL9+B
         yu1N8G7eLeS0McH/FxeDt6mu55YK+Nnra1CTDcGO96QvpeVbE8tnA8Dg7S/nWZYpBT3g
         G8clmoapx42K/5sBBX7VK7vrkZWDkNjlidC3MhW8kHe1jjZI5yDLPnke16N7BV8xFwZU
         1G6g==
X-Gm-Message-State: AOAM531myGlhpqElmA4Dk8I39dQ2hA64voLf6fLQ854n3G/UTw7c9xqg
        hH3rnmHAcXCRlP892YKGs/3Yiw==
X-Google-Smtp-Source: ABdhPJwrxpWQ8wLaTXlnCVKPT2jX8P8XLXg4e/6MRhnCxRpaP19dQ7MB1jlUARLIYtv7RcWunKCbOQ==
X-Received: by 2002:a5d:49c3:: with SMTP id t3mr1658155wrs.379.1592440225910;
        Wed, 17 Jun 2020 17:30:25 -0700 (PDT)
Received: from [192.168.1.10] ([194.53.184.244])
        by smtp.gmail.com with ESMTPSA id d24sm1346382wmb.45.2020.06.17.17.30.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 17:30:25 -0700 (PDT)
Subject: Re: [PATCH bpf-next 4/9] tools/bpftool: move map/prog parsing logic
 into common
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Hao Luo <haoluo@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Song Liu <songliubraving@fb.com>
References: <20200617161832.1438371-1-andriin@fb.com>
 <20200617161832.1438371-5-andriin@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <56f8d71d-4cd7-e022-4176-7481a68bc040@isovalent.com>
Date:   Thu, 18 Jun 2020 01:30:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200617161832.1438371-5-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-06-17 09:18 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> Move functions that parse map and prog by id/tag/name/etc outside of
> map.c/prog.c, respectively. These functions are used outside of those files
> and are generic enough to be in common. This also makes heavy-weight map.c and
> prog.c more decoupled from the rest of bpftool files and facilitates more
> lightweight bootstrap bpftool variant.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Reviewed-by: Quentin Monnet <quentin@isovalent.com>

