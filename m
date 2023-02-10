Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0FD6916B2
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 03:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjBJCc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 21:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbjBJCc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 21:32:26 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65C970946
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 18:32:24 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id cw4so2736069qvb.6
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 18:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3JMfxbGsypE0nIJtw9gKpjMRitaNPth/fyxGeBqJa+4=;
        b=OLeoq6Ss2J94TUnpaZhDFxQ9Rai3rG6yYKZvYJDe1kH2IEXt9z+DiARbXzFs5yDnE1
         dgO6uTbET2O2whxQu0Jkd3wMdyp5sfQ7f0yunYL5gpjR7ZKn+8J23hZyXUjWneV8AERg
         YExhEPGNTUDpCIboc33p1WDnv38ZZffKOCF40e7sS2OBfIr2mQ9S2x/1zaSnGIWOKpzc
         mID9Njy2bscPgfrEgYYivfylzk3XztAoGzA/LjV2CN9+Aj+NtwKRvnD7hrj1c3IEwkf6
         ezeKDUzt7vu5PVZnGe73ma75reAoDvf2AKCRVMFLLB+BH/spz6wyXKc1a42SaYZjzYuz
         xCRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3JMfxbGsypE0nIJtw9gKpjMRitaNPth/fyxGeBqJa+4=;
        b=pEiIC4XwXVx8wdmROhWqVNFNYV62wCQBX0+F4NAPgcA0KIPTpvtjARmCqIZ8TR7lW/
         mWcntzz9u4wF0SI3bRDYWyoNg33BESWcJNy+19PfYnbGypEV6Uc3az8fpE96aw5TSHCh
         s2BizdKFAc+3Sft9hmezK+Ca8HLt0cMMheqHb+lCrD06VesR/V7nNIS5LOmzxGVrlXr/
         RbKXG4QbiJFl8pd2ovZOmgGai5lItTGYlntMeRif/9le7lqTBp0zSd4bsKkJnv19M+Pc
         l5qp5ZI6fXn3UmQQgEmWsPGeGD8NjytqexTMNimCHcEhdM7v7Z+6NwEq2MQRq2YP9msB
         XIoQ==
X-Gm-Message-State: AO0yUKVuzztV1yzZUgfYjgLXceab+c8XymBQ8cDRObOKVJr/1+Ibdopj
        FpZIQ8SJ8D+TdJ6YKcMhODc=
X-Google-Smtp-Source: AK7set+oKeSWT0U1AivFLjzsPir/IEcXo7OYunkl79WANtaR4oHZq4+uD+Q7NssBKwAmpVDliXp7hA==
X-Received: by 2002:a05:6214:e62:b0:56e:8a00:f1a with SMTP id jz2-20020a0562140e6200b0056e8a000f1amr4330605qvb.14.1675996343828;
        Thu, 09 Feb 2023 18:32:23 -0800 (PST)
Received: from t14s.localdomain (rrcs-24-43-123-84.west.biz.rr.com. [24.43.123.84])
        by smtp.gmail.com with ESMTPSA id z6-20020a376506000000b0071c535f3ff3sm2646008qkb.6.2023.02.09.18.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 18:32:23 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 965104C1ECE; Thu,  9 Feb 2023 18:32:22 -0800 (PST)
Date:   Thu, 9 Feb 2023 18:32:22 -0800
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH  net-next v3 4/9] net/sched: introduce flow_offload
 action cookie
Message-ID: <20230210023222.qsycaheyozpe2rfm@t14s.localdomain>
References: <20230206135442.15671-1-ozsh@nvidia.com>
 <20230206135442.15671-5-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206135442.15671-5-ozsh@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 03:54:37PM +0200, Oz Shlomo wrote:
> Currently a hardware action is uniquely identified by the <id, hw_index>
> tuple. However, the id is set by the flow_act_setup callback and tc core
> cannot enforce this, and it is possible that a future change could break
> this. In addition, <id, hw_index> are not unique across network namespaces.
> 
> Uniquely identify the action by setting an action cookie by the tc core.
> Use the unique action cookie to query the action's hardware stats.
> 
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
