Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E504327659C
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgIXBGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXBGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 21:06:45 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FB5C0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 18:06:44 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id m17so1586640ioo.1
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 18:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MyJeopwM3d784deUc8QfDgsHsd0NvtCbQzgqZCRJ9gY=;
        b=L5evM3exxALR4gMzK3uZjDgeBzr4okujknhNNFbmt4H4gIr1SYxcfd8orQozP+QmCE
         ZOsiT/Y0klvRvB9tTN4PrLASRhNvlFEGPvjRitBAthYkYu1AYdibXJzKc2LlOKSvjSyl
         sCHRTa4G63wqamkb0cWHyg3xKVnaRbJmPlZvhC7d5OHHzsVtiMijEQKJJ3A5cXym1Czr
         /mplJx4i/kKqm7IRDB/S24KF+jdt7gEnefTsGFTT+CcRfemrcxgKc+7PanJep69/Q1xm
         clC5cm7zqj89A6BvubBJ5uId6j7ZFfzWOSBIZ02rTQ75u66RPidq3ym6JU0WDD2b9wgq
         05jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MyJeopwM3d784deUc8QfDgsHsd0NvtCbQzgqZCRJ9gY=;
        b=qf2HnX6/PXZSHmqletiyyEMa4zKoHZN/e6/FqDmqkW4/xsjj+YYRLmaQTOq6WULD8p
         sKg6bKqfMGVR0Ck1tVxP6lNeL/drLmx/BWt22062Vxe/K6EhL1paqYuBlx0SrJeDYVsY
         KCLREYAoRBAmcG2ADsnILwIHpWJx9U78+Uycvvv/7yrjrJaS9qafzI6CZsB1+RG/f00f
         tebYPBXzUgdSfanf4jptHlPGJ01va3Maz0jmGBUCELTLEZKBByOpoD9VyBdv+bMeVjNi
         PhafAHWGl0pxS+rsSkx924d31saiR8Isv3hvOP94Cj4xfmczTruQgX93r8zHGbA/UITZ
         4BTg==
X-Gm-Message-State: AOAM531pQNOvy5II4qXE9wZOTKgDV6yrPsmd/zDDjzI/us+8CFns8NlS
        Y0M/c6XlGUhEsc9301V+i5oK5uCjCjL2wlgrGbiWXQ==
X-Google-Smtp-Source: ABdhPJxW+XOwHAKZNiY+jvWmtLDgZzdBGBipj+Fjm55wJ7oiRFaIMM0RqzK9dMlcQvyVcROH9z+nZ+6QSDXhQMFaL7s=
X-Received: by 2002:a05:6638:144:: with SMTP id y4mr1699803jao.61.1600909603971;
 Wed, 23 Sep 2020 18:06:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200923044059.3442423-1-zenczykowski@gmail.com> <202009240537.PKBbxi6l%lkp@intel.com>
In-Reply-To: <202009240537.PKBbxi6l%lkp@intel.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Wed, 23 Sep 2020 18:06:32 -0700
Message-ID: <CANP3RGfc6y+Vafi2Wy5-gFKbcHacZsfLFfmPRx1f5y_7Zw00sg@mail.gmail.com>
Subject: Re: [PATCH] net/ipv4: always honour route mtu during forwarding
To:     kernel test robot <lkp@intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>, kbuild-all@lists.01.org,
        clang-built-linux@googlegroups.com,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, Willem de Bruijn <willemb@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Sunmeet Gill <sgill@quicinc.com>,
        Vinay Paradkar <vparadka@qti.qualcomm.com>,
        Tyler Wear <twear@quicinc.com>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 2:34 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi "Maciej,
>
> Thank you for the patch! Perhaps something to improve:

This patchset was already superseded precisely because of this issue.
