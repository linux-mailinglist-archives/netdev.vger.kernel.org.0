Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 693416484ED
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 16:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbiLIPWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 10:22:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbiLIPVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 10:21:48 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 103D08D194
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 07:21:46 -0800 (PST)
Date:   Fri, 9 Dec 2022 16:21:41 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: Re: [PATCHv4 net-next 5/5] net: move the nat function to nf_nat_ovs
 for ovs and tc
Message-ID: <Y5NShbdkxb1XDpV1@salvia>
References: <cover.1670518439.git.lucien.xin@gmail.com>
 <c973910b2d9741153cca02c14c6c105942d7f44a.1670518439.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c973910b2d9741153cca02c14c6c105942d7f44a.1670518439.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 11:56:12AM -0500, Xin Long wrote:
> There are two nat functions are nearly the same in both OVS and
> TC code, (ovs_)ct_nat_execute() and ovs_ct_nat/tcf_ct_act_nat().
> 
> This patch creates nf_nat_ovs.c under netfilter and moves them
> there then exports nf_ct_nat() so that it can be shared by both
> OVS and TC, and keeps the nat (type) check and nat flag update
> in OVS and TC's own place, as these parts are different between
> OVS and TC.
> 
> Note that in OVS nat function it was using skb->protocol to get
> the proto as it already skips vlans in key_extract(), while it
> doesn't in TC, and TC has to call skb_protocol() to get proto.
> So in nf_ct_nat_execute(), we keep using skb_protocol() which
> works for both OVS and TC contrack.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks for addressing my feedback.
