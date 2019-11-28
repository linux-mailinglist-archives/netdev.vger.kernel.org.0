Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C95B210C505
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 09:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbfK1IX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 03:23:56 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55523 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727227AbfK1IX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 03:23:56 -0500
Received: by mail-wm1-f65.google.com with SMTP id a131so5656930wme.5
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 00:23:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cQQwRLuplu5GRUpNLyvi48BexJIcng1mR6vUhhAFnF4=;
        b=qRrmriBAwKBUculh5Ncp5Viq2++W296qtyAlSq29eZ8DwE5DD/Uuga4BhfmgIBXNp7
         KePolPTky9u2ffXVzubXviwo5XhxcJKoWd/H4+WBuFbqZDMrn8AovUN0iippjO43mOnz
         mr+GxDL560rftWv56KwZqathtCi4fuORR8VxqdGrNFGW689i4oZWsZyj9RDeWNZbK2n3
         r+hKoIoubG5HSsvFv2/+xKn1ghAc1r0IDzx5D6VeWsfp5h0qmWLD/jeJy2Ywhz29SJnz
         PIDIhar/6d3vi7zhTGPA9N7K6njtzYSQloff0X40jVvtfafSqChpTV6Aj4x2mTLXHOEv
         P2KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cQQwRLuplu5GRUpNLyvi48BexJIcng1mR6vUhhAFnF4=;
        b=doBNd2Y/Z21ED10Q98hAW+hg0WkowHggs1HM4Okv+lQmyd2TiGc5BOGu/1mJcafVVp
         85iQThmK/uvklPSHcpXut04O9eYJ4KJWO2cNa07EXndDyjmfAsTA+vUQ8unkblo9kn4T
         x+LNi3lwLNGPzLuhzX9XP9SFnzYYAFDQnwbeMaEz33S+/3JEO20uUgh1Ix+5JPcOglKE
         Lv5sRACLAe72uh5oGwgdGgZNM4lS8h9C0Ah1CAS626RX4x1vyhaQNozVK99joLvDI9/B
         STs/9PHVAE7IcfrPyv23ty6HoKZ1zu0Zprc9MdvDFEPZBbBw6TcKMWPXj4z/bFh5UxLf
         FmBw==
X-Gm-Message-State: APjAAAXF3BO3smBmK5O2q1NI61jJ7kinBia/TRfQ2NYdqBlZukj0O21w
        o1bVC9RL5FrGnE9rYrvXbPieqoob
X-Google-Smtp-Source: APXvYqzevJSqRR5rpXy4urpyj1ljQ7xeWAg5/H4MYFV9PUyB6nLcfOVGvNUrWCwQjHkeI53rIKLPYw==
X-Received: by 2002:a1c:ca:: with SMTP id 193mr8225379wma.111.1574929433825;
        Thu, 28 Nov 2019 00:23:53 -0800 (PST)
Received: from localhost (195-70-108-137.stat.salzburg-online.at. [195.70.108.137])
        by smtp.gmail.com with ESMTPSA id g138sm10037632wmg.11.2019.11.28.00.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 00:23:53 -0800 (PST)
Date:   Thu, 28 Nov 2019 00:23:51 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: Re: phy timestamping "library"
Message-ID: <20191128082351.GA3705@localhost>
References: <a45cdb5be352ece0b724f7e03493c4ff@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a45cdb5be352ece0b724f7e03493c4ff@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 07:00:02PM +0100, Michael Walle wrote:
> So what I'd like to have in a seperate "library" is the following:
>  - skb queues handling
>  - rx timestamp pool handling
>  - rx timestamp timeout handling
>  - skb delivery to the network stack on either match or timeout

I would resist the temptation to turn this into a "library", unless
there is a clear benefit.

> Now I have the following problem: the original driver attaches more data
> to the timestamp, as is my driver; this data is used by the match
> function.

...

> But how can I give that memory to the lib in phyts_init() and how can
> phyts_init() populate its rx_pool_data. Or maybe I'm getting it all
> wrong and there is a better way ;)

Sounds like the re-factoring of a couple of lists into a "library" is
not worth the effort.  The differences in the matching logic will make
the "library" baroque.

I suggest not over-engineering your new driver.  In any case, it is
hard to say without seeing the patches.

Thanks,
Richard
