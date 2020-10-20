Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB6C2938EF
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 12:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404532AbgJTKMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 06:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728448AbgJTKMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 06:12:22 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C69C061755;
        Tue, 20 Oct 2020 03:12:21 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id h6so1420521lfj.3;
        Tue, 20 Oct 2020 03:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0NVDAJwiCNsVNKZWhlOY3xhwUPk6NysTziyLS+bYwFA=;
        b=jkXrMeQBqT/RqdDiE/ziEbQ5Vs7eQ61+qAhI3VUOkmHvyGC/j6q66S3suiTy7Ednr0
         2i+mzVSBxZLV8A/YRtAbUcRCAT8+tjy2NUxWPwVGYWSF40eEUoYrt/CxjPCx4Z75k7CE
         jb0+kOr29dZO4JjlS9PscvaW5UEr/iKfMC9Ij8AruYaifqDw10hVcdkrcmBXDEuqCkW9
         NzHkLM2Py0Y6sX52YaFEtoqcT3Z3OpRI8DqhfHrdQc2VbXBSuHoZfIxd83ZqZX0lAEkQ
         1DNHIgrnWAOqftqW3rvLM4TiyPbpSvEhH2VVQW0chvMs+ktnLxmtb1mZLNxgEl3wE7A1
         2w2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0NVDAJwiCNsVNKZWhlOY3xhwUPk6NysTziyLS+bYwFA=;
        b=gGbI2zBrxQxFW0Et5BWPC9LszjdBZUrCHKMeWiSObYkIHIrppw8YY0F/F5uDdmGmmJ
         lboxFlVg6II7FdoXHk3Brcmav88q1vT2V0fLJIUjLg0eJDCAanFfubjofuiUIVDpYWWU
         0XSmJYzFvQPAvsGAqvYnL/cICFoEEN+A4nfiFb2ih+lxL3FSGNs/zGcwNtiTClF51+AB
         2BsafWlT8nD1I5jvWfTYwXlo2fXC8mWiVyNeZf28a8NNWyNsKGLtO3Yc05p7oebYj1AP
         pmRFXRBWajsobmyNonfRSaLKoODn0C83too3hwRLBZgLrF3dJP0Sd+i7UCJAZeVtWRyC
         npng==
X-Gm-Message-State: AOAM532fR2IxGmKokl+TfL5utMZqcT5OiD14QZcyR+W9tkAvbZr906FF
        0h+tm13YpVP2mLZ0KA45WozwRAI8RhlrDlYuEus=
X-Google-Smtp-Source: ABdhPJyej+E8dxCY3kF9aWuYxbiwlWYLZCQe5GPTfsUoqsFL6pH6jps6tpEdavOizby7t0Hjq+mlkEvj0D9dlUdkA7E=
X-Received: by 2002:a19:7e8d:: with SMTP id z135mr747618lfc.158.1603188740418;
 Tue, 20 Oct 2020 03:12:20 -0700 (PDT)
MIME-Version: 1.0
References: <20201019090657.131-1-zhenzhong.duan@gmail.com>
 <20201019090657.131-2-zhenzhong.duan@gmail.com> <7eec99d5-e36b-ee5b-5b6c-1486e453a083@redhat.com>
In-Reply-To: <7eec99d5-e36b-ee5b-5b6c-1486e453a083@redhat.com>
From:   Zhenzhong Duan <zhenzhong.duan@gmail.com>
Date:   Tue, 20 Oct 2020 18:12:08 +0800
Message-ID: <CAFH1YnNZ2WPbNOCnFGPaL=L7TrSUXhzVT_kGpskXj=CTnZPHvQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: not link irqfd with a fake IRQ bypass producer
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        mst@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 2:32 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/10/19 =E4=B8=8B=E5=8D=885:06, Zhenzhong Duan wrote:
> > In case failure to setup Post interrupt for an IRQ, it make no sense
> > to assign irqfd->producer to the producer.
> >
> > This change makes code more robust.
>
>
> It's better to describe what issue we will get without this patch.

I didn't see an issue without this patch.

Regards
Zhenzhong
