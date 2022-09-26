Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C157C5EA64C
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 14:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235863AbiIZMi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 08:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236801AbiIZMh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 08:37:59 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A820D3C150
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 04:15:14 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id hy2so13263764ejc.8
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 04:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=8WMox82INt3NG8DXdxBCiAhnOpkRZ6GeF1Wo6LRaIs0=;
        b=fHlUexZl42jAYJygNrWKtFu4xVmeSVK/EUZmvX2ja/TEV1lEWSS6jykkLs4hWIjYXd
         pajLv53TxAjtCRKVMYJk+BQbr5cPhzSfP5nkdU0aOg4Tl/N8ZU0shkmdcZiQPZXje1qn
         qXpgj9k/dm5+6GoGgk9+or038ahzML0nqEmuHMbbHvenf+09EZN0BsumoPPEAQFBZB3t
         MJwzJhyWqu9DvXRVor/b2RUbqjm2bmS4fqV5FHMbQEujHRmaSUw+3IZ2Fmcf+Scbqe56
         HSWbYS0EsPmx+vNjTqzc0FhD6ISgerll6kaYaWTt3oVwtAktIJsiDbgFhLnzUPBcKjkE
         JqEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=8WMox82INt3NG8DXdxBCiAhnOpkRZ6GeF1Wo6LRaIs0=;
        b=dg//PRioL5L15cgyGvV5JlGO8mxc0VetOp2faTFvOeTPZCl+cHHVqiJXwjcf0hsNvK
         7qChh5dnVHuhd6Z2X4B6xwjkSxRGIve5xCevJ+orFkZ4seoPelXwZTYyRfoR08jSxaSn
         FND5+fMaI8ZNVs0nELuJ0xuFcjCs96gLhoONIshaSqGSePaqgw18+0d2zzoaysi18R4R
         R/fZa5xGlmZ1A+pXNPthV3iyd8w9c3TT9DyUGI2GuO3cssaZ7ESgsNzf7v9Ep4sfPr4s
         tEzK1ibaj9ic/uYjTgIIwvm6xhDeoNFJInvWsEzJHTMv/LFME51DcbDKdJ64YS/gm88H
         g9Bw==
X-Gm-Message-State: ACrzQf0uPXmQs4d+s9q4/w/M0fbbpr0B+RPaglwaj2XHkax0VVw93Cx/
        M0zrWWBGlVF0grKc6bOHwkJaaw==
X-Google-Smtp-Source: AMsMyM4TlFAcqtvK6taDo98ph1dkiwAuBhqu3cAlZrTQL9ERbsFC8ph9W82EiDY13fGfXzYdfAduaw==
X-Received: by 2002:a17:906:cc4b:b0:772:3844:6ab2 with SMTP id mm11-20020a170906cc4b00b0077238446ab2mr17203597ejb.211.1664190840404;
        Mon, 26 Sep 2022 04:14:00 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id u17-20020a50c2d1000000b0044e8d0682b2sm11628994edf.71.2022.09.26.04.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 04:13:59 -0700 (PDT)
Date:   Mon, 26 Sep 2022 13:13:58 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Phil Sutter <phil@nwl.cc>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        dsahern@gmail.com
Subject: Re: [RESEND net-next PATCH] net: rtnetlink: Enslave device before
 bringing it up
Message-ID: <YzGJdsH1csfPc8gM@nanopsycho>
References: <20220914150623.24152-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914150623.24152-1-phil@nwl.cc>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Sep 14, 2022 at 05:06:23PM CEST, phil@nwl.cc wrote:
>Unlike with bridges, one can't add an interface to a bond and set it up
>at the same time:
>
>| # ip link set dummy0 down
>| # ip link set dummy0 master bond0 up
>| Error: Device can not be enslaved while up.
>
>Of all drivers with ndo_add_slave callback, bond and team decline if
>IFF_UP flag is set, vrf cycles the interface (i.e., sets it down and
>immediately up again) and the others just don't care.
>
>Support the common notion of setting the interface up after enslaving it
>by sorting the operations accordingly.
>
>Signed-off-by: Phil Sutter <phil@nwl.cc>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
