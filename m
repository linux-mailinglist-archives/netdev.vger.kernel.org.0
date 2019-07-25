Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D94C74418
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 05:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390116AbfGYDpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 23:45:45 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46813 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389704AbfGYDpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 23:45:45 -0400
Received: by mail-qt1-f194.google.com with SMTP id h21so47686975qtn.13;
        Wed, 24 Jul 2019 20:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Trz4Yq5I05miJEk3QpVWhCvPnyfFV9tn+2LYf9hXH1Q=;
        b=Nlhf5uo/1yQsmBtkOM7iJMYAy0WxeG7Qtxka2FAwqdb8mFLbKv2UD+RjcTEc35mzpI
         NSr7t/zzELViTrMk7M+PpgJ3aFWo6mnPuHO1NE6fsKhgwSj544qF6K04wvnvD4OGORwk
         Rv9UbVLBAaW+xv6DgZdoJjQ3xCm6rJfMsg4CHgK+FiANotCBINMkESdbaoDCtwGIjsek
         wDg0txnqQZCOVcOKG6YUaLdBUjuTI4rV1fOXLv5Lt/HAZltlovc5awDam38H71WsW8Y+
         cujK+qJUxiMWkKEftg6E8W7rDF5nK5WXcLs3Q02PExzdw415EMouEATTQWYz7JqKXuWa
         pzNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Trz4Yq5I05miJEk3QpVWhCvPnyfFV9tn+2LYf9hXH1Q=;
        b=K3PQrqeZkt/am+0TkH5l9a1e+gvVgDf9JlQ6fjbykJ26qACINRxKtPkPE3+Ck+YMFR
         rgaqOJXx/ox/GkDqYoG354b0NQ0QSsYg+14/INyVoN/TP1FxuGugvdv+qU3vw7wgv2wE
         uzoXgLlrrxTHAkGbmoph02xs8B/bnINeOOxFMTd2GFIpOkH0rngfbl/3VJ8BfkmYoGkn
         4mRmplYUBRlLvz0MWbI9Fd4fTVSHEV0M9j4GV74qJyhFn8B9Dv26Od0HrLZxRP+1P6xl
         v/2cOfM0Xb6eVlb/MQeYw4xKYkcYtwmF+aNdZwssS+Dn+bbgvoLgb/Aqp+nSEzmozioz
         yueA==
X-Gm-Message-State: APjAAAVnoApVgdk5HVZwWx0zFhnN2N/M+Kiid+VRBo37U+zAffI9WvBE
        mxIyqe9CFwK6K6N59YuySy3Dbn5M2DH/Ug==
X-Google-Smtp-Source: APXvYqx6bjhGCIG6JegvgzYJgZVMDSSssjrOezQEzjRns6Fe+9Q+q4dIpLw7Fu0yuPPAdhR7APEiUA==
X-Received: by 2002:ac8:1b30:: with SMTP id y45mr58469118qtj.218.1564026343941;
        Wed, 24 Jul 2019 20:45:43 -0700 (PDT)
Received: from localhost.localdomain ([168.181.49.45])
        by smtp.gmail.com with ESMTPSA id x46sm30072483qtx.96.2019.07.24.20.45.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 20:45:43 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 88E59C1628; Thu, 25 Jul 2019 00:45:40 -0300 (-03)
Date:   Thu, 25 Jul 2019 00:45:40 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu <wenxu@ucloud.cn>
Cc:     pablo@netfilter.org, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: nf_table_offload: Fix zero prio of
 flow_cls_common_offload
Message-ID: <20190725034540.GJ6204@localhost.localdomain>
References: <1562832210-25981-1-git-send-email-wenxu@ucloud.cn>
 <20190724235151.GB4063@localhost.localdomain>
 <9775e2da-78ce-95f8-c215-b35b464ea5a9@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9775e2da-78ce-95f8-c215-b35b464ea5a9@ucloud.cn>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 11:03:52AM +0800, wenxu wrote:
