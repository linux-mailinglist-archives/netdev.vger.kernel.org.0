Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F14AC125920
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 02:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfLSBRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 20:17:33 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36526 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfLSBRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 20:17:32 -0500
Received: by mail-lj1-f196.google.com with SMTP id r19so4296080ljg.3;
        Wed, 18 Dec 2019 17:17:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x+hZ4AsCCSWF7X3U8kH39BiTzUTLQH9/GLTn4Zwvi2k=;
        b=HI7qOMG1BZ9iBpMMUhSMk75Oa2uNnCESdfS2b5zaTakgAZ38v09cEubHnHG2cWxOjB
         1+/09Gg3omg/LTo1ZdhfMYiPGli8VQ0VFNN1/VXlEv7qRgYPJlX3k8McdE9bNgrZmsQL
         x5bBJutEZjWm7GMHaqelpJojx6oI+8w4duRkIE+I/N43T4IYbQBd9EuC3sQiTFxeqY8Y
         IYa04i/oDHYRWayIOIBhgypQyxanUenXWiuUv8hocKn5BRxY/lUvNmBmgSx4hVFRCapp
         tUByQWDDv5+gQ2X6g+mF7ly2sH3h8VK/BZ9cXO6P06JbZmjSQB0GF7aseUx+nXlkyG6+
         InOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x+hZ4AsCCSWF7X3U8kH39BiTzUTLQH9/GLTn4Zwvi2k=;
        b=aGLAXcAjEpRw1EL4a7HnS0TtIvFiYKJrfDJYPyCzy+aBpCuFK1LVh/G2YLFqaHji9e
         EpwaEd/AmJg0FpzLDdUNIkYfoo2urEThu8eX+IoJzwIsv8KLUVRX0d4ufpffH8vu4CpH
         q32UILXV7iN3QYiwGiKmAU/27tFLrnydQDrNYKvrgMomcPkMu8TzDAI8XNO/QzRiGG5e
         /l1xCtLXZH8GWdhp/UrBPoR67MezUE3+3DCr0rJ2H2SeGvZDWKRWaSxpoxg0GAjw+E2+
         Aw0tDhCKO1OuEWWjvhjvTwO6HCIlQKTHi5JyYsRNVhwKJS2SgzTqsYx+lWlk47VF0UJ8
         zhDg==
X-Gm-Message-State: APjAAAXzuqRe/qDKjlIca3m7RjHoOlarwLxGUgvtLGqylg53HA+sc6k7
        T4rKas4HJYHeH0lDiedtGjitBHZCJbrlIMXDXyo=
X-Google-Smtp-Source: APXvYqwMucniyBvvi/ahg11Dnv7XDWoGTxskW4ZSjRWD8b55hyXxzdVf9Rcv+mZ3Oz8rV9WdSjCMXE+U7r27uW7VMs8=
X-Received: by 2002:a2e:9d85:: with SMTP id c5mr4038997ljj.51.1576718250567;
 Wed, 18 Dec 2019 17:17:30 -0800 (PST)
MIME-Version: 1.0
References: <20191218205747.107438-1-tehnerd@tehnerd.com>
In-Reply-To: <20191218205747.107438-1-tehnerd@tehnerd.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 18 Dec 2019 17:17:19 -0800
Message-ID: <CAADnVQ+A1rdqtGNEa_d8sDrMgHqb0Z4QfiRv6_dfPYqPgBt6cA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: allow to change skb mark in test_run
To:     "Nikita V. Shirokov" <tehnerd@tehnerd.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 12:59 PM Nikita V. Shirokov <tehnerd@tehnerd.com> wrote:
>
> allow to pass skb's mark field into bpf_prog_test_run ctx
> for BPF_PROG_TYPE_SCHED_CLS prog type. that would allow
> to test bpf programs which are doing decision based on this
> field
>
> Signed-off-by: Nikita V. Shirokov <tehnerd@tehnerd.com>

Applied. Thanks.

Please cc bpf@vger next time.
