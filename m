Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82CD04FAC39
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 08:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbiDJGLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 02:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiDJGLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 02:11:19 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860647667;
        Sat,  9 Apr 2022 23:09:10 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id s137so8707485pgs.5;
        Sat, 09 Apr 2022 23:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=X5O6qklI6QLlb6LyGFLJ9U+yqHok8sHb1WOi5Ydjjzk=;
        b=UA2DA7wN7jwJf8u6D6hGuyRk1/Oik5A2zeaS/timbOB8sFGy60lViqFJX2HQIWiGc6
         8xfPU+O8b1GKZomntCj3tCzzDOBuT2rMoMG1SrspMly6y9qIfN4V8NPNUEKp/s3vKFLQ
         i7KSFdQqk0oRdTqQ5hZgXHCVmV0SOMGgOLcTd9Qm7exE+FnitVud7qDb+tF/U9+aougt
         wgLccQGeiHuxng+viugCaQ/zDRjJQdzrOesiyAwqFDqj+9tj6poBzbkrJ959OwacwFNR
         TMEASxuwUY/+X7ZKDN2owF0mWU4vvElk7zjhW8okHn586JrjsvPZLY+1OV9GfU0M8r7Z
         swlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=X5O6qklI6QLlb6LyGFLJ9U+yqHok8sHb1WOi5Ydjjzk=;
        b=YbUBBSnUqmwcH60WHAhdmawSisA3xZcPwuzrmxb2ZaxZDhoZ11QQ8DpVrFK67xhGHz
         dghZBvbgP+1/HxTvKFhUO6SkYDoAPw5AMGCAweoBnr3rRf+J2L/dApRldI1ekfHc+L2s
         d0j7bF1H+55l3mCae2pBXC/vaMygGQAbyE9os9WLK0AYhoPyL8R9z489RZMDlbT1PZ0a
         I+mcqbyznkRXJ42Iz0cHXjC7YEIPVu/dWg1LmVqvoZTylRYJmSUJ4g+YRYPGtOjciY8x
         WtmNePmwvuJ1Lbpdh9cT5OSLMl2kpZcxCyXnp/qbbnq6jBFvoRbD9tM+7KSSdkEE0VAp
         aMsg==
X-Gm-Message-State: AOAM533SXcnbwod2VM0BBC12E89LxJ9LSOkTwGuMPvB7ihO9Yd4duuAz
        yZvvRfEbLE4IZSOolKabJ0mztC3P6QeV14PUrjg2zGGJ5QxZt9M=
X-Google-Smtp-Source: ABdhPJyrEFXEzmWKC0IE0oJktQtD3GUKBUm6HgxCusZ/kfMhsYsw/eaflIzEowoijG6FKXqulUsYlnnMwVonQJAniwY=
X-Received: by 2002:a63:ce45:0:b0:399:1124:fbfe with SMTP id
 r5-20020a63ce45000000b003991124fbfemr22282846pgi.542.1649570949975; Sat, 09
 Apr 2022 23:09:09 -0700 (PDT)
MIME-Version: 1.0
From:   Zheyu Ma <zheyuma97@gmail.com>
Date:   Sun, 10 Apr 2022 14:08:56 +0800
Message-ID: <CAMhUBjnAeLsZmhOmJnbnrqQNJn=i4Xx6P4iwh0YKW9gUM9U+KA@mail.gmail.com>
Subject: [BUG] ptp: ocp: Warning when the ptp_ocp driver fails to probe
To:     richardcochran@gmail.com, jonathan.lemon@gmail.com
Cc:     netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I found a bug in the ptp_ocp driver.
When the ptp_ocp driver fails to probe at the function
ptp_clock_register(), we will get the following splat:

[    3.354719] ptp_ocp 0000:00:05.0: clock not enabled
[    3.355127] ptp_ocp 0000:00:05.0: Could not register (null): err -19
[    3.358800] ------------[ cut here ]------------
[    3.359200] sysfs group 'gen1' not found for kobject 'ocp0'
[    3.359671] WARNING: CPU: 6 PID: 256 at fs/sysfs/group.c:280
sysfs_remove_group+0x9f/0x220
[    3.366602] RIP: 0010:sysfs_remove_group+0x9f/0x220
[    3.375709] Call Trace:
[    3.375920]  <TASK>
[    3.376119]  ptp_ocp_detach+0x117/0xe60 [ptp_ocp]
[    3.376568]  ptp_ocp_probe+0xb1f/0x1830 [ptp_ocp]
[    3.376967]  ? rcu_read_lock_sched_held+0x2f/0x70
[    3.377379]  ? lockdep_hardirqs_on_prepare+0x347/0x620
[    3.377810]  ? _raw_spin_unlock_irqrestore+0x2d/0x60
[    3.378277]  ? lockdep_hardirqs_on+0x7b/0x100
[    3.378646]  ? _raw_spin_unlock_irqrestore+0x3d/0x60
[    3.379063]  ? ptp_ocp_i2c_notifier_call+0x1c0/0x1c0 [ptp_ocp]
[    3.379558]  pci_device_probe+0x40e/0x8d0

Regards,
Zheyu Ma
