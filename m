Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F254BAD2C
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 00:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiBQXVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 18:21:07 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:47762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiBQXVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 18:21:05 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE96C3BF97;
        Thu, 17 Feb 2022 15:20:41 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id ay7so1239964oib.8;
        Thu, 17 Feb 2022 15:20:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ai+S7fak2GpHEP1+ZJ/XH67hAGPIunh/6iFam+VXIR4=;
        b=WXnldF+HgnpqmattPhjw2ozOwOwXqg+UG24zGFcMh2/wj2hlG6s+uSSVdrH6frdUZy
         uPV0eqRWMURcfnRIOaTUiKGmPFYgrIp90xMvylOhiKSagB88BKtZWtYBu8ZTp5mZa3/e
         4U5oSPpE8XJZP9Pc7cETJZ1djXKf8nW3UMHsHEhrfcIkEG5DxSO3Z7czsaMYt/F5Ucgx
         ifFYhMzPvVt85Yb9eWT20o1DdFnHQNx3DII3TlfF6JKY8kjmpEIEDy/IoInCLrmT7IP4
         XKetc8U8aIILQoUF8F3KDAfMAof8Wp/7+K3nCRtBNmk4yc8sUCRZkQ0EmX8KXjGmA/ox
         wRMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ai+S7fak2GpHEP1+ZJ/XH67hAGPIunh/6iFam+VXIR4=;
        b=JGBHcUbn5wN7AR/2HDjbmF2IYJmafGqTX1i9qYVdg+lyLTcggVWe9P3ggRdk7xiubR
         APj0D+E3RfKjGHzGbBnFG6DFNSItedZSWR2oE55c18rF/9Ug9i9IU3tZX5uq+W2MXKAT
         7hezY01MI27pyMTXfn4MB8NVJvo0Wt03UmGKlUzNOl2OX/jTLtjO7Y3KmMmgMWLHrSvV
         NqZUe6QMKBK2ll9nTH5Wqsj2IeXtFE16MhbG28MU8VNZKYhGsVFRuWOEXIVTbeJl7a3/
         XT+k6pCzT1PWzdIsQRex7X/Zyy4plGa5d6WYxtiWm594Lwdt0BUOmeD6Q3J6pcj5B8SL
         ssRA==
X-Gm-Message-State: AOAM5301TtaHO1t+tX2JSnsT/iA1mHx8DYkl3tOPWqrEemfxNQ5Lzc10
        i9cIb+KmYskZe1yApZrEqwA=
X-Google-Smtp-Source: ABdhPJyjnm7RIpIuDLtW/Zrc/iR4QXpNLAqEnc2xzQSkzhEl+KuaCtR2gMStX0JbQhRNZMvTaSaMxA==
X-Received: by 2002:aca:eb41:0:b0:2ce:6a75:b7fe with SMTP id j62-20020acaeb41000000b002ce6a75b7femr2151058oih.197.1645139766519;
        Thu, 17 Feb 2022 15:16:06 -0800 (PST)
Received: from t14s.localdomain ([177.220.172.100])
        by smtp.gmail.com with ESMTPSA id q4sm598911otk.39.2022.02.17.15.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 15:16:06 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 0143F16773D; Thu, 17 Feb 2022 20:16:03 -0300 (-03)
Date:   Thu, 17 Feb 2022 20:16:03 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>, davem@davemloft.net,
        Jiri Pirko <jiri@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>, coreteam@netfilter.org
Subject: Re: [PATCH net 1/1] net/sched: act_ct: Fix flow table lookup failure
 with no originating ifindex
Message-ID: <20220217231603.st6tjefagkp636vq@t14s.localdomain>
References: <20220217093424.23601-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217093424.23601-1-paulb@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 11:34:24AM +0200, Paul Blakey wrote:
> After cited commit optimizted hw insertion, flow table entries are
> populated with ifindex information which was intended to only be used
> for HW offload. This tuple ifindex is hashed in the flow table key, so
> it must be filled for lookup to be successful. But tuple ifindex is only
> relevant for the netfilter flowtables (nft), so it's not filled in
> act_ct flow table lookup, resulting in lookup failure, and no SW
> offload and no offload teardown for TCP connection FIN/RST packets.
> 
> To fix this, allow flow tables that don't hash the ifindex.
> Netfilter flow tables will keep using ifindex for a more specific
> offload, while act_ct will not.
> 
> Fixes: 9795ded7f924 ("net/sched: act_ct: Fill offloading tupledx")

The fixes tag got corrupted. It should have been:
Fixes: 9795ded7f924 ("net/sched: act_ct: Fill offloading tuple iifidx")

Not sure if it needs a respin or not, but:
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> ---
