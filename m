Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 510E3FBE3C
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 04:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfKNDQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 22:16:15 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34639 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbfKNDQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 22:16:15 -0500
Received: by mail-pf1-f194.google.com with SMTP id n13so3126803pff.1
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 19:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=q79DaP1fOoolvLxoAnlS8yt+lWkaDbOcHhAYIQsFJLE=;
        b=xL4olkQUydVzoxcA3r42/uWdgWf/DqrgZcwX/qsbHxmo+bQPlQQgcJxt8eZmuSjGUZ
         dhuAz6AtaA9GJuS0uYEOijkov+ezv7IiVsglsvA3APdDWxNBaRc/sIfkPzmCgf7AmJP8
         Xjzw72kUXwMsOoEZrPEM9TcGa5XH9ajGhGEVcvQmLbxPh+grv4qMnnHYvRxl+nr6dCH4
         QNZ6VNWlz5iTL96JoTeCA451YbGEOk/97BiK5x+npC3SRkd2jtrNfcCE/B5C5gsFkz4O
         IhY9NILulIIeS2OXfuMKfD82UvAInEcL2jDBvrTxrtwEaiEi7cOHsWCy9KgOl8/pbzVA
         89hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=q79DaP1fOoolvLxoAnlS8yt+lWkaDbOcHhAYIQsFJLE=;
        b=cP5k3t8LHpSFIVmG1nM1udRgdjvGNuZnrgxLHnscB+ipyD8d7ltdd1+kVqdRr6a/ia
         hiDfPuTzm1TxVF5GcvTU6ZBVR3+AOKzuw7iJVNeDIlXYtG38rKbgOTHgYDUYf7yiIAOe
         t1QcJ4ecruMtaYwWCvObtGHDmFeSE7+4+bOS5kW/7yg5+35f2UuTP1spF1BiMByPFjfK
         Nk08603dz4k4ZvvnsGwTP3PoICz8ZeKPcpnKGqp38pAG0s6O3jHnUchC79h2DWLLsS4H
         eFpuZoWniGagCzzjaq8MQo0oSGECPsRoRzukBNaR6ZqcT58bWvRHyujS6QFnpN28LEsB
         XFiQ==
X-Gm-Message-State: APjAAAUpE1AVZ4xUGByRvx6gZ7ATItVNGcJQVo7dkQ3c+3tXEd06Drub
        ESbptklA1a+WWEbWrHrmw5XenONy7to=
X-Google-Smtp-Source: APXvYqy3QZqhMtUR0bon8k9Px6BVrb3ntk96HWPu2Xigldpdvd5nMJfG9EKkz8hX3m0HO7ZAt3WHkg==
X-Received: by 2002:a65:628f:: with SMTP id f15mr6406113pgv.91.1573701373151;
        Wed, 13 Nov 2019 19:16:13 -0800 (PST)
Received: from cakuba (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id b9sm4627737pfp.77.2019.11.13.19.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 19:16:13 -0800 (PST)
Date:   Wed, 13 Nov 2019 19:16:10 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next 2/2] cxgb4: add TC-MATCHALL classifier ingress
 offload
Message-ID: <20191113191610.0974298f@cakuba>
In-Reply-To: <cbbe1b8e3d4062e329bb17f8521a6fa6de543091.1573656040.git.rahul.lakkireddy@chelsio.com>
References: <cover.1573656040.git.rahul.lakkireddy@chelsio.com>
        <cbbe1b8e3d4062e329bb17f8521a6fa6de543091.1573656040.git.rahul.lakkireddy@chelsio.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Nov 2019 20:09:21 +0530, Rahul Lakkireddy wrote:
> +static int cxgb4_matchall_alloc_filter(struct net_device *dev,
> +				       struct tc_cls_matchall_offload *cls)
> +{
> +	struct cxgb4_tc_port_matchall *tc_port_matchall;
> +	struct port_info *pi = netdev2pinfo(dev);
> +	struct adapter *adap = netdev2adap(dev);
> +	struct ch_filter_specification *fs;
> +	int ret, fidx;
> +
> +	/* Since the rules with lower indices have higher priority, place
> +	 * MATCHALL rule at the highest free index of the TCAM because
> +	 * MATCHALL is usually not a high priority filter and is generally
> +	 * used as a last rule, if all other rules fail.
> +	 */

The rule ordering in HW must match the ordering in the kernel.

> +	fidx = cxgb4_get_last_free_ftid(dev);
> +	if (fidx < 0)
> +		return -ENOMEM;

