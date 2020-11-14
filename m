Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0393D2B2A48
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 02:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgKNBDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 20:03:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgKNBDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 20:03:53 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DC3C0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 17:03:52 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id me8so16401576ejb.10
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 17:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xLpTENXiXDwIRw497rV07cth6tNrgrnbavlNyTzYUkY=;
        b=e2OOkZ9MDMhHIcTFEfgZHJM2T3Q6Xx0CsfD+IdXtB0J/s4cM5c7glUaOd/NDx1zIYY
         MdTnil+gwqmnHBUnxoZ89+NcnawZR2PEGTczBfkT5mG1szj9JT9v6rny5QxJjM1d0klQ
         EwpdCq+0sPh7KaL2LXXl2WscC3170yIbfM3Q5TTLtBy0oGKNXPpkDYn9Jh5zdVpXCcrx
         gnPkRAZHS/aZU0A89AMmxHhJc35ZKjCUF46AmBnFheajdLCHe9zx1WA6m5c58+ilHdPv
         nN2QlJuJxrLm8jS1SKbUgx/sRvjQWrEsfiSccMQqr8HmcSFRqt6IZ6SvdqsgtC5UjhqS
         cPDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xLpTENXiXDwIRw497rV07cth6tNrgrnbavlNyTzYUkY=;
        b=UrV6zG9YWvLxm3zBTb56rGPlDjFCU8ydQ/i2mdsqH29wuuBSiMl05J0YcSNmGEzjrK
         FQCdkUAyi14O2hthGdEwLAwnuZmMPl8iYSclUQckcPjAQ4F//YX5mymusM3FJrYyt698
         33XtKqFfcOqL7CbubiTlPgaiD8CdRgqeAyK7SDITT4JcWTXkS8j6vDWG8zblVyTopvlp
         wHsjBBFkxu21BIbyDKlisF/JxWuwpMgiNLhn4mS3ATsFeW9bPPEceEfk1b0aUkq5/Fgw
         SfgA1iJwHF91T693NJY3LwDlUdivdLteCmh4EZXvPPII8sLP1jEQl7g8TpNPixnWSZD9
         Uz9w==
X-Gm-Message-State: AOAM531p1Nj94IPin8aDBc/gPlt5oE3NjOepFk48mlJCpdFGoL/Qbvkm
        DvFNwHcsnoph6JChK3bp0Ns=
X-Google-Smtp-Source: ABdhPJxY2jCmfDM9YqQRMtJLM6z3EfCSNhXBl+JKJ3Tl+ZA6TeSZ6y7HrRLuCGKZf+tZEObOSssBMw==
X-Received: by 2002:a17:906:1497:: with SMTP id x23mr4969535ejc.457.1605315831510;
        Fri, 13 Nov 2020 17:03:51 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id f19sm5132175ejk.116.2020.11.13.17.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 17:03:50 -0800 (PST)
Date:   Sat, 14 Nov 2020 03:03:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/2] net: dsa: tag_dsa: Unify regular and
 ethertype DSA taggers
Message-ID: <20201114010349.xwago6rlwqxcwgug@skbuf>
References: <20201111131153.3816-1-tobias@waldekranz.com>
 <20201111131153.3816-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201111131153.3816-2-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 02:11:52PM +0100, Tobias Waldekranz wrote:
> Ethertype DSA encodes exactly the same information in the DSA tag as
> the non-ethertype variety. So refactor out the common parts and reuse
> them for both protocols.
> 
> This is ensures tag parsing and generation is always consistent across
> all mv88e6xxx chips.
> 
> While we are at it, explicitly deal with all possible CPU codes on
> receive, making sure to set offload_fwd_mark as appropriate.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
