Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5921D682192
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 02:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjAaBwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 20:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjAaBwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 20:52:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4AC2914C
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 17:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675129877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mBv8DJNmeWTzhqoixUePfk7DvfX/r91Bih49ZwlSTgg=;
        b=DC/74vslTzwnAVEO02wzUzKZO9FsmJQQvVyLu1aOUQQoIFRxiJB2pM3C6SSQ8ZwwTMh653
        0dTn7zVksefp4LEZoq7HcTjcJ7Sgzcq3kwcZ1KyfZXMAdhSzPv2ZX+XPOqVvutfVgE/Fwd
        C6ReLcsooHyYBc0JuMNS1RmenAaSZwE=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-27-FDBhlDN3NiqvNezBuFDMSQ-1; Mon, 30 Jan 2023 20:51:16 -0500
X-MC-Unique: FDBhlDN3NiqvNezBuFDMSQ-1
Received: by mail-pg1-f199.google.com with SMTP id e184-20020a6369c1000000b0049de6cfcc40so6026370pgc.19
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 17:51:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mBv8DJNmeWTzhqoixUePfk7DvfX/r91Bih49ZwlSTgg=;
        b=fYj7y2xRTifoX3g1DUML5piuSavUp8b1rF1LTeLrZgt5nhew7UmI1bMtZ6HlqA/+S8
         YPFcAv3AoJW8RFCC3hyx91J4aPB1Uq9lLSue844+xKzllxRSYQaf0FIctVaCvjrpquJG
         axznjidyY88PDUSfSrw1ZqFLVvsOM7f0SuNQLJ017FSqdg1wk09kRhIAs/5F4ne/PS5a
         iU7/KxWz61WJOCXf46dDKe2AxAjvjpCJt7lIqq9LTudw4J/yBhnJYkDNqB9Rq6hYIYeA
         r36JMtv4qhLIvca8v1Y5RF0SB+3EwQNuZcy1JQY8o+pqxZHtDB0O8WY6Rs1ddrpPJw7B
         7/5A==
X-Gm-Message-State: AO0yUKVKa0RZO3cjNpdkqU7XFkrCLXkwPcHrawwjnPR79BMU9f+IqKgw
        iaLV7B+Tj5JZ7L9oANeNi1DJ/ELM+U48XcPpzCAKJgwMfz9KlUYcYQQmH1YslYJbpfel4lw9fOh
        MIqL2+5FiDH8PlWBO
X-Received: by 2002:a17:902:d487:b0:196:15af:e6de with SMTP id c7-20020a170902d48700b0019615afe6demr29574963plg.68.1675129875374;
        Mon, 30 Jan 2023 17:51:15 -0800 (PST)
X-Google-Smtp-Source: AK7set8JSjJ+sRvtPcXP6fVdufCYZ8fk74MG4aecVDj2Iej+5W2CdxzxrzRUj04G/QWJkYRImmyA4Q==
X-Received: by 2002:a17:902:d487:b0:196:15af:e6de with SMTP id c7-20020a170902d48700b0019615afe6demr29574939plg.68.1675129875072;
        Mon, 30 Jan 2023 17:51:15 -0800 (PST)
Received: from [10.72.13.217] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id o17-20020a170902d4d100b00196077ba463sm8430985plg.123.2023.01.30.17.51.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 17:51:14 -0800 (PST)
Message-ID: <ba3adefd-f2d8-d074-4dfc-5677c3cd71a3@redhat.com>
Date:   Tue, 31 Jan 2023 09:51:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 12/23] ceph: use bvec_set_page to initialize a bvec
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>, Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        devel@lists.orangefs.org, io-uring@vger.kernel.org,
        linux-mm@kvack.org
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-13-hch@lst.de>
 <CAOi1vP_b77Pq=hYmFMi1zGGRMee2uNjbAbHz_gCCoByOdbRqLw@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP_b77Pq=hYmFMi1zGGRMee2uNjbAbHz_gCCoByOdbRqLw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 31/01/2023 02:02, Ilya Dryomov wrote:
> On Mon, Jan 30, 2023 at 10:22 AM Christoph Hellwig <hch@lst.de> wrote:
>> Use the bvec_set_page helper to initialize a bvec.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> ---
>>   fs/ceph/file.c | 10 +++++-----
>>   1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 764598e1efd91f..6419dce7c57987 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -103,11 +103,11 @@ static ssize_t __iter_get_bvecs(struct iov_iter *iter, size_t maxsize,
>>                  size += bytes;
>>
>>                  for ( ; bytes; idx++, bvec_idx++) {
>> -                       struct bio_vec bv = {
>> -                               .bv_page = pages[idx],
>> -                               .bv_len = min_t(int, bytes, PAGE_SIZE - start),
>> -                               .bv_offset = start,
>> -                       };
>> +                       struct bio_vec bv;
>> +
>> +                       bvec_set_page(&bv, pages[idx],
> Hi Christoph,
>
> There is trailing whitespace on this line which git complains about
> and it made me take a second look.  I think bvec_set_page() allows to
> make this more compact:
>
>          for ( ; bytes; idx++, bvec_idx++) {
>                  int len = min_t(int, bytes, PAGE_SIZE - start);
>
>                  bvec_set_page(&bvecs[bvec_idx], pages[idx], len, start);
>                  bytes -= len;
>                  start = 0;
>          }
>
This looks better.

Thanks

