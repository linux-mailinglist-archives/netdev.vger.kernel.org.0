Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751125A1814
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 19:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242825AbiHYRmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 13:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234681AbiHYRmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 13:42:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE44B2D9E;
        Thu, 25 Aug 2022 10:42:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1D92B82A68;
        Thu, 25 Aug 2022 17:42:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E607C433C1;
        Thu, 25 Aug 2022 17:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661449329;
        bh=w857NjmZvn15PF0UZAGRqvuU5wVMAAdo1gnTqJ7Yi4w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qU0rnAnuAnH9bxn1gEwWsMcPXK5ez7TiLi22yFvOmtIqE5w+j7wt81NPs4bqgFJ3u
         0oJ+NDqTVLAdbjjxWF6qQ06pGsM/PuXFhHYV5UyDgAZ6ZA0h/I2RRDJqZSPcUuNMmy
         +RvTBk6VwWuKo4OAw8/0b2+JZnv1G8LZjTrgmrAW3muFEb9YncoJo1r08qaKyXBjCf
         xQeWYfDZ8ytZGauhjSawjYcHv2BQatl77q3oBsNlH2saUFurp9XgcbQoF3dLQbb0Ob
         HrRL1kQPz7MT3UJUTHNsRywx4TP5jShjmjWvQFxJE1NPXZphYtqAk2g6tg7jYB/NhP
         s4/rDNnZsqL/g==
Date:   Thu, 25 Aug 2022 10:42:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "=?UTF-8?B?aW1hZ2Vkb25n?=(=?UTF-8?B?6JGj5qKm6b6Z?=)" 
        <imagedong@tencent.com>, linux-doc@vger.kernel.org
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Linux Next Mailing List" <linux-next@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [Internet]linux-next: build warning after merge of the net-next
 tree
Message-ID: <20220825104208.592a2df2@kernel.org>
In-Reply-To: <07263247-4906-4A72-A1A2-CAB41F115EB7@tencent.com>
References: <20220825154105.534d78ab@canb.auug.org.au>
        <07263247-4906-4A72-A1A2-CAB41F115EB7@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Aug 2022 07:55:36 +0000 imagedong(=E8=91=A3=E6=A2=A6=E9=BE=99) w=
rote:
> > After merging the net-next tree, today's linux-next build (htmldocs)
> > produced this warning:
> >=20
> > Documentation/networking/kapi:26: net/core/skbuff.c:780: WARNING: Error=
 in declarator or parameters
> > Invalid C declaration: Expecting "(" in parameters. [error at 19]
> >   void __fix_address kfree_skb_reason (struct sk_buff *skb, enum skb_dr=
op_reason reason)
> >   -------------------^
> >=20
> > Introduced by commit
> >=20
> >   c205cc7534a9 ("net: skb: prevent the split of kfree_skb_reason() by g=
cc")
> >  =20
>=20
> Yeah, I commited this patch. May I ask what command did you use to
> produce this warning? I tried the following command, but not success:
>=20
>   make V=3D2 SPHINXDIRS=3D"networking" htmldocs
>=20
> Hmm.......what does this warning means? Does it don't like this
> function attribute?

It popped up for me on a clean build of

	make htmldocs

There's a lot of other warnings but you should see this one, too.

I think you need to add the new keyword to one of the tables in
Documentation/conf.py
