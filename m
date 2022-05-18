Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E08FB52B035
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 03:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbiERBuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 21:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiERBuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 21:50:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE5B546B9;
        Tue, 17 May 2022 18:50:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB40C615D2;
        Wed, 18 May 2022 01:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8C5C385B8;
        Wed, 18 May 2022 01:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652838637;
        bh=Wz2LeatRysIIJI6We7LTZk35ChDhAzJXX04vN/qest4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TGVIx8poRzlJHVepsNHLU+LI7vdlE3uI/EGCQGs68AHNEPcHNiyIRi9xqvOUgxDSh
         8YtnnmFYNiAAI+fsQvdph9190vDmT7ckoZMekUIrkysJj8nAFvYfuko9WkqjUrNLax
         UGZ82PgXyr+AZ+n6vzerg9OQ3swAIOrf2O2YmkeMEgFC8lmI3q1z2kbTDfsGwdVE9Z
         bgkv4d/4b0Bb5FsH5StZnYKHVmagO7ewylboCCuxWqqJhewHuYFOemXCthEEkW3We4
         pzoC9dkAWv57MUsrHY1xwB/bpnjDfCGLzWAtTrNKBx1Oi1Ml21qzhgE9c+PmZP7cbo
         xrzN003HEz9+A==
Date:   Tue, 17 May 2022 18:50:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin =?UTF-8?B?TGnFoWth?= <mliska@suse.cz>
Cc:     netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH] gcc: fix -Warray-compare
Message-ID: <20220517185035.4ee3dd8e@kernel.org>
In-Reply-To: <21708ede-f378-d20e-0b1d-410e946fcca5@suse.cz>
References: <21708ede-f378-d20e-0b1d-410e946fcca5@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 May 2022 16:19:16 +0200 Martin Li=C5=A1ka wrote:
> Subject: [PATCH] gcc: fix -Warray-compare

The subject should be more like

eth: sun: cassini: remove dead code

>=20
> Fixes the following GCC warning:
>=20
> drivers/net/ethernet/sun/cassini.c:1316:29: error: comparison between two=
 arrays [-Werror=3Darray-compare]
> drivers/net/ethernet/sun/cassini.c:3783:34: error: comparison between two=
 arrays [-Werror=3Darray-compare]

Because AFAICT this comparison will always be true:

#define CAS_HP_ALT_FIRMWARE   cas_prog_null

Hopefully DaveM will correct if I'm getting this wrong :)
