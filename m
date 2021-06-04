Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D5739C16A
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 22:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhFDUht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 16:37:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25518 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231320AbhFDUhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 16:37:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622838960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y6Thexy0S9yAdfMWlPeLLADSbYeQgKUJsnhXYbRk/4M=;
        b=XhS0Br0O+o0blnT7o3ulVnwPwfgJD7netfTE2epzrL41F0gAsKz+nepOOSeHokqc+boWY8
        yjmv57YuZbcm3X7MJz6rJjcZIDpVkQpKSSWOZqbrgmQY8Ay5s09gruRE4T1T1UsmxwxCt7
        n37bbkGUNX6bB2noViH5nSqIHOV1NzI=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-G_9RXneRODqngAKmTI4MgA-1; Fri, 04 Jun 2021 16:35:59 -0400
X-MC-Unique: G_9RXneRODqngAKmTI4MgA-1
Received: by mail-lj1-f199.google.com with SMTP id f13-20020a2eb5ad0000b02900f990d6bf16so4809524ljn.4
        for <netdev@vger.kernel.org>; Fri, 04 Jun 2021 13:35:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y6Thexy0S9yAdfMWlPeLLADSbYeQgKUJsnhXYbRk/4M=;
        b=VG5+zWffjzfLC46gnigengHKOfpZgnZmWfz8ZdtwISZw2zbvrZ2y9IidqfwTOb7MDB
         FtwkgqlbFOXkF9LxH9M2E900vVrzmg9as04Mik3K7ohp4QECExSFDbArWLugySrlnfe2
         AEyR8OfCxVKdlXoOQUK+xMo/5UAcAdQj8kMQEmalK7ClqH9MJYP5FKuTa3m8PBpWfERV
         YiIs5aqNOWXPEKzvs8jdSX+CLvm/mq9K8ct9+IxJro4E3wU7sj54d40+xZSmMOQqkO3P
         QnOiqlP8ynX1wSdPuQNf6+kEWlqLLUF2+s8QvFgt4Bk+8DbrIKv57pfxBHnKXuEPSDgl
         6g/g==
X-Gm-Message-State: AOAM533enrlFmQKjN7MzuIpIv5ncIQn1gp3cTBxoa5NIYbGFsC51+ZtE
        4Z8ypI0CfDERMK1wR55M8Rcg2bQe7LyijVZw+E50SKOZOpZ7rXlExIdnp23yWD/F3Ao8Pt/+3xN
        r2Q+KrgO0pjXzmM8BkJ9THc9reS8R6VUu
X-Received: by 2002:a2e:83ce:: with SMTP id s14mr4802991ljh.30.1622838957722;
        Fri, 04 Jun 2021 13:35:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyA8sfpDISd7W3a8IsW6/YiM57Zw+/p+NaHoiuAPg8X6bW9cLXRUw/b5biIXrpjtTnIR6xsL3IgHzsQtEI3hbs=
X-Received: by 2002:a2e:83ce:: with SMTP id s14mr4802957ljh.30.1622838957476;
 Fri, 04 Jun 2021 13:35:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210504092340.00006c61@intel.com> <87pmxpdr32.ffs@nanos.tec.linutronix.de>
 <CAFki+Lkjn2VCBcLSAfQZ2PEkx-TR0Ts_jPnK9b-5ne3PUX37TQ@mail.gmail.com>
 <87im3gewlu.ffs@nanos.tec.linutronix.de> <CAFki+L=gp10W1ygv7zdsee=BUGpx9yPAckKr7pyo=tkFJPciEg@mail.gmail.com>
 <CAFki+L=eQoMq+mWhw_jVT-biyuDXpxbXY5nO+F6HvCtpbG9V2w@mail.gmail.com>
 <CAFki+LkB1sk3mOv4dd1D-SoPWHOs28ZwN-PqL_6xBk=Qkm40Lw@mail.gmail.com>
 <87zgwo9u79.ffs@nanos.tec.linutronix.de> <87wnrs9tvp.ffs@nanos.tec.linutronix.de>
 <CAFki+LkqBHnVYB5VBx_8Ch0u8RfXrJsRzxyuDfHhbR-dCeN3Lg@mail.gmail.com> <87bl93ahc4.ffs@nanos.tec.linutronix.de>
In-Reply-To: <87bl93ahc4.ffs@nanos.tec.linutronix.de>
From:   Nitesh Lal <nilal@redhat.com>
Date:   Fri, 4 Jun 2021 16:35:45 -0400
Message-ID: <CAFki+LmW1d1f-mdFq8ovGERDRMkM7o=urmmQZi9cwXoR+Ydm=w@mail.gmail.com>
Subject: Re: [PATCH] genirq: Provide new interfaces for affinity hints
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, jbrandeb@kernel.org,
        "frederic@kernel.org" <frederic@kernel.org>,
        "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
        Alex Belits <abelits@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "rppt@linux.vnet.ibm.com" <rppt@linux.vnet.ibm.com>,
        "jinyuqi@huawei.com" <jinyuqi@huawei.com>,
        "zhangshaokun@hisilicon.com" <zhangshaokun@hisilicon.com>,
        netdev@vger.kernel.org, chris.friesen@windriver.com,
        Marc Zyngier <maz@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>, pjwaskiewicz@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 5:48 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Fri, May 21 2021 at 12:13, Nitesh Lal wrote:
> > On Fri, May 21, 2021 at 8:03 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> >> Provide new interfaces:
> >>
> >>   irq_update_affinity_hint() - Only sets the affinity hint pointer
> >>   irq_apply_affinity_hint()  - Set the pointer and apply the affinity to
> >>                                the interrupt
> >>
> >
> > Any reason why you ruled out the usage of irq_set_affinity_and_hint()?
> > IMHO the latter makes it very clear what the function is meant to do.
>
> You're right. I was trying to phase the existing hint setter out, but
> that's probably pointless overengineering for no real value. Let me redo
> that.
>

Thomas, are you planning to send a v2 for this soon or did I somehow miss
it?

Since your other patch "genirq: Export affinity setter for modules" is
already in linux-next, I have started looking into the drivers where
we can use that.

On thinking about this whole chunk a little more, I do wonder about the
reason why we are still sticking with the hints.

The two reasons that I could come up with are:
- We are not entirely sure if irqbalance still consumes this or not
- For future use by some other userspace daemon  (?)

Does that sound right?

-- 
Thanks
Nitesh

