Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2BD3DC2CB
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 04:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhGaCyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 22:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbhGaCyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 22:54:39 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23D5C06175F
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 19:54:32 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id l18so13726947ioh.11
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 19:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=ZGYnQy48GzBlBHXN0QjsOeTFQ3pys0A5WDxyuWjWxm4=;
        b=iy2ie5vYvJ98ulhG92Ck+UE7D3T/P6VP0uvyydndqTWAM9tRQjAyjOLGN/4F3nxi9P
         IpvI+x5asd+cvciSq8IYHCHS6RdoCP2xzUVu7YaAxcgwkUbvHWr2YSg769E7rutDdK7b
         V1x/g8WM8YUlHj7U6Ww2mDnxXzoy+bvukQZjKVXr1ywpcXob2I09yI6fSYun9lUSNavd
         eTKqMPz2d+PmTgXodUcNm4WLAOB4XoKx1vOqJcL5lINciZq7OvdC5yen6L30YOG53Eum
         y3ji/hDNM/RDkFBGk87FEeK5fXUKOmz2002tDMkzMfwIn8wo3+wYMfWRo9rqxGOAaQE1
         ofxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=ZGYnQy48GzBlBHXN0QjsOeTFQ3pys0A5WDxyuWjWxm4=;
        b=taLCXj8uAzj5jI9VWGSkw146zyKVwZZ6KdE4A99faQ1sTRlZ1Mpduee75q2qMVmnzV
         bzCBtSuqLKVEt0Flpg7/LhAN2x3agcJGTdjj66AfrBjV/kF77w+V6b62l+h1C9Jji5h6
         KixQM1xhf8m8x98GjraUwE/GlGJV43O9EQSWNjIrBLgDJXtWB0TEfaJybfVCtsBmv5N8
         fsJjPBlF2rLBj+/vLV4Bm80lew++ZpGM7egVKXaFCg/Rj+UdxTP+kRRIzo7zLq27kork
         b+I+zxZEskaD+XCzzI+jlAnY2SiO267I09CA7TBVOss+2TYLugZuuzE8HEsttN3xubA6
         zYqA==
X-Gm-Message-State: AOAM533K7sxWQiaAHEvQfr4EevRzcfLBWjZTFsU8P2cf8kGFmd7e+4n9
        L7VdLyAB/RssqAwYhucsNBQ=
X-Google-Smtp-Source: ABdhPJzAwS//JGZOW4ozeHHrBd0O3wfT8e2pM9qMuoiYBYoYwxLu4TFl3BCzRaJAj9Ed8nTrJwgS3g==
X-Received: by 2002:a5d:8343:: with SMTP id q3mr3919076ior.17.1627700072170;
        Fri, 30 Jul 2021 19:54:32 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id h24sm2356956ioj.32.2021.07.30.19.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 19:54:31 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>
Subject: Re: [PATCH net-next] net: dsa: mt7530: drop paranoid checks in .get_tag_protocol()
Date:   Sat, 31 Jul 2021 10:54:23 +0800
Message-Id: <20210731025424.639902-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210730225714.1857050-1-vladimir.oltean@nxp.com>
References: <20210730225714.1857050-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 31, 2021 at 01:57:14AM +0300, Vladimir Oltean wrote:
> It is desirable to reduce the surface of DSA_TAG_PROTO_NONE as much as
> we can, because we now have options for switches without hardware
> support for DSA tagging, and the occurrence in the mt7530 driver is in
> fact quite gratuitout and easy to remove. Since ds->ops->get_tag_protocol()
> is only called for CPU ports, the checks for a CPU port in
> mtk_get_tag_protocol() are redundant and can be removed.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/mt7530.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 69f21b71614c..b6e0b347947e 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1717,15 +1717,7 @@ static enum dsa_tag_protocol
>  mtk_get_tag_protocol(struct dsa_switch *ds, int port,
>  		     enum dsa_tag_protocol mp)
>  {
> -	struct mt7530_priv *priv = ds->priv;
> -
> -	if (port != MT7530_CPU_PORT) {
> -		dev_warn(priv->dev,
> -			 "port not matched with tagging CPU port\n");
> -		return DSA_TAG_PROTO_NONE;
> -	} else {
> -		return DSA_TAG_PROTO_MTK;
> -	}
> +	return DSA_TAG_PROTO_MTK;
>  }
>  
>  #ifdef CONFIG_GPIOLIB
> -- 
> 2.25.1
> 

Acked-by: DENG Qingfang <dqfext@gmail.com>
