Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A675DE217
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 04:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfJUC1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 22:27:01 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35387 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbfJUC1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 22:27:00 -0400
Received: by mail-qk1-f195.google.com with SMTP id w2so11104358qkf.2
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 19:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jrxW9Qmajz62yvUJquj+KTYfgTaCJqtVwxFo17SjfJg=;
        b=GdHGOI6FA40Cf/+MypBS3AhVeJaxk7piMbLSXh4snwlYbYQSyU4qdtsk5NWw4Is4MW
         8CEOyhdLdJn1MUYeul4rYdmLKibTOfIZF5eVj45+tBaOQoJ7gKr+9twnE9J0ZylXTLKW
         Oek1sYfiGGf7cKBCKkYsQ2l/1rEJ44mUZi3A8zstu2qW+bf0vpRv5d1byuJG5tPFOJ/F
         PKn/EcFXsFyaUeBczL3W71GZZXnSW+QtvjGYzRHTnWKAhrm6W7y7GAfyhmz5IXICxg6v
         NTy1rCcmjFtdsqV+iqw2s2ysWcElHOwdIOOG2lWrbNPvH8xBNneEGZO5MuurM78HUbOH
         +EwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jrxW9Qmajz62yvUJquj+KTYfgTaCJqtVwxFo17SjfJg=;
        b=e7PMSJqxY0L/EjptjV8yh2HXs/pUTFNx5RTLBSge5JLVh1O091odQP85H+1Z1Sedj2
         sb9Ceh0vhd1xjm4yO8gimsrj5mdmWT66tZSJicwR8QwL2HoFNY9N8Px9wAm6NoyuC/p0
         vZbijTlHetgQ07j8ehGp53HM8ITaQgtGFOOYrhSMz1VQmseAuBbIsMSDXV9pUBfCxCvV
         VrmLyHkjBucbzCrx+/s6HhyznsaHI7mvlpj6Cfg5P5lxM4jn8e2S5BqGvfQ5nenhTjb5
         Bsp8JzNoL3i+S/iAZd2zkevGibRZhKVEhD9JCLu+U7A2NOcKh0+ekbnNkqUQRdcjG0r+
         tNPA==
X-Gm-Message-State: APjAAAWLO7yOcvero+83psFVeo0saVLohduQ3ZDKnOxDuMt7R9bswqZB
        f1rlPo6AhzI7SA3f/BrGf24izLTwbIxJV311c7U8OQ==
X-Google-Smtp-Source: APXvYqzLwdW3DA3VpPfKWk5UBNKvFyqUgyR2WjiFtRKl7134YMV086Yowi5kRvOGGSPHNujQzRONodo0XwsojYlg7G8=
X-Received: by 2002:a37:5f46:: with SMTP id t67mr19441250qkb.220.1571624819419;
 Sun, 20 Oct 2019 19:26:59 -0700 (PDT)
MIME-Version: 1.0
References: <20191016015408.11091-1-chiu@endlessm.com> <CAB4CAwen5y7Z4GU7YgpVafyGexxaMDLzrZ949t9p+LiZ9TxAPA@mail.gmail.com>
In-Reply-To: <CAB4CAwen5y7Z4GU7YgpVafyGexxaMDLzrZ949t9p+LiZ9TxAPA@mail.gmail.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Mon, 21 Oct 2019 10:26:48 +0800
Message-ID: <CAB4CAwcW5JGtZQy+=vugx5rRYMycWoCSSdDc6nwhunqTtqoQaA@mail.gmail.com>
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

On Thu, Oct 17, 2019 at 10:26 AM Chris Chiu <chiu@endlessm.com> wrote:
>
> On Wed, Oct 16, 2019 at 9:54 AM Chris Chiu <chiu@endlessm.com> wrote:
> >
> > The RTL8723BU has problems connecting to AP after each warm reboot.
> > Sometimes it returns no scan result, and in most cases, it fails
> > the authentication for unknown reason. However, it works totally
> > fine after cold reboot.
> >
> > Compare the value of register SYS_CR and SYS_CLK_MAC_CLK_ENABLE
> > for cold reboot and warm reboot, the registers imply that the MAC
> > is already powered and thus some procedures are skipped during
> > driver initialization. Double checked the vendor driver, it reads
> > the SYS_CR and SYS_CLK_MAC_CLK_ENABLE also but doesn't skip any
> > during initialization based on them. This commit only tells the
> > RTL8723BU to do full initialization without checking MAC status.
> >
> > Signed-off-by: Chris Chiu <chiu@endlessm.com>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@gmail.com>
>
> Sorry, I forgot to add Jes.
>
> Chris
> > ---
> >
> > Note:
> >   v2: fix typo of commit message
> >
> >

Gentle ping. Cheers.

Chris
