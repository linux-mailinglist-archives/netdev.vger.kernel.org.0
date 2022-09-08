Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2954C5B20AC
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 16:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbiIHOhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 10:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiIHOhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 10:37:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E819FD021F
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 07:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662647824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wFcDqpqfo5+BlCFcCMK6T6o/K8WN6HmeBg3zPocSOsQ=;
        b=N+tZaDGiUYRQF8AzZbxuUVas3Ry684LxyexUNSPudcRz4ydhuPXxg4p6/ELaE07YT/F+iO
        SZYRySLI+nM03eC7TH9Z98S45uPb6QIGqtZECC32q5xBQqa7H0terh0k2WfR3fSMEfCAhJ
        uBKCqB/pWtdCuDcaQvpAIWD5EXV7UcQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-286-ELQWd1FAMh6P_VOTRWSxkQ-1; Thu, 08 Sep 2022 10:36:59 -0400
X-MC-Unique: ELQWd1FAMh6P_VOTRWSxkQ-1
Received: by mail-wr1-f70.google.com with SMTP id k17-20020adfb351000000b00228853e5d71so4030794wrd.17
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 07:36:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=wFcDqpqfo5+BlCFcCMK6T6o/K8WN6HmeBg3zPocSOsQ=;
        b=peVUtb4npXkGBcbSfteGdj+eJFijDQQKz0gxibtTQv+NHWvkbUUc1ZUEmxPYzx5aJY
         d6cWnBu5skxKb8QNVkmuI9iN6NBMBdL1IRS+7Qm6HD8G6CDb4VsgoLX0C9YhtlZHzi7s
         EfpEnP8g4WmMOqXISjuvihQd16amKbT6BjNFZE9FFiHzjEuWKitW5sjPy/OW9bGEI8j1
         cheYelECMPpsn8FGsex5EDNnWQrxVnYnhbztZGo00bTnzNLZZ3zJop9Kl51x1fO6y2VG
         g7mR9sLnC9SVCLpszCXXCzMaO69dckSwbQYX5sYvwauPJL0iOgccgKRRdSJCKeH5nuHC
         +wiw==
X-Gm-Message-State: ACgBeo2HbHb29EYWDqJx1LSaDGdVTkIflYValaBM4PWJGRxh4COzrr3a
        jvPaKzop+B7Z4y5kAJOFEUCXdwUA/9OLvRhrYKa9KgYcjjt39ZDq5gO5fJ94fIXUTHvCjDpJKdk
        xZi1qJM6ACKVQ8PP2
X-Received: by 2002:a5d:6da2:0:b0:228:64ca:3978 with SMTP id u2-20020a5d6da2000000b0022864ca3978mr5285527wrs.542.1662647818274;
        Thu, 08 Sep 2022 07:36:58 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6BEGVkHcFX/ZuPLpySO7WMaIWzsWXcmGzFBbS0MxMsqv14mvHPWdYH6rv4OjZ1+HxLnAXdhw==
X-Received: by 2002:a5d:6da2:0:b0:228:64ca:3978 with SMTP id u2-20020a5d6da2000000b0022864ca3978mr5285510wrs.542.1662647818042;
        Thu, 08 Sep 2022 07:36:58 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-69.retail.telecomitalia.it. [87.11.6.69])
        by smtp.gmail.com with ESMTPSA id v11-20020a05600c444b00b003a3442f1229sm3131212wmn.29.2022.09.08.07.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 07:36:56 -0700 (PDT)
Date:   Thu, 8 Sep 2022 16:36:52 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Call to discuss vsock netdev/sk_buff [was Re: [PATCH 0/6]
 virtio/vsock: introduce dgrams, sk_buff, and qdisc]
Message-ID: <20220908143652.tfyjjx2z6in6v66c@sgarzare-redhat>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <YxdKiUzlfpHs3h3q@fedora>
 <Yv5PFz1YrSk8jxzY@bullseye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Yv5PFz1YrSk8jxzY@bullseye>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 02:39:32PM +0000, Bobby Eshleman wrote:
>On Tue, Sep 06, 2022 at 09:26:33AM -0400, Stefan Hajnoczi wrote:
>> Hi Bobby,
>> If you are attending Linux Foundation conferences in Dublin, Ireland
>> next week (Linux Plumbers Conference, Open Source Summit Europe, KVM
>> Forum, ContainerCon Europe, CloudOpen Europe, etc) then you could meet
>> Stefano Garzarella and others to discuss this patch series.
>>
>> Using netdev and sk_buff is a big change to vsock. Discussing your
>> requirements and the future direction of vsock in person could help.
>>
>> If you won't be in Dublin, don't worry. You can schedule a video call if
>> you feel it would be helpful to discuss these topics.
>>
>> Stefan
>
>Hey Stefan,
>
>That sounds like a great idea! I was unable to make the Dublin trip work
>so I think a video call would be best, of course if okay with everyone.

Looking better at the KVM forum sched, I found 1h slot for Sep 15 at 
16:30 UTC.

Could this work for you?

It would be nice to also have HyperV and VMCI people in the call and 
anyone else who is interested of course.

@Dexuan @Bryan @Vishnu can you attend?

@MST @Jason @Stefan if you can be there that would be great, we could 
connect together from Dublin.

Thanks,
Stefano

