Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1875A1C72E8
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 16:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgEFOdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 10:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728357AbgEFOdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 10:33:54 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14733C061A10
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 07:33:54 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id i16so1083224ybq.9
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 07:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XbqSj0zLlZxwhc6FbfH4AgPdBJNe+u7Ez5XFOAJ4dlE=;
        b=sMK2gxKz00XlJrqT2IQRh3RVnLny1lQB0H+zg4sYGFloaiAo/v9DJLCWh3yavgGR9t
         c9UH85bbgwNnZ8rYaAmhkL9RXQ0ojcvHwdGPEORoemyMdhnQh1F34HjrbRUWcPnC06if
         XXQz6FU/rVCvlSYCU7ys0+0E0Twdld4F+lZM4DENbx1STo8XrEe+V2fdFnCkStrpVY/p
         AtTCq68fOOYR2goQGPNTKBBoBU+ce30sIhhZuhLPmFihWqnJd1lOneugUIJwibLPGWmh
         wHKs3CJjA3fRLTTjL74ocbYlbKhUsFm/Mv/m6kMUuQOJXTxOg2QqsPJd/cn1IoG3HMml
         gn/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XbqSj0zLlZxwhc6FbfH4AgPdBJNe+u7Ez5XFOAJ4dlE=;
        b=bEQRYttHrXm23PHcWrJdWqlGqwncjlvcGRfPoEzLpAVP0adXnju1vNDOyXYi753ucn
         INLZAM6iMFhraoL1AfuP2eh6QVyZyxlD0NHQ/uWr1psASbGY0lFYU9N3UdjGyt92q7wf
         PFypGX7TrUDwUf9Fy33Zt5isfKKtoRon62rK1iRkWqo2O8iWpuNl052o7fhNdarIpsPh
         rbbwbARp0sf0BF0ZigBSYSL5GOVVRrNLpY4AMc+Q4W+jafzpZKQ55El9M5skSDea1A23
         ZgMjcXzZu+Q1k9kcGZ9OsT4MDRpCYCTWcVlYBIShWXYde71ULJVKN42sd3VTl1Irh7mH
         dI5A==
X-Gm-Message-State: AGi0Pubrspde1IgIxW3yDGf5an251nNfWQVnbQQvjhZKWSMNkacIxbeM
        wo/mHKwUZMfqOvU9fUCVK5iMG5UW82qtSqlqnNBpRw==
X-Google-Smtp-Source: APiQypLa55+6CY2rDCiL0pAlUnndI/LxWB5VFYnf5D/Y4Vob6Fja7SVSAFXSw3DhrjJqMzyBFM1EmuD9ZAmaq6mtXSQ=
X-Received: by 2002:a25:bc53:: with SMTP id d19mr13792238ybk.395.1588775632988;
 Wed, 06 May 2020 07:33:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200505184955.GO2869@paulmck-ThinkPad-P72> <20200506125926.29844-1-sjpark@amazon.com>
In-Reply-To: <20200506125926.29844-1-sjpark@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 6 May 2020 07:33:41 -0700
Message-ID: <CANn89iL2ZRa9CtypuZXL_+aGQmiqxP9q7eutozJ6G8b=QWjZKw@mail.gmail.com>
Subject: Re: Re: Re: Re: Re: [PATCH net v2 0/2] Revert the 'socket_alloc' life
 cycle change
To:     SeongJae Park <sjpark@amazon.com>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sj38.park@gmail.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>, snu@amazon.com,
        amit@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 5:59 AM SeongJae Park <sjpark@amazon.com> wrote:
>
> TL; DR: It was not kernel's fault, but the benchmark program.
>
> So, the problem is reproducible using the lebench[1] only.  I carefully read
> it's code again.
>
> Before running the problem occurred "poll big" sub test, lebench executes
> "context switch" sub test.  For the test, it sets the cpu affinity[2] and
> process priority[3] of itself to '0' and '-20', respectively.  However, it
> doesn't restore the values to original value even after the "context switch" is
> finished.  For the reason, "select big" sub test also run binded on CPU 0 and
> has lowest nice value.  Therefore, it can disturb the RCU callback thread for
> the CPU 0, which processes the deferred deallocations of the sockets, and as a
> result it triggers the OOM.
>
> We confirmed the problem disappears by offloading the RCU callbacks from the
> CPU 0 using rcu_nocbs=0 boot parameter or simply restoring the affinity and/or
> priority.
>
> Someone _might_ still argue that this is kernel problem because the problem
> didn't occur on the old kernels prior to the Al's patches.  However, setting
> the affinity and priority was available because the program received the
> permission.  Therefore, it would be reasonable to blame the system
> administrators rather than the kernel.
>
> So, please ignore this patchset, apology for making confuse.  If you still has
> some doubts or need more tests, please let me know.
>
> [1] https://github.com/LinuxPerfStudy/LEBench
> [2] https://github.com/LinuxPerfStudy/LEBench/blob/master/TEST_DIR/OS_Eval.c#L820
> [3] https://github.com/LinuxPerfStudy/LEBench/blob/master/TEST_DIR/OS_Eval.c#L822
>
>
> Thanks,
> SeongJae Park

No harm done, thanks for running more tests and root-causing the issue !
