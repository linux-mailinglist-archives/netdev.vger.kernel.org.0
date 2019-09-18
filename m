Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 280E3B614E
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 12:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbfIRKTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 06:19:12 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33192 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728427AbfIRKTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 06:19:11 -0400
Received: by mail-pf1-f194.google.com with SMTP id q10so4118945pfl.0;
        Wed, 18 Sep 2019 03:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=96CtskRVCyIhaAKO+sSNyyBpkm2SbKef8Ee9AWjrlh4=;
        b=iHa0UBM0kjKshaEZj62nIXMbVRlVv5bnQ9VqnCc7T/8eiqdR73BAoL8GYK9hiIq6A+
         z2WVgbExWiUEADVie/AqV4Uf0Vp7eTDJs6Q7iFVZeV5KhrnlBzEraEq6x/d6WsL5VY0J
         tCa4DbKxUdTfXsbMWZuwltSdc1dxJk0g+imrm7HI5t1PTZ1V62/Zooj+7B8GNmQl25Ma
         gHbEgsdZY5aUYRwUwISV9l/zcPIitHn62W+BwWADCqM+75n7fjtdNpbXTFOO310anOPJ
         55R4zDffdJn/8CCZQTs2I5vXNjoGO2dFMvq4xcUXUuheTK3lriMr/IyAghXSZGuJJqBi
         vKLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=96CtskRVCyIhaAKO+sSNyyBpkm2SbKef8Ee9AWjrlh4=;
        b=O9RJ0ftU/hYNSqFSWTj4erbV7/0yTDE+VOWIRi63rBKdiGWpBNR2F7IN372M3KXS9L
         kiXOi04+GXQY40AZjZVIurt6fiAoaJ/JuYdV/woZKAR8rorJHJJt3Ol3gyRfW53XCgVw
         VWvI5jj9YwO7LrVSK43UW4kMi/LN5CaGxFeuslg5wbkhT6xR+8l2Une0ZZnGwlHnQKOT
         z2WoRtsnOQIAz79vkd5M27rAe6qi2Ze5Uw0HrMiJK5ejnbDhYUA7lFn3VmUygcCrvE88
         EX9zRTLb2DbdHRVqBjqSwfhFBb/kzQKyfu28TgkzwQQRZqDBkTTfjHG1KjYAjF8gFTPE
         +qAw==
X-Gm-Message-State: APjAAAVRNp1UH3haHX1Hm3fMo7Tey3htnNOMXTmi/pauFn0pJqAayY2t
        p05IAaj5q8R/LN940Qpr5WY=
X-Google-Smtp-Source: APXvYqz7mG8Zg395xUxujulOcShLGIf2bZpzuR/HwTQDLZzBsaAy5PRpgtx5jXrS5Q39Klb2xxDIGg==
X-Received: by 2002:a17:90a:2e04:: with SMTP id q4mr3014403pjd.43.1568801951226;
        Wed, 18 Sep 2019 03:19:11 -0700 (PDT)
Received: from bharath12345-Inspiron-5559 ([103.110.42.36])
        by smtp.gmail.com with ESMTPSA id c16sm6833207pja.2.2019.09.18.03.19.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 03:19:10 -0700 (PDT)
Date:   Wed, 18 Sep 2019 15:49:04 +0530
From:   Bharath Vedartham <linux.bhar@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     davem <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        allison@lohutok.net, tglx@linutronix.de,
        network dev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jon Maloy <jon.maloy@ericsson.com>
Subject: Re: net/dst_cache.c: preemption bug in net/dst_cache.c
Message-ID: <20190918101904.GB4519@bharath12345-Inspiron-5559>
References: <20190822195132.GA2100@bharath12345-Inspiron-5559>
 <CADvbK_c5+1-qDohRtFap25ih6XoAD3JirUz-impy7jvNZYpdvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_c5+1-qDohRtFap25ih6XoAD3JirUz-impy7jvNZYpdvg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 09, 2019 at 05:48:25PM +0800, Xin Long wrote:
> On Fri, Aug 23, 2019 at 3:58 PM Bharath Vedartham <linux.bhar@gmail.com> wrote:
> >
> > Hi all,
> >
> > I just want to bring attention to the syzbot bug [1]
> >
> > Even though syzbot claims the bug to be in net/tipc, I feel it is in
> > net/dst_cache.c. Please correct me if I am wrong.
> >
> > This bug is being triggered a lot of times by syzbot since the day it
> > was reported. Also given that this is core networking code, I felt it
> > was important to bring this to attention.
> >
> > It looks like preemption needs to be disabled before using this_cpu_ptr
> > or maybe we would be better of using a get_cpu_var and put_cpu_var combo
> > here.
> b->media->send_msg (tipc_udp_send_msg)
> -> tipc_udp_xmit() -> dst_cache_get()
> 
> send_msg() is always called under the protection of rcu_read_lock(), which
> already disabled preemption. If not, there must be some unbalanced calls of
> disable/enable preemption elsewhere.
> 
> Agree that this could be a serious issue, do you have any reproducer for this?
> 
> Thanks.
Hi Xin,

Sorry for the delayed response. I do not have a reproducer for this. You
can submit a patch to syzbot which can run the patch on the same system
on which it found the bug.

Thank you
Bharath
> >
> > [1] https://syzkaller.appspot.com/bug?id=dc6352b92862eb79373fe03fdf9af5928753e057
> >
> > Thank you
> > Bharath
