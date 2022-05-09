Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7ADD5203A3
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239676AbiEIRgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239666AbiEIRgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:36:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D7711AFD5;
        Mon,  9 May 2022 10:32:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68511B81897;
        Mon,  9 May 2022 17:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A803FC385B1;
        Mon,  9 May 2022 17:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652117538;
        bh=wbTfRTa1LYaVdf9Q0XCcxIfLxAm6dKGFkdpNVVBPAoY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UU+mNilnLYVA0ENPVmo3ioIjpztt9e95KvT5zQtLujRKbA1ajuEXBwbQFWi6OjrCj
         Wp5tN1zojmRyKh1DNm2NF0LMeqXC/SNO8znGn97Vzk61ZCXjIBg/jv67CDSbfistf/
         hyZ1QSrF40ZzChK5ovtHUhh9muy/8cFIINnvTwCrcQok+hvCdMHt+3VlX3pqaU9dAa
         /6KP5F0Uqg38k0Y9e0CD3NP/3lEWWJkpOSGCOJCsO4kOW2mAlrrcKkgasHs1IDoTWI
         6FBgM0mgyqzXkmQDp2hynYzPGDcqPzoj/BAgVWBSMc2T++BIcfj0rkCJRKpEKde7kS
         ztqKlBHCzM7TA==
Date:   Mon, 9 May 2022 10:32:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Doug Brown <doug@schmorgal.com>
Subject: Re: [PATCH net-next] net: appletalk: remove Apple/Farallon
 LocalTalk PC support
Message-ID: <20220509103216.180be080@kernel.org>
In-Reply-To: <CAK8P3a0FVM8g0LG3_mHJ1xX3Bs9cxae8ez7b9qvGOD+aJdc8Dw@mail.gmail.com>
References: <20220509150130.1047016-1-kuba@kernel.org>
        <CAK8P3a0FVM8g0LG3_mHJ1xX3Bs9cxae8ez7b9qvGOD+aJdc8Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 May 2022 19:14:42 +0200 Arnd Bergmann wrote:
> On Mon, May 9, 2022 at 5:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Looks like all the changes to this driver had been tree-wide
> > refactoring since git era begun. The driver is using virt_to_bus()
> > we should make it use more modern DMA APIs but since it's unlikely
> > to be getting any use these days delete it instead. We can always
> > revert to bring it back.
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>  
> 
> Removing this driver sounds good to me, your description makes sense
> and it gets us closer to completely removing virt_to_bus() in the future.
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> I think however, if we remove this driver, we need to discuss removing the
> last remaining localtalk driver (CONFIG_COPS) and possibly the localtalk
> bits in net/appletalk along with it.
> 
> Doug Brown suggested removing COPS last year for entirely different
> reasons[1] but never got a reply. I suppose that is a sign that nobody
> cared about the driver enough, but we should remove it. He also
> mentioned working on a new localtalk driver, though I don't think he
> posted that one yet.
> 
>        Arnd
> 
> [1] https://lore.kernel.org/netdev/6c62d7d5-5171-98a3-5287-ecb1df20f574@schmorgal.com/

Very interesting, thanks!

Removing COPS and appletalk makes perfect sense to me (minus what Doug
has plans to use, obviously).

I'm taking notes for "next steps" while trying to strategically cast 
a narrow net, hitting VIRT_TO_BUS only now.
