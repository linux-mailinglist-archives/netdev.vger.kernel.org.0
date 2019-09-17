Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B340B5242
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 18:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbfIQQBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 12:01:12 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42097 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbfIQQBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 12:01:12 -0400
Received: by mail-pl1-f196.google.com with SMTP id e5so1709521pls.9
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 09:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/23YK+iwNZhnsWrJZgUA8e8wVGgRXkGE3IhM6DmqMsI=;
        b=n+r49PwL2S6A4SMiJMOSrMzDWz9h3hrUYuDriYfE7384T+SjrNAJV1zAmSLXiW2zKu
         LDxgaWaGtRmZ5Y1SSsouXLkKINMGZqZ/6s/Et5eNpRCmJZceAw2L1EJWsvIOtoF+/O/u
         Mrh3e5lIReU75i1q7ZI8sxvM6Aa35kmsGWPBP6mPqwbb4jtX2hmXFqNIJH2/bwOKmZTi
         jvFWdIIr89ooutmm1Vx9VOU70chQU63Yi9cRCyIbJGOBQ8DuG1k1F+snC/vlYb8vKZh/
         pnlR1aXE9vVHTO/NZjljGzrz05wMZPQfeDv2Hn1SfeFSUCg+KFIjFllmimLUXuXApVx5
         q5IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/23YK+iwNZhnsWrJZgUA8e8wVGgRXkGE3IhM6DmqMsI=;
        b=YVsy3HyjxqUyVr0A8pnkT9/OxoJuQrcPXjbo/A3QxenRqEmaBLy+f9b94d2qDPO0kP
         bGDLsEPa1Scn2oz0EzheLM2/kJXG8cEd4LQD/uMJARgbtkL3gmJfSALxlz6SbVo1KbJ0
         dEW18ZXrXlfVQAlqjP28X0/FciMYr/jj04MPZkj1g8bMPUoeRQXqjISle1Wn3NdaN/C4
         T1H45Ca6CJnokjsPSLP0lUlPrkpRxs1+kftM41dCFGthN++hbaUeA0pFJgPmZYpI/BNS
         7UlwACjm8h5FRAUTJpedPKe6TwUo67eAZQmJHehuY4Jw58W9HYrKslYHXmUtBax4T3uc
         X/LQ==
X-Gm-Message-State: APjAAAW3Dq0PcOF+Aq+QcarI001UEOyWyidk6pjE4yolaLHotrUVa5MD
        EE3JNB4JEXPNukYpKpEbLji4aYdMh6PZMPnIfSV3nw==
X-Google-Smtp-Source: APXvYqz8dyKSNtQP0vAs4KMUBdn0O75gBbiQdluvYEFK4rH7QBocrrUA3plnVMmHs0TF1P6FT2TnB0PAcoKwlUC6vkk=
X-Received: by 2002:a17:902:d891:: with SMTP id b17mr4243631plz.119.1568736071167;
 Tue, 17 Sep 2019 09:01:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190917073232.GA14291@archlinux-threadripper>
 <BN8PR12MB3266AFAFF3FAAA9C10FB1C1FD38F0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <510d777024554eab846ef93d05998b63@AcuMS.aculab.com> <BN8PR12MB32662378E844E6ECBA3FE8D7D38F0@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB32662378E844E6ECBA3FE8D7D38F0@BN8PR12MB3266.namprd12.prod.outlook.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 17 Sep 2019 09:00:59 -0700
Message-ID: <CAKwvOdkr0=gdTUG9_2ACBY-WxEerzcK60WHBsmy+hz7rD-yZNA@mail.gmail.com>
Subject: Re: -Wsizeof-array-div warnings in ethernet drivers
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ilie Halip <ilie.halip@gmail.com>,
        David Bolvansky <david.bolvansky@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 17, 2019 at 6:27 AM Jose Abreu <Jose.Abreu@synopsys.com> wrote:
>
> From: David Laight <David.Laight@ACULAB.COM>
> Date: Sep/17/2019, 11:36:21 (UTC+00:00)
>
> > From: Jose Abreu
> > > Sent: 17 September 2019 08:59
> > > From: Nathan Chancellor <natechancellor@gmail.com>
> > > Date: Sep/17/2019, 08:32:32 (UTC+00:00)
> > >
> > > > Hi all,
> > > >
> > > > Clang recently added a new diagnostic in r371605, -Wsizeof-array-div,
> > > > that tries to warn when sizeof(X) / sizeof(Y) does not compute the
> > > > number of elements in an array X (i.e., sizeof(Y) is wrong). See that
> > > > commit for more details:
> > ...
> > > > ../drivers/net/ethernet/amd/xgbe/xgbe-dev.c:361:49: warning: expression
> > > > does not compute the number of elements in this array; element type is
> > > > 'u8' (aka 'unsigned char'), not 'u32' (aka 'unsigned int')
> > > > [-Wsizeof-array-div]
> > > >         unsigned int key_regs = sizeof(pdata->rss_key) / sizeof(u32);
> > > >                                        ~~~~~~~~~~~~~~  ^
> > ...
> > > > What is the reasoning behind having the key being an array of u8s but
> > > > seemlingly converting it into an array of u32s? It's not immediately
> > > > apparent from reading over the code but I am not familiar with it so I
> > > > might be making a mistake. I assume this is intentional? If so, the
> > > > warning can be silenced and we'll send patches to do so but we want to
> > > > make sure we aren't actually papering over a mistake.
> > >
> > > This is because we write 32 bits at a time to the reg but internally the
> > > driver uses 8 bits to store the array. If you look at
> > > dwxgmac2_rss_configure() you'll see that cfg->key is casted to u32 which
> > > is the value we use in HW writes. Then the for loop just does the math
> > > to check how many u32's has to write.
> >
> > That stinks of a possible misaligned data access.....
>
> It's possible to happen only if structure field is not aligned. I guess
> I can either change all to u32 or just __align the field of the struct

Would __aligning the struct still produce the warning?  It's good to
know that this case is intentional, but I would like to consider other
instances of it before we seriously consider turning it off.  If the
driver can be rewritten to just make use of u32, I would find that
preferrable.
-- 
Thanks,
~Nick Desaulniers
