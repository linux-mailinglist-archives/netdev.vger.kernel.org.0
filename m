Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB434645291
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 04:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiLGDdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 22:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiLGDdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 22:33:32 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F73C1AD83
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 19:33:31 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-143ffc8c2b2so19913404fac.2
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 19:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jJurWFq5bo6lmI7Bvuzpdn6rb8OF/TtSEiJWbYAHojE=;
        b=ZjPx8XhgOyINiKV0IRhGBrisLdbHr3bE0hXWcrqY7UPNLUO9UrDzF4No5+W73UQHGY
         cdgMlEr1k7nGeoJHgbQ6N/xUzrs7NK0ui60HbZxNwN7p0BBAvjMKi1HrXiwH4qE4QYc6
         XQ1oqhMv6uf+Pui9H8ijnsrN9elCzNgtOgt4aAAe11nXUGeYAzGLsEuiQhASiU0+ilTe
         z75WAvWNr/gpjO3m2dnQylWp5IUzeSFQqMW8C9KAUZAjiAtHxJbtt7wpNN/2nhk0K6e7
         zyDKU3XqALU18FGwPvFhuM6+CAvIkgQPosNlUY8iu/tzp1+y0eIP7DvehD86H3rvx9PN
         uGng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jJurWFq5bo6lmI7Bvuzpdn6rb8OF/TtSEiJWbYAHojE=;
        b=1iYEW8Hyu3+GtT+IkixqXs/S1l1b8phZ7Vyeh/SCHd1w+I/v/RBEAEvJKR6UOiQggF
         yvadpIF6xwWZQTrhBtI/7Oe1vDYWr/P4jtEQ+3Q4andVW0h9fZkXeUbcf4g/3Aa7dfU4
         1AaqLGFGcDP2gpDyaJBzPC3y7JFgmZuClx9PmmxeG4oKk6ODX7PaDdzHmhGl9FBjA9Q1
         c2xzWmMl3AZrSapkk7xhYSVBnmXD4tUm9AVb5VP8yjUJc+uhlwsyOfrxxdW+VAw88hW3
         vs0OL3pElYmW84KmBa4BqiQVhpQ6hmcfyiH/4oDDw0ujYnO6gJOHnPRSzRUYuNLvwxDv
         Sjsw==
X-Gm-Message-State: ANoB5plD2pMSL2egIcWnd8hOkuOiXom0J8zaHMV3y5mg0h2lJE6MFhCj
        22cRF+RFjelkOzce+T/gDT6hnGMm97vfxksAmMI=
X-Google-Smtp-Source: AA0mqf6155pQksUkPcD/xWZhEL/Kh7qXjAZHGu0iMVl+T5znqCFJvTimS6GFfqrbiumrz/nBD904ziy0CxqJlzz2Jns=
X-Received: by 2002:a05:6871:4494:b0:142:6cb4:8b3a with SMTP id
 ne20-20020a056871449400b001426cb48b3amr40282244oab.190.1670384010494; Tue, 06
 Dec 2022 19:33:30 -0800 (PST)
MIME-Version: 1.0
References: <cover.1670369327.git.lucien.xin@gmail.com> <bbaf96445e9e60136dfaacdc58726bfd3a9e5148.1670369327.git.lucien.xin@gmail.com>
 <Y4/WNywqOPQlCQrz@salvia>
In-Reply-To: <Y4/WNywqOPQlCQrz@salvia>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 6 Dec 2022 22:32:40 -0500
Message-ID: <CADvbK_dEST=QdwkS0CdtnMWUAcF96XagezF2zuvRU_B7nB=aYw@mail.gmail.com>
Subject: Re: [PATCHv3 net-next 5/5] net: move the nat function to nf_nat_ovs
 for ovs and tc
To:     Pablo Neira Ayuso <pablo@netfilter.org>
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 6, 2022 at 6:54 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Tue, Dec 06, 2022 at 06:31:16PM -0500, Xin Long wrote:
> [...]
> > diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
> > index 1d4db1943936..0976d34b1e5f 100644
> > --- a/net/netfilter/Makefile
> > +++ b/net/netfilter/Makefile
> > @@ -54,6 +54,12 @@ obj-$(CONFIG_NF_CONNTRACK_TFTP) += nf_conntrack_tftp.o
> >
> >  nf_nat-y     := nf_nat_core.o nf_nat_proto.o nf_nat_helper.o
> >
> > +ifdef CONFIG_OPENVSWITCH
> > +nf_nat-y += nf_nat_ovs.o
> > +else ifdef CONFIG_NET_ACT_CT
> > +nf_nat-y += nf_nat_ovs.o
> > +endif
>
> Maybe add CONFIG_NF_NAT_OVS and select it from OPENVSWITCH Kconfig
> (select is a hammer, but it should be fine in this case since
> OPENVSWITCH already depends on NF_NAT?).
not really completely depends, it's:

  depends on (!NF_NAT || NF_NAT)

but it's fine, the select will be:

  select NF_NAT_OVS if NF_NAT

>
> Then in Makefile:
>
> nf_nat-$(CONFIG_NF_NAT_OVS)  += nf_nat_ovs.o
>
> And CONFIG_NF_NAT_OVS depends on OPENVSWITCH.
Sounds great!
Then it will be:

--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -459,6 +459,10 @@ config NF_NAT_REDIRECT
 config NF_NAT_MASQUERADE
        bool

+config NF_NAT_OVS
+       bool
+       depends on OPENVSWITCH || NET_ACT_CT
+

--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -59,6 +59,7 @@ obj-$(CONFIG_NF_LOG_SYSLOG) += nf_log_syslog.o
 obj-$(CONFIG_NF_NAT) += nf_nat.o
 nf_nat-$(CONFIG_NF_NAT_REDIRECT) += nf_nat_redirect.o
 nf_nat-$(CONFIG_NF_NAT_MASQUERADE) += nf_nat_masquerade.o
+nf_nat-$(CONFIG_NF_NAT_OVS)  += nf_nat_ovs.o

--- a/net/openvswitch/Kconfig
+++ b/net/openvswitch/Kconfig
@@ -15,6 +15,7 @@ config OPENVSWITCH
        select NET_MPLS_GSO
        select DST_CACHE
        select NET_NSH
+       select NF_NAT_OVS if NF_NAT

--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -977,6 +977,7 @@ config NET_ACT_TUNNEL_KEY
 config NET_ACT_CT
        tristate "connection tracking tc action"
        depends on NET_CLS_ACT && NF_CONNTRACK && (!NF_NAT || NF_NAT)
&& NF_FLOW_TABLE
+       select NF_NAT_OVS if NF_NAT


I will prepare v4, Thanks.
