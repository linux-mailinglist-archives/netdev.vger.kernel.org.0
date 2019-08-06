Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A38D283515
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 17:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732976AbfHFPVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 11:21:37 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38747 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfHFPVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 11:21:36 -0400
Received: by mail-lj1-f196.google.com with SMTP id r9so82565485ljg.5;
        Tue, 06 Aug 2019 08:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1sJ7ixGeE7RZS3VbxKxevNtiuxonkBN1nlH+bBwiJAo=;
        b=ZEgo/vnDUJXPZxSAXfu1SMTOyq16tKCuCkk6y9PNBp/2cnI6xZ0gNsugQfhRxfK0AD
         9AyAKzHnoMKl/ePD2AoWO9j6kIZSIXmWDmhu5lBGSlc3wDCskTXb8qTktdWlDRtWJOxp
         PKOX1wjw0sdmtijyNW8NaaGolXxIq2oTQQY3gGEq16pl9Hpp46hDhxsUHTNZ5hqp4BZu
         ZMl7Gl8ui9GnucOy5EyZwAvHgIsToICw6IOScBVLLx5fN8IEI/n5KuhasGsgI3F6Ct7R
         xbgxLJPoaYSN+SD6h/JpkFoF3mGGNwZAJ1okIXUA5K4nzkhMu5gCizTraVgF+yF+PMZM
         +nmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1sJ7ixGeE7RZS3VbxKxevNtiuxonkBN1nlH+bBwiJAo=;
        b=fQXy0d0rQh9OVeLsEAv4e6uVPG3pY1jf9s1SsaA9KWMwKXcnvaKp8TUsJQwSdKSEID
         8kGTZcAQCuY2k3n6q3mP/Uw0qthwh9BSyHYNqIK/w9JYcCNCr13CjJjy4P36W2MypB8k
         ayp1DkgLzw3n0LP1yVcFd5p/4nGn5kcGeUysoZnO0HQFXsEvHigI8C3dWCaDD63dMJhT
         rM6wwmNgD8ISkWSb6yqdlrinTOfkrvj1QAiGzInT0sBXusTbt9wnDW/QRhUZjctXLd0q
         bRU9Zl22zbFMIHUOBQ0oQPNPhHurXKas4aGDDHgaCGjw8UuzZG2s+aAUV/iiJHZHrjgW
         yp3A==
X-Gm-Message-State: APjAAAXXlrqI5D1fskfewNFE9YxbGfNkD+NTLQraLzOu7GtCaRXrdSwk
        jNlB0LccDqmlqyeGEUZ6XGWvS87JSOkGHen5F9I=
X-Google-Smtp-Source: APXvYqwqHpXakbGJfmufnUhVkhx5lb5yh7ESZIq3VNa8wGUESnKDAk8YovWiYUqVoK23hCjYnu5mVf0TRy0H0TgTPp4=
X-Received: by 2002:a2e:9dca:: with SMTP id x10mr2024634ljj.17.1565104894711;
 Tue, 06 Aug 2019 08:21:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190806021744.2953168-1-ast@kernel.org> <ff86b565-097e-8f1a-c411-7138f429ed79@fb.com>
In-Reply-To: <ff86b565-097e-8f1a-c411-7138f429ed79@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 6 Aug 2019 08:21:22 -0700
Message-ID: <CAADnVQKj1o_OBtM2urdMQe-0x7Qu78-TW5Vj8y_3Q7K2naF25g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/2] selftests/bpf: more loop tests
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 5, 2019 at 9:19 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 8/5/19 7:17 PM, Alexei Starovoitov wrote:
> > Add two bounded loop tests.
> >
> > v1-v2: addressed feedback from Yonghong.
> >
> > Alexei Starovoitov (2):
> >    selftests/bpf: add loop test 4
> >    selftests/bpf: add loop test 5
>
> Looks good to me. Ack for the whole series.
> Acked-by: Yonghong Song <yhs@fb.com>

Applied. Thanks
