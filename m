Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5549924E22B
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 22:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgHUUg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 16:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgHUUg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 16:36:27 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C63C061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 13:36:26 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id qc22so3918043ejb.4
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 13:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ebU6ZOPrEiT4sJ2Qift4Kje6ztl3WCJTClKg9hrAqUQ=;
        b=sJJ4ao6DisZKUH3MXLhKbGf3f83SemnBmSnc0GZe4BQVf99IvFWHXrBHpqkrQwShn7
         +bYszE3x5i2zzGpUWigeoglsgJZG38A2PkRWE45g+t0D2eLzT/AOq0gLKENYlXi4TshE
         J56DB12WAL2lMl49Fw1xhilezBWV73I457CHMUBCyFBlbtrk+98CEw+fB1Rp7QYyD8vG
         yOX6mVOCzDAznOB6DirK1zDl6I8Tk7+maUeZ5Z/mqvAaHmFfXZneBwgJ7NectQn6ZqK7
         naKp7Iiq5p8U7rxj3O4iUNiNR+/bbMYJ195On09y8rSChp9UtBOWc+GnEVFvXPMaDE1w
         8aIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ebU6ZOPrEiT4sJ2Qift4Kje6ztl3WCJTClKg9hrAqUQ=;
        b=MynW05mm3/vtE4pltfEzk1ML+Jeeggi27dGxqdllp6Z6mG6A1oac5hEG/B3AkXSItM
         YlDS6CUvCXYRkrDY0Agj9R0xGlsgP3WBMaODrgoW7Rq03BJ2wK7eMNqFM2QPQqruI5d2
         MalM9H+cWHtD91gOAIEqIeshyX1EAY1AGqVbhmTAX5lgxeqoGSECtl8hQODJGSz+B8kN
         N8aBsl7xpQrLEO/vTYruDdx+yt7swheCBOUp345b1lnGG5DBcyexW0AKA8X2zgFU2Pej
         zwtWSqFELIXo1liVKT0y3cLfOKV7orQ8k2vf+/ixeym0IvI7fm+b0djicyotC12PffsV
         i/eA==
X-Gm-Message-State: AOAM532Ji3uoV2P9nNSrXloKs8Ewl7Y2vlLlrK2iZjCSaTU62HbafT8T
        w8vgSEDxHnjcO8tmSpT2QW+TkoQMI/k8/Vu9vJD8
X-Google-Smtp-Source: ABdhPJxDQil/PQ8kmBmFKvgLTSoD067CTWtz7P7sgZlRoEMyzAplC2icCm4EXb7/gBGF6eTw85Zm4lqErAh/T2no1x0=
X-Received: by 2002:a17:906:3390:: with SMTP id v16mr4569483eja.106.1598042184879;
 Fri, 21 Aug 2020 13:36:24 -0700 (PDT)
MIME-Version: 1.0
References: <159797437409.20181.15427109610194880479.stgit@sifl> <20200821.113844.1413413632075759126.davem@davemloft.net>
In-Reply-To: <20200821.113844.1413413632075759126.davem@davemloft.net>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 21 Aug 2020 16:36:13 -0400
Message-ID: <CAHC9VhQKRozweij6PndZbffq5uaVqkv-xnfhhNNqgLuQ6BDWeQ@mail.gmail.com>
Subject: Re: [net-next PATCH] netlabel: fix problems with mapping removal
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Stephen Smalley <stephen.smalley.work@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 2:38 PM David Miller <davem@davemloft.net> wrote:
> From: Paul Moore <paul@paul-moore.com>
> Date: Thu, 20 Aug 2020 21:46:14 -0400
>
> > This patch fixes two main problems seen when removing NetLabel
> > mappings: memory leaks and potentially extra audit noise.
>
> These are bug fixes therefore this needs to target the 'net' tree
> and you must also provide appropriate "Fixes:" tags.
>
> Thank you.

Reposted as requested:

https://lore.kernel.org/selinux/159804209207.16190.14955035148979265114.stgit@sifl

-- 
paul moore
www.paul-moore.com
