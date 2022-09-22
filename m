Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241E05E6D03
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 22:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiIVU2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 16:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiIVU2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 16:28:21 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDB510FE01
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 13:28:19 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id t3so9895452ply.2
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 13:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=G8vWMNKl/tOJSQ6M0zXFOTKwOLhvJw/y+mqTFh6znV4=;
        b=oRDbnaKns9k1KMISsKzq9cJmS0ifqDbhOlYFyzmUeoGAc59XCen77eJauyo50l++Jz
         /l2VH8ln5YUbdwdox0h5RnLpGrg17OJaHKU8CfYBskgEiA8DDCbsm14q2wHG+azbHL0u
         K9JlajsChYbWsxgd4zWITszcOXvepqou+3/gLt4EH6s3TyCcwhJIiD4AGfO/qjKYdlNf
         s0ap+wOkzWz2uvf0bzEKaD+A8CKvhBuMD1kM6pykegZCM1e8TuO2ujuxbJW8H0XA1Imw
         2wfRT3Kf1WQHO1IcuqMjhhd1m4usX0zeyKsWJlKlxKUZAsom5P9AFXQx31UGv6XbJ1cO
         yzaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=G8vWMNKl/tOJSQ6M0zXFOTKwOLhvJw/y+mqTFh6znV4=;
        b=4wgbfKkG8VD7/TmQVMl0DpmUma+OeJARTV9yuUUfsl7TMGaeLhA0+ceHBiEEjrO224
         gtYZh/bqXSK42Kc70e4qaOzqmvuFCD9ULnlQOSEeR/LnnL+QaimFkH9t3zs2C1iugW1y
         Zo7zKXpon2UVSPMEcfOOeRkVug9ACb3yC8DvDTUkr29AzG3eYeJTatR9I9JXQa/RFJf1
         TJzGS538EwqLM2DA3gtsmdkxdu7rmRWNbnfPZUhHxdfMs/ZXvbQaNd41n32SB+wSiSRS
         GhOn5eE8THl6wTF7TmWXS8++lKgVSEBGWQWVlWulNnpLkcPPi3EDaI/Gt2Q0XsLUArTs
         r7gg==
X-Gm-Message-State: ACrzQf2uhvDFrk3E1Ue/dzRnTn686m8qFVRkpk+9vG38SaBZc4r2QvaK
        8tgQlqsEzU6245LAG6yHNh2qM3a/akrOYg==
X-Google-Smtp-Source: AMsMyM4DfM834Wjkqe69cV0QoDjzYLu7pFkdWBoXO5KCN65N/HeyEC4OLO4bwh7shKGTRREM2BM8zQ==
X-Received: by 2002:a17:902:c402:b0:178:2bd6:c415 with SMTP id k2-20020a170902c40200b001782bd6c415mr4843897plk.48.1663878498963;
        Thu, 22 Sep 2022 13:28:18 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id p12-20020a170902e74c00b00176e2fa216csm4596890plf.52.2022.09.22.13.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 13:28:18 -0700 (PDT)
Date:   Thu, 22 Sep 2022 13:28:16 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Message-ID: <20220922132816.64e057e7@hermes.local>
In-Reply-To: <20220922201319.5b6clcxthiqqnt7j@skbuf>
References: <20220921165105.1737200-1-vladimir.oltean@nxp.com>
        <20220921113637.73a2f383@hermes.local>
        <20220921183827.gkmzula73qr4afwg@skbuf>
        <20220921154107.61399763@hermes.local>
        <Yyu6w8Ovq2/aqzBc@lunn.ch>
        <20220922062405.15837cfe@kernel.org>
        <20220922180051.qo6swrvz2gqwgtlp@skbuf>
        <20220922123027.74abaaa9@kernel.org>
        <20220922201319.5b6clcxthiqqnt7j@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Sep 2022 20:13:21 +0000
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Thu, Sep 22, 2022 at 12:30:27PM -0700, Jakub Kicinski wrote:
> > On Thu, 22 Sep 2022 18:00:52 +0000 Vladimir Oltean wrote:  
> > > As for via, I didn't even know that this had a serious use in English as
> > > a noun, other than the very specific term for PCB design. I find it
> > > pretty hard to use in speech: "the via interface does this or that".  
> > 
> > Maybe it's a stretch but I meant it as a parallel to next-hops 
> > in routing.
> > 
> >  ip route add 10.0.0.0/24 via 192.168.0.1 dev eth1
> >                           ^^^  
> 
> Ignoring the fact that a preposition can't be a synonim for a noun
> (and therefore, if I use 'via' I can't use the alternate name 'master'),
> I thought a bit more about this and I dislike it less than conduit.
> 
> I can avoid referring to the DSA master as such in the command, but the
> man page will still have to describe it for what it is.
> 
> I think I'm going to give this a go.

Not sure where choice of "via" came from.  Other network os's use "next-hop"
or just skip having a keyword.
