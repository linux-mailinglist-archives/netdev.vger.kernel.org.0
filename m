Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A346528293A
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 08:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgJDGm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 02:42:59 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12504 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgJDGm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 02:42:59 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f796ee60000>; Sat, 03 Oct 2020 23:42:46 -0700
Received: from [10.21.180.76] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 4 Oct
 2020 06:42:50 +0000
Subject: Re: [PATCH net-next 03/16] devlink: Add devlink reload limit option
To:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
 <1601560759-11030-4-git-send-email-moshe@mellanox.com>
 <20201003075100.GC3159@nanopsycho.orion>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <f91809cf-268d-64de-8a19-12305a3c11e0@nvidia.com>
Date:   Sun, 4 Oct 2020 09:42:47 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201003075100.GC3159@nanopsycho.orion>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601793766; bh=3f7ocMFDJGTXvJfoe+Ta4bX4ElhSzZUOdZHzS8aX3YE=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=keJ8HCRa6vbiWsfMsxMl8G3Qnll75cRUj+ASpcGL6P8MZzA/K9AbRPLZJn8TR39VS
         wtDidiGt9ZBDDthhw/sG7ehpYCk4CjUqRLvV62qB0zw/E+Pr2VttE0AFaItLw00Mlk
         vc1nSHQZ0hL97msUeh5/qPg37Ouie5lbVMS3kHbCkr5jLnBvrcK5VwZj84rK09DHrP
         IMBeNpF98frICHzfBAo0troXigwmrFdlqyBWnKuNcGOerHiToP1cdfcZKYfDsiKIEF
         xyCYQJvP1qzsPv9RsbCRUQWUUYkR9CYCQoNvCM0q3UD4JyslkQRjdB++WLGGmV+wkw
         J8R9Xkn20RaQw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/3/2020 10:51 AM, Jiri Pirko wrote:
> Thu, Oct 01, 2020 at 03:59:06PM CEST, moshe@mellanox.com wrote:
>
> [...]
>
>> enum devlink_attr {
>> 	/* don't change the order or add anything between, this is ABI! */
>> 	DEVLINK_ATTR_UNSPEC,
>> @@ -507,6 +524,7 @@ enum devlink_attr {
>>
>> 	DEVLINK_ATTR_RELOAD_ACTION,		/* u8 */
>> 	DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED,	/* u64 */
>> +	DEVLINK_ATTR_RELOAD_LIMIT,	/* u8 */
> Hmm, why there could be specified only single "limit"? I believe this
> should be a bitfield. Same for the internal api to the driver.


Why bitfield ? Either the user asks for a specific limit or he doesn't 
ask for any (unspecified).

If the user doesn't need limitation he will not specify a limit.

> [...]
