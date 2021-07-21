Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1293D1693
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 20:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238697AbhGUSB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 14:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239290AbhGUSB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 14:01:57 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C0CC061575;
        Wed, 21 Jul 2021 11:42:31 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id b12so1413585plh.10;
        Wed, 21 Jul 2021 11:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0ew7m7SUbK8KldmxUiyHmG0bNK/g1aMZqNB+ugfhvrg=;
        b=VKVbhP84vp4BGV2sU5tm16GM66xXfRjFL8JvEIA+TrM/R8mtdmvYSB7C0vpRr3iV9f
         mvgIDn62KPRYn/fwhqWI4xKsanzfYDSD1CqLxaP/Wg6r1mc6rGtqLXfpbHZhgiXv0mJY
         NVAp9cDxF+uMzHE4PPznhPgwMU413wULBqeYPxN4ojoxWwzeNJL7ndbRVK1VWQAfGggm
         C/aXxMpF0l4sTtGg0l+N20NFiV1wOYmGqHM8PDaJ4LKHNEl2QXzFx9qR90G8mb9wIa4i
         ZjnQ9s2DFDBkRKQ5UPlgKDjMR5E0z69EvxJUysjUWjcuZFwfKnZLFYnoMtld4dwRp6nL
         KJvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0ew7m7SUbK8KldmxUiyHmG0bNK/g1aMZqNB+ugfhvrg=;
        b=tL3awq+RYYwqIFH3UEy9v2qmgtaIj4BSKtiNdU60FdxYsbWjLS35e96Q1Uxr3X1Hvh
         eduLieIief0b+QXHi70K1HH9nKrQ38APBAEvie2wt2hZ+MEvasfxYT8JNlgHKmHUQASY
         CTldjNUL855bnhtUr9CvjNBrkuoiA4lJNOdViusvnT7mYFhIkT4PtVGMa9raiuUMBSvG
         Hfn94b4/3t6yVUB1sWwHneZmMefHKrjLltwg22wG5Xg5g3421rQVTtltXP7QaioFzPJ8
         LNealNt+bJi8dvh0Fiobys3DnTLMw65ZrLRA9wZg2CUIgepvyFJh0oc+iY8P+r6VEjGq
         s7QQ==
X-Gm-Message-State: AOAM533ziHTOwF83Ct0AW05LGf0Xh54S24J6nzDaK7ceN8QTxD+dmy3u
        QAn+sqhm+C4ZQAGvYboznE4=
X-Google-Smtp-Source: ABdhPJy95wMizfWeHJ/SDhWQuIVM/Mli/eU2hPSUj8ktKUR3k36/yzEwZuT9OzzRGn9GUCTTfXsQzA==
X-Received: by 2002:a17:902:fe87:b029:12a:ef40:57a2 with SMTP id x7-20020a170902fe87b029012aef4057a2mr28710506plm.81.1626892951420;
        Wed, 21 Jul 2021 11:42:31 -0700 (PDT)
Received: from horizon.localdomain ([2001:1284:f013:bdcf:961b:3613:110d:86ce])
        by smtp.gmail.com with ESMTPSA id f11sm31713406pga.61.2021.07.21.11.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 11:42:29 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 32D86C087C; Wed, 21 Jul 2021 15:42:27 -0300 (-03)
Date:   Wed, 21 Jul 2021 15:42:27 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org,
        Jacek Szafraniec <jacek.szafraniec@nokia.com>
Subject: Re: [PATCH net] sctp: do not update transport pathmtu if
 SPP_PMTUD_ENABLE is not set
Message-ID: <YPhqk1Sx5FKYyiK+@horizon.localdomain>
References: <a0a956bbb2142d8de933d20a7a01e8ce66d048c0.1626883705.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0a956bbb2142d8de933d20a7a01e8ce66d048c0.1626883705.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 12:08:25PM -0400, Xin Long wrote:
> Currently, in sctp_packet_config(), sctp_transport_pmtu_check() is
> called to update transport pathmtu with dst's mtu when dst's mtu
> has been changed by non sctp stack like xfrm.
> 
> However, this should only happen when SPP_PMTUD_ENABLE is set, no
> matter where dst's mtu changed. This patch is to fix by checking
> SPP_PMTUD_ENABLE flag before calling sctp_transport_pmtu_check().
> 
> Thanks Jacek for reporting and looking into this issue.
> 
> Fixes: 69fec325a643 ('Revert "sctp: remove sctp_transport_pmtu_check"')
> Reported-by: Jacek Szafraniec <jacek.szafraniec@nokia.com>
> Tested-by: Jacek Szafraniec <jacek.szafraniec@nokia.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/output.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index 9032ce60d50e..8d5708dd2a1f 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -104,8 +104,8 @@ void sctp_packet_config(struct sctp_packet *packet, __u32 vtag,
>  		if (asoc->param_flags & SPP_PMTUD_ENABLE)
>  			sctp_assoc_sync_pmtu(asoc);
>  	} else if (!sctp_transport_pl_enabled(tp) &&
> -		   !sctp_transport_pmtu_check(tp)) {
> -		if (asoc->param_flags & SPP_PMTUD_ENABLE)
> +		   asoc->param_flags & SPP_PMTUD_ENABLE)

Lacks a '{' here at the end of the line.

Other than that:
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

(please add it on the v2)

> +		if (!sctp_transport_pmtu_check(tp))
>  			sctp_assoc_sync_pmtu(asoc);
>  	}
>  
> -- 
> 2.27.0
> 
