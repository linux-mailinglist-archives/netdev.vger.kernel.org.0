Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76885210F86
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732124AbgGAPkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731473AbgGAPkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 11:40:20 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D33C08C5C1;
        Wed,  1 Jul 2020 08:40:19 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id f8so15348359ljc.2;
        Wed, 01 Jul 2020 08:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sOi+qWkKDemVwvNYqv6TF/8o8Mf+HMvL6pnrNxnEAWQ=;
        b=IkOXYXeuz7fPmGfAGrqMSRe0qiSwWm/2gbXsscpM6jTwtMeITTovL4ZVzz5qq3uke5
         Z6nfwQTmSbFNOMOqe600laFoQoTmFYSDdHK2w1KrX+ohVWow3Ctcf+BXH2AShFNqoqGz
         Ciu4ZdxGYWz3XnAEWFxYFpEypbv/uCahmSLhT9JxEv+VJkSG2NIIRA0hR3QWRfNph2cq
         yQV9xypI7vINoVUE7KT0mRsbYYZSQKNpsVDVa2Wbznwarm+ie94fMWRqiCITr18weqF9
         2A6frOxoVGRzeYzISJROZl0bQzpzzXUv0h865as9wzoXBZijfAheRRq7BW45vScFQwGi
         DKfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sOi+qWkKDemVwvNYqv6TF/8o8Mf+HMvL6pnrNxnEAWQ=;
        b=UmW95IcN0pmIxSJF+W9DdKnih5NnC5cPmOBC2bS29kJheUNu60Q2e3Hw1szn880gjI
         64ff5QNtUVX9s4e1/IcvbaDmbKrrYf1KcZiyB21qKBK0FyLZCSbqnVA2tIFW2oTM3I/N
         f1FknJOxu4KU9g/XgSJ1pv/f1N6Db6xRReFBDgGDqZHHnZw2O44HqIhCWCUV84OJQnYo
         8jjTJoE7RR6CEnbnxuDkC5LXm/ty/V6Y5HUVp/K3AppBRJk4C1vbO3q0Hz2Ddc1xj9IS
         4rOHbqaw6/46lvQqt1rY5J4wNcblVJ7YQ0TBcoYL8Y8pcgkne5kxhK6QU0snHRcoC6ZS
         4yRA==
X-Gm-Message-State: AOAM533TH0f4P8cdcL5GQMlTsxf1XHCwG3Qurg+U2uNXiRiUJSzNqATJ
        dnswr6w+y5PourmlchYHUpthzuq/7KfIXAV8n5s=
X-Google-Smtp-Source: ABdhPJwyjNlZqL+HnzBmJ6zhO5PUQmL6vPuNORjeZ2PTJBwbm8J1CNeUPQvLDZ8ndDtb9J0PLhaC8p5pW+u3YDAVY40=
X-Received: by 2002:a2e:9a0f:: with SMTP id o15mr14249574lji.450.1593618017302;
 Wed, 01 Jul 2020 08:40:17 -0700 (PDT)
MIME-Version: 1.0
References: <b1a858ec-7e04-56bc-248a-62cb9bbee726@infradead.org> <a4c90264-c77b-8cfe-d3ff-3526d6229da7@fb.com>
In-Reply-To: <a4c90264-c77b-8cfe-d3ff-3526d6229da7@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 1 Jul 2020 08:40:05 -0700
Message-ID: <CAADnVQLvgda8BGMkCezr9stb5k4O5MLLibzLuWqV8-pcTkP7+w@mail.gmail.com>
Subject: Re: [PATCH -next] bpf: fix net/core/filter build errors when INET is
 not enabled
To:     Yonghong Song <yhs@fb.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 10:50 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 6/30/20 10:29 AM, Randy Dunlap wrote:
> > From: Randy Dunlap <rdunlap@infradead.org>
> >
> > Fix build errors when CONFIG_INET is not set/enabled.
> >
> > (.text+0x2b1b): undefined reference to `tcp_prot'
> > (.text+0x2b3b): undefined reference to `tcp_prot'
> >
> > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Martin KaFai Lau <kafai@fb.com>
> > Cc: Song Liu <songliubraving@fb.com>
> > Cc: Yonghong Song <yhs@fb.com>
> > Cc: Andrii Nakryiko <andriin@fb.com>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: KP Singh <kpsingh@chromium.org>
> > Cc: netdev@vger.kernel.org
> > Cc: bpf@vger.kernel.org
>
> Thanks for the fix!
>
> Acked-by: Yonghong Song <yhs@fb.com>

Applied. Thanks
