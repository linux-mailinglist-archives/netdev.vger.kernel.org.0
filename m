Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F896673EF2
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 17:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjASQfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 11:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjASQfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 11:35:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051134DBE2
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 08:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674146065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=83gZifSODMrXnGeBJGIfSYRxF8xPK+5wusNqboUpN7c=;
        b=V1zLKlLv+zLOc5XXNpkpoE2zIJzzBumhHY1UXTcTB37+LHwnWlPuTXXDIuK0AYIKCcYLh+
        fw3az9I6GIDtmpiWjT7rpfpY/rc9CELfS7gl1ldMoUEIAGeuA6X67oWo6JzwuL/eP6Ufpg
        wIe0b705BiUw378lrPH9SyuuI600B4k=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-437-R3Jh6yHkPmWLnwWRIeJjag-1; Thu, 19 Jan 2023 11:34:23 -0500
X-MC-Unique: R3Jh6yHkPmWLnwWRIeJjag-1
Received: by mail-ej1-f70.google.com with SMTP id hr22-20020a1709073f9600b0086ffb73ac1cso1960435ejc.23
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 08:34:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=83gZifSODMrXnGeBJGIfSYRxF8xPK+5wusNqboUpN7c=;
        b=Ntbs3AoU5up5BQ/JcyYmoYFP+fQYvhX81PZKAXTMjG5XR0y3WujuZOJMN+lY1XCjuT
         P9R2O2pc3/iVMD2yE117PqdBnmxFbDELXLgcLRAh7BHPTB14b+8rhsGnYTO8JxViBrIA
         PfrwLFNV1Ah+AIzX1vZYQq11f/G3HK+xuRYDbtSoJmV4qI3dzv/TTLNX65Q89mlB6tte
         VY1IJQWp7J+wDLBryS7ojKxggyzPww9wUraKT+nSlNn41jBIO4tR0uRrNvH6BJHmoTaC
         iDMSTCyGqh5nC4HaEMQLIADTci8qCful3Lkg+ZmA/dp7Shlx7oocUZD3Y1tVRpK/Gq/w
         PXfw==
X-Gm-Message-State: AFqh2koYuDeC/BWoO91RGa1Vyz6f6w7diuF8/hGfwYcUihcst3lKSIYA
        VF9uA1swkLHV7uSbwcvPzJbbkzb8QZLp/ztTnS0zxffJMfR+rmDd3BeQfOJSP0+TJSYJV2yCYYD
        eFICM5AJWNrfHN3Gm
X-Received: by 2002:a05:6402:27cf:b0:49a:23ce:2ab4 with SMTP id c15-20020a05640227cf00b0049a23ce2ab4mr14141931ede.42.1674146062667;
        Thu, 19 Jan 2023 08:34:22 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtFURTsd7LzLCGF/zWRlOaM4Z4wBWb8CHxX0rcunRtP3ZzIvLPFvjrbihzayp51CmQiNcIkug==
X-Received: by 2002:a05:6402:27cf:b0:49a:23ce:2ab4 with SMTP id c15-20020a05640227cf00b0049a23ce2ab4mr14141902ede.42.1674146062439;
        Thu, 19 Jan 2023 08:34:22 -0800 (PST)
Received: from localhost (net-37-179-25-230.cust.vodafonedsl.it. [37.179.25.230])
        by smtp.gmail.com with ESMTPSA id ec49-20020a0564020d7100b0049e249c0e56sm5021103edb.56.2023.01.19.08.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 08:34:21 -0800 (PST)
Date:   Thu, 19 Jan 2023 17:34:20 +0100
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Kyle Zeng <zengyhkyle@gmail.com>,
        shaozhengchao <shaozhengchao@huawei.com>,
        David Miller <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: Question: Patch:("net: sched: cbq: dont intepret cls results
 when asked to drop") may be not bug for branch LTS 5.10
Message-ID: <Y8lxDBaULPzZMIS1@dcaratti.users.ipa.redhat.com>
References: <4538d7d2-0d43-16b7-9f80-77355f08cc61@huawei.com>
 <CAM0EoM=rqF8K997AmC0VDncJ9LeA0PJku2BL96iiatAOiv1-vw@mail.gmail.com>
 <CAM0EoM=VwZWzz1n_y8bj3y44NKBmhnmn+HUHtHwBb5qcCqETfg@mail.gmail.com>
 <CADW8OBvNcMCogJsMJkVXw70PL3oGU9s1a16DOK+xqdnCfgQzvg@mail.gmail.com>
 <Y8fSmFD2dNtBpbwK@dcaratti.users.ipa.redhat.com>
 <CAM0EoMmhHns_bY-JsXvrUkRhqu3xTDaRNk+cP-x=O_848R0W3Q@mail.gmail.com>
 <Y8gXmjlFPZdcoSzW@dcaratti.users.ipa.redhat.com>
 <CAM0EoMkrfFqjfUbEK5dSmTMj8sseO=w4SJsp=8mLDpMcER5eug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoMkrfFqjfUbEK5dSmTMj8sseO=w4SJsp=8mLDpMcER5eug@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 12:00:57PM -0500, Jamal Hadi Salim wrote:

> On Wed, Jan 18, 2023 at 11:00 AM Davide Caratti <dcaratti@redhat.com> wrote:

[...] 

> > With HTB, CBQ, DRR, HFSC, QFQ and ATM it's possible that the TC classifier
> > selects a traffic class for a given packet and writes that pointer in 'res.class'.
> 
> It's their choice of how to implement.

[...] 

> If all goes well, it is a good pointer.

Oh, probably now I see - the assignment in .bind_class() does the magic.

[...]

> > well, the implementation of "goto_chain" actually abuses tcf_result:
> > since it's going to pass the packet to another classifier, it
> > temporarily stores a handle to the next filter in the tcf_result -
> > instead of passing it through the stack. That is not a problem, unless
> > a packet hits the max_reclassify_loop and a CBQ qdisc that dereferences
> > 'res.class' even with a packet drop :)
> >
> 
> The rule is tcf_results should be returning the results and execution
> state to the caller. The goto_chain maybe ok in this case.

it looks ok because the chain is another classifier that re-writes tcf_result
with its own res.class + res.classid. Maybe we should assess what happens
when no classifier matches the packet after a goto_chain (i.e. let's check
if res.class still keeps a pointer to struct tcf_proto). However, tcf_classify()
returns -1 (TC_ACT_UNSPECT) in this case: CBQ and other qdiscs already
ignore tcf_result here.
 
> BTW, I did create a patch initially when this issue surfaced but we
> needed to get something to net first. See attached. The proper way to
> do this is to have the small surgery that returns the errcode instead
> of verdict code and store TC_ACT_XXX in tcf_result (in place of errcode).

my 2 cents: I really would like to see a different skb drop reason for these
packets (currently they are accounted as SKB_DROP_REASON_QDISC_DROP like
regular qdisc drops [1][2]). 

thanks!

[1] https://elixir.bootlin.com/linux/latest/source/net/core/dev.c#L3886
[2] https://lore.kernel.org/netdev/Yt2CIl7iCoahCPoU@pop-os.localdomain/ 

-- 
davide

