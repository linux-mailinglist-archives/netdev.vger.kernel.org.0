Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A639614F9A7
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 19:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbgBASxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 13:53:16 -0500
Received: from mail-oi1-f171.google.com ([209.85.167.171]:39228 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbgBASxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 13:53:04 -0500
Received: by mail-oi1-f171.google.com with SMTP id z2so10740961oih.6;
        Sat, 01 Feb 2020 10:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u78NgzZ3KrEOfpTpyNxckRqZTrwrDsJGa/4Tbk58Hxk=;
        b=GxL3/WHIG+dHKdSJmccC2EhuC5+Xeh4cjy7QzIJDDegXBinYS/USK76BbAzD1MQjSK
         DljAHU5SxCAXmxnPUWEt1rgfWa40Z5Vn8QUwpfruDYdwVRsHpniHdndZ0dt0RMDkgfRy
         yUChf89Ur95RZ4ZkEB4aH4cMeG48GTxr2c/XJYLrPGCNXAFGbTTx/1UU/kdaxO6rXgcN
         4xHsh8l2a6Gz5T6T54fZQJAt4He1si/1kPOMVUUUG7Cr1EOjT91Fvgt4kXQGBpwadtdI
         yrgyPlClqMZYfvACn50mPrzungQY4ksE6s7IQZjhDvNPlqYGfaTv/XzfDdmwdlVwzNxP
         O/Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u78NgzZ3KrEOfpTpyNxckRqZTrwrDsJGa/4Tbk58Hxk=;
        b=BzTJbvDaocbdV5uMSAT+SOh5p5hfl5tZ+HvSC1wxs8w+7Ohug+YSw+mfwA6ftMjaV5
         80ZpsYcHy1uFkCF1TmOUu1hBp/kTkPVoc+FFu8QC5AcGRgDc9ostUMkdWBMIB7OqXc1n
         6ilH74F2dFOIhGUdixZB0SgIqCaU8h+bOrJMu1LDBn5HbBC0StDF4yM3VE9L/SyK8DLi
         N7u8PrMABkXQ2XX0jsSRhvqgrNLJu7vVjJ6/i4hldqi1v8OuQdG1iogUyp5Uk5fJ/kV6
         qaRsEfyLXgxSV1meZzCC9qY2o1ueZVHNAaLOTyb8iqWbFPsYx5LbCstc3J7xgxTBb51E
         GNAg==
X-Gm-Message-State: APjAAAVu8aId3XNeNOPEFLLDYXjIzQpGQxQ2xnBf8NcchzyHZj2hIdGM
        LaHtY8sW2qVo6j8YUsyYALnXS5ypJv1zWtybPAI=
X-Google-Smtp-Source: APXvYqzvVoAlLlNnEUrquYyrowd/GNygHH+kPf3WtbxWTi2YbX4mjnslEPbIqGus2wMsEDBfbJE3f0rCbVKEKHix6Rw=
X-Received: by 2002:aca:cf07:: with SMTP id f7mr729695oig.5.1580583183580;
 Sat, 01 Feb 2020 10:53:03 -0800 (PST)
MIME-Version: 1.0
References: <000000000000466b64059bcb3843@google.com> <20200126132352.8212-1-hdanton@sina.com>
 <20200201070541.GJ1778@kadam>
In-Reply-To: <20200201070541.GJ1778@kadam>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 1 Feb 2020 10:52:52 -0800
Message-ID: <CAM_iQpWsfc5U3_csn=qZWZZs7SPptj9ZxGcriMd-aYy8NiN09Q@mail.gmail.com>
Subject: Re: INFO: task hung in hashlimit_mt_check_common
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 11:07 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> I wonder if there is some automated way to accept test patches from the
> mailing list.

At least for me, I always test patches before formally posting to mailing
lists. Sometimes I want syzbot to test some debugging or experimental
patches too, those should not be posted to dev mailing lists.

Thanks.
