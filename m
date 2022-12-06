Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D718643C20
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 05:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbiLFER1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 23:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiLFERY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 23:17:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1227BE0C0;
        Mon,  5 Dec 2022 20:17:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5ED856152C;
        Tue,  6 Dec 2022 04:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E529C433C1;
        Tue,  6 Dec 2022 04:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670300241;
        bh=4IePKNOkeFvyxrJoGNDmuHXxFvj5ECDITsn/SJbjTAI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yx/72mJCwQXBY0eaf49v8WmXRNWpzWSlOZM3GITsXbzzhmKZXqh6FCK0xVC9+mEqV
         k2bmpdxgKsRAQqHoUEfseH9NDHTNVphi2xp0EFhfpYRTB097Tjk+jXY1XyjxKBtpvO
         S7u1FhipHMbA2BD2Vgx9RA3JmMwbpWvj00lo8jP33XWlWdwLw1SMGyYEVFSb6iIA7D
         PMKw3djATRiUA3IRENTTJhCmfHNmKsjp3YiCysa1Ut8+WSunL9G6Woq1dntTpS2pcQ
         IjvEVSvlM5Ke+NBz34foDkRG4NaoDW99lMEVOkbRCgpIjiUoZAeZPTABSPLJPHgd0e
         ott7fA4vxRI7w==
Date:   Mon, 5 Dec 2022 20:17:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: pull-request: bluetooth 2022-12-02
Message-ID: <20221205201720.68199051@kernel.org>
In-Reply-To: <CABBYNZKhyTcAJkBt5pg4ymU530h5wie3OACU5HVX4dR37=1ZAw@mail.gmail.com>
References: <20221202213726.2801581-1-luiz.dentz@gmail.com>
        <20221202203226.6feab9f5@kernel.org>
        <CABBYNZKhyTcAJkBt5pg4ymU530h5wie3OACU5HVX4dR37=1ZAw@mail.gmail.com>
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

Sorry for the delay, looks like the list ate your email :S

On Fri, 2 Dec 2022 23:49:18 -0800 Luiz Augusto von Dentz wrote:
> > On Fri,  2 Dec 2022 13:37:26 -0800 Luiz Augusto von Dentz wrote:  
> > > bluetooth pull request for net:
> > >
> > >  - Fix regressions with CSR controller clones
> > >  - Fix support for Read Local Supported Codecs V2
> > >  - Fix overflow on L2CAP code
> > >  - Fix missing hci_dev_put on ISO and L2CAP code  
> >
> > Two new sparse warnings in btusb.c here, please follow up to fix those.
> 
> Do you have the logs somewhere?

Yes, but shouldn't matter, the output is actually quite messy. 
I recommend running:

  make W=1 C=1 path/to/file.o

and you'll see all the warnings.

> Or even better if you share the script you use to detect new sparse
> warning we can perhaps integrate in our ci.

Yes, yes, all our script are here:

https://github.com/kuba-moo/nipa/tree/master/tests

Build one is here:

https://github.com/kuba-moo/nipa/blob/master/tests/patch/build_allmodconfig_warn/build_allmodconfig.sh

It's relatively okay at catching build issues. But the output is messy,
as I said :(
