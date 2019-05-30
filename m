Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D93B30011
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 18:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727622AbfE3QTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 12:19:01 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40313 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfE3QTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 12:19:01 -0400
Received: by mail-qk1-f195.google.com with SMTP id c70so4207708qkg.7
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 09:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/BOF1PS9ef/1e7lF8f7QGaLzvKEh7xsX3IUCbdi38sI=;
        b=E34x/JZltMmJpxLwbPQ3upRY0aW6h4YRZvuNYNeY24YqQEVr0xGxbd94fNVxyYEkd6
         L1QZc/Kub9/DPa/7/Iw+5FCGQAQPlwMuSybDLCnGJwTZJkXOHuI66sZHlV/4zWgW3IX9
         ER8WHijNf6yvvLP9UaU0MK0/5SpJ1gKgBC1+LPxTH2XTtCsxrCkz4MRu9WUbjT2pSax+
         4i6/QpqUNsQe5JuW4QCAdrAlMoL/yvmUBlbyW+gUnJ/LOZATfYSgvTldftMNsC2y3blY
         kNRWQipzSHFAfUWu918mwJDL6F++OKoJA49EXGi8A/5veoy93/gdfkH5+MaH8ipOcvQL
         2NGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/BOF1PS9ef/1e7lF8f7QGaLzvKEh7xsX3IUCbdi38sI=;
        b=e429pMttwlnLyZQxY1a4c+IqJPF8K+tRiLCPfjX/Y7+Grb+teNgQuSzi05bJ5gKRrW
         LrIVACpPS8a92wLoMHNaXk/cOr02wcwk7E4YgF7vgfQe3wojRXy3HlrURc8vpSEFHKZj
         7Rkmx4m3swMdJTTkOsLEiX5y03MQ8Dg4ftexW13I/ltECBW7QdyVof9a8PQ9AS2VjLxh
         I7KHCIyb0ZLosZ99f/jeCnsxIIP8oLQyK/1ujqPDhC58rMLNe+c+Hlkc0f3g6vaxaxqE
         FFHuiGYs2sWsIM7jjc2NKJo+9jvfxajWXc5RlriLilWEMyJI0uXMjKXI4bp/sNJ/N5hg
         I7cA==
X-Gm-Message-State: APjAAAV0mXuxNqXtFqIdY2HLkjkM1uQz37+8RovonGUxNIEEhAPOmRlC
        +53ccRBkJcPpqqyityiztcXidufpEnR8dq30b9hS3g==
X-Google-Smtp-Source: APXvYqyThEOTsDPymddn81aSSL0LysAZFw4QN4ZJW+unu55HDESyR2d6fYY+dP4ysFM/iFLBd3G9l+xGe+xmzPDyhmM=
X-Received: by 2002:a37:6312:: with SMTP id x18mr4113595qkb.300.1559233140556;
 Thu, 30 May 2019 09:19:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190529050335.72061-1-chiu@endlessm.com> <CAD8Lp46on32VgWtCe7WsGHXp3Jk16qTh6saf0Vj0Y4Ry5z1n7g@mail.gmail.com>
 <CAB4CAwfVDfphWNAN5L1f9BCT9Oo3AQwL19BOUTNJNFM=QR7rjQ@mail.gmail.com>
In-Reply-To: <CAB4CAwfVDfphWNAN5L1f9BCT9Oo3AQwL19BOUTNJNFM=QR7rjQ@mail.gmail.com>
From:   Daniel Drake <drake@endlessm.com>
Date:   Thu, 30 May 2019 10:18:49 -0600
Message-ID: <CAD8Lp465rwNHt0TSmCKfFzpSagbZBd2iBHx5JrLo7Qp8YvTSgw@mail.gmail.com>
Subject: Re: [RFC PATCH v3] rtl8xxxu: Improve TX performance of RTL8723BU on
 rtl8xxxu driver
To:     Chris Chiu <chiu@endlessm.com>
Cc:     Jes Sorensen <jes.sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 10:52 PM Chris Chiu <chiu@endlessm.com> wrote:
> You mean moving the ratr_index to be the 4th function parameter of
> update_rate_mask which has 2 candidates rtl8xxxu_update_rate_mask
> and rtl8xxxu_gen2_update_rate_mask? I was planning to keep the
> rtl8xxxu_update_rate_mask the same because old chips seems don't
> need the rate index when invoking H2C command to change rate mask.
> And rate index is not a common phrase/term for rate adaptive. Theoretically
> we just need packet error rate, sgi and other factors to determine the rate
> mask. This rate index seems to be only specific to newer Realtek drivers
> or firmware for rate adaptive algorithm.  I'd like to keep this for gen2 but
> I admit it's ugly to put it in the priv structure. Any suggestion is
> appreciated.

I think it's cleaner to have it as a function parameter, even if the
old chips don't use it.
The rest of the implementation is in the core, so we aren't exactly
dealing with chip-specific code here, at least the way it's currently
done.
The vendor driver also has it as a function parameter from what I can see.

Daniel
