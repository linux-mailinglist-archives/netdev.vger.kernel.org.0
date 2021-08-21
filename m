Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95B63F3AD5
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 15:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbhHUNpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 09:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhHUNpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 09:45:40 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1580C061756
        for <netdev@vger.kernel.org>; Sat, 21 Aug 2021 06:45:00 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id dj8so18352176edb.2
        for <netdev@vger.kernel.org>; Sat, 21 Aug 2021 06:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XOkvmocD1NfSc6W3xyMtK2214BDZpc2SR/eJTyNI/FE=;
        b=YZWZp6P/ZieyOFu1TyD3ip3bYxYSMY8dr/UvaOvv94p5SKwahhqrb2vrgEgLHZLGjz
         dx+gBSRFtY7KRFsbc+8jqEmmY60tLZnOqff774HmGPWd9zIYXYS3VWgD/Wi4EbIpQcl1
         fKmxKqOxia81b7z536hCEplZPbv1lVspPQiUjKiJoi7ktl3y0vCbCv9IuTEUUIQL+RDM
         aAVtTIoEA11+Z6oc8oFxV70rzJ6r5v0uo3eVV8wc2U6OOB8Uv4i9zQ7Hz03E9fIO6l1u
         dqTHj8myYjrwoof7esqsRrfBdfg9+xBUnOgSHDGxjAY0BRW50QHZnMxEQl83ik+bgsts
         Lzqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XOkvmocD1NfSc6W3xyMtK2214BDZpc2SR/eJTyNI/FE=;
        b=pDqt57lrD0c2W66NSJAoCZ/NONFDRazOqAbqE1nRrnzd7deB3hSR7uBLiPX3KeYMZD
         L7t/FEOkodu/dMCp+wJaXrpX+hAMDwbvbDj3CQ660pGYrGciD1J4UaMsUQ6bVHqhztoU
         FRYBa6QIlUlE1JEkLiajj4jcN0/0IARjeYsTNdZPN+FhKRHtG2UZAz7QFSqbPgR56cnh
         Mmt7Ayk761DSMExh70LVfAk2p3WkbYYmbG0j7ZnGQD9B9zhYubLrS4PdTVCuQlyWzF6R
         E59qu7VSd0tL133Pk6bSuleJ66TOIPnNEJL0uyVgshOBVmcWOUp/GlEY1iS97KWkiEKl
         3MdA==
X-Gm-Message-State: AOAM531OZmFypOtVGst/5ObCAW0r4eHi+i5Q73YBIu8b8I8nlfG5hnSN
        ZGy5GozT1YaT5U3zAjHAMPaNRnbuaYlsgA==
X-Google-Smtp-Source: ABdhPJyJ6tTvaQYlDzhSUyFgRspZEW1/tF7hvrKOLhzalUROHRpSjZ5zameP1rJmF65YP4k8KgZlSg==
X-Received: by 2002:aa7:d388:: with SMTP id x8mr28239733edq.254.1629553499232;
        Sat, 21 Aug 2021 06:44:59 -0700 (PDT)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com. [209.85.221.44])
        by smtp.gmail.com with ESMTPSA id br16sm4351791ejb.34.2021.08.21.06.44.58
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Aug 2021 06:44:59 -0700 (PDT)
Received: by mail-wr1-f44.google.com with SMTP id h13so18458770wrp.1
        for <netdev@vger.kernel.org>; Sat, 21 Aug 2021 06:44:58 -0700 (PDT)
X-Received: by 2002:a5d:6da4:: with SMTP id u4mr4110781wrs.50.1629553497372;
 Sat, 21 Aug 2021 06:44:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210819143447.314539-1-chouhan.shreyansh630@gmail.com>
 <CA+FuTSdsLzjMapC-OGugkSP-ML99xF5UC-FjDhFS1_BDDSJ2sg@mail.gmail.com>
 <20210819100447.00201b26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <YSCos0Sdw7RYsNQu@fedora>
In-Reply-To: <YSCos0Sdw7RYsNQu@fedora>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 21 Aug 2021 09:44:19 -0400
X-Gmail-Original-Message-ID: <CA+FuTSceSFcRc-OxP=_1zAmBGckQL5gDsAScqoiGy2c4PLckWQ@mail.gmail.com>
Message-ID: <CA+FuTSceSFcRc-OxP=_1zAmBGckQL5gDsAScqoiGy2c4PLckWQ@mail.gmail.com>
Subject: Re: [PATCH] ip_gre/ip6_gre: add check for invalid csum_start
To:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 21, 2021 at 3:18 AM Shreyansh Chouhan
<chouhan.shreyansh630@gmail.com> wrote:
>
> Hi,
>
> Thank you Jakub and Willem for your reviews. I have separated the
> changes into two differnet patches. Sorry for the delay.

Thanks Shreyansh

> Where can I read about patch targets? I have seen patches with differnet
> targets but I do not know what they mean/how they work. I was not able
> to find the documentation for these.

Targeting these bug fixed to net was the right destination.
Documentation/networking/netdev-FAQ.rst has more context on the net vs
net-next distinction.
