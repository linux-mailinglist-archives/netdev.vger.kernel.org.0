Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5110856C955
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 14:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiGIMJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 08:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGIMJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 08:09:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD762371BF;
        Sat,  9 Jul 2022 05:09:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D5C3B819D3;
        Sat,  9 Jul 2022 12:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23274C3411C;
        Sat,  9 Jul 2022 12:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657368550;
        bh=YO9kouytDckeiNed5/PCbASz81pBf9NT+av1kb0cQ1g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mPO8bNZxLY9r7WrCyVYilLh1vks62Uiw++D7pq2dWREbVaf+Jr+qUGtPD8UTZfnpZ
         a0EO3Huvk8UlObsL7KZvOWrJfbuQrzbd4fEpwAm4odVRmk4h3nygcu16dwChQKJGmI
         TkexGG9zpMyMDXpmwXkerfGhcZZLO2hZUNYaeHmzbND9XvDbI1aaiEUkgqrrV9edBs
         QQYXdsiiGdlbNcmzKQX2NlYr1IbPcZWlQjCqGRQn0xjJJfEJJlDmlveGR/83yhA3Fz
         TKzguVd5e1EQBtIRs+xmBGdBgcU0vH7VcYBBV4GEQ+bUEgOCiWrOKu9Q7PDAJI2t6L
         kKM+/GVUvBZHg==
Received: by pali.im (Postfix)
        id 18984AFA; Sat,  9 Jul 2022 14:09:07 +0200 (CEST)
Date:   Sat, 9 Jul 2022 14:09:06 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     James Carlson <carlsonj@workingcode.com>,
        Chris Fowler <cfowler@outpostsentinel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-ppp@vger.kernel.org" <linux-ppp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ppp: Add rtnl attribute IFLA_PPP_UNIT_ID for specifying
 ppp unit id
Message-ID: <20220709120906.ymkhn5diywadgrka@pali>
References: <20210811173811.GE15488@pc-32.home>
 <20210811180401.owgmie36ydx62iep@pali>
 <20210812092847.GB3525@pc-23.home>
 <20210812134845.npj3m3vzkrmhx6uy@pali>
 <20210812182645.GA10725@pc-23.home>
 <20210812190440.fknfthdk3mazm6px@pali>
 <20210816161114.GA3611@pc-32.home>
 <20210816162355.7ssd53lrpclfvuiz@pali>
 <20210817160525.GA20616@pc-32.home>
 <20210817162155.idyfy53qbxcsf2ga@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210817162155.idyfy53qbxcsf2ga@pali>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 17 August 2021 18:21:55 Pali Rohár wrote:
> On Tuesday 17 August 2021 18:05:25 Guillaume Nault wrote:
> > On Mon, Aug 16, 2021 at 06:23:55PM +0200, Pali Rohár wrote:
> > > On Monday 16 August 2021 18:11:14 Guillaume Nault wrote:
> > > > Do you have plans for adding netlink support to pppd? If so, is the
> > > > project ready to accept such code?
> > > 
> > > Yes, I have already some WIP code and I'm planning to send a pull
> > > request to pppd on github for it. I guess that it could be accepted,
> > 
> > I guess you can easily use the netlink api for cases where the "unit"
> > option isn't specified and fall back to the ioctl api when it is. If
> > all goes well, then we can extend the netlink api to accept a unit id.
> > 
> > But what about the lack of netlink feedback about the created
> > interface? Are you restricted to use netlink only when the "ifname"
> > option is provided?
> 
> Exactly, this is how I wrote my WIP code...

Sorry for a long delay (I forgot about it). Now I created pull request
for pppd https://github.com/ppp-project/ppp/pull/354 which adds support
for creating ppp interface via rtnetlink. rtnetlink is used only when
ppp unit id was not provided and interface name was provided.

> > > specially if there still would be backward compatibility via ioctl for
> > > kernels which do not support rtnl API.
> > 
> > Indeed, I'd expect keeping compatiblitity with old kernels that only
> > have the ioctl api to be a must (but I have no experience contributing
> > to the pppd project).
> > 
> > > One of the argument which can be
> > > used why rtnl API is better, is fixing issue: atomic creating of
> > > interface with specific name.
> > 
> > Yes, that looks useful.
> > 
