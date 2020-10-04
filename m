Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C985282929
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 08:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgJDGbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 02:31:04 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11143 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgJDGbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 02:31:04 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f796c1b0004>; Sat, 03 Oct 2020 23:30:51 -0700
Received: from [10.21.180.76] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 4 Oct
 2020 06:30:51 +0000
Subject: Re: [PATCH net-next 02/16] devlink: Add reload action option to
 devlink reload command
To:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
 <1601560759-11030-3-git-send-email-moshe@mellanox.com>
 <20201002151943.GB3159@nanopsycho.orion>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <44621685-5356-c0c2-2947-15013b8f6d13@nvidia.com>
Date:   Sun, 4 Oct 2020 09:30:48 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201002151943.GB3159@nanopsycho.orion>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601793051; bh=uu0CTyBqLF7KdJxyDrjGKEkyAj9kchNDjZPnpEmUIik=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=qoivaNDR67uZoGdfMvfOwhmLbAkBL2Fop3XS/Gs2ixEh29/8PQtRE/TRGEWrPPKhP
         HW5EAU/2foUDWZjrHai+ZdNqyaT4kxnPG4pH5ZAI6Gs47Rg04ALFslApdIMqW3sU8s
         9gdi7aiN0qdtH/zlnoUE9XTWupiPT+f/x+STu8i+mVZTdwBYQOPMq54I+xmqXf2m0G
         7Sl3KuZ5uhVEXnw7vdqSd9gVlNXUBFN/TTmEVEzyxtKcBpoNNGDB78/fAlPNsYxhSB
         t4BnVZLhFdf/wuzAIEyE1gZ1FYtFsPINgM7FLh3rAw7dQc/WaA42GBEH59jzQTK596
         cRZqc/i4hPFQw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/2/2020 6:19 PM, Jiri Pirko wrote:
> Thu, Oct 01, 2020 at 03:59:05PM CEST, moshe@mellanox.com wrote:
>
> [...]
>
>
>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>> index 1c286e9a3590..ddba63bce7ad 100644
>> --- a/include/net/devlink.h
>> +++ b/include/net/devlink.h
>> @@ -1077,10 +1077,11 @@ struct devlink_ops {
>> 	 * implemementation.
>> 	 */
>> 	u32 supported_flash_update_params;
>> +	unsigned long reload_actions;
>> 	int (*reload_down)(struct devlink *devlink, bool netns_change,
>> -			   struct netlink_ext_ack *extack);
>> -	int (*reload_up)(struct devlink *devlink,
>> -			 struct netlink_ext_ack *extack);
>> +			   enum devlink_reload_action action, struct netlink_ext_ack *extack);
>> +	int (*reload_up)(struct devlink *devlink, enum devlink_reload_action action,
>> +			 struct netlink_ext_ack *extack, unsigned long *actions_performed);
> Nit. Could you please push extack to be the last arg here? It is common
> to have extack as the last arg + action and actions_performed are going
> to be side by side.


Sure.

> Otherwise the patch looks fine.
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
