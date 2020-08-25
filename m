Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A12A251053
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 06:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgHYEPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 00:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgHYEPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 00:15:00 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FFBC061574;
        Mon, 24 Aug 2020 21:15:00 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id v4so12201678ljd.0;
        Mon, 24 Aug 2020 21:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jixWM/zIS64nCGA1U6cQ5Pjeg1UMIki8HoUmWtXeAkY=;
        b=LzxRELyEGRsgbX7kBwy/PssngmffqOYu4iwz/HiL7qUN0lGC1lQpXAOQXz+F2cLbN0
         YHc+wPiPHwEpfqaNauQ5o4ltyHIGFbSfutkjrkPV0rBGEY7xNZu6Kn9JB/B6gClEJoK9
         EknibguIdT50J825b2y09+8efYzZb9WBWcBq2MM52XPFqIXoNi0KHHeEba1UZx0Mheqg
         DDF77qKfcFEGzkWx/NA6OLVyQHADQH7sNJUy5Mv/H3HzFYqiruZiOipm+qwuaY0K2Qvs
         AcIXw9RNcT+qymzl5fS604sk9dVmFarjAPCMpjyEQCoIGBSv6t9ByEb0dJOh/K0GckqY
         8DsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jixWM/zIS64nCGA1U6cQ5Pjeg1UMIki8HoUmWtXeAkY=;
        b=ijuFBK3xspbB07EpAaFeKDJW3s0uZUkHFLSip44SUwcsVqhN80paCLhbG2JPCArSfD
         MT7EohsM1fxoEGFdY+80H8V1UrpyVopiuJLl+zt8Y3ZU8vWCVVhgNtfc6OThzsce4lUC
         KJqVunHP5kL0c1/dwyot8nA5W21Olyw6cGJQrwchcKMhWpMGRKixv736pdrvuOEg7f91
         oTG9bpSx6Eln2/DS16kaLFdcQhtWs/ctNAZOjUpZ/pVbQwLNITWhMAKxPC3mOzS0V1eR
         FUqWIRr1c+k6OR/HOIq3zziSfHRratZjoKulZCY7kFKslviTwN5nzBLNbgUHOPrPUwo5
         FvEw==
X-Gm-Message-State: AOAM532fdspo12FGu1+oGlxTNbUpSfXOiQ14gfW+Q9A8a7Hkvx/6p7Zr
        FQ0L2nJ3zZruy4lrNgky2MpxNz3C7rnwOhOtsrk0539M
X-Google-Smtp-Source: ABdhPJyV58Ym6HhdUQZ/BWmsotzvFYsy+cyju8w+pTPKc/vxJ20Gec2Un+mVQhPM4VCVQZN++dBlhpHzS3ju44BJo8Y=
X-Received: by 2002:a2e:4e09:: with SMTP id c9mr4104057ljb.283.1598328898606;
 Mon, 24 Aug 2020 21:14:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200824142047.22043-1-tklauser@distanz.ch>
In-Reply-To: <20200824142047.22043-1-tklauser@distanz.ch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 24 Aug 2020 21:14:47 -0700
Message-ID: <CAADnVQJ6g_ZYS-wQ-FN6p4X=MoVu65Qe_=-5O3eh-K_jB=kCCQ@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf, sysctl: let bpf_stats_handler take a kernel
 pointer buffer
To:     Tobias Klauser <tklauser@distanz.ch>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 7:20 AM Tobias Klauser <tklauser@distanz.ch> wrote:
>
> Commit 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
> changed ctl_table.proc_handler to take a kernel pointer. Adjust the
> signature of bpf_stats_handler to match ctl_table.proc_handler which
> fixes the following sparse warning:
>
> kernel/sysctl.c:226:49: warning: incorrect type in argument 3 (different address spaces)
> kernel/sysctl.c:226:49:    expected void *
> kernel/sysctl.c:226:49:    got void [noderef] __user *buffer
> kernel/sysctl.c:2640:35: warning: incorrect type in initializer (incompatible argument 3 (different address spaces))
> kernel/sysctl.c:2640:35:    expected int ( [usertype] *proc_handler )( ... )
> kernel/sysctl.c:2640:35:    got int ( * )( ... )
>
> Fixes: 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Applied. Thanks
