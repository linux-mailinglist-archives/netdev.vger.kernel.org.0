Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34CC612125
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 09:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiJ2Hxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 03:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiJ2Hxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 03:53:44 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4C972B5A;
        Sat, 29 Oct 2022 00:53:41 -0700 (PDT)
Date:   Sat, 29 Oct 2022 15:53:35 +0800
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Cai Huoqing <cai.huoqing@linux.dev>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Bin Chen <bin.chen@corigine.com>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Peter Chen <peter.chen@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: hinic: Add control command support for VF PMD
 driver in DPDK
Message-ID: <20221029075335.GA9148@chq-T47>
References: <20221026125922.34080-1-cai.huoqing@linux.dev>
 <20221026125922.34080-2-cai.huoqing@linux.dev>
 <20221027110312.7391f69f@kernel.org>
 <20221028045655.GB3164@chq-T47>
 <20221028085651.78408e2c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221028085651.78408e2c@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28 10月 22 08:56:51, Jakub Kicinski wrote:
> On Fri, 28 Oct 2022 12:56:55 +0800 Cai Huoqing wrote:
> > > The commands are actually supported or you're just ignoring them
> > > silently?  
> > No, 
> 
> Do you mean "neither"?
> 
> > if the cmd is not added to 'nic_cmd_support_vf',
> > the PF will return false, and the error messsage "PF Receive VFx
> > unsupported cmd x" in the function 'hinic_mbox_check_cmd_valid',
> > then, the configuration will not be set to hardware.
> 
> You're describing the behavior before the patch?
> 
> After the patch the command is ignored silently, like I said, right?
> Because there is no handler added to nic_vf_cmd_msg_handler[].
> Why is that okay? Or is there handler somewhere else?

No need to add handlers to nic_vf_cmd_msg_handler[].
It will run the path,
if (i == ARRAY_SIZE(nic_vf_cmd_msg_handler))
	err = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_L2NIC,
				cmd, buf_in, in_size, buf_out,
				out_size, HINIC_MGMT_MSG_SYNC);
right? or if not please show the related code.
