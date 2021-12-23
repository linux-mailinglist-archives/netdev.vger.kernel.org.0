Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D60E47E39D
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 13:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243721AbhLWMjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 07:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239727AbhLWMjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 07:39:06 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF23EC061401;
        Thu, 23 Dec 2021 04:39:05 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id j6so20767383edw.12;
        Thu, 23 Dec 2021 04:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CTz+WzOPPv+J3NG9b5Kt944FkWQA/8CWT9C+npA8ORo=;
        b=E6mN1rW41RakQLpi8CVFnf5wBkV8HhU9TSrPvRv1x6zTrXBCvR3eLUpSvrw8KGgvrn
         scPeTZVTDQaQVmhhRyadEK7G91kM9IfI3ABPNL9PytMOjMgqfoNoh0NeKIUG9wEYEhxI
         rzxIeudkYeSIUFlctRyhiYfppffbsUZrxBZLAju3nH+k4c4j9WR9cQOW2uSYmEmSu6PB
         +4XR492FBzayYRaoEDALm5L1ihvfx/q4tTEG5vzxjiw6bBui8l0cGAv7XTwQ9qRaWMGC
         +u3K1QVL9HQecP45uuY4ePm9LT36tP/R+drgHupKokHeKTK4M4MCGujSCP0pvCmZnV+8
         S24A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CTz+WzOPPv+J3NG9b5Kt944FkWQA/8CWT9C+npA8ORo=;
        b=IXZ2Ud2YZCo+93k7XWWHnwyaElHWzYgsYkFhNLo4omrrzDMmjEk8OuI6xh+GlacQwr
         1wfiaHmn63UroQF3TDw0bkf1ADvO2LuYr5rghEhNExvAqOLX1Jvjh6os+EJ5d3/5qpSa
         5sFb2wZsweyY56s/HDI49ZPdMRIfSDQ2rdAqeSIFT+q1msS5cJ8IE4mv3ATMMiMX4Kn3
         unSHSDyS3KwZIM+rUiwT+SlOVKTEU/2TVcWRETNxfVLLNp8t1NMKcstq2OWj2k78uyK+
         KnJdliXZyI9SL1tCmQqhcrDVAI/LViIQ49ZpJNYUHyH6neRS7v54xMSOzqZ4E4bVrjP8
         hnFg==
X-Gm-Message-State: AOAM530ecFltjA35zv67YOzXRTZiFWULMb1iDRX5Ci5Hdieb1IxoT1SL
        ILYoXIa/0U9g/EDqbH+rg5cNF1il1NpCLfgRMFw=
X-Google-Smtp-Source: ABdhPJzTk1oaxfNvGK2XQBZb0LI9+ErDnsXn/cLbG7wT5aFtzoTuAWuyzyTUiMn0XTB4JJfYGjG9FsApf0zLNEm9t6k=
X-Received: by 2002:aa7:cd75:: with SMTP id ca21mr1860304edb.242.1640263144114;
 Thu, 23 Dec 2021 04:39:04 -0800 (PST)
MIME-Version: 1.0
References: <20211223123232.1353785-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20211223123232.1353785-1-jiasheng@iscas.ac.cn>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 23 Dec 2021 14:37:06 +0200
Message-ID: <CAHp75VcuXAiLGy7p+2A1839x=9-L=E71xkTaRncx0-Jf2Fh_mg@mail.gmail.com>
Subject: Re: [PATCH v2] drivers: net: smc911x: Check for error irq
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 23, 2021 at 2:33 PM Jiasheng Jiang <jiasheng@iscas.ac.cn> wrote:
> On Thursday, December 23, 2021, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> > Do other way around.
> > ret = ...
> > if (ret < 0)
> >   ...
> > irq = ret;
>
> This version I correct the patch by using error variable, too.
> And the commit message is as follow.
>
> Because platform_get_irq() could fail and return error irq.
> Therefore, it might be better to check it in order to avoid the use of
> error irq.

Fix commit message and send v3.

-- 
With Best Regards,
Andy Shevchenko
