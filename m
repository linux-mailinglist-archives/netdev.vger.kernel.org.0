Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 838D74C2787
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 10:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbiBXJJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 04:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbiBXJJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 04:09:06 -0500
X-Greylist: delayed 428 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 24 Feb 2022 01:08:31 PST
Received: from blyat.fensystems.co.uk (blyat.fensystems.co.uk [IPv6:2a05:d018:a4d:6403:2dda:8093:274f:d185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DBE19E011;
        Thu, 24 Feb 2022 01:08:30 -0800 (PST)
Received: from pudding.home (unknown [IPv6:2a00:23c6:5486:8700:eaa7:4ea6:88e4:6f0e])
        by blyat.fensystems.co.uk (Postfix) with ESMTPSA id 314E643912;
        Thu, 24 Feb 2022 09:01:17 +0000 (UTC)
Subject: Re: [PATCH v2 2/2] Revert "xen-netback: Check for hotplug-status
 existence before watching"
To:     paul@xen.org,
        =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:XEN NETWORK BACKEND DRIVER" 
        <xen-devel@lists.xenproject.org>,
        "open list:XEN NETWORK BACKEND DRIVER" <netdev@vger.kernel.org>
References: <20220222001817.2264967-1-marmarek@invisiblethingslab.com>
 <20220222001817.2264967-2-marmarek@invisiblethingslab.com>
 <d9969551-77ca-fda7-b30a-da5d9e1dfcd6@gmail.com>
From:   Michael Brown <mcb30@ipxe.org>
Message-ID: <a10683f1-59ef-93e1-150a-f755bf470602@ipxe.org>
Date:   Thu, 24 Feb 2022 09:01:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <d9969551-77ca-fda7-b30a-da5d9e1dfcd6@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/02/2022 07:56, Durrant, Paul wrote:
> On 22/02/2022 00:18, Marek Marczykowski-Górecki wrote:
>> This reverts commit 2afeec08ab5c86ae21952151f726bfe184f6b23d.
>>
>> The reasoning in the commit was wrong - the code expected to setup the
>> watch even if 'hotplug-status' didn't exist. In fact, it relied on the
>> watch being fired the first time - to check if maybe 'hotplug-status' is
>> already set to 'connected'. Not registering a watch for non-existing
>> path (which is the case if hotplug script hasn't been executed yet),
>> made the backend not waiting for the hotplug script to execute. This in
>> turns, made the netfront think the interface is fully operational, while
>> in fact it was not (the vif interface on xen-netback side might not be
>> configured yet).
>>
>> This was a workaround for 'hotplug-status' erroneously being removed.
>> But since that is reverted now, the workaround is not necessary either.
>>
>> More discussion at
>> https://lore.kernel.org/xen-devel/afedd7cb-a291-e773-8b0d-4db9b291fa98@ipxe.org/T/#u 
>>
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Marek Marczykowski-Górecki 
>> <marmarek@invisiblethingslab.com>
> 
> Reviewed-by: Paul Durrant <paul@xen.org>

In conjunction with patch 1/2 (which reverts the patch that caused the 
original problem):

Reviewed-by: Michael Brown <mbrown@fensystems.co.uk>

Thanks,

Michael

