Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3BC20EC1A
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 05:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729176AbgF3DjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 23:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728930AbgF3DjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 23:39:10 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75373C061755;
        Mon, 29 Jun 2020 20:39:10 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id e64so14574981iof.12;
        Mon, 29 Jun 2020 20:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yAZduYcEKm4wiOoLB6wnk1hlMRtoPsLgtKlyIvlMUUk=;
        b=NDpBAaV5Y8Ka1UoM0WgNI2K+NSaP1tG1RWeEhhHg0dFiLFP7uifzCMBubfXUDnq8JM
         Qdz7Rik33to316B5AikQ6oXzHq4T5UH+cUx44tVFqvaz9/rDiKRR78HnSgxrEIx0doRM
         MfpZ761C67mc3KPTANzjT/aC0qtYxVduY+jV78o+Y/0hYL5Oyo/ZSfweZKOPEz1uINMx
         3KARiV0AexBxEgrNi/XAhz6MTDKARusWB48PhCg3unU3YJIU2shNFQXmaIE+2fBC8z/0
         ut2b2cArErLkqy1GxVobPujY+e/ylGVdmQ/MF4FqCskXyM7H//NEczILBs/hC99Wr2PS
         LR7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yAZduYcEKm4wiOoLB6wnk1hlMRtoPsLgtKlyIvlMUUk=;
        b=dFeq0+Lg20FAbzQwEFB8GHnTW7DaYzq0ww3qsbZMRmaSeqlze2D8JsLmllSm7dUm4l
         vfn/fMPCwTEK/5wypZsyTUaesU5PaglehENsBI7UZHma+f4cflju/aFPzrDm+bzPj6j5
         MzP5OMT6sNu8EogObwT8N99rqRBVHLsHeHMdLVC2y/tn/6R/BYCNng9qVrYnEKqS6l21
         D8o1nmsF1r6jOEsOyEUVqSTd9EOGNzuzyTQDAs9kZCfFQibO90F0xsAs9JaHMPMG/AvF
         oG9XsxT7LUbCsErwJx0rzTAQvTiOXdY6D7HE328fKmbAecxSEyHM4Ashc47GUHCGnO91
         qz8w==
X-Gm-Message-State: AOAM5319XYJl8OR/9jXO2x95GmzWVxCJBOuKkS64zYH54yt3orYO/1el
        1ZKpjvb9+WPYSOpSI9HuYy6tNrW7QuY3oNCtMRM=
X-Google-Smtp-Source: ABdhPJwoird2/Mhtjc7mCVLFXM2zg41JBownJhSzezbP4gCwOLLCuBVV57M7yNYu0M/LCJeRJ67NIwts/Q8apK7vfNo=
X-Received: by 2002:a02:1a08:: with SMTP id 8mr20432403jai.124.1593488349849;
 Mon, 29 Jun 2020 20:39:09 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000006eb8b705a9426b8b@google.com>
In-Reply-To: <0000000000006eb8b705a9426b8b@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 29 Jun 2020 20:38:58 -0700
Message-ID: <CAM_iQpXix27CeSxORWz-5EHBGenSQ0PPxuGN3CjA51xonEA8+g@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in netdev_name_node_lookup_rcu
To:     syzbot <syzbot+a82be85e09cd5df398fe@syzkaller.appspotmail.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: genetlink: get rid of family->attrbuf
