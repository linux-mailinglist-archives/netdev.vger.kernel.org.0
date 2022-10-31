Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F05861349D
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 12:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiJaLjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 07:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJaLjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 07:39:18 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C3BDFD4;
        Mon, 31 Oct 2022 04:39:17 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id A8326FF803;
        Mon, 31 Oct 2022 11:39:09 +0000 (UTC)
Message-ID: <7f118c0f-c79a-7f26-aefc-afae00483233@ovn.org>
Date:   Mon, 31 Oct 2022 12:39:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Cc:     linux-kernel@vger.kernel.org, i.maximets@ovn.org
Subject: Re: [ovs-dev] [PATCH net] openvswitch: add missing resv_start_op
 initialization for dp_vport_genl_family
Content-Language: en-US
To:     Ziyang Xuan <william.xuanziyang@huawei.com>, pshelar@ovn.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, dev@openvswitch.org
References: <20221031081210.2852708-1-william.xuanziyang@huawei.com>
From:   Ilya Maximets <i.maximets@ovn.org>
In-Reply-To: <20221031081210.2852708-1-william.xuanziyang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/31/22 09:12, Ziyang Xuan via dev wrote:
> I got a warning using the latest mainline codes to start vms as following:
> 
> ===================================================
> WARNING: CPU: 1 PID: 1 at net/netlink/genetlink.c:383 genl_register_family+0x6c/0x76c
> CPU: 1 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc2-00886-g882ad2a2a8ff #43
> ...
> Call trace:
>  genl_register_family+0x6c/0x76c
>  dp_init+0xa8/0x124
>  do_one_initcall+0x84/0x450
> 
> It is because that commit 9c5d03d36251 ("genetlink: start to validate
> reserved header bytes") has missed the resv_start_op initialization
> for dp_vport_genl_family, and commit ce48ebdd5651 ("genetlink: limit
> the use of validation workarounds to old ops") add checking warning.
> 
> Add resv_start_op initialization for dp_vport_genl_family to fix it.
> 
> Fixes: 9c5d03d36251 ("genetlink: start to validate reserved header bytes")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---

Hi, Ziyang Xuan.  Thanks for the patch!

But it looks like Jakub already fixed that issue a couple of days ago:
  https://git.kernel.org/netdev/net/c/e4ba4554209f

Best regards, Ilya Maximets.
