Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1637672C3F
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 12:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfGXKSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 06:18:05 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38464 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbfGXKSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 06:18:05 -0400
Received: by mail-ed1-f67.google.com with SMTP id r12so11833818edo.5;
        Wed, 24 Jul 2019 03:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZFqgSiYPAinxvLfUxTqUXyh4XMM9+7IXXnlhhfhWpwI=;
        b=pe/cE7r7iqcJRsJyBPWVoXjP1Jxy7fXOW+n5iMyOn+WbSS8Ls6JwiNyj7pDv3nzSGe
         dzfCja9wOn43d7Rq6i1nbLkG3kyhaipb2SzRm4ERCb8J74979D4WCmJfaJFbIk9pVPvY
         B4rvH8XCQYwd+7t4ayPzwITKhO/s8YWhGk6vz87Qm4SYN0+pactZeONMUXbx3F9rpK8i
         412RepXY4Cj6R5xsC1D1UNgUZ673kIId+AUusCO/6LaKd/IuWceFWFp9+28Grvfk7um6
         ioV1d/46YTNvcUpHuJ5YAbYuaZH5X6JgWCqnKcNVhEep0T9dHLSeNE5DD4F4GhrOsjIR
         WwoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZFqgSiYPAinxvLfUxTqUXyh4XMM9+7IXXnlhhfhWpwI=;
        b=Wyyosv66l+FoBUZz14b7ScsDXvJvS7XJQBlTK8Hyotffzit5TLk4TMVXypWouTPRm8
         hmdfQEYPnLH2yVATiMlaw77SHyGXEZ665hD/LwxCCmJ44asrJyR/KyFFzvFO1E8X60Qh
         ZjmLVnGWRedtyStBBLXwmenGPCioXHw98RilXGolohLNac+5AslTTCyyYcc8qhf3k0kL
         j5Y8B20x6UC6m2OycWK4+mtE9sIO0KDvdrLtms8wdfIeU1ShJM1a38yUoTUXTIvvdHoe
         cfiKI0SEq5thi7L/i+Vso0uckuQaginY0cH3llIuB7fyl5d8Qz7Cb+F7KQKGB85Btgwj
         XPvA==
X-Gm-Message-State: APjAAAWaFpCK6vP7jHwCpVS8wbjy2C4IX8Mv66GcAW9MsVWwyOp8VPF+
        1xW5NT67lbbWhjTSKArNRSrydnyX3pJAb1rG9T+2Wg==
X-Google-Smtp-Source: APXvYqxwS3R2moKyO80rq/sz60wGXAPhb7Xn4d35V9ncoA5nxvOV6T01i4VAMLOhWdeE9cFHyy+GEkm1cY94mvSPYig=
X-Received: by 2002:a50:ba19:: with SMTP id g25mr70418810edc.123.1563963483167;
 Wed, 24 Jul 2019 03:18:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190723104448.8125-1-nishkadg.linux@gmail.com> <20190723.133856.860402214064308020.davem@davemloft.net>
In-Reply-To: <20190723.133856.860402214064308020.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 24 Jul 2019 13:17:52 +0300
Message-ID: <CA+h21hrP7q=NTKW2yukCThW4v4FJH4wqXS2ZQ8u8jJDDKMVeLw@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: sja1105: sja1105_main: Add of_node_put()
To:     David Miller <davem@davemloft.net>
Cc:     nishkadg.linux@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jul 2019 at 23:38, David Miller <davem@davemloft.net> wrote:
>
> From: Nishka Dasgupta <nishkadg.linux@gmail.com>
> Date: Tue, 23 Jul 2019 16:14:48 +0530
>
> > Each iteration of for_each_child_of_node puts the previous node, but in
> > the case of a return from the middle of the loop, there is no put, thus
> > causing a memory leak. Hence add an of_node_put before the return.
> > Issue found with Coccinelle.
> >
> > Signed-off-by: Nishka Dasgupta <nishkadg.linux@gmail.com>
>
> Applied.
>
> Again, the semantics of these looping constructs are terrible.

Strange.
Thanks for the fix.

-Vladimir
