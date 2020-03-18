Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5492F18A20E
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 19:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgCRSCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 14:02:10 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40408 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgCRSCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 14:02:10 -0400
Received: by mail-pg1-f193.google.com with SMTP id t24so14105447pgj.7;
        Wed, 18 Mar 2020 11:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9X7tDrmUL0L//7N8M2i92Ik51zKFFPsFFM40oxZGF0U=;
        b=HXz2X7B/GeGwgkG0XWRn8Bjf8YZUjh9/2lnZ6gFpCKc5VvEfx3dtQfm1BVjYRtJT3l
         C+v2PnoLKGVTXWB3Jqq6ZmzVzUr8adya2B3iYNPy4CUlbSt8KmkXnE0EK/XLES1cUbzR
         avMzO49dt87P2JFhASIqHSWDIuNp3HalGpEo373pXd7EEivTUojCNMdSUSaMwsDowxuF
         tp8+UqFk+cCxRN4+bz09t1yqlChMnkOuVvjC1HsoEUpyZ2crjaqRGsYb8iNoXepbCdNG
         /VOc7950xI1cTFaiwsWG1zCUKdoqpR020f8LQ9KMQXrUJ9sT2fcYpgmpKLnc9qNoTQHX
         TwuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9X7tDrmUL0L//7N8M2i92Ik51zKFFPsFFM40oxZGF0U=;
        b=LdqptBPkYmy+QMisu6QzZPyeFNufCY2xUyV1jfFvo32CHGkDs1KIpfD9iF2Zl2E4c0
         8abHjlVczlewQX2GNuE/xQRLlY3u/lYKc15p9MpYnJqOu9w/K3wfpLyNrr98Bq3em6En
         qSBnnarO6hoAYUahuStvemBK6Nk+fk18x7oJaPeke45Fg5RZ1Ly6teN5ACeGUYegLy//
         WUv7eXkCdcoG8NWFG57ObMSIWTTUbi1HSCKf7WMSEAGelLnibhyCf4MKj5kMR0crst/C
         d/2Z4EC0dj2ncvfWU+5LD8uu45tMCFiXe5qFMqzCl2mx0eQAcRPqzpb7bXbFj6hEVooV
         kNfw==
X-Gm-Message-State: ANhLgQ2KYdC2KOuv0X5R+VZadyU6LvXn92aaxEeBWjQZFamN3Km0lAeA
        23GtFegbCdUeC6TsNd1lpDvD2Uaw
X-Google-Smtp-Source: ADFU+vv9CafcsMN4KTE3Q3A608AdB9Pfgiokt/+7lncsqo674RymhuMEObUUbvu3u0K6QrqKNFOZ/w==
X-Received: by 2002:aa7:9790:: with SMTP id o16mr5607556pfp.322.1584554524630;
        Wed, 18 Mar 2020 11:02:04 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id z11sm7119471pfa.149.2020.03.18.11.02.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 11:02:03 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: don't auto-add link-local address to lag ports
To:     Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Moshe Levi <moshele@mellanox.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        netdev@vger.kernel.org
References: <20200318140605.45273-1-jarod@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8a88d1c8-c6b1-ad85-7971-e6ae8c6fa0e4@gmail.com>
Date:   Wed, 18 Mar 2020 11:02:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200318140605.45273-1-jarod@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/20 7:06 AM, Jarod Wilson wrote:
> Bonding slave and team port devices should not have link-local addresses
> automatically added to them, as it can interfere with openvswitch being
> able to properly add tc ingress.
> 
> Reported-by: Moshe Levi <moshele@mellanox.com>
> CC: Marcelo Ricardo Leitner <mleitner@redhat.com>
> CC: netdev@vger.kernel.org
> Signed-off-by: Jarod Wilson <jarod@redhat.com>


This does not look a net candidate to me, unless the bug has been added recently ?

The absence of Fixes: tag is a red flag for a net submission.

By adding a Fixes: tag, you are doing us a favor, please.

Thanks.

> ---
>  net/ipv6/addrconf.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 46d614b611db..aed891695084 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -3296,6 +3296,10 @@ static void addrconf_addr_gen(struct inet6_dev *idev, bool prefix_route)
>  	if (netif_is_l3_master(idev->dev))
>  		return;
>  
> +	/* no link local addresses on bond slave or team port devices */
> +	if (netif_is_lag_port(idev->dev))
> +		return;
> +
>  	ipv6_addr_set(&addr, htonl(0xFE800000), 0, 0, 0);
>  
>  	switch (idev->cnf.addr_gen_mode) {
> 
