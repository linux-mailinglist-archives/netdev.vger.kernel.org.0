Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408351F8477
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 19:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgFMRwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 13:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgFMRwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jun 2020 13:52:21 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BF6C03E96F;
        Sat, 13 Jun 2020 10:52:20 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id x189so4556771iof.9;
        Sat, 13 Jun 2020 10:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zohJCjdH5WGCVYNdwZ7CTrdR3aOqxAG5fyOBK5BztPc=;
        b=EUObILvwjkSPfOGbLkzWJI+bN4YkEE1QMRNu6obBM54ATHFDLMaR8jcldK29nUeBLh
         4jdNSXAntcPwcBPMW19IVFfCQ3b6eT4uMd1knpz+5Ym01z2ht+dS9XmMBhriBt1bYkrR
         8F14Hp8FNOGHuKK5kNoflJa0hQWBtXrgbTWKKXH8T/jvf3Z2y78fHcHAtSXevXhpOR3c
         rbqd1cY0S8jO+i4iDRSWSaUlH3vJRTdlPWA3FDrc6/oKEnJdzCBc8QcBrbFuNgbIxlRW
         AW8PKX2mdWIEVMKvBQv2Fn7hp6tSkaO+KfMclXgQfPHTCYQGmAyZ1IGzqKAJgAQEI5eV
         gM9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zohJCjdH5WGCVYNdwZ7CTrdR3aOqxAG5fyOBK5BztPc=;
        b=KF35/U6aUqUoNswvXKQO0aqKnirASX28D6HBITnDpAmGL63A3EuKz3qOXA6t4Qi4cI
         IPOFmfrlAdOCVaY1tOfthky1hX0EYcLEm8Zi/8wowugJR+7eqyPRLI92Vf4HNn28POAL
         Knfk5YKMcBAHKsa0Yio7cK+nM7JlEXJFy1baGo8NGk+c41KotDu7uPDivQfoIsafiQjN
         PO7c8KOY6IbzlJK4iDC3xBjJFdYzORpR9mcm92WaPpedj5ySRS2MUNjg0ohFHw4V63qx
         m9OtA9Wuq4NrarQVMsfO7Vy0bmBMOIRVZ9JzeSBG/LUpG17inzAA45YLN+60AEug7qGZ
         Xh7Q==
X-Gm-Message-State: AOAM532fGg46vEv7jzSOOGtoAJ0Wguh7zh+wG3YOhRN1QdsTQF2QZjT0
        DIUqZwjeaoH8Z5Ji8Y08Iv5xHB+Fqb+3inBCxfM=
X-Google-Smtp-Source: ABdhPJwjY/vl6qjusNuTDwyuBK/oHqui9HUITvTM3CJWb9devaQE+o7GXcDRCoU1S6cljuvkxQ/n7AArm90xf+58W1A=
X-Received: by 2002:a05:6638:216:: with SMTP id e22mr13883777jaq.16.1592070740031;
 Sat, 13 Jun 2020 10:52:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAMdYzYpKEOWCjb-kZj=HAkzQ0_QNs4N_6pXz1qPb1YQ2Xh5Jsg@mail.gmail.com>
In-Reply-To: <CAMdYzYpKEOWCjb-kZj=HAkzQ0_QNs4N_6pXz1qPb1YQ2Xh5Jsg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 13 Jun 2020 10:52:08 -0700
Message-ID: <CAM_iQpUNNs4fzLAT8xmhbg+dhM0gdS+HVOtFD+fMJegeSHgUFA@mail.gmail.com>
Subject: Re: [Crash] unhandled kernel memory read from unreadable memory
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000ead67105a7fadaa9"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000ead67105a7fadaa9
Content-Type: text/plain; charset="UTF-8"

Hello,

On Sat, Jun 13, 2020 at 5:41 AM Peter Geis <pgwipeout@gmail.com> wrote:
>
> Good Morning,
>
> Last night I started experiencing crashes on my home server.
> I updated to 5.6.17 from 5.6.15 a few days ago but I'm not sure if
> that is related.
> The crash occurred four times between last night and this morning.

Yeah, this is known. Can you test the attached patch?

Thanks.

--000000000000ead67105a7fadaa9
Content-Type: text/x-patch; charset="US-ASCII"; name="cgroup_sk_alloc.diff"
Content-Disposition: attachment; filename="cgroup_sk_alloc.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_kbdxrsd10>
X-Attachment-Id: f_kbdxrsd10

ZGlmZiAtLWdpdCBhL2tlcm5lbC9jZ3JvdXAvY2dyb3VwLmMgYi9rZXJuZWwvY2dyb3VwL2Nncm91
cC5jCmluZGV4IDZjOWM2YWM4MzkzNi4uYzAxMjQ1YTE5ZWEyIDEwMDY0NAotLS0gYS9rZXJuZWwv
Y2dyb3VwL2Nncm91cC5jCisrKyBiL2tlcm5lbC9jZ3JvdXAvY2dyb3VwLmMKQEAgLTY0MzgsOSAr
NjQzOCw2IEBAIHZvaWQgY2dyb3VwX3NrX2FsbG9jX2Rpc2FibGUodm9pZCkKIAogdm9pZCBjZ3Jv
dXBfc2tfYWxsb2Moc3RydWN0IHNvY2tfY2dyb3VwX2RhdGEgKnNrY2QpCiB7Ci0JaWYgKGNncm91
cF9za19hbGxvY19kaXNhYmxlZCkKLQkJcmV0dXJuOwotCiAJLyogU29ja2V0IGNsb25lIHBhdGgg
Ki8KIAlpZiAoc2tjZC0+dmFsKSB7CiAJCS8qCkBAIC02NDUzLDYgKzY0NTAsOSBAQCB2b2lkIGNn
cm91cF9za19hbGxvYyhzdHJ1Y3Qgc29ja19jZ3JvdXBfZGF0YSAqc2tjZCkKIAkJcmV0dXJuOwog
CX0KIAorCWlmIChjZ3JvdXBfc2tfYWxsb2NfZGlzYWJsZWQpCisJCXJldHVybjsKKwogCS8qIERv
bid0IGFzc29jaWF0ZSB0aGUgc29jayB3aXRoIHVucmVsYXRlZCBpbnRlcnJ1cHRlZCB0YXNrJ3Mg
Y2dyb3VwLiAqLwogCWlmIChpbl9pbnRlcnJ1cHQoKSkKIAkJcmV0dXJuOwo=
--000000000000ead67105a7fadaa9--
