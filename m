Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917171D4DAA
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 14:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgEOM2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 08:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbgEOM2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 08:28:34 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5746C05BD0A
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 05:28:33 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id v12so3279020wrp.12
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 05:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=8CBmhx9ui3qJxYivj5qzMWxfms8vf7DMdx7vVNSjA8c=;
        b=vGGnjcDhIBopZLFVLn2T3uR4fy/h1Jea54IFYPCJ4/m/2BQ7vKoRoVRyf+9bTtKuS8
         /OKsdJoy2rFrug9YW2g/pXktJUu3g+HWFPnf5mdLSm+eGo0y6qB7jQI+oDya51Umb5Qo
         SN3ZEFgFbvACJhXyWd0CHVSEdQ17bb87p+q2k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=8CBmhx9ui3qJxYivj5qzMWxfms8vf7DMdx7vVNSjA8c=;
        b=C1FTF2J8X3uCQA79FRNSqcP9bOdE7dQlSsXYdulpUn6pb6U9qB0sKKFq7Rh+/NZ7OP
         13NdEvsXjn/FcPl9EohSXGh9tnRWDtsCcIURLrZ1i9Hs8/onjlulOWHt25Bgb1ZOdTla
         6Y+ArbOsC9gDi7cx+l7sdBE2dvQ10ncm6w47h/y4p5/Ud86Z2QPIlYxmO3KvH50gTUZ3
         zCCMl2bc6xW+3McrWl2iKk0yWAXBVn5PX6/+Uqedcfkr2xbHONIDghymD53uuIOf5bCc
         NHD3/NgowPLPQrS9FneNHfuRCj+iDTIvk5ZTyeQKUm2yiYdFhPlmMeaiRpvWM3UhC9VX
         hVNQ==
X-Gm-Message-State: AOAM5326UEQ1pSlDnP94i3/VUcjCs9ZtSVUK+XqIxRRt8r3Ctb5Xgs/1
        Uyox+Z4E2NvDc+KdOhmrSfw66Q==
X-Google-Smtp-Source: ABdhPJzuJO3h9wm9P+HDKn4bQyUeRVRQ2oDHXcFbX7IhBImY1lx/94mnSy7aM8awmKA1Hpau8zRqXA==
X-Received: by 2002:adf:decb:: with SMTP id i11mr4341029wrn.172.1589545712448;
        Fri, 15 May 2020 05:28:32 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id b12sm3663696wmj.0.2020.05.15.05.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 05:28:31 -0700 (PDT)
References: <20200511185218.1422406-1-jakub@cloudflare.com> <20200511185218.1422406-6-jakub@cloudflare.com> <20200511204445.i7sessmtszox36xd@ast-mbp>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, dccp@vger.kernel.org,
        kernel-team@cloudflare.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next v2 05/17] inet: Run SK_LOOKUP BPF program on socket lookup
In-reply-to: <20200511204445.i7sessmtszox36xd@ast-mbp>
Date:   Fri, 15 May 2020 14:28:30 +0200
Message-ID: <87wo5d2xht.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 10:44 PM CEST, Alexei Starovoitov wrote:
> On Mon, May 11, 2020 at 08:52:06PM +0200, Jakub Sitnicki wrote:
>> Run a BPF program before looking up a listening socket on the receive path.
>> Program selects a listening socket to yield as result of socket lookup by
>> calling bpf_sk_assign() helper and returning BPF_REDIRECT code.
>>
>> Alternatively, program can also fail the lookup by returning with BPF_DROP,
>> or let the lookup continue as usual with BPF_OK on return.
>>
>> This lets the user match packets with listening sockets freely at the last
>> possible point on the receive path, where we know that packets are destined
>> for local delivery after undergoing policing, filtering, and routing.
>>
>> With BPF code selecting the socket, directing packets destined to an IP
>> range or to a port range to a single socket becomes possible.
>>
>> Suggested-by: Marek Majkowski <marek@cloudflare.com>
>> Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---

[...]

> Also please switch to bpf_link way of attaching. All system wide attachments
> should be visible and easily debuggable via 'bpftool link show'.
> Currently we're converting tc and xdp hooks to bpf_link. This new hook
> should have it from the beginning.

Just to clarify, I understood that bpf(BPF_PROG_ATTACH/DETACH) doesn't
have to be supported for new hooks.

Please correct me if I misunderstood.
