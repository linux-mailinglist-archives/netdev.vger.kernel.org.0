Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94CB13A3785
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 01:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhFJXCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 19:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbhFJXCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 19:02:08 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02437C0617A6
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 15:59:57 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id my49so1572667ejc.7
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 15:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tLVSEUeWe1hjAG8vUUSV1jIQXrPXnYapan9xB17sJAY=;
        b=K0h5wjKAyXZCenH7OhFcproTVJxIv2zUk5G3eY9+rW5WGT0+S7jvNzpWyOqEVDfZsa
         /8M5AZbnbbthNOtzcOEbF2P714AQERHyyzXYTzVTny3+hLQS1tHfUCb4Kpp2u21x8wXS
         jLfn2sRuumRupF6qcjd2I/C6Dp4Qeaj1BjLn4x17D6Ejz0LmJDuhnkLs5qmZX3PTTF3x
         cr4w0KV+1Fs1ywA6sinVgR55Sx8jyhGbpKygx04HRK6QesPJ/Zf1XvvYXPtX4XF8p1e+
         56QtRGZj569bvVOmekJfVIOqqRPA22ZxOh22ti3pWRLXlVbPW3pd1fdkrCQE24iOBCJT
         irag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tLVSEUeWe1hjAG8vUUSV1jIQXrPXnYapan9xB17sJAY=;
        b=jsRo5j72nTrs2RA4oNmy3uzInvBgPvBl8VzxdGxRbObHyBKman29Rm23+RxZhb97lo
         ryXquRQZllBN/wwf5ezLTN8/s3RATzsvLnYdeBADful5Ffeh487wtsCDA57jWKI7eAAC
         nCWllTyd4KsptFKVHiBsCMCylpo3Rzp7IlgpNgW5fTWMtyWhsFRtHiXUXuf/ugOYqCuI
         2NVPg+FnorSkznz8c+3sPrUD6URXhgm/KpQ6UquVATLZKpvlITY5O5Y2GbuMWukZxLJZ
         x+nkSOm+s/PXSHacM8akhsw3LjzVNmjoklaFveyW12QGY+TmZsYnFb9IQyCs57z208He
         tQiw==
X-Gm-Message-State: AOAM530THwxlGIHr1r80TEUhXLSwygSEl2wFhAZ/bfbJ6mLcJxcfeXiF
        2O0pWjdaHmbFy+WqUGYS4gFXnqisPRM=
X-Google-Smtp-Source: ABdhPJyEqEERJ5eRsXmNBffx1gZpeAOJ+QS8zkIPp6jnvZ28TP9KvGvXFyhYUOIkAE259jeCuzIwgQ==
X-Received: by 2002:a17:907:1112:: with SMTP id qu18mr665467ejb.511.1623365995541;
        Thu, 10 Jun 2021 15:59:55 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id y15sm1908133edd.55.2021.06.10.15.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 15:59:55 -0700 (PDT)
Date:   Fri, 11 Jun 2021 01:59:54 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, f.fainelli@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, richardcochran@gmail.com,
        vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next 00/10] DSA tagging driver for NXP SJA1110
Message-ID: <20210610225954.6ih4opzjwpg7d7wq@skbuf>
References: <20210610173425.1791379-1-olteanv@gmail.com>
 <20210610.144645.1169461277377813265.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610.144645.1169461277377813265.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 02:46:45PM -0700, David Miller wrote:
> 
> Please fix this and resubmit, thanks:
> 
> ERROR: modpost: "dsa_8021q_rcv" [net/dsa/tag_sja1105.ko] undefined!
> ERROR: modpost: "sja1110_process_meta_tstamp" [net/dsa/tag_sja1105.ko] undefined!
> ERROR: modpost: "dsa_8021q_rcv" [net/dsa/tag_ocelot_8021q.ko] undefined!
> make[1]: *** [scripts/Makefile.modpost:150: modules-only.symvers] Error 1
> make[1]: *** Deleting file 'modules-only.symvers'
> make: *** [Makefile:1754: modules] Error 2
> make: *** Waiting for unfinished jobs....

That sucks, sorry...
I'll resend.
