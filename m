Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0232C2938D6
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 12:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405924AbgJTKFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 06:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729133AbgJTKFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 06:05:30 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2030DC061755;
        Tue, 20 Oct 2020 03:05:30 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id 184so1386627lfd.6;
        Tue, 20 Oct 2020 03:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YKO69m9GIUyAgq9zP8NOSQHmVAdJ/gUS0MMiKmKZ6jg=;
        b=qOrMe8Hq+6G5pM2CoZ63NLIZNnwaOnlTKIVr7oi0qiWzq9EW2VxVzZvLFUSeNAoqNb
         b0DHM2tW8EGGk1WP1V27VaAqCme6xeSbd06kPDSxLhXxmrVqjPqeRQc5l+cO8ce2xIWg
         JaeEowfzYSccwxpZfNY7bxBUu2n/7h3UtKkiSWjWsUvqdSWEPPzlbgRBSnVgBTxmZuyq
         AixqQe0zAG8CTn+qyuGukx5+q8fhqJUpSoctvD2ESiyDYRRbYxrXl2Vyhf0SER27fKdB
         3M0s3NfpMJiT6sGekyLEebzzDu2WEkbROH2lDReLAVOne+ul1hBGWOAKH/x3lzhjGi5p
         53wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YKO69m9GIUyAgq9zP8NOSQHmVAdJ/gUS0MMiKmKZ6jg=;
        b=B296+a1sp+dlMarrZRq/gbyo18IoMJxUzTBkfhqWSrxj7RDh7dOCgytHPPHxhbnVIE
         CtHG2wNDN5uVBcqaEDsf3vXu8qR4hSi0+xRgyAnuTo4vEqUXAAVwFYXDNeB8lpUsJ+af
         9qIWucN4Xws0lF69auqMYTOGAJjTu9CMULf+SVMTmW/hEfmssYwscKbxxEq4I5A9unOp
         ecii3MXvARzL5Wn8NNMnFuyQtsCLx1pZ5K+bpHSpjEl3CFuJtBQDJbV6xK339faDb68x
         iGOINWJixODVeAOUPpDFK9vX/cn7t+Na1wL3fqwnxvIhheEssqkDdQw6oyb+Myl3SYw8
         oimg==
X-Gm-Message-State: AOAM531phyWNg0TAw7QDwceDsGn6rOGgVW+q9nufcquNgPJ/sGKaXR+0
        6EScIonTBTaGILQjV1pjrF/+ZGf8n6321JJ/BKU=
X-Google-Smtp-Source: ABdhPJy2nmaqm1jT8wSt3AQn7oWDyvTYsXu3yiDPHIW2jwxyt8jEHtIrUs+Ej0TtQHIRVHd9AnMOPX0/t6XWhxxfHF4=
X-Received: by 2002:a19:f207:: with SMTP id q7mr639182lfh.588.1603188328643;
 Tue, 20 Oct 2020 03:05:28 -0700 (PDT)
MIME-Version: 1.0
References: <20201019090657.131-1-zhenzhong.duan@gmail.com> <7ef3b498-bdc5-4a3d-d23b-ad58205ae1b7@redhat.com>
In-Reply-To: <7ef3b498-bdc5-4a3d-d23b-ad58205ae1b7@redhat.com>
From:   Zhenzhong Duan <zhenzhong.duan@gmail.com>
Date:   Tue, 20 Oct 2020 18:05:16 +0800
Message-ID: <CAFH1YnNsoPeOe6fVZOasy_GiLE7-tiSKeezSEoxv4+wTU+FUAg@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: not register a IRQ bypass producer if
 unsupported or disabled
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

On Tue, Oct 20, 2020 at 2:23 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/10/19 =E4=B8=8B=E5=8D=885:06, Zhenzhong Duan wrote:
> > If Post interrupt is disabled due to hardware limit or forcely disabled
> > by "intremap=3Dnopost" parameter, return -EINVAL so that the legacy mod=
e IRQ
> > isn't registered as IRQ bypass producer.
>
>
> Is there any side effect if it was still registered?

Not much side effect in theory, just some legacy mode IRQs in producer
list and it's not easy to distinguish them with PI interrupt mode IRQ.
The main purpose of this patch is to provide a way for people to know
if a device IRQ is really offloaded from kernel by a print.
>
>
> >
> > With this change, below message is printed:
> > "vfio-pci 0000:db:00.0: irq bypass producer (token 0000000060c8cda5) re=
gistration fails: -22"
>
>
> I may miss something, but the patch only touches vhost-vDPA instead of VF=
IO?

VFIO already has above print in vfio_msi_set_vector_signal() but vhost-vDPA=
 not.

Regards
Zhenzhong
