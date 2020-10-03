Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1E1282204
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 09:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725763AbgJCHad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 03:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCHad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 03:30:33 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDF2C0613D0;
        Sat,  3 Oct 2020 00:30:32 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id s13so3703924wmh.4;
        Sat, 03 Oct 2020 00:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lXGujmAKLyMpD7fQxEFxgzS/OSDXTsLvLAkTOWnjwXo=;
        b=LfiqgBVlHBiT5dt8hMc7fWngd0uMR0kgbNqc7O5HeRfi0jknSmQ0A9fqCxKh6R2Wtj
         kFUMu2RnJ193/18bLsdyrR2qAllV53BP3iVSptM6FHTdsP9nP6A6m+TYr3zTq62gOn4Z
         9jFG+qrq51q2FTum+KAsX/v/kiFbjLSpsuUbkfBHYkrb61FsMgMMX5RF0fmqbiYEgbEx
         mza3QWHFrb4YrD98UF8t1R3Y7UWQhsd0BmS4j2L0vQKuWnLDYwfysL6D98/llsFBFoZM
         ltZv4mTARMyAQ1Mwk511/k32CsNP3Mxk7nDxjZG8AA7mgy6zDwT5mjsttUWDWOjvwYeC
         s4uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lXGujmAKLyMpD7fQxEFxgzS/OSDXTsLvLAkTOWnjwXo=;
        b=duFznQ4AJCO+jbwIAbhR3bg3Q0bV8FEGRW8N3FFIp/5+oYt9PCDtcnJ5RTNI4LP2Y+
         mJpfQ+Hjml/1nqgo3UBn1gmw2y1CwnWUslYB2ANpiPJKIW8pNo1DftcIlwtlXzYU5/3p
         IhdsOodgHrYj9asA6JARWno6wuL43owSeXGHvL3A70rd6xqSLitF4bw7eKxUd1kdtJn+
         3s/lvU1kBEN1zU28Q5dZAELUV0xZUnftpuFYsMQtoZWHL0U2m7SFcMpSuJPqAYKUUtAB
         modTLZFMRJ2U6KjwTTqQ9q3NMLG0lwzoU0q2fKMJCqdHPI309v0kibeWtJ3HwCbq/btf
         D2kg==
X-Gm-Message-State: AOAM531sIAVfWKY7WEzd2rc/XZxiIm8VNiNlVGeDojZat8fR89hVqXtm
        HoYazAC4yW7o2qnfHKXLt2LaAaoRxMmmoulUbynQo1Q5
X-Google-Smtp-Source: ABdhPJykAc/Uay/20Qh9LGOaoCa8SiAmpuQmItGP4iLLO3fD2fUSKkIeeqj221ly0VWwAOBtY1+EFHcDXbCsB5EpVY0=
X-Received: by 2002:a1c:4b04:: with SMTP id y4mr6453353wma.111.1601710231639;
 Sat, 03 Oct 2020 00:30:31 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1601387231.git.lucien.xin@gmail.com> <3716fc0699dc1d5557574b5227524e80b7fd76b8.1601387231.git.lucien.xin@gmail.com>
 <20201003040915.GH70998@localhost.localdomain>
In-Reply-To: <20201003040915.GH70998@localhost.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 3 Oct 2020 15:45:57 +0800
Message-ID: <CADvbK_cV-yBX-NpPPQxTY+J8OFhv7DvH-UkeprAgtHW+mB0rqg@mail.gmail.com>
Subject: Re: [PATCH net-next 12/15] sctp: call sk_setup_caps in
 sctp_packet_transmit instead
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 3, 2020 at 12:09 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Tue, Sep 29, 2020 at 09:49:04PM +0800, Xin Long wrote:
> > sk_setup_caps() was originally called in Commit 90017accff61 ("sctp:
> > Add GSO support"), as:
> >
> >   "We have to refresh this in case we are xmiting to more than one
> >    transport at a time"
> >
> > This actually happens in the loop of sctp_outq_flush_transports(),
> > and it shouldn't be gso related, so move it out of gso part and
>
> To be more precise, "shouldn't be tied to gso"
right.

>
> > before sctp_packet_pack().
