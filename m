Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565B064B8C8
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 16:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbiLMPoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 10:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236287AbiLMPoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 10:44:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665D422299
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 07:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670946193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ta5qJGL6TYgTS7WdcfK/NhG2rVIgkTUOeHGwN5QJWEY=;
        b=JQ6RmByxFW0d0XbO6fXrkhCIhmaIYc2c9mouZII98kriYOJq4pn4Gr1ltUL62pfZEPHsVC
        w8o7xiyhol2bAh7x/w9UbgUWgMjorKEgDTD/W05F9ZOOAMKwDuz/AKj/0uZcu8PCPP+85v
        N7BjJ+xW1okwWikpnVPUtbIGuck/w5o=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-494-aAIbIDMcOFGPCMwprcs-IA-1; Tue, 13 Dec 2022 10:43:11 -0500
X-MC-Unique: aAIbIDMcOFGPCMwprcs-IA-1
Received: by mail-wm1-f70.google.com with SMTP id h81-20020a1c2154000000b003d1c8e519fbso5812653wmh.2
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 07:43:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ta5qJGL6TYgTS7WdcfK/NhG2rVIgkTUOeHGwN5QJWEY=;
        b=TmvdEnpmgVBgG6+aiXrQy6q9zsd2I2JZq/QikLHkdKMJPLlElq7sy6aL3659daBpK1
         HT9/+MhMdPkS569O4ojSntvGGrCjBwKSNeStf2YP0slwHfSy50Ya7PSkUK8CC6vbXKDX
         JhuPoLlCsJykE0gxfpewRZZXSsAW4HjxdArgUH/FYKWdht9LrZdNJ31ZCWo5svYOeava
         M4haKn3Nh/MMK9dhwiBc7ojgPOjHnF4tI2tNEVqDkJzVvcyNiOYv1vee3RCdKfF2ZMAu
         cBs/EuRelpBHzpXEAP8Eam60/JEr0Moc9H4DDpVL8YAYRVn5q7pGpdWeRptuzfwEIcNG
         lZsw==
X-Gm-Message-State: ANoB5plBEtN/tdXkzgcPRXoZAGF9J4RTAuPMyI3WbzA8PSiyEFCmDrgD
        2eEabEpjLXOwsQZydkTtpbUzDPqCxbXqFNJDgWgluWe1qji3RH88zZqOPIrCGXpRnWYRDZyhFcD
        MtLigTY6wJYFL8Mls
X-Received: by 2002:a05:6000:550:b0:242:880:20ce with SMTP id b16-20020a056000055000b00242088020cemr13771060wrf.47.1670946190490;
        Tue, 13 Dec 2022 07:43:10 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7Fome2UWsPehy6lJdurAxcXv7sPgyHhsfgJzvy5rYv8HZ777S+ULuoF2cVj9aNlQvSN3jKBA==
X-Received: by 2002:a05:6000:550:b0:242:880:20ce with SMTP id b16-20020a056000055000b00242088020cemr13771047wrf.47.1670946190282;
        Tue, 13 Dec 2022 07:43:10 -0800 (PST)
Received: from sgarzare-redhat (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id j14-20020a5d564e000000b0024165454262sm135347wrw.11.2022.12.13.07.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 07:43:09 -0800 (PST)
Date:   Tue, 13 Dec 2022 16:43:04 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6] virtio/vsock: replace virtio_vsock_pkt with
 sk_buff
Message-ID: <20221213154304.rjrwzbv6jywkrpxq@sgarzare-redhat>
References: <20221213072549.1997724-1-bobby.eshleman@bytedance.com>
 <20221213102232.n2mc3y7ietabncax@sgarzare-redhat>
 <20221213100510-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221213100510-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 10:06:23AM -0500, Michael S. Tsirkin wrote:
>On Tue, Dec 13, 2022 at 11:22:32AM +0100, Stefano Garzarella wrote:
>> > +	if (len <= GOOD_COPY_LEN && !skb_queue_empty_lockless(&vvs->rx_queue)) {
>>
>> Same here.
>>
>> If there are no major changes to be made, I think the next version is the
>> final ones, though we are now in the merge window, so net-next is closed
>> [1], only RFCs can be sent [2].
>>
>> I suggest you wait until the merge window is over (two weeks usually) to
>> send the next version.
>
>Nah, you never know, could be more comments. And depending on the timing
>I might be able to merge it.

Right, in the end these changes are only to virtio-vsock transport, so 
they can go smoothly even with your tree.

@Bobby, so if you can fix the remaining small things, we can try to 
merge it :-)

Thanks,
Stefano

