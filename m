Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46086480EC5
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 03:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238323AbhL2CDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 21:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238317AbhL2CDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 21:03:44 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B7BC061574
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 18:03:43 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id v11so17535266pfu.2
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 18:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jwx9oYDYYtkijtgGI7nMiqny5yngEF+z4nqoWlAzOfs=;
        b=IuLSF18Y3hXjgqKSRBxl3XzEYPW5E+4hdSS50mnfxFoFrNYVjzX7r3sEW/aFRkQPr9
         lWl4e4VtTXpNJblDNuR0OY+NdBJQJ3gQ6Ch0jSO1N3+Q/dCuP+qtjHWCS7/c11vVM4JY
         A54NLfuAXSRZuvHvtdAMMwOkf4e9WMjqFTIE/JYewOi6HpeBPhFNa6RDEP/f2TYKPtFw
         O+Dlpff7Bss0/Mwt8KgPFhkgxEFzAFOuUixBcmPX1bRMzj4gsBxC7wAB+PR6JknxfGWD
         ytG+HL5kJKsJOeoXm03JAYe1BoJzDjvEbMaPewRPk/Hf/rXM2UTToR/CLY2Kz1T+pEoC
         Mtbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jwx9oYDYYtkijtgGI7nMiqny5yngEF+z4nqoWlAzOfs=;
        b=duiR94I8Dlhq22Hg16Vz6/qjhWbBOV5o/YFIVRaCSHZZbvKZ8qvQE22ZNcuVwyvjyE
         GHB9LlyT79Kalij9ghUqAQmBfMICa55BJaosRpbWBM/7UDQ8B+Z3DqAjK95ShFQMoP5z
         tKrEdV0bQMAuTxzgVUdJJwcz47+/qLD8qqzU8SaAjOQQ0gul0RKeKDLwmdsUbtUIjWqj
         +6kADrb/+nH2T++Ff2NawwpQdfzprdEcxEo8rbGwFoTqMSjduRoNbPkOmC7yI+rofAKo
         uTAffnUWoZaRzKVrTSeCVb+i3/xhTj77zQn2QwtKct3WTWGhzWXQqDZA3B78UqrA6Zdz
         BglA==
X-Gm-Message-State: AOAM532m7zSnGpcGH0mlRqLNrubqX+BredyiosFzW9YOywra/7+ubJtg
        J7NXMEx7LT+b1XFSiVYhgy0=
X-Google-Smtp-Source: ABdhPJxhoxlyIl16QFgky7OadekYGfQsApCYp/ZbFQaBCQ0JXldYkHQadQ2NrcEtn6zyvglYTKKB3A==
X-Received: by 2002:a62:33c6:0:b0:4a0:3a81:3489 with SMTP id z189-20020a6233c6000000b004a03a813489mr24796127pfz.59.1640743422635;
        Tue, 28 Dec 2021 18:03:42 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id s34sm23511567pfg.198.2021.12.28.18.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 18:03:41 -0800 (PST)
Date:   Tue, 28 Dec 2021 18:03:39 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCHv3 net-next 1/2] net_tstamp: add new flag
 HWTSTAMP_FLAG_BONDED_PHC_INDEX
Message-ID: <20211229020339.GA3213@hoboy.vegasvil.org>
References: <20211210085959.2023644-1-liuhangbin@gmail.com>
 <20211210085959.2023644-2-liuhangbin@gmail.com>
 <Ycq2Ofad9UHur0qE@Laptop-X1>
 <20211228071528.040fd3e3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20211228160050.GA13274@hoboy.vegasvil.org>
 <20211228081748.084e9215@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211228081748.084e9215@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 28, 2021 at 08:17:48AM -0800, Jakub Kicinski wrote:
> That's still just a compile-time fix,

I think Hangbin's immediate question was about compilation.  linuxptp
needs to be able to compile against older system headers.

> if the user space binary 
> is distributed in binary form (distro package) there is no knowing
> on which kernel versions it will run. I think runtime probing will
> be necessary.

Yes, that too.
 
> If we want the define it should be to the enum name:
> 
> What about adding matching #defines into the enum declaration?
> 
> enum hwtstamp_flags {
> 	HWTSTAMP_FLAG_BONDED_PHC_INDEX = (1<<0),
> #define HWTSTAMP_FLAG_BONDED_PHC_INDEX HWTSTAMP_FLAG_BONDED_PHC_INDEX
> };
> 
> Examples in include/uapi/linux/rtnetlink.h

Ha!  I knew I saw this somewhere.

Thanks,
Richard
