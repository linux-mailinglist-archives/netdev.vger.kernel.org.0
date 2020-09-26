Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD4E279CBF
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 00:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgIZWL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 18:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbgIZWL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 18:11:26 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67102C0613CE
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 15:11:26 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id q13so3307082ejo.9
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 15:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Afm+KLUGjhU+e/PLFMMYBXSD6xhBOJFQEd+1wA/rOLs=;
        b=HzskSZvkTN5tt7REwkgOJ1c2qbBTt5ozryCA4Ur0in7l4jn3KK4n26RRO6qlMQUTtQ
         aX2i1FhC6EFZauUViO8puoJhLFCBxJ/OrJ+1AM4/v8S4xwvhscCKRHhO1VtbBM6OjayM
         LtjCr8KzMDJdE835qU3IJicvgIyY9GrFEKOrQbss8iNnJb7ugQ8cJ/WyZ13PwEY666H2
         qkg57F+a2VoxIuVobB3R0aYfa1rnbba0upsa8W7NXAcolJNgihHJyiczj8LzlLLIqFqx
         on7VUawrnCXDY8ubANiK2re0KkXuARphklB2dgA5aURMYSZcws3GIwI1ezkoaqm6S/dl
         Izfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Afm+KLUGjhU+e/PLFMMYBXSD6xhBOJFQEd+1wA/rOLs=;
        b=tTyN5tt3qyQIw45bYUvsnZfCly9Xs41xhM/bj8yDA7U7qrVjKxxIqBPTn4lhTuQdw1
         ojMM4el3yuRWC9pLwY0+ABNBt90ijiPJ2NNPmvjUgRvtMz6wS3qlw1tHrOp3ReRBgOiW
         YB1yi4L8qkr81jwg+DGMwUS0P8qK8O2Msn4LijHXaeetg0No0v65nHbXFms9w8BAuedy
         +0XunEwPD7ZkLMuBOHej2wALJFcwilyXSfnbiqQnqe2n9Y1ImnnRj4qnKXel2dj58D+N
         UQGeD15UUiI0PN5hOjwI5eW3lKyvHcooNV8diQWm6txX7w+Nkv8dCVfqpK1vwmzPGIt8
         HHnQ==
X-Gm-Message-State: AOAM533t8q4nDqsDXl9qNFhx1SWgvKuEGYL/GcKMuHMh0aTzLDmBDF19
        fzCt1YHOH3lsYMJd1SWVCiY=
X-Google-Smtp-Source: ABdhPJxbGmn+pwR87U8cuZ64QUk93mIl/V1BkGxtQ9MLnIKgtVt5dr98I4mOuB/V3fg/byFUdHz+iA==
X-Received: by 2002:a17:906:cf85:: with SMTP id um5mr8748860ejb.479.1601158284890;
        Sat, 26 Sep 2020 15:11:24 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id dc22sm5113262ejb.112.2020.09.26.15.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2020 15:11:24 -0700 (PDT)
Date:   Sun, 27 Sep 2020 01:11:22 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 0/7] mv88e6xxx: Add per port devlink regions
Message-ID: <20200926221122.7mpsmh7iwctnact7@skbuf>
References: <20200926210632.3888886-1-andrew@lunn.ch>
 <20200927000219.610d7c5e@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200927000219.610d7c5e@nic.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Sun, Sep 27, 2020 at 12:02:19AM +0200, Marek Behun wrote:
> Andrew, can this be used to write the registers from userspace, or only
> to read it?

It is intended for reading only.
https://www.kernel.org/doc/html/latest/networking/devlink/devlink-region.html

Thanks,
-Vladimir
