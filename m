Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9642BC66E
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 16:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbgKVPR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 10:17:27 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9418 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgKVPR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 10:17:26 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fba810c0000>; Sun, 22 Nov 2020 07:17:32 -0800
Received: from [172.27.12.158] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 22 Nov
 2020 15:17:14 +0000
Subject: Re: [PATCH mlx5-next 09/16] net/mlx5: Expose IP-in-IP TX and RX
 capability bits
To:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     Leon Romanovsky <leonro@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>
References: <20201120230339.651609-1-saeedm@nvidia.com>
 <20201120230339.651609-10-saeedm@nvidia.com>
 <20201121155852.4ca8eb68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Aya Levin <ayal@nvidia.com>
Message-ID: <7e783e5c-a4e1-bdc9-e5bb-73762f05ad19@nvidia.com>
Date:   Sun, 22 Nov 2020 17:17:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201121155852.4ca8eb68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606058252; bh=aP5BdeaYqwpKUvjSCf8F4Li6m7Y+ETdHbVthh38qMMU=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=jAGXcs37fWlJIYYofw3kBm24wbmsFrmQGibWqr9hvYWi8b+DRVMaArNkOMIOiKh8/
         343RulmWufnMBWQntLCnTCfrEQyhhVfXHOQ6WWPz8gy58zHuZ06C3l80ry/dqf9ylb
         YlKIVr/nqqWKornaAgXBlPn/eIhuDcFjZ3x48FBR5rO/2etOJK+Tn8D/WgWFfSoSsJ
         JuQy0XYbwfvhhMwKuyRedmlDCkjwUwDmDpbZR3ovOMnSzGaslNceAMZ1H8dyp+1Pbw
         9BeXQZ0y31drGrbbQvwTB7qvIYHv/QG5VelhkbO8GXB26taqX296rUvKvNw3aIGlbs
         rWBR28TkYobCA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/22/2020 1:58 AM, Jakub Kicinski wrote:
> On Fri, 20 Nov 2020 15:03:32 -0800 Saeed Mahameed wrote:
>> From: Aya Levin <ayal@nvidia.com>
>>
>> Expose FW indication that it supports stateless offloads for IP over IP
>> tunneled packets per direction. In some HW like ConnectX-4 IP-in-IP
>> support is not symmetric, it supports steering on the inner header but
>> it doesn't TX-Checksum and TSO. Add IP-in-IP capability per direction to
>> cover this case as well.
> 
> What's the use for the rx capability in Linux? We don't have an API to
> configure that AFAIK.
> 
Correct, the rx capability bit is used by the driver to allow flow 
steering on the inner header.
