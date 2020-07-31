Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E40234D69
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 00:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgGaWEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 18:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgGaWEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 18:04:22 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F386C06174A
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 15:04:22 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id h7so30218543qkk.7
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 15:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ap8lYOY9D1Pl4j2a4z4H0d7Fb7XlWr+FQV/Dul+0ry4=;
        b=spBp3OdISINgpKkpS7KqT/OqGFCM4Ak6uM++tR+l0QQMbHCj148Yu/nqPXGygU6066
         wl34tgx58KiZ5piWwh9P0YtP/AFz6PZEsAtBDFNqJyW2U4MJsJo2BGjWzg7FYe02CNax
         jrvtUicUmtx7sLQRd+ns0rCEurxrs+i7CS9eWZW8Q9lNk/ygYZfxLDFKJ/gwNHv3CFVc
         EkwA+SgnFEshS5VO+7OjDkbOcmx6GxE/gUdwJTL6inmEJ8vtj7lO+HdZEdUuch4HWnz7
         W46rm0dyhza8FJ4xT0IcESKva2NI8jkhlEN3Mpt4QSdbml6fBJeLWfrNCEhKpifEaTT7
         at2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ap8lYOY9D1Pl4j2a4z4H0d7Fb7XlWr+FQV/Dul+0ry4=;
        b=d7+wC8fvNJHltA3QobIUIcGl6+fAMBpu26pPcvOoxRIyIRefinjZ2q0KbuHxc5cz6b
         F3EQ4JMkHsgIoiN9do1QZeFnt4L4FzmWsOAKG3bHM/Qn4SidXACBqaPAAvucSNqb48Z/
         H7kg+oRJUyEWcw/NAeA0EJBHiwuY3LeXf58a7pyeJgZ81wbcagZ0ie2MlX5uVx8snmTl
         4FTBnIgelcSRkO69fBEF/H8nbBw1Hg1ECejmXMo91X9PHv2pxdGx0aHuKW6WdqeO4uA1
         ECPjHobA2fSft3/hAJsnvreTu2THSt3vsKlPFEg2nlij8yPI89d1jvY7O1N3+PlsJpT9
         52FA==
X-Gm-Message-State: AOAM5322hoJDTkgbBMjeuFErbLGI3tqVPOf4pa5EEnNVdtNVS2ZaFmn6
        tXGB8UJsRfb+gO5pkBGtKX4miBdx
X-Google-Smtp-Source: ABdhPJz29o7tge/n02FKSErxVj9EzoRzjsN1VOPlTLsmEBxSIRXwweKCf8m0O/XlecS9Oju/kJBV1g==
X-Received: by 2002:a05:620a:4ec:: with SMTP id b12mr6203056qkh.266.1596233061255;
        Fri, 31 Jul 2020 15:04:21 -0700 (PDT)
Received: from localhost.localdomain ([138.204.24.108])
        by smtp.gmail.com with ESMTPSA id y9sm10425606qka.0.2020.07.31.15.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 15:04:20 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 00D91C0DAC; Fri, 31 Jul 2020 19:04:17 -0300 (-03)
Date:   Fri, 31 Jul 2020 19:04:17 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, tom@herbertland.com
Subject: Re: [PATCH net] net: gre: recompute gre csum for sctp over gre
 tunnels
Message-ID: <20200731220417.GD3398@localhost.localdomain>
References: <6722d2c4fe1b9b376a277b3f35cdf3eb3345874e.1596218124.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6722d2c4fe1b9b376a277b3f35cdf3eb3345874e.1596218124.git.lorenzo@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 08:12:05PM +0200, Lorenzo Bianconi wrote:
> The GRE tunnel can be used to transport traffic that does not rely on a
> Internet checksum (e.g. SCTP). The issue can be triggered creating a GRE
> or GRETAP tunnel and transmitting SCTP traffic ontop of it where CRC
> offload has been disabled. In order to fix the issue we need to
> recompute the GRE csum in gre_gso_segment() not relying on the inner
> checksum.
> The issue is still present when we have the CRC offload enabled.
> In this case we need to disable the CRC offload if we require GRE
> checksum since otherwise skb_checksum() will report a wrong value.
> 
> Fixes: 4749c09c37030 ("gre: Call gso_make_checksum")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
