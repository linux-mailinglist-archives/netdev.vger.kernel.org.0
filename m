Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 692E356628D
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 06:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiGEE7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 00:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGEE7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 00:59:41 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE65BC02;
        Mon,  4 Jul 2022 21:59:40 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q82so3249686pgq.6;
        Mon, 04 Jul 2022 21:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qfnX+ERB9BGD1FSxfWo8C5WVWTr9j0KzyIVwQielrBY=;
        b=C4E595EbYpg6Wy3cVUItkjNufxZ8CoTfOKXvo4XyMkiGFCjsZ4+mnzTbcwgmMm5ys7
         5QFGRAJgkDXyBvxvw2MsJfXKZSwZ3CDjsOIoYYkp5WrmwCT8kxo1GPsOPh/SjuPZJQqD
         lcNMxA/WtdezUHp0PRwR+/FenCkjMmua9h0IKkPhZHpWj/tWbcFp2oJ01JqI52SJVhlz
         CEsEYl5qSiElInL60T56WviA6UN6XniPaNAjmOlbtjz0BAHXLaXx5rW3uAB6MVH/LrTJ
         gQjD1/ND40tMx/FvXHNlshx52Xk2jLmt/P4GSG5xcJRYQT1pDJAf7gzmLqrjVucD3uKu
         Rj0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qfnX+ERB9BGD1FSxfWo8C5WVWTr9j0KzyIVwQielrBY=;
        b=R1WeXs5QYO1XWuRa9zAahAO0cxaUN8mse33gpac+3Lh+aZyThetJNwuXJGxE+mC8I2
         usTDxVxVDI8NqJQrrD16ecNkYRmWIQEz7Md+6MIGgLoEKu15r6tSa6QmUaELOjAIL4XF
         8PB2Oy6hXmWHmcov9INWjet/RJWalMJy9eOlP4/8vORY0QqfcJZNmuRVK12niTXFM1oY
         t3LXOo5avczcsu/mci5oYtYc8GurpvtxFnqpodhoBqxbyhfrO3CY9JsH1jknYcvIzRb0
         5CRaxTh2BpiIRpVkOZXltf8q/NxFZpuKpoIYQvy8rZMeo+mA5Pt8Aa9pI3XFHzSdPEWb
         MXUA==
X-Gm-Message-State: AJIora98hQzfz9h8uSaOTxheQ4IXO8ObabWLa0ca0wZMxqn22DifmQ/e
        libElozcNeXhNsd85HB7Qzbs/NLh8Qb9fA==
X-Google-Smtp-Source: AGRyM1u19Dk1iBAD0qS21FTRYfRud95dlLy3UXG+hoj+0YqYR3ShunFkKSaw6VyrLxbvZoVC5Mw3ng==
X-Received: by 2002:a65:49c5:0:b0:412:6e3e:bd91 with SMTP id t5-20020a6549c5000000b004126e3ebd91mr2220208pgs.221.1656997179826;
        Mon, 04 Jul 2022 21:59:39 -0700 (PDT)
Received: from Negi ([68.181.16.243])
        by smtp.gmail.com with ESMTPSA id t17-20020a170902e85100b00162529828aesm22409691plg.109.2022.07.04.21.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 21:59:39 -0700 (PDT)
Date:   Mon, 4 Jul 2022 21:59:38 -0700
From:   Soumya Negi <soumya.negi97@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        syzbot+9d567e08d3970bfd8271@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com,
        Xiaolong Huang <butterflyhuangxx@gmail.com>,
        stable@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Test patch for KASAN: global-out-of-bounds Read in
 detach_capi_ctr
Message-ID: <20220705045938.GA19781@Negi>
References: <CAHH-VXdqp0ZGKyJWE76zdyKwhv104JRA8ujUY5NoYO47HC9XWQ@mail.gmail.com>
 <20220704112619.GZ16517@kadam>
 <YsLU6XL1HBnQR79P@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsLU6XL1HBnQR79P@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 04, 2022 at 01:54:17PM +0200, Greg KH wrote:
> On Mon, Jul 04, 2022 at 02:26:19PM +0300, Dan Carpenter wrote:
> > 
> > On Fri, Jul 01, 2022 at 06:08:29AM -0700, Soumya Negi wrote:
> > > #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
> > > 3f8a27f9e27bd78604c0709224cec0ec85a8b106
> > > 
> > > -- 
> > > You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> > > To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> > > To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/CAHH-VXdqp0ZGKyJWE76zdyKwhv104JRA8ujUY5NoYO47HC9XWQ%40mail.gmail.com.
> > 
> > > From 3aa5aaffef64a5574cbdb3f5c985bc25b612140c Mon Sep 17 00:00:00 2001
> > > From: Soumya Negi <soumya.negi97@gmail.com>
> > > Date: Fri, 1 Jul 2022 04:52:17 -0700
> > > Subject: [PATCH] isdn: capi: Add check for controller count in
> > >  detach_capi_ctr()
> > > 
> > > Fixes Syzbot bug:
> > > https://syzkaller.appspot.com/bug?id=14f4820fbd379105a71fdee357b0759b90587a4e
> > > 
> > > This patch checks whether any ISDN devices are registered before unregistering
> > > a CAPI controller(device). Without the check, the controller struct capi_str
> > > results in out-of-bounds access bugs to other CAPI data strucures in
> > > detach_capri_ctr() as seen in the bug report.
> > > 
> > 
> > This bug was already fixed by commit 1f3e2e97c003 ("isdn: cpai: check
> > ctr->cnr to avoid array index out of bound").
> > 
> > It just needs to be backported.  Unfortunately there was no Fixes tag so
> > it wasn't picked up.  Also I'm not sure how backports work in netdev.
> 
> That commit has already been backported quite a while ago and is in the
> following releases:
> 	4.4.290 4.9.288 4.14.253 4.19.214 5.4.156 5.10.76 5.14.15 5.15
> 

Thanks for letting me know. Is there a way I can check whether an open
syzbot bug already has a fix as in this case? Right now I am thinking
of running the reproducer on linux-next as well before starting on a
bug.

-Soumya
