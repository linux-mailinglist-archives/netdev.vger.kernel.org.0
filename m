Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA9CEB4595
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 04:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391991AbfIQCnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 22:43:24 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45354 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729003AbfIQCnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 22:43:24 -0400
Received: by mail-pf1-f194.google.com with SMTP id y72so1190261pfb.12
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 19:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=aQrXVTNYPD93A+dr3PQzbCJpCjMJXTuJQlMV8r8hKjE=;
        b=jMhRGNsPq4gN9mlEaZ/AEVKbtiBbP49Nk000CTIHRAT7Qw5Sm5KXl30UtOnKNEXgJG
         BBcf0/EzePXZhMAXA1Ed+Hu3czD1Ka2KVhgyxemKS+eS5LZobAJ4B50wLjVdUSE8YD2L
         puiSTTu61AVk3VP0aa7iYu1y1ask/Hk4D577HbXvPrxwqtz/ggUfUxHMnx56eZlbifHi
         n3SLjkQco+K4dPH01qWh3ysbYuyTdJeI/9PwYRJwxPeSs+LnLSGR+qfHqzVXm86KQ7Mc
         3SbrrAQoBk+vCulD8t3H4OO+kGMpKJOJRPWi9tpwOTB56Lp1/SaPjcaAtLoBuSDZ8/X2
         4AWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=aQrXVTNYPD93A+dr3PQzbCJpCjMJXTuJQlMV8r8hKjE=;
        b=cfSKa4TGm93gQ2M8yx7atQWZnOBSjCrE18zG7pnZSSsX/DTOxlObuOC5x6PgMzp/3f
         4JbkpKGdTRifSi9IZohJfnifo8nXY/gDidWwjGMZpTI6j4MSSNRjcf/nyzkOdim9oHLo
         0HLmcyJj+erdE8VYUe08tQ7yOzyY0FzaNh+2u+jBX+nSntuNQEytk9+nTPNDGIM8PuDT
         7Hz/xsNdotwUu1kt13q9ECuLDauxNbw60xWQKveSlCn8aX1S5FUWbTeuxRqf4nuB71l5
         24/PzmhY0+7btVfnf1f70itIXKBddpnQrvytmjT6QiG5bLQpSQs37PHpLgC+p7AMDjgW
         bOyQ==
X-Gm-Message-State: APjAAAWf6logKWyeZaxS+TWQmRSTmiF0NAdrC3sanLajw90xELv3HVVA
        SPz8G4M8gnMr9RmARkTHcrjeow==
X-Google-Smtp-Source: APXvYqzJsHSwaJsn5L+NBbiv4QM7roesrFufWYU2XCHXrcTHzejh6DulwYsZREZeSRQpa4cfz+9Jdw==
X-Received: by 2002:a17:90a:e290:: with SMTP id d16mr2606067pjz.86.1568688203384;
        Mon, 16 Sep 2019 19:43:23 -0700 (PDT)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::2])
        by smtp.gmail.com with ESMTPSA id x72sm450247pfc.89.2019.09.16.19.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 19:43:23 -0700 (PDT)
Date:   Mon, 16 Sep 2019 19:43:19 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     <davem@davemloft.net>, <anna.schumaker@netapp.com>,
        <trond.myklebust@hammerspace.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] ixgbe: Use kzfree() rather than its implementation.
Message-ID: <20190916194319.712d81cc@cakuba.netronome.com>
In-Reply-To: <1567564752-6430-2-git-send-email-zhongjiang@huawei.com>
References: <1567564752-6430-1-git-send-email-zhongjiang@huawei.com>
        <1567564752-6430-2-git-send-email-zhongjiang@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Sep 2019 10:39:10 +0800, zhong jiang wrote:
> Use kzfree() instead of memset() + kfree().
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> index 31629fc..113f608 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> @@ -960,11 +960,9 @@ int ixgbe_ipsec_vf_add_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
>  	return 0;
>  
>  err_aead:
> -	memset(xs->aead, 0, sizeof(*xs->aead));
> -	kfree(xs->aead);
> +	kzfree(xs->aead);
>  err_xs:
> -	memset(xs, 0, sizeof(*xs));
> -	kfree(xs);
> +	kzfree(xs);
>  err_out:
>  	msgbuf[1] = err;
>  	return err;
> @@ -1049,8 +1047,7 @@ int ixgbe_ipsec_vf_del_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
>  	ixgbe_ipsec_del_sa(xs);
>  
>  	/* remove the xs that was made-up in the add request */
> -	memset(xs, 0, sizeof(*xs));
> -	kfree(xs);
> +	kzfree(xs);
>  
>  	return 0;
>  }

All the crypto cases should really be converted to memzero_explicit().
