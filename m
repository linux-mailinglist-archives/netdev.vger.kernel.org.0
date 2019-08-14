Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBCF8C9AD
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfHNCqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:46:37 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42770 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbfHNCqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 22:46:37 -0400
Received: by mail-qt1-f194.google.com with SMTP id t12so20064025qtp.9
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 19:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=pD/XpBOcxU6zmV0LLVzBEhXOXBom/NndH3aawH5g868=;
        b=IzzlmTyB3Xsgb8CSHmNFv3EZm3rd7s/+Rpz8uK8clVoBf/U3P301mjwFTXWDqj1oSM
         MQxMT8zWzlQhEBsElEoALqvNR+djrAIKRJ53nhPBVa5aeO26PnkJVrZgrXfbf8ebT6Kj
         r7qxLrrdPykTVPYutPYmHibq89a7LpC/Cl6EVfYmS3XrUeITn2zAbbnaM7MUJfmRf2S/
         ToYyAmhLTfC//ryy8k1z/E2YdvDMFN+uUV418XIAbOviazwxZEJsChBJjfMfbLEv8cHK
         mvOsjt/5WsQYjAATOc8GbVcqfUrdB74JHXDEQ4L9B/LfbRRto9pY3SEndaiir56Sb9rv
         Qbvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=pD/XpBOcxU6zmV0LLVzBEhXOXBom/NndH3aawH5g868=;
        b=rqh110bf1UhlrCt5zFscUnPIY+EiFSJu5XO5rXn8Y4jBzFtCOablVFYjogZ5JcNlPf
         pCh6xpfaKxlzmvIbDueycJQgUJ1S5M4FQUdv4MJ9beWdYrH3EukaBeNjmdNm24HFyIW/
         IXBhw1bz1+PViWklvsPm00DHoq0AGm3SW4coazv2zrcITeUn67e9j7qW4invVzCgizBD
         74HKV9I/qmSMm6iyVnBZGIlegWwK4VD8jBSohdLYDFs3bXGGwBq3emhdPryp4RyN79FB
         qUV8X3NquStHVTR3oznvsScusAL0Cj1ayRBL7eYalejZX9jfNOhh4KfAHFsF6NxvmDai
         ZgkA==
X-Gm-Message-State: APjAAAVFRLUWmQttGJPJjiOlsPr/O8R29DKTIfi61d8exWGmq+cLPWuL
        o/8MYDP05DJKe4+ILjmPxB32cg==
X-Google-Smtp-Source: APXvYqwZUhcYfqLZD1BmBDbDtrEp3VN4xaZXc5CMIUNdlUNrEwxJ99tUrtylVEq/hwrY8z7BcVtK5g==
X-Received: by 2002:ac8:688:: with SMTP id f8mr36243068qth.130.1565750796315;
        Tue, 13 Aug 2019 19:46:36 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t26sm61485262qtc.95.2019.08.13.19.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 19:46:36 -0700 (PDT)
Date:   Tue, 13 Aug 2019 19:46:25 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org (open list:MELLANOX ETHERNET DRIVER (mlx4_en)),
        linux-rdma@vger.kernel.org (open list:MELLANOX MLX4 core VPI driver),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH v2] net/mlx4_en: fix a memory leak bug
Message-ID: <20190813194625.565e02b8@cakuba.netronome.com>
In-Reply-To: <1565637095-7972-1-git-send-email-wenwen@cs.uga.edu>
References: <1565637095-7972-1-git-send-email-wenwen@cs.uga.edu>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Aug 2019 14:11:35 -0500, Wenwen Wang wrote:
> In mlx4_en_config_rss_steer(), 'rss_map->indir_qp' is allocated through
> kzalloc(). After that, mlx4_qp_alloc() is invoked to configure RSS
> indirection. However, if mlx4_qp_alloc() fails, the allocated
> 'rss_map->indir_qp' is not deallocated, leading to a memory leak bug.
> 
> To fix the above issue, add the 'qp_alloc_err' label to free
> 'rss_map->indir_qp'.
> 
> Fixes: 4931c6ef04b4 ("net/mlx4_en: Optimized single ring steering")
> Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>

Applied, thanks.
