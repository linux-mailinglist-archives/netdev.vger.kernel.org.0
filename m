Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DA13A866C
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 18:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhFOQ2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 12:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhFOQ2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 12:28:43 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C3BC061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 09:26:38 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id d13so13747997ljg.12
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 09:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EBFLtpLfl9HP8/ret0EKv7MwCFVe5SQTPS5z/OHIK8Y=;
        b=bQywYYAF55xi9rfhAvnKFe87fzG8BbK+wEPL75j1aESOYpg9xE0k0jKdUwjK1oGds+
         DDutLAOMbJxXVHWnGdupHdWIaY9pFItCIhW18lRJY8T1HRGd8RXiqOovWC7OaC0OiT+9
         Wn9yZ0QxaZK/9wUWXqNcBb+mKq4hOXUWRmaGk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EBFLtpLfl9HP8/ret0EKv7MwCFVe5SQTPS5z/OHIK8Y=;
        b=RTv4QAnBOdRytTl2Sy+YlWdyDXodzzApcB+iztp5wLFzWrjFWtPoG+hXPn4GCjTmSk
         GX0XhEs0nolQbDK2YhQxFKv8Ufol5gcso3iTerAW/HRSRcecamexPmxPTaWUNhHktRxi
         PU81DM6Ab+jRbo1rSJCwrvACQUxUw4qkxr+Zb7phuadsQZ9Yn2rhtY/J33d97x88SYdm
         xtQKXxKepr9FqDT8Pk+SKX6hpzqkheEtSMvtJxRJBZU6fWlRQd652od2g0K0b1MSYn/s
         1oIGgby38aH/YfSVridxkZqz9kH4RbFDRqNkoejogqP0c4y66RMJvY44ecUdrdOu0ly/
         N6Aw==
X-Gm-Message-State: AOAM533c8H6VRkXoULJdb97mY3MPiqjpZS7XQfZmGzj5sKm2hg9sGz9B
        ycC2OySq9qYeFTskMx7/Pf4A162Q8BNjR4et
X-Google-Smtp-Source: ABdhPJxm76pY01a/EX3Xl2V4sOhyYx7qWthfDVzmxyvcdRd/F2juxPqvIGbYvuXYhV+jYYdSemuK8g==
X-Received: by 2002:a05:651c:150a:: with SMTP id e10mr376681ljf.215.1623774397122;
        Tue, 15 Jun 2021 09:26:37 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id w17sm297705lfd.126.2021.06.15.09.26.35
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 09:26:36 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id c11so25913392ljd.6
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 09:26:35 -0700 (PDT)
X-Received: by 2002:a2e:b618:: with SMTP id r24mr406657ljn.48.1623774395513;
 Tue, 15 Jun 2021 09:26:35 -0700 (PDT)
MIME-Version: 1.0
References: <YMjTlp2FSJYvoyFa@unreal>
In-Reply-To: <YMjTlp2FSJYvoyFa@unreal>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 15 Jun 2021 09:26:19 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiucGtZQHpyfm5bK1xp9vepu9dA_OBE-A1-Gr=Neo8b2Q@mail.gmail.com>
Message-ID: <CAHk-=wiucGtZQHpyfm5bK1xp9vepu9dA_OBE-A1-Gr=Neo8b2Q@mail.gmail.com>
Subject: Re: NetworkManager fails to start
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Andrea Righi <andrea.righi@canonical.com>,
        stable <stable@vger.kernel.org>,
        linux-netdev <netdev@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000000a60a805c4d070db"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000000a60a805c4d070db
Content-Type: text/plain; charset="UTF-8"

On Tue, Jun 15, 2021 at 9:21 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> The commit 591a22c14d3f ("proc: Track /proc/$pid/attr/ opener mm_struct")
> that we got in v5.13-rc6 broke our regression to pieces. The NIC interfaces
> fail to start when using NetworkManager.

Does the attached patch fix it?

It just makes the open always succeed, and then the private_data that
the open did (that may or may not then have been filled in) is only
used on write.

               Linus

--0000000000000a60a805c4d070db
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_kpy9c7n50>
X-Attachment-Id: f_kpy9c7n50

IGZzL3Byb2MvYmFzZS5jIHwgNCArKystCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvcHJvYy9iYXNlLmMgYi9mcy9wcm9jL2Jh
c2UuYwppbmRleCA3MTE4ZWJlMzhmYTYuLjljYmQ5MTUwMjVhZCAxMDA2NDQKLS0tIGEvZnMvcHJv
Yy9iYXNlLmMKKysrIGIvZnMvcHJvYy9iYXNlLmMKQEAgLTI2NzYsNyArMjY3Niw5IEBAIHN0YXRp
YyBpbnQgcHJvY19waWRlbnRfcmVhZGRpcihzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0IGRpcl9j
b250ZXh0ICpjdHgsCiAjaWZkZWYgQ09ORklHX1NFQ1VSSVRZCiBzdGF0aWMgaW50IHByb2NfcGlk
X2F0dHJfb3BlbihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkKIHsKLQly
ZXR1cm4gX19tZW1fb3Blbihpbm9kZSwgZmlsZSwgUFRSQUNFX01PREVfUkVBRF9GU0NSRURTKTsK
KwlmaWxlLT5wcml2YXRlX2RhdGEgPSBOVUxMOworCV9fbWVtX29wZW4oaW5vZGUsIGZpbGUsIFBU
UkFDRV9NT0RFX1JFQURfRlNDUkVEUyk7CisJcmV0dXJuIDA7CiB9CiAKIHN0YXRpYyBzc2l6ZV90
IHByb2NfcGlkX2F0dHJfcmVhZChzdHJ1Y3QgZmlsZSAqIGZpbGUsIGNoYXIgX191c2VyICogYnVm
LAo=
--0000000000000a60a805c4d070db--
