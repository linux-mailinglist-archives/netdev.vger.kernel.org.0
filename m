Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAAE4564268
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 21:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbiGBTMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 15:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbiGBTMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 15:12:00 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A94A7E0C3;
        Sat,  2 Jul 2022 12:11:59 -0700 (PDT)
Date:   Sat, 2 Jul 2022 21:11:56 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Hugues ANGUELKOV <hanguelkov@randorisec.fr>
Cc:     netdev@vger.kernel.org, security@kernel.org, kadlec@netfilter.org,
        fw@strlen.de, davy <davy@randorisec.fr>, amongodin@randorisec.fr,
        kuba@kernel.org, torvalds@linuxfoundation.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v1] netfilter: nf_tables: fix nft_set_elem_init heap
 buffer overflow
Message-ID: <YsCYfBSobCXxy7Ok@salvia>
References: <271d4a36-2212-5bce-5efb-f5bad53fa49e@randorisec.fr>
 <YsCVB2Jh8d6mM6f7@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YsCVB2Jh8d6mM6f7@salvia>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 02, 2022 at 08:57:14PM +0200, Pablo Neira Ayuso wrote:
> On Sat, Jul 02, 2022 at 07:59:11PM +0200, Hugues ANGUELKOV wrote:
> > From d91007a18140e02a1f12c9627058a019fe55b8e6 Mon Sep 17 00:00:00 2001
> > From: Arthur Mongodin <amongodin@randorisec.fr>
> > Date: Sat, 2 Jul 2022 17:11:48 +0200
> > Subject: [PATCH v1] netfilter: nf_tables: fix nft_set_elem_init heap buffer
> >  overflow
> > 
> > The length used for the memcpy in nft_set_elem_init may exceed the bound
> > of the allocated object due to a weak check in nft_setelem_parse_data.
> > As a user can add an element with a data type NFT_DATA_VERDICT to a set
> > with a data type different of NFT_DATA_VERDICT, then the comparison on the
> > data type of the element allows to avoid the comparaison on the data length
> > This fix forces the length comparison in nft_setelem_parse_data by removing
> > the check for NFT_DATA_VERDICT type.
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220702021631.796822-1-pablo@netfilter.org/

For the record, pull request is already available with pending fixes
for net.

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220702191029.238563-1-pablo@netfilter.org/
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220702191029.238563-2-pablo@netfilter.org/
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220702191029.238563-3-pablo@netfilter.org/
