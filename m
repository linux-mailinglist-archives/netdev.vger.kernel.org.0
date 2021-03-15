Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0737F33B1C0
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 12:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhCOLvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 07:51:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32471 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230221AbhCOLvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 07:51:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615809064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KhbwYbr1JWAcOIkfOcoM79xycZKeXHZVR1gf3zwYaTk=;
        b=G4rjmNC37xZ7lXAijUBApsdQMUg73vjR/7kbvfbmMEbBIiKQif5RW2qYJBYnEEdqgdy1c0
        eaH4Art419DLcHxiBWksY9AhSKtjMVUTCRaR4mEOnS1eqfGwmzQMBaMyDwWGBaokreXb4X
        WMfoJEdLWEfxPsz23lgHKTaRyX5k1zM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-ViOpTZ7jNdK2oh73ewkBjw-1; Mon, 15 Mar 2021 07:51:03 -0400
X-MC-Unique: ViOpTZ7jNdK2oh73ewkBjw-1
Received: by mail-wr1-f71.google.com with SMTP id x9so14860313wro.9
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 04:51:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KhbwYbr1JWAcOIkfOcoM79xycZKeXHZVR1gf3zwYaTk=;
        b=pH6NgGhmRDCHdCF2oLmnuwxgxX+dzD7ZHBu7DIDxtsmBadmNFR+ZKAnxZAFB1zr75Q
         HKMPwu2pQOlrnGO66LTm/C2WDfnTJGu5LWVxRSsN/vVVwBxDDMRV/Yn6wn1MApqslHJH
         MBzmGdPwVGF5pxtAnIOb/2J+QIZ5tKLJxGcTQqSvUiGJH41zkQcIbTXs51vG0hMeEXYS
         ZgdfNRqlqtdX/Y4xkaYcvTrALHOtJM3S7eSHmCaPO0KpC7w0VZWOA9yjtgo8R0FTepeE
         gABBqgLVYlYO5hqkXjp2sBJfmQJ23mYSzg37P+MwRiuL4eOyVzciMF0Ea++rI00HYGf0
         4BtA==
X-Gm-Message-State: AOAM530iYyOI2FDPOB5AY7Gq9Q81/kUxNsVvjuFrVb7fjOjJDeDrDUTP
        4p81uJV8nFO+T+t3AkMktfNPquuHWq1pGQ476AFHjzrp6wF99Fh3zIrwk9ZA2/7bL5G4Z825kUt
        fkIJeV+NpJlqz9EZK
X-Received: by 2002:a1c:2857:: with SMTP id o84mr25471298wmo.181.1615809062061;
        Mon, 15 Mar 2021 04:51:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyj8r+wAIyoNyWKLiKRdkWWw3D0PyiO8E7h+4V9nhQzFYJxIDgAKAD8ONJqVHYJm5zq7xLASQ==
X-Received: by 2002:a1c:2857:: with SMTP id o84mr25471280wmo.181.1615809061887;
        Mon, 15 Mar 2021 04:51:01 -0700 (PDT)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id c16sm22463404wrs.81.2021.03.15.04.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 04:51:01 -0700 (PDT)
Date:   Mon, 15 Mar 2021 12:50:58 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     lyl2019@mail.ustc.edu.cn
Cc:     paulus@samba.org, davem@davemloft.net, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Parkin <tparkin@katalix.com>
Subject: Re: [BUG] net/ppp: A use after free in ppp_unregister_channe
Message-ID: <20210315115058.GA4296@linux.home>
References: <6057386d.ca12.1782148389e.Coremail.lyl2019@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6057386d.ca12.1782148389e.Coremail.lyl2019@mail.ustc.edu.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 08:34:44PM +0800, lyl2019@mail.ustc.edu.cn wrote:
> File: drivers/net/ppp/ppp_generic.c
> 
> In ppp_unregister_channel, pch could be freed in ppp_unbridge_channels()
> but after that pch is still in use. Inside the function ppp_unbridge_channels,
> if "pchbb == pch" is true and then pch will be freed.

No. It's freed only if if the refcount drops to 0. And the caller of
ppp_unregister_channel() must hold its own refcount. So
ppp_unbridge_channels() is not going to drop the last refcount in this
case.

> I checked the commit history and found that this problem is introduced from
> 4cf476ced45d7 ("ppp: add PPPIOCBRIDGECHAN and PPPIOCUNBRIDGECHAN ioctls").

Next time, please also Cc. the author of the patch.

> I have no idea about how to generate a suitable patch, sorry.

There's no patch to send as far as I can see.

