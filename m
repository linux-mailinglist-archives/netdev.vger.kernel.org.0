Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D616C185957
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 03:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbgCOCr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 22:47:27 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35269 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgCOCr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 22:47:26 -0400
Received: by mail-ed1-f65.google.com with SMTP id a20so17457252edj.2;
        Sat, 14 Mar 2020 19:47:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=g01xlTcHoCeW8HA/Zoij0G1oenw325gwe1o5DluyjVk=;
        b=fhOkvcAzmrWNJMgNJHPikI0QrGFXUsIZP5fkroS/IpA0TQrw0VoJrbLW4s1e4dcL0L
         OkBTtQEMGbrcyKAZ/DZbMQgvicmu+g3W2zk691CCuMfY5wS3zAblPMF21MOExZYVv/29
         wlVpXaW1FrRC7nxMmMnz4peCdKXJCQS7tNGOa+WX5CmBNw8QcyexYj5AneuIXFLe4Q7+
         nR+xs7Io4N0jlM4IwpiC8AweeFotW6hX9oBszbn+Zhn0rug5mdNw4EhFqeDde03gn62+
         xOdyunUAogpSjYSTCX+zLdRr0urBiPyT+igD4lXSqthOfdeHinWhuJGcspr2G1AzZL8y
         Zf1g==
X-Gm-Message-State: ANhLgQ0SzV6O2Bt/85guXt2+2wBEHCCjVeyp4t4II8iyl56lhdmONSLA
        GQ9/hVsncD9cQ64HKzHRagjDuQeZDNU=
X-Google-Smtp-Source: ADFU+vv1WkKB0u07WBdUm4ghC+dsxjEf7g/P9HdfFTe2RSYc3zQrfQ3xU1TFNHiCqZRBtceL52pXBQ==
X-Received: by 2002:a17:906:2181:: with SMTP id 1mr15328632eju.131.1584183589584;
        Sat, 14 Mar 2020 03:59:49 -0700 (PDT)
Received: from kozik-lap ([194.230.155.125])
        by smtp.googlemail.com with ESMTPSA id f21sm1538993ejx.41.2020.03.14.03.59.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 14 Mar 2020 03:59:48 -0700 (PDT)
Date:   Sat, 14 Mar 2020 11:59:44 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Ben Skeggs <bskeggs@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dave Jiang <dave.jiang@intel.com>,
        Jon Mason <jdmason@kudzu.us>, Allen Hubbe <allenbh@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-snps-arc@lists.infradead.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-ntb@googlegroups.com,
        virtualization@lists.linux-foundation.org,
        linux-arch@vger.kernel.org
Subject: Re: [RESEND PATCH v2 6/9] drm/mgag200: Constify ioreadX() iomem
 argument (as in generic implementation)
Message-ID: <20200314105944.GA16044@kozik-lap>
References: <20200219175007.13627-1-krzk@kernel.org>
 <20200219175007.13627-7-krzk@kernel.org>
 <90baef2d-25fe-fac4-6a7e-b103b4b6721e@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <90baef2d-25fe-fac4-6a7e-b103b4b6721e@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 11:49:05AM +0100, Thomas Zimmermann wrote:
> Hi Krzysztof,
> 
> I just received a resend email from 3 weeks ago :/
> 
> Do you want me to merge the mgag200 patch into drm-misc-next?

Thanks but it depends on the first patch in the series so either it
could go with your ack through other tree or I will send it later (once
1st patch gets to mainline).


Best regards,
Krzysztof

