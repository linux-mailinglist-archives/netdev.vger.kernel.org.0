Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2121C19E035
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 23:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgDCVNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 17:13:12 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36373 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgDCVNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 17:13:09 -0400
Received: by mail-lj1-f195.google.com with SMTP id b1so8439371ljp.3;
        Fri, 03 Apr 2020 14:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XmiJ8r8In7YZhRpgdLSggbFpjzBQN570VmkdZRjoKl0=;
        b=M6ntENSWQevfVE4wJYGpCvuhiRBs/UguboAiKuhbN1k8eoUdPpvVhUv1xnF8VXgwRA
         MdLwa/cOtEg+kyIANAYshaShDUIy364a8Qo+R2UAu/P1S+ulxY0kFyk+cOqsHi+T3UFp
         g2LxoYzZgTThz6Oy4rK7gU2WNK3GzOtrqQzmeQOwI6MlscPkO2M6rdL00gjYrK8igEyZ
         w5SN4N/51Ggyw+VN7sRiouv16fwKQmHEjKcDJW5oAysHPfz/jbDfsiAK5JZqbT+Yt1Rd
         2RdZsW5WGf/hx2pwMsgqOhucC8mAjPqiSPy8ltpa3QVsgaRKLVWedu342pVtPwBbnBYf
         wxIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XmiJ8r8In7YZhRpgdLSggbFpjzBQN570VmkdZRjoKl0=;
        b=azRK44efIQRVkP9oWe75wP8STYF6/bdc6aMngSiRglurMbz5n1HTSZu7Y4QXdGUOR+
         P4kFFa5nBpUtnz4TboY7bIVoAadsFor6l20ir9SGpNokh2xufrhkHMidelEmwCKuaXnM
         68JREb+mKLeU3sKj21LBAyKJ+ENHEPydV48HivhRPie3cU8IKQKm8xmR70MfWJK3vvZE
         H7KNCKq+z29tmTrAb43gdECrAu+RbFFDvmTc6kwjBNYYNq8Xt8RZCvoTrN2+EMdf9XLe
         sBaNGG5WkiOLK9cK8B15LaOYIoHcftZeg1grm3lDUkXrQsbsLIe/SxUVZP9mbAJQVwMY
         ZyIA==
X-Gm-Message-State: AGi0PuZKcVuijDqwn1vAxHAWm74zmeA1ghVjFDY8MSaGnd4+V5Jt6Vqe
        /STXadkWxrXEgu2eupuW8I38Gk/cztfUimAZi0s=
X-Google-Smtp-Source: APiQypLrAAv0TjbwUikI1rOrsahsFIicv7pVJUqr/CcJxejGQmURK1Ta5WDW3qardZaSCQVr8cXCTMZJZgEGyc+DR3M=
X-Received: by 2002:a2e:b24c:: with SMTP id n12mr6345776ljm.7.1585948385607;
 Fri, 03 Apr 2020 14:13:05 -0700 (PDT)
MIME-Version: 1.0
References: <fb5ab568-9bc8-3145-a8db-3e975ccdf846@gmail.com>
 <20200331060641.79999-1-maowenan@huawei.com> <7a1d55ad-1427-67fe-f204-4d4a0ab2c4b1@gmail.com>
 <20200401181419.7acd2aa6@carbon> <ede2f407-839e-d29e-0ebe-aa39dd461bfd@gmail.com>
 <20200402110619.48f31a63@carbon> <CAADnVQKEyv_bRhEfu1Jp=DSggj_O2xjJyd_QZ7a4LJY+dUO2rg@mail.gmail.com>
 <20200403095847.21e1e5ea@carbon>
In-Reply-To: <20200403095847.21e1e5ea@carbon>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 3 Apr 2020 14:12:54 -0700
Message-ID: <CAADnVQKs9hLUPB6vW+sC3pe1ivXKU3woJFvT=X2hCqT=NnZF7Q@mail.gmail.com>
Subject: Re: [PATCH net v2] veth: xdp: use head instead of hard_start
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Mao Wenan <maowenan@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, jwi@linux.ibm.com,
        jianglidong3@jd.com, Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 3, 2020 at 12:59 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> I want to wait to ease your life as maintainer. This is part of a
> larger patchset (for XDP frame_sz) and the next patch touch same code
> path and thus depend on these code adjustments.  If we apply them in
> bpf vs bpf-next then you/we will have to handle merge conflicts.  The
> severity of the "fix" is really low, it only means 32 bytes less
> headroom (which I doubt anyone is using).

Ahh. Make sense. That type of fix can wait.
Thanks!
