Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C9B20EC30
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 05:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729277AbgF3Duf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 23:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbgF3Duf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 23:50:35 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145E5C061755;
        Mon, 29 Jun 2020 20:50:35 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id a12so19529001ion.13;
        Mon, 29 Jun 2020 20:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yAZduYcEKm4wiOoLB6wnk1hlMRtoPsLgtKlyIvlMUUk=;
        b=LKamDgqYqesOzSvVhslHl7abbLHAM1zc8BuGRmPHvpO6LO4bhdJcFrwcfxhI18xPmx
         dyqg2hlEj9udw/dFz8q/hjDf9Wdm8aeriV0OcZE75Tw5XuFop2YChbE2IzE1R2qxQjwx
         2BOEKkDSPLJq/ApychEMSVA34/8wSaVodMw/vX1b/7eHMttmov1CdzbnPE4vFaKaBrB3
         37ZwCa316Cb82flgrXezMBXgSLGO4Xz0Ly+MOtmFvS0+GCHYxAYk3vVELrBP3pkt+YnC
         RXXOAEKNUV/kzatuPjy8VV1jAIyWDb89AfrdBHyJ/YRhFSiUV6F3xnbOdGTSCY/4A1Xj
         sQsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yAZduYcEKm4wiOoLB6wnk1hlMRtoPsLgtKlyIvlMUUk=;
        b=SO1yVr8AiodHeBMgaAAeuHAArnS29lVEn8aWwm3xy/BVWMryS6HEPTGxRP5bwJp4/o
         knFR+pV3uucR4vE3Ei2amPHsfZivU5/aV9w9ySX1wRzbAKyhSn2t6JC8816JVDrNtmdF
         wqIh080MalWrBSWyNs/RYExOwgNhPQo5UyLIOX6jJ4r4ApvUTmXSHjS6WQN58SzZtlqG
         16WXyBKg3fmudm6TZUgLjvJ+w//sg8Ng7rFTg7x6rY+Vz23PMXO3D3nyyN547FzvyfO4
         ae8LGxKfH1toGjiw+wHo+c16rSfQpvMVPswPJIeq4onn1KJH9v5g/8dNOW4czSU4C1tr
         /oLw==
X-Gm-Message-State: AOAM532SA1Iv9h9ftUtd6KTuuR5LNv/z7HWeNJFFDsCk9zkbsR9ntoHz
        usXaJ5LPKDHYTTao987XphcjZOrz3Zqy/nnYzx0=
X-Google-Smtp-Source: ABdhPJwZXSxk5Ni5RdxK9COZYxWSeupqBcmRLml/34e81CpgxbEqF5TYLdB2ywMEbK32ItrYrazG2/47m0bFLsJ2AyU=
X-Received: by 2002:a05:6602:2f0a:: with SMTP id q10mr19503583iow.134.1593489034512;
 Mon, 29 Jun 2020 20:50:34 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000498aa905a90b9dd0@google.com>
In-Reply-To: <000000000000498aa905a90b9dd0@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 29 Jun 2020 20:50:23 -0700
Message-ID: <CAM_iQpUX3AAsGfbTBQZxS9=GjwgbxuEjzFtTEu_1Qn7OTKYnoQ@mail.gmail.com>
Subject: Re: KASAN: vmalloc-out-of-bounds Read in __cfg8NUM_wpan_dev_from_attrs
To:     syzbot <syzbot+b108a9b0cf438a20f4f8@syzkaller.appspotmail.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-wpan@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        stefan@datenfreihafen.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: genetlink: get rid of family->attrbuf
