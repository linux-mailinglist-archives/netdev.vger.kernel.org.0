Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B649F673556
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 11:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbjASKTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 05:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjASKTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 05:19:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E7D2D15E
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 02:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674123485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZyAzDZKr0/bMIvP5l7bauvOI4AE9MO2mQ9K2TxYaceY=;
        b=ZH9oYSIhPiriW8tM4cB/HTwPjK5L85Cb3y3JardBb4CTo8kUN9v+jqGo5XqPlTBMbqGFBl
        1BWDNbwcts8mJpTDzZ/IfE/3titvV263AyfqK8ojEWjtylEjnxsdNSlPzGKmvGTOsCu0Rs
        x1VPmxQM8ehhJD6nshJdw4UsbXrSH1o=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-637-G1PpAR58PwityjhB2A7tnA-1; Thu, 19 Jan 2023 05:18:01 -0500
X-MC-Unique: G1PpAR58PwityjhB2A7tnA-1
Received: by mail-ed1-f69.google.com with SMTP id h18-20020a05640250d200b0049e0e9382c2so1321304edb.13
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 02:18:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZyAzDZKr0/bMIvP5l7bauvOI4AE9MO2mQ9K2TxYaceY=;
        b=63Arrl2LrUUMryilax08mRghOkwKF9CD40ozV+vGEGh+sz3My8UYJqFuiaTWDRSgCr
         NKePpRzPdjKuiwgeLWNBCQI/Y72mZna5Vl9VT5O3l4sTNvJ4NceTeULiSrTr9BWeDXNy
         igsq2oXcA1HdUzmPGYckGL51F0uY2z2Lc9RZKSnGUuZdrpsZ9f8djPP+AQPwj1IZUuH8
         iC/+a/PJbjqOHgQ5QqZldrlR0Am0/FEUlScPg6j50/IvFWFGkR3h/ih+qBW+wBxldhBe
         7npWrC2eyKlLnxzr238kwtgwG1KDV3P52iYYITGdZt0RLYJGNs8xOkqarRLBn+knhnAh
         poGA==
X-Gm-Message-State: AFqh2kqioozvx3u6Jp7NAgMyiCURnWx2yyARwIEhn/ZwZqpYcg4/KuDM
        40orJtMBmEB2DdZpZcJu7Af4he6ZQKyz732dReqzIK5jHRQsXbfKbFm2xV9ynaxbKslAMYYDU6m
        AMnTcF6lvCSwpua7f
X-Received: by 2002:a17:907:1019:b0:84c:69f8:2ec2 with SMTP id ox25-20020a170907101900b0084c69f82ec2mr10335721ejb.22.1674123480784;
        Thu, 19 Jan 2023 02:18:00 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt25IiIHToqdq+4JX+Dyw/Z1VFB0gczPMWZ3/G8Ja6BBnFQqZ1k6HFGQNSd1rYhcPF3q9uyJQ==
X-Received: by 2002:a17:907:1019:b0:84c:69f8:2ec2 with SMTP id ox25-20020a170907101900b0084c69f82ec2mr10335703ejb.22.1674123480556;
        Thu, 19 Jan 2023 02:18:00 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id p8-20020a17090653c800b00872c0bccab2sm3683389ejo.35.2023.01.19.02.17.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 02:18:00 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <e564a0de-e149-34a0-c0ba-8f740df0ae70@redhat.com>
Date:   Thu, 19 Jan 2023 11:17:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next V2 2/2] net: kfree_skb_list use
 kmem_cache_free_bulk
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <167361788585.531803.686364041841425360.stgit@firesoul>
 <167361792462.531803.224198635706602340.stgit@firesoul>
 <6f634864-2937-6e32-ba9d-7fa7f2b576cb@redhat.com>
 <20230118182600.026c8421@kernel.org>
In-Reply-To: <20230118182600.026c8421@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19/01/2023 03.26, Jakub Kicinski wrote:
> On Wed, 18 Jan 2023 22:37:47 +0100 Jesper Dangaard Brouer wrote:
>>> +		skb_mark_not_on_list(segs);
>>
>> The syzbot[1] bug goes way if I remove this skb_mark_not_on_list().
>>
>> I don't understand why I cannot clear skb->next here?
> 
> Some of the skbs on the list are not private?
> IOW we should only unlink them if skb_unref().

Yes, you are right.

The skb_mark_not_on_list() should only be called if __kfree_skb_reason()
returns true, meaning the SKB is ready to be free'ed (as it calls/check
skb_unref()).

I will send a proper fix patch shortly... after syzbot do a test on it.

--Jesper

