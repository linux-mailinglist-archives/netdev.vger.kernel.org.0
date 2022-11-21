Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C179C632D2D
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbiKUTpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiKUTpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:45:40 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7441CFE9D;
        Mon, 21 Nov 2022 11:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
        Cc:To:From:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HN21k88BYPW1IXLLNQAyuv3uXPjyMHl4EerDCx5rTIw=; b=ciQVnzPeChYZY2d0235iiTvSdi
        c8MR22HaUxDx84Rs3LamdRvRvSu+9bt3tbvHGrpPBOP22b57oPgy/+phkeftG+l0TLTjcX1V98Q/F
        Nrv2sSd3Cw4Sc8OTikN0eZFwV1fDi49wGoOi+gPBbBaXcr4lPArEXU5F6nWq6r3S0NnU=;
Received: from p200300daa7225c007502151ad3a4cf6f.dip0.t-ipconnect.de ([2003:da:a722:5c00:7502:151a:d3a4:cf6f] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1oxCjD-003axr-3p; Mon, 21 Nov 2022 20:45:15 +0100
Message-ID: <3a9c2e94-3c45-5f83-c703-75e1cde13be1@nbd.name>
Date:   Mon, 21 Nov 2022 20:45:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH] netfilter: nf_flow_table: add missing locking
Content-Language: en-US
From:   Felix Fietkau <nbd@nbd.name>
To:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221121182615.90843-1-nbd@nbd.name>
In-Reply-To: <20221121182615.90843-1-nbd@nbd.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.11.22 19:26, Felix Fietkau wrote:
> nf_flow_table_block_setup and the driver TC_SETUP_FT call can modify the flow
> block cb list while they are being traversed elsewhere, causing a crash.
> Add a write lock around the calls to protect readers
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
Sorry, I forgot to add this:

Reported-by: Chad Monroe <chad.monroe@smartrg.com>

- Felix
