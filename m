Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C543A6669
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233397AbhFNMWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232940AbhFNMWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 08:22:44 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F9BC061574;
        Mon, 14 Jun 2021 05:20:41 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id 5so58677qkc.8;
        Mon, 14 Jun 2021 05:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6+NR/KKSaOj6WVEi9WsTz9NzkFk26S1P3gzSzNQD9Oc=;
        b=tmpfVFoAugwz926HRfi6/VLJP2ONtsTUsebc+DJfzaULfZFWsokwoZ3ZLI8F4BQI5T
         4u7ZgKJN61lBd2hFiyNJmuszLK/lEsQvu5oJsIj9jxkfK1U8sfrzCh5Xe/tq7j+m7OHz
         hw0wiW6fTXMyqQscNhn/f8DUhhL/zc2JhNZgGvOpUXbzza1Yg8+l0iXJA8556aYnq484
         az/Rvs+3CX9zvMvXQeHZvgcrgf9WtHmQzfV2riQ5npONyL4PfR1K5g4EjfYjz7NKU69u
         wMWt+U/iyVUZ1DD2M2IpORgkN76nT1nDzvsmJ0Mc9Rc7aFrAfhgGld0AR/wOLurD7pKM
         V/ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6+NR/KKSaOj6WVEi9WsTz9NzkFk26S1P3gzSzNQD9Oc=;
        b=LsjPaCDlTmXiMwENSLaAn2CZsempFapQBNL+21IVS6dFtHSdzOk8BrPcQJWiBYLyUe
         EI3YwI5Lfb5XQ1ITqanzt9d6jMwib14AQiejA2bZZDoPivL0p1CaHnSmh3WGQKQ//Ixb
         Tm7VTNMJQZxNEWhUbVxF1KRSLPFcveApmJh2eyaIOPOdHSzgDHiOW0Y/8IuZbo+TzQxL
         oDomlINFynR4/SjuVaPPCEQWXMfGJTV6lHWqp3HlWOKlk19Bo/kdzyxqPtNWnPOZp2Y1
         9epN/i8MvNmw3lj6rpZ+QHCqUftbiAVN8ZlAVJYeogjvIE1CBXUZJfW0TJOFOBMfkeZx
         Kopg==
X-Gm-Message-State: AOAM531mZBJXhCPtqaGUQr4ItfA1scM8zZI7YootG+XJpD3TeQZjPw+T
        vqAfWJWu0K/t2irRKPvc9euBBjdUXGtIR91zUw==
X-Google-Smtp-Source: ABdhPJzVaUTVtnHsGE1LcIPHrNrEhwMXwy1xdSIQCfLUCttVnjzDlxMRqvc/becrPDMGFyyS6E3Qa5wGYrTzJiW6dxA=
X-Received: by 2002:a05:620a:1093:: with SMTP id g19mr15925857qkk.254.1623673240782;
 Mon, 14 Jun 2021 05:20:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210609135537.1460244-1-joamaki@gmail.com> <20210609135537.1460244-4-joamaki@gmail.com>
 <20210609220713.GA14929@ranger.igk.intel.com> <CAHn8xcnMX03sX0n5VrTA2kJTSgcUj5s07mUHHc0wqB76QWpqeQ@mail.gmail.com>
 <CAJ8uoz0i2Y4bUXCGEgqWwP3QzLp2dqUfGZg+rWNt76qBwQezOw@mail.gmail.com>
In-Reply-To: <CAJ8uoz0i2Y4bUXCGEgqWwP3QzLp2dqUfGZg+rWNt76qBwQezOw@mail.gmail.com>
From:   Jussi Maki <joamaki@gmail.com>
Date:   Mon, 14 Jun 2021 14:20:29 +0200
Message-ID: <CAHn8xcmgeV+NBt7t9t46AK_x7oSrRvPC6QnP34BhL=VLs_q3hA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: Add tests for XDP bonding
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, j.vosburgh@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>, vfalico@gmail.com,
        Andrii Nakryiko <andrii@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 10:48 AM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Mon, Jun 14, 2021 at 10:09 AM Jussi Maki <joamaki@gmail.com> wrote:
> > Sounds like a good idea to me to have more shared code in the
> > selftests and I don't see a reason not to use the AF_XDP datapath in
> > the bonding selftests. I'll look into it this week and get back to
> > you.
>
> Note, that I am currently rewriting a large part of the AF_XDP
> selftests making it more amenable to adding various tests. A test is
> in my patch set is described as a set of packets to send, a set of
> packets that should be received in a certain order with specified
> contents, and configuration/setup information for the sender and
> receiver. The current code is riddled with test specific if-statements
> that make it hard to extend and use generically. So please hold off
> for a week or so and review my patch set when I send it to the list.
> Better use of your time. Hopefully we can make it fit your bill too
> with not too much work.

Ok, thanks for the heads up! Looking forward to your patch set.
