Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D00F488F1B
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 04:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbiAJD5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 22:57:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbiAJD5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 22:57:33 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978D3C06173F;
        Sun,  9 Jan 2022 19:57:33 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id e198so11919264ybf.7;
        Sun, 09 Jan 2022 19:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gKx+R06dgFeuVR7iJXoCkBPxrF2Apl09qUxtv6PLYN0=;
        b=JjDq71ibn5FynQdndgTl2I2VuEtzjI/3odcIwxX3kmKNI8EzqWvZQmlIx6vOqChYcu
         22KtrGRjsozpl8SMvC9FEgbYMbhil5pBdVDac0DjNThmcaFdsgHFkexTJ1cNktw9LVdY
         z4I1XhOFs7eCdpvqG1ouJD1Zo6vD0IDqCTWU1PFfgrA6n9g5w8A/XTNVmE7VeZTJPsAi
         E7GbW+9ne5xQ4KW+8q9yhK5Fww+VyCW9Amjhw6lfsABQ/8/sjV793fJErtY048GHhZ2x
         Of2aE0wcQk9rcLpa8X+k4ukofbxYiPl4bs8t5WRFuuGap6Y1Qrs+jbMR8uCGj5x0WhIY
         zL5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gKx+R06dgFeuVR7iJXoCkBPxrF2Apl09qUxtv6PLYN0=;
        b=Gqc15IPKehPxqixCrQ+nw/Kee8Msfyql8p+NS+3aPn0MzJpLmXbw0ALV8RJ/LuozSB
         /wk3BrhlI71TYvU+Uml4eZKQpil9Ps1VP7eFJdM6mc7H7uOd2WMAOdN5yvU4mXj88yA1
         gyt8mEgFLJnei6O0YscmosVgBzt5phzvPNnJyuep5ncmjNZMA0ZOQFa8K68SLZ+frkb6
         rjuWqS1YISxb6YZ9pApDQnyrfU8SjLNIlqfZDLLZD3X9QnyJEAwGm6IcfP/7GDMX2Pi2
         DAWd2BQ15V/OIYGADDtJ3DLNaeco4Tj08PG70uh+lwFlkfsR7ptLw6iL7JNHKZ1eqsEM
         ijYw==
X-Gm-Message-State: AOAM531PC/LG3IVg+6DU5iCUnkENJejBKCnHUeuTxYFRYe+axdswPOWU
        3wBnvi6YKQVwK7vzNNhJHIFcqXTCIxFemRPqwNMV+smT
X-Google-Smtp-Source: ABdhPJzTrETyuDmbXvR9z7gKCTEi3XRBUYW5RWIvBDdJ1o1QYQdlEAhxaqVSAAgeeilDeW2FdqR525K64kZ3HQA7h4U=
X-Received: by 2002:a25:c41:: with SMTP id 62mr22130417ybm.284.1641787052533;
 Sun, 09 Jan 2022 19:57:32 -0800 (PST)
MIME-Version: 1.0
References: <20220107210942.3750887-1-luiz.dentz@gmail.com>
 <20220107182712.7549a8eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <6FFD2498-E81C-49DA-9B3E-4833241382EE@holtmann.org> <20220109141853.75c14667@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CABBYNZJ3LRwt=CmnR4U1Kqk5Ggr8snN_2X_uTex+YUX9GJCkuw@mail.gmail.com> <20220109185654.69cbca57@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220109185654.69cbca57@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Sun, 9 Jan 2022 19:57:20 -0800
Message-ID: <CABBYNZKpYuW6+iZJomaykGLT6gF2NBjTxjw-27vBZRY89P3xgw@mail.gmail.com>
Subject: Re: pull request: bluetooth 2022-01-07
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Tedd Ho-Jeong An <hj.tedd.an@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Sun, Jan 9, 2022 at 6:56 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 9 Jan 2022 18:46:05 -0800 Luiz Augusto von Dentz wrote:
> > > You're right. I think our patchwork build bot got confused about the
> > > direction of the merge and displayed old warnings :S You know what..
> > > let me just pull this as is and we can take the fixes in the next PR,
> > > then. Apologies for the extra work!
> >
> > Im planning to send a new pull request later today, that should
> > address the warning and also takes cares of sort hash since that has
> > been fixup in place.
>
> But I already pulled..

Nevermind then, shall I send the warning fix directly to net-next
then? Or you actually pulled the head of bluetooth-next not tag?

-- 
Luiz Augusto von Dentz
