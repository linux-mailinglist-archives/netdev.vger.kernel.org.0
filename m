Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F01A4D5894
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 04:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345865AbiCKDBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 22:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345883AbiCKDBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 22:01:34 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0F91A8CA2
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 19:00:28 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id h5so5224345plf.7
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 19:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8Ji+Sz/InlU6NQ7/bE8a/j0QT0u2BBcoHxouEcw237Q=;
        b=1ZI8yU4UrELG2xrC/mfVd6A+FaeFF+xwtztLkZtCvmLCL9ZEErSZpHk7iQwh9qdQJj
         SUBcUc27Sn3R/NDBARB+reFk7UerEKN27Xn5YWdz6mz8Jkos8eGNMf+ibZAcuuIh5TM1
         p5deuroKIfLra3z9yBeBmKSt91D4QZ23PgzE84zPNcgGJZ4/off5QhP0PkuaSRnlVMhw
         inxMAToYVOeyAlvs043dpXiYqDF+T2B2necAj66KcoyJMwxg+owdBtezDI376bf51u4e
         xWC9bvDsuaTmpexOzT7M7beDXBJT7IR7F732Ylxj56jsBX0jM3y1RZnzT9o9LHQvHo+g
         xfdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8Ji+Sz/InlU6NQ7/bE8a/j0QT0u2BBcoHxouEcw237Q=;
        b=vsTtil54HsJaYWNNsscq8b1HAtPqBIz5cX5uNknaWCiXKLfyVrms3piR3gLr8hdzKx
         StuhkbB7V9GGf0RhDIBz+NhD4ZG/IFIoVrpoFPNpQOVw6gpn/PkMgq6DFdu3m/pJ28U2
         Xq1kWcKkjDxEiILkoPpLYw7t4Q8er6kDZ+UEvoQ7yunJkd4lfD1pUP9bzgTtnnWAOiOm
         3Z2G3we3RsMNBP3lF3jiQ/EhAIF/fnUPBvcygeC3VHNaZ3/azBPoNWuC54HBGD8oKeBR
         gYKzMIPWoupHJWbnOwQSLvs1pIRC79beXGsM1YKw0/Ik8e9hcawmcBmvqu64fjNo2lSc
         WaGg==
X-Gm-Message-State: AOAM531bfNXwJBZqchqYIQ/UBw4tOqVUXXXV/xwmvxCR5pdz/wShkS17
        8+mVUr1LeTl/AVb1ZkDf+iOjmQ==
X-Google-Smtp-Source: ABdhPJyVzrAMFLjoDnwq/ceXZU7fnb7H49S/WbDrtkMb1ng1xAfGPAuqFHWqw0NU4l1IITHvfuZHxA==
X-Received: by 2002:a17:90a:c504:b0:1bf:6d9f:65a6 with SMTP id k4-20020a17090ac50400b001bf6d9f65a6mr8653580pjt.204.1646967627714;
        Thu, 10 Mar 2022 19:00:27 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id u10-20020a6540ca000000b0037445e95c93sm6673005pgp.15.2022.03.10.19.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 19:00:27 -0800 (PST)
Date:   Thu, 10 Mar 2022 19:00:24 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] hv_netvsc: Add check for kvmalloc_array
Message-ID: <20220310190024.0eaa76b9@hermes.local>
In-Reply-To: <20220311024344.2037906-1-jiasheng@iscas.ac.cn>
References: <20220311024344.2037906-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Mar 2022 10:43:44 +0800
Jiasheng Jiang <jiasheng@iscas.ac.cn> wrote:

> +	if (!pcpu_sum) {
> +		for (j = 0; j < i; j++)
> +			data[j] = 0;
> +		return

Why is unrolled zero (memset) needed? The data area comes from
ethtool_get_stats and is already zeroed (vzalloc).


There does look like at TOCTOU error here with on the number of stats.
Code doesn't look hotplug safe.
Not sure, but that issue might have been raised during review.
