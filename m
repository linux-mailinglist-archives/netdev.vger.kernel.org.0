Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48FD7673F82
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 18:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjASRGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 12:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbjASRGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 12:06:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B2849429
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 09:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674147959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SqDs16/I+LueVUy81wt70cDHrU7GR/mpu4CiRVI2Wok=;
        b=OggJBjl20RG1qYZVaJLmNAVuHeZFAlXCCzK7LIs/TgCemA7AC9SNeetvALsf0/mp66J/Zp
        zAk086rjJM6gYNuKm7ODTEvXH9KocDJF2p7rbgyvYLZI6BOBzeAcfICNZamIBO1v3CD549
        P1j1woKSss1lKeB41NOlKQJ8vvdqW8o=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-582-lzZRTxWCPNuhoXenY6xTXw-1; Thu, 19 Jan 2023 12:05:58 -0500
X-MC-Unique: lzZRTxWCPNuhoXenY6xTXw-1
Received: by mail-wr1-f69.google.com with SMTP id s3-20020adf9783000000b002ab389f64c1so555166wrb.22
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 09:05:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SqDs16/I+LueVUy81wt70cDHrU7GR/mpu4CiRVI2Wok=;
        b=36PtH/4+geSOgNXriZ04Em4toRqdnqnmOIC/g2YBocp4gMO0FpIPFDl94yXK6nN9gY
         u/X54fpQy7ZanviW+2oOhup91CZFJ9isXCF9NyyJrVSbM/2uQQdVxeJ6Im0vt5VBV2et
         c2olDzeA3a1srt1QoSK5egPCtvQyobScKDmRSb870cLNR3fm3Hl5K1q8QPXQyr5aVR1n
         Zfsvvm4AQ6yBbINx2/0xeSNYHXKmVrY6b4oIux+qWNyIscPe5GVIQKfBTzStJw6am+kn
         KsGjVGRBV0dhSxdf8kpi51nSxlWp5UuYuAZf1IP29DqnWmk/tLrgUVbU5y1ghgI3axh+
         8IKQ==
X-Gm-Message-State: AFqh2kpsgzObHK5LXU7351abqvyoBWtCRV6pck4au+6dscZ6ZheQTrSQ
        iLztbfeqvWXsYPPxj3sabicOLf7yNka3iV6AI5Pszj0m41slP7WDfl84ynJ8ryVNChs44rSpoEC
        FsU8Vc4g66K9aeWI=
X-Received: by 2002:a5d:59c7:0:b0:293:1868:3a14 with SMTP id v7-20020a5d59c7000000b0029318683a14mr6993658wry.0.1674147956960;
        Thu, 19 Jan 2023 09:05:56 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsL9JI1n8lPEchD8izckO5AXv8TXa1kqriBMz4k0q/+x39QtDaWFErPmiIYNZj+l6l3/iGYmA==
X-Received: by 2002:a5d:59c7:0:b0:293:1868:3a14 with SMTP id v7-20020a5d59c7000000b0029318683a14mr6993648wry.0.1674147956789;
        Thu, 19 Jan 2023 09:05:56 -0800 (PST)
Received: from [192.168.122.188] (hellmouth.gulag.org.uk. [85.158.153.62])
        by smtp.gmail.com with ESMTPSA id g11-20020a5d488b000000b002bc7e5a1171sm27260735wrq.116.2023.01.19.09.05.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 09:05:56 -0800 (PST)
From:   Jeremy Harris <jeharris@redhat.com>
X-Google-Original-From: Jeremy Harris <jgh@redhat.com>
Message-ID: <ee84e51b-e41d-9613-fac7-42fa58a1f7ac@redhat.com>
Date:   Thu, 19 Jan 2023 17:05:55 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH net-next 0/7] NIC driver Rx ring ECN
To:     Jakub Kicinski <kuba@kernel.org>
References: <20230111143427.1127174-1-jgh@redhat.com>
 <20230111104618.74022e83@kernel.org>
 <2ff79a56-bf32-731b-a6ab-94654b8a3b31@redhat.com>
 <20230112160900.5fdb5b20@kernel.org>
Content-Language: en-GB
Cc:     netdev@vger.kernel.org, jgh@redhat.com
In-Reply-To: <20230112160900.5fdb5b20@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13/01/2023 00:09, Jakub Kicinski wrote:
> It may be cool if we can retrofit some second-order signal into
> the time-based machinery. The problem is that we don't actually
> have any time-based machinery upstream, yet :(
> And designing interfaces for a decade-old HW seems shortsighted.
> 
>>> Host level congestion is better detected using time / latency signals.
>>> Timestamp the packet at the NIC and compare the Rx time to current time
>>> when processing by the driver.
>>>
>>> Google search "Google Swift congestion control".

> Grep for HWTSTAMP_FILTER_ALL, there's HW out there.

OK.

>> - does not address Rx drops due to Rx ring-buffer overflow
> 
> It's a stronger signal than "continuous run of packets".
> You can have a standing queue of 2 packets, and keep processing
> for ever. There's no congestion, or overload. You'd see that
> timestamps are recent.

Agreed.  That's why marking at a proportion of ring-fill approaching
100% was my "preferred" implementation.  But if the current situation
with NIC API design makes that commonly impractical, I guess it's
a dead duck.

> I experimented last year with implementing CoDel on the input queues,
> worked pretty well (scroll down ~half way):
> 
> https://developers.facebook.com/blog/post/2022/04/25/investigating-tcp-self-throttling-triggered-overload/

That looks nice.  Are there any plans to get that upstream?
-- 
Cheers,
   Jeremy

