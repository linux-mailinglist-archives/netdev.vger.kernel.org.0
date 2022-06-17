Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F75754F946
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 16:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382756AbiFQOhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 10:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382436AbiFQOhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 10:37:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E85F44755C
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 07:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655476628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DzLEVlO+p/pWeRclfP0VKhTEDj31pzoDzWmMqKZhHhk=;
        b=XXHS7JCPK2Y9ETwkFD7J+yoALrVTxF8SPS2ULRFL+lh0Wplo+AJHXa8HM600oFZPHs6PAA
        hCQEjRaCBtP+jP6CxmRYsADbUyydyLbmTpHevUc9EonL8LsoF2H9kJxLUrnfFAHx2HouLY
        rjEzWpOsLzgpoCrtH6xyY1tugUGgJ5A=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-31-brex01W7MP-Pr03ySqer2w-1; Fri, 17 Jun 2022 10:37:03 -0400
X-MC-Unique: brex01W7MP-Pr03ySqer2w-1
Received: by mail-lf1-f70.google.com with SMTP id c25-20020ac25f79000000b00478f05f8f49so2433352lfc.20
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 07:37:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=DzLEVlO+p/pWeRclfP0VKhTEDj31pzoDzWmMqKZhHhk=;
        b=3JgrgpiRrOx2sI2umCk9gxgA+0rkbtMh162bwfNXEfn0uq64g3AoORONq6mKZE9cdD
         z3MGH9PnohgW93XyhAXWL1pBI3g+LCiRYqJVZfrFA27Y0Hrm/A/KBhZKuUZEdLB/AEeO
         on0dJmNupd69/OYqAdDLdQLZj2jeg/XmGJDFKENF2Ny/jQb2BgEu6PCD6esvwRtUBALa
         kcU1IRHLLmdsCupldM107oDRnnanYe0cyS+3t80mqjEKKy1xGs3JziN/ixwQxR1DIJkG
         vZQ57rT9GVWZ7suKoBet4Js6YHs1x2fabxgMhhCRyqK1hbSGAqXjod+jxv1m+Pjv4lAF
         HDdA==
X-Gm-Message-State: AJIora+Bn5H1vzyg02oy2zbtRNHlDZXmm2DNkaST56G37tJ9OyQo9ztx
        gkDQv6yOv3hfhURz0d1hiDQiY/vu992siNcRXAgh+wtcFLw9dzlbiIe8uywF9FNr6WAAuIKaVCS
        hhvA8o9xON67qhy8F
X-Received: by 2002:a05:6512:e9f:b0:479:5a2f:bc4d with SMTP id bi31-20020a0565120e9f00b004795a2fbc4dmr5861751lfb.619.1655476619459;
        Fri, 17 Jun 2022 07:36:59 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vv7NN6RQHghSzY9rni3dAZpaQeqU+hVbM15hIWb5QKHNFJS24jXgmb2aZlmInLs60+ll4H/A==
X-Received: by 2002:a05:6512:e9f:b0:479:5a2f:bc4d with SMTP id bi31-20020a0565120e9f00b004795a2fbc4dmr5861744lfb.619.1655476619216;
        Fri, 17 Jun 2022 07:36:59 -0700 (PDT)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id a5-20020a2eb165000000b002553ab60e17sm568839ljm.122.2022.06.17.07.36.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jun 2022 07:36:58 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <108bf94b-85a6-98d4-175b-2c0d43e17b11@redhat.com>
Date:   Fri, 17 Jun 2022 16:36:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Cc:     brouer@redhat.com, anthony.l.nguyen@intel.com, edumazet@google.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com,
        magnus.karlsson@intel.com, sven.auhagen@voleatech.de
Subject: Re: [PATCH net] igb: fix a use-after-free issue in igb_clean_tx_ring
Content-Language: en-US
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
References: <e5c01d549dc37bff18e46aeabd6fb28a7bcf84be.1655388571.git.lorenzo@kernel.org>
 <f137891f-eb33-b32b-5a16-912eb524ddef@intel.com>
In-Reply-To: <f137891f-eb33-b32b-5a16-912eb524ddef@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16/06/2022 20.26, Jesse Brandeburg wrote:
> On 6/16/2022 7:13 AM, Lorenzo Bianconi wrote:
>> Fix the following use-after-free bug in igb_clean_tx_ring routine when
>> the NIC is running in XDP mode. The issue can be triggered redirecting
>> traffic into the igb NIC and then closing the device while the traffic
>> is flowing.
> 
> <snip>
> 
>>
>> Fixes: 9cbc948b5a20c ("igb: add XDP support")
>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> Thanks Lorenzo, @maintainers this fix seems simple enough you could 
> directly apply it without going through intel-wired-lan, once you think 
> it's ready.
> 
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> 

Sounds good to me.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

