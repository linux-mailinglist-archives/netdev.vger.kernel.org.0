Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF6E626324
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 21:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbiKKUpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 15:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbiKKUpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 15:45:16 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B15185470;
        Fri, 11 Nov 2022 12:45:16 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id b185so5820092pfb.9;
        Fri, 11 Nov 2022 12:45:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c2HEMasltS1yPDvm91ly5x6KiWjgyLEEQdyLS8IioLg=;
        b=WhNAkXgslHhgAVdqKqP96D2lYVEu4NjGjwFnynZQv0Ksv9mmQ8fLWO2TlDA/wdmqhI
         r/wK8sUUHo1Qo9l5wVfYkJifcBohQQVj9yJMMWMp9jdfqxwLheOzQpHI3Ph+fYpHss5G
         aVDHp8QNjRafeb3g1VtNCZwFtJ6SL4yPJup4GNy/46YC9plYFnzBZec7WCCF/+DOPNGQ
         cn30A+H1YKbtiGK3J0Yr96GuKukoX2bEEY6S+ZEedvaZHYZrMSQfqapXjIoiW6xbE75y
         NThBNQlsbEfEkY/Ii2dWa+Bud5P4sYf15hH9pG9lCeBtj1swd7r9gRUGddo23zYC58GU
         tY+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c2HEMasltS1yPDvm91ly5x6KiWjgyLEEQdyLS8IioLg=;
        b=dgX1XtVsZ4Ns7S2a9EtH6WMT/Glygirg1rFAw4jOaePzgPtpVdzfV1RiSGIBHnkEoY
         oQ8jB91QodoS5GuLq8ssnLyFtu4npFnyBmF93QuueENwGqdUhQx5qJ296jSyVHRZqK8I
         9GuQz5bbGzOLqbJoClCDYZ2A5Ot0wipSjPLZuFoTSIqwE3tCFjDgvvQigsrJ3GXkvq52
         fQ05T7vqvg3WThuFdf1aXRqx/o1wbfXZHS0nxpuufVPuaTHUPIlSY0XiN3MUhwh1RU7P
         W3TxtUQZ/9zBhTlpiEp7ogFUO6ydW+3e9y3DWGkMRyDtWLPUB7ulOgKpIwgNSA2+A9gJ
         cEyA==
X-Gm-Message-State: ANoB5pn1KuwcExa83QnSljZwxfXKkmpfJzvD5MyAfKxn8o7yDCGPC4Ee
        uDm/cpcrU7R15um5bUo5LKU=
X-Google-Smtp-Source: AA0mqf5er9K38GzKed6ziwcftvLjT+F+/+up4GF5V4OAMHFjsUW5j4AijUg1UqXF5k6oHfEPEEatGg==
X-Received: by 2002:a63:224b:0:b0:45c:562f:b2b9 with SMTP id t11-20020a63224b000000b0045c562fb2b9mr3109177pgm.245.1668199515444;
        Fri, 11 Nov 2022 12:45:15 -0800 (PST)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id 133-20020a62168b000000b0056b9124d441sm1969714pfw.218.2022.11.11.12.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 12:45:14 -0800 (PST)
Date:   Fri, 11 Nov 2022 20:45:13 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "edumazet@google.com" <edumazet@google.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        kernel <kernel@sberdevices.ru>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH v3 00/11] virtio/vsock: experimental zerocopy receive
Message-ID: <Y260WSJKJXtaJQZi@bullseye>
References: <f60d7e94-795d-06fd-0321-6972533700c5@sberdevices.ru>
 <20221111134715.qxgu7t4c7jse24hp@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221111134715.qxgu7t4c7jse24hp@sgarzare-redhat>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 02:47:15PM +0100, Stefano Garzarella wrote:
> Hi Arseniy,
> maybe we should start rebasing this series on the new support for skbuff: https://lore.kernel.org/lkml/20221110171723.24263-1-bobby.eshleman@bytedance.com/
> 
> CCing Bobby to see if it's easy to integrate since you're both changing the
> packet allocation.
> 

This looks like the packet allocation can be married somewhat nicely in
since SKBs may be built from pages using build_skb(). There may be some
tweaking necessary though, since it also uses the tail chunk of the page
to hold struct skb_shared_info IIRC.

I left some comments on the patch with the allocator in it.

> 
> Maybe to avoid having to rebase everything later, it's already worthwhile to
> start using Bobby's patch with skbuff.
> 

I'll be waiting until Monday to see if some more feedback comes in
before sending out v4, so I expect v4 early next week, FWIW.

Best,
Bobby
