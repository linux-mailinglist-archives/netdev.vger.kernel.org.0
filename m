Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36B38648E38
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 11:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiLJKiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 05:38:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiLJKh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 05:37:58 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB93513E05
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 02:37:56 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1670668675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mnADdeTlGymlxNpd0Q+8eoVdPUdVQVNZ6bRoEM+YrxI=;
        b=hh8BkCwoTkDeWDAw7iNn5vlIZu9e55ZV1AuPw9wxYgrXTVLvmjZU4fYrAjl3D4U25CeggM
        H5+foGSOJtNZIC5yJQ8VwzivjJ/sf/IZcscrlmgRbi6PDD4sXsam+/eUx7jPGe/Zhnt2Om
        cb3QkdxofyydHbbI6w6U0zbGtdxzKJC1I56qntb17chdeIyNFiP6ST67hgqE+jLFi0vnUW
        d9IKBCK+K+VJxz0AhAIINIYj9K/m7xqkaJ0AKygRHn+nUZmk8nK1LUHW5ZP/B+JNPZqf7H
        +Q/CJ/5pAZg0NPZCfVHq5X25ev/4hzKRg3paPz3Iqa4vNLdf6o4esreBv/KfJg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1670668675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mnADdeTlGymlxNpd0Q+8eoVdPUdVQVNZ6bRoEM+YrxI=;
        b=cGpqXp+fK/XSJzBWqXGhor5BelmbjRqXuQpbC9MIxPyHCJhlpaqk7Es99WEFFZZ2qQuTU2
        Tz+NucMTdmcobmAQ==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: don't call ptp_classify_raw() if
 switch doesn't provide RX timestamping
In-Reply-To: <20221209175840.390707-1-vladimir.oltean@nxp.com>
References: <20221209175840.390707-1-vladimir.oltean@nxp.com>
Date:   Sat, 10 Dec 2022 11:37:53 +0100
Message-ID: <87fsdnk0hq.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Fri Dec 09 2022, Vladimir Oltean wrote:
> ptp_classify_raw() is not exactly cheap, since it invokes a BPF program
> for every skb in the receive path.

Only if CONFIG_NET_PTP_CLASSIFY is set.

> For switches which do not provide ds->ops->port_rxtstamp(), running
> ptp_classify_raw() provides precisely nothing, so check for the
> presence of the function pointer first, since that is much cheaper.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmOUYYETHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgswUEACVJsEv1kbeLDXP5HxBY5efbs97WrL/
+g4y4Tl1uSkeZoi6mZIjHklrOtPzfhaaCyIx3IwSjUE4PKY/x/c0ZWlKqB/gmEXx
Te7FMWCobAcz4AD5OPWV8gYeE7C2zGatGPgMq/ycQJU9NM+u2nvUCbOtPmKX58Bf
vgUbG71Z/XS0MOyOmKNkTVmRVl9K9cAeP0MbD3DMo1+dzxiDM15qi3v2i8WMkdkA
xSPVx1e9TwhoIxwfWtAEoVMvVycaotjp6inM8NlUCc6DWvG5GHOWY16KVIEdQ0xW
L3ER8uxhp/qxRlDm2o64irCJLJHmf/eQhp635b01Xoxn7c9r7JG+3dPr+MUF0f75
JGDghv/B9HxhekhXIon0NaGLVUplxhFCCy7njSY1bhkIDtYw9NGlAzsPojBDatfp
WGvWKCFxO0emG4zzaKyF8T3P/hyaGUT22ZpTXA99nzigXjPhTqmKvKcRCS57zTzW
zeMtdKdol6t7g9zR1l5k5UUFDKDlJMXhRrzWnXLk+5DuGcuFAxR1rEm9PgOJYKcD
/UKJZoVgVIS+UncCVXk6W2++jXc/LNgjmSYrEr8oVXWMXWBoONY+VS9SIVC7cd4m
GJVGlPiQdkPX3LyMCZC81QsHo0D8GaD5YSLuKKdKsTIc8SQHij6Lb8uKlyl8F6VK
Fe9zwbqfus1P4A==
=9nTA
-----END PGP SIGNATURE-----
--=-=-=--
