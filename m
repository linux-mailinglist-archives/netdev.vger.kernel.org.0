Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7142666CDB
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 09:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239846AbjALItc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 03:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239993AbjALIss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 03:48:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49E13AB22
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 00:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673513177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1N2k8G9QPhAF/lVVnkzLTvxKdFyyG9cAsCkNsoWreio=;
        b=OtLk+BFv6BcO111JawSQ+cKAmv5j4QFgeqEUIXTyC2ik++jX1tu4E4n+yFC9C+LE/MdxAi
        FCYvTxATVRzTpupzJIlVBdbkXPcUzOdrk6rScclFoagWUmGniQgXLfltwSFr6MS9ptCll2
        XoRHLIs+u7GBHeJHsFkH9FU+A9Uxdy0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-617-YoAFM0fTNUmZ7vR90WL90Q-1; Thu, 12 Jan 2023 03:46:15 -0500
X-MC-Unique: YoAFM0fTNUmZ7vR90WL90Q-1
Received: by mail-ej1-f70.google.com with SMTP id sh12-20020a1709076e8c00b0084d4e7890a0so7645450ejc.7
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 00:46:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1N2k8G9QPhAF/lVVnkzLTvxKdFyyG9cAsCkNsoWreio=;
        b=gcPz4hxbOAzBdNL5G2Ej7z3I3v6/CmLa91a/2UDXJmKKD4PTrPzH4w98+n5Ief+DBU
         66iCMi42gXu+PF1Q5Qj2mqK6nPwSGoexUtLJaV2j4w2254bCvX5lPmX3R2E6gwSbeQ4Y
         GLhn94+nspkKvMJzaaaRVrvxcQF4Y44gonxfl+ypAYoysLmloWyc5fLKMFcFtyq9e/e6
         AT6BdXZpvL8fM6IWIw0C13F94RegqSIH4QIGmawLvygHmG1qb7yzImUmT0rteYyP++R9
         +v++W1T5sbmv89pKNamU5VjRI8uIrH2zVAHkuzlOnZkQ66nC/Wwdi94txol93YO0sRti
         FGvA==
X-Gm-Message-State: AFqh2kpBuMDnipyBu0aBiYOezkv6+9SZBcLVYRYQsqLmPLeObyzO65sH
        irWctf9DgsVrXEUebhBiCqubh76es4OpqfzHjnnx3+7KmMOW8A1r868a3qDDxkzp5PMbKD4jFtN
        Y/tbYNyzfQxBy2Vxj
X-Received: by 2002:a17:907:7b88:b0:84d:465f:d2fe with SMTP id ne8-20020a1709077b8800b0084d465fd2femr13378525ejc.41.1673513174523;
        Thu, 12 Jan 2023 00:46:14 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv3XejnpCxnn3n+C2D8Ijcz4buUlPB2wo+7H83mIypX7N1GzssS0wXV7qT5mJWwdiHhUdmHIA==
X-Received: by 2002:a17:907:7b88:b0:84d:465f:d2fe with SMTP id ne8-20020a1709077b8800b0084d465fd2femr13378521ejc.41.1673513174311;
        Thu, 12 Jan 2023 00:46:14 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id 11-20020a170906300b00b008675df83251sm250138ejz.34.2023.01.12.00.46.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 00:46:13 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <b5b54760-63bb-2e87-7c01-c3517ca86786@redhat.com>
Date:   Thu, 12 Jan 2023 09:46:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v3 17/26] page_pool: Convert page_pool_return_skb_page()
 to use netmem
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20230111042214.907030-1-willy@infradead.org>
 <20230111042214.907030-18-willy@infradead.org>
In-Reply-To: <20230111042214.907030-18-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/01/2023 05.22, Matthew Wilcox (Oracle) wrote:
> This function accesses the pagepool members of struct page directly,
> so it needs to become netmem.  Add page_pool_put_full_netmem().
> 
> Signed-off-by: Matthew Wilcox (Oracle)<willy@infradead.org>
> Reviewed-by: Jesse Brandeburg<jesse.brandeburg@intel.com>
> ---
>   include/net/page_pool.h |  9 ++++++++-
>   net/core/page_pool.c    | 13 ++++++-------
>   2 files changed, 14 insertions(+), 8 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

