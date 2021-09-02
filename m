Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E261A3FEF09
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 15:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345338AbhIBN7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 09:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235635AbhIBN7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 09:59:42 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20420C061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 06:58:44 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id r7so3049244edd.6
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 06:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NXEJdGninkBdVtpXQoG13dqQs8Qs+Jfbydk0oWk896M=;
        b=Nls/IV4MSQuu3HJFeiLRnplV4yq96ldDKDyz8BGmf/lYykqGly+V3DRC3aYr81i/4N
         LA8f7+nfAe3DgnlL6YnyXMLM0X2nWRa1jTXj9S7k4HaCGpzBmjzlufRQp7rx14D44QEJ
         CbD1NjZyH1P70Ts8g1Ss/+n6oGegK5PPgrK3azF9ItKkUSY00LwjPdkrDDHn7JW4vVw6
         8TfUn0jeZTy1CgPPB2E02YpgD3JfZ+nJaPnxf+C/N/cEoPasKqabw2YB/bch4ytIWFkA
         I29vWhap8RtKiU/PsrV5ikjOjgrRlWrljWQ0l1YH6JZyv+IPy1xEeZvxiseu+Gm2NNxy
         gFow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NXEJdGninkBdVtpXQoG13dqQs8Qs+Jfbydk0oWk896M=;
        b=FgWCASIY7OoP0xOQaPqYYpS3R1+2st2i2T9jAhWCwTDs8Im8eSgO2Z7gY1lVlUZaJ2
         7kGIicfi5+jN8j0/CcCGXea1ih5cSramOuDFkJ7L077W6U2K0yRiEFkjjZ0k5N173LcQ
         1Mv8b77s3y5N1JKqWpsDthkD513upOLgry/5txL0dKXBiaZBPrj+oiiboz4O+x05dZ9h
         9FxFjs5Mq8QrakWeADsBYjpcw3yq0+EHUEK/ccJoiD3b84QYPT1woilF7tA8JtFhQMax
         NRfORgnZOjiAy4ok+ssXIV4HLtAKaPydGNs1gqNc+viFwFQtsxSK1HaZ4HsCoySieqDm
         JSdQ==
X-Gm-Message-State: AOAM532kxIB9NIZEAeDFdmpvpPP8ElmpZouROYDYLzPiGs1Jiguw2f5e
        3xCnYtnY+uP8FqsWqNxIHahXcCT/vamD1/MW3DCu
X-Google-Smtp-Source: ABdhPJw6QC4FMVNA86SoALbyyyEG6UMKskge2SDZ8noyZveyOk2NS6c2yrsdp8J/q7V+M4RSUyJzH5IVh/rven6EEo0=
X-Received: by 2002:aa7:d613:: with SMTP id c19mr3671822edr.196.1630591122604;
 Thu, 02 Sep 2021 06:58:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210902005238.2413-1-hdanton@sina.com> <0000000000002d262305caf9fdde@google.com>
 <20210902041238.2559-1-hdanton@sina.com>
In-Reply-To: <20210902041238.2559-1-hdanton@sina.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 2 Sep 2021 09:58:33 -0400
Message-ID: <CAHC9VhQBX8SsKBDHJGSyNC_Ewn3JgWK1_VixK48V8FRi7Tf=pA@mail.gmail.com>
Subject: Re: [syzbot] WARNING: refcount bug in qrtr_node_lookup
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+c613e88b3093ebf3686e@syzkaller.appspotmail.com>,
        bjorn.andersson@linaro.org, dan.carpenter@oracle.com,
        eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        manivannan.sadhasivam@linaro.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 2, 2021 at 12:13 AM Hillf Danton <hdanton@sina.com> wrote:
> On Wed, 01 Sep 2021 19:32:06 -0700
> >
> > syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> > UBSAN: object-size-mismatch in send4
> >
> > ================================================================================
> > UBSAN: object-size-mismatch in ./include/net/flow.h:197:33
> > member access within address 000000001597b753 with insufficient space
> > for an object of type 'struct flowi'
> > CPU: 1 PID: 231 Comm: kworker/u4:4 Not tainted 5.14.0-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Workqueue: wg-kex-wg0 wg_packet_handshake_send_worker
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:88 [inline]
> >  dump_stack_lvl+0x15e/0x1d3 lib/dump_stack.c:105
> >  ubsan_epilogue lib/ubsan.c:148 [inline]
> >  handle_object_size_mismatch lib/ubsan.c:229 [inline]
> >  ubsan_type_mismatch_common+0x1de/0x390 lib/ubsan.c:242
> >  __ubsan_handle_type_mismatch_v1+0x41/0x50 lib/ubsan.c:271
> >  flowi4_to_flowi_common include/net/flow.h:197 [inline]
>
> This was added in 3df98d79215a ("lsm,selinux: pass flowi_common instead of
> flowi to the LSM hooks"), could you take a look at the UBSAN report, Paul?

Sure, although due to some flooding here at home it might take a day
(two?) before I have any real comments on this.

-- 
paul moore
www.paul-moore.com
