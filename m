Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300715BECEB
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 20:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiITShy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 14:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiITShs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 14:37:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187F57435C;
        Tue, 20 Sep 2022 11:37:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6B07B82C38;
        Tue, 20 Sep 2022 18:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E266C433D7;
        Tue, 20 Sep 2022 18:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663699065;
        bh=EevUVUgTemyy3pi8j8ML87dKQSxdA/iB4mYtejbDRq0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NZrnrzs1qBSwaZv0mI50czcHyki7jpYOdd78bggNqjhQzQ6u1bR26pt4bEtVHWbRz
         ZbYKiVRpt9bJn4eN+/7b8Nz621xorekXabXN0ZinEZsCaHwXqSInfuG4IoUlXX/ILP
         QWjMg8SGk0HTxTDZcsrC067+W2Zpz2/ja3SK7Tb9SIR/ICHf2Je5Y6nwkEmJrKMlo4
         f4E5/pjIhJIVgzmp4aSb3/iVBltdFQ5dvrIe5yrqU2w6C7GTWfVqEKuu2fXwLEJnzI
         /E9YoEub4LkBeSzTDWdLd+j/7+MWWUpPueh2y9R2GgJNsq5TeSAky3p4bzMgjHyt5d
         ZXZlX2s9zz+og==
Date:   Tue, 20 Sep 2022 11:37:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Li Zhong <floridsleeves@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, edumazet@google.com, davem@davemloft.net
Subject: Re: [PATCH v1] net/ethtool/tunnels: check the return value of
 nla_nest_start()
Message-ID: <20220920113744.64b16924@kernel.org>
In-Reply-To: <20220917022602.3843619-1-floridsleeves@gmail.com>
References: <20220917022602.3843619-1-floridsleeves@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Sep 2022 19:26:02 -0700 Li Zhong wrote:
>  			goto err_cancel_table;
>  
>  		entry = nla_nest_start(skb, ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY);
> +		if (!entry)
> +			return -EMSGSIZE;

not even correct, and completely harmless
