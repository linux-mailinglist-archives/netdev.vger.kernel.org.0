Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E84D2ABB69
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 14:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732554AbgKIN15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 08:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730936AbgKIN14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 08:27:56 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B23EC0613CF;
        Mon,  9 Nov 2020 05:27:56 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604928474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WG3O0Yq9IgUsxM6iHYTRUGMax2Zqkl4t5Ylzk9NgAgU=;
        b=mYxInpRPGuHUI0BHTCrs04gRm7r7w6hETgwWcsN+y7uaZ2Xh+DDXpeIGNhgbCkdFQWU9+d
        VvMM+B3njyInQsQQytpUdcMJDBwoW4PvqaHY1YRaPSBP2oWHn766+uMaJEpmYQj52WMCor
        e0DX9D8folQLx/G8YmNu+BpcYgy7m+2OEXZ+jZCrjgoo497DCOFnY7Q8ygtvr7yNmZ9Xw0
        m3s8OppEtXA0uq/eNmkLSADYw3LC6nt8OEtTtrAwXXl0ua/rzNZjkLgkVl28LIqSY9OTpA
        mwurtxysrcmaynNcGNhFVHpG2LvQp1yjk6T8EmGaqxSZNuKP9HNoaCXarEZMOw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604928474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WG3O0Yq9IgUsxM6iHYTRUGMax2Zqkl4t5Ylzk9NgAgU=;
        b=lft8dUCwRq8EPoK717JI3WT9nSZoDR8fyBgvLKaPF4orIEcjVNfsh8cLB12T9J5Z982NiL
        Zaewm94tHIcswjDg==
To:     Colin King <colin.king@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: dsa: fix unintended sign extension on a u16 left shift
In-Reply-To: <20201109124008.2079873-1-colin.king@canonical.com>
References: <20201109124008.2079873-1-colin.king@canonical.com>
Date:   Mon, 09 Nov 2020 14:27:52 +0100
Message-ID: <87y2jar76v.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Mon Nov 09 2020, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> The left shift of u16 variable high is promoted to the type int and
> then sign extended to a 64 bit u64 value.  If the top bit of high is
> set then the upper 32 bits of the result end up being set by the
> sign extension. Fix this by explicitly casting the value in high to
> a u64 before left shifting by 16 places.
>
> Also, remove the initialisation of variable value to 0 at the start
> of each loop iteration as the value is never read and hence the
> assignment it is redundant.
>
> Addresses-Coverity: ("Unintended sign extension")
> Fixes: e4b27ebc780f ("net: dsa: Add DSA driver for Hirschmann Hellcreek switches")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl+pQ9gACgkQeSpbgcuY
8KYcTBAAy18YsyfEDK2RBP/05cmZJKdrhKGT65m5aI1JezdENk9bCdlxSlc+Oqga
rAzG0pQliyooyHkhkk/+uKd0TMFQ5TdbvIW7af2AoAiNADbUrp2I1an/CXbxIBGA
kCoyqGmGpmvl6V9/sRklq5Y16BxxhDJVREa4/oeiAl4HEuqUQo/bxnc8bH3puOzx
3SMHt0YZDWLyIAkmocREmMBijzlAlXEpTrIR/QnDJTcAEJgxlUlHwJq8Vn4c+1iR
rc2XlsIwzzLz1ah6wfVzP24wbHvFwpGGUMjOR2OubJeKcyn8u5AjqT4z2NCr3/G5
7MhTYblsO0qZVLSxO63ZatXzB8gX+Y6Pr3M6WQqL1B3j4mMrGJSYYohPBHSwKeDh
1z+w8tYNOPGAQ811hjuMrIJh/xGIo4dglYCWASo6oUi611tqrs1WBMaH09E9Dy3F
jYj7Zv+K4qMRmeGYLGu3bLihqycZFq3XvyPmGF8aJlKCNAQnPb+2Vk5v5L3AXsSj
qD3cJbCO87U86Ee4jYyGnpu/5+g1VGWxQzvzWrtqFyITPJVL1gJ51TEPdG2DvbSb
REMVKGPmLZCrylUWmq8zQa7MqCxuI1sSwyIhhAGx/PxvEHc0AlHMm4HNBq8+ZCVD
crawO2LX5auQKEudppWsulWZIRQzvO3xaE+3Ov3C85LVvBQ8XWE=
=OcYZ
-----END PGP SIGNATURE-----
--=-=-=--
