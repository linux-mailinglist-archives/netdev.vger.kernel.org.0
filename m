Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 064397B86B
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 06:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfGaEMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 00:12:33 -0400
Received: from mail-lj1-f181.google.com ([209.85.208.181]:36161 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbfGaEMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 00:12:33 -0400
Received: by mail-lj1-f181.google.com with SMTP id i21so64209778ljj.3;
        Tue, 30 Jul 2019 21:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hG19nbQy+AVdG3V4usBpGCc3Y7/Fo49/v/D0tj7mJjk=;
        b=fsmjYkSR0COLxibp9N55+udLVwPk8oPdc/sSwnHW1DjJZW97AbTCjlICWaKcIwKTXs
         1hvNsbmJJ+Z7K8fQ2Tz06tlkATWHfcevmaaPXRYhC+JhDx9m+vNyyPf8ulg9xuP1SzyG
         GOx8ZQTCoExZQF1TJNsukG3R4AkAiacdIYVjpOxfQ161kc5fHtwsqs5zOVOZbq76Kphs
         1qGQYrZrT8j6dD/gH27rDZTJRbQ3f0O2ouXX9NZNlZ54CEYo0O/8eDVuIdTL5MgI1xQc
         n+JAsLBrkBQsx2iIZDbTuWiyFHgC7uXDaA7vtF09J3iLuBUUHiwJrch1GfSNofKDAke8
         kMCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hG19nbQy+AVdG3V4usBpGCc3Y7/Fo49/v/D0tj7mJjk=;
        b=qyvQLNwRWFct8+/+C7VToNlBAkFgDAWik4MJIHjCY8AlAH7JuLjByuv84LuSAUoHug
         z0siusSOvYMMT6FmmXgxRtgjMBJeMd6NnNAwIx2TLMDpPgpK61bY9NXAtt1wmXEo8oe2
         MVl1W6G8HHy89LLCT/JME15Fosj9bCNQlAIel/Pmzigm5SAo/Wh3XQGFO0FmlS3hT6LN
         q8zD+1l/C8ZEGyuak6j/J8GKtAXI5j02UTdljLiUYYI8UbNF1Ek9o77xt7phvrhjUT/1
         s/QUA53/oWyfeuvBTF2cryPBIlvYsp9y74upgKBFMtbUVkkyzlN6rFo8nWYnnXuemoha
         fSQA==
X-Gm-Message-State: APjAAAW7+HP9ddpCZ5seyQScS2MR+StTmNF577XlR5bopfSZ45bYWDd+
        izHRrwUXS5JpxLXPdA11RWztGZIGly+vcF5vrUPeDA==
X-Google-Smtp-Source: APXvYqyARbzaS7CSkEyAESuMZyx9Z1IsGeI3J4rq5a9HkrFhw+V6G1HOEOFhw2tKThcn2BFYWMx6+hPBtML8p4q2ksM=
X-Received: by 2002:a2e:7818:: with SMTP id t24mr34958384ljc.210.1564546351131;
 Tue, 30 Jul 2019 21:12:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190729165918.92933-1-ppenkov.kernel@gmail.com>
 <20190729204755.iu5wp3xisu42vkky@ast-mbp> <CAG4SDVV9oBYkXqof=FoD0DeRY=+tSwZo3E1jhqMnF8F8+bVTbg@mail.gmail.com>
In-Reply-To: <CAG4SDVV9oBYkXqof=FoD0DeRY=+tSwZo3E1jhqMnF8F8+bVTbg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 30 Jul 2019 21:12:19 -0700
Message-ID: <CAADnVQKKb=5n-rsa9Gr-i=5bti=xxhjv17gGs51PmHt4FY_jfg@mail.gmail.com>
Subject: Re: [bpf-next,v2 0/6] Introduce a BPF helper to generate SYN cookies
To:     Petar Penkov <ppenkov@google.com>
Cc:     Petar Penkov <ppenkov.kernel@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Stanislav Fomichev <sdf@google.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 4:46 PM Petar Penkov <ppenkov@google.com> wrote:
>>
> > What is cpu utilization at this rate?
> > Is it cpu or nic limited if you crank up the syn flood?
> > Original 7M with all cores or single core?
> My receiver was configured with 16rx queues and 16 cores. 7M all cores
> are at 100% so I believe this case is CPU limited. At XDP, all cores
> are at roughly 40%. I couldn't reliably generate higher SYN flood rate
> than that, and the highest numbers I could see for XDP did not go past
> 10.65Mpps with ~42% utilization on each core. I think I am hitting a
> NIC limit here since the CPUs are free.

Applied. Thanks!