> 
> On 7/25/2019 7:51 AM, Marcelo Ricardo Leitner wrote:
> > On Thu, Jul 11, 2019 at 04:03:30PM +0800, wenxu@ucloud.cn wrote:
> >> From: wenxu <wenxu@ucloud.cn>
> >>
> >> The flow_cls_common_offload prio should be not zero
> >>
> >> It leads the invalid table prio in hw.
> >>
> >> # nft add table netdev firewall
> >> # nft add chain netdev firewall acl { type filter hook ingress device mlx_pf0vf0 priority - 300 \; }
> >> # nft add rule netdev firewall acl ip daddr 1.1.1.7 drop
> >> Error: Could not process rule: Invalid argument
> >>
> >> kernel log
> >> mlx5_core 0000:81:00.0: E-Switch: Failed to create FDB Table err -22 (table prio: 65535, level: 0, size: 4194304)
> >>
> >> Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
> >> Signed-off-by: wenxu <wenxu@ucloud.cn>
> >> ---
> >>  net/netfilter/nf_tables_offload.c | 3 +++
> >>  1 file changed, 3 insertions(+)
> >>
> >> diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
> >> index 2c33028..01d8133 100644
> >> --- a/net/netfilter/nf_tables_offload.c
> >> +++ b/net/netfilter/nf_tables_offload.c
> >> @@ -7,6 +7,8 @@
> >>  #include <net/netfilter/nf_tables_offload.h>
> >>  #include <net/pkt_cls.h>
> >>  
> >> +#define FLOW_OFFLOAD_DEFAUT_PRIO 1U
> >> +
> >>  static struct nft_flow_rule *nft_flow_rule_alloc(int num_actions)
> >>  {
> >>  	struct nft_flow_rule *flow;
> >> @@ -107,6 +109,7 @@ static void nft_flow_offload_common_init(struct flow_cls_common_offload *common,
> >>  					struct netlink_ext_ack *extack)
> >>  {
> >>  	common->protocol = proto;
> >> +	common->prio = TC_H_MAKE(FLOW_OFFLOAD_DEFAUT_PRIO << 16, 0);
> > Note that tc semantics for this is to auto-generate a priority in such
> > cases, instead of using a default.
> >
> > @tc_new_tfilter():
> >         if (prio == 0) {
> >                 /* If no priority is provided by the user,
> >                  * we allocate one.
> >                  */
> >                 if (n->nlmsg_flags & NLM_F_CREATE) {
> >                         prio = TC_H_MAKE(0x80000000U, 0U);
> >                         prio_allocate = true;
> > ...
> >                 if (prio_allocate)
> >                         prio = tcf_auto_prio(tcf_chain_tp_prev(chain,
> >                                                                &chain_info));
> 
> Yes,The tc auto-generate a priority.  But if there is no pre
> tcf_proto, the priority is also set as a default.

After the first filter, there will be a tcf_proto. Please see the test below.

> 
> In nftables each rule no priortiy for each other. So It is enough to
> set a default value which is similar as the tc.

Yep, maybe it works for nftables. I'm just highlighting this because
it is reusing tc infrastructure and will expose a different behavior
to the user.  But if nftables already has this defined, that probably
takes precedence by now and all that is left to do is to make sure any
documentation on it is updated.  Pablo?

> 
> static inline u32 tcf_auto_prio(struct tcf_proto *tp)
> {
>     u32 first = TC_H_MAKE(0xC0000000U, 0U);
                              ^^^^  base default prio, 0xC0000 = 49152

> 
>     if (tp)
>         first = tp->prio - 1;
> 
>     return TC_H_MAJ(first);
> }

# tc qdisc add dev veth1 ingress
# tc filter add dev veth1 ingress proto ip flower src_mac ec:13:db:00:00:00 action drop
                                                           1st filter  --^^
# tc filter add dev veth1 ingress proto ip flower src_mac ec:13:db:00:00:01 action drop
                                                           2nd filter  --^^
# tc filter add dev veth1 ingress proto ip flower src_mac ec:13:db:00:00:02 action drop

With no 'prio X' parameter, it uses 0 as default, and when dumped:

# tc filter show dev veth1 ingress
filter protocol ip pref 49150 flower
filter protocol ip pref 49150 flower handle 0x1
  src_mac ec:13:db:00:00:02
  eth_type ipv4
  not_in_hw
        action order 1: gact action drop
         random type none pass val 0
         index 40003 ref 1 bind 1

filter protocol ip pref 49151 flower
filter protocol ip pref 49151 flower handle 0x1
                        ^vv^^---- 2nd filter
  src_mac ec:13:db:00:00:01
  eth_type ipv4
  not_in_hw
        action order 1: gact action drop
         random type none pass val 0
         index 40002 ref 1 bind 1

filter protocol ip pref 49152 flower
filter protocol ip pref 49152 flower handle 0x1
                        ^vv^^---- 1st filter
  src_mac ec:13:db:00:00:00
  eth_type ipv4
  not_in_hw
        action order 1: gact action drop
         random type none pass val 0
         index 40001 ref 1 bind 1


