Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5223056A
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 01:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfE3XSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 19:18:04 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38897 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfE3XSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 19:18:04 -0400
Received: by mail-lj1-f195.google.com with SMTP id o13so7722872lji.5
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 16:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=quantonium-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LVIIpjnnPCLsUAPBd11N47MhSnl9QrmWCawoxmaW2KA=;
        b=d3Iq/Urov+E6cU3JSI/tG+b2TBhg7UOiZQmkOEWR9pDKktelo/CS9/idGQBcxf3uUe
         haFcnB5mcSsCvU69QIKl5GueHJRuw9OKQKrNySInxXBF1c29crbMVIURzZ3ps6JCGpLV
         GWzAeQqyu4exeZbiK3xEKrnWsAJiHGwJWWCTAvj9R1E1QGnQnPBHj0az4E800yo5/En+
         aurKf2WHgKtYHULZq0VYO1XV6T5cDi3M5KL7waRRyBXVFMr0bCxJBT98c3ljnVSzDj6z
         35glztrdspmlh1al9boNnP0F7dMwmLbJUkFVcFHC2Fr23Vjs1MB7JOB8BIyIF3EsJBQ8
         LsXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LVIIpjnnPCLsUAPBd11N47MhSnl9QrmWCawoxmaW2KA=;
        b=KUu6/T+a6WAZW5WxPQlxYycHjOw5R2d6k8eLp4R01zFMUOZxkllBMLouSwe//Ju7pb
         rRzlKRa44LamPDRrPljKzgySMpmrgGZcilqL0nU773I/NLVmqf5HLeoSRw1rlLrKVMk/
         ktw/fj+L8NwYEU29IvXcME9oZ7JI/Z3dZJzSOeO5L3l4V0608iU4Ol4ruwg8ejO+q5fE
         HhSbu7X23q/b2J0Bo8Zw7w0TP/hMPN7srHsx6/5jGfY4ebXI/o3U0AQpXEMLyeD4arS+
         XSMQmeyBSxmUd2VMjyXX4ZhFDEw0fyrDD5Wu/yzL02NSNf6k+9tZOlNC7bB+OBECJdh+
         l2nQ==
X-Gm-Message-State: APjAAAUcMMChIkrLNwrOVz/Grs+FmB/dQPMIRmDhlgJWQbkwrVhUjbT4
        AfEdai855U1OrRfmcUi9ys2wvz+WlwVHExoyAfV/lw==
X-Google-Smtp-Source: APXvYqzki8GKa8yHjJSKdQR9E4Rmvj+mx2EI90AOoD6OEYWtJItJFUUnfUZ2tLfJ/WkEJn0PHBcga/JvpcHYRwW3WxY=
X-Received: by 2002:a2e:7d04:: with SMTP id y4mr1931643ljc.63.1559258282217;
 Thu, 30 May 2019 16:18:02 -0700 (PDT)
MIME-Version: 1.0
References: <1559253021-16772-1-git-send-email-tom@quantonium.net>
 <1559253021-16772-2-git-send-email-tom@quantonium.net> <20190530.151804.1553728286012545364.davem@davemloft.net>
In-Reply-To: <20190530.151804.1553728286012545364.davem@davemloft.net>
From:   Tom Herbert <tom@quantonium.net>
Date:   Thu, 30 May 2019 16:17:50 -0700
Message-ID: <CAPDqMepF7DrF3YunbHKid_=SvD1_7QjQS-BddYs+O7sL_EdPjQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/6] seg6: Fix TLV definitions
To:     David Miller <davem@davemloft.net>
Cc:     Tom Herbert <tom@herbertland.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        dlebrun@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 3:18 PM David Miller <davem@davemloft.net> wrote:
>
> From: Tom Herbert <tom@herbertland.com>
> Date: Thu, 30 May 2019 14:50:16 -0700
>
> > TLV constants are defined for PAD1, PADN, and HMAC (the three defined in
> > draft-ietf-6man-segment-routing-header-19). The other TLV are unused and
> > not correct so they are removed.
>
> Removing macros will break userland compilation, you cannot do this.

Is it okay to change the value of a uapi macro?

Thanks,
Tom
