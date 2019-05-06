Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69DFE1550B
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 22:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfEFUpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 16:45:35 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34901 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbfEFUpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 16:45:35 -0400
Received: by mail-ed1-f65.google.com with SMTP id p26so16664336edr.2;
        Mon, 06 May 2019 13:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T0nHJ9khqFzYd9X1bGFM55dYV8Drkoa/Hw+bI+N/V5w=;
        b=h6fz1yi/MJ5wJovCykD/1iOQnsTzXFfSRsjxb68Du13HmdUx3xKMKgJtVe/+XSJoHF
         JAPoIOwErthkTls1yy1gJM62S7msSsh8wqreyrL3F/qaIlxiqnF5zAc/7qAPdOkFllgz
         f+zemVeyHOmlcsDIBYHemNcI5r5LE7WuqO36f6bZjNKS5ngXnBKdtbOocyWItTjQrVHP
         vi/tS53Mk1GooAkaogUjCsj3zLBuYk8emn/aBYMPntnQjnt9Wx77VQdl1nldkkhtZw0N
         Cky7AW8QiFmFp5TiRC2pGb/l1O8yWlJq606fi1hSGFH8SkwzKu8Oz+k9fOsTWOptaPJT
         YJ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T0nHJ9khqFzYd9X1bGFM55dYV8Drkoa/Hw+bI+N/V5w=;
        b=VKGpnYvb1CZG5HCxw57ru4oJmehhtF7kWbV6q/2TCsZTGZVYT2mOPKmR+YX8sIY5dR
         Mx7DfDL//ZJN1pDoCPx6wzhzQVfgmit7xfABmRXCiQFXud9qwfcM/zx9kpNWvWRIG18j
         Zd0zB8DELi3TreYQEAw+d92v6+jL5uzzGPHsnY190N2QAA2h7DPNyG5F+me3H9wZeWL+
         mDknadqEsolvuG7nFSdl71MuDS2n87ttWEnxT+7afPSnKf5YjJbPh1xJAKrW7qwnVnnx
         krHvA0lsQOXEl7twiryApn89zXzG/xXDCEn4cTFN47gKXQP/3lQflwYdNV9O8pfNkOR5
         ebug==
X-Gm-Message-State: APjAAAVVZVa/1UZ2t6GWNirsD8yxZvnPQE3xUw8TGwbfY6uivn+Bkkfn
        7ejgTaufJYurW1BAK0zbnjP6pvmx+EnzRrQ3FRc=
X-Google-Smtp-Source: APXvYqxafPtBl+3HWXW7hDxqDmr1hvHRlVnDeusFECLnBRyfxCF8K4AAyn/TXq04Gah1Ed9de0ZGLae9A+61+M2/iJg=
X-Received: by 2002:a50:9177:: with SMTP id f52mr28874627eda.18.1557175533006;
 Mon, 06 May 2019 13:45:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190506202447.30907-1-natechancellor@gmail.com>
In-Reply-To: <20190506202447.30907-1-natechancellor@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 6 May 2019 23:45:22 +0300
Message-ID: <CA+h21hpODxkfP8c0CVZwfVpUs91U1REsc2vWMVBAOteDnkJJjQ@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: sja1105: Fix status initialization in sja1105_get_ethtool_stats
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 May 2019 at 23:25, Nathan Chancellor <natechancellor@gmail.com> wrote:
>
> Clang warns:
>
> drivers/net/dsa/sja1105/sja1105_ethtool.c:316:39: warning: suggest
> braces around initialization of subobject [-Wmissing-braces]
>         struct sja1105_port_status status = {0};
>                                              ^
>                                              {}
> 1 warning generated.
>
> One way to fix these warnings is to add additional braces like Clang
> suggests; however, there has been a bit of push back from some
> maintainers[1][2], who just prefer memset as it is unambiguous, doesn't
> depend on a particular compiler version[3], and properly initializes all
> subobjects. Do that here so there are no more warnings.
>
> [1]: https://lore.kernel.org/lkml/022e41c0-8465-dc7a-a45c-64187ecd9684@amd.com/
> [2]: https://lore.kernel.org/lkml/20181128.215241.702406654469517539.davem@davemloft.net/
> [3]: https://lore.kernel.org/lkml/20181116150432.2408a075@redhat.com/
>
> Fixes: 52c34e6e125c ("net: dsa: sja1105: Add support for ethtool port counters")
> Link: https://github.com/ClangBuiltLinux/linux/issues/471
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/net/dsa/sja1105/sja1105_ethtool.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/dsa/sja1105/sja1105_ethtool.c b/drivers/net/dsa/sja1105/sja1105_ethtool.c
> index 46d22be31309..ab581a28cd41 100644
> --- a/drivers/net/dsa/sja1105/sja1105_ethtool.c
> +++ b/drivers/net/dsa/sja1105/sja1105_ethtool.c
> @@ -313,9 +313,11 @@ static char sja1105pqrs_extra_port_stats[][ETH_GSTRING_LEN] = {
>  void sja1105_get_ethtool_stats(struct dsa_switch *ds, int port, u64 *data)
>  {
>         struct sja1105_private *priv = ds->priv;
> -       struct sja1105_port_status status = {0};
> +       struct sja1105_port_status status;
>         int rc, i, k = 0;
>
> +       memset(&status, 0, sizeof(status));
> +
>         rc = sja1105_port_status_get(priv, &status, port);
>         if (rc < 0) {
>                 dev_err(ds->dev, "Failed to read port %d counters: %d\n",
> --
> 2.21.0
>

Acked-by: Vladimir Oltean <olteanv@gmail.com>

Thanks Nathan, compound literals got me this time.
-Vladimir
