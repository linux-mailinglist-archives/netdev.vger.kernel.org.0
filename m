Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C3D47E2DA
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 13:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348095AbhLWMEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 07:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348102AbhLWMEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 07:04:37 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DC7C061401;
        Thu, 23 Dec 2021 04:04:37 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id j6so20399518edw.12;
        Thu, 23 Dec 2021 04:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vHXP4DgUxXHsJzGn5rRtLSurzSkz1QEhYFG5Qx1uOwQ=;
        b=RLDaPYcqkPeMjMJ6yC56PoeEDIE24h55zgk6ItpvpcLd89jcnNOVqAKBvUnhObSIAD
         B0oJc+oeO7WWB+2H+Nba2nShScj1QijSwJ+IeWEWKTrl/+Idp4ru8e2ZRe1Xb2vgc8fu
         iZhphtZGnCoOG12P6Vl+AnQ6aHwoSArE3afEqgPfpuijZ7SZLXZTOHtySdIvA2jGY3Ww
         K29MWwUTA1HmuexeoiPV/xu9tzM2H5vaj3G6Xz1Cqudz/vuhe0O4I4XAEv0lnKB/TDu8
         LZpvIq47Ej2GRqdrfunAO4YRtFb07yhPR0dRXbrzpXYGhom9zcvHMgO2MrfI6djFGKMA
         C3NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vHXP4DgUxXHsJzGn5rRtLSurzSkz1QEhYFG5Qx1uOwQ=;
        b=cwU5YM4PSarXmVoNewEc3D4eS3alI+eapQrF81Cs+HZ/gzoRSicCACMKewRXFtx3/H
         RsqUXRWaOgQBQRO1VwNEKdF2Dd0ncgQ+BAeXqmYunW4euD3sfO42wSgsxJsqmc2rrnYQ
         csRSRSb2WU0U0LGrx4ECYGLye1TEmK5gWAD35V0iigFfUPw+XUg/l6gi1/eLQIcq5DET
         oQMoGifn8X//ey6nMufOufrbZ/kkoVL/yluOiJ0wSfvzWvnLjsBFgYh+xSLQe19jxuo6
         bVfs/RfhBJTkHbuAelR0AWpfh31bb5RSjl5FC/iCRMfpSURtenasL3HGQ8RiarBH9Bub
         nIXQ==
X-Gm-Message-State: AOAM530C753dw8EnrTGpwkfBkYVrnkmZr2xNAwfkMpSNqiNU7+kYDfHE
        jglPdwdL7CqwJvrvgcZXlIU4IY2eigck6IXla+nYgWbR/m8=
X-Google-Smtp-Source: ABdhPJyRVDEnjltecyiX2KCow6fCITK/+MaEdzV9k7+Kdcl86XxJMaAyVam4EJ03SzQB8wG0Lmh4NgaFKddoq2DXgR4=
X-Received: by 2002:a05:6402:354b:: with SMTP id f11mr1743438edd.342.1640261075478;
 Thu, 23 Dec 2021 04:04:35 -0800 (PST)
MIME-Version: 1.0
References: <20211223120146.1330186-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20211223120146.1330186-1-jiasheng@iscas.ac.cn>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 23 Dec 2021 14:02:37 +0200
Message-ID: <CAHp75VdDPKWb6a6SZTUqwv-Zif+Lxz_zgVrRBEDuJQ_xVpNPXA@mail.gmail.com>
Subject: Re: [PATCH v3] fjes: Check for error irq
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 23, 2021 at 2:01 PM Jiasheng Jiang <jiasheng@iscas.ac.cn> wrote:
> On Thursday, December 23, 2021, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> > Always think a bit, don't be an appendix to the dumb machine.
>
> Sorry, the v2 message has a mistake.
> Here is the right one.
>
> This one is also corrected.

Same as per previous patches from you, fix the commit message and send v4.

-- 
With Best Regards,
Andy Shevchenko
