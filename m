Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA9A33D065
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 10:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbhCPJSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 05:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbhCPJR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 05:17:58 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43D4C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 02:17:57 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id lr13so70952707ejb.8
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 02:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZLz6mUcSO3CqtdOErDOXrHNp7gGVwoIePKDfksrUqRk=;
        b=idbOni8u5FhWqR+J+Tz9vDazPbc8DlBv6aOh1pE4h1g2wB2CykU4x5cVEiTDk4fc3H
         Z3I7b9+/VlUwf0N3cfMeoDBk5KAQcHsdK8O8aBWTYLpjTZ4ULafcXbu8iexz6uvCjt1y
         ObyCG/YZ8Zac7cOkzyGPY1d8zHBcdhEHd+TCmPEfphduy8T7CB4mGWbYJpGd7L6hie+u
         MP62GLHDdG2kUegDGgMwGB5hdqZUtsJ+S8dDYDA14Dco7J1wYWsXivW1cZlkC9fWFLLh
         ri9qeNd2yYie663218TmSyqyWIvnYh0oK/JaY/GzjL69la+LP5s79nM4INrO8P3OLoaX
         fL5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZLz6mUcSO3CqtdOErDOXrHNp7gGVwoIePKDfksrUqRk=;
        b=AwElTTz3WX4rTfiu/BqFV1PvHkd6zibhw/76vorUvA9ic9yhV9h3ExiAxC2FTFX73P
         ecXnHzX/1k1ttfFPDUarUouuFpLTku6VqluXlXPlkY2sxNKL+iM17WYa+M/tlSAMXlsc
         0cgRQ6JqsvcA8WYbWADRKMrBgYyKbZGw99kJ72nZwKakk3SkOnvBqodckaL2GG/c6CKf
         KwLSeTtAfHw0dm5lK2TucDjVR8ZFEFfMbLpdUFRoasV9XvGbUOqA32Poo6oI77NrfZM9
         0fbI9EiQ+HkNCDRaJCdEAbDIjRsHDdUL1MQAN48xueoPOGTLZKIqxtzK7zjE+hNpo6v5
         k0jw==
X-Gm-Message-State: AOAM533+lse8vjDhedpoma2Yinr/sZtJ/GBtf4pbzf/XOGjQwiPgOMzO
        I7sz2k5e5Sbi9sOKTqZTN2k=
X-Google-Smtp-Source: ABdhPJw94eHX6iTW4J2nwTISvAzY05aK9pukGg9sMBQSgU4bhGNZS1xSEMigud+TDyzbGgAzIVQAfg==
X-Received: by 2002:a17:906:5607:: with SMTP id f7mr27795743ejq.262.1615886276418;
        Tue, 16 Mar 2021 02:17:56 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id si7sm9016002ejb.84.2021.03.16.02.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 02:17:56 -0700 (PDT)
Date:   Tue, 16 Mar 2021 11:17:55 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/5] net: dsa: mv88e6xxx: Remove some
 bureaucracy around querying the VTU
Message-ID: <20210316091755.uxzjhcjy4ka3ieix@skbuf>
References: <20210315211400.2805330-1-tobias@waldekranz.com>
 <20210315211400.2805330-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315211400.2805330-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 10:13:57PM +0100, Tobias Waldekranz wrote:
> +static int mv88e6xxx_vtu_get(struct mv88e6xxx_chip *chip, u16 vid,
> +			     struct mv88e6xxx_vtu_entry *entry)
>  {
> +	int err;
> +
>  	if (!chip->info->ops->vtu_getnext)
>  		return -EOPNOTSUPP;
>  
> -	return chip->info->ops->vtu_getnext(chip, entry);
> +	entry->vid = vid - 1;

Should the vtu_get API not work with vid 0 as well? Shouldn't we
initialize entry->vid to mv88e6xxx_max_vid(chip) in that case?

> +	entry->valid = false;
> +
> +	err = chip->info->ops->vtu_getnext(chip, entry);
> +
> +	if (entry->vid != vid)
> +		entry->valid = false;
> +
> +	return err;
>  }
