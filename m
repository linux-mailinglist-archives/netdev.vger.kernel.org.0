Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 161563BB48
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 19:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388565AbfFJRra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 13:47:30 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:40454 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387643AbfFJRra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 13:47:30 -0400
Received: by mail-vs1-f68.google.com with SMTP id a186so4076342vsd.7
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 10:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=9ctFDS2z8KDGvafdc88Ef4Bv0XUDy23rklvB3/YsVX0=;
        b=G1U9pJbuRLo1HpNeyjjU/EL2LV6jPG4CgnZWC0kJOQZn1scc6QLncDkDXEEsME1N/j
         2vPY/bLUSOQGt3S1b/yV/7sV2MRuUUh7etgwKuPjjrNZIt5wwbxTyE/waoRnMwSqgl9+
         /KpZF3fGEU1etuYBR42dPodw2VPw04XDTWOwlEAnM06jKloHR7Nl3uxxn5mQka/pXMAA
         nsjBtkxoxZzvvRmNWzK7JSZVWXHV2MQhVzu3LrvoCmlZozDLK9mdoq21tGZGUjMqa/zD
         yi/7NGJQKeBzap1A5COkF5IWCbbt26fjvILJEmqGPrGSK/e87puegZVT+ZJpIxZN/fG/
         w5ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=9ctFDS2z8KDGvafdc88Ef4Bv0XUDy23rklvB3/YsVX0=;
        b=gaP37ZDYFUjJt1oRHIw9GBeSV6tZhgWsPVqytDA54+vX70gVsvaXSNVNJCjI1esMWN
         hbW4CnyYGmio8AsdK2bTYvvRWFt7DkyFcXyiVm3e5LFNd5XhHoq8+QLg+lCOdKaxBALe
         Mesf5uJoa4OZoTUMHTSS+QJiW0PXzgM82D47GoeWozRhj1kU338UpT04qShi4Al436aV
         dmQBiLJoERh4yPPrrGbpciIxwty3Jk+Mv1qMHTdwk0U9MKcuKHSQxDmDXObzKGLPe2g7
         TJtlcLqbrvg2MdqDR8bGo2wHI16YnWatH4ghpT8DwNZTEfgz69sFRpcNHSEQJIcWdA2Z
         ZDlw==
X-Gm-Message-State: APjAAAURfq8hTBT2ja5fTx/v1cESA+N6JnIZ03pnp9YglPYdLv+heF1l
        S9Byea0tx2tp5nSXwaGfeQaHwA==
X-Google-Smtp-Source: APXvYqwIQXsWRqrob/1ylTn5alYUTw3m8mUxD8ce1sRAGH/3Q6E5H/1GAwSxsciaNdGYbLu3tbt1Hg==
X-Received: by 2002:a67:e419:: with SMTP id d25mr8271035vsf.196.1560188848788;
        Mon, 10 Jun 2019 10:47:28 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r3sm3616975vkd.30.2019.06.10.10.47.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 10:47:28 -0700 (PDT)
Date:   Mon, 10 Jun 2019 10:47:23 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, mlxsw@mellanox.com, sthemmin@microsoft.com,
        saeedm@mellanox.com, leon@kernel.org, f.fainelli@gmail.com
Subject: Re: [patch net-next v3 3/3] devlink: implement flash status
 monitoring
Message-ID: <20190610104723.66e78254@cakuba.netronome.com>
In-Reply-To: <249eca9b-e62a-df02-7593-4492daf39183@gmail.com>
References: <20190604134044.2613-1-jiri@resnulli.us>
        <20190604134450.2839-3-jiri@resnulli.us>
        <08f73e0f-918b-4750-366b-47d7e5ab4422@gmail.com>
        <20190610102438.69880dcd@cakuba.netronome.com>
        <249eca9b-e62a-df02-7593-4492daf39183@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jun 2019 11:30:24 -0600, David Ahern wrote:
> On 6/10/19 11:24 AM, Jakub Kicinski wrote:
> > On Mon, 10 Jun 2019 11:09:19 -0600, David Ahern wrote: =20
> >> On 6/4/19 7:44 AM, Jiri Pirko wrote: =20
> >>> diff --git a/man/man8/devlink-dev.8 b/man/man8/devlink-dev.8
> >>> index 1804463b2321..1021ee8d064c 100644
> >>> --- a/man/man8/devlink-dev.8
> >>> +++ b/man/man8/devlink-dev.8
> >>> @@ -244,6 +244,17 @@ Sets the parameter internal_error_reset of speci=
fied devlink device to true.
> >>>  devlink dev reload pci/0000:01:00.0
> >>>  .RS 4
> >>>  Performs hot reload of specified devlink device.
> >>> +.RE
> >>> +.PP
> >>> +devlink dev flash pci/0000:01:00.0 file firmware.bin
> >>> +.RS 4
> >>> +Flashes the specified devlink device with provided firmware file nam=
e. If the driver supports it, user gets updates about the flash status. For=
 example:
> >>> +.br
> >>> +Preparing to flash
> >>> +.br
> >>> +Flashing 100%
> >>> +.br
> >>> +Flashing done
> >>> =20
> >>>  .SH SEE ALSO
> >>>  .BR devlink (8),   =20
> >>
> >> something is missing here from a user perspective at least:
> >>
> >> root@mlx-2700-05:~# ./devlink dev
> >> pci/0000:03:00.0
> >>
> >> root@mlx-2700-05:~# ./devlink dev flash pci/0000:03:00.0 file
> >> /lib/firmware/mellanox/mlxsw_spectrum-13.2000.1122.mfa2
> >> devlink answers: No such file or directory
> >>
> >> root@mlx-2700-05:~# ls -l
> >> /lib/firmware/mellanox/mlxsw_spectrum-13.2000.1122.mfa2
> >> -rw-r--r-- 1 cumulus 1001 994184 May 14 22:44
> >> /lib/firmware/mellanox/mlxsw_spectrum-13.2000.1122.mfa2
> >>
> >>
> >> Why the 'no such file' response when the file exists? =20
> >=20
> > I think the FW loader prepends /lib/firmware to the path (there is a
> > CONFIG_ for the search paths, and / is usually not on it).  Perhaps try:
> >=20
> > ./devlink dev flash pci/0000:03:00.0 file mellanox/mlxsw_spectrum-13.20=
00.1122.mfa2
> >  =20
>=20
> that worked, but if the user specifies fullpath that is confusing. So at
> a minimum the documentation needs to be clear about the paths.
>=20
> But, why the path limitation? why not allow a user to load a file from
> any directory? For mlxsw at least the file in /lib/firmware will be
> loaded automagically, so forcing the file to always be in /lib/firmware
> seems counterintuitive when using a command to specify the file to load.

It's the kernel that does this, the request_firmware() API.  It's
documented in both devlink's and ethtool's API.  I was initially
intending to use the file request API directly in devlink, but because
of the requirement to keep compatibility with ethtool that was a no go.

FWIW you can load from any directory, just prefix the file name
with ../../ to get out of /lib/firmware.

I guess we could add some logic into devlink user space to detect that
user does not know about this quirk and fix up the path for them.. =F0=9F=
=A4=94
