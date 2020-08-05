Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF6123CD52
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 19:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgHERXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 13:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728497AbgHERQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 13:16:43 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275AEC06174A;
        Wed,  5 Aug 2020 10:16:43 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id r4so14989193pls.2;
        Wed, 05 Aug 2020 10:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=09YSKPP7Cq8VsV0IMBuxAsBm/yvKaFDSCahx4z1NFcQ=;
        b=tqO0M2IBSkDzDHxoQDOnAATXSwqNxm90XEEAkKpFztXTwlqlHWOmv+BXv3Sa/F0jHh
         /vpnLYSxSaj65tJfLmXqL7YNzX6DVxWM+NahlBxARrOUn5AbVv5ZbcEbTv2DLpHdBgi6
         BvQhl13guAvmywkJ1hVNSuTK3j9oqw82tsFv+NblXgQyPJeWFL0S/velRw7rfNPtSN+0
         Tgfsxz8lTfrxFoPy/+CVveRihaC/P17OpZJmOV4LoxkIOC/5a4SWqfQ6rHnCGWNXtL/H
         Of6WGeC40kASrNllKhkSozfyBGoKnUB7Rx+WGuclFS/u+0RQd/8MC+y1tdL53+NH9Cm6
         HC0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=09YSKPP7Cq8VsV0IMBuxAsBm/yvKaFDSCahx4z1NFcQ=;
        b=AayXoPbbgsOvbdpffm97368955qIMRmjiF0V0UyEQSwk1oF9lFPJKAq9w5N2OI3vu6
         /GMdshFvUu1Xs4nPjjDnt2Tupogv/mri4cDOrUCrmxvFXVXBEFIr4pBIluL5DLf05cKj
         WxDmWTdJdDHSa3WH0i2vY47SdcKqOQjQckvhAi45VRC0GDI9b4dsDhb8UK4eVzmkAf3x
         P1uiydahjPle+xnVaaclEPg+smef7QQLSxmytIAh6sUUcKvKyT0fp1A1EkvJPubLIeVy
         +2OKRzUtSYeHqfCV+LnItFRCJUZ/YuFzIxzENK0MNVStn6eOrKwOC0pkjWu3J+W1aTSY
         vz8w==
X-Gm-Message-State: AOAM532/TGRn7WT/arfSF9XWi8zHAMOHtpJs28HQvxRxfXmaS34M7GKh
        PPUDdZoEVFT0KhJn07jvn/Q=
X-Google-Smtp-Source: ABdhPJwUGn9rRBdEQrMwQQSOgL4hqeAra8KQU6l7Yc00ExdaONKgUZjxB5Gl9xdQLixur2v9izy6Ig==
X-Received: by 2002:a17:90b:154:: with SMTP id em20mr4496017pjb.173.1596647802631;
        Wed, 05 Aug 2020 10:16:42 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:16b0])
        by smtp.gmail.com with ESMTPSA id np4sm3957912pjb.4.2020.08.05.10.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 10:16:41 -0700 (PDT)
Date:   Wed, 5 Aug 2020 10:16:39 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Xu <dlxu@fb.com>
Subject: Re: [PATCH bpf-next 5/5] selftests/bpf: add benchmark for uprobe vs.
 user_prog
Message-ID: <20200805171639.tsqjmifd7eb3htou@ast-mbp.dhcp.thefacebook.com>
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-6-songliubraving@fb.com>
 <CAEf4BzaP4TGF7kcmZRAKsy=oWPpFA6sUGFkctpGz-fPp+YuSOQ@mail.gmail.com>
 <DDCD362E-21D3-46BF-90A6-8F3221CBB54E@fb.com>
 <CAEf4BzY5RYMM6w8wn3qEB3AsuKWv-TMaD5NVFj=YqbCW4DLjqA@mail.gmail.com>
 <7384B583-EE19-4045-AC72-B6FE87C187DD@fb.com>
 <CAEf4BzaiJnCu14AWougmxH80msGdOp4S8ZNmAiexMmtwUM_2Xg@mail.gmail.com>
 <AF9D0E8C-0AA5-4BE4-90F4-946FABAB63FD@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AF9D0E8C-0AA5-4BE4-90F4-946FABAB63FD@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 04:47:30AM +0000, Song Liu wrote:
> 
> Being able to trigger BPF program on a different CPU could enable many
> use cases and optimizations. The use case I am looking at is to access
> perf_event and percpu maps on the target CPU. For example:
> 	0. trigger the program
> 	1. read perf_event on cpu x;
> 	2. (optional) check which process is running on cpu x;
> 	3. add perf_event value to percpu map(s) on cpu x. 

If the whole thing is about doing the above then I don't understand why new
prog type is needed. Can prog_test_run support existing BPF_PROG_TYPE_KPROBE?
"enable many use cases" sounds vague. I don't think folks reading
the patches can guess those "use cases".
"Testing existing kprobe bpf progs" would sound more convincing to me.
If the test_run framework can be extended to trigger kprobe with correct pt_regs.
As part of it test_run would trigger on a given cpu with $ip pointing
to some test fuction in test_run.c. For local test_run the stack trace
would include bpf syscall chain. For IPI the stack trace would include
the corresponding kernel pieces where top is our special test function.
Sort of like pseudo kprobe where there is no actual kprobe logic,
since kprobe prog doesn't care about mechanism. It needs correct
pt_regs only as input context.
The kprobe prog output (return value) has special meaning though,
so may be kprobe prog type is not a good fit.
Something like fentry/fexit may be better, since verifier check_return_code()
enforces 'return 0'. So their return value is effectively "void".
Then prog_test_run would need to gain an ability to trigger
fentry/fexit prog on a given cpu.
