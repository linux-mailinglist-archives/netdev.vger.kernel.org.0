Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF0A17AA2B
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 17:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgCEQHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 11:07:24 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:35710 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgCEQHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 11:07:24 -0500
Received: by mail-yw1-f68.google.com with SMTP id a132so6096055ywb.2
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 08:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RARwB1bFSQWTGdQ4jJkyYRMMXdh+Je2fLK+67Qxwq/k=;
        b=fzXwFYRHnvpkCmhSoYWwE8SkOzdkUYg996ld06CkKHXSBoXFZp2NxKjnt/ECwp2zHg
         bVu6v0Jay3sgQMA1peV0iSdXHVXbhVtkYU7+x5ZEWs/9InGvY+yAgpVqI4BT688Wo7he
         vokQrLW5n+EFcqPdgBI/t59VYuk3kdV5qtw9Al+RB45M2ECzU1AeBWmgFNu/I9ZSPZl6
         95UzoZn4VOMk8jxr5D9r3rBsPUOfU3w8X/Va+NElhWQFXQyD2GORL8RtG2DKTXR30h6n
         mhTWhn05QNBHEJDnEmuUlHdTiyxqjDuok3MSTsFn2c6ai//53Jpt3X5BBtHA/VWoz8HE
         UEPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RARwB1bFSQWTGdQ4jJkyYRMMXdh+Je2fLK+67Qxwq/k=;
        b=MgiUkyzlHN1NyLs3ze9yfsUuOIwt5rib/JOS8/Z2bu7QiU3eTO3R+mC31owFdYRaaf
         c0HQg70vYXOzZbYlunTK31+jORwm4baGmmRqcQAZxcu7o1WUbM5qSYnH/UfdHTP68m1v
         KQpl3OdBaC/Qbvt37zSTmoWLbnxUITgdtCqaDyK5pxsTUvMhHPL7XVatsy1eiPF4+Xax
         XQ4Cxt2PXWQK0oDSqQqL4tM0tjOIWjY6/1MTpu4VeoMifHWDzi+a8EcGo/zxUvf93ih6
         KH/SwWO3YaCTowLhvi1UfcdqjXegDZ/iZAJY9qZ1ZNtm9YiWsbLxr8wD0xISIDq8yfT1
         HAEQ==
X-Gm-Message-State: ANhLgQ1o5dLzpRCbZaACBqkYIp+PhbxxJJcbacgxl73H+aQ6hXOSRv4s
        Vd4gOKdVsitXvNmH9k14uqL8u1HR
X-Google-Smtp-Source: ADFU+vv6iPWh8YYjm5BmnzLcqx871ZUxZZeawz/1ehtFW4k2Eb4d2RwTQCyTU8C3NnedyFqkrAqlVg==
X-Received: by 2002:a25:aaab:: with SMTP id t40mr5899120ybi.453.1583424442109;
        Thu, 05 Mar 2020 08:07:22 -0800 (PST)
Received: from mail-yw1-f43.google.com (mail-yw1-f43.google.com. [209.85.161.43])
        by smtp.gmail.com with ESMTPSA id g190sm11989646ywd.85.2020.03.05.08.07.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 08:07:21 -0800 (PST)
Received: by mail-yw1-f43.google.com with SMTP id p124so2187173ywc.8
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 08:07:20 -0800 (PST)
X-Received: by 2002:a81:f10a:: with SMTP id h10mr8713773ywm.109.1583424440323;
 Thu, 05 Mar 2020 08:07:20 -0800 (PST)
MIME-Version: 1.0
References: <20200228.120150.302053489768447737.davem@davemloft.net>
 <1583131910-29260-1-git-send-email-kyk.segfault@gmail.com>
 <CABGOaVRdsw=4nqBMR0h8JPEiunOEpHR+02H=HRbgt_TxhVviiA@mail.gmail.com>
 <945f6cafc86b4f1bb18fa40e60d5c113@AcuMS.aculab.com> <CABGOaVQMq-AxwQOJ5DdDY6yLBOXqBg6G7qC_MdOYj_z4y-QQiw@mail.gmail.com>
 <de1012794ec54314b6fe790c01dee60b@AcuMS.aculab.com> <CABGOaVSddVL-T-Sz_GPuRoZbKM_HsZND84rJUm2G9RRw6cUwCQ@mail.gmail.com>
In-Reply-To: <CABGOaVSddVL-T-Sz_GPuRoZbKM_HsZND84rJUm2G9RRw6cUwCQ@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 5 Mar 2020 11:06:42 -0500
X-Gmail-Original-Message-ID: <CA+FuTSc5QVF_kv8FNs03obXGbf6axrG5umCipE=LXvqQ_-hDAA@mail.gmail.com>
Message-ID: <CA+FuTSc5QVF_kv8FNs03obXGbf6axrG5umCipE=LXvqQ_-hDAA@mail.gmail.com>
Subject: Re: [PATCH v2] net: Make skb_segment not to compute checksum if
 network controller supports checksumming
To:     Yadu Kishore <kyk.segfault@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 5, 2020 at 1:33 AM Yadu Kishore <kyk.segfault@gmail.com> wrote:
>
> Hi all,
>
> Though there is scope to optimise the checksum code (from C to asm) for such
> architectures, it is not the intent of this patchset.
> The intent here is only to enable offloading checksum during GSO.
>
> The perf data I presented shows that ~7.4% of the CPU is spent doing checksum
> in the GSO path for architectures where the checksum code is not implemented in
> assembly (arm64).
> If the network controller hardware supports checksumming, then I feel
> that it is worthwhile to offload this even during GSO for such architectures
> and save the 7.25% of the host cpu cycles.

Yes, given the discussion I have no objections. The change to
skb_segment in v2 look fine.

Thanks for sharing the in depth analysis, David. I expected that ~300
cycles per memory access would always dwarf the arithmetic cost.
Perhaps back of the envelope would be that 300/64 ~=5 cyc/B, on the
order of the 2 cyc/B and hence the operation is not entirely
insignificant.  Or more likely that memory access cost is simply
markedly lower here if the data is still warm in a cache.

It seems do_csum is called because csum_partial_copy executes the
two operations independently:

__wsum
csum_partial_copy(const void *src, void *dst, int len, __wsum sum)
{
        memcpy(dst, src, len);
        return csum_partial(dst, len, sum);
}
