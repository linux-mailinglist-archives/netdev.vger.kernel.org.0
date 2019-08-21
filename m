Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E57C9713B
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 06:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbfHUEma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 00:42:30 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:38958 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfHUEma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 00:42:30 -0400
Received: by mail-pf1-f181.google.com with SMTP id f17so570746pfn.6;
        Tue, 20 Aug 2019 21:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=i89KOpZXg5uqwnV062z/TaX7O+4O8ZnzG7ZB8KWGu7I=;
        b=nAQHbiY4C7bgXTA0MquRawmOXsB3K0fXhg86Tb8v/Ezav0nDqfR0h+WxjEZgMmw7tQ
         ieJZnSf8soiUDT4CY5BMTfHs6kxrtVqBgKLiB1Qlw3Pgf6Bl81GfqsGWavxLnwZYBakB
         CUDOniYlzkANMuxA6eEBN76mTS22RBku2zzlG/bexxagrdS9D679QJmpXbNWB/B+DzbA
         Na0SDRI9L4kLbyklF105l6BscgxAmY+zTku3YzKO3cp0A8svk69xdnm+WXmLt0utyiKi
         t/2FAG+4Kbsjkcs8g+J5Sv0Qo14Rx3aTUoA1LlXsU1D4Wc+iop353UW07GxQvdObgnIb
         pOpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=i89KOpZXg5uqwnV062z/TaX7O+4O8ZnzG7ZB8KWGu7I=;
        b=Q8e1mRNymVMIDJDekp102HLVhAhIENT+3YNQ3dNeMOjvYr1QeoxVCMX5I3qG/mzK/5
         m9XvtVeLzwmVBJaZyKxvdIHPJ12LLOMjiYM6SLedZxaSloAfzkZ5eSJQI17PRs8bw2w0
         AAl1FA25cAAqqUC+qmEz0e4Z6JVigeAg9HWMtyvdyZL99e+eR5fGreLIUVU58fxbfMpg
         PQQoIzs0OyxwhdhTlE1jf3m7sdz2JNqElVSMbn6n7ONxtI8gVCDvVGp9faRJytMAjJqa
         5T0MX63O3sXYryvO58XyRtxy0GPkoWaAiFKZEtwkCuiKSjCHhZ7KJ4rtRECVbTteWio8
         8i2A==
X-Gm-Message-State: APjAAAUA7d4tfTOI1J5pcnbKeAZcF1ovKRgCPtCBeN8b2BdWurQLK0Rc
        qVjnJk8nMf16HH6chPhZ39U=
X-Google-Smtp-Source: APXvYqwI7+PihQ5G8Qc/XojcT8tPzrV/diy43ofLsSx9Aa78WhxpWqUJmvcvUJgST70w3ZCwsJv8eQ==
X-Received: by 2002:a63:20d:: with SMTP id 13mr28183602pgc.253.1566362549301;
        Tue, 20 Aug 2019 21:42:29 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id a26sm22820230pff.174.2019.08.20.21.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 21:42:28 -0700 (PDT)
Date:   Tue, 20 Aug 2019 21:42:26 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Hubert Feurstein <h.feurstein@gmail.com>, mlichvar@redhat.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH spi for-5.4 0/5] Deterministic SPI latency with NXP DSPI
 driver
Message-ID: <20190821044226.GC1332@localhost>
References: <20190818182600.3047-1-olteanv@gmail.com>
 <CA+h21hr4UcoJK7upNJjG0ibtX7CkF=akxVdrb--1AJn6-z=sUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hr4UcoJK7upNJjG0ibtX7CkF=akxVdrb--1AJn6-z=sUQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 06:57:10PM +0300, Vladimir Oltean wrote:
> I believe something similar should be possible on other hardware as well.

Not for the marvell link street devices, AFAICT.

Thanks,
Richard
