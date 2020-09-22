Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C656274C07
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 00:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgIVWXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 18:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbgIVWXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 18:23:22 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E15C061755;
        Tue, 22 Sep 2020 15:23:22 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id jw11so2120986pjb.0;
        Tue, 22 Sep 2020 15:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=OlSVKzFE1Q9BCH/xjw1bokQDCp7IHVagUzHPkq8I7WI=;
        b=c3TkFKROQ0WbLC1h/nHUMG47isU8u5m1rD9F87MUto4wbBEGQ1TEtU2ImlXdCHc7Fl
         HUkgzV9tipQhKqAaAzwbA1LcqJPKCQvywfA1jTH5jzCGYwL2WA/Qxp2g6VNA/NvMkUOt
         0z4iNbPKh3dYCctTm05XR1LmIgDCMixh2QLNAqZxmU9bbP/P7ZWpbxPQUlPqm7klkPHJ
         sDbRXlC1u0ocMpxQ30dFWVkRwtzgZ9o061H6fBL+qLkDpKyyx6wBoNCoHAXwnL3cQ5Fz
         e5lxv0pGLp1ihzMDCEt28WQ4sskry1n+RocgDcsSPpE8gpUEz5GDey8ggq4vrC6FHT9m
         pVxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=OlSVKzFE1Q9BCH/xjw1bokQDCp7IHVagUzHPkq8I7WI=;
        b=dOE8cgKNcePDno8QNjl3beDF7YFpFX/eL0O6bWnGPMWxtGqBNqAwIGE6Jvrd/vPF8m
         l2oEcgGo/Q8XYNq/SzCy1FhW77+TK4A943Vc+2kRxqL/lii20lfqcXcbNm6fz0dOv1Zw
         7Gp5S4B8OIrOdNqL9wHaiA3HBeN4tkgcLX5US5jH58D5dEMPuRgDH8JolWf5u1L5gKCE
         WPR8ypeDx9bOkLPZD1wGvX7rW2jw9AXpwGnnUZn4EjOIY2FAJ6x0EYZ/fm8wAm+b3iNA
         0vIyCFuUBsoaOtWYts4bOFvp6HJn6mbgf7TEFsf6oi8vRtnDN4r6ACD7pw8zdbNQMAtt
         iw1w==
X-Gm-Message-State: AOAM532hufOdytjkmMSdXrG3hkV6mh5JRq8OGz9L983yMYAkOoielJ0Y
        ybrgzzouZS2Xe/RCVv7nLM+bK683M4SoWCj133O1UNQ3
X-Google-Smtp-Source: ABdhPJxa0mkKAbHyoU1c0G8q9G1hDx28XT+sSeHEf9WSOoThtWtON3SZHZG+8pRNtHzpV4FIB4BCQmTu/o8A1VHcoDs=
X-Received: by 2002:a17:90b:360a:: with SMTP id ml10mr5443221pjb.198.1600813401716;
 Tue, 22 Sep 2020 15:23:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200922135718.508013-1-xie.he.0141@gmail.com>
In-Reply-To: <20200922135718.508013-1-xie.he.0141@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Tue, 22 Sep 2020 15:23:10 -0700
Message-ID: <CAJht_EN3q_2+u92+TmE7QDE-RRwRQtvGx+NHyf4hDPSA50oPQA@mail.gmail.com>
Subject: Re: [PATCH net] drivers/net/wan/x25_asy: Correct the ndo_open and
 ndo_stop functions
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry. I wish to drop the 3rd part (the 3rd point in the commit
message) and re-send this patch.

I'll re-address the problem discussed in the 3rd point in future patches.
