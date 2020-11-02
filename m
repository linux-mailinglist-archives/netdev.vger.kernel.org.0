Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64E72A2E83
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 16:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgKBPlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 10:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgKBPli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 10:41:38 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4A0C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 07:41:38 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id s25so5566362ejy.6
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 07:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VYvv4AKgonyBQR0AjmRQ1lEVfkpg+eFpgAy6ueRaH/s=;
        b=U9k+/cnsKgj56ma6tcphOczg/l0x7T2HvpaGeQ6XvxR1LFnP7uTZkFKp3ppbhSjoJ0
         XsD2abKQk09EPhDVoheSatotpCH6fMvY1VOAiaZWZb6CAOMMPavEMdbOhrk9PNGfpwzJ
         oQ3CaoVriezjN0iqLNg7dwSkAGX4/+/OE4Fv50CZtnurknT26UhYnSQUUrUQA99ddze2
         kyiWFC/LzT6RiFYQtIe2LFRV86uHPNYIZIBltjhfJRrVeJFv7d0wRKSoi2lDcJ4we36U
         RP8TNLy0R8k4V3Nblgi6God+lwlTHb6YW8zox/S6oM+hsMJfVYnKJ643EBHZVyP+Sd03
         vjGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VYvv4AKgonyBQR0AjmRQ1lEVfkpg+eFpgAy6ueRaH/s=;
        b=DTil5kjlOS7jUP5Y3nNfbjEkrWguF+fX3UAz2UYiP7gPi5TZcm5tGY/gmoprIyYz1F
         A3za6ggJNixQociSjJyUVVb0elCRNRKOrEYTfrjDklL6ByU42+kXCTp7+5GuRfvDnaYn
         FOfQzmFjL3WT/O/dl3a5gOp3MVIQs0us6+BuXAAje9naG/BD4HlsdIr892woxIf3RrYT
         aYWhLRcxRSWzsd7R7NuUwUBPQnW2T06sj5q1ekuRGCN5nAfw6DOvwBKrqyvtSzrAqnkz
         67V7/Foz2Ku8YFn/cid+ht/UlLQzw05TjQGJ8kIjTmFJWqtKige3i11/cOn97RFwf6O5
         dHlw==
X-Gm-Message-State: AOAM533eqMbF9mhGypXM6s+QdSuw0zgPPJhrrsH7XTWMR6U8iUx/WAWx
        GJFCS+uFAsZlIDwVTCornZo=
X-Google-Smtp-Source: ABdhPJxJcngr7cgxF/Df/LsTGsBJ4eQ2uKTUklTaLGIOYRHZ+aDEWPHH+dig5FmTGnYRGVtb082MCg==
X-Received: by 2002:a17:906:b18f:: with SMTP id w15mr16593976ejy.137.1604331696609;
        Mon, 02 Nov 2020 07:41:36 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id j20sm10536387edt.4.2020.11.02.07.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 07:41:33 -0800 (PST)
Date:   Mon, 2 Nov 2020 17:41:32 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: set IRQF_NO_THREAD if MSI(X) is enabled
Message-ID: <20201102154132.gfcd5t5fo4oupmre@skbuf>
References: <446cf5b8-dddd-197f-cb96-66783141ade4@gmail.com>
 <20201102000652.5i5o7ig56lymcjsv@skbuf>
 <b8d6e0ec-7ccb-3d11-db0a-8f60676a6f8d@gmail.com>
 <20201102124159.hw6iry2wg4ibcggc@skbuf>
 <e67de3a4-d65d-0bbc-d644-25d212c04fdd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e67de3a4-d65d-0bbc-d644-25d212c04fdd@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 04:18:07PM +0100, Heiner Kallweit wrote:
> According to my understanding the point is that executing the simple
> hard irq handler for NAPI drivers doesn't cost significantly more than
> executing the default hard irq handler (irq_default_primary_handler).
> Therefore threadifying it means more or less just overhead.

If that is really true, then sure. You could probably run a cyclictest
under a ping flood just to make sure though.
