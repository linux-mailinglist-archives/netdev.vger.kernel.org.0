Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41CF0DA3AE
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 04:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406670AbfJQC0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 22:26:32 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44301 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404287AbfJQC0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 22:26:31 -0400
Received: by mail-qt1-f195.google.com with SMTP id u40so1264905qth.11
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 19:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QYYIz0DpXt+S96zKsPkYJbopZGRxz9flW9WuWLOogaQ=;
        b=DPl0z3hlFDrtFfUjhG/QNSp37MnO5lnNjz+RDVaYKEe9dx44OSQaiUs6jPgU1mlu+d
         GQCin+43NLsVlgi9RzYf+tI/v8b9tJjEPefiv3E2pYhpEp/PDLCDXOXBc48gTlgbGATs
         0ZDFck9LGWXjDpiuxxN/KMfjk2ALdUgI6P2xLFRdBBCRKSkvrBWX7rxWV4d6qXRxf9Un
         z2b5jV5twiUT24rOl6BJCgI1A0bAXsL8BSPuzwFH2MSOD2QVZaGw6E8KNPIHMd+IFlV4
         mJ+1OEqgH/WqxY7vxSTcY4bGsgAVXkaOtc/BstJ24QyN0sm7QAWaa926M5fJWb3OLiC5
         Dd4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QYYIz0DpXt+S96zKsPkYJbopZGRxz9flW9WuWLOogaQ=;
        b=N1Um+uk7I5TY7vkp3ffXsw2snuJFzEN8QpOYtHV3XQFhGIBqn7VKpjaNFY99fVQDea
         yPXBALKW3E/fRIvOuL5PB9QWpJNEz//UvUJCtB3vxjs75AqvZ84SfgJBkE2cpRbsXVXR
         xznp2u3Pc5rXWfP/XipoStB9Fl0qOMspMK+wGW9btPFZmnw7QBJdJVw1SUHsx03N1c7H
         imycSa4Y+uIBzRja8r7xnZ7PzeqniRKKTkdqEAYC1rsq5M3P4xtqGz7TS4KOPBCNHnAL
         BAkr8e9wBYnS1FGpkQ/q5T+r9oyF2vKUew5pO8T4CM6i2j7zPIx0ICwAUPqoFGkAmgwx
         eZLQ==
X-Gm-Message-State: APjAAAWdeh2iFlqTO9C0RdPUZwmnQkHR8S71gAb5nQ91RZvDSUIbJq56
        mCZkwEBMR/LzXLLHo4PHjwl9Qg/5yhR5xtlQFl22zA==
X-Google-Smtp-Source: APXvYqyQj2ZLctUSSL3V9JNUsWb05JdfRipaPfh6FHbT8hGhFaGCyPxwpFtBc+PUDLv4I6g5Tcjv2ImmCdkpX+suV3c=
X-Received: by 2002:a0c:c792:: with SMTP id k18mr1397138qvj.154.1571279189073;
 Wed, 16 Oct 2019 19:26:29 -0700 (PDT)
MIME-Version: 1.0
References: <20191016015408.11091-1-chiu@endlessm.com>
In-Reply-To: <20191016015408.11091-1-chiu@endlessm.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Thu, 17 Oct 2019 10:26:18 +0800
Message-ID: <CAB4CAwen5y7Z4GU7YgpVafyGexxaMDLzrZ949t9p+LiZ9TxAPA@mail.gmail.com>
Subject: Re: [PATCH v2] rtl8xxxu: fix RTL8723BU connection failure issue after
 warm reboot
To:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 9:54 AM Chris Chiu <chiu@endlessm.com> wrote:
>
> The RTL8723BU has problems connecting to AP after each warm reboot.
> Sometimes it returns no scan result, and in most cases, it fails
> the authentication for unknown reason. However, it works totally
> fine after cold reboot.
>
> Compare the value of register SYS_CR and SYS_CLK_MAC_CLK_ENABLE
> for cold reboot and warm reboot, the registers imply that the MAC
> is already powered and thus some procedures are skipped during
> driver initialization. Double checked the vendor driver, it reads
> the SYS_CR and SYS_CLK_MAC_CLK_ENABLE also but doesn't skip any
> during initialization based on them. This commit only tells the
> RTL8723BU to do full initialization without checking MAC status.
>
> Signed-off-by: Chris Chiu <chiu@endlessm.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@gmail.com>

Sorry, I forgot to add Jes.

Chris
> ---
>
> Note:
>   v2: fix typo of commit message
>
>
