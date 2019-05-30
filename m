Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B591D30140
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 19:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfE3Rwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 13:52:32 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:32838 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3Rwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 13:52:32 -0400
Received: by mail-pl1-f195.google.com with SMTP id g21so2875976plq.0
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 10:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LszvIaVzF8gg9qGOdsPQ9w7knU9w6rT/n2TiESptiwg=;
        b=kKDZotTGs0B5O5W3AcUTMWax6YfGKHLZtpR2tbOeuAmUN+sxBGoN1ulnSUQVUHtQ+0
         3G9l0txMbg7rvTB6+qgWVelbxMrUQ50NgUuHqiNH/78rcrtc5XJQkgV2jrq4k0emjTMk
         nNTIpYWRJohtps38WLsrzaw//Zc/eBNEQ/6PlyIDVSqx6mnEBgNy8FOsybIIAwVvfNh5
         B2qoSSqumzEuN4cVVF3bY3jdFF8R41B/IAV7t1udpG8zLJLKQBpYeXBRJXHMMlE+aaiu
         38EOXnJdh/YcEaWMNaGELsWTvFNTyRdhBIAtB9ByLdEsGkskYsPvTaf7n8VfchBG30c2
         GVWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LszvIaVzF8gg9qGOdsPQ9w7knU9w6rT/n2TiESptiwg=;
        b=mTcpog277NYxzYoCJyzZA/MfF3IVcLxvRLX295+KvnEldqDUtxjKLPWKSF06VzrBV8
         FMONYBuQmd1ub0wiDAnlmng1oV0qXMn17nx7R/3TWGz8yXzbMRo24CbLBbpJCUellzPe
         iq1hFmbNT/b8NljN9neswgFRGX9iuj2yoTf9I0f5jb0ELs2BGyqL6O/Va182Szqg9DSR
         qgfs/iZgTGTQ2GACKM3Wk7ssH0zyj48xUOrmFuL1PpIiFB6j1PU6jmIfU+rWe/Ff0bhX
         ObVGaTNhsDwnItVawpyVLnSrUe5+ZcaII875HNBOkZ9lWF9juIlnUUHizS39m3zbaLPO
         gBUw==
X-Gm-Message-State: APjAAAVHpdAdvTU7j138JqS2/BLZQ72tO985OBn2hTqDCotL+6lrRUPy
        rDmMyrjRTOuNwMvrBRBHyVBj/g==
X-Google-Smtp-Source: APXvYqzt7nwfgAgdiayJ9nLleFiW/x9mu07x5KM7z9+dCfx6YwaOuRKuQ+FJjgmoMXW1de3qlVuTnQ==
X-Received: by 2002:a17:902:1003:: with SMTP id b3mr4910122pla.172.1559238751359;
        Thu, 30 May 2019 10:52:31 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q20sm3056913pgq.66.2019.05.30.10.52.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 May 2019 10:52:31 -0700 (PDT)
Date:   Thu, 30 May 2019 10:52:29 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next 7/9] Add support for nexthop objects
Message-ID: <20190530105229.6951bffa@hermes.lan>
In-Reply-To: <20190530031746.2040-8-dsahern@kernel.org>
References: <20190530031746.2040-1-dsahern@kernel.org>
        <20190530031746.2040-8-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 May 2019 20:17:44 -0700
David Ahern <dsahern@kernel.org> wrote:

> +
> +static void print_nh_gateway(FILE *fp, const struct nhmsg *nhm,
> +			      const struct rtattr *rta)
> +{
> +	const char *gateway = format_host_rta(nhm->nh_family, rta);
> +
> +	if (is_json_context())
> +		print_string(PRINT_JSON, "gateway", NULL, gateway);
> +	else {
> +		fprintf(fp, "via ");

I was trying to get rid of all use of /fprintf(fp, / since it was
indication of non-json code and fp is always stdout.

Maybe
	print_string(PRINT_FP, NULL, "via ", NULL);
	print_color_string(PRINT_ANY, ifa_family_color(nhm->nh_family),
			"gateway", "%s ", format_host_rta(nhm->nh_family, rta));


			   
