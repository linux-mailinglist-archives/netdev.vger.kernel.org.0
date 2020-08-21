Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7710D24D3E3
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 13:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbgHUL0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 07:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728027AbgHULZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 07:25:31 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 35A93C061343
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 04:25:30 -0700 (PDT)
Received: from [IPv6:2a02:8010:6359:1:551f:34b6:cf72:2539] (unknown [IPv6:2a02:8010:6359:1:551f:34b6:cf72:2539])
        (Authenticated sender: james)
        by mail.katalix.com (Postfix) with ESMTPSA id 33E5886B99;
        Fri, 21 Aug 2020 12:25:29 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1598009129; bh=xiwNI2o0F6Zcd5qvhiL8FzxW07pHW+xmZPnQfHWUX9M=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:From;
        z=Subject:=20Re:=20[PATCH=20net-next=200/9]=20l2tp:=20replace=20cus
         tom=20logging=20code=20with=0D=0A=20tracepoints|To:=20Tom=20Parkin
         =20<tparkin@katalix.com>,=20netdev@vger.kernel.org|References:=20<
         20200821104728.23530-1-tparkin@katalix.com>|From:=20James=20Chapma
         n=20<jchapman@katalix.com>|Message-ID:=20<218d246a-a308-1f49-b6e3-
         af2863c97f69@katalix.com>|Date:=20Fri,=2021=20Aug=202020=2012:25:2
         8=20+0100|MIME-Version:=201.0|In-Reply-To:=20<20200821104728.23530
         -1-tparkin@katalix.com>;
        b=tiFW3uXcLpL6VTzfhcTHNNQk1HhrGp6scKxcfIQxpPc4q2QmXX5qbgP1DRjgro/vp
         Wg179IlRXr9REG/sVmKkTGQeomHq7kxA9zlydXVsj2RZqNN+kuR8ZgR0u/gs6ZWgTc
         RjB5JhVwhKHn0EBvTo0ZQ47GSXTXCcqRRpRKOiAGt7p34HTXXTfJwAaLI2QyVn0mbi
         PE8Za7ja/ZBL8N2XPWNE4VsgxsZINSpAofiDBIsuu9xoqfpmBnwoPvgVn0c0KGecgY
         Rej8ppJL6DXlnTD4bG4kqVNHPpPAqpALVpObM2+3jLN8ezdRQdPDsA9yzbTuDFwTZA
         eJsy2XzJoPaiw==
Subject: Re: [PATCH net-next 0/9] l2tp: replace custom logging code with
 tracepoints
To:     Tom Parkin <tparkin@katalix.com>, netdev@vger.kernel.org
References: <20200821104728.23530-1-tparkin@katalix.com>
From:   James Chapman <jchapman@katalix.com>
Autocrypt: addr=jchapman@katalix.com; prefer-encrypt=mutual; keydata=
 xsBNBFDmvq0BCACizu6XvQjeWZ1Mnal/oG9AkCs5Rl3GULpnH0mLvPZhU7oKbgx5MHaFDKVJ
 rQTbNEchbLDN6e5+UD98qa4ebvNx1ZkoOoNxxiuMQGWaLojDKBc9x+baW1CPtX55ikq2LwGr
 0glmtUF6Aolpw6GzDrzZEqH+Nb+L3hNTLBfVP+D1scd4R7w2Nw+BSQXPQYjnOEBDDq4fSWoI
 Cm2E18s3bOHDT9a4ZuB9xLS8ZuYGW6p2SMPFHQb09G82yidgxRIbKsJuOdRTIrQD/Z3mEuT/
 3iZsUFEcUN0T/YBN3a3i0P1uIad7XfdHy95oJTAMyrxnJlnAX3F7YGs80rnrKBLZ8rFfABEB
 AAHNJEphbWVzIENoYXBtYW4gPGpjaGFwbWFuQGthdGFsaXguY29tPsLAeAQTAQIAIgUCUOa+
 rQIbIwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQINzVgFp/OkBr2gf7BA4jmtvUOGOO
 JFsj1fDmbAzyE6Q79H6qnkgYm7QNEw7o+5r7EjaUwsh0w13lNtKNS8g7ZWkiBmSOguJueKph
 GCdyY/KOHZ7NoJw39dTGVZrvJmyLDn/CQN0saRSJZXWtV31ccjfpJGQEn9Gb0Xci0KjrlH1A
 cqxzjwTmBUr4S2EHIzCcini1KTtjbtsE+dKP4zqR/T52SXVoYvqMmJOhUhXh62C0mu8FoDM0
 iFDEy4B0LcGAJt6zXy+YCqz7dOwhZBB4QX4F1N2BLF3Yd1pv8wBBZE7w70ds7rD7pnIaxXEK
 D6yCGrsZrdqAJfAgYL1lqkNffZ6uOSQPFOPod9UiZM7ATQRQ5r6tAQgAyROh3s0PyPx2L2Fb
 jC1mMi4cZSCpeX3zM9aM4aU8P16EDfzBgGv/Sme3JcrYSzIAJqxCvKpR+HoKhPk34HUR/AOk
 16pP3lU0rt6lKel2spD1gpMuCWjAaFs+dPyUAw13py4Y5Ej2ww38iKujHyT586U6skk9xixK
 1aHmGJx7IqqRXHgjb6ikUlx4PJdAUn2duqasQ8axjykIVK5xGwXnva/pnVprPSIKrydNmXUq
 BIDtFQ4Qz1PQVvK93KeCVQpxxisYNFRQ5TL6PtgVtK8uunABFdsRqlsw1Ob0+mD5fidITCIJ
 mYOL8K74RYU4LfhspS4JwT8nmKuJmJVZ5DjY2wARAQABwsBfBBgBAgAJBQJQ5r6tAhsMAAoJ
 ECDc1YBafzpA9CEH/jJ8Ye73Vgm38iMsxNYJ9Do9JvVJzq7TEduqWzAFew8Ft0F9tZAiY0J3
 U2i4vlVWK8Kbnh+44VAKXYzaddLXAxOcZ8YYy+sVfeVoJs3lAH+SuRwt0EplHWvCK5AkUhUN
 jjIvsQoNBVUP3AcswIqNOrtSkbuUkevNMyPtd0GLS9HVOW0e+7nFce7Ow9ahKA3iGg5Re9rD
 UlDluVylCCNnUD8Wxgve4K+thRL9T7kxkr7aX7WJ7A4a8ky+r3Daf7OhGN9S/Z/GMSs0E+1P
 Qm7kZ2e0J6PSfzy9xDtoRXRNigtN2o8DHf/quwckT5T6Z6WiKEaIKdgaXZVhphENThl7lp8=
Organization: Katalix Systems Ltd
Message-ID: <218d246a-a308-1f49-b6e3-af2863c97f69@katalix.com>
Date:   Fri, 21 Aug 2020 12:25:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200821104728.23530-1-tparkin@katalix.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/08/2020 11:47, Tom Parkin wrote:
> The l2tp subsystem implemented custom logging macros for debugging
> purposes which were controlled using a set of debugging flags in each
> tunnel and session structure.
>
> A more standard and easier-to-use approach is to use tracepoints.
>
> This patchset refactors l2tp to:
>
>  * remove excessive logging
>  * tweak useful log messages to use the standard pr_* calls for logging
>    rather than the l2tp wrappers
>  * replace debug-level logging with tracepoints
>  * add tracepoints for capturing tunnel and session lifetime events

Acked-by: James Chapman <jchapman@katalix.com>


