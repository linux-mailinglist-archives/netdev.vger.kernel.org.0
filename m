Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9267467F915
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbjA1P2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 10:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbjA1P2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:28:03 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B4FF613DF4;
        Sat, 28 Jan 2023 07:28:01 -0800 (PST)
Date:   Sat, 28 Jan 2023 16:27:55 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        ozsh@nvidia.com, marcelo.leitner@gmail.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next v5 2/7] netfilter: flowtable: fixup UDP timeout
 depending on ct state
Message-ID: <Y9U++4pospqBZugS@salvia>
References: <20230127183845.597861-1-vladbu@nvidia.com>
 <20230127183845.597861-3-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230127183845.597861-3-vladbu@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Jan 27, 2023 at 07:38:40PM +0100, Vlad Buslov wrote:
> Currently flow_offload_fixup_ct() function assumes that only replied UDP
> connections can be offloaded and hardcodes UDP_CT_REPLIED timeout value.
> Allow users to modify timeout calculation by implementing new flowtable
> type callback 'timeout' and use the existing algorithm otherwise.
> 
> To enable UDP NEW connection offload in following patches implement
> 'timeout' callback in flowtable_ct of act_ct which extracts the actual
> connections state from ct->status and set the timeout according to it.

I found a way to fix the netfilter flowtable after your original v3
update.

Could you use your original patch in v3 for this fixup?

Thanks.
