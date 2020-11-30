Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEB62C8011
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 09:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbgK3IfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 03:35:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35951 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727028AbgK3IfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 03:35:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606725233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vOBw30VGGpYGUqtKjgp1D/xXFSKdq88sDVSnLLemHDo=;
        b=FRb3fGdf6aLMG6xJeHSgATNF+5MeF8CsLcrSLmJgvy3tWcQKhs+x8n1PKDN30xWSabPxpt
        CmxrZOqc6VAUEJDKbjpyg21zhrtTEb7PFhx3PYGLoFe7XuFsqRTEVI2FRF2E61wmZzUEUy
        rRgZU3+c/Qu5Znvqo9UfzMIzUGxDz8c=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-R4D0pqhDMXGgl2Gw7OZL4g-1; Mon, 30 Nov 2020 03:33:50 -0500
X-MC-Unique: R4D0pqhDMXGgl2Gw7OZL4g-1
Received: by mail-wr1-f71.google.com with SMTP id v5so8050801wrr.0
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 00:33:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vOBw30VGGpYGUqtKjgp1D/xXFSKdq88sDVSnLLemHDo=;
        b=qOrA8fZb6Ciuu6muCBr8f1RM10YiQg/OTLtk4d5OUqXZLwlInXdbWx19hDzv0+nDLV
         zG2e5LiEHJZuEkRuexbSKxQLBEISnpefpl5mKtin3myDXziQmq2/19UaSkXGKHdWKXSv
         StB2bK+f+9OWUDUD4/PmmP/Mq++RULPpDRtacna2QZr66CRXDkZMH6weS3NyvShDk2BB
         suGdtQE/oskD4ub2BcgtJNgXTuDlcQfVO5fb5x3kaJkXpc2Thd7HoGOK+Pw7gGSYJztV
         pItAmqIgRSDhclb/qU72hNKNinUIYOSB7MmQY47mimv6Y7iEGuFZhGuu8P6e2ZpS09mL
         pheQ==
X-Gm-Message-State: AOAM532RpWgdusedkPs9wdDEQW0KspF+aFm864FYAyKbAYIXfPPKZoOj
        LcZDMiKmfDOgzs5FWEJBxN8uiteTELKRALDAdB7n2uNbn50njorGOoDXb5xAw6eUM/FNoR/H/ho
        cESKf25AyL7ldfZYFhvdiM/W6tGBUxRjcvujZFTW0tn+sRGXmbSxJi5R19SZS+3XPdIl+
X-Received: by 2002:adf:dd0e:: with SMTP id a14mr26727980wrm.36.1606725228991;
        Mon, 30 Nov 2020 00:33:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxx/iQZGql5wZU5MomW2tQpacaKJDVUoRlyVnQsj6AxXWR1H+6D7EHUWZYX9I0NcbeUr12Ulw==
X-Received: by 2002:adf:dd0e:: with SMTP id a14mr26727949wrm.36.1606725228783;
        Mon, 30 Nov 2020 00:33:48 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id a184sm24043265wmf.8.2020.11.30.00.33.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 00:33:47 -0800 (PST)
Subject: Re: [PATCH AUTOSEL 5.9 22/33] vhost scsi: add lun parser helper
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201125153550.810101-1-sashal@kernel.org>
 <20201125153550.810101-22-sashal@kernel.org>
 <25cd0d64-bffc-9506-c148-11583fed897c@redhat.com>
 <20201125180102.GL643756@sasha-vm>
 <9670064e-793f-561e-b032-75b1ab5c9096@redhat.com>
 <20201129041314.GO643756@sasha-vm>
 <7a4c3d84-8ff7-abd9-7340-3a6d7c65cfa7@redhat.com>
 <20201129210650.GP643756@sasha-vm>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e499986d-ade5-23bd-7a04-fa5eb3f15a56@redhat.com>
Date:   Mon, 30 Nov 2020 09:33:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201129210650.GP643756@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/11/20 22:06, Sasha Levin wrote:
> On Sun, Nov 29, 2020 at 06:34:01PM +0100, Paolo Bonzini wrote:
>> On 29/11/20 05:13, Sasha Levin wrote:
>>>> Which doesn't seem to be suitable for stable either...  Patch 3/5 in
>>>
>>> Why not? It was sent as a fix to Linus.
>>
>> Dunno, 120 lines of new code?  Even if it's okay for an rc, I don't 
>> see why it is would be backported to stable releases and release it 
>> without any kind of testing.  Maybe for 5.9 the chances of breaking 
> 
> Lines of code is not everything. If you think that this needs additional
> testing then that's fine and we can drop it, but not picking up a fix
> just because it's 120 lines is not something we'd do.

Starting with the first two steps in stable-kernel-rules.rst:

Rules on what kind of patches are accepted, and which ones are not, into 
the "-stable" tree:

  - It must be obviously correct and tested.
  - It cannot be bigger than 100 lines, with context.

> Plus all the testing we have for the stable trees, yes. It goes beyond
> just compiling at this point.
> 
> Your very own co-workers (https://cki-project.org/) are pushing hard on
> this effort around stable kernel testing, and statements like these
> aren't helping anyone.

I am not aware of any public CI being done _at all_ done on vhost-scsi, 
by CKI or everyone else.  So autoselection should be done only on 
subsystems that have very high coverage in CI.

Paolo

