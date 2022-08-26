Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194025A329C
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 01:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbiHZX1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 19:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiHZX1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 19:27:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CDDEA176
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 16:27:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90CABB832F1
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 23:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEECC433D6;
        Fri, 26 Aug 2022 23:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661556452;
        bh=BuHhpBGNPp+pDCZzL9WAMq2O24b7beqXO/BDYuyyEXM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fC0cHu2gP64OG4Di24PZQ1qTNLhaySykfhvyDW4CEHEC+dwG2AiAQ+T3LIqLotMca
         3XQq2g8gEuQRuU00OUT5bZaFs9qO4u2uTJlyJgIf1wAqEMxIcmNJ3uo+7PiJwa9dMf
         NKyGwCVer2SbmxxtID5t26ul6xFJBd54/ORiMVcrRoyvhhtPAwLt9wQRugkgq9hg9G
         ZYI+ZfGEBWQr0ZL3mKQFvrZf0ISgGsGm2POx+xDnB5usNt0Phbng0dyddeYNYQ482X
         3La9ewiyGWKIjFjm5GirtX3OeKmTjN2tHwO9GDGtqipMsE4GNRIpTaycV0+AGjfrRB
         1x3WHFW6vVI8A==
Date:   Fri, 26 Aug 2022 16:27:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/3] sfc: support PTP over IPv6/UDP
Message-ID: <20220826162731.5c153f7e@kernel.org>
In-Reply-To: <CACT4oufi28iXQscAcmrQAuiKa+PRB81-27AC4E7D41LG1uzeAg@mail.gmail.com>
References: <20220819082001.15439-1-ihuguet@redhat.com>
        <20220825090242.12848-1-ihuguet@redhat.com>
        <20220825090242.12848-3-ihuguet@redhat.com>
        <20220825183229.447ee747@kernel.org>
        <CACT4oufi28iXQscAcmrQAuiKa+PRB81-27AC4E7D41LG1uzeAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Aug 2022 08:39:44 +0200 =C3=8D=C3=B1igo Huguet wrote:
> > > +static inline int
> > > +efx_filter_set_ipv6_local(struct efx_filter_spec *spec, u8 proto,
> > > +                       const struct in6_addr *host, __be16 port) =20
> >
> > also - unclear why this is defined in the header
>=20
> This is just because it's the equivalent of other already existing
> similar functions in that file. I think I should keep this one
> untouched for cohesion.

We usually defer refactoring for coding style issues until someone=20
is otherwise touching the code, so surrounding code doing something
against the guidance may be misleading.
