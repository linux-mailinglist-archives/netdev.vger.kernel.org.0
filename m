Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530E563B187
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 19:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbiK1SnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 13:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbiK1SnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 13:43:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C016BE2E;
        Mon, 28 Nov 2022 10:43:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C7236137F;
        Mon, 28 Nov 2022 18:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3F7C433C1;
        Mon, 28 Nov 2022 18:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669660992;
        bh=0xXqIHs0E79mxg8d6Dvbz5U88DL1tyI1mTmWHQ3xooU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qRFUjzuN6n31JCKERpQCaHM21qkNqvxx+KRKQkcIRC4yb//Mo7YPNYZ8GivbU/+i+
         5nRYBzazZyGeoQXr8gs+7mzPVQyCbF+vxs65rz4VzXvUk0YqCAWWTPTg4KnLvnbhR/
         72hVyk4MuAEvjNxAwwAUHqeIELDidjLZbM4ZmjgW03yvcQGppJEv5fdKvYBF62Gj2z
         rwO2Shcf4mg8IINpEQ2MSv7kAY40g2Apb1DnoEwK0VfOupyZ5zva8SI+X5CDy+IH3v
         Wtn8HbLYJMAC19eE+uQUdYcYby6Uke8rsh1UzLNYumBRmsEkuPwhUJKNDuOoG8TIgf
         hTDPCyVKu6Cjw==
Date:   Mon, 28 Nov 2022 10:43:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] net: devlink: devlink_nl_info_fill: populate
 default information
Message-ID: <20221128104311.0de1c3c5@kernel.org>
In-Reply-To: <CAMZ6RqJ_rjbbwAfKzA3g2547D5vMke2KBnWCgBVmQqLcev1keg@mail.gmail.com>
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
        <20221122201246.0276680f@kernel.org>
        <CAMZ6RqJ8_=h1SS7WmBeEB=75wsvVUZrb-8ELCDtpZb0gSs=2+A@mail.gmail.com>
        <20221123190649.6c35b93d@kernel.org>
        <CAMZ6RqJ_rjbbwAfKzA3g2547D5vMke2KBnWCgBVmQqLcev1keg@mail.gmail.com>
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

On Thu, 24 Nov 2022 14:33:58 +0900 Vincent MAILHOL wrote:
> > I think 2/ is best because it will generalize to serial numbers while
> > 1/ will likely not. 3/ is a smaller gain.
> >
> > Jiri already plumbed thru the struct devlink_info_req which is on the
> > stack of the caller, per request, so we can add the bool / bitmap for
> > already reported items there quite easily.  
> 
> Sorry, let me clarify the next actions. Are you meaning that Jiri is
> already working on the bitmap implementation and should I wait for his
> patches first? Or do you expect me to do it?

Dunno if the question still stands but we already have 
struct devlink_info_req and can put the bitmap in it.
All drivers use devlink helpers to add attributes.
