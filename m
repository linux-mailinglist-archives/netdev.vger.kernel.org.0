Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98E76603BF
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 16:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbjAFPx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 10:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbjAFPx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 10:53:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF6B13D16
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 07:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673020387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OdCMOC17SdPX8FiSgqMmaYf5o7DI2r40nfy0dYBiQ5Y=;
        b=PNv9Lfn8UgcaCI1T6ftrPLxjpYQ8CcnO6zbrMOcd8nEi/8w/BE2c/vCBd/d6hwVjoTl2hn
        BIAiQF8pJZUozLnIvFPc1EelHsCLs1R/Yj3aY/Z/dGkY2XktgmoF/gQdG21uaiho6mccvD
        dxj+dpWkJqD+VRicjCOmF962TSym2zg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-654-9qRUSXhWMni_rzXiVy82gA-1; Fri, 06 Jan 2023 10:53:06 -0500
X-MC-Unique: 9qRUSXhWMni_rzXiVy82gA-1
Received: by mail-ej1-f72.google.com with SMTP id wz4-20020a170906fe4400b0084c7e7eb6d0so1371431ejb.19
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 07:53:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OdCMOC17SdPX8FiSgqMmaYf5o7DI2r40nfy0dYBiQ5Y=;
        b=sC5IWZpfSX0Phy23LQnlVnxbjedIW1jtY2Kf8hO0kppRsRpzNUtEyGHqkKzwuganrD
         wwkVSWjNSJlMrHzlklYrZeR7wk1BQ92Eh3JHNjR++nhSB8Vl9mrSS/CGVlvklnn+MTwP
         6+nGjTQhyby0y4DPblYXv0KMD17cBByYnv1q+EXP8Yt9ENqpUWpktv7SSwD/Tp2vfjlK
         TCMtUOSEE+AEgpD/GIrHQMXn+qQWv90K/Syam5zG/FwGLy5YhO67N4yB5xptRSY3rkKk
         CQsUzsV42opB64Y8UoDYv3rGTFAAznCx03aTRUYINxnUuEL45O9aiqgHAiE4vHjdQ1FQ
         cm2A==
X-Gm-Message-State: AFqh2koQTAe0R4Z/DWtXjEz3FK0oE47/wQMo7Cowk863dcj9g8RD9F5A
        NZlyxaltV6ib5Geug6FUJrqeuh11I2rMnyk0LOUEBMFz+6xzHCCVEbp/35DATbb7AOxnzxSVrv2
        NoZK006Pl+YGZtpF1
X-Received: by 2002:a17:906:99d1:b0:7c0:ff76:dc12 with SMTP id s17-20020a17090699d100b007c0ff76dc12mr32080717ejn.2.1673020385311;
        Fri, 06 Jan 2023 07:53:05 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuyBY2k7zqXkK7vqaHOaS+XILfHcUDwXdJ5Q0SZbKT8rnMTbbUUnRJVeC+iOMrm5L6SVLhf+Q==
X-Received: by 2002:a17:906:99d1:b0:7c0:ff76:dc12 with SMTP id s17-20020a17090699d100b007c0ff76dc12mr32080703ejn.2.1673020385104;
        Fri, 06 Jan 2023 07:53:05 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id ku12-20020a170907788c00b007bc8ef7416asm523161ejc.25.2023.01.06.07.53.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 07:53:04 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <ac69f920-fc7b-7bc6-be36-0fbe12fd2dec@redhat.com>
Date:   Fri, 6 Jan 2023 16:53:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 19/24] xdp: Convert to netmem
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-20-willy@infradead.org>
In-Reply-To: <20230105214631.3939268-20-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 05/01/2023 22.46, Matthew Wilcox (Oracle) wrote:
> We dereference the 'pp' member of struct page, so we must use a netmem
> here.
> 
> Signed-off-by: Matthew Wilcox (Oracle)<willy@infradead.org>
> ---
>   net/core/xdp.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

