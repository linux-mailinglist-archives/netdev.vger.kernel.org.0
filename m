Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF226E4FD5
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 20:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjDQSEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 14:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbjDQSEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 14:04:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128B1C17F
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 11:04:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B23862919
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 18:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17558C433EF;
        Mon, 17 Apr 2023 18:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681754654;
        bh=8NTNvSn67aCIbKYF/K1DPCt1f5Z8I9B78RDJVJgyaug=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HCkE3HL9VXxuZNXUjZ7XoD5p3mL79bqt8/VlfoCXYOARryj8f72D1NQ4tibCGmwUu
         j4/a51ptOwfT3nJuMinR/GC++DAcgTc0JCxSi+Ph+/lQZuvgNzpYCfhEwEhXN4cB/J
         78Et1H7jfuDKYN3E3Hza6YPvVLaIoHQl8KxE32gRG0iGs7XFb8hbUnXbtGvG7uVsGI
         peALtp8HMh9rdJrgIF4LH9ESsCPJ+rX/eYam2YdzI0AsP5E1uY3cWmeBqh4baZ48oL
         +Y1bliEL/9313ieZfMyQpRwLOz7vyGbSDPdvFxzysZzy6edz63Sxxvk55lwwtMT7R2
         pZXQWI+gTwa2A==
Date:   Mon, 17 Apr 2023 11:04:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH net-next v5 5/5] macsec: Don't rely solely on the dst
 MAC address to identify destination MACsec device
Message-ID: <20230417110413.01f20f1e@kernel.org>
In-Reply-To: <IA1PR12MB63533E6FD3BE343E78ED60B9AB9F9@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20230413105622.32697-1-ehakim@nvidia.com>
        <20230413105622.32697-6-ehakim@nvidia.com>
        <20230414080051.004e2a67@kernel.org>
        <IA1PR12MB63533E6FD3BE343E78ED60B9AB9F9@IA1PR12MB6353.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 16 Apr 2023 12:18:05 +0000 Emeel Hakim wrote:
>  struct macsec_rx_sc *rx_sc = NULL;
> 
> if (md_dst && md_dst->type == METADATA_MACSEC) 
>         rx_sc  = find_rx_sc(&macsec->secy, md_dst->u.macsec_info.sci);
> 
> what do you think?

Yes, definitely.
