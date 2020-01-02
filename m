Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C620912EA53
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 20:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgABT1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 14:27:42 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43830 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727951AbgABT1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 14:27:41 -0500
Received: by mail-pf1-f194.google.com with SMTP id x6so21385362pfo.10
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 11:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ptxbpox1IIAFHRiR2gnZN0uv/ZUxPhUYaeW5IxjOobs=;
        b=qYDRCt4ldE2oJn0Kz+1fovHMkKOdpKtsgjufVGALRMQUYQ5lYULBocROneGOjv8AFm
         fwOlz8+xT9EJAMhuPgXE9RAjQ2sxnOsP9YUGKA1ow72Uv4ukjZiwXTRJC8/g69qLHO3P
         qb/oMGGiA4XJY9wq7py7WazZluBYQnv2mdxnf4MT6UwFs3Uzx67OQW6bSvzHnBWnJtFZ
         9xybnyAngR/MjGl0I3YtJ1OixRX/c3RQOe+1iuov72Pf+hd1v1WW3AxFBS+6gvTERK7m
         ofSydADj+LZzWkATvOry3MN26khGLqlxLsUsdV1A92alMBuVnZ8c0ElN/s9Wy0CpHNFl
         8pvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ptxbpox1IIAFHRiR2gnZN0uv/ZUxPhUYaeW5IxjOobs=;
        b=ah2ZaZpzt7nirP3nye5KD5QzC/pc5FzZA46r1mZb5YF2+CszFwdEvpykY9hM6RxIKy
         cf7D/uuZaYIZn+LPIGfOaoJ+Uvh2cOBEmv7oc9NpzFqUCRkwizOEDWGTxTLhoeEfKL7k
         M4s2IfCJl+fsig0ltDYHdqrwiIRmi2LpD/3E0TcP3duK1DL2G20/a9G2pvTe1ZfNRqm2
         cmelA5QhPNmNf6BIT/rH7G06CT2sU7yuMNIcNMB7qKrsGxxCHmls44GshlQL3egcj6Uo
         jW39mKr1fPvFoYUDOb9tAUlDSpAh3nloE0qMkd6HXN+XpnoM6e4W32Wz/8KBFRQOQdsh
         3Gag==
X-Gm-Message-State: APjAAAUPQKEoMjuOYuFk8FHWAb/uq5mtdVrtdAtEn7fZHnMlqQSWoBcH
        7ManuNYPDp+WYHpe90Md78TwZg==
X-Google-Smtp-Source: APXvYqyN7c3JKoqmj9IxkmJAw5eadUVtCaKkLLSO6qCpgnzCVs+cNRMfzJd+3Byu9Zt9+4n2K1UfCg==
X-Received: by 2002:aa7:940e:: with SMTP id x14mr72251074pfo.42.1577993261252;
        Thu, 02 Jan 2020 11:27:41 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id b98sm12117400pjc.16.2020.01.02.11.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 11:27:41 -0800 (PST)
Date:   Thu, 2 Jan 2020 11:27:31 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Ttttabcd <ttttabcd@protonmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH] fragment: Improved handling of incorrect IP fragments
Message-ID: <20200102112731.299b5fe4@hermes.lan>
In-Reply-To: <u0QFePiYSfxBeUsNVFRhPjsGViwg-pXLIApJaVLdUICuvLTQg5y5-rdNhh9lPcDsyO24c7wXxy5m6b6dK0aB6kqR0ypk8X9ekiLe3NQ3ICY=@protonmail.com>
References: <u0QFePiYSfxBeUsNVFRhPjsGViwg-pXLIApJaVLdUICuvLTQg5y5-rdNhh9lPcDsyO24c7wXxy5m6b6dK0aB6kqR0ypk8X9ekiLe3NQ3ICY=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Dec 2019 01:19:27 +0000
Ttttabcd <ttttabcd@protonmail.com> wrote:

> @@ -267,8 +278,6 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *skb,
>  	payload_len = ((skb->data - skb_network_header(skb)) -
>  		       sizeof(struct ipv6hdr) + fq->q.len -
>  		       sizeof(struct frag_hdr));
> -	if (payload_len > IPV6_MAXPLEN)
> -		goto out_oversize;

You can not safely drop this check.
With recursive fragmentation it is possible that the initial payload ends
up exceeding the maximum packet length.
