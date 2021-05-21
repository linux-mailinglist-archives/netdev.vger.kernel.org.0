Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E9D38D014
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 23:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbhEUVvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 17:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhEUVvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 17:51:02 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DBEC061574;
        Fri, 21 May 2021 14:49:37 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id 69so11682293plc.5;
        Fri, 21 May 2021 14:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=66fb4oSGK0L5gfh+2y3Yzr4PaM4N5wTM/f8Xpss0ujc=;
        b=WgWwLTNf51Evg/S2pBFLYrsIcbjMnI9c/wGBkMSsCcuc2BnvUiEEBAxwXquG/BGAzq
         Y6GoNGXDvICwcC9ncSFoqBXWJWnQExEmxgQBhkFHCV19WDK8gKnpfOMAY8CrZKL6imi5
         6deONijhF5Nxz6cDIgWhCsZztiKtlKupUqS8UZXlzEh4JTOg6ttPfma0l8/cTWHhjmG0
         Ju2S8autn7X26j2nDN/JGp6+00H4plkhHg2qu7dZqy+iApink3pD47CTR1/wanKdTCGl
         anyNmsvtkgvPml33xB24UWMD8CKFZoUqEus2j9NYRxFPDQolqViALhsJ6I2O3F0sM/fD
         Y9Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=66fb4oSGK0L5gfh+2y3Yzr4PaM4N5wTM/f8Xpss0ujc=;
        b=mftvTinNjrtxuO/vibpJCEhQliVrGlhfEP/YTHpVFRFEDppnH0ANOKzcqH6FOi06GL
         1Kg0+2RUZ9ahgkqMRBu3faQCBKVLtTeY/8Nn8Ei03xqEQkUbx+L1iLhYthQPgb3HnUCS
         38BDOCpA9r1yeETvGtItvUoIN6fYnblhAJpHy5OLMMlhd2x/Bg8oBmTXswgSgHpSm1f6
         Rf9g+xnc56USOgVNgS0aocHvdEQer2oHknwR6Ev+ULP7VJS8aPXQWS58GO4ZTO1wloYh
         5P5TpFomhPnUuEFpkIK3o1rJwRc1fPTP+j9jir5FbCY/d9DTsmK8ILj2PmU5sKrbJkCR
         Ga5w==
X-Gm-Message-State: AOAM532cMQBBe4viSWmzhaZVvGFXcq+cvQ+RBPZWPORKB3itVe8y0HNA
        bxsdlpcj96qMtBJDJZ+BeT2N0ghdV0NnxiidbQc=
X-Google-Smtp-Source: ABdhPJxjFDjjklUIBDaoj7dF48+2a1oump7WVzOhi4+ePlBoV+zJwDOWAaWn3YxB+RzRmdU5TiXwW+N21SrzahU/T6Y=
X-Received: by 2002:a17:90a:e2cb:: with SMTP id fr11mr12948417pjb.56.1621633777168;
 Fri, 21 May 2021 14:49:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210519204132.107247-1-xiyou.wangcong@gmail.com>
 <60a5896ca080d_2aaa720821@john-XPS-13-9370.notmuch> <CAM_iQpUC6ZOiH=ifUe1+cdXtTgiBMwPVLSsWB9zwBA7gWh8mgA@mail.gmail.com>
 <CAEf4Bzb7+XrSbYx6x4hqsdfieJu6C5Ub6m4ptCO5v27dwbx_dA@mail.gmail.com>
 <CAM_iQpVAhOOP_PRsvL37J1WwOxHKmLEnRXVBYag1nNccHN7PYw@mail.gmail.com> <CAEf4BzYUw8bTUXEdrkRwqFg0OGsMTNe+kwxkbdqAMV9we4xifw@mail.gmail.com>
In-Reply-To: <CAEf4BzYUw8bTUXEdrkRwqFg0OGsMTNe+kwxkbdqAMV9we4xifw@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 21 May 2021 14:49:26 -0700
Message-ID: <CAM_iQpXKxqebXz37MES2HqYue3ELPPvSvOQJYu6T2SBQ_xcpfA@mail.gmail.com>
Subject: Re: [Patch bpf] selftests/bpf: Retry for EAGAIN in udp_redir_to_connected()
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 10:12 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
> It doesn't matter. Instead of having an endless loop, please add a
> counter and limit the number of iterations to some reasonable number.
> That's all, no one is asking you to do something impossible, just
> prevent looping forever in some unforeseen situations and just fail
> the test instead.

Well, in a non-hostile environment, the packet will not be dropped
as it is sent via a loopback, hence the loop is not endless.

"my memcg kicks in for some unknown reason" is pretty much
a hostile environment, for which we should not consider. The counter
argument is simply not to run selftests in such a hostile environment.

Thanks.
