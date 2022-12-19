Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85C13651386
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 20:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbiLST41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 14:56:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbiLST4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 14:56:17 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021935F60
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 11:56:17 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id j5-20020a5d9d05000000b006e2f0c28177so4524041ioj.17
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 11:56:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cj5G7w7wrnXTjWG4Lf9C2ODteMMiP5v7wAraEGH3U0k=;
        b=uJWdujDWAf5cXmdlZ/zT1ukhFp6YIMQiGJ4btCoGI9KnzCGucGnDmYbcU3na2gbj9/
         Bq1fV3QhsDzl30lJ0UazNLDkBn0ZhtajGlyrcqtMbDIVOIgk2BsfmnmoILjRKi3jJxz+
         BEy+Z0D6AMNL96F6DN2HUdkrxs9BksvVisLyVcamFhJzhysKkJMqqvqcwZ2g0Q2h18Qg
         fTxk2PqXgp+yi6ymOyh6WIvluJZXXQPBTl5VZDSEPAKSI2JHR1PR5iP0vZnXyruhib4p
         XXF4BJMnNLY/ZKs8R8tdrAXpM2GUxxqOEevqozVcqvWFjcz2XjB68W/OCF37oO81t3id
         e8qg==
X-Gm-Message-State: ANoB5pk6KMD3IYzftlPUj6TZ4wfY1dMbvQ/lrVBl5v3AtU8ZAZ0affPm
        pSw8H5lYIBuFddeMC6bScjrcZ5srZ8/sZuFzEk5UGvMxoF1T
X-Google-Smtp-Source: AA0mqf7eE0GC/Cb+W5QzJIxt46Tbcb3KvugY9SCOhpmm/M5g7dQmZkOk8OKjjh9bxyYHJeuaULjQLcDPviCk4OX2G41hWkxQ25I2
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:13c1:b0:303:7f25:72c with SMTP id
 v1-20020a056e0213c100b003037f25072cmr7289815ilj.221.1671479776357; Mon, 19
 Dec 2022 11:56:16 -0800 (PST)
Date:   Mon, 19 Dec 2022 11:56:16 -0800
In-Reply-To: <Y6C8iQGENUk/XY/A@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000051b79a05f033b6e5@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in put_pmu_ctx
From:   syzbot <syzbot+b8e8c01c8ade4fe6e48f@syzkaller.appspotmail.com>
To:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        bpf@vger.kernel.org, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org, sdf@google.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to apply patch:
checking file kernel/events/core.c
patch: **** unexpected end of file in patch



Tested on:

commit:         13e3c779 Merge tag 'for-netdev' of https://git.kernel...
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
dashboard link: https://syzkaller.appspot.com/bug?extid=b8e8c01c8ade4fe6e48f
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15861a9f880000

