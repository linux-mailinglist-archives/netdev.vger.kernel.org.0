Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2118046DB7
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 04:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbfFOCMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 22:12:43 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42893 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbfFOCMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 22:12:43 -0400
Received: by mail-qk1-f196.google.com with SMTP id b18so2921978qkc.9
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 19:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=70GWEAQ/zIvFb13btevo8yQ10Sw33r3KUhoGywNNloo=;
        b=fHGl+m2lrHdFmsFWU4IvNgtXpmFrd5LHtQh0dzx0a+nKY7v+7C6tJN1pr1LeQNDrS3
         XGFa6lsno8Pc3Xn5NtAf28DawgtDMReBQklddYeoTWkEaxbEsSngWFt5UFqlyv9++1hN
         PskCtSKf7udf3RDPmMiiBpQVzV8RbbDNLBy+novLwOrIvY9JGByol8ljcbWB7Hx2rOvF
         OFElYl3GKnuT4yfk6hHlJl3rcO3N7M+AFchDu+MPZqGsy5krMetRqe0gSxP+aFZyq6zq
         pdtP8RVuIkrRHIJ+AChc/Uel2GLmb6Iml4HOXF7CD2dx2dRUr+S2c4Q3IyenJQR+Lu0X
         9New==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=70GWEAQ/zIvFb13btevo8yQ10Sw33r3KUhoGywNNloo=;
        b=fPGEZkd7o0KakAqYG3wacJ5Ev8R+ZmDUwQw8Nm9HWiaU3gMVerRerHVHVKRvAFMigB
         ngewk6eVdrpTLo/bq2u8nJlIcK2lvGLl7VzvvsivEIhmX7yZRwl9ACT9kDJwLewFBlpy
         6xcJ0iPjJctvA5I19wsDi9nKxEo1sLyhL+vBUqe/+RDFXffN89WLA66lKYt40VCpuEA/
         ww+M7Vjj+TKmpvxGjdj6sOybjrWoS4HOF6Lqayj0bwxcekMbWywJ553rvCpVbTHL5R63
         kgI2tW7YpXlPmjMh8D3pG75k9VU2xMDVf7wwniKTgBUssgH8F0q1rfsvxAmvaCqUtgU5
         0aDw==
X-Gm-Message-State: APjAAAWyeOsPzeFKTuhPaHBt7YxIo555FMMu1oD9u6LO5j5JJ35cv/Ij
        9H4auE7YFpNguVBjpK811WH21A==
X-Google-Smtp-Source: APXvYqwpXkXvvDfj8ISJEdaEC6oQtFSRPYV038G0N7iqkzFMi6nr1HqEg+BAsUoqkVs5tIl2/0affQ==
X-Received: by 2002:a37:66cb:: with SMTP id a194mr59367912qkc.312.1560564762005;
        Fri, 14 Jun 2019 19:12:42 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id k58sm3078498qtc.38.2019.06.14.19.12.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 19:12:41 -0700 (PDT)
Date:   Fri, 14 Jun 2019 19:12:36 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Subject: Re: [PATCH bpf-next v4 07/17] libbpf: Support drivers with
 non-combined channels
Message-ID: <20190614191236.2e498632@cakuba.netronome.com>
In-Reply-To: <f0d9e7cc-6266-a5d5-e371-dd355066b994@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
        <20190612155605.22450-8-maximmi@mellanox.com>
        <20190612132352.7ee27bf3@cakuba.netronome.com>
        <0afd3ef2-d0e3-192b-095e-0f8ae8e6fb5d@mellanox.com>
        <20190613110956.001ef81f@cakuba.netronome.com>
        <f0d9e7cc-6266-a5d5-e371-dd355066b994@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jun 2019 13:25:05 +0000, Maxim Mikityanskiy wrote:
> Imagine you have configured the NIC to have the maximum supported amount 
> of channels. Then your formula in ethtool.c returns some value. Exactly 
> the same value should also be returned from libbpf's 
> xsk_get_max_queues(). It's achieved by applying your formula directly to 
> max.

I'm just trying to limit people inventing their own interpretations 
of this API.  Broadcom for instance does something dumb with current
counts I think they return curr.combined = curr.rx, even though there
is only curr.combined rings...

You will over allocate space for all NICs with return both combined and
non-combined counts.  But that's not a huge deal, not worth arguing about.
Moving on..
