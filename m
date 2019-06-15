Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA0447267
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 00:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfFOW0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 18:26:50 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34151 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfFOW0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 18:26:49 -0400
Received: by mail-qk1-f196.google.com with SMTP id t8so4044545qkt.1
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 15:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=0cJBHAMebNrM9l9LSji3ufbXslzV2Rby6lFMkeWug48=;
        b=tMXbnHcnbHasCe4N/GreIyb4nW6tHRcgmcpO5wGbs5HjUUrWFyzRCSXNu8AvQgTXMe
         E/ihv1OCTh0hVOiBIMg8bPaap5PUVYbIYBZ7kMW8sfhXco5JpbzjtiFCham7NPBhcq9q
         i8k0SjL3dIgxBSCvKeiQLaE9xMHZKOUeKmzxYNw13dm8TcGZs64FMPVidYI+oU517M52
         9OS+f9tlK9uupHTdwXPGgLyD+R0IreA/OjPhDZYogXjRkXhZx9JX7cPR/i5RDNTZLaWg
         wMRbXaAfDrPGgBy40fpG+Tbodg3ayrzLXBVkm6v86khT83/v7yLFBHVlMPj0TYw9l7Jp
         XKGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=0cJBHAMebNrM9l9LSji3ufbXslzV2Rby6lFMkeWug48=;
        b=kCoEE7xk697buVWdhup8ZW1FOQaUX93Y5v+nIMNiyVjjOBb+OS7SnkJe1aW4GJc8iH
         h8FupEmA3cbvqpCOUAq64i+CzWX6zLgFjH5vrLZo4P/zCahwkWg5wE9hWJ5Vo2DdABS1
         6DIrxWtJgLhslmaI3+BZlM8Ji9xhgoU18f8RjKIEoTuSEGfOjKB80mLouYQbWM13B/nx
         diyWnQasI/eEEJqTYdklOqwoREhK5nwfVX9BLbc8LO844aWDupQBgHXBb34EYT31O0pw
         Q1JQzMOfLjhRgOa7H4kHDblB7E8HU4qUpT9RKh5n0tDxx91urqyEsbfG8Fnxm0z9EyPj
         hZ4w==
X-Gm-Message-State: APjAAAVK4IYTRXobm0GyH9lrKJ5RFsdzadNpU/474ZxtXY2OawY5WKdq
        k9XOI1yNtwqjawvk1O02GSC+HLOP
X-Google-Smtp-Source: APXvYqw+9pkVwcAgfM306oinNdXXbiawLM20hUwaJ/pIG+RepE9tGXLn0coKi40g2mW/ZveWF58OYQ==
X-Received: by 2002:a37:b7c6:: with SMTP id h189mr82203551qkf.347.1560637608654;
        Sat, 15 Jun 2019 15:26:48 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id c184sm3726037qkf.82.2019.06.15.15.26.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 15 Jun 2019 15:26:47 -0700 (PDT)
Date:   Sat, 15 Jun 2019 18:26:46 -0400
Message-ID: <20190615182646.GB26321@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     linux@armlinux.org.uk, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: do not flood CPU with
 unknown multicast
In-Reply-To: <20190615.133513.1319708433379449899.davem@davemloft.net>
References: <20190612223344.28781-1-vivien.didelot@gmail.com>
 <20190615.132555.265052877492424062.davem@davemloft.net>
 <20190615202810.m6ulgcv4uhffhd2a@shell.armlinux.org.uk>
 <20190615.133513.1319708433379449899.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Russell,

On Sat, 15 Jun 2019 13:35:13 -0700 (PDT), David Miller <davem@davemloft.net> wrote:
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Date: Sat, 15 Jun 2019 21:28:10 +0100
> 
> > On Sat, Jun 15, 2019 at 01:25:55PM -0700, David Miller wrote:
> >> From: Vivien Didelot <vivien.didelot@gmail.com>
> >> Date: Wed, 12 Jun 2019 18:33:44 -0400
> >> 
> >> > The DSA ports must flood unknown unicast and multicast, but the switch
> >> > must not flood the CPU ports with unknown multicast, as this results
> >> > in a lot of undesirable traffic that the network stack needs to filter
> >> > in software.
> >> > 
> >> > Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> >> 
> >> Applied.
> > 
> > Hi Dave,
> > 
> > We found this breaks IPv6, so it shouldn't have been applied (which is
> > the point I raised when I replied to Vivien).  Vivien is now able to
> > reproduce that.
> > 
> > I guess you need a revert patch now?
> 
> Yep, I'll revert, thanks for letting me know.

Indeed this patch requires to enable multicast_querier in some scenarios,
while flooding the CPU ports with unknown multicast traffic may still be
necessary in some cases, e.g. when a non-DSA interface is member of the bridge.

To give a bit more details, Russell's shown me that pinging the bridge's
IPv6 address won't work as is with this patch because the bridge won't flood
the IPv6 neighbor solicitation to the CPU. A good reflex here is to enable
multicast_querier on the bridge, to program its address into the switch.

But I will propose another patch making the flooding of unknown multicast
configurable, to work with all scenarios without making the code too complex.

Thanks,
Vivien
