Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E69E1195C7
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 01:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfEIXtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 19:49:35 -0400
Received: from mail-vs1-f45.google.com ([209.85.217.45]:34110 "EHLO
        mail-vs1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfEIXte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 19:49:34 -0400
Received: by mail-vs1-f45.google.com with SMTP id q64so2564418vsd.1
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 16:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vmYX659fV6r4Gm0v8hnRgrQfidbFwDmPBM+p7Xf5l2c=;
        b=lMVdST3HK0BasoOapTbMFuODdMNF5OMusynTrL/1JjWVfCp9W0iQJNamdi0t6BW8dU
         UZ4bCmX6mKZ1Is6qZ98yw9MBCEocvhPI84WVsisg5AFXc/6our9q02QKNc+x6eJL9TYh
         +zzcTdT/R1DcjB1QEDkbiq8arOA1TmSGlC5c4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vmYX659fV6r4Gm0v8hnRgrQfidbFwDmPBM+p7Xf5l2c=;
        b=JNbBeLUfgLyNN/436btUqbnxPVuG83ITQyQBhz16ddwsYbO/w+PLJj7WXCmOsmiJ5D
         E1Im1XlzhLplP3E1nnSqCAFmFBi1F0qX8J9C/T7y63jHobyFLdTJRgcf1kGbcBf31O0s
         mGzCXBuYPUQbtOiPkPRerUS6TRRkKHVseDQ5wuiiZZCXgu94NDvibr/udAsjPtQOA88u
         PAWjMS4lNLBGzuE7m00Fuu8dYIE4HQuhtmaGQ2tpOJtJvsWAZEplVUC1MZTnEzBYIhc+
         acNoEc75OBUfDunZtwHPz8nYi7D9CsqFMag4Gw26b9B2Asbocl0h1GrspynNXYUJeaj4
         b0kg==
X-Gm-Message-State: APjAAAWM1w45N+RlNl7Bu2rGkNjs6zOqEfwZBQ8SGl1K3D22QHUT87/9
        9W+TM6EI5ri9LbSvb24Be0AhU7AhQzY=
X-Google-Smtp-Source: APXvYqy1QJcmcURy2kzYUzy9yXB+YquefxhEIQ5uyr9z+FL7bZpMAyheiiXzw2F6U0OIzmtbfwTXLQ==
X-Received: by 2002:a67:b41:: with SMTP id 62mr4199505vsl.139.1557445773076;
        Thu, 09 May 2019 16:49:33 -0700 (PDT)
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com. [209.85.222.47])
        by smtp.gmail.com with ESMTPSA id d133sm1516559vke.19.2019.05.09.16.49.31
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 16:49:31 -0700 (PDT)
Received: by mail-ua1-f47.google.com with SMTP id l17so1482612uar.4
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 16:49:31 -0700 (PDT)
X-Received: by 2002:ab0:1646:: with SMTP id l6mr3707720uae.75.1557445771225;
 Thu, 09 May 2019 16:49:31 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89iL_XLb5C-+DY5PRhneZDJv585xfbLtiEVc3-ejzNNXaVg@mail.gmail.com>
 <20190508230941.6rqccgijqzkxmz4t@ast-mbp> <CANn89iL_1n8Lb5yCEk3ZrBsUtPPWPZ=0BiELUo+jyBWfLfaAzg@mail.gmail.com>
 <20190509044720.fxlcldi74atev5id@ast-mbp> <CANn89i+v52ktezz5J_0of_EvTUozf86rP1Uh36HpbHf33uzDJg@mail.gmail.com>
 <CANn89iK8e8ROW8CrtTDq9-_bFeg2MdeqAdjf10i6HiwKuaZi=g@mail.gmail.com>
 <e525ec9d-df46-4280-b1c8-486a809f61e6@iogearbox.net> <20190509233023.jrezshp2aglvoieo@ast-mbp>
In-Reply-To: <20190509233023.jrezshp2aglvoieo@ast-mbp>
From:   Kees Cook <keescook@chromium.org>
Date:   Thu, 9 May 2019 16:49:19 -0700
X-Gmail-Original-Message-ID: <CAGXu5jLVCSGyB7G2-PUBvGDYK5=HtNAUwyUyJCpgnmAvarpuMQ@mail.gmail.com>
Message-ID: <CAGXu5jLVCSGyB7G2-PUBvGDYK5=HtNAUwyUyJCpgnmAvarpuMQ@mail.gmail.com>
Subject: Re: Question about seccomp / bpf
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@fb.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Jann Horn <jannh@google.com>, Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 9, 2019 at 4:30 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> I'm not sure how that can work. seccomp's prctl accepts a list of insns.
> There is no handle.
> kernel can keep a hashtable of all progs ever loaded and do a search
> in it before loading another one, but that's an ugly hack.
> Another alternative is to attach seccomp prog to parent task
> instead of N childrens.

seccomp's filter is already shared by all the children of whatever
process got the filter attached.

-- 
Kees Cook
