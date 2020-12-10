Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9832F2D576D
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 10:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732029AbgLJJlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 04:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbgLJJlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 04:41:32 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320C9C0613D6;
        Thu, 10 Dec 2020 01:40:52 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id o4so3729004pgj.0;
        Thu, 10 Dec 2020 01:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4wACi7c+y84hFlcOFDDjJ1mfg6gJ3+Zeyx/hwXEAMNU=;
        b=hJHsvvU/+uBIFX6TLQB40KT17anRRYSMu4q+h9i6CGgJUtcvGs8/l2Dy+eDmBoEFZ4
         pWKWCQGfBTdhFGKjGBfCHNHX1vgxY59IfxFVg1MHIebHR3SPRvy6Jg5NYUG0MIGYqdFx
         VL+D9RRYsdt0aXZPv1uiKd7o6uVr8rZPxzq+w4t4Nkt0WpHUYxlRWoCDnR0q4k/jJrqz
         DJ74T5HbAPcRjvbcVzQwb4iS5qjIx/F84LFOnCQkHX0noBBjoAKuh7pW1bCmHBV33FGG
         STMKGJbHQ92uZ2qXQ+pXHlwWlKJd/eU/NvvybgpfHU34/GsaervI4S720y1ZY7e1Xw5T
         CWVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4wACi7c+y84hFlcOFDDjJ1mfg6gJ3+Zeyx/hwXEAMNU=;
        b=Vbq4565sPSREyJffeOQ3Sodx8KY1A3v5FzrtezX65ltSFklQIG1OLT2OYGe07Jh5vQ
         T9yakaFeGaJqwOiQlEAq10pt2indb3Pz1iiZKRdTXAED+r0qq8jm1o2FxeFsTqjW9QHd
         gRD8Qt/1wT9KlPUM/dDb9KF2aCFgAq4kPnj3NpGkpTKjYdXIeO6CF5b3MikEbFi2LslE
         JYjMcND8vHk6suVAu7EIHpG4A0KqUldW2QuVX5/v4pCJysuccblkNU65NNtubsOPLKJ5
         e0U6FmM+tyQEfCBP0HUHrY7EDvm+QuC3jl0dE47qK8tfHc18hT6pD5r7A1jQv0GXeXky
         sfTg==
X-Gm-Message-State: AOAM530/vriWmpCY5dgZY13JUQ8GLEZRKH5+xGjcAcv3Givqe6c7baRf
        Pw9KXeNd/SqOILh2WQ09XA8M8Cmnksnw5R7A6MTcccsT
X-Google-Smtp-Source: ABdhPJxHsWCOKgYVexWN3dQZ8W2TMDI6UaYW1T+HYEkZsFldN8WubM99OsXSlBmb+nDjIXtxLzHD0Ej/7Oafo/JKLBM=
X-Received: by 2002:a17:90a:c085:: with SMTP id o5mr2025373pjs.210.1607593251874;
 Thu, 10 Dec 2020 01:40:51 -0800 (PST)
MIME-Version: 1.0
References: <20201209081604.464084-1-xie.he.0141@gmail.com>
 <7aed2f12bd42013e2d975280a3242136@dev.tdt.de> <dde53213f7e297690e054d01d815957f@dev.tdt.de>
 <CAJht_EPk4uzA+QeL0_nHBhNoaro48ieF1vTwxQihk5_D66GTEA@mail.gmail.com> <8e15d185cabc9294958b13f5cff389aa@dev.tdt.de>
In-Reply-To: <8e15d185cabc9294958b13f5cff389aa@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 10 Dec 2020 01:40:41 -0800
Message-ID: <CAJht_EOD9QbCi=AkPRqoT2Hzweb65OTpxkoCeUNm9WUrnyw_8w@mail.gmail.com>
Subject: Re: [PATCH net-next] net: x25: Fix handling of Restart Request and
 Restart Confirmation
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 9, 2020 at 10:35 PM Martin Schiller <ms@dev.tdt.de> wrote:
>
> Yes, that's also the reason why I already acked this patch. We can
> solve this later a little bit cleaner if necessary.
>
> My patch that takes care of the orphaned packets in x25_receive_data()
> has again a dependency on other patches, especially the patch to
> configure the neighbor parameters (DCE/DTE, number of channels etc.),
> which I already sent before but still have to revise.
>
> Unfortunately I have only limited time for this topic, so I am not as
> fast as some people would wish. Sorry for that.

OK. Thanks! I appreciate your work! Code needs to have specialist
developers like you to keep it alive and evolving.

I understand you have limited time. Please take your time. Thanks!
