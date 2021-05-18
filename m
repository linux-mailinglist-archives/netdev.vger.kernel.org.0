Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDEA387D60
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 18:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350621AbhERQ25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 12:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345891AbhERQ2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 12:28:52 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F11C061573;
        Tue, 18 May 2021 09:27:30 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id h16so11932471edr.6;
        Tue, 18 May 2021 09:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VOFL/fyG/xjrj8+07b9ToGpPuhyYKQmDo4H8+IuR4rI=;
        b=uFs1d4AZfVtBEhTrnUfVDIt9Lx5EiV8ZoYxe/gWr3SZRhteEm2MhGF3IsEz+jzHpSh
         7SZ+LmFiA9i/5ZaHDk2laiFh3ce7BX5q2oIZoCK0+2+cLMkSicHgAv+dHPDqfmRyeCJr
         HxWJHpyBm/I1sCQj1JRPSQvprrMBxr4aCp7tC9WeRWz4FTsYOfhu9ebtaBmq4kxzYXaQ
         TKNHfvoRNVsLavif0N0WziXp7euacnTaMz+OZuXS4f3taUedM2vmgd3s8M7zztgfCVVX
         hh2RXjuREUCSCQnnL863BrqVwDlRJ9Px5Wof4ttKASB1GqGZzq2tagVzc9KFRJMvefp0
         BbvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VOFL/fyG/xjrj8+07b9ToGpPuhyYKQmDo4H8+IuR4rI=;
        b=soVeIt12XPJT/UOdqJghie4I6guT415+tQUL1MsDk+OPGpjlsw8UWqTYVPYpExXDZM
         SJVP89GSryA2NZKFNyoNF5YQ2lf2oUJtctANTYBgjmpzopqdDKnD38WBOI3m5kzgR8C3
         U0GHyDDe8gMyHyHbKrC+z/qfplHKMXb98ybLQ2U54geQn4ednLtGpQtswexE8u6kgzSx
         DEZe3ynGvzmvNjLqjI+XS3Pyy2Ly3yF999wkeHaC/oHQfugekAvVwh4RiwlPoeahrZ67
         aSlXg6MBTSVSi6ZupaCHlruULsffVtmKVCjUtjVUF6PtYh7uDNR2CKjGetgycnqiUndM
         9R2g==
X-Gm-Message-State: AOAM533iDLfHPoThklY3f32W4Qb1bzwDXdQlAyxnvA3G0jOazyDeQlA7
        lwXdiCD3kTczBqkLntKWXxU=
X-Google-Smtp-Source: ABdhPJyysjnSYXzu4/b8RUpqjOobCSUz+UeNVUj0Izli1DZ/Y8TeaYA+lH5/K6Ivdw0juTFHF6afcQ==
X-Received: by 2002:a50:ef15:: with SMTP id m21mr7946158eds.226.1621355249393;
        Tue, 18 May 2021 09:27:29 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id b19sm12997278edd.66.2021.05.18.09.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 09:27:29 -0700 (PDT)
Date:   Tue, 18 May 2021 19:27:27 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH net-next] net: dsa: qca8k: fix missing unlock on error in
 qca8k_vlan_(add|del)
Message-ID: <20210518162727.74gynfdtrzuyneul@skbuf>
References: <20210518112413.622913-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518112413.622913-1-weiyongjun1@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yongjun,

On Tue, May 18, 2021 at 11:24:13AM +0000, Wei Yongjun wrote:
> Add the missing unlock before return from function qca8k_vlan_add()
> and qca8k_vlan_del() in the error handling case.
> 
> Fixes: 028f5f8ef44f ("net: dsa: qca8k: handle error with qca8k_read operation")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/qca8k.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 4753228f02b3..1f1b7c4dda13 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -506,8 +506,10 @@ qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
>  		goto out;
>  
>  	reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
> -	if (reg < 0)
> -		return reg;
> +	if (reg < 0) {
> +		ret = reg;
> +		goto out;
> +	}

This is fuzzy and has been pointed out before by Russell. reg is unsigned, ret is signed.
An extra patch would be good to use an "int" everywhere.

>  	reg |= QCA8K_VTU_FUNC0_VALID | QCA8K_VTU_FUNC0_IVL_EN;
>  	reg &= ~(QCA8K_VTU_FUNC0_EG_MODE_MASK << QCA8K_VTU_FUNC0_EG_MODE_S(port));
>  	if (untagged)
> @@ -519,7 +521,7 @@ qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
>  
>  	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
>  	if (ret)
> -		return ret;
> +		goto out;
>  	ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
>  
>  out:
> @@ -541,8 +543,10 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
>  		goto out;
>  
>  	reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
> -	if (reg < 0)
> -		return reg;
> +	if (reg < 0) {
> +		ret = reg;
> +		goto out;
> +	}
>  	reg &= ~(3 << QCA8K_VTU_FUNC0_EG_MODE_S(port));
>  	reg |= QCA8K_VTU_FUNC0_EG_MODE_NOT <<
>  			QCA8K_VTU_FUNC0_EG_MODE_S(port);
> @@ -564,7 +568,7 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
>  	} else {
>  		ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
>  		if (ret)
> -			return ret;
> +			goto out;
>  		ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
>  	}
>  
> 

