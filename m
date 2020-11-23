Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC202BFF5D
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 06:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgKWFUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 00:20:09 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13195 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbgKWFUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 00:20:09 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbb468b0000>; Sun, 22 Nov 2020 21:20:11 -0800
Received: from [10.26.75.187] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 23 Nov
 2020 05:19:57 +0000
Subject: Re: [PATCH net] devlink: Fix reload stats structure
To:     Jakub Kicinski <kuba@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1605879637-6114-1-git-send-email-moshe@mellanox.com>
 <20201121145349.3824029c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <cfa39a4e-e78e-018d-e51a-0a38407af122@nvidia.com>
Date:   Mon, 23 Nov 2020 07:19:54 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201121145349.3824029c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606108812; bh=06+rPNg5w4lJEy4I5kbShgd4uXNmVa8vPwOaXftZiZM=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=oVAOD31qU4lCx3eX/LSbnQyUXdIxdX+27W13Fk7N752BNSKNKnjOvGxldrBg+39ld
         t5lqHm67RUGmF8Jc9C2fw7BuA+duzhSstXf4DMCMq4gsQW0dy++f6oDXbpDQ0OmTfT
         yoQXWsdrXdU6NlJTZTaJ4gP8QSYQy2e7ODRmlGlq2C0mcZphlrKZVRPbYeiOC5VlXm
         4BypjUlSXpKstsNjhwDiqWvJjsTM/vLiDKvMipVrghrbxXZnzum7toZH2PdwvGass+
         +r9rQImr4fDRzdaGHZb2OFVawlpNUyZY0JB72NL8CNAWve0qYSBbf04p6imWBoHOpN
         vG69TG40L6ZNQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/22/2020 12:53 AM, Jakub Kicinski wrote:
> External email: Use caution opening links or attachments
>
>
> On Fri, 20 Nov 2020 15:40:37 +0200 Moshe Shemesh wrote:
>> Fix reload stats structure exposed to the user. Change stats structure
>> hierarchy to have the reload action as a parent of the stat entry and
>> then stat entry includes value per limit. This will also help to avoid
>> string concatenation on iproute2 output.
>>
>> Reload stats structure before this fix:
>> "stats": {
>>      "reload": {
>>          "driver_reinit": 2,
>>          "fw_activate": 1,
>>          "fw_activate_no_reset": 0
>>       }
>> }
>>
>> After this fix:
>> "stats": {
>>      "reload": {
>>          "driver_reinit": {
>>              "unspecified": 2
>>          },
>>          "fw_activate": {
>>              "unspecified": 1,
>>              "no_reset": 0
>>          }
>> }
>>
>> Fixes: a254c264267e ("devlink: Add reload stats")
>> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> At least try to fold the core networking code at 80 characters *please*.
>
> You folded the comments at 86 chars, neither 100 nor 80.


Oh, I missed that comment folding while replacing it in this patch. I 
will fix, thanks.

