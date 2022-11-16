Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBDE62C789
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbiKPSVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239164AbiKPSVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:21:11 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73FA64A3E
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 10:21:05 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id c15-20020a17090a1d0f00b0021365864446so3194645pjd.4
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 10:21:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u6cVjAChJ4AVlCxwkfBM28wQzHHDwWAcjouqXWhWtv0=;
        b=TAdAs14Lbful+Udvw4R8t4nWfJNJO354vpWd+qBb0M7B2JmcYwzPB6EVen7VOIobO8
         vSAnMJ4TzFK9jgCYYYngNz2xTiKthiHnOcKLjnJn2Ja5zpEQPYMjDB/2MnYLMz/ajkvi
         m8bOE3dW6ZRHnXv03hWiXn9dlsk/W88PQxwyFab4AM0c6E6bkDM089vOcQbRw+asLBAe
         Xot2HzPdXvaLmT+QbWt3NJOE8H7XyXjO9nfJ6hHjITO5AeCNaskLrJwihRTqLSO/u/we
         hQTJiKfXkfUA6jK9i8BxQrz5FARyRpps8rroGsIcGhmaNzWjRhLURPMKoUZGudqngI8b
         95Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u6cVjAChJ4AVlCxwkfBM28wQzHHDwWAcjouqXWhWtv0=;
        b=AggmZwg2jhAq02kd4Q/mLpKG9F9uPMD2E3n4H+To3LI6/gdcVlwwqttt4LBTF/VTya
         PwrjGPB6BtYgH2xd8kKjWY2bX7x+dsjfdoX15fg5iFGkitbt4aNoAea5RVCjvZ6OSsmA
         RgWOPw87U/4FVPnfB93aLGERYWuq/W61Z8bfPKrWxU1m2a1m4BSMmCo4wD6c7TCK4nms
         tLiOKIh71Qjr8om4Pw+x4TA4s9h4zdlaA9o0kBLILJ0BtC+mQxMPY7hd4YfpEEiZh4Ra
         IkKWq/brsxJP0vHDX6ONRO16Z1Oj6PAc+dV9GtUgZE19drjdphB00DTQUsI8YTf9HkSt
         V/ZQ==
X-Gm-Message-State: ANoB5pktpeofVlG2euEX2Nkga709E4bXddyFh/ThHkLO5CgCt83T8Np3
        zRNLMbsB7b0/B+n/2OIUdCN4mw==
X-Google-Smtp-Source: AA0mqf7nzjTzKch/9nGOzTH3QvHpNyrU+jZU5yfJZaQYBkuAxzNpomLdK1DiQGf5OQnEtK2FzGnaOw==
X-Received: by 2002:a17:90a:8a86:b0:212:ec84:91d9 with SMTP id x6-20020a17090a8a8600b00212ec8491d9mr5063062pjn.139.1668622865368;
        Wed, 16 Nov 2022 10:21:05 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id k140-20020a628492000000b0054ee4b632dasm11196269pfd.169.2022.11.16.10.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 10:21:05 -0800 (PST)
Date:   Wed, 16 Nov 2022 10:21:02 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     <netdev@vger.kernel.org>, Paul Blakey <paulb@nvidia.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2 1/2] tc: ct: Fix ct commit nat forcing addr
Message-ID: <20221116102102.72599e40@hermes.local>
In-Reply-To: <20221116073312.177786-2-roid@nvidia.com>
References: <20221116073312.177786-1-roid@nvidia.com>
        <20221116073312.177786-2-roid@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Nov 2022 09:33:11 +0200
Roi Dayan <roid@nvidia.com> wrote:

> Action ct commit should accept nat src/dst without an addr. Fix it.
> 
> Fixes: c8a494314c40 ("tc: Introduce tc ct action")
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Paul Blakey <paulb@nvidia.com>
> ---
>  man/man8/tc-ct.8 | 2 +-
>  tc/m_ct.c        | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/man/man8/tc-ct.8 b/man/man8/tc-ct.8
> index 2fb81ca29aa4..78d05e430c36 100644
> --- a/man/man8/tc-ct.8
> +++ b/man/man8/tc-ct.8
> @@ -47,7 +47,7 @@ Specify a masked 32bit mark to set for the connection (only valid with commit).
>  Specify a masked 128bit label to set for the connection (only valid with commit).
>  .TP
>  .BI nat " NAT_SPEC"
> -.BI Where " NAT_SPEC " ":= {src|dst} addr" " addr1" "[-" "addr2" "] [port " "port1" "[-" "port2" "]]"
> +.BI Where " NAT_SPEC " ":= {src|dst} [addr" " addr1" "[-" "addr2" "] [port " "port1" "[-" "port2" "]]]"
>  
>  Specify src/dst and range of nat to configure for the connection (only valid with commit).
>  .RS
> diff --git a/tc/m_ct.c b/tc/m_ct.c
> index a02bf0cc1655..1b8984075a67 100644
> --- a/tc/m_ct.c
> +++ b/tc/m_ct.c
> @@ -23,7 +23,7 @@ usage(void)
>  		"	ct commit [force] [zone ZONE] [mark MASKED_MARK] [label MASKED_LABEL] [nat NAT_SPEC]\n"
>  		"	ct [nat] [zone ZONE]\n"
>  		"Where: ZONE is the conntrack zone table number\n"
> -		"	NAT_SPEC is {src|dst} addr addr1[-addr2] [port port1[-port2]]\n"
> +		"	NAT_SPEC is {src|dst} [addr addr1[-addr2] [port port1[-port2]]]\n"
>  		"\n");
>  	exit(-1);
>  }
> @@ -234,7 +234,7 @@ parse_ct(struct action_util *a, int *argc_p, char ***argv_p, int tca_id,
>  
>  			NEXT_ARG();
>  			if (matches(*argv, "addr") != 0)
> -				usage();
> +				continue;
>  

This confuses me. Doing continue here will cause the current argument to be reprocessed so
it would expect it to be zone | nat | clear | commit | force | index | mark | label
which is not right.


