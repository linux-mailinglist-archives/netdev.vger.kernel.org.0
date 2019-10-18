Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E13DCEB7
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 20:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394764AbfJRSv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 14:51:57 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:43051 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbfJRSv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 14:51:57 -0400
Received: by mail-vs1-f68.google.com with SMTP id b1so4684027vsr.10
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 11:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=posk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YQ+b7O8lIRasL7SBrhHpxrv11BEIe5f0Rek2PCPmRlk=;
        b=eq5rjLzv/egeeOliP0FyzcN897rAH02eUhoyWTxH5VxKB7cltB/4lezGCwXTc7mWiM
         agRoCqaVmezu+8sDVqVCH7V/ev7sXLa45VEb0VkR8sfJUoWQmCmtl2LAPjTe4cicayqL
         g7ZXqcHawzCtaBHEyzabwuwL7R7i7O+VI113W7GAZ024yh/EnZNp/2PJ0s05CkNv9R0T
         LTHQUo9yTolD17XDNZZ+pDwukRJEoK4XQ2u3COt7YATY9QLyCNcnpQUlWEbLAF0zh6Ug
         29RSLFs/o4EuZiKwSAwVJDvVJHdphgMnMGeN3hdmsCtqPtFzEb6+RkjWqqlCjj78Eay3
         QAGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YQ+b7O8lIRasL7SBrhHpxrv11BEIe5f0Rek2PCPmRlk=;
        b=FU4i0HOxlP/NbEMzmhMGOwW2RL8DVf2HlGKEznjfO6ysmtklZIYEDSYYAvqm9CPV7H
         8xQFVeG6Lktouq876niaoJB50ft4SJv6X4fmdIH9UVk80RC5pOmPUPmzW2zlQXa66PlA
         Hu2Xk605l91cQTHyOtgIgseVMkgQI4NnlvxLPNzxWQ0Qd2LdiH1sCkp0Jb2n3K7RhZo6
         Tquv7ON5bUH2u0inLmZQsaKWJyaHaqCo8GPOdS+bNw71w6+5LpoVY9UQB4qrIHT2HWfW
         bat7OyI+WHBbW9L4dTPyXE48xM0OxOrTM5XcPuOiGeqa8PxZgzWoyQNyldXAeUi93rqX
         R+Dw==
X-Gm-Message-State: APjAAAVWIDQm6YkbS2sjExr7VibTnvwpG72qFv4BT9liXm6NC5YQchCw
        PHU8efL0reylnBltr0bsoqJdTlr3O3PIvPXdY20Ifw==
X-Google-Smtp-Source: APXvYqy/fouzVLLJeCyLs5Pk8bc2m+kQSVsYEjXrZRIgA4PZofUHlW6/cLIfMnqH7a2sjGeHopVCqIG2YTD+NDkuVqk=
X-Received: by 2002:a67:6242:: with SMTP id w63mr361961vsb.233.1571424716206;
 Fri, 18 Oct 2019 11:51:56 -0700 (PDT)
MIME-Version: 1.0
References: <f5bf07dccd8b552a76c84d49e80b86c5aa071122.1571400024.git.jbenc@redhat.com>
In-Reply-To: <f5bf07dccd8b552a76c84d49e80b86c5aa071122.1571400024.git.jbenc@redhat.com>
From:   Peter Oskolkov <posk@posk.io>
Date:   Fri, 18 Oct 2019 11:51:44 -0700
Message-ID: <CAFTs51Xh=LjQqzS_YFaG6Z-OdOYLyXeSes+aWxkrPaBx_po_bg@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: More compatible nc options in test_tc_edt
To:     Jiri Benc <jbenc@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, linux-netdev <netdev@vger.kernel.org>,
        Peter Oskolkov <posk@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 5:00 AM Jiri Benc <jbenc@redhat.com> wrote:
>
> Out of the three nc implementations widely in use, at least two (BSD netcat
> and nmap-ncat) do not support -l combined with -s. Modify the nc invocation
> to be accepted by all of them.
>
> Fixes: 7df5e3db8f63 ("selftests: bpf: tc-bpf flow shaping with EDT")
> Cc: Peter Oskolkov <posk@google.com>
> Signed-off-by: Jiri Benc <jbenc@redhat.com>
> ---
>  tools/testing/selftests/bpf/test_tc_edt.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/test_tc_edt.sh b/tools/testing/selftests/bpf/test_tc_edt.sh
> index f38567ef694b..daa7d1b8d309 100755
> --- a/tools/testing/selftests/bpf/test_tc_edt.sh
> +++ b/tools/testing/selftests/bpf/test_tc_edt.sh
> @@ -59,7 +59,7 @@ ip netns exec ${NS_SRC} tc filter add dev veth_src egress \
>
>  # start the listener
>  ip netns exec ${NS_DST} bash -c \
> -       "nc -4 -l -s ${IP_DST} -p 9000 >/dev/null &"
> +       "nc -4 -l -p 9000 >/dev/null &"

The test passes with the regular linux/debian nc. If it passes will the rest,

Acked-by: Peter Oskolkov <posk@google.com>

>  declare -i NC_PID=$!
>  sleep 1
>
> --
> 2.18.1
>
