Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A652464ABC2
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 00:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbiLLXrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 18:47:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbiLLXr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 18:47:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD911CB01;
        Mon, 12 Dec 2022 15:47:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE8F8611C2;
        Mon, 12 Dec 2022 23:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B40AC433EF;
        Mon, 12 Dec 2022 23:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670888845;
        bh=J2zDtlm/ALtvFqZGZbzpV/1roC/oaCDFbTYkcBWFjao=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GlKr5knLODLMCPriZ4DhxaSM7p9TnhDc7WBNutZUOhsO2CTFN6WFxTpNK4Vn9dGVI
         0YsprihGpgL2Otpt/BLFU3FiJuvcyUtDxlFhy8dGmUaVPe1NyOvD5C4gb2rzpAhIAD
         lA6RBH+fSw8PkFx8TidrYn/YFqXmNrqh1mxeeV0r+wgerhDwbKZoEvTfmuqhIUXbzS
         UCv9//P+T+Ql7yWVRtyAkV2GvfhDanesR1tQJpqfAbQzE7LhbCS8YxqGtgUIWaABxi
         4ZmReZXB3p7lye2JGOLjZXWprKZJp/Z+jKiFQZieyz1jLixOkKYOjwQr/PxL9tRahC
         y2qXPKHl+j8xQ==
Date:   Mon, 12 Dec 2022 15:47:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: Re: [Patch net-next v4 00/13] net: dsa: microchip: add PTP support
 for KSZ9563/KSZ8563 and LAN937x
Message-ID: <20221212154723.4a7cebcf@kernel.org>
In-Reply-To: <20221212102639.24415-1-arun.ramadoss@microchip.com>
References: <20221212102639.24415-1-arun.ramadoss@microchip.com>
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

On Mon, 12 Dec 2022 15:56:26 +0530 Arun Ramadoss wrote:
> KSZ9563/KSZ8563 and  LAN937x switch are capable for supporting IEEE 1588 PTP
> protocol.  LAN937x has the same PTP register set similar to KSZ9563, hence the
> implementation has been made common for the KSZ switches.  KSZ9563 does not
> support two step timestamping but LAN937x supports both.  Tested the 1step &
> 2step p2p timestamping in LAN937x and p2p1step timestamping in KSZ9563.
> 
> This patch series is based on the Christian Eggers PTP support for KSZ9563.
> Applied the Christian patch and updated as per the latest refactoring of KSZ
> series code. The features added on top are PTP packet Interrupt
> implementation based on nested handler, LAN937x two step timestamping and
> programmable per_out pins.

The merge window has now begun, this set is rather large and Linus said
that he will be particularly strict about applying patches late:

https://lore.kernel.org/all/CAHk-=wj_HcgFZNyZHTLJ7qC2613zphKDtLh6ndciwopZRfH0aQ@mail.gmail.com/

So let's defer this for after 6.2-rc1 is cut. Feed free to switch to
RFC postings if you want to keep revising the set and make review
progress during the merge window.
