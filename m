Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208B347D771
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 20:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345088AbhLVTKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 14:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbhLVTKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 14:10:23 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98ECC061574;
        Wed, 22 Dec 2021 11:10:23 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id v16so3087822pjn.1;
        Wed, 22 Dec 2021 11:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=eKU6zyGwfFlWxbGr0zjaI2Jp0eBbVcOiSC2CJkTaOTE=;
        b=Dm06F6KpB9vlkE1/bI5YrdbkaKpwoRSWgYbNI8t0dtKwQMlkYRbosl4uCOO+AL8ekC
         OySFEYwmO86R+WWDIuCh8sZeSAwp/qNhLhpBhsthJy1kE2/bKXAh7dVftPq5z8dkbNb7
         A6R5R0lWIsa9rDs4GY4naIVyRmUCQMbFLqnlITX8pUHtJAs8cnQJ27Xcp2JrLPpp7N30
         T8FsT/HBmEHD/oSnapyMQejbRjByqf/aD7aHKTNVVWkzDgbdRI/INkO0/JAikHkjvzoX
         GRkRHlJjia85eNMba6ZiIX/7OhFHr8lCeMz7VOyH6hrMwa5laxuuxoULPYwAQlDqd8uX
         Bw6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=eKU6zyGwfFlWxbGr0zjaI2Jp0eBbVcOiSC2CJkTaOTE=;
        b=RCst2hOqVocHISYE4PPmxzGRZOFrge0NgGhHdf+gr7Cv5JixNl2nuuU9xWEmrRrZ2s
         RFjaE+1wafK169xtAnr+m7hjEUnb7KAcgQTnvPPSlHqZJ83LsaRF4zvbaO1DAIxx20Ls
         T/FfGuPp4l/eb+BRrPKqJvZQ37Zc/NYfNUqVGgjuajMtZEB2HpInkiW0lEMTyqVJwVWm
         Vsj5olf7POaQ/2OcViodCE0d6QT+w63XSt+D6LnIPoQSXLthslVu7RBe8LUApTe4/Fty
         efStwEl9Ijwmq7+VrAnsbE+NeofhfEUl4sKrPFf2c0NzODMJUSc0cbHlSSegz11JV1zK
         /NeA==
X-Gm-Message-State: AOAM531SLUOI4sz71YaEQ2SiHs9FQPNNYUNeb5pcPKm0AiAuoygWNXML
        ZZ1IGRnjChOnR2408j/Rfz4=
X-Google-Smtp-Source: ABdhPJzVWmb+g3frFClLt26LPQfPUONF/Kzd+DPYmYJBH5aR5XiDJkFtcVxGF8B1lvLNhXMLvLZ7Eg==
X-Received: by 2002:a17:90a:f998:: with SMTP id cq24mr2814797pjb.64.1640200222984;
        Wed, 22 Dec 2021 11:10:22 -0800 (PST)
Received: from [10.2.59.154] (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r10sm3003224pgn.4.2021.12.22.11.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 11:10:22 -0800 (PST)
Message-ID: <2e62a8db2ee325bc46220ded69ec2938117a117e.camel@gmail.com>
Subject: Re: [PATCH] net/mlx5: DR, Fix NULL vs IS_ERR checking in 
 dr_domain_init_resources
From:   Saeed Mahameed <saeed.kernel@gmail.com>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 22 Dec 2021 11:10:20 -0800
In-Reply-To: <20211222065455.32573-1-linmq006@gmail.com>
References: <20211222065455.32573-1-linmq006@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-12-22 at 06:54 +0000, Miaoqian Lin wrote:
> The mlx5_get_uars_page() function  returns error pointers.
> Using IS_ERR() to check the return value to fix this.
> 
> Fixes: 4ec9e7b02697("net/mlx5: DR, Expose steering domain
> functionality")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>

Applied to net-mlx5.

Thanks.
