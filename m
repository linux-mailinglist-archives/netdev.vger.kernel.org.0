Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63B2817C2B7
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 17:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgCFQQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 11:16:51 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37678 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgCFQQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 11:16:51 -0500
Received: by mail-ed1-f66.google.com with SMTP id m9so3161639edl.4
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 08:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Dap1kc1qiXmbZugAe2o1JqyM0eTLYcQXaxHWvf2Qr8=;
        b=crvnJ2PSX5ggVaj+80DEgKsvarhTWwcMoI+N7ZC5iu8gm2lV6mIINrQdAKkUSe645q
         1A2xLnhM0rYLSZRRM2vByGfv63PoXMgHNYyhTgF1jbk+RuOJrth+rt/+v80+RSjGfyHO
         DD8cIT6XcoScNsZQmP5AQQsacUKtJx2aYvwgTjvLgbnNtvn7QwUKRN/dwaINYiGV+9Kk
         J1fpu+16yIcHcAQZ7OcqxYX/kloQGwVenvXWj4yUBgm3MgW8xHCS6C6vZjNi0OKMpxvM
         QWkLvsNLaC1rvdhDH8ZUF17KFvM8zrIKBG/2is6vx7BkNW0RgcJz/j/HUk51elSuHYUQ
         BF6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Dap1kc1qiXmbZugAe2o1JqyM0eTLYcQXaxHWvf2Qr8=;
        b=GfLtYWChsHMz8u3rc//L/pFuokh0ULPpbm9H7YhbRzZ7YlpBN9EwduSad9rf0CGZ7F
         cLYnfwNtgFkoTZAJcBeU/jg5qZC4NUI0gQG1513QfleozFcvfRm5za+rXBdRJyKguupb
         /HKTOSET6SMUhNbZa6Hnwtj2EvD8+f2BbpR80yuv4QbO6epmKleieXbgoMiPmJ5cobKK
         IncimZHsGz3rxgHCLtgFNUo9jYzsw35EqaAedcJ2OG+jGxuXhB9vMCecUu1H4ssp9Uls
         9YDgqD5TN1ApbaKURjvZQ6ygBDaCBagU2E+qrsEI95Fu/x4QZ7/ycxRw66+c0Ius9Zj3
         gw9w==
X-Gm-Message-State: ANhLgQ2ujfTmQfXyPnu1Z5z3JmRK35tPEr2GEOj2DeW9DH9yJhsN+Fvn
        wijhU+6SrBad5UZrd3fJccK25U0JnsEw4xDKBlVGow==
X-Google-Smtp-Source: ADFU+vtEBorqMGpAvx/lz0TjI8aL/1bRpAFzeQnJglZFtVSKM2Ic7kyQA+cbQPzHfBniT9bOq7NfEsXupa/zAnOu+Bg=
X-Received: by 2002:a17:906:15c2:: with SMTP id l2mr3568358ejd.302.1583511409398;
 Fri, 06 Mar 2020 08:16:49 -0800 (PST)
MIME-Version: 1.0
References: <158323601793.2048441.8715862429080864020.stgit@firesoul>
 <20200303184350.66uzruobalf3y76f@ast-mbp> <5e62750bd8c9f_17502acca07205b42a@john-XPS-13-9370.notmuch>
In-Reply-To: <5e62750bd8c9f_17502acca07205b42a@john-XPS-13-9370.notmuch>
From:   Luigi Rizzo <lrizzo@google.com>
Date:   Fri, 6 Mar 2020 17:16:38 +0100
Message-ID: <CAMOZA0LzKZczQBcGFO8q44QJ1=6rv-61nruqxRK4k05-gFWaGw@mail.gmail.com>
Subject: Re: [bpf-next PATCH] xdp: accept that XDP headroom isn't always equal XDP_PACKET_HEADROOM
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf@vger.kernel.org, gamemann@gflclan.com,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 6, 2020 at 5:06 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Alexei Starovoitov wrote:
> > On Tue, Mar 03, 2020 at 12:46:58PM +0100, Jesper Dangaard Brouer wrote:
...
> > > Tested on ixgbe with xdp_rxq_info --skb-mode and --action XDP_DROP:
> > > - Before: 4,816,430 pps
> > > - After : 7,749,678 pps
> > > (Note that ixgbe in native mode XDP_DROP 14,704,539 pps)
> > >
>
> But why do we care about generic-XDP performance? Seems users should
> just use XDP proper on ixgbe and i40e its supported.

I think the point was to show the performance benefit of skipping the
normalization (admittedly for a specific workload, tinygrams;
my other patch to control xdpgeneric_linearize covered a different range
of packet sizes).

On a side note I think it would be more useful to report times in ns/pkt,
as they can be applied to other drivers too. Specifically here I would
have written:

  Before: average 207 ns/pkt (1s / 4.816 Mpps)
  After:  average 129 ns/pkt (1s / 7.750 Mpps)

cheers
luigi
