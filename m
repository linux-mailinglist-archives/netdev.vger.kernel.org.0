Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABA22C7AF3
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 20:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbgK2TgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 14:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728534AbgK2TgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 14:36:01 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF437C0613D4
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 11:35:15 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id d7so839334iok.1
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 11:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=newoldbits-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DB+U6n7ZaoOgXmCxGeygNOdm+zaWvRP+/rfkn1/T+Zw=;
        b=pVceFIYzxkdVfChbIC5+uasKapOvzjK6qXj/fXwwo3VG5t8zit7qWJWLeKvqtw1Lp1
         N2cr2wY7yuqHXQ1pnAQVdjETPwBkcxRVyKFCIWn6t0Yh+DNiTzTfzVwhMRFMFbeLMIf3
         vgYYLB6OwIrdHOqnx9Ize2PGqx60RDRVl9QvvP2MEnG+MqxgFmAlKU5A8ERYYbJakgej
         EJ+V8tUY63jGYoLW5xXt26D8kJpeMA0c65k//d/dhW1duDEvE4xD6+ayPJDQxMjm2RwG
         2Lk8SmwU0/OoSHlCAtP0KPPHQo023vLW7owDCstBWrid8ezM+y9413vECFBPUR47gHdl
         6Q0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DB+U6n7ZaoOgXmCxGeygNOdm+zaWvRP+/rfkn1/T+Zw=;
        b=oDxFk07d75eBGs3w+70DxEh/0OBOruDMyw/7BCBaiiBRdKtWnb2PZ5Yd+PfeQC2McZ
         Lt88J6pS1l5WO38aXwhN48bbEyaGD1bCesaONpmoBSckmM3Ncw0esROdFCFPO0AKMgXu
         QVvfLRa9OE/sYmZ2JjItuGeHKUwykd0bZyW59aonqYtVwwCJfUwJIt8QHmCC1yC2ureI
         SPxvpGtJeVvKvggQCzV0dIjx/gBu4bnGjoFNmtaTg4elKe8bF5CRMv1fIp3jcBCf8/Fd
         3g1GgQD2dd3g0GA+NKFjiNpODItUCcFoMJyB6LJR3RfButphkRHUEt4rk1pLyHT4TQYv
         S8bg==
X-Gm-Message-State: AOAM533NF/m28aLQFm49p+Jhf2jcyLn1aSG1//Gi4gxWFKKgOC1yE5G+
        Jz7o728vR1ltNLczI6sGzOqam1Ovv/TYSP+SnOPtOw==
X-Google-Smtp-Source: ABdhPJzJ1RDLLev2obJQkxpevD0Y/3Jh3Oiu8W/nz2rPPK+kpOMhPfO1cq/mdxFzLJwvR2fcUanDvbAg7BtCuwdSviY=
X-Received: by 2002:a6b:f719:: with SMTP id k25mr13100718iog.116.1606678515260;
 Sun, 29 Nov 2020 11:35:15 -0800 (PST)
MIME-Version: 1.0
References: <20201129102400.157786-1-jean.pihet@newoldbits.com> <20201129165734.GB2234159@lunn.ch>
In-Reply-To: <20201129165734.GB2234159@lunn.ch>
From:   Jean Pihet <jean.pihet@newoldbits.com>
Date:   Sun, 29 Nov 2020 20:35:04 +0100
Message-ID: <CAORVsuXaSYR_n0s5DSqewMotPc+c6EPi-ANGrhuvoesqSddPYA@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: dsa: ksz: pad frame to 64 bytes for transmission
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Ryan Barnett <ryan.barnett@rockwellcollins.com>,
        Conrad Ratschan <conrad.ratschan@rockwellcollins.com>,
        Hugo Cornelis <hugo.cornelis@essensium.com>,
        Arnout Vandecappelle <arnout.vandecappelle@essensium.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew,

On Sun, Nov 29, 2020 at 5:57 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> Hi Jean
>
> Please also include a patch 0/X which describes the patchset as a
> whole. This will be used as the branch merge commit.

Sure, will submit a v2 asap.

Thx,
Jean

>
>        Andrew
