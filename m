Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 535B763B30A
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbiK1UZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:25:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234051AbiK1UZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:25:38 -0500
Received: from smtp-bc0f.mail.infomaniak.ch (smtp-bc0f.mail.infomaniak.ch [45.157.188.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558102BB38
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 12:25:34 -0800 (PST)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4NLcRJ64KJzMqLwY;
        Mon, 28 Nov 2022 21:25:32 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4NLcRJ1X2fzxF;
        Mon, 28 Nov 2022 21:25:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1669667132;
        bh=iO2GiSFfUun1b68esQtzquit/aydFiNuRJGxevQwJiI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=jbEFMupArB+ck/i4yxCNQZ0+RpXB4vV787N7mu9NPtGUHTiOFpeS8ZG8w3cpRx1A/
         4v3rtTuWUkpzrf8lulp5lPVWmBiotpjp28K09HgP+OpB/l3lvCQwqJmA4CTZTOUgiT
         VDiV8Mwiy9BDyQTRONEWr0vFFGysu6ZA24vqAIQo=
Message-ID: <787e7546-25b9-4e32-6560-b6907cdd6401@digikod.net>
Date:   Mon, 28 Nov 2022 21:25:31 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH] landlock: Allow filesystem layout changes for domains
 without such rule type
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     artem.kuzin@huawei.com, gnoack3000@gmail.com,
        willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
References: <5c6c99f7-4218-1f79-477e-5d943c9809fd@digikod.net>
 <20221117185509.702361-1-mic@digikod.net>
 <1956e8c2-fd4c-898e-dd0f-22ad20a69740@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <1956e8c2-fd4c-898e-dd0f-22ad20a69740@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 28/11/2022 04:02, Konstantin Meskhidze (A) wrote:
> 
> 
> 11/17/2022 9:55 PM, Mickaël Salaün пишет:
>> Allow mount point and root directory changes when there is no filesystem
>> rule tied to the current Landlock domain.  This doesn't change anything
>> for now because a domain must have at least a (filesystem) rule, but
>> this will change when other rule types will come.  For instance, a
>> domain only restricting the network should have no impact on filesystem
>> restrictions.
>>
>> Add a new get_current_fs_domain() helper to quickly check filesystem
>> rule existence for all filesystem LSM hooks.
> 
>     Ok. I got it.
>     Do I need also to add a new network helper:
>     like landlock_get_raw_net_access_mask?

A get_raw helper would not be useful if there is not network access 
initially denied (like for FS_REFER).
