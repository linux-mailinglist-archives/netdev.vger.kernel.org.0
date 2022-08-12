Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC4D5917B2
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 02:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbiHLX75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 19:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiHLX75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 19:59:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE64C74368
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 16:59:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CDDA616BF
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 23:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D08C433C1;
        Fri, 12 Aug 2022 23:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660348795;
        bh=ekDuZO7T2InUYiP3dxmK8ce4c0v56xjsxWFFpVmKd34=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Kha1BDfbFrsJS/IHCN+qEhQNsGlNK3icJG9iYHrkOBMFVWZ4STD/J3jw7Atx1OD+A
         EnmKqNjtVPY+p2acDotxrYmd9eabS+SYVWj4ytKI9DpeRcUUxXy16S6SiiDADRBgv9
         jb/iiE/DgdvH8MeANvxLITnUUzHxGzLAHg9Bgoy6TP7WFBnwVhzMWKTWA6FGavG8Av
         7LyV3RRnT3vrzTUEp6+E8fxsLqts3L/Zyvdqfcc/eZYUmFrWH/lE9sdEHG0AqWtA8y
         omkpFvl7jqU2mgspB85dcl6rzK7+nQmznCpb+X9o0Tk5aFkbOmLVafnTUzomkrVwq7
         3uutkYaBDCyIw==
Date:   Fri, 12 Aug 2022 16:59:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?Q3PDs2vDoXM=?= Bence <csokas.bence@prolan.hu>
Cc:     <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, <qiangqing.zhang@nxp.com>
Subject: Re: [PATCH] net: fec: Restart PPS after link state change
Message-ID: <20220812165954.50427baa@kernel.org>
In-Reply-To: <20220812115408.12985-1-csokas.bence@prolan.hu>
References: <20220812115408.12985-1-csokas.bence@prolan.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Aug 2022 13:54:09 +0200 Cs=C3=B3k=C3=A1s Bence wrote:
> On link state change, the controller gets reset,
> causing PPS to drop out and the PHC to lose its
> time and calibration. So we restart it if needed,
> restoring calibration and time registers.
>=20
> Changes since v2:
> * Add `fec_ptp_save_state()`/`fec_ptp_restore_state()`
> * Use `ktime_get_real_ns()`
> * Use `BIT()` macro
> Changes since v1:
> * More ECR #define's
> * Stop PPS in `fec_ptp_stop()`

nit: [PATCH net v3] net: fec: ...=20
would have been the perfect prefix here.

The patch doesn't seem to apply, it needs to go to this tree:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/

When you repost, please also CC Andrew since he was giving feedback=20
on the initial version.
