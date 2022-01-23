Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4A8497567
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 20:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239753AbiAWT5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 14:57:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234957AbiAWT5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 14:57:46 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7507CC06173B;
        Sun, 23 Jan 2022 11:57:46 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id f5so17155322qtp.11;
        Sun, 23 Jan 2022 11:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vUBxUoo0e8G16QaWMdWu9QFYTFLGS+0ehY8WAD+BN28=;
        b=UGmommU6ZoC0S/JBVlhZvYrIDgZPcAa1UVMldu69+OUVlqjN/GRRQNq07y2VykwWng
         3OwXXRp3RepsuVS7pmbXTCoKqYFUpGd1FGUyUYlZ9kUwkVMYzQMVshkLdbU5xEjnIZJE
         97/dAjXtf/DZvB0uO0iI25yfZCQ4P9rDkna5tjPMvHPlhuBivWNt6LmGX33hvPjCPTMQ
         ZdIrOwilzxGt8T8lggcSI2pKLjf80D2TJ8sdKUXRMHYDb73VD66kp0SbE/oGMuE0GsE2
         SY7ZjItWctaonHBePFO/eFGK4BoHpSUu+quEmOyRYrl++VNNgaDzWc91RVYTzwC0BT+n
         WiBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vUBxUoo0e8G16QaWMdWu9QFYTFLGS+0ehY8WAD+BN28=;
        b=TfARsEUggyn3iv0fyG1+tdABcYbQIepDEX0IeyQ3tck+IgZlpa9fBADJB1Q1MpI2WL
         Z6pYW/wnZkwdm/tjccgk0HA0SIrUfmPrr6vZon8h4vB5UxlTAmfWkrwPjCSG+RKrX+O6
         HVTpqZj+49XOAToCuDzg9CRtJET0tkktuB15aPIaLnmLU8YRBOMoyvDEDf46sCbbc+Tp
         jdPQHdGBvSFilo1+nK45oLrbRdKk5YKhUgPsSTIxxEDvVc74uHp6xZ6xtGePLRqUmC+5
         S00u6R1xvBTRCp5UWeJSTrgtNYADQrLwcSHI5WjDheL0g+2f8VIhAhX7eyy0PRF8f8tr
         vhKQ==
X-Gm-Message-State: AOAM531Nh8w+wFQ2pgvPngDLnFZD29kbnCqtLmBqxy37/g+c3TLOLfJU
        10wJWZJOkQJSwwBwVC9jVX0=
X-Google-Smtp-Source: ABdhPJwVw1TX+Yob6QtHJ6Mqb0oIqdp/TuqrFris3bv+LUL4oUT69O9qdgISfZxTCJzioVx3caAKJA==
X-Received: by 2002:a05:622a:14a:: with SMTP id v10mr10395206qtw.446.1642967865549;
        Sun, 23 Jan 2022 11:57:45 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:4388:ab9b:beec:5dea])
        by smtp.gmail.com with ESMTPSA id y5sm1466588qkj.28.2022.01.23.11.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 11:57:45 -0800 (PST)
Date:   Sun, 23 Jan 2022 11:57:43 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     ycaibb <ycaibb@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] inet: missing lock releases in udp.c
Message-ID: <Ye2zN0R/R9uKEUNa@pop-os.localdomain>
References: <20220121031553.5342-1-ycaibb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121031553.5342-1-ycaibb@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 11:15:53AM +0800, ycaibb wrote:
> From: Ryan Cai <ycaibb@gmail.com>
> 
> In method udp_get_first, the lock hslot->lock is not released when afinfo->family == AF_UNSPEC || sk->sk_family == afinfo->family is true. This patch fixes the problem by adding the unlock statement.
> 

It should be unlocked by udp_seq_stop(). Do you see any real lockdep
warning or bug report?

Thanks.
