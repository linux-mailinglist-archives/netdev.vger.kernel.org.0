Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8E03FCAAE
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 17:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239016AbhHaPVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 11:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbhHaPVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 11:21:18 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC794C061575;
        Tue, 31 Aug 2021 08:20:21 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q68so17026835pga.9;
        Tue, 31 Aug 2021 08:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bHjdW+TFSdvqPfi7vbsYmlySYD0qeWma8ZlepyZ1pyA=;
        b=vKMmKg2JfTEH2r2TLKjdeGLs50EV+1jZUgn5bOxg36v536g3yxVJyUm07AJrRe5zpl
         tBmmevtBUhZm2otLHjO+t6XZXSqKFmlgJCMuDJmWa/GXj0SoH6IO4AASbNQrCa0nh7qM
         B7KI7XsRMY0RH1QUZ2VUGE8whdNH2gKq9Z8kV8Ym5rAqaokVsDSlFZJi22dmYwhDgQhT
         USid/NU4WRGPSTarkDcXxdUTAx9LYuGrR6Nv4PIqqo7PphtFsJN7VG6hLWhI5/qBs3Di
         +x+drrXZWdPlOXc87KdUarIUyVQNpVlgBbEDUDQ2DCD3gwGIwD/mm2RVJSZt7qbmg0qd
         mMeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bHjdW+TFSdvqPfi7vbsYmlySYD0qeWma8ZlepyZ1pyA=;
        b=MzsKrVPlwt7/4rfDPG6EyYEhnRwxeDRkJgwSp9OjclkbRb+2tmxN2Bzw5c53nNNOCv
         i18wRUyZ1rkGyLOyTbikbWtAwsJAIQCNxgd3tut+0m63FZaiyoCk4SYB7uP3iDs3eVuJ
         J25jWwQX7SC0zH4cRaf2soACqnB32P33CVFFkCu9++dBszr6lCnlP1wJfMDAvEPa8JRd
         OZbdd4rQ1fkDlN+2pfjhNoCLwdTXBxEnv9s7aHPZlNxBl67IlEjUU+nH/HQZV3DJIGO6
         qVIZ7tLQx3cU591mBn2wUaPQ8vfQKfjMl52mryq/+sJb5qRiAz3CF476fPVMAHJ1wS6u
         XadA==
X-Gm-Message-State: AOAM531vYGOXn0ln21AVI5BUsNkXL+oUcaCp6/HtEfhg/vvx0B+PCR1O
        y8lwPBajPooYgQ9g0A0gFf4=
X-Google-Smtp-Source: ABdhPJzSdF8ZTtYVUbdAWtHig1Ob457a20faxiqqeItSlT8AzOFj7ZlOHpfBE0oc7/WJzromHshTYw==
X-Received: by 2002:a62:8144:0:b0:3af:7e99:f48f with SMTP id t65-20020a628144000000b003af7e99f48fmr28970407pfd.2.1630423221259;
        Tue, 31 Aug 2021 08:20:21 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:1a:efea::50b])
        by smtp.gmail.com with ESMTPSA id x8sm7986672pfj.128.2021.08.31.08.20.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 08:20:20 -0700 (PDT)
Subject: Re: [PATCH V4 00/13] x86/Hyper-V: Add Hyper-V Isolation VM support
To:     Christoph Hellwig <hch@lst.de>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, catalin.marinas@arm.com,
        will@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        arnd@arndb.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
        brijesh.singh@amd.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, pgonda@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        hannes@cmpxchg.org, aneesh.kumar@linux.ibm.com,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        linux-arm-kernel@lists.infradead.org,
        xen-devel@lists.xenproject.org, rientjes@google.com,
        ardb@kernel.org, michael.h.kelley@microsoft.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
References: <20210827172114.414281-1-ltykernel@gmail.com>
 <20210830120036.GA22005@lst.de>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <91b5e997-8d44-77f0-6519-f574b541ba9f@gmail.com>
Date:   Tue, 31 Aug 2021 23:20:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210830120036.GA22005@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph:

On 8/30/2021 8:00 PM, Christoph Hellwig wrote:
> Sorry for the delayed answer, but I look at the vmap_pfn usage in the
> previous version and tried to come up with a better version.  This
> mostly untested branch:
> 
> http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/hyperv-vmap

No problem. Thank you very much for your suggestion patches and they are 
very helpful.


> 
> get us there for swiotlb and the channel infrastructure  I've started
> looking at the network driver and didn't get anywhere due to other work.
> 
> As far as I can tell the network driver does gigantic multi-megabyte
> vmalloc allocation for the send and receive buffers, which are then
> passed to the hardware, but always copied to/from when interacting
> with the networking stack.  Did I see that right?  Are these big
> buffers actually required unlike the normal buffer management schemes
> in other Linux network drivers?


For send packet, netvsc tries batching packet in send buffer if 
possible. It passes the original skb pages directly to
hypervisor when send buffer is not enough or packet length is larger 
than section size. These packets are sent via 
vmbus_sendpacket_pagebuffer() finally. Please see netvsc_send() for 
detail. The following code is to check whether the packet could be 
copied into send buffer. If not, the packet will be sent with original 
skb pages.

1239        /* batch packets in send buffer if possible */
1240        msdp = &nvchan->msd;
1241        if (msdp->pkt)
1242                msd_len = msdp->pkt->total_data_buflen;
1243
1244        try_batch =  msd_len > 0 && msdp->count < net_device->max_pkt;
1245        if (try_batch && msd_len + pktlen + net_device->pkt_align <
1246            net_device->send_section_size) {
1247                section_index = msdp->pkt->send_buf_index;
1248
1249        } else if (try_batch && msd_len + packet->rmsg_size <
1250                   net_device->send_section_size) {
1251                section_index = msdp->pkt->send_buf_index;
1252                packet->cp_partial = true;
1253
1254        } else if (pktlen + net_device->pkt_align <
1255                   net_device->send_section_size) {
1256                section_index = 
netvsc_get_next_send_section(net_device);
1257                if (unlikely(section_index == NETVSC_INVALID_INDEX)) {
1258                        ++ndev_ctx->eth_stats.tx_send_full;
1259                } else {
1260                        move_pkt_msd(&msd_send, &msd_skb, msdp);
1261                        msd_len = 0;
1262                }
1263        }
1264



For receive packet, the data is always copied from recv buffer.

> 
> If so I suspect the best way to allocate them is by not using vmalloc
> but just discontiguous pages, and then use kmap_local_pfn where the
> PFN includes the share_gpa offset when actually copying from/to the
> skbs.
> 
When netvsc needs to copy packet data to send buffer, it needs to 
caculate position with section_index and send_section_size.
Please seee netvsc_copy_to_send_buf() detail. So the contiguous virtual 
address of send buffer is necessary to copy data and batch packets.
