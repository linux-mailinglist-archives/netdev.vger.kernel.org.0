Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F51A1770E0
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 09:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgCCIMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 03:12:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51675 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727552AbgCCIMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 03:12:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583223131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BRq+Xpy5Ea2+CTWSH3HAl6Ym/30Z9q2zfGm1aeQYGVo=;
        b=UDJAvztSlBkUZMCgZxuV2FaM5ReEdj2FGoX0i42cICPVxu7HJl3IPpqdtrhcz6ve42ZkUK
        4zGAC0BcOp2h7mdjM6nWiXrKN0L9rw7DyjK6MYI7C7EMIyZVZ1ip9R0WdyfL9zld7CeU2T
        Umw/Yakh367clvYuqN2YjSC4BEGXDHk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-SHhBB8GZNq6-jtS0R7L-pg-1; Tue, 03 Mar 2020 03:12:10 -0500
X-MC-Unique: SHhBB8GZNq6-jtS0R7L-pg-1
Received: by mail-wm1-f71.google.com with SMTP id b23so753573wmj.3
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 00:12:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=BRq+Xpy5Ea2+CTWSH3HAl6Ym/30Z9q2zfGm1aeQYGVo=;
        b=jXcA/KMqoK82TPrkk10Jsj0HYTbliye4qX1kiwSDAvkvqx2MmmfRHVwa8oyLpE6aKb
         vcKzqjL9mXkzojTQDfUsx9kpT44CJufwN0iiW7B1PaFn3IKnzR+gghe0cU1mZFCL88Uk
         jR+yzn+OVtCb1FrgDCC8jj5Vo3e0/9xi3yihycUTwVRFNSur4TklXteM71jNZLCBL+cs
         lQn+PDBpYqIiOYG/ELXE84HqZ2toB/+qYO27i6zOjJukqv8O1tEtw7u5Skt2uas5HdmX
         klaYPaO7klM5JiuTbnnu0W4Uh9jbXTYxsm7NEm8d+uz3cyf97wBKQfuZUus8LcQdR0Fc
         spZA==
X-Gm-Message-State: ANhLgQ3Nd3kaWwP5S5SSMAcqECW6aXd+zyxcATj36dRaoxrjI/DyUpfY
        sCooreHW5aeDfQKKoIJ6s0acJL6+CBkVFnvFpV5O1RxMLy4n0h4bVk5Ecws6AZuaN3ZIHmEqJNc
        zmA6SxFBGMoytwPUY
X-Received: by 2002:a1c:9816:: with SMTP id a22mr3265078wme.16.1583223129062;
        Tue, 03 Mar 2020 00:12:09 -0800 (PST)
X-Google-Smtp-Source: ADFU+vv0LkO8J0l7GbYNi16fLvskKSOI02fFIeEOrajL9bUPCtZL8p9LwBczYLgYjj+MMpgy/cgGWA==
X-Received: by 2002:a1c:9816:: with SMTP id a22mr3265059wme.16.1583223128908;
        Tue, 03 Mar 2020 00:12:08 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id g7sm28284582wrm.72.2020.03.03.00.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 00:12:08 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9EE6E180362; Tue,  3 Mar 2020 09:12:07 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel abstraction
In-Reply-To: <CAEf4BzbUpfKfB6raqwvTFPm_13Een7A9WUbQeSjdAtvcEU3nLA@mail.gmail.com>
References: <20200228223948.360936-1-andriin@fb.com> <87mu8zt6a8.fsf@toke.dk> <CAEf4BzZGn9FcUdEOSR_ouqSNvzY2AdJA=8ffMV5mTmJQS-10VA@mail.gmail.com> <87imjms8cm.fsf@toke.dk> <CAEf4BzbUpfKfB6raqwvTFPm_13Een7A9WUbQeSjdAtvcEU3nLA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 03 Mar 2020 09:12:07 +0100
Message-ID: <87a74xsvqg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> All the XDP chaining specific issues should probably discussed on your
> original thread that includes Andrey as well.

Yeah, sorry for hijacking your thread with my brain dump; I'll move it
over to the other one :)

-Toke

