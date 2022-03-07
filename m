Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7792D4D095E
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 22:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237535AbiCGVcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 16:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235529AbiCGVcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 16:32:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7774AE2E
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 13:31:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01664B8170D
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 21:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82894C340E9;
        Mon,  7 Mar 2022 21:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646688677;
        bh=OtxOiwrtj4i9PywM8sc6lwMgoPhxL62V6XMKTUYNZuQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OJrw5rc1/xqIbP107d7lTxxc+TPBrbWi007J7I7jbjrpEmtbca0SyNUVJhEDzerDd
         NOTkKAgwyXISn8y9fG+Fnqu1J68CZzuSSK87InEgjdtjnehyOXuJdZ7dXSnRRgSOO3
         JFRaSQNsVhRYsCOwn/m6D/NRNtKkoyLrwO0a83SW8CK7nNe9p9auRv426seApnHgDZ
         QFjd4jLUbh54D+iJWbN4hYR3q9ntTkdN6vKPTxd4enQZEbmf/oiv3nPTWuGGKjvffl
         F0CRnjX68vWDX6tre22zHNNlhde4LIXV+HjVf5pUJblzFAVPKXvwjVwvgM2RAsbMCH
         mzuOR2u0GxLAg==
Date:   Mon, 7 Mar 2022 13:31:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jonathan Lemon" <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, kernel-team@fb.com
Subject: Re: [PATCH net-next 1/2] ptp: ocp: add nvmem interface for
 accessing eeprom
Message-ID: <20220307133116.24815d64@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0B9D1A8D-C56F-4B7C-BC62-31633003D7AC@gmail.com>
References: <20220303233801.242870-1-jonathan.lemon@gmail.com>
        <20220303233801.242870-4-jonathan.lemon@gmail.com>
        <20220303210112.701ed143@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <3D45B7EC-D480-4A0F-8ED2-2CC5677B8B13@gmail.com>
        <20220304081834.552ae666@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DC32C07D-52FC-437C-AE9A-FA03082E008B@gmail.com>
        <20220304191134.6146087d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <0B9D1A8D-C56F-4B7C-BC62-31633003D7AC@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 06 Mar 2022 14:53:42 -0800 Jonathan Lemon wrote:
> > In my limited experience the right fit here would be PCI Subsystem
> > Vendor ID. This will also allow lspci to pretty print the vendor
> > name like:
> >
> > 30:00.0 Dunno controller: OCP Time Card whatever (Vendor X) =20
>=20
> Unfortunately, that=E2=80=99s not going to work for a while, until the
> relevant numbers get through the PCI approval body.

There's no approval for sub ids. Vendor whose ID is used can=20
do whatever they want there.

> I believe that board.manufacture is correct.  In this particular
> example, the 3 boards are fabbed in 3 different locations, but
> there are 2 =E2=80=9Cvendors=E2=80=9D.
>=20
> So what this does is identify the contractor who assembled the
> particular board.  Isn=E2=80=99t that what this is intended for?

Not really, as I explained this field is to differentiate _identical_
board designs delivered by different fabs. I did not see that case in
your example output. The point of devlink info is to expose the
information not covered in standard PCI device fields, so the industry
standard approach takes precedence.
