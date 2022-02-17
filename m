Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80254BA809
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244173AbiBQSUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:20:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244181AbiBQSUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:20:50 -0500
Received: from smtp.smtpout.orange.fr (smtp05.smtpout.orange.fr [80.12.242.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899682B2FEC
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 10:20:34 -0800 (PST)
Received: from [192.168.1.18] ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id KlOInzYku0Z1CKlOInhbZ2; Thu, 17 Feb 2022 19:20:32 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Thu, 17 Feb 2022 19:20:32 +0100
X-ME-IP: 90.126.236.122
Message-ID: <01035905-61f5-da02-36d5-92831e1da184@wanadoo.fr>
Date:   Thu, 17 Feb 2022 19:20:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 1/2] nfp: flower: Fix a potential leak in
 nfp_tunnel_add_shared_mac()
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        John Hurley <john.hurley@netronome.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        oss-drivers@corigine.com, netdev@vger.kernel.org
References: <4acb805751f2cf5de8d69e9602a88ec39feff9fc.1644532467.git.christophe.jaillet@wanadoo.fr>
 <20220211165356.1927a81b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220217075940.GA4665@corigine.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20220217075940.GA4665@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 17/02/2022 à 08:59, Simon Horman a écrit :
> On Fri, Feb 11, 2022 at 04:53:56PM -0800, Jakub Kicinski wrote:
>> On Thu, 10 Feb 2022 23:34:52 +0100 Christophe JAILLET wrote:
>>> ida_simple_get() returns an id between min (0) and max (NFP_MAX_MAC_INDEX)
>>> inclusive.
>>> So NFP_MAX_MAC_INDEX (0xff) is a valid id.
>>>
>>> In order for the error handling path to work correctly, the 'invalid'
>>> value for 'ida_idx' should not be in the 0..NFP_MAX_MAC_INDEX range,
>>> inclusive.
>>>
>>> So set it to -1.
>>>
>>> Fixes: 20cce8865098 ("nfp: flower: enable MAC address sharing for offloadable devs")
>>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>>
>> This patch is a fix and the other one is refactoring. They can't be
>> in the same series because they need to go to different trees. Please
>> repost the former with [PATCH net] and ~one week later the latter with
>> [PATCH net-next].
> 
> Thanks Jakub.
> 
> Christophe, please let me know if you'd like me to handle reposting
> the patches as described by Jakub.
> 
Hi,

If you can, it's fine for me.

I must admit that what I consider, as an hobbyist, too much bureaucracy 
is sometimes discouraging.

I do understand the need for maintainers to have things the way they 
need, but, well, maybe sometimes it is too much.

In this particular case, maybe patch 1/2 could be applied to net as-is, 
and 2/2 just dropped because not really useful.


(Just the thoughts of a tired man after a long day at work, don't worry, 
tomorrow, I'll be in a better mood)

CJ
