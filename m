Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A80B36657E
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 08:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236076AbhDUGfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 02:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhDUGfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 02:35:43 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA2AC06174A;
        Tue, 20 Apr 2021 23:35:10 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1618986908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z6EUUiEJOblPxT1w4z7114vadpacx2AEQX1f9yDMYqc=;
        b=lEuNRrcRd5xehOxWkhsJcyzkY5ItC/TzQ3vW0lGDuQCGszdkBlJIaRFEdWcs1Q8Hn8MBKI
        8+dOZYJedEitM9JeZJJBjkR/vmJJDFy1bMK0AmrY2wff3xbnKhQ+wPTok6LVV79hJvONpM
        9JQuHbaB6UMSDTdD4zRSB9muYF89OxR/kRW9Yt6/STwi6d+zJCpkyjZ0xKNpto4wvspxB7
        mHuNn5DzjGwzI/9wUHWBqxrj32Kj8IdT4ZcU12kC/sXEos3eKg22IPozobXEuASTg+4mbE
        K8Ria10j8+dq+hPu+UFlcsnT/4kklACn05+NxL7NeRVajmDM5VWVyaG2Gc6H3Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1618986908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z6EUUiEJOblPxT1w4z7114vadpacx2AEQX1f9yDMYqc=;
        b=+Op9AgrN6rv3f98XM0KuHGxatYW1bWwtiDwOubp2q3LP+7fjDPzKYdIj3FoadTkk6spBlY
        p2QfcWFU+jtMGAAQ==
To:     "Nguyen\, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "kuba\@kernel.org" <kuba@kernel.org>,
        "Brandeburg\, Jesse" <jesse.brandeburg@intel.com>
Cc:     "bigeasy\@linutronix.de" <bigeasy@linutronix.de>,
        "daniel\@iogearbox.net" <daniel@iogearbox.net>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast\@kernel.org" <ast@kernel.org>,
        "hawk\@kernel.org" <hawk@kernel.org>,
        "lorenzo\@kernel.org" <lorenzo@kernel.org>,
        "john.fastabend\@gmail.com" <john.fastabend@gmail.com>,
        "alexander.duyck\@gmail.com" <alexander.duyck@gmail.com>,
        "ilias.apalodimas\@linaro.org" <ilias.apalodimas@linaro.org>,
        "richardcochran\@gmail.com" <richardcochran@gmail.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "sven.auhagen\@voleatech.de" <sven.auhagen@voleatech.de>,
        "intel-wired-lan\@lists.osuosl.org" 
        <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net v2] igb: Fix XDP with PTP enabled
In-Reply-To: <c1eed5fe05a59f86ff868580e3ae89e251f498ec.camel@intel.com>
References: <20210419072332.7246-1-kurt@linutronix.de> <c1eed5fe05a59f86ff868580e3ae89e251f498ec.camel@intel.com>
Date:   Wed, 21 Apr 2021 08:35:06 +0200
Message-ID: <874kg0b0x1.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

>> +		/* pull rx packet timestamp if available */
>> +		if (igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP))
>> {
>> +			timestamp = igb_ptp_rx_pktstamp(rx_ring-
>> >q_vector,
>> +							pktbuf);
>
> The timestamp should be checked for failure and not adjust these values
> if the timestamp was invalid.

OK. I'll adjust it.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmB/x5oACgkQeSpbgcuY
8KbLIxAAmG5oUNtJmfrc3pqEBAta5uyV2H7xPFqHyHTH2EAn7xPr4idVnyX0xntg
0hzdnuXGElZawt5BVtvyaWvI0cLvD0lD3hDKx3NC8n0otehzv87c3ooE3Tamch/o
pXbAh21R7C3PuLMGTambH7xH2TM3Ts/8pgTW4zjZ48mVWlodMTEewzvbJlT5EJO1
zGQBCqaQG3bHCy6+6Tl+9tKzTCoL2GzHkhGd7gT/aphWDaNNaOl8sFEWGdoAodQh
Y/GvhMPu3SO+MA/2G1ZP/xJJkSoZ1i3Dp76dCMLfqd9GGfA46yA9aASRV0BQi3HB
ceiiUkuGNGHzmXEDQfDfNYGOFwzHsRmiLey8ZNL5zUUD7MxvkxqOdn1CKq4iemuz
qjcP4Ibbt0ZesTjpMkCLxeI+6PdOYfdz6c2z4T4zBermFXMq3ovXDSgv1z39EqfT
7QHJASn9rr5pdxJurT6uqZqR7mtWJqPW66uHza3r0YV1CSvKYPZ0N/PQSKTnaA1J
mErbg9Y4kfoamTUmYJQWus3w75n6GDe2A6lDnzTsHRTOw8luXbBlwu7Vj/sEFP+A
+O0tfuoftZyO9BgUWkTSfFnn/62JEMsXCVsb1RXRcbVu/aLQtFNjolG8R9dy3ifi
WFN8B/z5BGKYqbb8F6UVplXu4aUmglfR5tv44jxpQZSjP+5PaYA=
=cV8D
-----END PGP SIGNATURE-----
--=-=-=--
