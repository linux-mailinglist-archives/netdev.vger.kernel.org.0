Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1449561FB2
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 17:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235391AbiF3Puv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 11:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234204AbiF3Puu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 11:50:50 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF352A409
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 08:50:49 -0700 (PDT)
Received: from [10.120.40.106] (static-qvn-qvt-113043.business.bouyguestelecom.com [89.83.113.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 96CA3501186;
        Thu, 30 Jun 2022 18:49:09 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 96CA3501186
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1656604150; bh=8QiiGAbSK7q1zbgt/8+D/8O7yvB+W5ua3xr2QtHSWMI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=CeYEvug0bTIYIdKPS0dJN6mQG35Ex0jyCfgVKNmixTdhtlKKQClRi7t1yA/3Y1fIG
         mUOVQcQLCCUGfnXzSu+n76i/TWg4QddfY+a4p0nnQGCUinLIgpLPAfLRCrNMNLKVK7
         NK783mpL5X0QzwFfRUmQ5T5rShpAkLgUruyBsKIc=
Message-ID: <689711e9-47ca-af2d-b0a7-a6406d9736e1@novek.ru>
Date:   Thu, 30 Jun 2022 16:50:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v1 1/3] dpll: Add DPLL framework base functions
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org\"" 
        <linux-arm-kernel@lists.infradead.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
References: <20220623005717.31040-1-vfedorenko@novek.ru>
 <20220623005717.31040-2-vfedorenko@novek.ru>
 <DM6PR11MB46579C692B75DEF81530B7339BB59@DM6PR11MB4657.namprd11.prod.outlook.com>
 <34093244-431b-98c8-ba88-82957c659808@novek.ru>
 <DM6PR11MB4657C1830DACC5EB4CD98B789BB49@DM6PR11MB4657.namprd11.prod.outlook.com>
 <a85620a1-94ef-0fdf-3c92-6c9d2e3614f5@novek.ru>
 <DM6PR11MB46572B45C787C6D1351D606C9BBB9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <528be46d-16d4-bf71-a657-8e7fd55f9ebd@novek.ru>
 <20220629192312.45acd2fd@kernel.org>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20220629192312.45acd2fd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.06.2022 03:23, Jakub Kicinski wrote:
> On Thu, 30 Jun 2022 00:30:08 +0100 Vadim Fedorenko wrote:
>>> For adjusting phase offset it would be great to have set/get of s64 phase
>>> offset.
>>
>> This way it's getting closer and closer to ptp, but still having phase offset is
>> fair point and I will go this way. Jakub, do you have any objections?
> 
> How does the DPLL interface interact with PTP? Either API can set the
> phase.

Well, if the same hardware is exposed to both subsystem, it will be serialised 
by hardware driver. And it goes to hardware implementation on how to deal with 
such changes. Am I wrong?
