Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0683637C95
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiKXPNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiKXPNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:13:54 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302A315AAB4;
        Thu, 24 Nov 2022 07:13:53 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id bp15so2933603lfb.13;
        Thu, 24 Nov 2022 07:13:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XPUoBYfcFjyl7FwxKw5AFCfnK5DVVfvD4huQjq4ERM0=;
        b=AkPWvGH7j6VUvs4P98n6tnaY9J6JAvXPdd/8I4dDqfahyZkB9/YF9YbpwSTldp2f3X
         jP6cM8a7DgYWkMkvFtxggc6GWfTNC4vjntqRqniI6jqUqUqENSM/mvV5VCGA25hKBIsu
         AFQVcKd4OGc5b9LF6tF+BLmlbMhvqku4+CLbq4eJg8SJcXZ9olxRuk1PwX5UectHJU6h
         hMuzXIJIXfjKwB91kTU6RVFs7gcA5CmrgQvbXdN1mi4g3ri55lsaoKb0479D2z+fSdDJ
         ne4NwNnw/tBB0jh+CbdKrYYRDVZgIWRnBgOxL23yIyGAOMZurS5GWwZ9F9NYyYHPLgdx
         Rpow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XPUoBYfcFjyl7FwxKw5AFCfnK5DVVfvD4huQjq4ERM0=;
        b=5uJC2YQNPyR8TFBcuQZBAR8T6/qU8BL9dQaoSP6enIpcApyGZA76xzYJuzpw3v6SWW
         fzOPHemahlrPPWEmYvToFIMfonCTH7AHSnZeos10rdQqqzBdC0/IZyWc7eN3oH6Siza/
         +l0UlyeR2UWIW3kVHRNKwHLQwQNVg2HhHOfkYIqFWkfpHW4f2w2NrVcUA9PJz2eHBQiu
         LCn/XG7GiI+NvJ+6iZmnxAoSwpjXPimJPpi8cqyZa7kOqh+mhNR8+aSlmzS3gvGxHtxw
         VqscaRcxMX5LrE+Qyraow8T9hIZN51s3fM50w9jTFEESr0AzMz9d3zyuAtPgk1dP5CWN
         RVxQ==
X-Gm-Message-State: ANoB5pnjSw63WHTbWrm8ytmGWmynIyNcklnCRBCNHbElBAK5s79qvX5M
        ZTdH1nbr+El3VXW42lTlP/RdIAcTxq5lU9X6
X-Google-Smtp-Source: AA0mqf4k0uXoT2d9p9bR4yGYvChWpenmHBP0KZLaPEZf8Nogjyhp2jYojmpP1532YnbY3Tqz7QTaNg==
X-Received: by 2002:ac2:5331:0:b0:4ab:35a8:2fa0 with SMTP id f17-20020ac25331000000b004ab35a82fa0mr8789857lfh.233.1669302831294;
        Thu, 24 Nov 2022 07:13:51 -0800 (PST)
Received: from [192.168.0.103] ([77.220.140.242])
        by smtp.gmail.com with ESMTPSA id u25-20020ac25199000000b00494a8fecacesm145435lfi.192.2022.11.24.07.13.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Nov 2022 07:13:50 -0800 (PST)
Message-ID: <03d74a68-91a3-04dd-613b-33e232937cbc@gmail.com>
Date:   Thu, 24 Nov 2022 18:13:49 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v4] virtio/vsock: replace virtio_vsock_pkt with sk_buff
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, AVKrasnov@sberdevices.ru
References: <20221124060750.48223-1-bobby.eshleman@bytedance.com>
 <20221124150005.vchk6ieoacrcu2gb@sgarzare-redhat>
From:   Arseniy Krasnov <oxffffaa@gmail.com>
In-Reply-To: <20221124150005.vchk6ieoacrcu2gb@sgarzare-redhat>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Stefano

