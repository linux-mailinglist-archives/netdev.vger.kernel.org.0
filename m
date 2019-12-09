Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C571175FB
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 20:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfLITeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 14:34:44 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39024 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfLITen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 14:34:43 -0500
Received: by mail-ot1-f67.google.com with SMTP id 77so13275655oty.6;
        Mon, 09 Dec 2019 11:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PFE1nWxTiyfBRgn/J6q9Y8I6dNPJrpPO2zwkS+e8TbI=;
        b=l57bR7j5YoTdsraECl+v5XCXZ2L9yCiOQaei6qnxTgzBKu6DHPdEP2L91+oIkroRMl
         dBW16Yn7M2d5zqpGrKHHu9zqC1Iwdbrm/Bior7UUkbmS7Dzt7c2vA1rIVGXy7w1Xq7jI
         7cTqZ73LSKdFPLYOPe9dsTyCkkvaHQTmaqpczWxscNNewc8+95w6VQ25TW+OJnEExH9R
         TrA/R3/6pFOehNsWxcSaOGZ1Crp1aSlN3xuRW9HZitoMTe6QRU4p/4G7m3uVAmI3K8+1
         St0Rh2zNQH94IiQoZhUthkIOMFEG13Y9CSu0Mg3X/4ibfQ9xRUJCsmdzpZFts0nuLUJE
         Je0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PFE1nWxTiyfBRgn/J6q9Y8I6dNPJrpPO2zwkS+e8TbI=;
        b=UdUmEu1Kl8uHkcS6c/u/GFnAv22Rs0oSfyd/St7MQsf3TR/FtHw+cU8S+dJKylpOEw
         1R4cVWM4J5liRRJxTJMRgIX7YjLxqkisSOlQfShaP7teSwqiJEPIUHt/xrAH6GmRMz5B
         NLm6igUGZwhxprsscCExYyTtp2M789I8BMZFBxtyBYxYIxkJD8gUngeLwr6nFP5v5TjN
         PjwVQcFZV6NdMVoy/H9AVH+t+sdTkdttWg8OkLChRIK93u2q8G2XvH+rGSLvKgPivSrf
         /U856LyWEm3ZCBuVja92gBXHu//yzsEjzYUQ82fCQ8Cm64POEatIJmR8Xlt5eDInoKI9
         p6rg==
X-Gm-Message-State: APjAAAU8R5vUAZonjbdqI4xS3OZUtWGch9rgqLsM+V/WmrDyK2+V0EPD
        Tpd45f6jnu6S8Lt5RhknpP0=
X-Google-Smtp-Source: APXvYqxSnopGKPKS40Fp2UWWVvhccgBBkC3FGIBGVtKql552IcLIhIyHMgbgNBjN89Vl/gf2tP5iZg==
X-Received: by 2002:a9d:6a92:: with SMTP id l18mr23312145otq.37.1575920082851;
        Mon, 09 Dec 2019 11:34:42 -0800 (PST)
Received: from ubuntu-m2-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id x16sm296462oto.41.2019.12.09.11.34.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 09 Dec 2019 11:34:42 -0800 (PST)
Date:   Mon, 9 Dec 2019 12:34:40 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Julio Faracco <jcfaracco@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, dnmendes76@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Shannon Nelson <snelson@pensando.io>,
        Martin Habets <mhabets@solarflare.com>,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH net-next v9 1/3] netdev: pass the stuck queue to the
 timeout handler
Message-ID: <20191209193440.GA15189@ubuntu-m2-xlarge-x86>
References: <20191209162727.10113-1-mst@redhat.com>
 <20191209162727.10113-2-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209162727.10113-2-mst@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Mon, Dec 09, 2019 at 11:29:03AM -0500, Michael S. Tsirkin wrote:
> This allows incrementing the correct timeout statistic without any mess.
> Down the road, devices can learn to reset just the specific queue.
> 
> The patch was generated with the following script:
> 
<snip>
> 
> where the list of files and functions is simply from:
> 
> git grep ndo_tx_timeout, with manual addition of headers
> in the rare cases where the function is from a header,
> then manually changing the few places which actually
> call ndo_tx_timeout.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Acked-by: Heiner Kallweit <hkallweit1@gmail.com>
> Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Acked-by: Shannon Nelson <snelson@pensando.io>
> Reviewed-by: Martin Habets <mhabets@solarflare.com>
> 
> changes from v8:
> 	fix up a missing direct call to timeout
> 	rebased on net-next
> changes from v7:
> 	fixup leftovers from v3 change
> changes from v6:
> 	fix typo in rtl driver
> changes from v5:
> 	add missing files (allow any net device argument name)
> changes from v4:
> 	add a missing driver header
> changes from v3:
>         change queue # to unsigned
> Changes from v2:
>         added headers
> Changes from v1:
>         Fix errors found by kbuild:
>         generalize the pattern a bit, to pick up
>         a couple of instances missed by the previous
>         version.
> ---
<snip>
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index 6a9d12dad5d9..ad0ecebb1b34 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -288,7 +288,7 @@ static int dpaa_stop(struct net_device *net_dev)
>  	return err;
>  }
>  
> -static void dpaa_tx_timeout(struct net_device *net_dev)
> +static void dpaa_tx_timeout(struct net_device *net_dev, int txqueue)

This needs to be unsigned int, otherwise there is a build error:

../drivers/net/ethernet/freescale/dpaa/dpaa_eth.c:2622:20: error: incompatible pointer types initializing 'void (*)(struct net_device *, unsigned int)' with an expression of type 'void (struct net_device *, int)' [-Werror,-Wincompatible-pointer-types]
        .ndo_tx_timeout = dpaa_tx_timeout,
                          ^~~~~~~~~~~~~~~
1 error generated.

Cheers,
Nathan
