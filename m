Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAEBB64DA9D
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 12:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiLOLpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 06:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiLOLpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 06:45:49 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0D015804
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 03:45:47 -0800 (PST)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id B9395240004;
        Thu, 15 Dec 2022 11:45:43 +0000 (UTC)
Message-ID: <920bc474-d5d8-2d8d-d9eb-fd237cba723d@ovn.org>
Date:   Thu, 15 Dec 2022 12:45:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Cc:     i.maximets@ovn.org, pshelar@ovn.org, davem@davemloft.net,
        dev@openvswitch.org, aconole@redhat.com, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Content-Language: en-US
To:     Eelco Chaudron <echaudro@redhat.com>, netdev@vger.kernel.org
References: <167103556314.309509.17490804498492906420.stgit@ebuild>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [PATCH net v2] openvswitch: Fix flow lookup to use unmasked key
In-Reply-To: <167103556314.309509.17490804498492906420.stgit@ebuild>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/22 17:33, Eelco Chaudron wrote:
> The commit mentioned below causes the ovs_flow_tbl_lookup() function
> to be called with the masked key. However, it's supposed to be called
> with the unmasked key.

Hi, Eelco.  Thanks for the fix!

Could you, please, add more information to the commit message on
why this is a problem, with some examples?  This will be useful
for someone in the future trying to understand why we actually
have to use an unmasked key here.

Also, I suppose, 'Cc: stable@vger.kernel.org' tag is needed in the
commit message since it's a fix for a bug that is actually impacts
users and needs to be backported.

Best regards, Ilya Maximets.

> 
> This change reverses the commit below, but rather than having the key
> on the stack, it's allocated.
> 
> Fixes: 190aa3e77880 ("openvswitch: Fix Frame-size larger than 1024 bytes warning.")
> 
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> 
> ---
> Version history:
>  - v2: Fixed ENOME(N/M) error. Forgot to do a stg refresh.
> 
>  net/openvswitch/datapath.c |   25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)

