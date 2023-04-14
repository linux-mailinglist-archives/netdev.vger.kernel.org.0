Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDF16E265C
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 17:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbjDNPA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 11:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbjDNPAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 11:00:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2140A93CE
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 08:00:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C359623EE
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 15:00:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82190C433D2;
        Fri, 14 Apr 2023 15:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681484452;
        bh=F6mnkucNTmoaPae769gad7U7f5GnN1CHWsquDOiat3U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Uh1lmT44Cl8fJDrdQueGT+fHeBC5rd5NttJkCT+FPckfs+Mtb5kX9h7DQ1TaAHbHI
         8lM2Oq8lfhh1hI9RxZgbwkFzInaq6H6k5jgJZzDNPxwsOW1y7zKzOT0V99U1Q+lb3U
         GqeYHV2my3hHxnxYeg4+4Dip+OZD/b80mOLW1FgQplHo6h/op1DVDiMzFVvz3IkF3n
         VJ/Pb7umX+d/3F1AbYmwpuCsGWkwjWoqbL4zSPgDIgvftpoZb6C02Tntzs1qOhRQeZ
         O69d3+8JzgNLF99iBUCm4HAo9iyD2b7nZd53HVSG23Nl9Gc+nNUC3FrgnXEIAaUqSQ
         pHmXsj7I3b9Nw==
Date:   Fri, 14 Apr 2023 08:00:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <sd@queasysnail.net>, <netdev@vger.kernel.org>, <leon@kernel.org>
Subject: Re: [PATCH net-next v5 5/5] macsec: Don't rely solely on the dst
 MAC address to identify destination MACsec device
Message-ID: <20230414080051.004e2a67@kernel.org>
In-Reply-To: <20230413105622.32697-6-ehakim@nvidia.com>
References: <20230413105622.32697-1-ehakim@nvidia.com>
        <20230413105622.32697-6-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Apr 2023 13:56:22 +0300 Emeel Hakim wrote:
> +			struct macsec_rx_sc *rx_sc = (md_dst && md_dst->type == METADATA_MACSEC) ?
> +						     find_rx_sc(&macsec->secy,
> +								md_dst->u.macsec_info.sci) : NULL;

Just a coding nit, in addition to Subbaraya's question:
why use a ternary operator if the entire expression ends up being 
3 lines of code? :| And well above 80 char.