On 24.11.2022 18:00, Stefano Garzarella wrote:
> This is a net-next material, please remember to use net-next tag:
> https://www.kernel.org/doc/html/v6.0/process/maintainer-netdev.html#netdev-faq
> 
> On Wed, Nov 23, 2022 at 10:07:49PM -0800, Bobby Eshleman wrote:
>> This commit changes virtio/vsock to use sk_buff instead of
>> virtio_vsock_pkt. Beyond better conforming to other net code, using
>> sk_buff allows vsock to use sk_buff-dependent features in the future
>> (such as sockmap) and improves throughput.
>>
>> This patch introduces the following performance changes:
>>
>> Tool/Config: uperf w/ 64 threads, SOCK_STREAM
>> Test Runs: 5, mean of results
>> Before: commit 95ec6bce2a0b ("Merge branch 'net-ipa-more-endpoints'")
>>
>> Test: 64KB, g2h
>> Before: 21.63 Gb/s
>> After: 25.59 Gb/s (+18%)
>>
>> Test: 16B, g2h
>> Before: 11.86 Mb/s
>> After: 17.41 Mb/s (+46%)
>>
>> Test: 64KB, h2g
>> Before: 2.15 Gb/s
>> After: 3.6 Gb/s (+67%)
>>
>> Test: 16B, h2g
>> Before: 14.38 Mb/s
>> After: 18.43 Mb/s (+28%)
>>
>> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>> ---
> 
> The patch LGTM. I run several tests (iperf3, vsock_test,
> vsock_diag_test, vhost-user-vsock, tcpdump) and IMO we are okay.
> 
> I found the following problems that I would like to report:
> 
> - vhost-user-vsock [1] is failing, but it is not an issue of this patch,
>   but a spec violation in the rust-vmm/vm-virtio/virtio-vsock crate as I
>   reported here [2]. We will fix it there, this patch is fine, indeed
>   trying a guest with the new layout (1 descriptor for both header and
>   data) with vhost-vsock in Linux 6.0, everything works perfectly.
> 
> - the new "SOCK_SEQPACKET msg bounds" [3] reworked by Arseniy fails
>   intermittently with this patch.
> 
>   Using the tests currently in the kernel tree everything is fine, so
>   I don't understand if it's a problem in the new test or in this
>   patch. I've looked at the code again and don't seem to see any
>   criticisms.
> 
>   @Arseniy @Bobby can you take a look?
Seems i've found this problem here:

https://lkml.org/lkml/2022/11/24/708

Being fixed - all tests passes

Thank You!
> 
>   I'll try to take a closer look too, and before I give my R-b I'd like
>   to make sure it's a problem in the test and not in this patch.
> 
>   This is what I have (some times, not always) with both host and guest
>   with this patch and the series of [3] applied:
> 
>   host$ ./vsock_test --control-host=192.168.133.3 --control-port=12345 \
>                      --mode=client --peer-cid=4
>   Control socket connected to 192.168.133.3:12345.
>   0 - SOCK_STREAM connection reset...ok
>   1 - SOCK_STREAM bind only...ok
>   2 - SOCK_STREAM client close...ok
>   3 - SOCK_STREAM server close...ok
>   4 - SOCK_STREAM multiple connections...ok
>   5 - SOCK_STREAM MSG_PEEK...ok
>   6 - SOCK_SEQPACKET msg bounds...ok
>   7 - SOCK_SEQPACKET MSG_TRUNC flag...recv: Connection reset by peer
> 
>   guest$ ./vsock_test --control-port=12345 --mode=server --peer-cid=2
>   Control socket listening on 0.0.0.0:12345
>   Control socket connection accepted...
>   0 - SOCK_STREAM connection reset...ok
>   1 - SOCK_STREAM bind only...ok
>   2 - SOCK_STREAM client close...ok
>   3 - SOCK_STREAM server close...ok
>   4 - SOCK_STREAM multiple connections...ok
>   5 - SOCK_STREAM MSG_PEEK...ok
>   6 - SOCK_SEQPACKET msg bounds...Message bounds broken
> 
> Thanks,
> Stefano
> 
> [1] https://github.com/rust-vmm/vhost-device/tree/main/crates/vsock
> [2] https://github.com/rust-vmm/vm-virtio/issues/204
> [3] https://lore.kernel.org/lkml/c991dffd-1dbc-e1d1-b682-a3c71f6ce51c@sberdevices.ru/
> 
