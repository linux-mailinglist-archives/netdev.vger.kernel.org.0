Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCE443E4A0
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 17:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhJ1PMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 11:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbhJ1PMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 11:12:15 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F638C061570;
        Thu, 28 Oct 2021 08:09:48 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id y207so8669878oia.11;
        Thu, 28 Oct 2021 08:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=aADjUL3aoYVuhKrrOmc9kzerdnVVqgXoXwAZgyL/N/U=;
        b=XhbAQtELL3EMSWLYvjyRKjO2fpf7UQsdykJZwmwrectdPQoafcCTXv7f2Tv3Kj1TpH
         NbPhrBiBvkL+pjmZty2UnaWe+uc+j7oXqnV9SkhO0IEQLuPCGYhA3oua7lXP64wlelgu
         4RZlopnYPUB/nOGOfC8f9WFATE4fbybuNaZTARKRYwfjeqFgmeZvkUmkWZeruAsge3dD
         nTiQf2uc0Ywu0d32ZIva1O25nq5SlipgSsk+eM9Aatu3fKSC87lyibiZgfUpjknbnLC+
         9ra3/2q75DAO20i/xQkAbWLnChpkE794s86Z1qwKYP4sDvL8ejDZIjMpkltf5ojxw0Ti
         6mjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aADjUL3aoYVuhKrrOmc9kzerdnVVqgXoXwAZgyL/N/U=;
        b=SDc5PXnTgKHVmbo83xBzF6RQwr+kKMqklGAz9v8ZrYf9Zf1slC9E1WDrYvxYELZ6B+
         q0BapwPqNN2GmMFXEWZ/WfLf82dNloXYi4vivO3bw5p6VblKdtmVCosj2MMbeeLFvPsT
         DXPk1GeznAt4i32InWfPG8uLIHA2FmuAnmNnrRE2va8Upd4e8OvTRNjLdeXXzIi70gZ3
         McHtAduMAFQ75fuzjqUfbIeU4E7NztYxZBgVWfHK2U6jnT1ZQ7HeunW9jhq+zwtE3E2U
         e35r7CCc42C5RFLdOhwF7OhNo/gTV3vLW7HL3LYurqXdILc2OE6O1pnxAcRLEqgawCio
         noOw==
X-Gm-Message-State: AOAM530s4Z87GwkLI8wpDe8VN/SSLoED37TLrhI++i/okVKvAhnVdiB0
        aR/gwKmHE9g8geqD16vE2cmcfM4l3yE=
X-Google-Smtp-Source: ABdhPJzb+xizXUPt5P6p1qkqBpQXPH+lSyzWHcorceIZANn1ZP7Wz97agKdRsJturFMltGumuSh4MQ==
X-Received: by 2002:a05:6808:23cb:: with SMTP id bq11mr3469368oib.139.1635433787557;
        Thu, 28 Oct 2021 08:09:47 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id v66sm1149541oib.18.2021.10.28.08.09.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 08:09:47 -0700 (PDT)
Message-ID: <7e5514de-01ec-060f-cbc3-1b777e134a54@gmail.com>
Date:   Thu, 28 Oct 2021 09:09:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH net-next] neigh: use struct {arp, ndisc}_generic_ops for
 all case
Content-Language: en-US
To:     Yajun Deng <yajun.deng@linux.dev>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211028122022.14879-1-yajun.deng@linux.dev>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211028122022.14879-1-yajun.deng@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/21 6:20 AM, Yajun Deng wrote:
> diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
> index 922dd73e5740..9ee59c2e419a 100644
> --- a/net/ipv4/arp.c
> +++ b/net/ipv4/arp.c
> @@ -135,14 +135,6 @@ static const struct neigh_ops arp_generic_ops = {
>  	.connected_output =	neigh_connected_output,
>  };
>  
> -static const struct neigh_ops arp_hh_ops = {
> -	.family =		AF_INET,
> -	.solicit =		arp_solicit,
> -	.error_report =		arp_error_report,
> -	.output =		neigh_resolve_output,
> -	.connected_output =	neigh_resolve_output,
> -};
> -

neigh_ops are used by net/core/neighbour.c; this change breaks those
references.

