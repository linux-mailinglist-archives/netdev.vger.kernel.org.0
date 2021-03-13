Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B544339DF0
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 12:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbhCMLpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 06:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbhCMLov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 06:44:51 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F4EC061574
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 03:44:50 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id x21so11613064eds.4
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 03:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rf0OnTX1XAPOi8QpiEOIuyStgyS3JM3FfHL4z1qbsWE=;
        b=W0p/Fs/ezAY3gCRNAa2DJQOXdLb+I9qNpVUTaWK4P9q0N0GLhYyHAWMPnmIZFrQ36O
         tNHIVUqTX0pZ4dcKAIvF/MUBIqV4kkVfxOxe9XWpgEb1DMO/xGwh67rI59FOmQpX7WpS
         bFAqETJBpeEvnIlOvorBpHr9QUo9iTYcbrorA4ELHOZRLmeCKf3zu1fXxOlyiTk8eux5
         1isF88rtNPdH5tUY7WsAUC8VoP4w2YQADb1CiAYoBmPr1W6U6IC6RsgB1wq5XuLkEHdK
         f/+wX5ijfoRVgUYjCf+EgAyI59IkQ2x89zxnXcThJyfmnLZictzmfJNapiD3jBWBmtP2
         X3eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rf0OnTX1XAPOi8QpiEOIuyStgyS3JM3FfHL4z1qbsWE=;
        b=TfHld09SrL9z5trFpaZ8MuOEEmkMfhCHbcHrpQVyFOL+NP4b1k4GRmjIbQLu3MECBT
         hkc527Nasm4Hrmqj0Z5veVeTPBrleDriBdo5JHXhFEhABheZpDqUdYsrf+itdq05C1ML
         RESmgESCEXd2W2uZaFQMg8r6vMW4N4qiBFPZ0NRiAy62OMoP4HELH5EvZczxf2XuaNru
         lCD5eZcbm8mEHeXh3YRcye7xB2gbRiBA9vK2IMKIMDPKmlnfdBXCgknR3LAWuUguC1L4
         YA3upSvE1DH7GDdBz8Sc1xUTGhs7FxCfJHnZ/x9loOmllv6XZlTZYHDFqKB0rEj8q1Y7
         sDZQ==
X-Gm-Message-State: AOAM530d7UOB+1LXKE7AIFsyW5+MotYg1oIbcsuaBLoh1oHRltiITqY0
        Dp/mRc7kzCQbE4ylSHwsSD8=
X-Google-Smtp-Source: ABdhPJzxBK+2TMc5NzYa8zjlUjcJ3svV3J7QnJe38+HwliJ+DUh3ZGvB0OGCW42LwrLMVmo4QtiNNQ==
X-Received: by 2002:a50:f314:: with SMTP id p20mr19457929edm.236.1615635889556;
        Sat, 13 Mar 2021 03:44:49 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id a9sm762377eds.33.2021.03.13.03.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 03:44:49 -0800 (PST)
Date:   Sat, 13 Mar 2021 13:44:48 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/4] net: dsa: hellcreek: Move common code to
 helper
Message-ID: <20210313114448.xlkiesdhwwvnjv6y@skbuf>
References: <20210313093939.15179-1-kurt@kmk-computers.de>
 <20210313093939.15179-4-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210313093939.15179-4-kurt@kmk-computers.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 13, 2021 at 10:39:38AM +0100, Kurt Kanzenbach wrote:
> There are two functions which need to populate fdb entries. Move that to a
> helper function.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/dsa/hirschmann/hellcreek.c | 85 +++++++++++++-------------
>  1 file changed, 43 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
> index edac39462a07..38ff0f12e8a4 100644
> --- a/drivers/net/dsa/hirschmann/hellcreek.c
> +++ b/drivers/net/dsa/hirschmann/hellcreek.c
> @@ -670,6 +670,40 @@ static int __hellcreek_fdb_del(struct hellcreek *hellcreek,
>  	return hellcreek_wait_fdb_ready(hellcreek);
>  }
>  
> +static void hellcreek_populate_fdb_entry(struct hellcreek *hellcreek,
> +					 struct hellcreek_fdb_entry *entry,
> +					 size_t idx)
> +{
> +	unsigned char addr[ETH_ALEN];

You could have assigned:

	unsigned char *addr = entry->mac;

and avoided the memcpy, but it doesn't really matter much.

> +	u16 meta, mac;
> +
> +	/* Read values */
> +	meta	= hellcreek_read(hellcreek, HR_FDBMDRD);
> +	mac	= hellcreek_read(hellcreek, HR_FDBRDL);
> +	addr[5] = mac & 0xff;
> +	addr[4] = (mac & 0xff00) >> 8;
> +	mac	= hellcreek_read(hellcreek, HR_FDBRDM);
> +	addr[3] = mac & 0xff;
> +	addr[2] = (mac & 0xff00) >> 8;
> +	mac	= hellcreek_read(hellcreek, HR_FDBRDH);
> +	addr[1] = mac & 0xff;
> +	addr[0] = (mac & 0xff00) >> 8;
> +
> +	/* Populate @entry */
> +	memcpy(entry->mac, addr, sizeof(addr));
> +	entry->idx	    = idx;
> +	entry->portmask	    = (meta & HR_FDBMDRD_PORTMASK_MASK) >>
> +		HR_FDBMDRD_PORTMASK_SHIFT;
> +	entry->age	    = (meta & HR_FDBMDRD_AGE_MASK) >>
> +		HR_FDBMDRD_AGE_SHIFT;
> +	entry->is_obt	    = !!(meta & HR_FDBMDRD_OBT);
> +	entry->pass_blocked = !!(meta & HR_FDBMDRD_PASS_BLOCKED);
> +	entry->is_static    = !!(meta & HR_FDBMDRD_STATIC);
> +	entry->reprio_tc    = (meta & HR_FDBMDRD_REPRIO_TC_MASK) >>
> +		HR_FDBMDRD_REPRIO_TC_SHIFT;
> +	entry->reprio_en    = !!(meta & HR_FDBMDRD_REPRIO_EN);
> +}
> +

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
