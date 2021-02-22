Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E042B3214E7
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 12:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhBVLQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 06:16:06 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11461 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbhBVLQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 06:16:03 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6033924b0000>; Mon, 22 Feb 2021 03:15:23 -0800
Received: from [172.27.13.143] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Feb
 2021 11:15:21 +0000
Subject: Re: [PATCH iproute2] dcb: Fix compilation warning about reallocarray
To:     <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20210222105105.10213-1-roid@nvidia.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <0b7e4dd2-1f49-ca73-ca68-91146a474e61@nvidia.com>
Date:   Mon, 22 Feb 2021 13:15:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210222105105.10213-1-roid@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613992523; bh=Cha5nvmg1Be7q388oQmy4vMnkBAIphTWfDjoGy27vZg=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=DegGPHlzFoOtZxyjJ0e5+TPaUoWSBRKYoY+SZDMqTUKLOi6gY/MsNO2CMDBV+vOky
         Abs9fXN3bVM2K6tjsJSAPW+A0uU1JJUozTzdB6SpEZFh2rCLRjuuzrA4t3oE2OVqQ9
         QjrsOWvgP8NXx1DqahTkU5GR/kfx+hCwTxmJ8CQGCSAROHVVDs/wdAmjvp7on/sgKn
         6Kl7zHiao6OqOcF23uNj8ietgNu3phlOaWrS5AMRiCZeUqf9vmW5E2rVfWHzhUj1J0
         SIEo1iIKdJMr0L2MASb5xJ9xutKcBlGqK+KKU/6D9usn5K94QnEsM0tl+kHHKmPHAd
         ZvSJJL8oLi0NQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-02-22 12:51 PM, Roi Dayan wrote:
> To use reallocarray we need to add bsd/stdlib.h.
>=20
> dcb_app.c: In function =E2=80=98dcb_app_table_push=E2=80=99:
> dcb_app.c:68:25: warning: implicit declaration of function =E2=80=98reall=
ocarray=E2=80=99; did you mean =E2=80=98realloc=E2=80=99?
>=20
> Fixes: 8e9bed1493f5 ("dcb: Add a subtool for the DCB APP object")
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> ---
>   dcb/dcb.c | 1 +
>   1 file changed, 1 insertion(+)
>=20
> diff --git a/dcb/dcb.c b/dcb/dcb.c
> index 6640deef5688..32896c4d5732 100644
> --- a/dcb/dcb.c
> +++ b/dcb/dcb.c
> @@ -5,6 +5,7 @@
>   #include <linux/dcbnl.h>
>   #include <libmnl/libmnl.h>
>   #include <getopt.h>
> +#include <bsd/stdlib.h>
>  =20
>   #include "dcb.h"
>   #include "mnl_utils.h"
>=20

It seems I need this include in old centos distro but
not in fedora 27 for example as it is part of glibc.
don't merge this please.


