Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60AB25C881
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 20:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgICSLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 14:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbgICSLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 14:11:19 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAFBC061244;
        Thu,  3 Sep 2020 11:11:18 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id b16so4140579ioj.4;
        Thu, 03 Sep 2020 11:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V+GMmTFvs7s0t0FvInd/NUfaKu3dA/IzqIRbP4zlxr8=;
        b=Gb/hBa++DrX4j779VrK2yY4l3kZuH2W4sMHm9V3re2ErixJYSTFJY/BRViHuubs6xw
         snLaVDOU62y5EtXd3OJJ7959tthCMm1o1FEsdnAw8eEmliseWsVTl8xzjSrmLrsLK40n
         C48QVJHkWvSSoifiuPaDAu1abPcSOBQYLTWi9VLgFYJbLSxr29cDQr7JmzI5bsUKHhMO
         zFHBxmIE2R0ZgckOefe6ASvJ70V7Hdk29kQsHcoXMil4J7jGQeJhdQPN4SNzlt57D7/P
         mxtyNQ27UPRMn3hiN4EfM17aFK9FfoBxMtSiPPIAiZtKTYIL3Ydlp38Rg2qj7wlY+87y
         GXrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V+GMmTFvs7s0t0FvInd/NUfaKu3dA/IzqIRbP4zlxr8=;
        b=jRB2hJkv5zzzYIbNXJfx4uroEtnNVpA1Yfx0LVUhEKZO6pt8fHIDSuOf0deP7hUg7a
         BQU01seBKKs6G5qevf3OHw6nTNqiHf5LEGnzuCtizGlLb0K4cOIVS+4cBV2UW7tYO4JT
         4SFtvJTR0mh2yser5jR7+1/rNCSa0/ACP07G49b5vLQSE2GceI7pHOixWsVQfkVc8A7B
         R595Cku6Q+EbwutzQvGsQHbdH4zXqHna2+w16Lp27FxkrCFFcnrenKyhbnq1QatObnYZ
         uIAtVPAVkncXppCshtYS+D4pXeXW++wQTXQoM4Nn16CF+2Q/IVvdo6m0kyppQv826AxM
         phLg==
X-Gm-Message-State: AOAM5310JCFFIZ1+Z/ArPLflSdkEGOFDWbsPaIpPETKy3oQD8kkIbdtg
        C+C/3Pmpw8KB7rEKjuXZNeywe0FuS0ygp1VEpGjagf95smvNMw==
X-Google-Smtp-Source: ABdhPJwx8SASqRC8vWgePvaMpKXctzoeYfvxXMEy5rkbTFlXSy8Wmw5QNNgnTYv01Fvdi++VRAzpNW9TmQixG46o+BE=
X-Received: by 2002:a05:6602:2215:: with SMTP id n21mr1844583ion.44.1599156677417;
 Thu, 03 Sep 2020 11:11:17 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000014fd1405ae64d01f@google.com> <af0a0922-86cb-fcab-0aeb-a842c5c34707@gmail.com>
In-Reply-To: <af0a0922-86cb-fcab-0aeb-a842c5c34707@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 3 Sep 2020 11:11:06 -0700
Message-ID: <CAM_iQpUBL+Wadb6f7iiKLXW0v8u3Hh+JERJAa7mEN94yZi0c1w@mail.gmail.com>
Subject: Re: INFO: task hung in tcf_ife_init
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     syzbot <syzbot+80e32b5d1f9923f8ace6@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 3, 2020 at 2:47 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> This commit might be related :
>
> commit 4e407ff5cd67ec76eeeea1deec227b7982dc7f66
> Author: Cong Wang <xiyou.wangcong@gmail.com>
> Date:   Sun Aug 19 12:22:12 2018 -0700
>
>     act_ife: move tcfa_lock down to where necessary

It does not look like my commit's fault. From my _quick_ understanding
of this problem, we somehow have a "deadlock" situation:

Thread A allocates an IDR with a specific index and calls populate_metalist()
to re-accquire the RTNL lock.

Thread B gets RTNL lock right after thread A releases it, then it waits for
thread A to finally commit the IDR change.

Thanks.
