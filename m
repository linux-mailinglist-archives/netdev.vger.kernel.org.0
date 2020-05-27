Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4291E46AD
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 17:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389399AbgE0PAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 11:00:51 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48673 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389364AbgE0PAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 11:00:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590591648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S79dLGaDC34U88k/muBN2/cWWvIJSeZD2zX/jWO3DQQ=;
        b=bDDpE2gNlwNf5Z+ph3dXAJ1M+XkBoEdNnF4SLBt0skQq3BWmCnaCmK5xwhQJNTMzG5/5/T
        QTEu0GOFKTimtY351fvoq8XT4vhcctH64iK7Ucs3HiyADlRUAe8BtE/SKfs0ETv3EQBQFe
        WhDV7JEibaMfS00t7aTfhUQ/GHBrQVE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-DsS9-EnUN-6GTyNBOavp1w-1; Wed, 27 May 2020 11:00:47 -0400
X-MC-Unique: DsS9-EnUN-6GTyNBOavp1w-1
Received: by mail-ed1-f71.google.com with SMTP id o12so10135600edj.12
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 08:00:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S79dLGaDC34U88k/muBN2/cWWvIJSeZD2zX/jWO3DQQ=;
        b=Dj5Kd27K32BnBrgL/4igHxr1O8DPxjFtAW76J+6jQsWVPN0u7neqTl01FNLg5IA0hf
         z1r70R6xWAT5zf19Am104Ut3fH+XV5pfwBWp0FQrbiyFp+n/X56AqD3X+M6lYECJnu0d
         wncCDsYeRZQYjD3+nXTEDDVgCueprU4hbUVU2yn28H4zEIDzWwBDm2jzpMNSW9zHzljS
         w24GcZUqv3qDFSPG/YVL1I5hFa8nEbhEdatFu2zU/DmYOSN2eFs36035al9JxylziKvA
         Z42GnuhGizeNVCdtUYOZ+bwIVcmvbonRcV3XAqfRfROZobQCYG+oxPVlsFuX/Fb3Y3X7
         twvg==
X-Gm-Message-State: AOAM533qPL9rlvqtbFnirEdM3jKeoQOLamIas3Dpk8NUdimbF1O4X5zm
        qmMmzLbsqICn2l/wkoGeHFfQCfhy35j4MjiEgpN+ZvO4cyH7i4HPxS7X8+Gbpq2et2TunsIie0I
        lQxTSUATd8Ck1Q0YW
X-Received: by 2002:a17:906:1442:: with SMTP id q2mr3491299ejc.33.1590591646048;
        Wed, 27 May 2020 08:00:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxzNY5UhO1mssuYEm2F2UYGESNfuhTc2d/FaV+VoTyW39e+803AKyGa34dCi6Lxc3HyJGruA==
X-Received: by 2002:a17:906:1442:: with SMTP id q2mr3491234ejc.33.1590591645542;
        Wed, 27 May 2020 08:00:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id l1sm3053400ejd.114.2020.05.27.08.00.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 08:00:45 -0700 (PDT)
Subject: Re: [PATCH v3 0/7] Statsfs: a new ram-based file system for Linux
 kernel statistics
To:     Andrew Lunn <andrew@lunn.ch>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jim Mattson <jmattson@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Emanuele Giuseppe Esposito <e.emanuelegiuseppe@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Jonathan Adams <jwadams@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
References: <20200526110318.69006-1-eesposit@redhat.com>
 <20200526153128.448bfb43@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <6a754b40-b148-867d-071d-8f31c5c0d172@redhat.com>
 <20200527133309.GC793752@lunn.ch>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b0d11337-3ea4-d874-6013-ff8c3e9d6f26@redhat.com>
Date:   Wed, 27 May 2020 17:00:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200527133309.GC793752@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/05/20 15:33, Andrew Lunn wrote:
>> I don't really know a lot about the networking subsystem, and as it was
>> pointed out in another email on patch 7 by Andrew, networking needs to
>> atomically gather and display statistics in order to make them consistent,
>> and currently this is not supported by stats_fs but could be added in
>> future.
> 
> Do you have any idea how you will support atomic access? It does not
> seem easy to implement in a filesystem based model.

Hi Andrew,

there are plans to support binary access.  Emanuele and I don't really
have a plan for how to implement it, but there are developers from
Google that have ideas (because Google has a similar "metricfs" thing
in-house).

I think atomic access would use some kind of "source_ops" struct
containing create_snapshot and release_snapshot function pointers.

Paolo

