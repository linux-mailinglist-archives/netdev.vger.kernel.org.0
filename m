Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B4E5F61AE
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 09:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiJFHed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 03:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbiJFHeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 03:34:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4548E98B
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 00:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665041658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fUwy6V31dk1BCOu7dbLezKne5qwi/4FkmWkd7lla4qc=;
        b=G61PdCeb+7BbtYnNlLEwgWbpXOxBca7fEC1xrhkbiX1AU9qB0j4O/JEmBa8OMO5neFD5yE
        f+iINeF/+NB2xC0VwjNS+IZA6VfmrOmMTC56ILq/3nWCocIljMBxNyuvrU/X1Xjlcy+0DS
        oEDpnKkoUGw+YTg8ruKqFNgGOtgNj4M=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-104-DOesN1ZIOIGNrp4jhyk2tw-1; Thu, 06 Oct 2022 03:34:17 -0400
X-MC-Unique: DOesN1ZIOIGNrp4jhyk2tw-1
Received: by mail-ed1-f71.google.com with SMTP id dz21-20020a0564021d5500b004599f697666so899862edb.18
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 00:34:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fUwy6V31dk1BCOu7dbLezKne5qwi/4FkmWkd7lla4qc=;
        b=uOkFvBBK+kAjfm7NyAfStnTWLX8lXwr616hoYYTebH2nK0UieFf+r75MUZxQWRODfv
         /6bqf9hqM+xernt++TNTe5rpPpo/D/h7xuFAPxWefk47jUOq6plTkbJxAYnoDx54SrMc
         UVWKwDwhg/UydukJuHVG9Q8A5lkRUywkt9eBbmz4JDvkgOrQRxYSb0QcQJ027qbHLPJp
         zoNARGcpgV70z9lez0hmmhu4mlVtCo6xKmG/jYAx/JUN8qTGwPIYonBIGxyXJYF+eVef
         V7gbF3fPIU8aWY/RSU1mKv6u/lLcp95SxVh7NM0cy2LHpgAVuHzwkrYTwOUlrnYItxuL
         /xkQ==
X-Gm-Message-State: ACrzQf3LTdmaiCxrTfa8EBigqtO5ezSLBFhiBANMEcTYjnrvOqnNIXoJ
        98Jz7r3CzXaLyxUztiup1XXSMx+Dh9CPJbraGhTCGB9PIN36wtMkIBcpDwVjPxhhmahG8RiySrc
        XlKyLMoswc9VqorAg
X-Received: by 2002:a17:907:724a:b0:782:405f:8115 with SMTP id ds10-20020a170907724a00b00782405f8115mr2910888ejc.147.1665041655385;
        Thu, 06 Oct 2022 00:34:15 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM44T4zWyGulJH+j/LpDdqknk09HMNxHTcvIsE5Med56cxQZCnSdeQcKPGt1dPA9kjuGiw7FWw==
X-Received: by 2002:a17:907:724a:b0:782:405f:8115 with SMTP id ds10-20020a170907724a00b00782405f8115mr2910870ejc.147.1665041655098;
        Thu, 06 Oct 2022 00:34:15 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-222.retail.telecomitalia.it. [79.46.200.222])
        by smtp.gmail.com with ESMTPSA id g25-20020a056402321900b004542e65337asm5307845eda.51.2022.10.06.00.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 00:34:14 -0700 (PDT)
Date:   Thu, 6 Oct 2022 09:34:10 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vsock: replace virtio_vsock_pkt with sk_buff
Message-ID: <20221006073410.ahhqhlhah4lo47o7@sgarzare-redhat>
References: <20221006011946.85130-1-bobby.eshleman@bytedance.com>
 <20221006025956-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221006025956-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 06, 2022 at 03:08:12AM -0400, Michael S. Tsirkin wrote:
>On Wed, Oct 05, 2022 at 06:19:44PM -0700, Bobby Eshleman wrote:
>> This patch replaces the struct virtio_vsock_pkt with struct sk_buff.
>>
>> Using sk_buff in vsock benefits it by a) allowing vsock to be extended
>> for socket-related features like sockmap, b) vsock may in the future
>> use other sk_buff-dependent kernel capabilities, and c) vsock shares
>> commonality with other socket types.
>>
>> This patch is taken from the original series found here:
>> https://lore.kernel.org/all/cover.1660362668.git.bobby.eshleman@bytedance.com/
>>
>> Small-sized packet throughput improved by ~5% (from 18.53 Mb/s to 19.51
>> Mb/s). Tested using uperf, 16B payloads, 64 threads, 100s, averaged from
>> 10 test runs (n=10). This improvement is likely due to packet merging.
>>
>> Large-sized packet throughput decreases ~9% (from 27.25 Gb/s to 25.04
>> Gb/s). Tested using uperf, 64KB payloads, 64 threads, 100s, averaged
>> from 10 test runs (n=10).
>>
>> Medium-sized packet throughput decreases ~5% (from 4.0 Gb/s to 3.81
>> Gb/s). Tested using uperf, 4k to 8k payload sizes picked randomly
>> according to normal distribution, 64 threads, 100s, averaged from 10
>> test runs (n=10).
>
>It is surprizing to me that the original vsock code managed to outperform
>the new one, given that to my knowledge we did not focus on optimizing it.

Yeah mee to.

 From this numbers maybe the allocation cost has been reduced as it 
performs better with small packets. But with medium to large packets we 
perform worse, perhaps because previously we were allocating a 
contiguous buffer up to 64k?
Instead alloc_skb() could allocate non-contiguous pages ? (which would 
solve the problems we saw a few days ago)

@Bobby Are these numbers for guest -> host communication? Can we try the 
reverse path as well?

I will review the patch in the next few days!

Thanks,
Stefano

