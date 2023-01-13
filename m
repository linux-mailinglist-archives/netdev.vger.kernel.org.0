Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 722F766A3B7
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 20:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjAMTyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 14:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjAMTyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 14:54:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB9F87932;
        Fri, 13 Jan 2023 11:54:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 20FCFCE20C2;
        Fri, 13 Jan 2023 19:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6553C433EF;
        Fri, 13 Jan 2023 19:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673639650;
        bh=o/jt4K1pvhBiN+jx25cKLJjAvfIhQnIB1JmYnMtWFc0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bNP5c8f4aTCQD81HSgG75FoQJyMLmrSyhC/YNRNGbEHwD0SsWjm3yFN2KJPaJClMl
         94cLmSemCH6fUri3EM0YX90m0e6cLwKmCjiYC8H98h0UlIRo1re/dMxtAq8tLcTiA7
         IaBn/rjnxaoD60jNknefdfvf6Gf+NrrpfrfRTrn97aPJ4fPUyw3yYuqiHszzi5qjp7
         sywRilHJEh8W1PBk6y49rku2oikDsvKPcMb5gIRSXYY0J1cbwFWcqAiy3FG9JQbnYI
         JXAox9U/jXLWAe1Fh+nNqQpEXQs/rm1GLIg7mIYBnmYcDCFVIMQuvf/YY27Afq6v/8
         q2A5xykM8KGPQ==
Date:   Fri, 13 Jan 2023 11:54:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc:     Greg KH <greg@kroah.com>, Andre Przywara <andre.przywara@arm.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] r8152; preserve device list format
Message-ID: <20230113115408.741150b8@kernel.org>
In-Reply-To: <874jsu68og.fsf@miraculix.mork.no>
References: <87k01s6tkr.fsf@miraculix.mork.no>
        <20230112100100.180708-1-bjorn@mork.no>
        <Y7/dBXrI2QkiBFlW@kroah.com>
        <87cz7k6ooc.fsf@miraculix.mork.no>
        <878ri86o6j.fsf@miraculix.mork.no>
        <Y7/ir/zcJQUVec72@kroah.com>
        <874jsu68og.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Jan 2023 11:16:47 +0100 Bj=C3=B8rn Mork wrote:
> There is no point backporting to anything older than v5.15 since the
> patch depend on significant driver changes between v5.10 and v5.15.  The
> good news is that those changes also modified the macro in question so
> any device ID patch for v5.10 or older will have to be fixed up in any
> case.  So we don't lose anything by ignoring the older longterm kernels
> here.
>=20
> IIUC the special netdev stable rules are gone.  But if this is going to
> stable, then I believe it still has to go to "net" first.
>=20
> David/Jakub - Would you please pick
>=20
>   ec51fbd1b8a2 ("r8152: add USB device driver for config selection")
>   69649ef84053 ("cdc_ether: no need to blacklist any r8152 devices")
>=20
> from net-next to net?  With a "CC: stable" preferably.  Or do you prefer
> some other solution?

Well.. we already shipped the patch from this thread as is to Linus.
Greg will be able to take be53771c87f4 into stable directly, with=20
no dependencies.

And now the refactoring won't cherry-pick cleanly :(
Maybe let's leave it be?

I'll keep in mind that Greg is okay with taking this sort of
refactoring in in the future. I made an unnecessary commotion here.
