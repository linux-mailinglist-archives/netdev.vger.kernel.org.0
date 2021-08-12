Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E593F3EA47E
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 14:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237549AbhHLMUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 08:20:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49544 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237463AbhHLMUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 08:20:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628770775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vKmC5YkDRzwBofq4XWda3KBrNPR0n6/8+JsVWcX9in4=;
        b=QzQwGjb0KXZ0IMjyvoZPNOqDWoW36MW4wYlhGcZdffImD0URIwC2beUHszHeM7+bJ1DTtG
        o8xr7othGodAKr6kdc9PTJHSrY8puWJYmsB586NC2iSO6G3OPIcLenn55CJeI1clx01Yg1
        jcEuS/1z5LMMVL1M2NiWxJrSkvVPOPk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-5bo-kOdjMXq2Pshf9LhjiQ-1; Thu, 12 Aug 2021 08:19:34 -0400
X-MC-Unique: 5bo-kOdjMXq2Pshf9LhjiQ-1
Received: by mail-wr1-f69.google.com with SMTP id e17-20020adfa4510000b02901550e0550f3so1758415wra.11
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 05:19:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:cc:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vKmC5YkDRzwBofq4XWda3KBrNPR0n6/8+JsVWcX9in4=;
        b=ejc8i+UxLG9XSiPddaO+/55Uj8ZBr9hRdnaZgK9EwsWxIy5EUM+U08aPsDfJ2Ymtjq
         QGp3y8Z8c2aqPXJ6FiOKW7yetaEFLJuxIdStSzuoiKEOi4f4zGHpbnDioTWf5/1dqygM
         +NojFi+WwY51dkOzdS3Zunwb9inE24c3lEshy367lxwLJYDUnV1I30JXFWUWUh/q77Rj
         kqGjjOfWjIE4WiL408lr9cWLcoBWWv/D6rWwnga7QcfQcOTwlRXP1Jd1KSyz0B9C/yTZ
         kwCWYu3C4vOr/yl4+dJlM/hlXANs1arNCmokw6VHeJhKZnHKoWI2cLpOytZMWh/Yc2a3
         4KrA==
X-Gm-Message-State: AOAM532+3/41ZrDCdQ90qbL8sGE01jfQdWKUtj6pFnGrcMQYYjsQ0pg0
        cJk1DLCVaejRDsy+6Rui9F8XSBDRkmACwrRI06czCaUmc+PlVwDY4K6R/7Jz3ovXOINee3DwrO0
        Z0ciQP0dvsAstQ/vl
X-Received: by 2002:adf:e5c5:: with SMTP id a5mr3643775wrn.120.1628770773520;
        Thu, 12 Aug 2021 05:19:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyh3mpRx4+tSpvGMhZFyCMJkBTd2zX5gzQsxWqA2o8nGoya+6ffI+jOm3RdAsGVpKlF7gwyqQ==
X-Received: by 2002:adf:e5c5:: with SMTP id a5mr3643715wrn.120.1628770773253;
        Thu, 12 Aug 2021 05:19:33 -0700 (PDT)
Received: from [192.168.42.238] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id z15sm2806100wrp.30.2021.08.12.05.19.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 05:19:32 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com, Saeed Mahameed <saeed@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lukasz Czapnik <lukasz.czapnik@intel.com>,
        Marcin Kubiak <marcin.kubiak@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Shay Agroskin <shayagr@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jian Shen <shenjian15@huawei.com>,
        Petr Vorel <petr.vorel@gmail.com>, Dan Murphy <dmurphy@ti.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 03/21] ethtool, stats: introduce standard XDP
 statistics
To:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
 <20210803163641.3743-4-alexandr.lobakin@intel.com>
 <20210803134900.578b4c37@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ec0aefbc987575d1979f9102d331bd3e8f809824.camel@kernel.org>
 <20210804053650.22aa8a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <43e91ce1-0f82-5820-7cac-b42461a0311a@gmail.com>
 <20210804094432.08d0fa86@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <5653e19f-75fa-9a94-4b45-0cf110fd6e36@redhat.com>
Date:   Thu, 12 Aug 2021 14:19:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210804094432.08d0fa86@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 04/08/2021 18.44, Jakub Kicinski wrote:
> On Wed, 4 Aug 2021 10:17:56 -0600 David Ahern wrote:
>> On 8/4/21 6:36 AM, Jakub Kicinski wrote:
> 
>> Does anyone have data that shows bumping a properly implemented counter
>> causes a noticeable performance degradation and if so by how much? You
>> mention 'yet another cacheline' but collecting stats on stack and
>> incrementing the driver structs at the end of the napi loop should not
>> have a huge impact versus the value the stats provide.
> 
> Not sure, maybe Jesper has some numbers. Maybe Intel folks do?

(sorry, behind on emails after vacation ... just partly answering inside 
this thread, not checking if you did a smart counter impl.).

I don't have exact numbers, but I hope Magnus (Intel) would be motivated 
to validate performance degradation from this patchset.  As I know Intel 
is hunting the DPDK numbers with AF_XDP-zc, where every last cycle *do* 
count.

My experience is that counters can easily hurt performance, without the 
developers noticing the small degradation's.  As Ahern sketch out above 
(stats on stack + end of napi loop update), I do believe that a smart 
counter implementation is possible to hide this overhead (hopefully 
completely in the CPUs pipeline slots).

I do highly appreciate the effort to standardize the XDP stats!
So, I do hope this can somehow move forward.

--Jesper

