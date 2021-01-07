Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824422ECAAF
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 07:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbhAGGw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 01:52:59 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7642 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbhAGGw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 01:52:59 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff6afa20000>; Wed, 06 Jan 2021 22:52:18 -0800
Received: from [172.27.1.141] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 7 Jan
 2021 06:52:16 +0000
Subject: Re: [PATCH iproute2] build: Fix link errors on some systems
To:     Petr Machata <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Petr Machata <me@pmachata.org>
References: <1609355503-7981-1-git-send-email-roid@nvidia.com>
 <875z4cwus8.fsf@nvidia.com> <405e8cce-e2dd-891a-dc8a-7c8b0c77f4c6@nvidia.com>
 <4a07fbc9-8e1c-ecd6-ee9e-31d1a952ba42@nvidia.com> <87y2h6urwe.fsf@nvidia.com>
 <5ed38f17-be13-0c5b-5b2f-1cb58ee77a8c@nvidia.com> <87turuuoru.fsf@nvidia.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <4d5f2f49-83cb-8f54-cc01-678282c16074@nvidia.com>
Date:   Thu, 7 Jan 2021 08:52:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <87turuuoru.fsf@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610002338; bh=W0ObrW6CpYHCqtpb+hX9URxw46k0U1ZzMS1ZT0EtTss=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=KG0d+2O1GRrZXeYZZq7z8cM0Lq2PSF5OCIM+4Ijw2SBC9I2uj5hCHQzKr6J9bqjvp
         kskpqgq4X3ObzqZ6wx8EmR9p9S+y0SCxpg81Lo/YBf1M5PUbLj4DCK7yQbaCqiUGSc
         ylmcfK1jjofR+sfhewy3b2d/TYzZEx1v0lboflB4fUg9srm5FHV3VZHnn8DWcodqO1
         MNSYO2ykOfCSdOrlUFNwRiWPVCLkibvhPbgWt8XZec8CWqxRg/wanzke+naPow5Uwz
         SQ2EEAXx73JBn6wOFf628LupfHjH+AzL/pXK8uI3QACIAyqsXkldbCz1jNsjsaywC/
         OqOzDhu8exKDQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-01-06 4:24 PM, Petr Machata wrote:
> 
> Roi Dayan <roid@nvidia.com> writes:
> 
>> On 2021-01-06 3:16 PM, Petr Machata wrote:
>>> Regarding the publishing, the _jw reference can be changed to a call to
>>> is_json_context(), which does the same thing. Then _jw can stay private
>>> in json_print.c.
>>> Exposing an _IS_JSON_CONTEXT / _IS_FP_CONTEXT might be odd on account of
>>> the initial underscore, but since it's only used in implementations,
>>> maybe it's OK?
>>>
>>
>> With is_json_context() I cannot check the type passed by the caller.
>> i.e. PRINT_JSON, PRINT_FP, PRINT_ANY.
> 
> I meant s/_jw/is_json_context()/. Like this:
> 
> #define _IS_JSON_CONTEXT(type) \
>      ((type & PRINT_JSON || type & PRINT_ANY) && is_json_context())
> 
> Then _jw can stay private.
> 

right. thanks. i'll submit v2 for review.
