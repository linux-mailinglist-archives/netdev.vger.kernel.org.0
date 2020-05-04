Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FBA1C416F
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730352AbgEDRLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730076AbgEDRLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:11:45 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD740C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 10:11:44 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id t11so10419224lfe.4
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 10:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ixzEtMiXaF/qz/KekxraCygM8Jiomf7VZjOVAfNWf6o=;
        b=eeaN8etLnIL/QFNqWHl/zogdftIj/e6LccItgF5ZbbaOs17zN0noNQCEp6rlPW4oNx
         xMMFrHE1kN99Bq3heBUNZBuIpbfzvFUmlqAWH9DarrBA2YOHAR8H6GUiOXp2BWV9gWjK
         VS6u/zPR6u6bslVlDc9X5Q2VbFFOK3/0JD+leo5QCQA0ILDkvLVtseq0vfLH2DoxlJvx
         EC9HfcIcMa+RxXY/TmVMJz2LeM6cHTUfvDHuSpoyjuBSRojswnkUzVXX4vCkljKBj8i4
         OWoVb7L9UEO2tV/IGvgYXSCTwnfSMhfnq9yqc/icW6tzpAJCI7TNusYkHrWEpBOKNWVJ
         psbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ixzEtMiXaF/qz/KekxraCygM8Jiomf7VZjOVAfNWf6o=;
        b=INoQZcLBrO+032LCMHMAbJommx3taoDZH5h4nQTSmvfpnxKYCmFfcclOs/rkdMEGSP
         4LDPNruZkN0Dv7b7K9NpW+d/M3oBkAkR9GumRGedUoj+6qGaDDVkVvp4AYdghzxoLOjC
         ebYemK3STZ7MUoYIYXZwMLHrnDl7gv2V1kcSYj3DOMADbYAkeJAzdY5aRwiHxk/PYZO0
         lIL/oB4gYbxD1dDMsj3XF8GwRpX7+ffP6e8o+9K1V30Qxuc0VXF2YlhQb0WT9EsGUeIY
         TI2Zk2KdoyGSQutkNLBhNddNSsfDplGcpMCXRbXrSZvEillm6BzNxZ5pgV5xB5cfGLYR
         8JfQ==
X-Gm-Message-State: AGi0PuZihOEewMk8KNQZFYnGHkz/Y3uhbhRQyR9IS+AWSoF43r+3X3CR
        YvE7tEGajiseaxGe0P1pHQyc/y9WKnZCv1esbZS/zhmF
X-Google-Smtp-Source: APiQypKc1omnphI6WLyvU5+jop5OY05TJyNWaGxPBgWKxNwhDNF5yLKbvzHvI4+yRncVphs1v76ybDfWO2AiSBAwCQg=
X-Received: by 2002:ac2:4248:: with SMTP id m8mr12396502lfl.211.1588612303343;
 Mon, 04 May 2020 10:11:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200503052220.4536-1-xiyou.wangcong@gmail.com> <20200503052220.4536-2-xiyou.wangcong@gmail.com>
In-Reply-To: <20200503052220.4536-2-xiyou.wangcong@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Tue, 5 May 2020 02:11:31 +0900
Message-ID: <CAMArcTVQO8U_kU1EHxCDsjdfGn-y_keAQ3ScjJmPAeya+B8hHQ@mail.gmail.com>
Subject: Re: [Patch net-next v2 1/2] net: partially revert dynamic lockdep key changes
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        syzbot <syzbot+aaa6fa4949cc5d9b7b25@syzkaller.appspotmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 3 May 2020 at 14:22, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>

Hi Cong,
Thank you for this work!

> This patch reverts the folowing commits:
>
> commit 064ff66e2bef84f1153087612032b5b9eab005bd
> "bonding: add missing netdev_update_lockdep_key()"
>
> commit 53d374979ef147ab51f5d632dfe20b14aebeccd0
> "net: avoid updating qdisc_xmit_lock_key in netdev_update_lockdep_key()"
>
> commit 1f26c0d3d24125992ab0026b0dab16c08df947c7
> "net: fix kernel-doc warning in <linux/netdevice.h>"
>
> commit ab92d68fc22f9afab480153bd82a20f6e2533769
> "net: core: add generic lockdep keys"
>
> but keeps the addr_list_lock_key because we still lock
> addr_list_lock nestedly on stack devices, unlikely xmit_lock
> this is safe because we don't take addr_list_lock on any fast
> path.
>
> Reported-and-tested-by: syzbot+aaa6fa4949cc5d9b7b25@syzkaller.appspotmail.com
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Taehee Yoo <ap420073@gmail.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Acked-by: Taehee Yoo <ap420073@gmail.com>

Thank you,
Taehee Yoo
