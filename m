Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF9D2AE694
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 03:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgKKCvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 21:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgKKCvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 21:51:43 -0500
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299D6C0613D1;
        Tue, 10 Nov 2020 18:51:43 -0800 (PST)
Received: by mail-vs1-xe43.google.com with SMTP id z123so364772vsb.0;
        Tue, 10 Nov 2020 18:51:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f5k/9uFbnfs/f8a6g1xB26ridc46MN4oNEtBkfOzYcg=;
        b=SGNatAJg4ZWElg+LCUolt9lm503miKO80z7GpLg0QZqOE9BxHGUpyU/isicut7E2N2
         GlBfmchfukVqs+6+gTxBZ646Kc5XjLvragUVEExL3xgD7zwwzQBFsTKfhZv7wk+ciyzI
         TMeGzNui+F37cutCpbqM3mEU7o1ZM26SThlswJNGytI2cxsLmi2+IZv04mZivYyfmCoH
         SiXXonpt1n2gtP+FBmw0m9f/ECyncwMovnGXLUufvXgsR3itPKngNlc188mTNuoFNwhF
         rtjLVnp6JC4dkKMJsOQP8LuCrATGVJ032HPgwJTRyfZcMu6qoodZdULK2hGS8tGszPZ0
         0GNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f5k/9uFbnfs/f8a6g1xB26ridc46MN4oNEtBkfOzYcg=;
        b=CCQoOpNMn4aCOohBsRjpykHyvP4A5BedqRRYnPtiv6HzlO3g7RCl+b/jF3kTesRc1b
         t2W7Jw9xwtoEExW7LqeX3SXgi/KbwONQ3zk5HHIe0RsYh0fT+LhZIRqZKnaz3QR+ztoi
         PNtN3hEJ5xisHHeaBx0mQNDHOJML/iBNjP37HJcyMGDqRaY8Og488bdG6A/yhZtWte9+
         hGaK8O0fq7sbRm4fUbNMGkcOkLnxufz4bMW/hDqXnWTu1wgj1iCUJQSUqAEY6tANC7yL
         gUQnS0PINSAHLkR0jPfnCupqcBL5h40JEKcEH3zpnk/4tJoJuxluAha+WObSNHh28Xui
         KFXg==
X-Gm-Message-State: AOAM531Vkc7lidsTstIHo/HMzpnlCgYfn6jx375ZSrRHm4JOv+BZE9n/
        cOk8EMLSjbRAxbN76soGmJRhOBbenEEIPUfZXKLJsj+e
X-Google-Smtp-Source: ABdhPJx60b/vzEX6+7qse5r7AlWXBHIgX0VwThCE/ZytKcDujWYDyIaGceptSVS3V02G/hjJWEIsMN0y3nVoxrbSWnE=
X-Received: by 2002:a67:cc2:: with SMTP id 185mr14575163vsm.42.1605063102199;
 Tue, 10 Nov 2020 18:51:42 -0800 (PST)
MIME-Version: 1.0
References: <20201109203828.5115-1-TheSven73@gmail.com> <20201110175509.11a6d549@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110175509.11a6d549@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Tue, 10 Nov 2020 21:51:31 -0500
Message-ID: <CAGngYiUTAWj2pfCqKyvnEDacdz=oR5FfunpJZgxbn=1F3yaMwg@mail.gmail.com>
Subject: Re: [PATCH net v1] lan743x: fix "BUG: invalid wait context" when
 setting rx mode
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 8:55 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Please remember about fixes tags

Will do in the future- I posted this patch before we had this
conversation about the need for Fixes tags in net.

>
> Applied, thanks!

Thank you !
