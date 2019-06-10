Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00EB53BBBB
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 20:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbfFJSTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 14:19:07 -0400
Received: from mail-ua1-f43.google.com ([209.85.222.43]:34690 "EHLO
        mail-ua1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfFJSTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 14:19:06 -0400
Received: by mail-ua1-f43.google.com with SMTP id 7so3450214uah.1;
        Mon, 10 Jun 2019 11:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Rd7jWnbbAp4RfevQw78c7K7px6JtJUHSgmHkrc6gVU4=;
        b=NoqhzsNrSi7dYNU8yAmO1tRvsVK2jYNpAak6UvyF+UpISCg7sKKp+j/LODUeyNnGGM
         hB7/cEOSqt99ksyAvEbmXLwW8gjf7zgNTpXKPcsWgHJE4LXlXBTkZJGO863W9xk+Vfat
         bVgUYj+I5DTk0xpfsYwKEFMzHbBQ25NIZlsNGltPdj8av7Iu80Z3ZEndzt9anwoXuCJg
         w9DHDLsr4c9Shkn8cu5DWwZD9OGLwo8vPBxuBGW+Dso5njoo8SXGL4M9eyzxFV0sZd+c
         pIqDtQM6P93Q2vkFkzEs75Hx4V++tpJfhxoXy6X8hAERs+zTcnH3Ww+l4K093n0sdlZm
         G5qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Rd7jWnbbAp4RfevQw78c7K7px6JtJUHSgmHkrc6gVU4=;
        b=kAe/cL6qFoeAr8n1bnqFNTGbwblwVe3x+CaD0KysG7ckp0vKTlCG8LqnU9leE4aHpM
         WGz54vrpPqM/INDqBNcIhLuX+4yrt7pcE+VE1Xz7p5ZHhIfyqT4+FlM+WV6epUh8p8qV
         qb6MYibGtMNTvwJ+Iifn1vb7NT8BLr6hzhUt18f+gW+EYNVgszOhJgFG4ubj8FkSnNPV
         Z9sOJjjyfsUwL4AfTgnAw2P3WG88UrVPudwmud+8/i6NCZW1dfDsCAO2I1K77oGCUrMY
         r6PkOVB8s4fP5y7k7DHYHOabkMwKLTCMvNAhDELDTP1xewavc1uUzv8OxuEekJ48YzC9
         jWFA==
X-Gm-Message-State: APjAAAXfPdG0CQk3CYTYuc2AgFHglUzTMdtRRurxrElUFHt8Tm4hF3WQ
        uXJ1MY5dO7sgVOF2QCGJ/2Y=
X-Google-Smtp-Source: APXvYqyQrkANAPukJc9v5IcPa2tL2EIoyvjbdXZpPEWyXnxL8ESjiYbyJ4IvKpakUqHqBNPtNUcbQw==
X-Received: by 2002:ab0:60c4:: with SMTP id g4mr8141145uam.46.1560190745317;
        Mon, 10 Jun 2019 11:19:05 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::2:1677])
        by smtp.gmail.com with ESMTPSA id t20sm4657335vkd.53.2019.06.10.11.19.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 11:19:04 -0700 (PDT)
Date:   Mon, 10 Jun 2019 11:19:01 -0700
From:   Tejun Heo <tj@kernel.org>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+d4bba5ccd4f9a2a68681@syzkaller.appspotmail.com>,
        ast@kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org,
        daniel@iogearbox.net, hannes@cmpxchg.org, kafai@fb.com,
        linux-kernel@vger.kernel.org, lizefan@huawei.com,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: KASAN: null-ptr-deref Read in css_task_iter_advance
Message-ID: <20190610181901.GC3341036@devbig004.ftw2.facebook.com>
References: <00000000000055aba7058af4d378@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000055aba7058af4d378@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, Hillf.

On Tue, Jun 11, 2019 at 12:59:23AM +0800, Hillf Danton wrote:
> >syzbot will keep track of this bug report. See:
> >https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >
> Ignore my noise if you have no interest seeing the syzbot report.

They're awesome.

> The following tiny diff, made in the hope that it may help you perhaps
> reproduce the crash, waits css lock holders and then pick task off
> the list of dying tasks.

I already posted a fix.  Well, at least I think it's the fix.

  https://www.spinics.net/lists/cgroups/msg22468.html

Thanks.

-- 
tejun
