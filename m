Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B44D43C2C4
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 08:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbhJ0GTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 02:19:11 -0400
Received: from out2.migadu.com ([188.165.223.204]:47327 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229887AbhJ0GTJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 02:19:09 -0400
Message-ID: <a8dfcb9f-8d06-a240-c532-dad0ed724ecb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1635315403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ga70GwRUJrfAIkVrc4391j0HrqGrUqS+1GzD0PsqvcE=;
        b=sBi8QByIKGJ/JufW8ixAMJHVIh9ir8bTqt9meFxrurnjVvRusWsqGdJejMbRVBibgG4zVl
        PAoFlU+NBvDgMLYoS+a2yVSfXGZVK6EuSrvGECtaLtTJrduKnPEpVdIaBQgcvogKI/HeQ1
        p66mudfY75qSAoYjkjb5KRSB/Rvy+Io=
Date:   Wed, 27 Oct 2021 09:16:41 +0300
MIME-Version: 1.0
Subject: Re: [net-next 10/14] net/mlx5: Let user configure io_eq_size param
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jiri Pirko <jiri@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20211025205431.365080-1-saeed@kernel.org>
 <20211025205431.365080-11-saeed@kernel.org>
 <20211026080535.1793e18c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <91f1f7126508db9687e4a0754b5a6d1696d6994c.camel@nvidia.com>
 <20211026101635.7fc1097d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Gal Pressman <gal.pressman@linux.dev>
In-Reply-To: <20211026101635.7fc1097d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: gal.pressman@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/10/2021 20:16, Jakub Kicinski wrote:
> On Tue, 26 Oct 2021 15:54:28 +0000 Saeed Mahameed wrote:
>> On Tue, 2021-10-26 at 08:05 -0700, Jakub Kicinski wrote:
>>> On Mon, 25 Oct 2021 13:54:27 -0700 Saeed Mahameed wrote:  
>>>> From: Shay Drory <shayd@nvidia.com>
>>>>
>>>> Currently, each I/O EQ is taking 128KB of memory. This size
>>>> is not needed in all use cases, and is critical with large scale.
>>>> Hence, allow user to configure the size of I/O EQs.
>>>>
>>>> For example, to reduce I/O EQ size to 64, execute:
>>>> $ devlink resource set pci/0000:00:0b.0 path /io_eq_size/ size 64
>>>> $ devlink dev reload pci/0000:00:0b.0  
>>> This sort of config is needed by more drivers,
>>> we need a standard way of configuring this.
>> We had a debate internally about the same thing, Jiri and I thought
>> that EQ might be a ConnectX only thing (maybe some other vendors have
>> it) but it is not really popular
> I thought it's a RDMA thing. At least according to grep there's 
> a handful of non-MLX drivers which have eqs. Are these not actual
> event queues? (huawei/hinic, ibm/ehea, microsoft/mana, qlogic/qed)


These are indeed event queues in RDMA, but it's more of an
implementation detail in each driver, there's no EQ object definition in
the IB spec AFAIK.

