Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 909FE17A002
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 07:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgCEGdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 01:33:08 -0500
Received: from mail-ua1-f65.google.com ([209.85.222.65]:36060 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgCEGdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 01:33:08 -0500
Received: by mail-ua1-f65.google.com with SMTP id 8so827182uar.3
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 22:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ww7r8xyl5AstK3HJYP7D2+NA05/L7M6Ex4cvs85NXOs=;
        b=Lzj9TC4v6SxT9dxz9rVrEA1xAZu+KYjBzF47S0XkuuJK1K3i9ghUgFJsEEAA69BJ44
         UN9uGj04+S7/yrYwy9nnbWQWucoCbbyDxsuZtU4KJGIsCje1pxi4HR3NfLHW17dpzTR7
         XXV8CbypUehC7LCkbl+umeUtpWr1ndKKKgoBgKIsMZzSF14HJKNChz9aOtShIQISftMj
         WgQXzYEPh9Syu+IiDYuCOya2IgvVPQD3k4RNvHDtwXJm8/dXBKo8InjoJO2ieHINs1nN
         ceBbH2ev/Q81Sc46ddYQWUqpIXRK98e9xPek2Ca2rt7Cc+JPoMgIyyiz4keekhgAVKRd
         dMrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ww7r8xyl5AstK3HJYP7D2+NA05/L7M6Ex4cvs85NXOs=;
        b=mmhXPOBIhaEkwRpqfEAOry69rl0+EsSPWhs6eJKQmp7gO+9aqFjzRft8b+flvPAVJn
         2nnEICcAplSGd5zfEZxwy+ndK5hM6oNcf1BD7wsgtK3sdYTPq6vq5+xEvpY4wUUfpG2+
         RPO5qcbPhY7IHyeEPl35l9dbCepxQoFKcU/Qsx/ugoZCZO3UB0DwmMUZGyJMp7Evgvpz
         Xw+b/nGShmA/DEKgKCOAlWw9Iwm5IqxS5t6pEJFdxS8dehQvSMIlVOedN0SbJbHJENTg
         kCuOfAtiMBxdQYZA6uNTy0skZwDZ2VFmltdsMFplxcKXEfyO+fShYwZSIeZuZsSlXROF
         eTQA==
X-Gm-Message-State: ANhLgQ3KWs4+Ju2WX8ktESnfz/m2GHHWFIvswuQQ8NV9uRjMZFLJSPrX
        neWMuR8oueD6ov6j38G0WchNGoW5MrxSAfVsEXU=
X-Google-Smtp-Source: ADFU+vvWKnplrgnS3ALZ041EaBOKZafTuBgGQQTwp46cdSl5R53VoUnUvz3ccpxzy7oA6hemN+L47KwoPGeBPBnz6GY=
X-Received: by 2002:ab0:488b:: with SMTP id x11mr3811881uac.86.1583389986784;
 Wed, 04 Mar 2020 22:33:06 -0800 (PST)
MIME-Version: 1.0
References: <20200228.120150.302053489768447737.davem@davemloft.net>
 <1583131910-29260-1-git-send-email-kyk.segfault@gmail.com>
 <CABGOaVRdsw=4nqBMR0h8JPEiunOEpHR+02H=HRbgt_TxhVviiA@mail.gmail.com>
 <945f6cafc86b4f1bb18fa40e60d5c113@AcuMS.aculab.com> <CABGOaVQMq-AxwQOJ5DdDY6yLBOXqBg6G7qC_MdOYj_z4y-QQiw@mail.gmail.com>
 <de1012794ec54314b6fe790c01dee60b@AcuMS.aculab.com>
In-Reply-To: <de1012794ec54314b6fe790c01dee60b@AcuMS.aculab.com>
From:   Yadu Kishore <kyk.segfault@gmail.com>
Date:   Thu, 5 Mar 2020 12:02:55 +0530
Message-ID: <CABGOaVSddVL-T-Sz_GPuRoZbKM_HsZND84rJUm2G9RRw6cUwCQ@mail.gmail.com>
Subject: Re: [PATCH v2] net: Make skb_segment not to compute checksum if
 network controller supports checksumming
To:     David Laight <David.Laight@aculab.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Though there is scope to optimise the checksum code (from C to asm) for such
architectures, it is not the intent of this patchset.
The intent here is only to enable offloading checksum during GSO.

The perf data I presented shows that ~7.4% of the CPU is spent doing checksum
in the GSO path for architectures where the checksum code is not implemented in
assembly (arm64).
If the network controller hardware supports checksumming, then I feel
that it is worthwhile to offload this even during GSO for such architectures
and save the 7.25% of the host cpu cycles.

Thanks,
Yadu Kishore
