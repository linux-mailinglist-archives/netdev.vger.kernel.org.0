Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED13A31931
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 05:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfFADKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 23:10:45 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39141 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfFADKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 23:10:45 -0400
Received: by mail-lf1-f68.google.com with SMTP id p24so2979882lfo.6
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 20:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G4xZjVwS79aLStW8E7LRD6UpsT6T1crYSjZnP9O5XDI=;
        b=LC3oKl3NwAmQnxy1QePaF50dH9kiJbeis2aCyEW6HkO0bxJ9aK3Jppz3qHPQRn8ARA
         K/b1JiTs39el4CRcY8FNVP11D0Ju9CKld2w61BDsuETvbc7T27krxXhRwwcqSvleLk+V
         camSe6B8AELh7T8epbKb17kEij9W1U2Ndz/QZVMALRaQs84DTGucW96+Ku2mk6OjJPiY
         RF4Tx3E3Rfgh2hTNKmqaSvmpFZpjw3noEEsSdkJCmA92LpYZjgMuhV/pyxBGgRjdXNtd
         F4Ewfz+/EF5m7VRK9UuL7LDfmNt1xkdsvyzwOL5uf2MaYs0vw8Jkl6wVqAj6+4rIymky
         sfpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G4xZjVwS79aLStW8E7LRD6UpsT6T1crYSjZnP9O5XDI=;
        b=Q2ODRJdxHtA9zir2BCy8j8LeGg0Q+0SSj7y5flLQ1qw3CJx2sN0csQCXVmSR6T4MTa
         +ks/G+twNzJW/+DG0if6aF2vWnv+AyQbGpjkWonjz32fIu92Z16LtqrakNcZHIuRrCv1
         52fb1S0lzwZyieOLykp//e277tvbqBzGiDj59hHnXR/x81yrGUfQ0M4/NRYVVYj9yz7P
         fPd9TWIQNlBv2KE6ei+xsjMM1frveTiCNyOGCYypvx48Qw/plwH3K54EJ/s/3EB2Jgdd
         GQurWBVE5VEPyhmZPgCCMOH/eO0bpGKSwFPnI5CNaY5ZPvyKVE1hVVze/TuvWetHqLWS
         cXmQ==
X-Gm-Message-State: APjAAAVZTQBkFb85/unY90S5zYc6c62oKY1B3pWzE09YmpjvR7ZON9YM
        0xNbwn5Hl3o66Lo1xNooza/Sw50WWoP4/xl/1aM=
X-Google-Smtp-Source: APXvYqzT3MDSVJeJEMctoW5yXoi4uSBm3En4IhrlCMh5z2NcKR7Ol9pOjA0+RN+sfxXOymOUEWkVYMq6f4gdi61D078=
X-Received: by 2002:a19:ab1a:: with SMTP id u26mr102936lfe.6.1559358643753;
 Fri, 31 May 2019 20:10:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQJT8UJntO=pSYGN-eokuWGP_6jEeLkFgm2rmVvxmGtUCg@mail.gmail.com>
 <65320e39-8ea2-29d8-b5f9-2de0c0c7e689@gmail.com> <CAADnVQ+KqC0XCgKSBcCHB8hgQroCq=JH7Pi5NN4B9hN3xtUvYw@mail.gmail.com>
 <20190531.142936.1364854584560958251.davem@davemloft.net> <ace2225d-f0fe-03b3-12ee-b442265211dd@gmail.com>
 <CAADnVQ+yj28xchvW6jCPfXCneuHxN+0MNHVquA1v10rWQ=dBMQ@mail.gmail.com> <8da19c41-b4ba-12c2-0f43-676c90037f67@gmail.com>
In-Reply-To: <8da19c41-b4ba-12c2-0f43-676c90037f67@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 31 May 2019 20:10:32 -0700
Message-ID: <CAADnVQK0L98pJh3Mar_sa9hY1Mzc8EVh9rwuk5BWS8W_VmfMcA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/7] net: add struct nexthop to fib{6}_info
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 7:59 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 5/31/19 8:51 PM, Alexei Starovoitov wrote:
> > From single sentence of commit log it's not clear at all
> > whether they're related to this thread.
> > Will they fail if run w/o this set?
> >
>
> New code in this set (if (fi->nh) {}) can not be tested yet. It can not
> be tested until the final patch that wires up nexthops with fib entries.

Could you post the whole thing please?
This set to review/apply and whatever number of
supporting sets _including_ final tests as RFC ?
