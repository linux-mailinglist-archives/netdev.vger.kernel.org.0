Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFD171E69B
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 03:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbfEOBZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 21:25:38 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:41276 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfEOBZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 21:25:38 -0400
Received: by mail-lf1-f66.google.com with SMTP id d8so630688lfb.8;
        Tue, 14 May 2019 18:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=spALqsHPlcMPD/HLPUMszMEQ9eOMq2oe9oN3NtzXKDQ=;
        b=ie9KhO+PWO5gcRcQypKy1hJzTA8aGgNWCbj3W4g50q4SXlQgGx5yZ0k2+9k24c/po3
         Q7i4ptVlmS6WKDizFmt2Ib+MPnrIujB9hWBXV5o+UdhaDJ7cl9C6te94SUWBSQw9qxoM
         gm3e4WsjGb93Wr9nmfcLPDf12Y54EFUwHTpqnMiA+B1lyMXXOCOvVPdrwOp3GYNkgpca
         3DQz5wUpNntr7m+cSnv+5+tYyzcfs0lP1SUhVXDskgUd9LPBwncI4qWwwWBPTUZ8W7jy
         GiFqwBu8++R9484fS31BcYRPmyFf/ERUVuwJVLkTpQvHS7CMhugGJqPVAdD7me4Ez5jI
         7fTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=spALqsHPlcMPD/HLPUMszMEQ9eOMq2oe9oN3NtzXKDQ=;
        b=f9uuJPjjmW6Wi4Chm/3hDM/GGvNh0coGLFlsSC2CMt7Pp8xD7U4Tr+SXG5zwMfiEQv
         Av5Z1YD56opAMlRUvhF9ayXKx6h/XR7YhfTtAWZISU2pQDXJbnITSD9PR4xeT+QBVzoU
         mzdWRO64D1RH5m9OY+nkTNgv0ftfYn6FAf3tdKKxR03oMG9sbYbuW6lPF6W+tZ+2QYSS
         U5DJAzCv2t1ydKdWvz1avqx9Gzp/zLq3aD5J76RvcLMajepIlnNfEv0mX+GxDVu7F4KI
         r9rGFEh0r7+4KJ18GXzGfywjlPhFt0zXvJ0/rnV/qLbT4/ShqzpwZ6snCq2F1sZUTzy0
         fE1Q==
X-Gm-Message-State: APjAAAW9bER0cJbmxlQyNcbVlbSyHeYD1pmwFMwe+xj4fXsy5bwLjvUa
        dOj147nbzbbf/RckqMKcHKzaR5UJkpQeqE3mV6c=
X-Google-Smtp-Source: APXvYqxR+R5Xz1Js6FqVG2VmRZhAmSbedVy7SwLygze/gdvxftsvx4VUG0p3TVc6BEfYhyjs+WOvqLJdx88zAyjgcLU=
X-Received: by 2002:ac2:5606:: with SMTP id v6mr16711175lfd.129.1557883536277;
 Tue, 14 May 2019 18:25:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190508171845.201303-1-sdf@google.com> <20190508175644.e4k5o6o3cgn6k5lx@ast-mbp>
 <20190508181223.GH1247@mini-arch> <20190513185724.GB24057@mini-arch>
 <CAADnVQLX3EcbW=iVxjsjO38M3Lqw5TfCcZtmbnt1DJwDvp64dA@mail.gmail.com>
 <20190514173002.GB10244@mini-arch> <20190514174523.myybhjzfhmxdycgf@ast-mbp> <20190514175332.GC10244@mini-arch>
In-Reply-To: <20190514175332.GC10244@mini-arch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 14 May 2019 18:25:24 -0700
Message-ID: <CAADnVQLAJ77XS8vfdnszHsw_KcmzrMDvPH0UxVXORN-wjc=rWQ@mail.gmail.com>
Subject: Re: [PATCH bpf 0/4] bpf: remove __rcu annotations from bpf_prog_array
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 10:53 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> Existing __rcu annotations don't add anything to the safety.

what do you mean?
BPF_PROG_RUN_ARRAY derefs these pointers under rcu.
