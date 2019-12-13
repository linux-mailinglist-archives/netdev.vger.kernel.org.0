Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 349C911DBE6
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 02:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731888AbfLMB5Y convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 Dec 2019 20:57:24 -0500
Received: from mail-pf1-f171.google.com ([209.85.210.171]:40204 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbfLMB5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 20:57:23 -0500
Received: by mail-pf1-f171.google.com with SMTP id q8so574921pfh.7;
        Thu, 12 Dec 2019 17:57:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=CndJAowMJInL8tn9fXQ0Bjot5xFUhuMQ3mivrKVBjhs=;
        b=SPZ6K+QLP7ROl0y8zPZaMHzYPXUMOB6s6rAYXRHwuUC7e/DV5q7FikMIhkskolpiek
         R0SFRpQ1GY+D7YFTfNcC6I4imGCVyeHxrD7+yslYQ5wN83bRCR1+8AzP1XlSZ+g2Helr
         qziIs2h/itqZbDhoylpBbGlGMmmHbamMAEeRTpkkRRNH0IjnzaUwN34u8M95N1dY4ytr
         xwZLj2Pac81vadqigxCBVHBxEbZK4nwgAtLpsG+UTKT+Ii6pNR26hfFOaVj+piA3F/gB
         oo44GHey59S3b5YUHBUdP8GDuGwRKt3qDMDwRKC5w42PGdLhWKj3K0UJ2c3YUMUAcmG3
         reSQ==
X-Gm-Message-State: APjAAAUV0R0rvWd9Nut1wYIl3XneampVlpPOzVXD3F7+nF4+NkMQtJ2u
        xbepiNjPT2/0CeCyC5tiKmw=
X-Google-Smtp-Source: APXvYqz5+9I2c9+BB9gbo/XUtG0zU4JO/dvc8qFiDsEuM+T5MJLIqwsMikJPqffpMgKBhGYk9TAq4w==
X-Received: by 2002:a63:fe0a:: with SMTP id p10mr13699053pgh.96.1576202242950;
        Thu, 12 Dec 2019 17:57:22 -0800 (PST)
Received: from [192.168.51.23] (184-23-135-132.dedicated.static.sonic.net. [184.23.135.132])
        by smtp.gmail.com with ESMTPSA id i11sm6421887pjg.0.2019.12.12.17.57.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Dec 2019 17:57:22 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [Make-wifi-fast] debugging TCP stalls on high-speed wifi
From:   Simon Barber <simon@superduper.net>
In-Reply-To: <34a05f62-8dd0-9ea0-2192-1da5bfe6d843@gmail.com>
Date:   Thu, 12 Dec 2019 17:57:13 -0800
Cc:     Dave Taht <dave.taht@gmail.com>,
        Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <5DBB113A-E61A-4032-B877-18BE3ABBC616@superduper.net>
References: <14cedbb9300f887fecc399ebcdb70c153955f876.camel@sipsolutions.net>
 <CADVnQym_CNktZ917q0-9dVY9dhtiJVRRotGTrPNdZUpkjd3vyw@mail.gmail.com>
 <f4670ce0f4399fe82e7168fb9c491d8eb718e8d8.camel@sipsolutions.net>
 <99748db5-7898-534b-d407-ed819f07f939@gmail.com>
 <ff6b35ad589d7cf0710cb9fca4c799538da2e653.camel@sipsolutions.net>
 <CAA93jw6b6n0jm_BC6DbccEU3uN9zXcfjqnZMNm=vFjLVqYKyNA@mail.gmail.com>
 <22B5F072-630A-44BE-A0E5-BF814A6CB9B0@superduper.net>
 <34a05f62-8dd0-9ea0-2192-1da5bfe6d843@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
X-Mailer: Apple Mail (2.3445.9.1)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In my application this is a bridge or router (not TCP endpoint), and the driver is doing GRO and NAPI polling. Also looking at using the skb->fraglist to make the GRO code more effective and more transparent by passing flags, short segments, etc through for perfect reconstruction by TSO.

Simon

> On Dec 12, 2019, at 5:46 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> 
> 
> On 12/12/19 4:59 PM, Simon Barber wrote:
>> I’m currently adding ACK thinning to Linux’s GRO code. Quite a simple addition given the way that code works.
>> 
>> Simon
>> 
>> 
> 
> Please don't.
> 
> 1) It will not help since many NIC  do not use GRO.
> 
> 2) This does not help if you receive one ACK per NIC interrupt, which is quite common.
> 
> 3) This breaks GRO transparency.
> 
> 4) TCP can implement this in a more effective/controlled way,
>   since the peer know a lot more flow characteristics.
> 
> Middle-box should not try to make TCP better, they usually break things.

