Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22404412225
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 20:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347849AbhITSNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 14:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356720AbhITSKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 14:10:43 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A292CC03403E;
        Mon, 20 Sep 2021 09:59:01 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id v2so11472039plp.8;
        Mon, 20 Sep 2021 09:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IBSoeVVLnWYAGPb1SKm3z5sRdwBHeGdklFJrhwdB0Fk=;
        b=mxpwn2lSSJ3JeF+MV9cVwjvjo2x+lsjCqILuSHO3fItLmVLbvGdWPgCfwpOhhTCVte
         JfrJCqruUjbiRw3++8TJ5LGoAlVOjnhWEgb0/hs3VusIXpMs3gXoeInjf4R8JCVU8lVM
         32ddI6pgI+0Jktv+nvvMPz53Yo1wCUTc9N2aDD1BgM0jsH3nMdU9Ag+EaUJ+eLvOutP2
         tVEjdBwmFW3gqVmtlJpdocAv4DsUgW2+vdPqdAk6X1b5F/c9sJVBhBP/3q/2bnI2O2rn
         y0UJKOmxMXSkDoDvE7U4JjWKF2BW9Cl7nJWUiY4o/T5MGOd2zLfs/ipxPIjXxPpielz3
         Ljpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IBSoeVVLnWYAGPb1SKm3z5sRdwBHeGdklFJrhwdB0Fk=;
        b=xbbZe+Ala7WDr14ucNu+j+RQITAWhHVZvQmMaar085FW1dDW3Ob5HIDpkgFB1kbR4n
         CJ2o5BDgJUHFctRL86SjJvzNdbmguxAux2rub5OY1Qycpv9RPV0V6Lqms+hQEEtJGQ0m
         uO39C9xZwTzIBWtWX3m+puGAaxpb0yl6H8FtDUdoV5EMOApyLQB2o5oxAgISshdD4Lwk
         +wT996y+pCjJ5r2UeLQuMGLBj/zWC2dCmiayPES1Ab6VLF3el5vprt1ZxYMLGd/fUKGk
         ItMaIdPEpTR4wXAifXGmyi46ShboTWt6G2nTcKphRS67ydHATlDKZtgGuBUV0LALu4RG
         3XsQ==
X-Gm-Message-State: AOAM531p14CLmUyTvY4f0NNBIkCiIA5rs44z5lWVAq5nPMBJPOyiLPtj
        VHOLUQOZ1ju32djpzU4jxVCvVno9DOC/f1NKjPvauyS2F6k=
X-Google-Smtp-Source: ABdhPJyE7NkKOF+WWXx0CNmVPrF3VW+8E2Z1M9gR0RHHAnTZAjdq0Exz4rP/3zC2M+V3qgTRcXldquMCoCUJruenex4=
X-Received: by 2002:a17:90a:2945:: with SMTP id x5mr23757549pjf.225.1632157141127;
 Mon, 20 Sep 2021 09:59:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210904064044.125549-1-yan2228598786@gmail.com>
 <CAM_iQpWCRYXc1PAOTehgMztfbmSVF=RqudOjhZhGeP_huaKjZw@mail.gmail.com> <CALcyL7h=vS_Nmg4GfRe-SD9ZSZopCM5p6U1mojn1gncw1Nds6g@mail.gmail.com>
In-Reply-To: <CALcyL7h=vS_Nmg4GfRe-SD9ZSZopCM5p6U1mojn1gncw1Nds6g@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 20 Sep 2021 09:58:50 -0700
Message-ID: <CAM_iQpVB97-t+J+zEF5xzLi07+YPK6O+Ph-NyTxAHV-2=cY93Q@mail.gmail.com>
Subject: Re: [PATCH] net: tcp_drop adds `reason` and SNMP parameters for
 tracing v4
To:     Zhongya Yan <yan2228598786@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, hengqi.chen@gmail.com,
        Yonghong Song <yhs@fb.com>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Zhongya Yan <2228598786@qq.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 4, 2021 at 7:51 PM Zhongya Yan <yan2228598786@gmail.com> wrote:
> Thanks for the tip!
> See reason:https://github.com/iovisor/bcc/issues/3533

This link only explains why TCP needs it, my question is why not
do it for other protocols too, therefore neither this link nor you
answers it.

BTW, net/core/drop_monitor.c is based on kfree_skb() tracepoint
too, in case you are only interested in tracepoints not other things.

Thanks.
