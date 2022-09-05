Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0775AD4A8
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 16:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236081AbiIEOWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 10:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiIEOWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 10:22:14 -0400
X-Greylist: delayed 400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 05 Sep 2022 07:22:12 PDT
Received: from mail.sf-mail.de (mail.sf-mail.de [IPv6:2a01:4f8:1c17:6fae:616d:6c69:616d:6c69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC003B951
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 07:22:12 -0700 (PDT)
Received: (qmail 31521 invoked from network); 5 Sep 2022 14:15:41 -0000
Received: from p200300cf0709290076d435fffeb7be92.dip0.t-ipconnect.de ([2003:cf:709:2900:76d4:35ff:feb7:be92]:46898 HELO eto.sf-tec.de) (auth=eike@sf-mail.de)
        by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 16:15:41 +0200
From:   Rolf Eike Beer <eike@sf-mail.de>
To:     netdev@vger.kernel.org
Subject: Usage of arch_get_platform_mac_address() or the lack thereof
Date:   Mon, 05 Sep 2022 16:15:21 +0200
Message-ID: <3193368.44csPzL39Z@eto.sf-tec.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart8111812.T7Z3S40VBb"; micalg="pgp-sha1"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart8111812.T7Z3S40VBb
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Rolf Eike Beer <eike@sf-mail.de>
To: netdev@vger.kernel.org
Subject: Usage of arch_get_platform_mac_address() or the lack thereof
Date: Mon, 05 Sep 2022 16:15:21 +0200
Message-ID: <3193368.44csPzL39Z@eto.sf-tec.de>
MIME-Version: 1.0

Hi,

just for the fun of it I'm poking a bit through the sunhme driver. I noticed 
that this driver as well as many other sun related drivers directly use 
idprom->id_ethaddr, but noone uses arch_get_platform_mac_address(). Some 
drivers use eth_platform_get_mac_address() instead, which does some more 
querying of of_* properties to find out the mac address.

So, what is the right way of doing this? sungem and sunhme query "local-mac-
address" before, but do not query the other possibilities used in 
of_get_mac_address(), and neither of them checks for all-zeroes and other 
things in the returned addresses. sungme will error out if that does not 
return any address, sunhme will simply leave the mac address unassigned.

What would be the correct way of doing this? Should all these driver be ported 
to use arch_get_platform_mac_address() or eth_platform_get_mac_address()?

Eike
--nextPart8111812.T7Z3S40VBb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSaYVDeqwKa3fTXNeNcpIk+abn8TgUCYxYEeQAKCRBcpIk+abn8
TlJ8AJ9sOl/io+sH/GHP9UkPS3osyUssVwCfTQNwzTevddendGHeF8C9hP97Ff0=
=j5j5
-----END PGP SIGNATURE-----

--nextPart8111812.T7Z3S40VBb--



