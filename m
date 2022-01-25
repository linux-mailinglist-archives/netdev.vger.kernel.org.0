Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375E649BE63
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 23:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbiAYWUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 17:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbiAYWUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 17:20:22 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFD4C06173B
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 14:20:21 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id y15so51202900lfa.9
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 14:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=hwj4gXvXCBhRExuPMnShGuL7vs55AmEq+6hYowPkYfs=;
        b=MseaPcuBOjYDvXOUymz9SJCTRA1wN6I2pwonSZpoMHOeH7Zvizsr8WRusIf+LXHExs
         IuPfhRYTzX4T/zRxdlsfenm4oWkoxY9nAz/1zebN3yfflBsyOp0hop7xiJz6xPJDS9xb
         mPfjwTYHeDPFf+22WcZSq/ZMBk0Qcr9FW5rd+M8q0+LRCEiaYV41tpBwiAqoDml0AL+b
         bOt9RCpsqxBUyjtKX7EjyQemXya9GEyq26W7vW6lkAAe1ylGzmNB/n+LNod2kWQkaugX
         RNHZLYeCvIwe8RaCaTo+CHJR2PwEs0JSBWFoBSZ3Ik4hVo/Q/zOMPcqBHIGhjLnMEi+L
         pfhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=hwj4gXvXCBhRExuPMnShGuL7vs55AmEq+6hYowPkYfs=;
        b=Q8bbaWRjMVmX0P+UGRBNQsZlVwPGqe870Ai4o0QMsWI+40IjVpdbQDf/PjMGQc7Loe
         XOCmmSygpBNpFbezZt2y47OoYVygwp9mKo6gP2jgzcgF+F1lwWIXs7s8609SfU5FIQ1m
         y0NTjYL2+5wwaSfGESlLKyY8vRsUHWAWMJbdaLPx7/bBgCW7BU7MZ6vjj04DWCbPyhBB
         qoeDG4zNZjOr4ZwF9NwwXdv7PhgPdCFDxye/kRGGVFqbptdn8gjHYpwvqHBYKqCkom/9
         Qv6NhZ2DShSYsqEOgj7mjXTIOUvXW187nGuix0wlbzsw1ZhXgYMF2qnx7h4DXZCoMaEm
         Wa2g==
X-Gm-Message-State: AOAM530WFj6qL+azBT8U7FymDNnOGUFYbsI1MXwlEwF92Sw8g57zhsZC
        9kfm5Y1KouoBZBSw2rPCJk7AO7a+x2o/zA==
X-Google-Smtp-Source: ABdhPJxswDHiUsV5VubCHu1KOO4ZfNn8Jc0RBnErifcHMNguMLjlfrpNYGTBwcL7JHyKnyn0BM4hRw==
X-Received: by 2002:a05:6512:151c:: with SMTP id bq28mr17889742lfb.544.1643149219988;
        Tue, 25 Jan 2022 14:20:19 -0800 (PST)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id r18sm80883ljj.107.2022.01.25.14.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 14:20:19 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] net: dsa: Avoid cross-chip syncing of VLAN
 filtering
In-Reply-To: <20220125124108.5a19f007@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20220124210944.3749235-1-tobias@waldekranz.com>
 <20220125100131.1e0c7beb@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <87wninbppy.fsf@waldekranz.com>
 <20220125124108.5a19f007@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Date:   Tue, 25 Jan 2022 23:20:18 +0100
Message-ID: <87tudrbgpp.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 12:41, Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 25 Jan 2022 20:05:45 +0100 Tobias Waldekranz wrote:
>> On Tue, Jan 25, 2022 at 10:01, Jakub Kicinski <kuba@kernel.org> wrote:
>> > On Mon, 24 Jan 2022 22:09:42 +0100 Tobias Waldekranz wrote:  
>> >> This bug has been latent in the source for quite some time, I suspect
>> >> due to the homogeneity of both typical configurations and hardware.
>> >> 
>> >> On singlechip systems, this would never be triggered. The only reason
>> >> I saw it on my multichip system was because not all chips had the same
>> >> number of ports, which means that the misdemeanor alien call turned
>> >> into a felony array-out-of-bounds access.  
>> >
>> > Applied, thanks, 934d0f039959 ("Merge branch
>> > 'dsa-avoid-cross-chip-vlan-sync'") in net-next.  
>> 
>> Is there a particular reason that this was applied to net-next?
>
> Not sure, there were issues with kernel.org infra during the night,
> could be unintentional.

Ahh ok, hope it gets sorted quickly!

>> I guess my question is really: will it still be considered for
>> upcoming stable kernel releases?
>
> Only after the next merge window, but yes.

I had a feeling that would be the case. Aright, not optimal, but not a
big deal either. Thanks for taking the time to respond.
