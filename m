Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712BE30E8F0
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbhBDAvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:51:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:38794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233392AbhBDAvU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:51:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25D1B64F4C;
        Thu,  4 Feb 2021 00:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612399840;
        bh=/jwmhOkkvsV+5tbBXO7Yw4MNLAkV97R3mNisDJKr+P0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i9bV0LMNbbBFh+OI6yX0KUfGD4OwDY6uzXHIg2Qk6SQc41ACfikQXxci6AMe+e130
         Sn9ocyOxRRjIqZhDhBx4asDa+xKB9nn8k5x0gQJhMslxrdSLb0eezMxHzWNx0MRlOM
         SPRB8mrQetpcTGNWqNsONky68g7hrVM6v3uMfrXstlWSH0BcJqhDOas/drkwNGDTK3
         Z5qwJSWFfLJW57AOWeIWKSwSU8udpBhdY28EPESu+XKFNVdTKP/vnbgfzbxnpLLscn
         MBUWRd6yTC+8VuJU+OXd6CNX2qRlQf++XwQGTfqtd3iBxIT7oxBDE0jBDo0vvpQlnX
         VCCP/rA8goD6Q==
Date:   Wed, 3 Feb 2021 16:50:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        Guangbin Huang <huangguangbin2@huawei.com>
Subject: Re: [PATCH net-next 2/7] net: hns3: RSS indirection table and key
 use device specifications
Message-ID: <20210203165039.3bf2784d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1612269593-18691-3-git-send-email-tanhuazhong@huawei.com>
References: <1612269593-18691-1-git-send-email-tanhuazhong@huawei.com>
        <1612269593-18691-3-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Feb 2021 20:39:48 +0800 Huazhong Tan wrote:
>  struct hclgevf_rss_cfg {
> -	u8  rss_hash_key[HCLGEVF_RSS_KEY_SIZE]; /* user configured hash keys */
> +	/* user configured hash keys */
> +	u8  rss_hash_key[HCLGEVF_RSS_KEY_SIZE_MAX];
>  	u32 hash_algo;
>  	u32 rss_size;
>  	u8 hw_tc_map;
> -	u8  rss_indirection_tbl[HCLGEVF_RSS_IND_TBL_SIZE]; /* shadow table */
> +	/* shadow table */
> +	u8  rss_indirection_tbl[HCLGEVF_RSS_IND_TBL_SIZE_MAX];
>  	struct hclgevf_rss_tuple_cfg rss_tuple_sets;
>  };

What if the table sizes supported by the device grow beyond the
.._SIZE_MAX constants? Are you handling that case?
