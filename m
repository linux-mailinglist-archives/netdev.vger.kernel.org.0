Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758984813C9
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 15:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239844AbhL2OGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 09:06:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:22983 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237227AbhL2OGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 09:06:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640786792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aO/4Yp6T43XLmNMDQP+OwTqaYv7whlIlyBDq4dbPFsg=;
        b=cIKLPwvkNFjDmUgRNlTNSevOZIBBFlut6kEpMOFbQCxhZU69gSHGNYnoRflhGuMChScNM8
        MLLIYy1Jlu4IaaAOR1/o9cyYzvZDtsUr3P0CyuY6juobcOPXCitDDK0ZZO06bxnwR6prVQ
        6vzpTZjOkHWBIWOV7rNOYbKxvNXjFuU=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-V1MSNceqNWC0g_RL47FBNg-1; Wed, 29 Dec 2021 09:06:31 -0500
X-MC-Unique: V1MSNceqNWC0g_RL47FBNg-1
Received: by mail-qk1-f198.google.com with SMTP id bj32-20020a05620a192000b0046dcca212b6so12809372qkb.6
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 06:06:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aO/4Yp6T43XLmNMDQP+OwTqaYv7whlIlyBDq4dbPFsg=;
        b=Pvg7vLKNnZEjo1IYYv028pBwQ/35IggFrYuLxh1RKM3R+lcm2oTKi8pzTf/BtQ24EA
         5GC9/ddG/ii8drEhoMdHhMsFG6VIxZx6suoEtkc9sBuD+WnyGoofWbCfR+ccnClXc6V8
         4FcELLr1IThxllqc6cvMloaJTWRk+c7trifDZc1SLtj8QWPc2S0UpgDrZs5d4iLnhpNV
         9XzFxcwTBVvpj4mEDzl0DR+u0qg0JXMYns2UYbhxe0BsxzvOMlesX9vQmejL1BXLK+lv
         41aepHeISYxtF/PZHiV0tv2+rtCGkJ+5RqioCMJYMwAox564v7DeTwt/mt+ttB42R2kM
         PQjw==
X-Gm-Message-State: AOAM530aC/tJmrqyro4pDOt8f2p9iQAsuk1bwCFAMbS9U2NVNKqKPkip
        +zCkFB5RoxPItKrpS8IXKQfyl5tq6J+R2IutjOMnWFTA9yRvudR/Iz7nGxDAQUjA5+xHpUSglt6
        QoF39cW4ntoJyqTMI
X-Received: by 2002:a05:620a:4003:: with SMTP id h3mr18549125qko.153.1640786790470;
        Wed, 29 Dec 2021 06:06:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyimHrQiLRtzxiuwvtJVztliA6HApJnsXsaqWdLb9ltPripN76oNC87N68Zld9IushfHCBQfg==
X-Received: by 2002:a05:620a:4003:: with SMTP id h3mr18549076qko.153.1640786790152;
        Wed, 29 Dec 2021 06:06:30 -0800 (PST)
Received: from steredhat (host-87-10-236-9.retail.telecomitalia.it. [87.10.236.9])
        by smtp.gmail.com with ESMTPSA id h2sm18124352qkn.136.2021.12.29.06.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 06:06:29 -0800 (PST)
Date:   Wed, 29 Dec 2021 15:05:57 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        dledford@redhat.com, jgg@ziepe.ca, mustafa.ismail@intel.com,
        shiraz.saleem@intel.com, leon@kernel.org, ap420073@gmail.com,
        wg@grandegger.com, woojung.huh@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        george.mccollister@gmail.com, michael.chan@broadcom.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        hawk@kernel.org, john.fastabend@gmail.com, tariqt@nvidia.com,
        saeedm@nvidia.com, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, jreuter@yaina.de, dsahern@kernel.org,
        kvalo@codeaurora.org, pkshih@realtek.com,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        viro@zeniv.linux.org.uk, andrii@kernel.org, mcgrof@kernel.org,
        keescook@chromium.org, yzaikin@google.com, nikolay@nvidia.com,
        jiri@nvidia.com, wintera@linux.ibm.com, wenjia@linux.ibm.com,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        ralf@linux-mips.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kgraul@linux.ibm.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, arnd@arndb.de,
        linux-bluetooth@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-can@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-hams@vger.kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-s390@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH bpf-next v2] net: don't include filter.h from net/sock.h
Message-ID: <20211229140557.cuap5jjqz47yevda@steredhat>
References: <20211229004913.513372-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20211229004913.513372-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 28, 2021 at 04:49:13PM -0800, Jakub Kicinski wrote:
>sock.h is pretty heavily used (5k objects rebuilt on x86 after
>it's touched). We can drop the include of filter.h from it and
>add a forward declaration of struct sk_filter instead.
>This decreases the number of rebuilt objects when bpf.h
>is touched from ~5k to ~1k.
>
>There's a lot of missing includes this was masking. Primarily
>in networking tho, this time.
>
>Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>---
>v2: https://lore.kernel.org/all/20211228192519.386913-1-kuba@kernel.org/
> - fix build in bond on ia64
> - fix build in ip6_fib with randconfig

For AF_VSOCK:
Acked-by: Stefano Garzarella <sgarzare@redhat.com>

