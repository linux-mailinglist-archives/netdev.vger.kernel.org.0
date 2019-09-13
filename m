Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14404B1CBF
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 13:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbfIML6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 07:58:51 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42547 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728523AbfIML6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 07:58:51 -0400
Received: by mail-qk1-f193.google.com with SMTP id f16so1535753qkl.9;
        Fri, 13 Sep 2019 04:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BDa53w/ACXdT5fA16kw42x/1PlignMSxtyYJh9nqv/8=;
        b=OT5AiV0BzI6lyLS+FJBPujuz795LNXNHh8cOVghQE4u6aEfAbbBc6mWgpghzi/pXUI
         tI7TGXSGWfLKsA+oZUSyLxPRAXN3RbE7J2nN83wcVWnMQlTEfWjj5CRdVIwHoWiL721x
         AECp1ChA3lVFjQQI55acaSP7RAOeB0H4pt9t8JLzCDDzp4ewN+sjQtarWCimkNkF8nL3
         uzWrBXuAZl4OXXgLVG57iiF1PpBp9RFRkqGfcwa4EDJDF6krzBzRK9LT/BI8QqorUR7L
         LzoXL/Y6BUFv5PwUE8bUw4Y5KgsPwOziFYUq9lKSO9z+70OURud2nM6GTgTo8DQkQ4Fa
         kJMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BDa53w/ACXdT5fA16kw42x/1PlignMSxtyYJh9nqv/8=;
        b=Ss+JNKdg6bj2bChO99uJo93nu0K4cbrRKaXn57rs4cW2cyaTSGU84t8r+1QY4iCnhE
         vulJeCv7/qbjn6UMu+XpXlXh3cmodKdtIJLZoiK6LsVzlKL7rMxIHPgRq+1lBP4aimkv
         95FfSRxGLa6zCUK3c2+j9x3us2KdLRpwKPsbrbUai+It7k4JbabxxaWFqnyN0Lkz/igO
         pTeTgLNf4FD6CzXZFmeIWVl8f92FoTzawYM4JJIZA7Bd4bRntxkBAKPFsJ4Jb3FEW6sD
         8XLWZv+nLGu1OSpVqj5xDxkgZ3E2cvQzO/fmVkfkmajW4Oky3OSA7gqA6e7F/KqT+NyD
         5EuA==
X-Gm-Message-State: APjAAAW8jD/ypzEwTATXFRT2xu6ojDM1r8OED5QP1MJBn9qKtQFlE4Jd
        JynqzsNU7s5WyOfmiefKg73Gp71KWCk=
X-Google-Smtp-Source: APXvYqzIM2cv9WUUoNPdkfYD6AMHGpK/i8XCfIRPhj02e1zxMQtsmqTGnRkGuNPky+VCy6IS1aDkAA==
X-Received: by 2002:a37:708:: with SMTP id 8mr45614203qkh.273.1568375928331;
        Fri, 13 Sep 2019 04:58:48 -0700 (PDT)
Received: from frodo.byteswizards.com ([190.162.109.190])
        by smtp.gmail.com with ESMTPSA id z38sm16977290qtj.83.2019.09.13.04.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 04:58:47 -0700 (PDT)
Date:   Fri, 13 Sep 2019 08:58:43 -0300
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Eric Biederman <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v10 2/4] bpf: new helper to obtain namespace
 data from current task New bpf helper bpf_get_current_pidns_info.
Message-ID: <20190913115843.GA8262@frodo.byteswizards.com>
References: <c0e67fc7-be66-c4c6-6aad-316cbba18757@fb.com>
 <20190907001056.GA1131@ZenIV.linux.org.uk>
 <7d196a64-cf36-c2d5-7328-154aaeb929eb@fb.com>
 <20190909174522.GA17882@frodo.byteswizards.com>
 <dadf3657-2648-14ef-35ee-e09efb2cdb3e@fb.com>
 <20190910231506.GL1131@ZenIV.linux.org.uk>
 <87o8zr8cz3.fsf@x220.int.ebiederm.org>
 <7b0a325e-9187-702f-eba7-bfcc7e3f7eb4@fb.com>
 <CACiB22j9M2gmccnh7XqqFp8g7qKFuiOrSAVJiA2tQHLB0pmoSQ@mail.gmail.com>
 <91327e6c-2ea7-de0e-4459-06a9e0075416@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91327e6c-2ea7-de0e-4459-06a9e0075416@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 02:56:43AM +0000, Yonghong Song wrote:
Yonghong,

Great, I'll submit this new interface along self tests as version 12.
Thanks for your help.

Bests
> 
> 
> On 9/12/19 3:03 PM, carlos antonio neira bustos wrote:
> > Yonghong,
> > 
> > I think bpf_get_ns_current_pid_tgid interface is a lot better than the 
> > one proposed in my patch, how are we going to move forward? Should I 
> > take these changes and refactor the selftests to use this new interface 
> > and submit version 12 or as the interface changed completely is a new 
> > set of patches?.
> 
> This is to solve the same problem. You can just submit as version 12.
> This way, we preserves discussion history clearly.
> 
> > 
> > Eric,
> > Thank you very much for explaining the problem and your help to move 
> > forward with this new helper.
> > 
> > 
> > Bests
