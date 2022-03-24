Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F534E61F0
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 11:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349508AbiCXKru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 06:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240458AbiCXKru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 06:47:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C6037A27C0
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 03:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648118777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SY8Zpg3HfKN7OLvRr+t2R2NBXsTqrDCHJm44fgalnyI=;
        b=H+0yYJohDgCfJzHIuhECwrzd2IoNwfRHJLnGknVRPE/PJlqjJBQiKjzhKgj2EWseTvCXdD
        gPbsufjNdnWqCpmARxMlLF3+JZZlWK+SXlljE2iKp2sPrUOps9Osl0VJtkVGwoTKRt+pVM
        zyXlIr2FjBeAU5tKMFoUxDt8NBET5UE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-36-56vT88VtO-C1uQkHY6W_lg-1; Thu, 24 Mar 2022 06:46:16 -0400
X-MC-Unique: 56vT88VtO-C1uQkHY6W_lg-1
Received: by mail-wr1-f72.google.com with SMTP id o9-20020adfca09000000b001ea79f7edf8so1537974wrh.16
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 03:46:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=SY8Zpg3HfKN7OLvRr+t2R2NBXsTqrDCHJm44fgalnyI=;
        b=Y/z/xXawYMmA4VpiBH4vk7P5gNyWRu2bfo2TBMErBFZhGGunFpzykaU9GKRyhbTijf
         xV+ms+H9D27lh6XD76B+dXF3+WxDokg8xn1JRQ01kfxl3L8tTazHV7EGK5Q7aq22b79M
         oB9YMYnXDo9vZl2138N258OvlYqnhYyJnLMl5Y0BPGyROSggApv1LRbbYAg3ar7+w4xe
         ZYuFOQjuBQ5zaFK5wD85mG4Cfag1B/TkMcmWXyyoMqsVLDVxj6krFSQyuqZHZeF/s4se
         JmxHxNqGVslgGHcbc/7XcNAucj9EPHyDHUddyQcBpSqCCA7YQj6CcHeXLzSS32/mzyop
         yBig==
X-Gm-Message-State: AOAM533aiHidpOc74UfmyFQJPPO2UcwCa/uOkckL4sLb8sgyxa0irs45
        7IEkWk/sGASOK72IyO4WIBDdfjAHkbCuzUOI+n7H1lW/Dhk0c+0Gfme7N72n87Pw7hCdHFAw1LT
        tmxs75vUUTeiTidE1
X-Received: by 2002:a05:6000:1083:b0:203:fbd3:937e with SMTP id y3-20020a056000108300b00203fbd3937emr3947184wrw.139.1648118775385;
        Thu, 24 Mar 2022 03:46:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqwK363x/lQQ7GkLV8cbmtKe+6jv7+DtEPxZLenuGRyjD62htTnjjltK8uF850hOZimwkWcw==
X-Received: by 2002:a05:6000:1083:b0:203:fbd3:937e with SMTP id y3-20020a056000108300b00203fbd3937emr3947168wrw.139.1648118775167;
        Thu, 24 Mar 2022 03:46:15 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-232-135.dyn.eolo.it. [146.241.232.135])
        by smtp.gmail.com with ESMTPSA id t4-20020a05600001c400b00203fb5dcf29sm2188758wrx.40.2022.03.24.03.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 03:46:14 -0700 (PDT)
Message-ID: <7393b673c626fd75f2b4f8509faa5459254fb87c.camel@redhat.com>
Subject: Re: [PATCH] bnx2x: replace usage of found with dedicated list
 iterator variable
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakob Koschel <jakobkoschel@gmail.com>,
        Ariel Elior <aelior@marvell.com>
Cc:     Sudarsana Kalluru <skalluru@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Date:   Thu, 24 Mar 2022 11:46:13 +0100
In-Reply-To: <20220324070816.58599-1-jakobkoschel@gmail.com>
References: <20220324070816.58599-1-jakobkoschel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, 2022-03-24 at 08:08 +0100, Jakob Koschel wrote:
> To move the list iterator variable into the list_for_each_entry_*()
> macro in the future it should be avoided to use the list iterator
> variable after the loop body.
> 
> To *never* use the list iterator variable after the loop it was
> concluded to use a separate iterator variable instead of a
> found boolean [1].
> 
> This removes the need to use a found variable and simply checking if
> the variable was set, can determine if the break/goto was hit.
> 
> Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/
> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>

This looks like a purely net-next change, and we are in the merge
window: net-next is closed for the time being. Could you please re-post
after net-next re-open?

Additionally, I suggest you to bundle the net-next patches in a single
series, namely:

bnx2x: replace usage of found with dedicated list iterator variable 
octeontx2-pf: replace usage of found with dedicated list iterator variable 
sctp: replace usage of found with dedicated list iterator variable 
taprio: replace usage of found with dedicated list iterator variable 

that will simplify the processing, thanks!

Paolo

