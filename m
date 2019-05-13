Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C72F91BFD2
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 01:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfEMX3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 19:29:32 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38245 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfEMX3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 19:29:31 -0400
Received: by mail-qk1-f196.google.com with SMTP id a64so3427328qkg.5
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 16:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=w0BO7kflhhldyV0a05jXg7RBYuSqeiVZ6HOP0eI2DHc=;
        b=SpccjLqINbhKgq0eV7ZOe/x4UBtLM/5vE+qyOs2pNPcFfcXfDmuFEZzv9o+FnveTGT
         Nk/A0BXy61IeAoALl9Z8A1/s5WmPsWIS6kPrAwJFYdaVkNrFZBdBhr0xHC/h6txW6Ug2
         ULpfabtFLUn5r4r99hYX56orPDFgI9L6nJ1K0JSTSbWlUPjshHpsIBTjktMXlCz6e1AI
         Kbgn71iOCEqr0tVWs6iV9NYkHisXt1dk4zb8UTo6cUDoGviEU87tzB2fLxQEOsxPFpxs
         xH8SItsGd4sU4ziTwDEpzsCivSFJZ/FKAXzZdjVNp1f3pZ5Xkp3OsC5HwqGFDQbgF1cc
         UOgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=w0BO7kflhhldyV0a05jXg7RBYuSqeiVZ6HOP0eI2DHc=;
        b=Qo4guxz9KikpKBtCqJpyK4y39OT2F0J+AAj5VqwoctgJ9SX3iZDEm4Lz8/N+jUc+D4
         oqzF9VO9q+NgJWqabJ/RaymqMcdoKqujN8RgSCTVQIFHTLwvI3PB5ejXHCvCKJUXVKQY
         ykRYk24ldvUZ14RWzTwPujeOLA7/abCV8xdG8XRemV0iPSSHQ+Yy+khGQAQwV94i+1rB
         rT2r6+qSar6rNbS91cdvaPB7ZfnN+GftByJYvxUMxb4EnYXlMJkOMKfxL12dfSePktfu
         G3Uq1s9iNgcPInXXeuNoW/8k+R9vV6AqhXTgyhUnSGxfVMt7GvV6A7zhu1IVlTti7s6k
         tuwQ==
X-Gm-Message-State: APjAAAXpoXjG7nWtzSR7UKy8bB58z9YQt+d2bAO2wkwyI34WHgG4uFux
        tyZNXawlTkn06XVDdLl/TPw=
X-Google-Smtp-Source: APXvYqz0+EzCasS4EaIvRckJGp6DTct1PioGUxHcX/QQOdlmJHxBApCapDgbro1tGmua1xEVqtnW9A==
X-Received: by 2002:a37:508a:: with SMTP id e132mr24728280qkb.281.1557790170702;
        Mon, 13 May 2019 16:29:30 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id b11sm4873272qtt.6.2019.05.13.16.29.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 13 May 2019 16:29:29 -0700 (PDT)
Date:   Mon, 13 May 2019 19:29:28 -0400
Message-ID: <20190513192928.GB2800@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] net: Always descend into dsa/
In-Reply-To: <20190513210624.10876-1-f.fainelli@gmail.com>
References: <20190513210624.10876-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 May 2019 14:06:24 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> Jiri reported that with a kernel built with CONFIG_FIXED_PHY=y,
> CONFIG_NET_DSA=m and CONFIG_NET_DSA_LOOP=m, we would not get to a
> functional state where the mock-up driver is registered. Turns out that
> we are not descending into drivers/net/dsa/ unconditionally, and we
> won't be able to link-in dsa_loop_bdinfo.o which does the actual mock-up
> mdio device registration.
> 
> Reported-by: Jiri Pirko <jiri@resnulli.us>
> Fixes: 40013ff20b1b ("net: dsa: Fix functional dsa-loop dependency on FIXED_PHY")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
