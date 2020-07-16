Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1183222B51
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 20:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbgGPS4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 14:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728163AbgGPS4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 14:56:54 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1FAC061755;
        Thu, 16 Jul 2020 11:56:53 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id m16so4261160pls.5;
        Thu, 16 Jul 2020 11:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=558SEf3wkjUc5GW0/aqWtWS31X2v2nvkhCml04nU/kc=;
        b=Cz4k9FfxeOO4NHD3yEMpbkx3rAmHS+0F/Du7ZUEYZJ+y9dvKfHSxpmrVu70LSynGEB
         ADFMeqdtKmna0GU7uITLNxfXfGhyhDwOibdX/9MCfW60jTAPxoqXc0KYpldDYp2Y7COt
         k5fpyxKZbw4su+8S+uOdVCOz5uKqwjBt5FFKPAqIMkHbKvd1BnxLGdGcDCNGbPvuzdrV
         1XRPC+ugzUgXxAEB6NKNSSATCwff+Vz2nn2JRvaDyGCq9zgvMGZD4bUlRcruJVuWsqxo
         8wIh4YDG2t2A2ZF96Lx6bsw1TCcFM3CJMJSvuTAx8shAEHK0RxYNSAh9I8PfXGiPMTE2
         0EAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=558SEf3wkjUc5GW0/aqWtWS31X2v2nvkhCml04nU/kc=;
        b=UUDitJf65OPefozAdn5w7+KqIapMoZJ0MQPHfMo9ecskUz9AW5EbwzG0T/Bz+sNSx1
         bEkAtqn53lXfjboMZQ4EkaGuIGMhwgNItKspqUzHcBZkvV+fQKO5wa1DGhM/Lf/cyn+L
         DQ3nxN6BQuRtqwQX9IhqoaDXhK7XJC1GuNanScv4rHHla9npZ12cz7i921m3BD53xcOY
         XaAhxWbcLUzG4MWLvcepOheQk8ok122u2aHO6AwGh9B//N0ERUsPtqUcdbI8WhI2YYH7
         Ea7iqEhsb2gGKILVByUO/Ax8IoTCpqg3DW+s/in/YNbs3xd6wT85cmApxihgeJhaxByL
         o1aw==
X-Gm-Message-State: AOAM532eS4mrQCIFUWttNqHDDga2LFoSTGY3SDWp+QPVBOA1v2XjcKEL
        513176kLsMa8B+UWFRx3TD0=
X-Google-Smtp-Source: ABdhPJyVJOE+N6XkYsKVvc9gHyOhLTznfmMXtKOKyg7LkJ9riRyKWMq0ixSICTozCljLpigEO5OgpQ==
X-Received: by 2002:a17:902:76c4:: with SMTP id j4mr4621390plt.131.1594925813249;
        Thu, 16 Jul 2020 11:56:53 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id u66sm5506910pfb.191.2020.07.16.11.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 11:56:52 -0700 (PDT)
Date:   Thu, 16 Jul 2020 11:56:50 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Sergey Organov <sorganov@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net] net: dp83640: fix SIOCSHWTSTAMP to update the struct
 with actual configuration
Message-ID: <20200716185650.GA1074@hoboy>
References: <20200715161000.14158-1-sorganov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715161000.14158-1-sorganov@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 07:10:00PM +0300, Sergey Organov wrote:
> From Documentation/networking/timestamping.txt:
> 
>   A driver which supports hardware time stamping shall update the
>   struct with the actual, possibly more permissive configuration.
> 
> Do update the struct passed when we upscale the requested time
> stamping mode.
> 
> Fixes: cb646e2b02b2 ("ptp: Added a clock driver for the National Semiconductor PHYTER.")
> Signed-off-by: Sergey Organov <sorganov@gmail.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
