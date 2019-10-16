Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B182D9A8C
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 21:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394630AbfJPT7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 15:59:40 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39257 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbfJPT7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 15:59:40 -0400
Received: by mail-lf1-f67.google.com with SMTP id 195so5536950lfj.6
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 12:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=S5rv6G5FHb2cQfGd13qHlLrf3736MZ536jKavl7v604=;
        b=sK4lWhumqCTHdhxg2Eh5nbQxU3DwYaCydV3NfV/fF7R+67M45LhQr0IzYTp78uhG/7
         uKkHm8JTxu+jkOruTDXsbdDVYgbKkrS8crE75O1CdVm/Ud+TkV/j4KW0nn9RWbwFYUmL
         2I8VMV7hGQJ7xZHBBWUAIra4CdLlr/pUVm9wdEFm9IbKpR+iPUT71keuQUdszG2PAwdU
         LY7EMS2cW1Rl8ceN9qIH2hjye+1iHnVpIrdptnVf2+jUkdiz+Rp97am04XFLVAWZ8IuN
         fp0kzSQXrnKlX6oeAo/crmE8g6mOwV+EhG6M2VmhchGd32rxXLuwRsT7EFU/pmn40KpV
         Q/7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=S5rv6G5FHb2cQfGd13qHlLrf3736MZ536jKavl7v604=;
        b=E/KyQzlgOlZTAThB1e3MfQqoPHAzGeCfNwtFC6QfN9tbw/bJcekZgkOmDCaOhWg8NN
         HleCoU85qaBQNyvo9SBlU1kueTZROJbF69gPEbmTgsOyQGXUb9DC/fL+gNEEihAQbFSS
         RAD3LnWwaFHmh4hvkGqHRDo0ZU/U+ygrGkmgZeiOr7ja+1+iR0m6GLD/T1MkiiyDsvbi
         qIV22nO2vOgkWJJlaCDZkrqpbbratWv2XX1Hlxewvz1g7es6MXMbgRmtivkCnZU2dL2z
         PxeRWGNNujDAiKnoz3FduTQlahcL7kt2UzGaVWj5Y6VLKc11BCjp1ngWLs0g4WjL8FcC
         BkLg==
X-Gm-Message-State: APjAAAXCd0pUnhQXIOY4WyVKXdmTga3+Ogv/koh4dDKwBQg7TXbRHKk7
        2UyfKIrwRAcl8PWCD6G/abbmYclGRgU=
X-Google-Smtp-Source: APXvYqyCw00j2ujOMVgMrtDAsF+ve3ar0zwdUCljZwYbBycdtNq7KvMLJeT/2FOWkBPzuhVX1x0i+w==
X-Received: by 2002:ac2:4847:: with SMTP id 7mr4065093lfy.180.1571255977844;
        Wed, 16 Oct 2019 12:59:37 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 4sm2081050lfa.95.2019.10.16.12.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 12:59:37 -0700 (PDT)
Date:   Wed, 16 Oct 2019 12:59:28 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 net 2/4] net: aquantia: when cleaning hw cache it
 should be toggled
Message-ID: <20191016125928.24d72dce@cakuba.netronome.com>
In-Reply-To: <e39ae93c-60eb-7991-3b15-70a05aca3377@aquantia.com>
References: <cover.1570787323.git.igor.russkikh@aquantia.com>
        <d89180cd7ddf6981310179108b37a8d15c44c02f.1570787323.git.igor.russkikh@aquantia.com>
        <20191015113317.6413f912@cakuba.netronome.com>
        <e39ae93c-60eb-7991-3b15-70a05aca3377@aquantia.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 13:19:30 +0000, Igor Russkikh wrote:
> >> It was previosly always just set. Due to the way driver stops HW this
> >> never actually caused any issues, but it still may, so cleaning this up.  
> > 
> > Hm. So is it a cleanup of fix? Does the way code is written guarantee
> > it will never cause issues?  
> 
> Yes, thats a cleanup. We just had other products where this cache reset had to
> be done multiple times. Obviously doing that second time was just no-op for
> hardware ;)
> On linux this always gets called on deinit only once - thus it was safe.
> We just aligning here the linux driver with actual HW specification.

I see, in light of that explanation I think it'd be appropriate to take
the Fixes tag away and move this patch to the net-next series.

> >> +	if (err)
> >> +		goto err_exit;
> >> +
> >> +	readx_poll_timeout_atomic(hw_atl_rdm_rx_dma_desc_cache_init_done_get,
> >> +				  self, val, val == 1, 1000U, 10000U);  
> > 
> > It's a little strange to toggle, yet wait for it to be of a specific
> > value..  
> 
> Notice thats a different value - 'cache_init_done' bit.
> This is used by HW to indicate completion of cache reset operation.

Ah, ack, it's an "eyeful".. :)
