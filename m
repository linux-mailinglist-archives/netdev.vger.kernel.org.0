Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A850758E200
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 23:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiHIVpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 17:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiHIVpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 17:45:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB7D459BD;
        Tue,  9 Aug 2022 14:45:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4564B8136E;
        Tue,  9 Aug 2022 21:45:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E815C433C1;
        Tue,  9 Aug 2022 21:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660081521;
        bh=BxV6es5XUO4R0NAkjmVm8NmpX0FBwuRIHZ0aOQhnu3w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FAusAI3FxlxEf4ofnn4IIzYt0ZKbrbg7l/FMG3dFglb0uPZILAHjRJp2nPHnL8wPL
         VeoaytK5xdadx2tanJlEgWC3QgjZnSeJUDURpTxZvpw+/1zq+tfsGrYnp4rEWwOhhX
         CBJXr4Xl81BXvvYuIqb/F/aRztA7JiezadBqqavZsmP8xK8VM5p0pFtVqm3gfifCNb
         Arc3WZiMOiz52O79poSdgb6ovkbDMQzpYQnQJ27sE6lUHTHvls0Imp+ohcbcNA9/Sd
         8r9A1gCNCisST7jM5D5NOkqQP6B6W8ZWG7SotkD3UbpvLlf0rmHQ+TXZASX8kO+/LE
         Pvj9XK/+R5OBg==
Received: by pali.im (Postfix)
        id E52F720B2; Tue,  9 Aug 2022 23:45:18 +0200 (CEST)
Date:   Tue, 9 Aug 2022 23:45:18 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Michal =?utf-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
Message-ID: <20220809214518.i6od5zbkmup76feb@pali>
References: <CAJ+vNU05_xH4b8DFVJLpiDTkJ_z9MrBFvf1gSz9P1KXy9POU7w@mail.gmail.com>
 <5914cae0-e87b-fb94-85dd-33311fc84c52@seco.com>
 <20220808210945.GP17705@kitsune.suse.cz>
 <20220808143835.41b38971@hermes.local>
 <20220808214522.GQ17705@kitsune.suse.cz>
 <53f91ad4-a0d1-e223-a173-d2f59524e286@seco.com>
 <20220809213146.m6a3kfex673pjtgq@pali>
 <CAJ+vNU3bFNRiyhV_w_YWP+sjMTpU28PsX=BTkT7_Q=79=yR1gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ+vNU3bFNRiyhV_w_YWP+sjMTpU28PsX=BTkT7_Q=79=yR1gg@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 09 August 2022 14:39:05 Tim Harvey wrote:
> I've been wondering the same as well which made me wonder what the
> history of the 'aliases' node is and why its not used in most cases in
> Linux. I know for the SOC's I work with we've always defined aliases
> for ethernet<n>, gpio<n>, serial<n>, spi<n>, i2c<n>, mmc<n> etc. Where
> did this practice come from and why are we putting that in Linux dts
> files it if it's not used by Linux?

U-Boot can modify on-the-fly Linux's DTB file when booting Linux kernel.
For example it can put permanent MAC address into ethernet nodes from
U-Boot env. Similarly it can modify other DT nodes.

So even when Linux itself does not use particular alias, it is used by
the bootloader.
