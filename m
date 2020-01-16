Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB81413DC3D
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbgAPNjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:39:00 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38508 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgAPNi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 08:38:59 -0500
Received: by mail-wr1-f66.google.com with SMTP id y17so19202951wrh.5
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 05:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N3obRAIyIl+6u7JuAN54pttOMvMsTv5wq2/SDqyRJ7k=;
        b=DV2mwNPnM1+gJ94/Hm+iBvvKHf2qavNI2HhzAlr2bd7Y8UnnZAcjXmPkOD/YOOaz0h
         uTz0cZWWeoMey1khdcAwZxfK78AAXAxtsUMqU1lvjSduhQrp298vB/K/trZeNfh2rQ1h
         dmvWs7Kyc6jPlPhu4VRTOmkOWagyYRJ0rgwnAWFnKH5JoTO4W6zuyVFicf5gcB6jr+RI
         LQRbjgUa10OelFpnCN42GOVGohMd7mLlc1yjM4NlpfnCWDf5i1b1CB5k7TKepXrvNLZy
         aXrhv+wFM9BqSTaKHOP5qGWZamAuvrXkGpVI9brhqexuvYFjqyO18qx1jIkrEwiYuriu
         +hsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=N3obRAIyIl+6u7JuAN54pttOMvMsTv5wq2/SDqyRJ7k=;
        b=dF2LsiKUd5HKYUgDLMefRHaGIKhZMkDfn/cpmTuXMVNlSluAHdXa/KQcfn2T3tIr4l
         iOD9odPOpHylkEEgzefufA27yQilJ8IINSkZiAfHdFNx8Dn+FVOlsHXM5JdBpPFwc5S7
         ylxAEVlVsR521GQ04z+VpWs6MD+n+Grsishm/YEDKd+KFPQTgS8DzwMQnlMYGnX4C1vU
         0YHfPfrX7H1XBlGChG2qYLiVurm7EUiGjehgAmFGDV2dl7+HiCxS7l39TpS38o3Gno60
         ocFVlEMpAnsNdK8efawn1hY24iwMw8AmEgxTtofAPat9vJVAao46MVqsALRgbc/oO8ek
         XTPg==
X-Gm-Message-State: APjAAAWniGI3Fne57C6UPQKyIjXtPVBfs4reqIRjYG7uIct9j1TPDiTV
        sYej7Ah1Iku30Y2FO3NGz+DL07X7KEk=
X-Google-Smtp-Source: APXvYqzV0HizurXQKRKc7aBZQVV35L2R0WGtTw9cQxi+Vx96irLv2rVZGepNKR1qVGGkwEpMIzj8sw==
X-Received: by 2002:a05:6000:1288:: with SMTP id f8mr3433770wrx.66.1579181937431;
        Thu, 16 Jan 2020 05:38:57 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:ed9f:e0c6:a41a:de2f? ([2a01:e0a:410:bb00:ed9f:e0c6:a41a:de2f])
        by smtp.gmail.com with ESMTPSA id u18sm28899430wrt.26.2020.01.16.05.38.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 05:38:56 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v3] openvswitch: add TTL decrement action
To:     Pravin Shelar <pshelar@ovn.org>, Matteo Croce <mcroce@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bindiya Kurle <bindiyakurle@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Ben Pfaff <blp@ovn.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
References: <20200115164030.56045-1-mcroce@redhat.com>
 <CAOrHB_D_zM+rceB9U3O_0GbGQW3KUouE-==haQf7MZUJm5p4wg@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <c7f288b2-dd07-f43a-48c9-ce6086137322@6wind.com>
Date:   Thu, 16 Jan 2020 14:38:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAOrHB_D_zM+rceB9U3O_0GbGQW3KUouE-==haQf7MZUJm5p4wg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 16/01/2020 à 08:21, Pravin Shelar a écrit :
> On Wed, Jan 15, 2020 at 8:40 AM Matteo Croce <mcroce@redhat.com> wrote:
[snip]
>> @@ -1050,4 +1051,5 @@ struct ovs_zone_limit {
>>         __u32 count;
>>  };
>>
>> +#define OVS_DEC_TTL_ATTR_EXEC      0
> 
> I am not sure if we need this, But if you want the nested attribute
> then lets define enum with this single attribute and have actions as
> part of its data. This would be optional argument, so userspace can
> skip it, and in that case datapath can drop the packet.
And note that 0 is a reserved value and should not be used. Look at other
attributes.

Regards,
Nicolas
