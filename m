Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1237E4D51EF
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 20:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235514AbiCJTnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 14:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbiCJTnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 14:43:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0042A10B1;
        Thu, 10 Mar 2022 11:42:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F913B825DB;
        Thu, 10 Mar 2022 19:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C37C340E8;
        Thu, 10 Mar 2022 19:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646941347;
        bh=o2oq2iURysJp7VA+2RW3Vyxnb1sOQqomJ/8Z78qsCCs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oG3ZGls9dS5FKnvarb2XL8mdBVsTguTIrfp2Aa7HexYggGatcX31sBwmZR5xcxsIk
         XwVodprW5BpDPxvodLkVMNKDuLLUkeMqdmQYsvZPg+9JMAY8fZPT7Km6fHVv/ZnRwk
         dBTVMxo7imDxijR/eqCfBM9vz4kJYQMovctRRKOawT3j73SugTO3/UUXT3/twsH0VD
         vdI1sV2wFCPfy4igUymXIcltmYvkDCJr69OFTH9YzK+1qyAQaoLUXVSiiXkoYSl684
         LI9pztBt73T4lcsHlRIEd3lhQZOZSKYWxTduwot61Dk5wETNaMpVvNZtswG98syze2
         fFWdyDepxXM+w==
Date:   Thu, 10 Mar 2022 11:42:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ariel Elior <aelior@marvell.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Manish Chopra <manishc@marvell.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alok Prasad <palok@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "it+netdev@molgen.mpg.de" <it+netdev@molgen.mpg.de>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: [EXT] Re: [PATCH v2 net-next 1/2] bnx2x: Utilize firmware
 7.13.21.0
Message-ID: <20220310114226.67bc1105@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <PH0PR18MB465582071EDA502A96E57096C40B9@PH0PR18MB4655.namprd18.prod.outlook.com>
References: <20211217165552.746-1-manishc@marvell.com>
        <ea05bcab-fe72-4bc2-3337-460888b2c44e@molgen.mpg.de>
        <BY3PR18MB46129282EBA1F699583134A4AB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
        <e884cf16-3f98-e9a7-ce96-9028592246cc@molgen.mpg.de>
        <BY3PR18MB4612BC158A048053BAC7A30EAB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
        <CAHk-=wjN22EeVLviARu=amf1+422U2iswCC6cz7cN8h+S9=-Jg@mail.gmail.com>
        <BY3PR18MB4612C2FFE05879E30BAD91D7AB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
        <CAHk-=whXCf43ieh79fujcF=u3Ow1byRvWp+Lt5+v3vumA+V0yA@mail.gmail.com>
        <20220310105232.66f0a429@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR18MB465582071EDA502A96E57096C40B9@PH0PR18MB4655.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Mar 2022 19:14:14 +0000 Ariel Elior wrote:
> Jackub, assuming former, we won't be able to provide anything in a couple of hours
> (already past midnight in Manish's part of the world).

No worries, I can take care of it myself, given the short notice.
