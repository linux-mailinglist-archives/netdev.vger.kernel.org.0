Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFEA0396CE2
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 07:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhFAFjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 01:39:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229477AbhFAFjB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 01:39:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C17C6128A;
        Tue,  1 Jun 2021 05:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622525832;
        bh=yO0eoa+2tzufXW5lRiGMzA2X6x9LWyVgEc+NjDK+5XE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QKjLhWAaO16ojkpXzgKdHgNHfksk9XqH9n4n0GNRh3rs7k9OjVXtNvS8buzqTEBok
         Bjo/EVTieImnQ3Laqf9HYzFIqtaNq+8xtLmY5pF+SfUNeD+P8n3vUv+W6tRCwf3QHZ
         1P9zu24L++C7o3ir5n2rLAF6RmYDg5ZDxGXgc1YVwAJfccFUX/ndMRejVj3zmDy7dh
         I2ZK85y9+pwUXySXmY04hJ+ig4/0paHc8uA8p8ZX4WJoyahPZ7V4o1Xxfki4eT7Ui+
         7XW2fbETXkUz0PXB+BPZDv94wOd4LVnt7NUpdk+5tkT80lw8az0eoQpfnJ0h5D769/
         b5+0E1RMjOqiw==
Date:   Mon, 31 May 2021 22:37:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     moyufeng <moyufeng@huawei.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Parav Pandit <parav@mellanox.com>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michal.lkml@markovi.net" <michal.lkml@markovi.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "lipeng (Y)" <lipeng321@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        <shenjian15@huawei.com>, <linyunsheng@huawei.com>,
        "chenhao (DY)" <chenhao288@hisilicon.com>,
        Jiaran Zhang <zhangjiaran@huawei.com>
Subject: Re: [RFC net-next 0/8] Introducing subdev bus and devlink extension
Message-ID: <20210531223711.19359b9a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <76785913-b1bf-f126-a41e-14cd0f922100@huawei.com>
References: <1551418672-12822-1-git-send-email-parav@mellanox.com>
        <20190301120358.7970f0ad@cakuba.netronome.com>
        <VI1PR0501MB227107F2EB29C7462DEE3637D1710@VI1PR0501MB2271.eurprd05.prod.outlook.com>
        <20190304174551.2300b7bc@cakuba.netronome.com>
        <VI1PR0501MB22718228FC8198C068EFC455D1720@VI1PR0501MB2271.eurprd05.prod.outlook.com>
        <76785913-b1bf-f126-a41e-14cd0f922100@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 May 2021 18:36:12 +0800 moyufeng wrote:
> Hi, Jiri & Jakub
> 
>     Generally, a devlink instance is created for each PF/VF. This
> facilitates the query and configuration of the settings of each
> function. But if some common objects, like the health status of
> the entire ASIC, the data read by those instances will be duplicate.
> 
>     So I wonder do I just need to apply a public devlink instance for the
> entire ASIC to avoid reading the same data? If so, then I can't set
> parameters for each function individually. Or is there a better suggestion
> to implement it?

I don't think there is a great way to solve this today. In my mind
devlink instances should be per ASIC, but I never had to solve this
problem for a multi-function ASIC. 

Can you assume all functions are in the same control domain? Can they
trust each other?
