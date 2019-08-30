Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD41A4082
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 00:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbfH3WYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 18:24:15 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37850 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbfH3WYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 18:24:15 -0400
Received: by mail-qt1-f196.google.com with SMTP id y26so9380367qto.4
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 15:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sRSCPPMhFu8xhsdJKFrECoHzmi9ztCIrphC9/2HwVZ8=;
        b=PaWubyRySgNSW1QGogjxgIThLnLRZWiDrEKltmDO2wpOQgsUTtWFKQOk7KEn+Yake1
         +o1/2Dl3q/b9wiNdWI1acKCXrldsWOOf8abuZR6vDQBHrji2ucdBLW7lJMX/+c/hYRWu
         9PZlwO0nfV9JraexmIhmmbwcaUHvYPG1AQ7p0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sRSCPPMhFu8xhsdJKFrECoHzmi9ztCIrphC9/2HwVZ8=;
        b=Ai4NDHe8XvrLEjNanDHBI8BBqExPB9lMwRyj0tXW0WK6kBTvU1qv2QW3Ye2411mgiZ
         iCLhhnyThmEmRe35LayZP2nWqR19LKEyXr8hNPCTQ483F25x1zmH2J/MyAncgrFY08M8
         h2e9wRsEfGBWtaG+7pZaDNrZ/3urstYKOnA/nH9YIQChQEAahCyjNuvH64D2ROjcB9n9
         KM4ofll8ALKcmeNZd+1jFNwivxjgI2+JwcO2oxMWALbpabk3nqkJ3q5KagaqP7SxgewK
         Ce8vtAmXH0gSOO4IeO9gB6OgjtodlF1FhlQYgvG10Ew0uccNBxts33uOSbc2bHFbiX6L
         2UAg==
X-Gm-Message-State: APjAAAWkvJzVeDyxfnOgSmyJN5QzTHqwOXGRdhdUrxjE36E2iKs+Y9l7
        4OUTZII6cqeB+eRwtlEGbn+OPV0Yt8fq+XeyVqki8w==
X-Google-Smtp-Source: APXvYqx83DuP9I+k/vUWZMwYRPLMlCjGy7ftGAnRh18XXQReOlRgyynbcetBE0UKHJEd2G5klNhZDrG2VdHRuyMNMoI=
X-Received: by 2002:ac8:6688:: with SMTP id d8mr17187086qtp.141.1567203854154;
 Fri, 30 Aug 2019 15:24:14 -0700 (PDT)
MIME-Version: 1.0
References: <CACeCKacOcg01NuCWgf2RRer3bdmW-CH7d90Y+iD2wQh5Ka6Mew@mail.gmail.com>
In-Reply-To: <CACeCKacOcg01NuCWgf2RRer3bdmW-CH7d90Y+iD2wQh5Ka6Mew@mail.gmail.com>
From:   Prashant Malani <pmalani@chromium.org>
Date:   Fri, 30 Aug 2019 15:24:02 -0700
Message-ID: <CACeCKacjCkS5UmzS9irm0JjGmk98uBBBsTLSzrXoDUJ60Be9Vw@mail.gmail.com>
Subject: Re: Proposal: r8152 firmware patching framework
To:     Hayes Wang <hayeswang@realtek.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bambi.yeh@realtek.com, amber.chen@realtek.com, ryankao@realtek.com,
        jackc@realtek.com, albertk@realtek.com, marcochen@google.com
Cc:     nic_swsd <nic_swsd@realtek.com>,
        Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Adding a few more Realtek folks)

Friendly ping. Any thoughts / feedback, Realtek folks (and others) ?

On Thu, Aug 29, 2019 at 11:40 AM Prashant Malani <pmalani@chromium.org> wrote:
>
> Hi,
>
> The r8152 driver source code distributed by Realtek (on
> www.realtek.com) contains firmware patches. This involves binary
> byte-arrays being written byte/word-wise to the hardware memory
> Example: grundler@chromium.org (cc-ed) has an experimental patch which
> includes the firmware patching code which was distributed with the
> Realtek source :
> https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/1417953
>
> It would be nice to have a way to incorporate these firmware fixes
> into the upstream code. Since having indecipherable byte-arrays is not
> possible upstream, I propose the following:
> - We use the assistance of Realtek to come up with a format which the
> firmware patch files can follow (this can be documented in the
> comments).
>        - A real simple format could look like this:
>                +
> <section1><size_in_bytes><address1><data1><address2><data2>...<addressN><dataN><section2>...
>                 + The driver would be able to understand how to parse
> each section (e.g is each data entry a byte or a word?)
>
> - We use request_firmware() to load the firmware, parse it and write
> the data to the relevant registers.
>
> I'm unfamiliar with what the preferred method of firmware patching is,
> so I hope the maintainers can help suggest the best path forward.
>
> As an aside: It would be great if Realtek could publish a list of
> fixes that the firmware patches implement (I think a list on the
> driver download page on the Realtek website would be an excellent
> starting point).
>
> Thanks and Best regards,
>
> -Prashant
