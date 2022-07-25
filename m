Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD07857FEDD
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 14:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiGYMUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 08:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiGYMUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 08:20:31 -0400
Received: from smtpout140.security-mail.net (smtpout140.security-mail.net [85.31.212.149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181CD6316
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 05:20:29 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by fx409.security-mail.net (Postfix) with ESMTP id 540B0323914
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 14:20:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalray.eu;
        s=sec-sig-email; t=1658751627;
        bh=GlBuXQiyqqsn18a32BzZ1rOEpXiDEPVNqA8AL9a7lTQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=YY/4s2oNJi/Eh94Ya//H0fj+7eiEjleQIdhSwpNkjdDptI3cXJeKyHtJboRMkt6qv
         18st1KIX4ohK041nR3IDoxn2Xnmp9jiYixgY+E6p69KL+RytD1/MwYG6QHnhSFIJWZ
         3+dPJo4cKHRiTExYnJ3BsqFsEEqhmch7TCi7yFn0=
Received: from fx409 (localhost [127.0.0.1]) by fx409.security-mail.net
 (Postfix) with ESMTP id A68BA3238F9; Mon, 25 Jul 2022 14:20:26 +0200 (CEST)
Received: from zimbra2.kalray.eu (unknown [217.181.231.53]) by
 fx409.security-mail.net (Postfix) with ESMTPS id E4F72323896; Mon, 25 Jul
 2022 14:20:25 +0200 (CEST)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTPS id C308A27E04ED; Mon, 25 Jul 2022
 14:20:24 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1]) by zimbra2.kalray.eu
 (Postfix) with ESMTP id AB35C27E04EE; Mon, 25 Jul 2022 14:20:24 +0200 (CEST)
Received: from zimbra2.kalray.eu ([127.0.0.1]) by localhost
 (zimbra2.kalray.eu [127.0.0.1]) (amavisd-new, port 10026) with ESMTP id
 8vqviDVoLMbn; Mon, 25 Jul 2022 14:20:24 +0200 (CEST)
Received: from tellis.lin.mbt.kalray.eu (unknown [192.168.36.206]) by
 zimbra2.kalray.eu (Postfix) with ESMTPSA id 9884D27E04ED; Mon, 25 Jul 2022
 14:20:24 +0200 (CEST)
X-Virus-Scanned: E-securemail, by Secumail
Secumail-id: <4bd4.62de8a89.5a0c7.0>
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra2.kalray.eu AB35C27E04EE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalray.eu;
 s=32AE1B44-9502-11E5-BA35-3734643DEF29; t=1658751624;
 bh=FvGNLwkue8m7Scn+DYtd5NAx6wYs3ZxV5h3llxl7AcU=;
 h=Date:From:To:Message-ID:MIME-Version;
 b=d9S0iuj2IRT7Pfh3vSpYC2LkSoNZQ9t7WzbiYgBQA4vMW55LPSKMt7WEaPe7NRKgp
 BVIgV9C7wgkZsc5v9cBZEuCXB44GDprVs84a42EoKVsYBhzo3OzMozf0IvzbUZQSbs
 /x1tzukvuaxoIi0FIQhpIosREyuVIBuLVinU8fSE=
Date:   Mon, 25 Jul 2022 14:20:23 +0200
From:   Jules Maselbas <jmaselbas@kalray.eu>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: ethtool generate a buffer overflow in strlen
Message-ID: <20220725122023.GB9874@tellis.lin.mbt.kalray.eu>
References: <20220722173745.GB13990@tellis.lin.mbt.kalray.eu>
 <20220722142942.48f4332c@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220722142942.48f4332c@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-ALTERMIMEV2_out: done
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 02:29:42PM -0700, Jakub Kicinski wrote:
> On Fri, 22 Jul 2022 19:37:46 +0200 Jules Maselbas wrote:
> > There is suspicious lines in the file drivers/net/ethernet/freescale/enetc/enetc_ethtool.c:
> >    { ENETC_PM0_R1523X, "MAC rx 1523 to max-octet packets" },
> > and:
> >    { ENETC_PM0_T1523X, "MAC tx 1523 to max-octet packets" },
> > 
> > Where the string length is actually greater than 32 bytes which is more
> > than the reserved space for the name. This structure is defined as
> > follow:
> >     static const struct {
> >         int reg;
> >         char name[ETH_GSTRING_LEN];
> >     } enetc_port_counters[] = { ...
> > 
> > In the function enetc_get_strings(), there is a strlcpy call on the
> > counters names which in turns calls strlen on the src string, causing
> > an out-of-bound read, at least out-of the string.
> > 
> > I am not sure that's what caused the BUG, as I don't really know how
> > fortify works but I thinks this might only be visible when fortify is
> > enabled.
> > 
> > I am not sure on how to fix this issue, maybe use `char *` instead of
> > an byte array.
> 
> Thanks for the report!
Thanks for the replie :)

> I'd suggest to just delete the RMON stats in the unstructured API
> in this driver and report them via
>  
> 	ethtool -S eth0 --groups rmon
I am not familiar with ethtool: I don't understand what you're
suggesting. Would you mind giving some hints/links to what RMON stats
are?


> No point trying to figure out a way to make the old API more
> resilient IMO when we have an alternative.
I was not thinking of changing the API but simply the structure to use
a string pointer instead of an array, this will make strings in the
enetc_port_counters properly nul terminated.
However the name will still be truncated when copied by the _get_strings
function... but it will not BUG on strlen.

Best,
Jules




