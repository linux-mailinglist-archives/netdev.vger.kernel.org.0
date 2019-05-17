Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52DBB21D34
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 20:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfEQSUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 14:20:32 -0400
Received: from mail-qt1-f172.google.com ([209.85.160.172]:39770 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfEQSUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 14:20:31 -0400
Received: by mail-qt1-f172.google.com with SMTP id y42so9093703qtk.6
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 11:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=sAuzu7oFu+qgNmzIjkw1268TiMptRYFG0uw1EQFtauA=;
        b=xJcVbcT/ku6Ma7TbNCUJZtzkKOiQiMNWgUXCDorUoEFatNEv83AdZrxzt0iGHShLb8
         muT+QryZjZ0j8N1fyfLdVAuFeWUM1aDnyD63SapNlvs3azOsKaefLXby0LtxdbWqQvn1
         sDZCp+W/uIaPTFq3ChgXEN703x+9r/9ras8QIM1bY9b+nyigMrSwTB8bgTXHMMm9eNat
         Ud5hinsvxBLdyLXVr4yE91/wYmVnG/sV401CFfGReKC1H5oFG1mlNZro2Q/ZEfOa32zy
         gU8ywI6X96IAdNVAm4YIghAB7jK8EjHHm6uyKSBi6e8hrPZhTTkA/ZWs5GRhhcS+xUk3
         4dzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=sAuzu7oFu+qgNmzIjkw1268TiMptRYFG0uw1EQFtauA=;
        b=HHXAt26fs/Gc0gh8v1vNYTIvVSYyv9YAFbl9RjkPT/VRxVdkMoU1e91jH2nos3MO6c
         WD0+/AN7CRquZ/4IDqIn69nFJqs0dDhw5M82/PmEjsvljuaEMbm4csZl4vcymlghR7J5
         PcUf8jHztjcMQN+akGEk2d21gHNZh/+UGVuYvuPxE8JXE3aUu0dMHrHN1PHreGyhXSS3
         j4QLvGsk5Wj5ruutaFeJZtYP5JEuLEKeNi/Df72g7oMnbwHxrLdw1jXOF0fRomm7rwG+
         vXO1wgmnje3XVkfknYiOPkCrPXEvqRloH9WJ1kZ2C/5zpGWeVA2+PyD4YefYFmIJ3hmi
         B3zA==
X-Gm-Message-State: APjAAAXFNgBSsTyKPYrkJrG14dN8a/oI1+GFlfe+PgiP70mEE5yLgzVF
        /YzAIe4SCWgdaDZQ3JWfET29xQ==
X-Google-Smtp-Source: APXvYqx3o5PlXHLDnKp5ovqh2Wht3158BUbDxFKtBy1D+ieys+NofN3ySCmgU1RjLqAEKv64s+/WLw==
X-Received: by 2002:a0c:954e:: with SMTP id m14mr3808077qvm.184.1558117230757;
        Fri, 17 May 2019 11:20:30 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 139sm4649275qkm.27.2019.05.17.11.20.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 17 May 2019 11:20:30 -0700 (PDT)
Date:   Fri, 17 May 2019 11:20:03 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, Jonathan Lemon <bsd@fb.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: Re: [RFC bpf-next 0/7] busy poll support for AF_XDP sockets
Message-ID: <20190517112003.02b130b2@cakuba.netronome.com>
In-Reply-To: <CAJ8uoz1i72MOk711wLX18zmgo9JS+ztzSYAx0YS0VKxkbvod-w@mail.gmail.com>
References: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
        <20190506163135.blyqrxitmk5yrw7c@ast-mbp>
        <CAJ8uoz2MFtoXwuhAp5A0teMmwU2v623pHf2k0WSFi0kovJYjtw@mail.gmail.com>
        <20190507182435.6f2toprk7jus6jid@ast-mbp>
        <CAJ8uoz24HWGfGBNhz4c-kZjYELJQ+G3FcELVEo205xd1CirpqQ@mail.gmail.com>
        <CAJ8uoz1i72MOk711wLX18zmgo9JS+ztzSYAx0YS0VKxkbvod-w@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 May 2019 14:37:51 +0200, Magnus Karlsson wrote:
>                                       Applications
> method  cores  irqs        txpush        rxdrop      l2fwd
> ---------------------------------------------------------------
> r-t-c     2     y           35.9          11.2        8.6
> poll      2     y           34.2           9.4        8.3
> r-t-c     1     y           18.1           N/A        6.2
> poll      1     y           14.6           8.4        5.9
> busypoll  2     y           31.9          10.5        7.9
> busypoll  1     y           21.5           8.7        6.2
> busypoll  1     n           22.0          10.3        7.3

Thanks for the numbers!  One question that keeps coming to my mind 
is how do the cases compare on zero drop performance?

When I was experimenting with AF_XDP it seemed to be slightly more
prone to dropping packets than expected.  I wonder if you're seeing
a similar thing (well drops or back pressure to the traffic generator)?
Perhaps the single core busy poll would make a difference there?
