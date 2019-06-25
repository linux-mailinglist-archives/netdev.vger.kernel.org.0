Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E39558B7
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfFYU0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:26:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55375 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfFYU0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:26:21 -0400
Received: from mail-yw1-f70.google.com ([209.85.161.70])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <guilherme.piccoli@canonical.com>)
        id 1hfs1C-0005KQ-Dw
        for netdev@vger.kernel.org; Tue, 25 Jun 2019 20:26:18 +0000
Received: by mail-yw1-f70.google.com with SMTP id b63so2988ywc.12
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 13:26:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5M39uvN+bkXJ3S1C3mg82ySeIPT7e1+AOU2LvkTvZ2g=;
        b=YYtizZ6QUGznNalBpKOhsPh5CQy5uByeHLLkSxNiuLyqt9pxpNS6ofBrQ2VSS1eALz
         pVEZ5dru2Oo+H7Jm3sL9YL6XyOC9FaN5nGksMth6fL1kAiQ+JZiBB+th0n+lXQtvk5vf
         z1OWplOLn6OWyERvwqPzJSuQOM/+Zk8lk2oXTtGzOrFgJn/M4jVoPs8DxGBeJPy9Z1Ev
         1IcgItg81tP9EdU8hKkc56O6mz10KHYdUnGwEzah83BOHmO9ah6hqXA265X8xDKEkm2F
         P/aYCt64xM0Fd+Jmbu64MMo+UW5Sjlm88H3LdrKE+9dV7odt8+QqtZs6SA4QSolytUxh
         EdVg==
X-Gm-Message-State: APjAAAW6YfLOYZpZpWD5eKgROspUW8PoSVtuoHwKxKOGD8mSJm7SyO5O
        Y5+I92lIuxbYNEBjthvjmgp3Sb2b9AnS00Y2FhLcCTgNu9JyVyHMyoF5EGlMzbUd8L2agWDWRA1
        k94OtUGt5WtxECtDjbEm5MwuoKsFL29iNTfQ2ggZ59b4VXoV2Fw==
X-Received: by 2002:a25:dbc3:: with SMTP id g186mr220105ybf.477.1561494377584;
        Tue, 25 Jun 2019 13:26:17 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyes5HusiuuGtopXE1D6uYN1Rq17GYps66V7R+0Uy93R5XUlxQljPHo/BILbjaCwQd3B8quz1xu612Bma1X91s=
X-Received: by 2002:a25:dbc3:: with SMTP id g186mr220089ybf.477.1561494377376;
 Tue, 25 Jun 2019 13:26:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190624222356.17037-1-gpiccoli@canonical.com>
 <MN2PR18MB2528BCB89AC93EB791446BABD3E30@MN2PR18MB2528.namprd18.prod.outlook.com>
 <CAHD1Q_y7v5fVeDRT+KDimQ-RBJMujMCL2DPvdBh==YEJ3+2ZaQ@mail.gmail.com>
In-Reply-To: <CAHD1Q_y7v5fVeDRT+KDimQ-RBJMujMCL2DPvdBh==YEJ3+2ZaQ@mail.gmail.com>
From:   Guilherme Piccoli <gpiccoli@canonical.com>
Date:   Tue, 25 Jun 2019 17:25:41 -0300
Message-ID: <CAHD1Q_y5wWqOkPaC+JsuGMfBHbwPHbQF93Y-+06Nck=HKrif2g@mail.gmail.com>
Subject: Re: [EXT] [PATCH V2] bnx2x: Prevent ptp_task to be rescheduled indefinitely
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "jay.vosburgh@canonical.com" <jay.vosburgh@canonical.com>
Cc:     GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sudarsana, let me ask you something: why does the register is reading
value 0x0 always in the
TX timestamp routine if the RX filter is set to None? This is the main
cause of the thread reschedule
thing.

Of course this thread thing is important to fix, but I was discussing
with my leader here and we
are curious on the reasoning the register is getting 0x0.

Thanks in advance,


Guilherme
