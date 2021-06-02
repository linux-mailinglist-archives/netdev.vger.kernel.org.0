Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852D7399643
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 01:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhFBXTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 19:19:30 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:40839 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhFBXT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 19:19:29 -0400
Received: by mail-lj1-f176.google.com with SMTP id u22so4698047ljh.7
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 16:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kHAIUyOjRJ75m1yqDEy1XR5TpykGFGx7wokSTM7Lnpg=;
        b=SrZqWHnAB7rhKMJWRaDxPxmNQ4O3bRLOxyH5FdpLdWLy83RLy3HZQYF1HuV70/8id2
         1pPu3oZYKxw5qqrWgDYgKE8OEWxIp4/pu6rkWKNTTRrZ8Rhioy37ygDeiLoJoZ1gloac
         baKV07IoFC2I0PHCTqXSKtpVpGk9eQ1HmIzQm5C331o+pFJxID5839ewJDGubROrRd+j
         k7G7xDVkOPeQ9h0HNzmG2I5ShVrV0QvCGcQ/3GUKd+/SAT83yyODb6av0hrRjw0Jg5cf
         zwJ065EnvEC+R6fZuTRkJeqpHkQ5TeCAaBDBBiPOw4rwf01sDaBCxYkv+XVR6ACgEvtZ
         er6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kHAIUyOjRJ75m1yqDEy1XR5TpykGFGx7wokSTM7Lnpg=;
        b=CqHORwTrRJasCwOZY8ejv7IQF4yv/r8GBwbzUHXxcic1vNyUtCdGhYbMOziWGIhBBV
         TsiZzzjCDF+vDx9u13rVwaiUNW3Vn0VR3jFmNHjCGwr2NHk/+hlVAFi3aYPbYakmK6qI
         oJf+0V8BRkwJNr6nITF5kE4iTKmxaUr97JgYnnCy7PYRUnj96KBDrxRd6tqYjjAe5Iuq
         DBj+xEW1pUl+RmzRHx37wq/iT0JJJJN32hlniXNLXI4RIOKQ6QQ+V0WdovNqevmDSY+S
         nujDOQWIR8g+6b7AXtYkTZ5rda0BSOAukPuhq2EOqqHrZBxK7BJsI7mTDPmqqG9NdjBb
         uccA==
X-Gm-Message-State: AOAM532JA1jjNc2V422NObk+OywdOZZw1UgzyIOjZRKi4KfHfXhRfvat
        0z8yUJbApvgtDKv9ePJ6wfnF/Zq4RDYnQ7I1lMI=
X-Google-Smtp-Source: ABdhPJyFC1eTaAJcUEKngbCuqPZnHPSh5VCltIZGjmMEKzG8btB1sCefNDLSgsqXs3cHCi29MIXdkaKgAHJVixqe/DA=
X-Received: by 2002:a2e:a4a5:: with SMTP id g5mr16956ljm.32.1622675805239;
 Wed, 02 Jun 2021 16:16:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210601221841.1251830-1-tannerlove.kernel@gmail.com> <20210602.131026.1242688865859450294.davem@davemloft.net>
In-Reply-To: <20210602.131026.1242688865859450294.davem@davemloft.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 2 Jun 2021 16:16:33 -0700
Message-ID: <CAADnVQKfy1QbHt9AGDq3JOtvskMx5N82u1Xk_esCF6VOOujkow@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
To:     David Miller <davem@davemloft.net>
Cc:     tannerlove.kernel@gmail.com,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>, tannerlove@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 2, 2021 at 1:10 PM David Miller <davem@davemloft.net> wrote:
>
> From: Tanner Love <tannerlove.kernel@gmail.com>
> Date: Tue,  1 Jun 2021 18:18:37 -0400
>
> > From: Tanner Love <tannerlove@google.com>
> >
> > First patch extends the flow dissector BPF program type to accept
> > virtio-net header members.
> >
> > Second patch uses this feature to add optional flow dissection in
> > virtio_net_hdr_to_skb(). This allows admins to define permitted
> > packets more strictly, for example dropping deprecated UDP_UFO
> > packets.
> >
> > Third patch extends kselftest to cover this feature.
>
> Definitely need some bpf review of these changes.

Yeah. imo it's more bpf material than net.
We'll process it.
