Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADE56C6638
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbjCWLMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbjCWLMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:12:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381661FD6
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 04:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679569878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BchtG9wKeZ97oxXjhrm96XFjZ5ZGtPrJx2tGt2VfOfg=;
        b=MixwL05+8bIr4KefEaQhkgOm7bFc9mIU2qBm2V07yVr+kDzipG2elyP+jFS11ZRl7yJAkp
        cJY+Mk+EYvMN8iJOcps7a5KFCQiFCJVojTztvSuwiXZZGXU1vPw5KhkVuU90ESsAHaTs78
        LJwc4+b9XuZj7KI+dS2n4GAI4kDKCss=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-6tbfu5fmMC2r0CFySG90sw-1; Thu, 23 Mar 2023 07:11:16 -0400
X-MC-Unique: 6tbfu5fmMC2r0CFySG90sw-1
Received: by mail-qk1-f198.google.com with SMTP id z187-20020a3765c4000000b007468706dfb7so5713581qkb.9
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 04:11:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679569876;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BchtG9wKeZ97oxXjhrm96XFjZ5ZGtPrJx2tGt2VfOfg=;
        b=Ub/1lJ8CjbWqqkw44mxSSi8mCgMZhXZDffoevp0fkvw/LDT+sfsou5k6/JHEqCubFa
         bZ6J5A3NQWVP9KCsUpR2lwmuAvVvCPMTzKxXQi2sb2y14q+Hoa+XC1H3DpWrF8YbbiAU
         DnDxtbiFTTPjdz6wsPbw1KOc0V/8B7OHv8E1t2WnnpC6wzz1pGhwsn9+SpzexjdVlr4h
         LsQrmrZ/9Y5KiPnuuWA88tGZ+fmtoEmKbQT8+sBXuBeJODpnZBhhWcXdem2wzjD0Nc6w
         aujJ9Nfm/LH0IlQIJ26IEIPRUscUE5tpfw2RGix1FLXyVe0JTtWchchjJBnM9I3adW6C
         BVQA==
X-Gm-Message-State: AO0yUKXzzq6C1d2ll7RWUO9xDznLUHBTRqvTzbScYRD4f1/4QY7Elie+
        HwyHnDahuUuzUvgbS26A8CzeWj+K4jSNI4i9Le6vMxJXTeZdsw+HmXGrVhmU5haeYYhqDEdDisZ
        cOhUlOPituxAVmC4z
X-Received: by 2002:a05:622a:15d3:b0:3e3:791e:72cf with SMTP id d19-20020a05622a15d300b003e3791e72cfmr10008570qty.26.1679569876174;
        Thu, 23 Mar 2023 04:11:16 -0700 (PDT)
X-Google-Smtp-Source: AK7set/KaamBvlgMtErYI/M4H7LuQVV0ilEhCcyJ2CVaFr2tiTj0CxZrISYp/ghNz4Mfs3oe/NjWig==
X-Received: by 2002:a05:622a:15d3:b0:3e3:791e:72cf with SMTP id d19-20020a05622a15d300b003e3791e72cfmr10008542qty.26.1679569875838;
        Thu, 23 Mar 2023 04:11:15 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id p17-20020a374211000000b007428e743508sm13015960qka.70.2023.03.23.04.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 04:11:15 -0700 (PDT)
Date:   Thu, 23 Mar 2023 12:11:10 +0100
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
Subject: Re: [RFC PATCH v5 0/2] allocate multiple skbuffs on tx
Message-ID: <20230323111110.gb4vlaqaf7icymv3@sgarzare-redhat>
References: <f0b283a1-cc63-dc3d-cc0c-0da7f684d4d2@sberdevices.ru>
 <2e06387d-036b-dde2-5ddc-734c65a2f50d@sberdevices.ru>
 <20230323104800.odrkkiuxi3o2l37q@sgarzare-redhat>
 <15e9ac56-bedc-b444-6d9a-8a1355e32eaf@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15e9ac56-bedc-b444-6d9a-8a1355e32eaf@sberdevices.ru>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 01:53:40PM +0300, Arseniy Krasnov wrote:
>
>
>On 23.03.2023 13:48, Stefano Garzarella wrote:
>> On Thu, Mar 23, 2023 at 01:01:40PM +0300, Arseniy Krasnov wrote:
>>> Hello Stefano,
>>>
>>> thanks for review!
>>
>> You're welcome!
>>
>>>
>>> Since both patches are R-b, i can wait for a few days, then send this
>>> as 'net-next'?
>>
>> Yep, maybe even this series could have been directly without RFC ;-)
>
>"directly", You mean 'net' tag? Of just without RFC, like [PATCH v5]. In this case
>it will be merged to 'net' right?

Sorry for the confusion. I meant without RFC but with net-next.

Being enhancements and not fixes this is definitely net-next material,
so even in RFCs you can already use the net-next tag, so the reviewer
knows which branch to apply them to. (It's not super important since
being RFCs it's expected that it's not complete, but it's definitely an
help for the reviewer).

Speaking of the RFC, we usually use it for patches that we don't think
are ready to be merged. But when they reach a good state (like this
series for example), we can start publishing them already without the
RFC tag.

Anyway, if you are not sure, use RFC and then when a maintainer has
reviewed them all, surely you can remove the RFC tag.

Hope this helps, at least that's what I usually do, so don't take that
as a strict rule ;-)

Thanks,
Stefano

