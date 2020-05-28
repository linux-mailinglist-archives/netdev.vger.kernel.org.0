Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68AB61E6FC5
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437351AbgE1W40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437266AbgE1W4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 18:56:22 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2ABC08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:56:21 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id v15so199694qvr.8
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JNUrJnDB9JB89P+K5Rt00Idq1ajTR4TMl/O+a69zNew=;
        b=ar0GKJZqeENl3nQo81/14pARyJcB/kmUBAYHxIOIf2I16Dm3A26TY3BM0xKhviycLU
         vYuKlTIBt4CsgmyGaS2yd1gzwC9cY0ICrmu3eXtw+bcpTzGDgAyetFT9jZMEBwBIQdOS
         hAtguy15dlH6tKKET/hBQgfUX37x1YjnmwxY5Rtkf8YIBxLpa7KDtnN4Xsh8VmwD91MW
         e+nfa670+XtJ02ioCS9y5kcjBPqiv0cdDw5K+15i3o6I0zj6ASB7p0mWpFIKMiwsgVQV
         K1wljHxNGnpgdMe9QSdUAP0NG5vldrNyBBo7EyHZfjf5/b+vH4o9UaBqyQ0EREV9yuXj
         lUpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JNUrJnDB9JB89P+K5Rt00Idq1ajTR4TMl/O+a69zNew=;
        b=W0WIceMU1wvXmDfWuvV2RMWiPUuEJk3rLAAo3lF99nmW8RfsZVswbKLj160DybMeuk
         v2nlM8KMXLqdiE/sXe7Np8VlRHL2KwiODcCC6ecofAZWMKAYKRXqv6vlNg1Pt1pKJbGn
         0czE69JKvuilFk+mCEVA8D9X96fnZsBORVG2/l0o2ztMLjhnjMXJNyF5c/F1aLeMTuZv
         z97c9ls/cKQ6XYPZkAKRzPPb9MMYUMU9MLqQuTMvITvDXM/D4IrvN3DjkUVskHYGdwim
         W1khlMAyJJpGFrP0fUVHmxyBPDpr5+nfVIiJMxqhl8oJW5mOwz+Rnb7K2CEDLfqlRdEq
         ZoQQ==
X-Gm-Message-State: AOAM533+/SG3mWdD6Jpqy5NvCPoxiQdK9JZi2k4Qq0x0KBwtxUsSjaOY
        pFSqSYiwild1wBfadjoNieSk5C1VOGA=
X-Google-Smtp-Source: ABdhPJza+kU8p33ohAn1v1b6J8zP4Gi68+jR0brwJD+zc5HmvbtEVeJ1/tzStZQRj2m5uITWEBT7VA==
X-Received: by 2002:ad4:4a81:: with SMTP id h1mr5575162qvx.71.1590706581098;
        Thu, 28 May 2020 15:56:21 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:2840:9137:669d:d1e7? ([2601:282:803:7700:2840:9137:669d:d1e7])
        by smtp.googlemail.com with ESMTPSA id 66sm6483206qtg.84.2020.05.28.15.56.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 15:56:20 -0700 (PDT)
Subject: Re: [PATCH v2 bpf-next 5/5] selftest: Add tests for XDP programs in
 devmap entries
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
References: <20200528001423.58575-1-dsahern@kernel.org>
 <20200528001423.58575-6-dsahern@kernel.org>
 <CAEf4BzapqhtWOz666YN1m1wQd0pWJtjYFe4DrUEQpEgPX5UL9g@mail.gmail.com>
 <20200528122510.1c475484@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7046644a-165b-19f6-a339-8023544ccada@gmail.com>
Date:   Thu, 28 May 2020 16:56:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200528122510.1c475484@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/20 4:25 AM, Jesper Dangaard Brouer wrote:
> That said, you should use the new SEC(".maps") definitions, but you
> need to use some tricks to avoid a BTF-ID getting generated.  Let me
> help you with something that should work:
> 
> /* DEVMAP values */
> struct devmap_val {
> 	__u32 ifindex;   /* device index */
> };
> 
> struct {
> 	__uint(type, BPF_MAP_TYPE_DEVMAP);
> 	__uint(key_size, sizeof(u32));
> 	__uint(value_size, sizeof(struct devmap_val));
> 	__uint(max_entries, 4);
> } dm_ports SEC(".maps");
> 
> Notice by setting key_size and value_size, instead of the "__type",
> then a BTF-ID will be generated for this map.
> Normally with proper BTF it should look like:
> 
> struct {
> 	__uint(type, BPF_MAP_TYPE_DEVMAP);
> 	__type(key, u32);
> 	__type(value, struct devmap_val);
> 	__uint(max_entries, 4);
> } dm_ports_with_BTF SEC(".maps");
> 
> 

Thanks for the tip.

