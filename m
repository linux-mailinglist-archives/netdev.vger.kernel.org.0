Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83B669FDBE
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 22:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbjBVVej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 16:34:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjBVVei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 16:34:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DE32DE53;
        Wed, 22 Feb 2023 13:34:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5860B818A2;
        Wed, 22 Feb 2023 21:34:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EED2C433D2;
        Wed, 22 Feb 2023 21:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677101675;
        bh=CsVy79cWb4ilZv2F3gdcYfg94pzPlq0ZjoazIarr1NQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SnW0Ti6YhlWJWpdQgI5B51L/1/ih1y9iVA9WBcgW0RBVU8TNKw4LDphn+UxWpcjxe
         1lhCMXV14eT/Cn1NMIHUYwQpg6kE07VUA7J6KPhxCtCSvIIoSI1Dofl2Tb1pZexOkB
         Wu81OPIIvrvf2FYSLVU3IQAcyA8+1yYeRC37fh5kwW4PQUGnUlG8V9q+jJsczGKE7b
         Gv0ahx8wGTYtdia5kLB/LvT0XrgYvbq9eELvOxO0TeeYnFZWy8cc8+pNJaTrCZZBTX
         680VDdI3PH8+tsvFZPYqU7xqORGqtjdgtuE6rsNF93hSKpJsKnUuOYIznvgIYJJghE
         ADtix5Z/VNHlA==
Date:   Wed, 22 Feb 2023 13:34:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bruno Goncalves <bgoncalv@redhat.com>
Cc:     Manish Chopra <manishc@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        Alok Prasad <palok@marvell.com>
Subject: Re: [EXT] Re: RIP: 0010:qede_load+0x128d/0x13b0 [qede] - 5.19.0
Message-ID: <20230222133433.7b4b0e67@kernel.org>
In-Reply-To: <CA+QYu4pe47eYEUyEMC3n5iF2+qx30ff_duokWq-2z9b=UcpWzQ@mail.gmail.com>
References: <CA+QYu4qxW1BUcbC9MwG1BxXjPO96sa9BOUXOHCj1SLY7ObJnQw@mail.gmail.com>
        <20220802122356.6f163a79@kernel.org>
        <CA+QYu4ob4cbh3Vnh9DWgaPpyw8nTLFG__TbBpBsYg1tWJPxygg@mail.gmail.com>
        <20220803083751.40b6ee93@kernel.org>
        <CA+QYu4poBJgXZ=RLTpQVxMeTX3HUSenWA7WZCcw45dzdGeyecg@mail.gmail.com>
        <20220818085106.73aabac2@kernel.org>
        <BY3PR18MB4612295606F0C22A1863FF44AB6D9@BY3PR18MB4612.namprd18.prod.outlook.com>
        <CA+QYu4pe47eYEUyEMC3n5iF2+qx30ff_duokWq-2z9b=UcpWzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Aug 2022 09:36:54 +0200 Bruno Goncalves wrote:
> We hit the panic by booting up the machine with a kernel 5.19.0 with
> debug flags enabled.

Hi Bruno,

Was this ever fixed?
