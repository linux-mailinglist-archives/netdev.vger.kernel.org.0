Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279D231E332
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 00:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbhBQXpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 18:45:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbhBQXpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 18:45:44 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2E9C061574
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 15:44:58 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id g5so288426ejt.2
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 15:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XeJjr58sJrhlQB+LAdjqmsQ3TZhuSViHAJlIArhIHCQ=;
        b=hUDCKelGSpQJXdly8lUubq8TD5KjwPT9sx404Dd6O4v2tEqx+IHABnJnsB8d6+fcwY
         D6N/9+/Bx9tk/At2SMYiuCUY4q7uwzy8vXaxE9RwYi9hd1Q3if17L3NkE+8JBdLFASxQ
         2s5UhUMAcR65sRnsWqM28m3wDIRZFimrwn1Z6b+1zRdAYZtzYvnZC36DACA+2mZ+2ePe
         B7uRwpkFQ50GnOA/zpRmeRXEmMIKzp4UB+KXDE+7cKB1AfAVm0tPUt3d4lZphEz0YwCD
         ySX4qjE/KtWiQ7Fo8T02BeDXoN3QxkxdPxrME36oEB4pdhlyj76sLUkpAGpts9VLvyRK
         hCyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XeJjr58sJrhlQB+LAdjqmsQ3TZhuSViHAJlIArhIHCQ=;
        b=fc3BV/om8InZv/jxub2LyPqzpTQA+YV2y9t23veTP8JrBmFG4TvHR7QRLphls/VfVd
         LqvrYAqeVgBOQwF0kNiaPAWef9Wbe0vR16XkOB0qxyiM2TbLd9XRHkrMXbevP7rNQ/IE
         ZD+DVfNkqwY/1blPkMSEyuStKipsYeiWIChnzholh76Zlbs5TA5a6yXt1myUDOGbru/U
         Xz0L/e4AkKf/tZtrCXxnaVi4c+5jCBbittSvVUWIDguczCJWQwpZNxRF6cmH//JL2pVz
         Ctntfrm5JQFeUdfjB1uogb45DDBPSWaKoEHVi8cnQgIO41YBPwqs9XTyqV03gk5I/r/A
         cqcQ==
X-Gm-Message-State: AOAM530CaLkNR1mP4W9s/sgQkaTTmpySXI63WBXaDSgdWtzMCKwm9NPG
        Q3op+f3lDvOYqpVwBYNkXZ+3wuogD2yk7lkC6pfl38c86UI=
X-Google-Smtp-Source: ABdhPJzn3fD6w2Pyjj3qwn8fLbiIIVQBBK95eHAlD19mGHW88Ntg/qN9mQP60DKbBQBt7B7mNTlV/o+VofRwszqIFmQ=
X-Received: by 2002:a17:906:54c7:: with SMTP id c7mr1275718ejp.161.1613605497733;
 Wed, 17 Feb 2021 15:44:57 -0800 (PST)
MIME-Version: 1.0
References: <20201216225648.48037-1-v@nametag.social> <5869aae1-400c-94a4-523e-e015f386f986@kernel.dk>
 <CAM1kxwiwCsMig+1AJQv0nTDOKjjfBS5eW5rK9xUGmVCWdbQu3A@mail.gmail.com> <2b120310-4c7f-3e60-e333-8236d72faf8d@kernel.dk>
In-Reply-To: <2b120310-4c7f-3e60-e333-8236d72faf8d@kernel.dk>
From:   Victor Stewart <v@nametag.social>
Date:   Wed, 17 Feb 2021 18:44:46 -0500
Message-ID: <CAM1kxwh20aoMC9eWbU-qBJy3fM9omFwqviYhWq=rnGgABP0EHA@mail.gmail.com>
Subject: Re: [PATCH net-next v5] udp:allow UDP cmsghdrs through io_uring
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 1:45 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 12/17/20 11:30 AM, Victor Stewart wrote:
> > might this still make it into 5.11?
>
> Doesn't meet the criteria to go in at this point. I sometimes
> make exceptions, but generally speaking, something going into
> 5.11 should have been completed at least a week ago.
>
> So I'd feel more comfortable pushing this to 5.12.

ping. are we still looking at 5.12 for this?

>
> --
> Jens Axboe
>
