Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A0C2F6D59
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 22:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729984AbhANViX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 16:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbhANViR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 16:38:17 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC81C061575
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 13:37:36 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id e7so8136854ljg.10
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 13:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1DPKrR/GXMZaqhSQSj3/DyujMQIDa+CTPA7V3yQWR0s=;
        b=gkrpBnHRYvioEZZaxpsKWlQ8fdN1oyyP5iwQ03kPk9IyMVAtQ+Cqf/UoGz76OCEaU6
         baj0lo/iBJVj8+SgxvkUI02Q9wTB6+SZt/TD8XjMbPyvEOEeDgFOV66vqKGPdUAG3aKW
         KkzkGv69tCMPo7VMSnpsDBBymGDnt8kwOZF00=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1DPKrR/GXMZaqhSQSj3/DyujMQIDa+CTPA7V3yQWR0s=;
        b=IrCM6fGPaPaKdH0j/ABFWLAu1Mdj9Dt1yLUekqkHpND3/9UBkFtoCDQETQaEym6RIi
         3BH8CCUi+48hI8EdVpKpADdZp1ixLndOGH2BUGnBc1RxNjZYPWtVPHUXWhYrfTLAifQ/
         6jR/Gl2Q6W75FnPtKJDS9PFRpCJVYchYj7g5lmcWJYLykTjZr7tXRBC/BZAaOSssvwBA
         ZwOnZocJn8Zni1cKT2I43VA0AcQWfyTwFzvBFsjhYRPcz5hSbk1fMjlp8xnB4hAKIP5M
         kXJxhHZ/xry3yV3S2/x9H/l3NXXZ0Bbfy5wZSODpn7y20e1Gcv+Q76RWCxqHVOG09B3/
         yL4g==
X-Gm-Message-State: AOAM533y5Ox5sS0JUV+8S87Pl/TBxooBGx2WgL2Hu+Ic+gXOG1B+DPuj
        DZsiC/IJhC5xag71k2SqldTBIX39lk5MPg==
X-Google-Smtp-Source: ABdhPJx0evDvPMmsYjDLqDp2StCC3N5Ui1BaiSY8ELjmZnJkJUnx5msxL0UXh3GUPsFVzvhHyogk3Q==
X-Received: by 2002:a2e:9907:: with SMTP id v7mr3769999lji.498.1610660254926;
        Thu, 14 Jan 2021 13:37:34 -0800 (PST)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id w24sm665005lfl.199.2021.01.14.13.37.33
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 13:37:34 -0800 (PST)
Received: by mail-lj1-f172.google.com with SMTP id b10so8140107ljp.6
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 13:37:33 -0800 (PST)
X-Received: by 2002:a2e:9ad7:: with SMTP id p23mr3930824ljj.465.1610660253546;
 Thu, 14 Jan 2021 13:37:33 -0800 (PST)
MIME-Version: 1.0
References: <20210114200551.208209-1-kuba@kernel.org>
In-Reply-To: <20210114200551.208209-1-kuba@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 14 Jan 2021 13:37:17 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjWP_7VU8Pi6A-88-1X7F_fs+2qoGf6qjkVOUnFQd3CDw@mail.gmail.com>
Message-ID: <CAHk-=wjWP_7VU8Pi6A-88-1X7F_fs+2qoGf6qjkVOUnFQd3CDw@mail.gmail.com>
Subject: Re: [GIT PULL] Networking for 5.11-rc4
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 12:05 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Current release - regressions:
>  ...
> Current release - always broken:

So I understand what you mean, but it does sound odd with that
"Current release - always broken" thing not being a regression. The
"always broken" makes it sound like it's some old broken code that has
never worked, which it clearly isn't.

Maybe rephrase it as "new code bugs" or something? You've done that
before ("bugs in new features").

I left it alone in the merge message, since we've had that pattern of
speech before, but for some reason I reacted to it this time.

          Linus
