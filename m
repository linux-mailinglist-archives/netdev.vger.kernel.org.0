Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3184EFCA3
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 00:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353316AbiDAWLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 18:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353300AbiDAWLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 18:11:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F451760D4
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 15:09:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56CA9B82547
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 22:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE173C2BBE4;
        Fri,  1 Apr 2022 22:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648850950;
        bh=pe0F+3q4wDE0gLwS78p5nBauckLwro9IWzL6HfAPVvQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CMdmANje3nBvLa3t+Lrq/XKksZiVH7lubbfxQGgz1+da5alI5wdZ0KfhWx30PbgfJ
         CY6REZsFUVpmXOl8huoF2NJUKeYTmC1J27qsG/OhORvU97DQ1RU6OQEg/drsuRQuRA
         vscaJ/2jF6CEp7V4OuURREDbSkRzTCXVQ2ig8IzWh5SbqRebO5IOEP4a7Z9tN2x8mA
         77mO2NTL2KBUJKGwLDSKIoy6RJh0W1R5k1GfPg2ZlbFF2AJ74FmO2M9iEkjBlaO31w
         w2vZepHz77ukhljQsN+HaM1mIoVgTiwB99zZkVqum5DFqI2m1L0sC+eOPv8E0OdWBs
         WUSHAn1f+3qgQ==
Date:   Fri, 1 Apr 2022 15:09:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florent Fourcot <florent.fourcot@wifirst.fr>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        edumazet@google.com, Jiri Pirko <jiri@mellanox.com>,
        Brian Baboch <brian.baboch@wifirst.fr>
Subject: Re: [PATCH net v2] rtnetlink: enable alt_ifname for setlink/newlink
Message-ID: <20220401150908.356a0db3@kernel.org>
In-Reply-To: <1250f3a0-9ed3-cfad-ba93-6b16cad5dcf5@wifirst.fr>
References: <20220401153939.19620-1-florent.fourcot@wifirst.fr>
        <20220401104342.5df7349a@kernel.org>
        <1250f3a0-9ed3-cfad-ba93-6b16cad5dcf5@wifirst.fr>
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

On Fri, 1 Apr 2022 23:02:39 +0200 Florent Fourcot wrote:
> I don't really care about getting this into stable, so I will resubmit 
> for net-next when opened.
> Should I drop "Fixes" tag?

Yup! No fixes tag if it's going in to net-next.

> Alternatives ifname feature never worked for setlink/newlink,
> but 76c9ac0ee878 claimed it was.

I wonder what the story was there. I think it "works" in that ip link
accept altnames, but IIUC that's because it does a get first and
resolves the ifindex.
