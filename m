Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4ED2F9033
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 03:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbhAQCXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 21:23:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:42912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727838AbhAQCXs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 21:23:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 548B7223E8;
        Sun, 17 Jan 2021 02:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610850187;
        bh=/cncSyIVbzimtICUtPhNWKsdONNPlXVuXcAWD+mC0NY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SUAzcnIbkbiYNhVM6b/DBXP2vYK+DXMysIbw12zOlTCJNkugT87wgnjQnhZe1UcKa
         phhqnq/PerpVHoaEjP+eM/10f12sa2wzdMtSx9WNIyFiF5tunfnv15ruqD/LSZaEln
         bKchb+k3jPKHseaRqcolSs8HGY+hXtUDWHVr5+7glHlyFlNdE7xQ10OVhP9+cg6B8t
         8EhElj1eimJKuMHsiWkHz9Rp6lkaaAeB2qCrEioipemn7Url7h2nGYo3o0PWKIMGH2
         VVrILI6yfz3NRvS8J+eDyAj64uVi/hgAa3xzeDaEUMV6iIybbCzxtVCufDmMIzxLJo
         yqbXztpVIr8nA==
Date:   Sat, 16 Jan 2021 18:23:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        Guangbin Huang <huangguangbin2@huawei.com>
Subject: Re: [PATCH net-next] net: hns3: debugfs add dump tm info of nodes,
 priority and qset
Message-ID: <20210116182306.65a268a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1610694569-43099-1-git-send-email-tanhuazhong@huawei.com>
References: <1610694569-43099-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jan 2021 15:09:29 +0800 Huazhong Tan wrote:
> From: Guangbin Huang <huangguangbin2@huawei.com>
> 
> To increase methods to dump more tm info, adds three debugfs commands
> to dump tm info of nodes, priority and qset. And a new tm file of debugfs
> is created for only dumping tm info.
> 
> Unlike previous debugfs commands, to dump each tm information, user needs
> to enter two commands now. The first command writes parameters to tm and
> the second command reads info from tm. For examples, to dump tm info of
> priority 0, user needs to enter follow two commands:
> 1. echo dump priority 0 > tm
> 2. cat tm
> 
> The reason for adding new tm file is because we accepted Jakub Kicinski's
> opinion as link https://lkml.org/lkml/2020/9/29/2101. And in order to
> avoid generating too many files, we implement write ops to allow user to
> input parameters.

Why are you trying to avoid generating too many files? How many files
would it be? What's the size of each dump/file?

> However, If there are two or more users concurrently write parameters to
> tm, parameters of the latest command will overwrite previous commands,
> this concurrency problem will confuse users, but now there is no good
> method to fix it.
