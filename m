Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEC83A67F9
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbhFNNgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbhFNNgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 09:36:22 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972EEC061766;
        Mon, 14 Jun 2021 06:34:07 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id bp38so21243163lfb.0;
        Mon, 14 Jun 2021 06:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y+VpVa/Mc1+kFCgRsz56WptJ2EZlhOZN6aWdeyarFVI=;
        b=XmuESoouVc/r6kZdVBYkje+JZAMeYXN3l+u2/CEUJmYTVI3rRrGWDATCLHlH/nMhIU
         AMb9rp/mLhgbE4wwm+vOvADqPpcDIqBVDZq7XxE398qNeKRh0Bi1tVahCS2GEXHLTecG
         iW9jF4CTmnyjHOi494BGqYZ6fsrG9dEAmh9u8b93W0UMN+6JZdUh/sh1xLljHyaStk5V
         V6fSbv1IVdlKCheWECR4shY9ltLAdpqyaBYFkoHnZDnUN/GegVZ0RHG0iNF1in9Gj35p
         n8FJeNI2PrycRv6ZzDLw/k+M7lWkyMtVyDiBTSikaTofkWSFZJ2w+8fxSXnmwEVDwBVG
         ogOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y+VpVa/Mc1+kFCgRsz56WptJ2EZlhOZN6aWdeyarFVI=;
        b=MqGUbYLRek34gVhU/bamnm24pm2T6pLVv9SFRPf1WJxFXiVNxs+oVGXSBtnz3X3/Jz
         Ola37a6gRsQjYYoYJ16lL3AyR+Xva5B4F4bSD8ti8lQF9ERPYYYOhNp6j7EN2051+5/p
         T7GTO3B/1VQl66YXXRJCj+wTvhi/0CgU3+D8dI5u7N/koz4xZAo/hMIeifRKKD3TdTQ7
         VkdHWBBCx7/0zS83vm/alovGtF0q8IxdkDl/kn+1YomRtr1JSmZdmP6ujBPuY4g6xFY4
         e6RffC7HUhP2Pii/mh3gSnX4zNWzM+hibs2lFh4BxeDLUmK3sOAmZyqGpjMqskSswIZL
         fsfA==
X-Gm-Message-State: AOAM530n1QAFmWS7EQjD0PoKzbVC+62enKVbAaU6IYMmiNVkKYya873o
        Lb9BBwpOkOeTWZZLADNyuaM=
X-Google-Smtp-Source: ABdhPJyAEIRZ7T8Bcy7B3MxB9ivA7zWCG4wfzOrjH8mWXFik1quzXUsOomybWlj9iwugKVYc7WzhnQ==
X-Received: by 2002:a05:6512:3d8f:: with SMTP id k15mr12457575lfv.362.1623677645915;
        Mon, 14 Jun 2021 06:34:05 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.24])
        by smtp.gmail.com with ESMTPSA id w24sm1486513lfl.123.2021.06.14.06.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 06:34:05 -0700 (PDT)
Date:   Mon, 14 Jun 2021 16:34:01 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     alex.aring@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        stefan@datenfreihafen.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzbot+b80c9959009a9325cdff@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Suggestions on how to debug kernel crashes where printk and gdb
 both does not work
Message-ID: <20210614163401.52807197@gmail.com>
In-Reply-To: <CAD-N9QUUCSpZjg5RwdKBNF7xx127E6fUowTZkUhm66C891Fpkg@mail.gmail.com>
References: <CAD-N9QUUCSpZjg5RwdKBNF7xx127E6fUowTZkUhm66C891Fpkg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Jun 2021 21:22:43 +0800
Dongliang Mu <mudongliangabcd@gmail.com> wrote:

> Dear kernel developers,
> 
> I was trying to debug the crash - memory leak in hwsim_add_one [1]
> recently. However, I encountered a disgusting issue: my breakpoint and
> printk/pr_alert in the functions that will be surely executed do not
> work. The stack trace is in the following. I wrote this email to ask
> for some suggestions on how to debug such cases?
> 
> Thanks very much. Looking forward to your reply.
> 

Hi, Dongliang!

This bug is not similar to others on the dashboard. I spent some time
debugging it a week ago. The main problem here, that memory
allocation happens in the boot time:

> [<ffffffff84359255>] kernel_init+0xc/0x1a7 init/main.c:1447

and reproducer simply tries to
free this data. You can use ftrace to look at it. Smth like this: 

$ echo 'hwsim_*' > $TRACE_DIR/set_ftrace_filter

would work.


With regards,
Pavel Skripkin
