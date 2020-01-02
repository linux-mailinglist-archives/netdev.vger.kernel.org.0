Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67F7912EB99
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 22:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgABV6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 16:58:07 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36820 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbgABV6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 16:58:07 -0500
Received: by mail-lf1-f67.google.com with SMTP id n12so30759736lfe.3;
        Thu, 02 Jan 2020 13:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=35q6Jfi2CC23jXWt4F+Y2RbWyKxhwN9lDjJC7r78ZIs=;
        b=vMMuuA9l9972ihHdc7hjdkhsUVFWoxUnVs30y5dRjb3CjWQx9INuW//pxcQsuPE3lK
         Qs5GuIuqd652A0/gkHUbVATgkvp+BBRr99JZEmO00EZzL5OhL8yhYWuRwYnAJ7B1JKsa
         L+JcjINjfBEmT57PMS2GroCkEB98e8ZJW5a3Sj8ySANKrEra0SoIwIlBU1jMMG1/ASQ5
         FulOqXC4EGJf8f7vUmi1EA3uyutDHPMdRRLljmIKD13XEzZmnicUFeo6fsqXIOZUr2pq
         JtQ+EGKef/UYlcc5aSKTtSUtwKgqjtnOR7mNL7uh6TEakjx0EkK5/P9FBdo+353rQVUc
         MOaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=35q6Jfi2CC23jXWt4F+Y2RbWyKxhwN9lDjJC7r78ZIs=;
        b=kCDe4SdOYQc6rtrtIyxa/UtIbyp13NxElF1cwWl58dLCy9D6n1QLSTQCpdBgKy6M/q
         LMIZSfCAhKXvzADUZbKtmSIgx/PR0DAnk1/q/ZbJbXAX7knPR3VW3O80cecQuq9mdyoO
         +h9z4QHtn2NcjKFENZsWvImc05ksHpIJNFrpBiCaRMLhhA4jg5LLlOXnvrLyo7k4WSW4
         Fy4pmwKRiB3tWMLO2DKxSl1IL43pFMk86b/azQyvy7+n2w0WYc+sIRlbSRMNLhjUiovB
         PO/iEdWt4bcke/HbvfNYSsHNFs7L4mja3PQ7H542b3VSukMqsD5bd3tnzhEeWEMlz3Rr
         +abw==
X-Gm-Message-State: APjAAAWt3E26J1ZuiGuBxQdJPFBYP28nGHMEjxD3Ao3owN3HctcbgvPH
        O31NmQTKJ8/HbjqExfZK6cMK0yGlurE=
X-Google-Smtp-Source: APXvYqwNwYpvQH3/oHzSQ5p43kTZlE979UrLxObLsg8UQhaOw2EWVmcuqb7E91wSH4HsXr7hSAKeBQ==
X-Received: by 2002:a19:6a06:: with SMTP id u6mr48503903lfu.187.1578002285376;
        Thu, 02 Jan 2020 13:58:05 -0800 (PST)
Received: from jonathartonsmbp.lan (83-245-229-102-nat-p.elisa-mobile.fi. [83.245.229.102])
        by smtp.gmail.com with ESMTPSA id p12sm23687003lfc.43.2020.01.02.13.58.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Jan 2020 13:58:04 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [Cake] [PATCH] sch_cake: avoid possible divide by zero in
 cake_enqueue()
From:   Jonathan Morton <chromatix99@gmail.com>
In-Reply-To: <20200102092143.8971-1-wenyang@linux.alibaba.com>
Date:   Thu, 2 Jan 2020 23:58:02 +0200
Cc:     =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        cake@lists.bufferbloat.net,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0750BA89-01A1-4126-9BEF-2C6AC607A5BD@gmail.com>
References: <20200102092143.8971-1-wenyang@linux.alibaba.com>
To:     Wen Yang <wenyang@linux.alibaba.com>
X-Mailer: Apple Mail (2.3445.9.1)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 2 Jan, 2020, at 11:21 am, Wen Yang <wenyang@linux.alibaba.com> =
wrote:
>=20
> The variables 'window_interval' is u64 and do_div()
> truncates it to 32 bits, which means it can test
> non-zero and be truncated to zero for division.
> The unit of window_interval is nanoseconds,
> so its lower 32-bit is relatively easy to exceed.
> Fix this issue by using div64_u64() instead.

That might actually explain a few things.  I approve.

Honestly the *correct* fix is for the compiler to implement division in =
a way that doesn't require substituting it with function calls.  As this =
shows, it's error-prone to do this manually.

 - Jonathan Morton=
