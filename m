Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF1663F544
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 17:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbiLAQ12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 11:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbiLAQ10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 11:27:26 -0500
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B70B43DA;
        Thu,  1 Dec 2022 08:27:25 -0800 (PST)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-1441d7d40c6so2708973fac.8;
        Thu, 01 Dec 2022 08:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8TBW6xbCe5t8nQXUxEetf6lihgyzkGvo5R6W7azKY14=;
        b=GrE3SOpw0Fz5M0vxofINCokaHe2M/a65FHUvX/TS0+68RzUftOn8E1WOlbOq486v+D
         VxYUVCeu2I2wsIVM2jqRLgqgg3HE+wb5VLBsLpescwy6MtCLhfY1Jz9pKzjQL79TebvP
         5KV5zvo7ZOBP0T5bAjSubFmPvtvsk9qIqrE3wOlEC3R8KbPZjuYcWc9tHg24uFj7k42+
         NQp3vRP6898Lzx6UD1V3KA/U4nnpGyk2YyTk2EmsQCvIpzQA2SSNYonJx3oV2NYCGAQ9
         YHRPDQJ7KQruLw1JWw5rzARLoF7irwvt7FNdbz4fnGqadMT9JVAUG3PZ38gQ6XWIgF7u
         8paw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8TBW6xbCe5t8nQXUxEetf6lihgyzkGvo5R6W7azKY14=;
        b=OzYnftoZOt1PomBvylIRbjcJz1/8tbfnLSeBo9wZlLM6XRAyFNi5nzW0ej1HeVa5hQ
         9TexDyZCDdndBThyJxIrdjXK+A9DqCKQvnuUTKKmsYPi4ROmYuC/ORQfvJc/DwN3ZXX0
         Cit8yJ7qZBBLRjvn048FWS6oetWgx6ljgiu4prfFu0ZdVa9eaRXtItUVZ0NHMElpdzdM
         bRB26kIWgJ6Ri1CeurJCv/xN5fBfxR8w0edt//S0gQRoBrFf6bloD+eifopCisqI8a9t
         wjSMj6goJ6xrEIjD5Pj8XmJ1f3G0ENr5+ffFROAXl2rVWgjnf6B22v8qAzaUSDwZ83A9
         rEzg==
X-Gm-Message-State: ANoB5plHrHSyaC6P3FzWbWiLhQ7ChWEx2yTfY56Azp7S0ZFLIzgQ6cFf
        iLna0YdX+05dxMIrUAh9TeKCZEZDaMfu/H1AHDs=
X-Google-Smtp-Source: AA0mqf7E6JlCU5bKp56CLLCXXIoqOGUT8ukLSY17cTa0VkMink3dCOT1kzff8JYwXCjE99+Ns2ekNhKUDClq+kGnrZs=
X-Received: by 2002:a05:6871:4494:b0:142:6cb4:8b3a with SMTP id
 ne20-20020a056871449400b001426cb48b3amr27850483oab.190.1669912044564; Thu, 01
 Dec 2022 08:27:24 -0800 (PST)
MIME-Version: 1.0
References: <cover.1669138256.git.lucien.xin@gmail.com> <bf19487f4dfc8cd91a4395672d9905b10917128d.1669138256.git.lucien.xin@gmail.com>
 <Y35r87foLmKAblMg@t14s.localdomain>
In-Reply-To: <Y35r87foLmKAblMg@t14s.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 1 Dec 2022 11:26:39 -0500
Message-ID: <CADvbK_cvyW3jO1RSJo3AROa5Di+2mXB_ajCXNjV9C-SwdrsnOw@mail.gmail.com>
Subject: Re: [PATCHv2 net-next 5/5] net: move the nat function to nf_nat_ovs
 for ovs and tc
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org, davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>,
        netfilter-devel@vger.kernel.org
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

On Wed, Nov 23, 2022 at 1:52 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Tue, Nov 22, 2022 at 12:32:21PM -0500, Xin Long wrote:
> > --- a/net/netfilter/Makefile
> > +++ b/net/netfilter/Makefile
> > @@ -52,7 +52,7 @@ obj-$(CONFIG_NF_CONNTRACK_SANE) += nf_conntrack_sane.o
> >  obj-$(CONFIG_NF_CONNTRACK_SIP) += nf_conntrack_sip.o
> >  obj-$(CONFIG_NF_CONNTRACK_TFTP) += nf_conntrack_tftp.o
> >
> > -nf_nat-y     := nf_nat_core.o nf_nat_proto.o nf_nat_helper.o
> > +nf_nat-y     := nf_nat_core.o nf_nat_proto.o nf_nat_helper.o nf_nat_ovs.o
>
> Considering that the code in nf_nat_ovs is only used if ovs or act_ct
> are enabled, shouldn't it be using an invisible knob here that gets
> automatically selected by them? Pablo?
It's good to not build it if no place is using it.
Making nf_nat_ovs a module might be too much.
If it's okay to Netfilter devel, I will change to use "ifdef" in Makefile:

+ifdef CONFIG_OPENVSWITCH
+nf_nat-y += nf_nat_ovs.o
+else ifdef CONFIG_NET_ACT_CT
+nf_nat-y += nf_nat_ovs.o
+endif
+

Thanks.

>
> I think this is my last comment on this series. The rest LGTM.
>
> >
> >  obj-$(CONFIG_NF_LOG_SYSLOG) += nf_log_syslog.o
> >
