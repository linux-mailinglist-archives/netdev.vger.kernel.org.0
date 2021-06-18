Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283913AD27F
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 21:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234643AbhFRTHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 15:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbhFRTHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 15:07:14 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25ADAC061574
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 12:05:04 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id s15so9946203edt.13
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 12:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=InFDEGKC2QscmOhpxTDMf9HUFBmB/LgZPJnIwcKnPTQ=;
        b=ahMENiKkmAR8uCnp8xipzJN4N7JXUgtH7/TQS+yk+R6rywi/hX9CJdat+U/xFmUk4r
         hat5TYBzYc5X54RdltIGEGX6NfVBMsdMxfkUG9PgO1DxMw0qE0QWJAAfQ4PBKuLAulaJ
         YhQaBz3dmSsJl3E5+BqXnPqEIFkB3xapzDr3DgoxxZkWC8+4Somn3WCfYwF5PQhCN+qU
         6xI3ArYXtsT8C0cbOpoLwYpI0ovpefBeiSkGOuyL0diV45C/MNmowJ3mIasRpYbzxlaa
         pO3NlLLaR9ODZTxvCgfMetoSWF1cqDUWCiZvcru2IW1kwDQ9PEedX60w51UsupezSY8H
         JLgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=InFDEGKC2QscmOhpxTDMf9HUFBmB/LgZPJnIwcKnPTQ=;
        b=aNQjrktOXriQ+zV13/Rywa2YgyEa66GY9Bx7y38TWGdJpaGuCPJrXGUcULRWcvWK3q
         IQr4aVz5UKhx3KiFBHYWG20geSceB+/MlSOPLaTYaKGeeASLM2mtEYWDNtoexPH+Cm1y
         qS7KLwXrSZV1pBGbztR6tXwY40cGkOvG+WQYyfH1myfys6Zs4QXmY25pqqL9RP9wrnCY
         Vd2k9mX9vdhKTlpXt5uTpZc8Puet/sZrB8MulobleTM4DtdR4QGcBbOJoTOdNctDIY6I
         pT/V0ssGvkw1Js2u29fB3CwdzsUBl0YFaBMyli0RqT7UvrEbsqg8AyXZ6N6J6ld9KLcC
         3Zmw==
X-Gm-Message-State: AOAM531G0o+FFNQHi+cp0xw4T1bB7HxLo6u2TtatsrZU6hCwtEuXn/vq
        bVfJmyc+vjRvKiGrWaqSDDy9pxlEOJc=
X-Google-Smtp-Source: ABdhPJzre7LL7imzb0dHpsABf90cgcu1A2O38B5bpZSpr8TeeFxw4t5we9Ji9ENd+lLIYyZn9ZO0dw==
X-Received: by 2002:a50:d943:: with SMTP id u3mr7258744edj.175.1624043102821;
        Fri, 18 Jun 2021 12:05:02 -0700 (PDT)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com. [209.85.128.51])
        by smtp.gmail.com with ESMTPSA id z3sm6449508edb.58.2021.06.18.12.05.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 12:05:01 -0700 (PDT)
Received: by mail-wm1-f51.google.com with SMTP id c84so6223939wme.5
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 12:05:01 -0700 (PDT)
X-Received: by 2002:a05:600c:19ce:: with SMTP id u14mr13438640wmq.169.1624043100534;
 Fri, 18 Jun 2021 12:05:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210618045556.1260832-1-kuba@kernel.org>
In-Reply-To: <20210618045556.1260832-1-kuba@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 18 Jun 2021 15:04:22 -0400
X-Gmail-Original-Message-ID: <CA+FuTSc+x+ePvvmLGWvau-XEye6fuN398aHsJiCCnfM6bPfDoA@mail.gmail.com>
Message-ID: <CA+FuTSc+x+ePvvmLGWvau-XEye6fuN398aHsJiCCnfM6bPfDoA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: vlan: pass thru all GSO_SOFTWARE in hw_enc_features
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, dcaratti@redhat.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 12:56 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Currently UDP tunnel devices on top of VLANs lose the ability
> to offload UDP GSO. Widen the pass thru features from TSO
> to all GSO_SOFTWARE.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Willem de Bruijn <willemb@google.com>
