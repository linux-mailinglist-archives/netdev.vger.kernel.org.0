Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664AD4EEE99
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 15:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346568AbiDAN4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 09:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346557AbiDAN4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 09:56:48 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA141DE6F3
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 06:54:59 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id v35so5100222ybi.10
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 06:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RTRXw+jgIWbLNHXOv9v+56Mv+zUPD6iW+b0omSppcHw=;
        b=FZ3K9XHmNes7RLB8Fkt+C0d0UO301AbdRo3mNmfLXK4LI5+Zm/7L7Z6iUg3RVJTEer
         iCVvoYnwcEQaFFx80WkeJ/q7xNQpiqMV+LZ/gQ0UuQgC/jCql9UGB4TYP1LYYQCtbC2O
         NvE5O1UTzh5i1Ce8w02ymOL2AZx/B00AUQf3F9tJ0MoaDKt2pSRC+SYkMcQu9l7fcOjD
         kC1wk6BAaBDvcntpfgq+QSoPBhx3vI1QO4oJs3ZkdiXZST458O1Bm7soAGjQy+mRACN2
         nBqafY1ExTSxCzTnLD9m5MMfU6DFbv3kXZePCQQGCSzTV0ScOeLRPcgjS/x/DfcjSBxK
         3Kyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RTRXw+jgIWbLNHXOv9v+56Mv+zUPD6iW+b0omSppcHw=;
        b=li0QDuw9B1ekZUztSRHnRaNrNLntqBl9tQPdlmbcx1J0q5crU6s1XhY4EROjxFA/9Q
         S6shragDn72/MzrKtdECzPUUf8SwEpx2bwTJaMz8YS0v9lRx16t1WvX+9hVn1Gc0t3pM
         vuOKA+ZRVpzEU94scOHH6eJp9JmO3dOT1lP/w3SEh+y1fP9gx2cFHENY1z9i1+FYpPXa
         CJHWW+zBFGDEpdGOqOv/GntoWfsRYox8DiOknR1egXyXT7W4WQsrgi31DWQ/A7emZLqK
         3ILo8ANdavmNN9sqpLEbYlad0sVnv7sZ8UBQSmdcFQakQKyDGkhkFAduQuoAIl159JbZ
         aAFQ==
X-Gm-Message-State: AOAM530Y88xTui3gXsDgcS8Z2FsdiRk2OLIlXD/fvS0KXia7cBaiR+8n
        Xdht7yxS4ZUaS7W3s7Z0ixyEgEnGv1mdIbPJTFiJGw==
X-Google-Smtp-Source: ABdhPJyhnaWjscK1FH7yecMTp/D05/vVfyJXpOdWBCPPcWESkr61dGx7YUpnk/Q05YzLYJSdtOBgbNw3XNnSir0REio=
X-Received: by 2002:a25:4003:0:b0:633:8ab5:b93e with SMTP id
 n3-20020a254003000000b006338ab5b93emr8738001yba.387.1648821298015; Fri, 01
 Apr 2022 06:54:58 -0700 (PDT)
MIME-Version: 1.0
References: <E1nZMdl-0006nG-0J@plastiekpoot> <CADVnQyn=A9EuTwxe-Bd9qgD24PLQ02YQy0_b7YWZj4_rqhWRVA@mail.gmail.com>
 <eaf54cab-f852-1499-95e2-958af8be7085@uls.co.za> <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
 <10c1e561-8f01-784f-c4f4-a7c551de0644@uls.co.za> <CADVnQynf8f7SUtZ8iQi-fACYLpAyLqDKQVYKN-mkEgVtFUTVXQ@mail.gmail.com>
 <e0bc0c7f-5e47-ddb7-8e24-ad5fb750e876@uls.co.za> <CANn89i+Dqtrm-7oW+D6EY+nVPhRH07GXzDXt93WgzxZ1y9_tJA@mail.gmail.com>
 <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com>
 <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za> <CANn89i+KsjGUppc3D8KLa4XUd-dzS3A+yDxbv2bRkDEkziS1qw@mail.gmail.com>
 <4b4ff443-f8a9-26a8-8342-ae78b999335b@uls.co.za> <CANn89iL203ZuRdcyxh16yKXqxXJW2u+4559DsDFmW=8S+_n7fg@mail.gmail.com>
 <CANn89i+6LCWOZahAi_vPf9H=SKw-4vdMTj5T0dYsp1Se4g9-yw@mail.gmail.com> <628a909d-1090-dc62-a730-fd9514079218@uls.co.za>
In-Reply-To: <628a909d-1090-dc62-a730-fd9514079218@uls.co.za>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 1 Apr 2022 06:54:46 -0700
Message-ID: <CANn89iL38aCi4TWMePFwHDbUzJgV+mGEVMVukx8Z636EPCWEag@mail.gmail.com>
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP connections
To:     Jaco Kroon <jaco@uls.co.za>
Cc:     Neal Cardwell <ncardwell@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 1, 2022 at 4:36 AM Jaco Kroon <jaco@uls.co.za> wrote:
>
> Hi Eric,
>
> On 2022/04/01 02:54, Eric Dumazet wrote:
> > On Thu, Mar 31, 2022 at 5:41 PM Eric Dumazet <edumazet@google.com> wrote:
> >> On Thu, Mar 31, 2022 at 5:33 PM Jaco Kroon <jaco@uls.co.za> wrote:
> >>
> >>> I'll deploy same on a dev host we've got in the coming week and start a
> >>> bisect process.
> >> Thanks, this will definitely help.
> > One thing I noticed in your pcap is a good amount of drops, as if
> > Hystart was not able to stop slow-start before the drops are
> > happening.
> >
> > TFO with one less RTT at connection establishment could be the trigger.
> >
> > If you are still using cubic, please try to revert.
> Sorry, I understand TCP itself a bit, but I've given up trying to
> understand the various schedulers a long time ago and am just using the
> defaults that the kernel provides.  How do I check what I'm using, and
> how can I change that?  What is recommended at this stage?

How to check: cat /proc/sys/net/ipv4/tcp_congestion_control"

This is of course orthogonal to the buf we are tracking here,
but given your long RTT, I would recommend using fq packet scheduler and bbr.

tc qd replace dev eth0 root fq   # or use mq+fq if your NIC is multi
queue and you need a good amount of throughput

insmod tcp_bbr   # (after enabling CONFIG_TCP_CONG_BBR=m)
echo bbr >/proc/sys/net/ipv4/tcp_congestion_control


> >
> >
> > commit 4e1fddc98d2585ddd4792b5e44433dcee7ece001
> > Author: Eric Dumazet <edumazet@google.com>
> > Date:   Tue Nov 23 12:25:35 2021 -0800
> >
> >     tcp_cubic: fix spurious Hystart ACK train detections for
> > not-cwnd-limited flows
> Ok, instead of starting with bisect, if I can reproduce in dev I'll use
> this one first.

Thanks ! (again this won't fix the bug, this is really a shoot in the dark)
