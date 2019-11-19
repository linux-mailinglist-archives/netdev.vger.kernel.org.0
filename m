Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A38E7102E50
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 22:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfKSVjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 16:39:02 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41716 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbfKSVjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 16:39:01 -0500
Received: by mail-lf1-f68.google.com with SMTP id j14so18353148lfb.8
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 13:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=hUn2ZHoyVe9y8hRbwrGi8oA9FxwUGlFsnhXqVwSHjgM=;
        b=gvQinZfxSMrVWSqlkLWb6aNPtdrIfVuYijtT1id3uMY8+IWYWGbN5YV3XhtBzoLVKP
         zPLfAr76mONY189MarrphH3wbnRO1cr+LS7rTP8VQ3cWImimM3U7pP8ryTx9VKc4HCGT
         YcYbvDxRv2FhBIbFRIOuojj/Cr5ktGe6NEWXFbBJVh1w7D1uKJQYUA7QGB8WCGOILI8m
         x38rWLZIvKq7DWATWsCetQ0W9Tx1Ep3Z0Sul8SedP3yg4E/RjTFcUIYqokuvHcfNlGUp
         FjkpvgsU62EcTEmszbH+2Pc6nCtuJZePnmHg3bep3jJ0y9VDcnTtDklManmZgkG0VSa5
         5XoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=hUn2ZHoyVe9y8hRbwrGi8oA9FxwUGlFsnhXqVwSHjgM=;
        b=eyiC6DFJ3qQHoJCPK2fb3ohVnPIxBB5WAs5RDPCP2Q1FaBZsjU0E3sVFhkJu+h9ywy
         ySxlchvvpPSYHKeoq4JDx5zUGiXt/2aaRjjtdym+hFS3f7Wm1dBAtF+ptLccb+Z1SKtW
         jMI0KBt+2t6iI/Tx1wDPPZOTtAcBf4V40wVHceEIkQ69hXr2kcHAfQ1UNTr3xJWMEf0I
         jPMRFegT2NbWFFLVY1Px15P/zoOCBMobkjegL7669BjJp5XUr1hEypYNIXCqdsWkkDFR
         w6tK6iBhKVRuq+Kwsj5znOJycwSGNMkXs0nCspPs0y00U1i36oSmJoxtwc/5x7RKRJBf
         srZA==
X-Gm-Message-State: APjAAAUuE4Nj6i2afpbevtaHX2Zo3rNVifR8NWrY9qE3/KIzDKHqmtiu
        fkmz0CGe+Svb7I1lcVhGDbQtUw==
X-Google-Smtp-Source: APXvYqwYxtCTmH4TQb/TcqWkDnIUgEOXP2tG9Qhy9Czei1f/mwoVjSDZQJBYXi78LL2wzMkGM/Eqnw==
X-Received: by 2002:a19:40cf:: with SMTP id n198mr5757322lfa.189.1574199539613;
        Tue, 19 Nov 2019 13:38:59 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s20sm4507473lfb.6.2019.11.19.13.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 13:38:59 -0800 (PST)
Date:   Tue, 19 Nov 2019 13:38:41 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linu Cherian <lcherian@marvell.com>,
        Rakesh Babu <rsaladi2@marvell.com>,
        Vamsi Attunuru <vamsi.attunuru@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH 02/15] octeontx2-af: Add support for importing firmware
 data
Message-ID: <20191119133841.16f91648@cakuba.netronome.com>
In-Reply-To: <CA+sq2CcrS4QmdVWhkpMb850j_g3kvvE1BriiQ2GyB-6Ti1ue2A@mail.gmail.com>
References: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
        <1574007266-17123-3-git-send-email-sunil.kovvuri@gmail.com>
        <20191118132811.091d086c@cakuba.netronome.com>
        <CA+sq2CcrS4QmdVWhkpMb850j_g3kvvE1BriiQ2GyB-6Ti1ue2A@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Nov 2019 13:01:41 +0530, Sunil Kovvuri wrote:
> On Tue, Nov 19, 2019 at 2:58 AM Jakub Kicinskiwrote:
> > Again, confusing about what this code is actually doing. Looks like
> > it's responding to some mailbox requests..
> >
> > Please run checkpatch --strict and fix all the whitespace issues, incl.
> > missing spaces around comments and extra new lines.  
> 
> I did check that and didn't see any issues.
> 
> ./scripts/checkpatch.pl --patch --strict
> 0002-octeontx2-af-Add-support-for-importing-firmware-data.patch
> total: 0 errors, 0 warnings, 0 checks, 349 lines checked
> 
> 0002-octeontx2-af-Add-support-for-importing-firmware-data.patch has no
> obvious style problems and is ready for submission.

Oh well, checkpatch didn't catch any errors so you didn't care to look
for mistakes I pointed out yourself?

Let me ask you again, please fix all the whitespace issues incl.
missing spaces around comments and extra new lines.
