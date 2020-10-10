Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEAE28A3D8
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389649AbgJJWzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730455AbgJJTvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:51:00 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0A1C05BD12;
        Sat, 10 Oct 2020 06:41:01 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id e10so9382681pfj.1;
        Sat, 10 Oct 2020 06:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eMeSz1jtaqvthR2BINpy8J1ocJKGMb+SrNFG1WDb8dk=;
        b=q/1yU0VH3X0Y37ZO2QklGCdDGCwRh7JVpmyubhEidIR1B8NkssuxhsC1J6HITSNXc8
         OHnqoBXNgi4fvwpTKGqUKABgIQbbCQuZdU5hWuHoq/QUWAHDUm3doLFE6w758l0/TlCD
         G+QAyvW5NlQTzcADF3fbuoa6qwL+o8BS4jeWat+as337v0x/o685tWrz5n3LZA886uzz
         RXNz9rkN8fit1UvkWgQHF61LTLaxgMe9AYdkm1ckAPYQ4t6wKKOHtzl94G7l4CLVatzj
         PTZ7l0oKyXJ4FO1Q9rc4Xt1fOu8m7mtSpLSMbcXx7as2APCbG/domrN1KMyv7Bs9NtxP
         Xilw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eMeSz1jtaqvthR2BINpy8J1ocJKGMb+SrNFG1WDb8dk=;
        b=IDxJ6IdCugJQ1DQM4mK1h5eDqJUx6MUWZg/oabEmhm4DQFXlh5DB+qQflvLqKTaXm/
         7kl+QD20LFlRq3H0IBn3UARPSReQ6yZvVZCnH5X7BqnX4S121fmIwJI2FFHrW508DGYI
         tA5a5SAPIN27tKOqDbriUwUhxw8IXfGF+/IODlxJttnNJON4UnypqC++u/fqDON5Whfb
         YFytWKcjxbXy5+Cs7O7W9KDwqeoJk5aoLqarYFWA7Fc9U7VTSn2R1N0XUjZxi9x38Reo
         zRa/6mZFyH9DOru+A2tx+neJKHm/dJFhPuwOo5lCyos6G5fuJk4x3mRNSOA7ICZVxztW
         rUTA==
X-Gm-Message-State: AOAM5324QC0tHqxqRzA6WAhk0LGPzlBl8l6tF+m5gKBUazDTwarRMxT8
        tHaUeNvGPshC1kCdQORoublTgLaUWr2Ndw==
X-Google-Smtp-Source: ABdhPJys+GG5qH6x9ZijI1Xw7Prlg7wTKnuAtRU/Isno51+Y1b+KF8Vyh0MtGSCjBvsUdCeF1F7oPA==
X-Received: by 2002:a17:90a:e553:: with SMTP id ei19mr10300571pjb.136.1602337261096;
        Sat, 10 Oct 2020 06:41:01 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id f12sm7834498pju.18.2020.10.10.06.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 06:41:00 -0700 (PDT)
Date:   Sat, 10 Oct 2020 22:40:55 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 5/6] staging: qlge: clean up debugging code in the
 QL_ALL_DUMP ifdef land
Message-ID: <20201010134055.GA18693@f3>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
 <20201008115808.91850-6-coiby.xu@gmail.com>
 <20201010080126.GC14495@f3>
 <20201010100002.6v54yiojnscnuxqv@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201010100002.6v54yiojnscnuxqv@Rk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-10 18:00 +0800, Coiby Xu wrote:
[...]
> > 
> > Please also update drivers/staging/qlge/TODO accordingly. There is still
> > a lot of debugging code IMO (the netif_printk statements - kernel
> > tracing can be used instead of those) but this patch is a substantial
> > improvement.
> 
> Thank you for the reminding! To move qlge out of staging tree would be
> interesting exercise for me:)

If you would like to work more on the driver, I would highly suggest
getting one or two adapters to be able to test your changes. They can be
had for relatively cheap on ebay. Just search for "qle8142".
