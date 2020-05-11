Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86ABD1CD147
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 07:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgEKFcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 01:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725840AbgEKFcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 01:32:41 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F06C061A0C
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 22:32:39 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id h4so16611314wmb.4
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 22:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=lZgM889WwuZuegA4Ft35gJ9Jifo5b4YUr6ApuyZ9lJ0=;
        b=j85XOe9H1l3lUJS30Vu1bQvgmKUkV7g8chtKN1dFaBhaX6bBalYHKfXZCcjKLAbOqn
         g3fiDOUZTColIXiK1F3rYcvWwZkEUwdlAD64dfwNvSfLpuefwOTvKtoIC5HygqRyyhaj
         V+oBFDygbvsF/AXVW2usrpM8b/612jJBvEgShlU1K23yYpDBI7NM8lKL6GZfh0gESpeQ
         VAGktGdn2pelMnbAIaqFQIob5u9udovkcoiYwNpBuIsJd78iw4jH2xMfDVcYfsmkSJur
         2p3CYeL/bZ8cwBk5IN0+xbvPheJUEhRweIPG1H1c/4NBgV7UthNwt78boCTXhWIvd4nT
         /PSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=lZgM889WwuZuegA4Ft35gJ9Jifo5b4YUr6ApuyZ9lJ0=;
        b=ekyxUdtwr9LShTpjaYA56bi3M7tojY76/0QaDBryFtcEwEdDBAbHQaaWSwNqSih8aA
         iLZi7mSifyeqZx3OQGt0jbr3ARfzPoTbAPlz686eDeF5tfMyBT7GVfZJzsijR+XiEVrT
         yepqwtdo5aBIqYXp1C+5fQwSGlSUQxQMuuXaZQ8cZDUOPKRRSPAMATuDfJ5eA+GLYxMp
         3E+fg/h7Q4hlFfF0+j6eOkEbM0VrTZMUvLQf5CYEjAMXo35G2h+PbiGHZG3agK68HK/k
         kUXLflHO7HXznIjywFZARUQxJQnbY99MCqG1z6dn5sPe3UOTT91MhMrp4auJIx/W3BGg
         J9yg==
X-Gm-Message-State: AGi0PuZ1b77O1B157xPHa9/0PALivc1pGT9AqMZrwTlKmZmuInvzLIId
        uxR1BAQmwHv+NrSUr0RJvQ1bfQ==
X-Google-Smtp-Source: APiQypIa2SCFNjwrD/891KbO3smmBIrMXyg/Sd9bF4BuJqIzFL0v9qo3LE9CWXIvPhRRVMwNQ2lwHw==
X-Received: by 2002:a1c:dd8a:: with SMTP id u132mr28430380wmg.87.1589175158498;
        Sun, 10 May 2020 22:32:38 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id p8sm15606415wre.11.2020.05.10.22.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2020 22:32:38 -0700 (PDT)
Date:   Mon, 11 May 2020 07:32:37 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Dave Taht <dave.taht@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, parav@mellanox.com,
        yuvalav@mellanox.com, jgg@ziepe.ca,
        Saeed Mahameed <saeedm@mellanox.com>, leon@kernel.org,
        andrew.gospodarek@broadcom.com, michael.chan@broadcom.com,
        moshe@mellanox.com, ayal@mellanox.com,
        Eran Ben Elisha <eranbe@mellanox.com>, vladbu@mellanox.com,
        kliteyn@mellanox.com, dchickles@marvell.com, sburla@marvell.com,
        fmanlunas@marvell.com, Tariq Toukan <tariqt@mellanox.com>,
        oss-drivers@netronome.com, Shannon Nelson <snelson@pensando.io>,
        drivers@pensando.io, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, grygorii.strashko@ti.com,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        markz@mellanox.com, jacob.e.keller@intel.com, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com,
        vikas.gupta@broadcom.com, sridhar.samudrala@intel.com
Subject: Re: [RFC v2] current devlink extension plan for NICs
Message-ID: <20200511053237.GB2245@nanopsycho>
References: <20200501091449.GA25211@nanopsycho.orion>
 <20200510144557.GA7568@nanopsycho>
 <CAA93jw7ROwOhZNS+dREeFurjn=YxUVWStL+WKZxHgZFLRX+X0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA93jw7ROwOhZNS+dREeFurjn=YxUVWStL+WKZxHgZFLRX+X0w@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, May 10, 2020 at 06:30:59PM CEST, dave.taht@gmail.com wrote:
>On Sun, May 10, 2020 at 7:46 AM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Hello guys.
>>
>> Anyone has any opinion on the proposal? Or should I take it as a silent
>> agreement? :)
>>
>> We would like to go ahead and start sending patchsets.
>
>I gotta say that the whole thing makes my head really hurt, and while
>this conversation is about how to go about configuring things,
>I've been unable to get a grip on how flows will actually behave with
>these offloads present.

As you said, this is about configuration. Not the actual packet
processing.


>
>My overall starting point for thinking about this stuff was described
>in this preso to broadcom a few years back:
>http://flent-fremont.bufferbloat.net/~d/broadcom_aug9.pdf
>
>More recently I did what I think is my funniest talk ever on these
>subjects: https://blog.apnic.net/2020/01/22/bufferbloat-may-be-solved-but-its-not-over-yet/
>
>Make some popcorn, take a look. :) I should probably have covered
>ecn's (mis)behaviors at the end, but I didn't.
>
>Steven hemminger's lca talk on these subjects was also a riot...
>
>so somehow going from my understanding of how stuff gets configured,
>to the actual result, is needed, for me to have any opinion at all.
>You
>have this stuff basically running already? Can you run various
>flent.org tests through it?
>
>>
>> Thanks!
>
>
>
>-- 
>"For a successful technology, reality must take precedence over public
>relations, for Mother Nature cannot be fooled" - Richard Feynman
>
>dave@taht.net <Dave Täht> CTO, TekLibre, LLC Tel: 1-831-435-0729
