Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 031386C2C82
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjCUId7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjCUIda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:33:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFDB3BDB6
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 01:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679387486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xVYNxjgnVb0JFY+7c7KHAdgAuOx4HsFDK20pHkfB6C4=;
        b=bjS8+W0Qm8/poBuM8zy3FmJh8gAKFolG9ITL6nsvbDVtkHeCcfarWGXhXkCYLP2KyR98mX
        cwQ5FHaGNGOOXLx8VTdZ9dtEyj5aM+I3bZdStVK4HiM0Bq1Zmcbj257SLU363DN01pAcs2
        tLLoj6b0esnB99FtYI7rc13quCTqKdc=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-245-Tutx29e5PGWjjZXFmyuv7Q-1; Tue, 21 Mar 2023 04:31:25 -0400
X-MC-Unique: Tutx29e5PGWjjZXFmyuv7Q-1
Received: by mail-qv1-f70.google.com with SMTP id pr2-20020a056214140200b005b3ed9328a3so7294731qvb.10
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 01:31:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679387484;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xVYNxjgnVb0JFY+7c7KHAdgAuOx4HsFDK20pHkfB6C4=;
        b=mGvUHVoAhKvK9uXGI3O+75JJ8hDl1ZjuvoWThGuvVw/wZ4DySItmHmorDVvEAAOv/m
         sbb0O5cip14pGMnhXtDiKt8L7lnR4qefACcs2Ia4ulObOg52hKknSER4w1nRfZqSAoAv
         w+2aiwiJxL9c7sBZkpw+da6KpIiL5DUZtkSFbJPBfQMZV6Hvg5wu7zmug1PicwpekXva
         e3jNWXvsMM1HrkeJgNpDMVm29o2BpnxW4hySUxylcM2gRkvKny6DmO+yHIrEpd9PSgpp
         o0tLZ/Mo7HzokLJQNeKAYmWpElFEZqX2sf2Kfk4lxyJdXUYaJyCDMiF9mvZcISbZQk9l
         Vevg==
X-Gm-Message-State: AO0yUKUW9DkD5sW64XiBVBKzEww3jkiJ3KuYEztbEmI1LoK1rka+lTTF
        yfpW+RItM1iBSDcx4OPQF2GWxPZh686TQOG68chKZosjdTodCW+6ggndFjjwNBrVXJj9x0ocAE5
        5v+mx5mdocxvcWSaZ
X-Received: by 2002:ac8:4e56:0:b0:3bf:c371:789e with SMTP id e22-20020ac84e56000000b003bfc371789emr2992380qtw.14.1679387484564;
        Tue, 21 Mar 2023 01:31:24 -0700 (PDT)
X-Google-Smtp-Source: AK7set8mAj/tW8Sor6IE+2uuuzeTZv1k3R2Mj59suaEEm8G9MRcPpnfF5V7q1374DrXGxP491bPB2w==
X-Received: by 2002:ac8:4e56:0:b0:3bf:c371:789e with SMTP id e22-20020ac84e56000000b003bfc371789emr2992359qtw.14.1679387484325;
        Tue, 21 Mar 2023 01:31:24 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id r16-20020a05620a299000b00746279f3fd5sm9035253qkp.9.2023.03.21.01.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 01:31:23 -0700 (PDT)
Date:   Tue, 21 Mar 2023 09:31:18 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v1 1/3] virtio/vsock: fix header length on skb merging
Message-ID: <20230321083118.63pcdeklvjbqs3as@sgarzare-redhat>
References: <e141e6f1-00ae-232c-b840-b146bdb10e99@sberdevices.ru>
 <63445f2f-a0bb-153c-0e15-74a09ea26dc1@sberdevices.ru>
 <20230320145718.5gytg6t5pcz5rpnm@sgarzare-redhat>
 <329372cf-ef01-8a20-da6e-8c1f9795e41a@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <329372cf-ef01-8a20-da6e-8c1f9795e41a@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 09:10:13PM +0300, Arseniy Krasnov wrote:
>
>
>On 20.03.2023 17:57, Stefano Garzarella wrote:
>> On Sun, Mar 19, 2023 at 09:51:06PM +0300, Arseniy Krasnov wrote:
>>> This fixes header length calculation of skbuff during data appending to
>>> it. When such skbuff is processed in dequeue callbacks, e.g. 'skb_pull()'
>>> is called on it, 'skb->len' is dynamic value, so it is impossible to use
>>> it in header, because value from header must be permanent for valid
>>> credit calculation ('rx_bytes'/'fwd_cnt').
>>>
>>> Fixes: 077706165717 ("virtio/vsock: don't use skbuff state to account credit")
>>
>> I don't understand how this commit introduced this problem, can you
>> explain it better?
>Sorry, seems i said it wrong a little bit. Before 0777, implementation was buggy, but
>exactly this problem was not actual - it didn't triggered somehow. I checked it with
>reproducer from this patch. But in 0777 as value from header was used to 'rx_bytes'
>calculation, bug become actual. Yes, may be it is not "Fixes:" for 0777, but critical
>addition. I'm not sure.
>>
>> Is it related more to the credit than to the size in the header itself?
>>
>It is related to size in header more.
>> Anyway, the patch LGTM, but we should explain better the issue.
>>
>
>Ok, I'll write it more clear in the commit message.

Okay, if 077706165717 triggered the problem, even if it was there from
before, then IMHO it is okay to use that commit in Fixes.

Please, explain it better in the message, so it's clear for everyone ;-)

Thanks,
Stefano

