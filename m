Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A42F272D4
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 01:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbfEVXQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 19:16:56 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45125 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbfEVXQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 19:16:55 -0400
Received: by mail-pl1-f195.google.com with SMTP id a5so1767173pls.12
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 16:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0V8ksX4TJfK5Lj57hsuogVErR3+ed43whm8eyRMW0uk=;
        b=xsAOoSzXMHBarO68WaCRVPmQsr8CLF9lqspDx3H2w9m9nrsHU48yL79J7qNp5DigNi
         dT23TzmEXdl/BzGyab95Tsz6K82rVvP1YMmB9T3CV4Wikwowos+AkRP+8ttw/gSJx+xC
         OxvgKd75Y5vYO1Y1RXvnc6s9lQSN6PepY5hkG9AK1H6fnI9g12CVsCijV+QaW6vptD8K
         sTldUMbsm/cEhVY6cq6xiQVhMOFfn9a9FUGxbhVQ9tRiuCc6O8Bj0/PN6APpjm8CQM+x
         Zk4SjS023BKPqDDmrlvFHJ7/04hbLVH8oxZK2QbHkFb/svrTDNNpMqf9cqhbrx739WzV
         yJIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0V8ksX4TJfK5Lj57hsuogVErR3+ed43whm8eyRMW0uk=;
        b=SYESIibFWAWuysCBEFSx5e9fdv/OH95FR5cZ3X3mG1oEwwKT7S5+vxM6wUFwc2vfs0
         YaNg4vF3hpwMJpovTzS4GxTseD/fmBXl+Gm7e32hp5TPc3hS/obDkW6Pqm0OWJvg+l87
         ONIvPJFfTndRCUkam6M7taLe+wI1rmKUbzRnH0qV6AvGRakoJ7VRcH0A9oMqK/qnsWmo
         oqwBiSlQ+xvqtrhpywaiKiNO0n0s/lDWraqYuF2zWi3GuH1WNjYJSzhXxFcmjDearHtm
         +vj3CBUrupxbAUo5qZAeL9AGxJ38iNEYMM9BhcEwABO0QlRkW2pPFb1dZHAKmlpX8oro
         +FEg==
X-Gm-Message-State: APjAAAUm5NaalfEgrFsLW2nYF5y7hR0CM3kzWxiyOd+1PKyTPAn5zIxV
        HV+l4OnSEjUIqMf0BFv0BFTCPw==
X-Google-Smtp-Source: APXvYqyR4R0m6loAWqnbF7KO/xLIJMPdwUFD6lurxx5e2EtaH6hEs5IrZ01Jpptis+3ul00gXC28pQ==
X-Received: by 2002:a17:902:1126:: with SMTP id d35mr58178594pla.82.1558567014827;
        Wed, 22 May 2019 16:16:54 -0700 (PDT)
Received: from xps13.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 1sm29429025pfn.165.2019.05.22.16.16.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 May 2019 16:16:54 -0700 (PDT)
Date:   Wed, 22 May 2019 16:16:52 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, Jason@zx2c4.com,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2] ip route: Set rtm_dst_len to 32 for all ip
 route get requests
Message-ID: <20190522161652.42104430@xps13.lan>
In-Reply-To: <20190517175913.20629-1-dsahern@kernel.org>
References: <20190517175913.20629-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 May 2019 10:59:13 -0700
David Ahern <dsahern@kernel.org> wrote:

> index 2b3dcc5dbd53..d980b86ffd42 100644
> --- a/ip/iproute.c
> +++ b/ip/iproute.c
> @@ -2035,7 +2035,11 @@ static int iproute_get(int argc, char **argv)
>  			if (addr.bytelen)
>  				addattr_l(&req.n, sizeof(req),
>  					  RTA_DST, &addr.data, addr.bytelen);
> -			req.r.rtm_dst_len = addr.bitlen;
> +			/* kernel ignores prefix length on 'route get'
> +			 * requests; to allow ip to work with strict mode
> +			 * but not break existing users, just set to 32
> +			 */
> +			req.r.rtm_dst_len = 32;
>  			address_found = true;
>  		}
>  		argc--; argv++;

Why not warn user that any prefix length (ie not 32) is ignored,
then do what you propose.
