Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C885EBB88
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 01:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbfKAA5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 20:57:01 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39119 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727455AbfKAA5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 20:57:00 -0400
Received: by mail-lj1-f195.google.com with SMTP id y3so8571817ljj.6;
        Thu, 31 Oct 2019 17:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7KZalqPIBGBwrHXYv2oCo/flql1M8NVd61LL9jOZDSA=;
        b=rrlOqMdcW5+Y3KEJbWFOKFOjFNQo+7g3fRhDp1RNPDT4GhP3UAjGTRC9GXIz7TeBye
         agfKO8OOo7AzwAWLAQGt2NRN6mcoa264eoUqnrAw0YiQvUhmApcetCDDewRlVU3cDsbD
         +6UXhFC908QW6FWUNsSI9fPkgrLULYvjMGuqi6oBLhJDbEqP69NXsbb8Kl/UX/eaM/+E
         VgJCmJ/uCMVZWTuI/NTAR/oYkf3XpGNEiYiHgzIn4ZO9zW6RPfe46rAAgIzPFUIw7gYS
         W/nU1Eh0IceXjJfF8gDuAZq4SThez0PuGfqr7DExepC06eo2o3XYQ3Qc1NIcDt57Ltae
         UaaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7KZalqPIBGBwrHXYv2oCo/flql1M8NVd61LL9jOZDSA=;
        b=ot58uhuOqbkz/Sb6bUdKxQi1benXjvSiNxLEL/XDfHFLvj3/ug9qRN+u31ARcUboxK
         nW8LrtVQhRtwbeCF8PZvqbOv8t5ILRgHnx1lKNnuDD/mX+uY5gttnMoePGEcE6BzU5+e
         BXkttQ7i0KkJ1BmNN+GpA+OtnqGoCoXalImtNs4NPShIQm+lAujme9V26V44tyn+2SW6
         1DI+GhFO6tc08FJcAImNEsdyUtEHLRN4ST2N2eyIvgMeDXeqmpOGtcMt9h5aY2QHbeRW
         8eih/64N2tOcETq0xixpuRK3CWbSFFbmonLw3TF6y+66ExRj2tqSLy8nSleYowEg9/31
         /Tlw==
X-Gm-Message-State: APjAAAVrAl9dFV0Yc8yBJ8j+orJ9AGIcaq+yxt8a2otpxqx3cxLJiWMR
        I8MVuXavtkVF2p/cI35souBako1+Za4s111ytDnbSg==
X-Google-Smtp-Source: APXvYqyXfsbugtAanZDp2088loLvVH2s5UB8yV4L1b1paSoVTrxPvzINkH6tA3sBFZH2mgmBf/dY/ST8Zbnh2SkPUyU=
X-Received: by 2002:a2e:2e10:: with SMTP id u16mr2325638lju.51.1572569818601;
 Thu, 31 Oct 2019 17:56:58 -0700 (PDT)
MIME-Version: 1.0
References: <20191101005127.1355-1-jakub.kicinski@netronome.com>
In-Reply-To: <20191101005127.1355-1-jakub.kicinski@netronome.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 31 Oct 2019 17:56:46 -0700
Message-ID: <CAADnVQKZbgqs3DJOsV4dtOY-ZXG8oQ7kWmJrJ_dS842qDrwABw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] Revert "selftests: bpf: Don't try to read files
 without read permission"
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        OSS Drivers <oss-drivers@netronome.com>,
        bpf <bpf@vger.kernel.org>, Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 5:51 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> This reverts commit 5bc60de50dfe ("selftests: bpf: Don't try to read
> files without read permission").
>
> Quoted commit does not work at all, and was never tested.
> Script requires root permissions (and tests for them)
> and os.access() will always return true for root.
>
> The correct fix is needed in the bpf tree, so let's just
> revert and save ourselves the merge conflict.
>
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Acked-by: Alexei Starovoitov <ast@kernel.org>
Since original commit is broken may be apply directly to net-next ?
I'm fine whichever way.
I would wait for Jiri to reply first though.
