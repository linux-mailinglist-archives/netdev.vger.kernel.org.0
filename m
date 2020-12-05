Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F972CF8F3
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 03:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgLECYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 21:24:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:33002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725300AbgLECYw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 21:24:52 -0500
Date:   Fri, 4 Dec 2020 18:24:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607135052;
        bh=S5R3xfPvRDcFw5tFqdUTYofPr0iRhfZlhXRxtQudGsw=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=hf0Fztzbb+Mz98kf3nhT5CMYzS7h4pta0zzmLlT10z2yF4Os+58dTUuUlI2MJmaAB
         MNvmZS4iK9fJZIWuE8LfdLH70sHg96eVR2qr+9nYFPf+7cF8JL4qH61LyZEoRIq17V
         9L8yDDOyzmWulpBlCwjU8ekBvkDHhf/ygpKg0dL4+wU8RjRjNziDccnPZ1MkcSMu5N
         te0mWmkvILEX/hMp4o93g/XlnUxf5n/56L2UU8F982S4qQA13Hfa/gzIiOdUue3tpK
         GZekeRGmf5bAR5cXCAZiVe+F9Ym+Q2D1fUauJWoCMn/xnKB21p4JqPlydkaY5HAXV0
         LegcBV6Xe9Xyw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>,
        <huangdaode@huawei.com>, Jian Shen <shenjian15@huawei.com>
Subject: Re: [PATCH net-next 2/3] net: hns3: add priv flags support to
 switch limit promisc mode
Message-ID: <20201204182411.1d2d73f3@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <1606997936-22166-3-git-send-email-tanhuazhong@huawei.com>
References: <1606997936-22166-1-git-send-email-tanhuazhong@huawei.com>
        <1606997936-22166-3-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Dec 2020 20:18:55 +0800 Huazhong Tan wrote:
> @@ -224,6 +224,7 @@ static int hclge_map_unmap_ring_to_vf_vector(struct hclge_vport *vport, bool en,
>  static int hclge_set_vf_promisc_mode(struct hclge_vport *vport,
>  				     struct hclge_mbx_vf_to_pf_cmd *req)
>  {
> +	struct hnae3_handle *handle = &vport->nic;
>  	bool en_bc = req->msg.en_bc ? true : false;
>  	bool en_uc = req->msg.en_uc ? true : false;
>  	bool en_mc = req->msg.en_mc ? true : false;

Please order variable lines longest to shortest.

> @@ -1154,6 +1158,8 @@ static int hclgevf_cmd_set_promisc_mode(struct hclgevf_dev *hdev,
>  	send_msg.en_bc = en_bc_pmc ? 1 : 0;
>  	send_msg.en_uc = en_uc_pmc ? 1 : 0;
>  	send_msg.en_mc = en_mc_pmc ? 1 : 0;
> +	send_msg.en_limit_promisc =
> +	test_bit(HNAE3_PFLAG_LIMIT_PROMISC_ENABLE, &handle->priv_flags) ? 1 : 0;

The continuation line should be indented more than the first line.

I suggest you rename HNAE3_PFLAG_LIMIT_PROMISC_ENABLE to
HNAE3_PFLAG_LIMIT_PROMISC, the _ENABLE doesn't add much 
to the meaning. That way the lines will get shorter.
