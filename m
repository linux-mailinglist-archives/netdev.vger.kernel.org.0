Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A385A816
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 04:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfF2CDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 22:03:04 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:39818 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbfF2CDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 22:03:04 -0400
Received: by mail-pf1-f181.google.com with SMTP id j2so3839177pfe.6
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 19:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=PxNura2FtwVYOyi81GbViu2+hM88Pn+e9x0rTuDTcoQ=;
        b=Bkw8E8uPLA9IENhj0LHLfwCv6/akD+dFdPBMlt6PSHTSEtAaUiCESMuCkaQPmwYlr8
         lcz3ffzW0bLvjRMVdmokrkJgUgUAPNzyWWHyJ+sVfS0n+61kHGaIufPvdEo2ISwHQLOm
         9rFcypdFd1rCxsXuuwaEcrzwjE7Fz2AsD6GXQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=PxNura2FtwVYOyi81GbViu2+hM88Pn+e9x0rTuDTcoQ=;
        b=ZhIg66EHQ+YO8SdSbQTnau6Lc77yVuLNb5spQ2tv1FzUoDcJ00BbRjdiEU09S94oN+
         I8emRJNHNyTnKsnQCaosjdmL/Yupo8m6qaaUwq9dhTATRpZdZKOj33FsRHQM611l37oD
         YUiMF79nTCOAhpYi3q9lLUQtca9Q5u0QMd8oz5l8+mDsL2KafFBPRcYnKtiKmXR72nol
         UTf3nGxlkvPVCr4ne1YKAcD2ZUpMBF1a5ai66KSfmpUQn+fMmL0JW55AnQBXFKiRukK5
         G1OswDaCf3zHUWHXwOrhdVIAh9Am/z1xwsMN4y1R8io9y9DMBNbmsPHEmtqjKY6cPjDp
         nxNw==
X-Gm-Message-State: APjAAAWvq47mOKzY6Jmq8iunCEmS5TOdlD8dggjRqc2vwom2D/b0KHMS
        y8JoAkzpfS95u8Lgn7W8+oG9
X-Google-Smtp-Source: APXvYqyQZ91FJGl69eFa+kT8wyj4k2TSKOyHgkNb6ATuR5CO9tDeyA7QfWt7PQQx++WbS2IOKPHKQw==
X-Received: by 2002:a63:e53:: with SMTP id 19mr12025624pgo.137.1561773783541;
        Fri, 28 Jun 2019 19:03:03 -0700 (PDT)
Received: from [192.168.1.144] (64-46-6-129.dyn.novuscom.net. [64.46.6.129])
        by smtp.gmail.com with ESMTPSA id v3sm3399769pfm.188.2019.06.28.19.03.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 19:03:02 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: net: check before dereferencing netdev_ops during busy poll
From:   Josh Elsasser <jelsasser@appneta.com>
In-Reply-To: <20190628225533.GJ11506@sasha-vm>
Date:   Fri, 28 Jun 2019 19:03:01 -0700
Cc:     Matteo Croce <mcroce@redhat.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Transfer-Encoding: 7bit
Message-Id: <1560226F-F2C0-440D-9C58-D664DE3C7322@appneta.com>
References: <CAGnkfhxxw9keiNj_Qm=2GBYpY38HAq28cOROMRqXfbqq8wNbWQ@mail.gmail.com>
 <20190628225533.GJ11506@sasha-vm>
To:     Sasha Levin <sashal@kernel.org>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Jun 28, 2019, at 3:55 PM, Sasha Levin <sashal@kernel.org> wrote:

> What's the upstream commit id?

The commit wasn't needed upstream, as I only sent the original patch after
79e7fff47b7b ("net: remove support for per driver ndo_busy_poll()") had
made the fix unnecessary in Linus' tree.

May've gotten lost in the shuffle due to my poor Fixes tags. The patch in
question applied only on top of the 4.9 stable release at the time, but the
actual NPE had been around in some form since 3.11 / 0602129286705 ("net: add
low latency socket poll").

	Josh
