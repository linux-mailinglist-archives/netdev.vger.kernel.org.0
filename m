Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A38E1C4757
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 21:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbgEDTtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 15:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726111AbgEDTtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 15:49:39 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557BEC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 12:49:39 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id e16so16003ybn.7
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 12:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YNfELQwKNP1Q5jKZoFZQxJgXNgB0Xlu0Uy32oNgZygQ=;
        b=mqNuAWeTaZNzYGIS36UMiog7ofTbiMcc3fBvksVOFkNLVTmHdZ4AsXRM0vgSGbUBCr
         ZIEB4NVpmOKepI3P1rbWwxWSRMgjuhX7j97d4H6j3q38+pBTdGoJIcS9M1fD69KnVUrA
         Wr9H3Zt7zyx3EwezJ6bQrDO8jiuOrSbbhsCXiee2Ym1ElSG41Xpmok3dyH9SdhBFUasG
         NhMlBeMjbeYp9HGzysgbpHIZ0bNbNzO2XGjZJCD7vihD0Ye4EaZAOilN2U5SSfFYwk79
         ePLA+eFzxHlRMP6Lsx/iOi9cW7MayYTGrGhcaPSLhjZyuu46ahau3n7xVG/W73g7BY2H
         Faww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YNfELQwKNP1Q5jKZoFZQxJgXNgB0Xlu0Uy32oNgZygQ=;
        b=bkWr4wOq29JEZt1Bv5+JafL9BQ9vtCFusUAnzjwcVG6cfzzDuh+RpJr5gVo79J3fuR
         1YmcT4Qs/9e7rA15t60rZ0jiy3ZCU1qNe9P4erJCniukNYMdl7O093OdZZUpSE9Nl/ZU
         FmY0T9G5dVMotSki2eZqZh8vWOdlPznSqEuf+BSwZJvyHgpfsDa2k8tS57IXBZvcnxrm
         UtZXA01sGzfS+bP2Rbe6A9DGrXBFtMOgAZe1+mh8JRgBP4Wk3Na5P+XCx7KEA4KEdafm
         s81+WEwj7hLDEjaDKcFZBqvOklEucgvVxNOvK1E723gry0vnz3EgXQR+Y6JsKwAY83N4
         r3UA==
X-Gm-Message-State: AGi0Pua8sZkvnqroApRStM0wLRl/nN0eF1hEO8xR5Bxj9AY7IAPi8FSs
        FLGQYclDMhYGUX95CS24CPRFQW83oRo9/2hLoH5oAg==
X-Google-Smtp-Source: APiQypKiB+8GwzH3FMCyxEyDqXq6XfgTOnk857mwNoEtcfbStTrichp4qypfbTPvlBsV59Yrcw6pSwLn63lyj1R/1Zo=
X-Received: by 2002:a25:3252:: with SMTP id y79mr1579293yby.274.1588621778238;
 Mon, 04 May 2020 12:49:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200501140741.161104-1-edumazet@google.com> <20200504.115643.1162428608759543632.davem@davemloft.net>
In-Reply-To: <20200504.115643.1162428608759543632.davem@davemloft.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 4 May 2020 12:49:26 -0700
Message-ID: <CANn89iLhJ9X3fBntt7df6mCo0XnM7sPLYdmUmrJfi8KowbkfQg@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] net_sched: sch_fq: add horizon attribute
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 4, 2020 at 11:56 AM David Miller <davem@davemloft.net> wrote:

>
> Applied, with some fuzz due to the recent fq optimizations.

This looks good to me, thanks David !
