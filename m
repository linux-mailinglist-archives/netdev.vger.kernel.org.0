Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67E61CC4BA
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 23:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgEIVba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 17:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbgEIVb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 17:31:29 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CC3C05BD09
        for <netdev@vger.kernel.org>; Sat,  9 May 2020 14:31:29 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id b18so4846901ilf.2
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 14:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hJ7z4VAJSx+xm7FsCX5ABKX2tbQO8xkYPxQslY9d7K0=;
        b=rWXeKbbANOWUUwP7lpX8Cf9DypzTSTus6AtVqPLXV/44YtFHj5dLS43e4UxvJdWVry
         gwleo1nb3nWjzEjj9K3w/eKzcAiNBlaqAtRX9yIXuOtxAocr3na/utdf6mExMDCvNdmM
         d7DK+79H5yESiqkR8KA/BALWvVCPgho//KlswpCxh08D/Ll90Ka/PzACPfpx5feJsrSd
         UcQjfBzYV7mYxN4rxPdH+WfIs6U3L+3kpZijJdaBG/vRoRMSmJTfk6pVz2PxTo1h4XsN
         zDMohhkIQ5vFvqUk19hlU1mgcfk4ntA++fv6c/7twKf647EPBqgO/iMVtIRgWNXSTMtj
         XqWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hJ7z4VAJSx+xm7FsCX5ABKX2tbQO8xkYPxQslY9d7K0=;
        b=cxpYKA/di7SWEosGKw8EyqGk9EXEGvnWX8Pnn8YxSlkv6lQJ3Q94A9WCTu2QX52EAe
         FO3rTl2x+O9PVDtTlq9gY7coELGGp1OVYSHQnDK0y/BslpcmINA7YESNoQpGbHe176Yw
         DANMP7om1s/qkq68+ovovx5bE/Mu5Sr12bLjLcUx6tiKrhFusI92NyenA8Icd2AAYmTQ
         Ak3hfStYn6JXk9ANjnLbqL1Hy6AMVR04Yy4QrPCSQAZ56mi8vrsxfYqOYf+56WdJTsg1
         1oXnprg7V1Q6ppF4TKE/vgMZc1L7gjfRS08a6sL5wHHykm7jIjjTIEQsF1bre30f6cD2
         8zww==
X-Gm-Message-State: AGi0PuY5IuTOCw8mRHsZKcMKxuc7hbQC1MCVXfxw0fJ6PGzWxWyfkytG
        fDifzRV6c+HIzfAJDuXpaddhe2Ty6QogpWKS2vIVFQ==
X-Google-Smtp-Source: APiQypKcAQjRZAeKQxjwrnh8OcxFNef9L1axiqwOy9aJfYL/oi19NkpaLm+EZzvOr9D2wLBWlSM9GkX0opkLZaeBXcE=
X-Received: by 2002:a05:6e02:544:: with SMTP id i4mr9590534ils.145.1589059888556;
 Sat, 09 May 2020 14:31:28 -0700 (PDT)
MIME-Version: 1.0
References: <CANP3RGeL_VuCChw=YX5W0kenmXctMY0ROoxPYe_nRnuemaWUfg@mail.gmail.com>
 <20200509211744.8363-1-jengelh@inai.de> <CANP3RGe3fnCwj5NUxKu4VDcw=_95yNkCiC2Y4L9otJS1Hnyd-g@mail.gmail.com>
In-Reply-To: <CANP3RGe3fnCwj5NUxKu4VDcw=_95yNkCiC2Y4L9otJS1Hnyd-g@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Sat, 9 May 2020 14:31:16 -0700
Message-ID: <CANP3RGcae5giBntjaXwU+EpuvayW+_S6mmHJ2H-xqtf1caVktA@mail.gmail.com>
Subject: Re: [PATCH] doc: document danger of applying REJECT to INVALID CTs
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux NetDev <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also maybe the example should be:

instead of just:
-A INPUT ... -j REJECT
do:
-A INPUT ... -m conntrack --ctstate INVALID -j DROP
-A INPUT ... -j REJECT
