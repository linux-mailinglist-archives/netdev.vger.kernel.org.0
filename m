Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2F7339120
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbhCLPVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:21:14 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:58383 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbhCLPVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 10:21:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1615562471; x=1647098471;
  h=to:cc:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding:subject;
  bh=fXChBcwn3i8+I8FRgnwJ2UacpPT+Q/2Jk1d/TX9xTNU=;
  b=L0qZH24LODcV0+LiANRVDuSW6Nh/cAwob0GWznYD2R2okmjlIj+eSWmW
   anaJJlIalLJTFxycJgj98wwlhWAyst0Z7a/uH8XdQTyXo/ZXdcU0GrBLa
   sx7c39Nrhi4SP5iUag2WdRHaHVA78zb0rt55SY3pi/y+Gz6lh8P1O7gJW
   A=;
IronPort-HdrOrdr: A9a23:jABeqaDMkSulc2PlHekZ55DYdL4zR+YMi2QD/UoZc20zTuWzkc
 eykPMHkSLlkTp5YgBHpfmsGomlBUnd+5l8/JULMd6ZNjXOlWO0IOhZnOjf6hL6HSmWzI5g/I
 NBV4Q7N9HqF1h9iq/BgTWQN9o72tGI/OSJqI7lvhVQZDpnYa1h8At1YzzzeiZLbTNbDpk0Ho
 f03LsjmxOcfx0sH6CGL0hAceyGg9HQjprpbVo9GhY75GC14Q+A2frVFR6X2xtbfhFu5fMZ8W
 bDmxHk/anLiZyG4y6Z+WnU4ZFb3OHk18IGPsqRkcIYQw+Cti+YIL9sUbGDozw5ydvA1GoX
X-IronPort-AV: E=Sophos;i="5.81,243,1610409600"; 
   d="scan'208";a="92520097"
Subject: Re: [net-next 1/2] xen-netback: add module parameter to disable ctrl-ring
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 12 Mar 2021 15:18:11 +0000
Received: from EX13D12EUA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id CF1DD220186;
        Fri, 12 Mar 2021 15:18:09 +0000 (UTC)
Received: from 147dda3ee008.ant.amazon.com (10.43.162.213) by
 EX13D12EUA002.ant.amazon.com (10.43.165.103) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 12 Mar 2021 15:18:06 +0000
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <wei.liu@kernel.org>, <paul@xen.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <xen-devel@lists.xenproject.org>
References: <20210311225944.24198-1-andyhsu@amazon.com>
 <YEuAKNyU6Hma39dN@lunn.ch>
From:   "Hsu, Chiahao" <andyhsu@amazon.com>
Message-ID: <ec5baac1-1410-86e4-a0d1-7c7f982a0810@amazon.com>
Date:   Fri, 12 Mar 2021 16:18:02 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YEuAKNyU6Hma39dN@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.43.162.213]
X-ClientProxiedBy: EX13D04UWB002.ant.amazon.com (10.43.161.133) To
 EX13D12EUA002.ant.amazon.com (10.43.165.103)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Andrew Lunn 於 2021/3/12 15:52 寫道:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>
>
>
> On Thu, Mar 11, 2021 at 10:59:44PM +0000, ChiaHao Hsu wrote:
>> In order to support live migration of guests between kernels
>> that do and do not support 'feature-ctrl-ring', we add a
>> module parameter that allows the feature to be disabled
>> at run time, instead of using hardcode value.
>> The default value is enable.
> Hi ChiaHao
>
> There is a general dislike for module parameters. What other mechanisms
> have you looked at? Would an ethtool private flag work?
>
>       Andrew


Hi Andrew,

I can survey other mechanisms, however before I start doing that,

could you share more details about what the problem is with using module 
parameters? thanks.

ChiaHao

