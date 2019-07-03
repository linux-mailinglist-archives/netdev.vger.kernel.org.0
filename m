Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 641495E378
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 14:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfGCMIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 08:08:09 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52767 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfGCMIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 08:08:05 -0400
Received: by mail-wm1-f68.google.com with SMTP id s3so1949121wms.2
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 05:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J59F3dMhWxbnEie6W6MXq5/LSl0Eehr1s+0JLvyfa3g=;
        b=cKuxib0xGaicYaSYXqj2YMouleMsFhPteEEhc9pVacqBYPsyNB0dXkCX/+isPZ4EIW
         i5Ij4uQqcTrFv+UVuLQzlvAW3F9GdCasq9PL1U8uEpIaO+9OdyPeHJKYcwjky9eUba7N
         aAZ45EQ+NhmViQ5JsTnCE/jrDNLR+W5ltBM0I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J59F3dMhWxbnEie6W6MXq5/LSl0Eehr1s+0JLvyfa3g=;
        b=ln4BOxqXUaXiHeke4suGAXCB5B3lM0ZHVKvyxQ4JvPTJ/5TeLtcX3kGwl1d8TAQ2Dp
         FiD9c7lXqjWLsM1zBppDOa9xADVtEWHisdRgHyk/0yTyDUGQAj/hNAr8yEdtBTC9dd7q
         otGShron9Ncli+2z3MnNbgcrOx+sEwZAC2IQwj4RcSg4YIWb76BopTHtjZVv9lxM7gps
         fV7Hk3aVbivCGMjNVsOvvjc3Unx3gvwYljZ9dYM5w3Ju+9i5+hvQNkQHncLXkUGUVEym
         sjl/tQDzKGHuQynNmyo328bHGkN4yQc3xzVaIydPC0pLQu9qbBIA0YgEc5Lbsjr6/4AB
         h1Wg==
X-Gm-Message-State: APjAAAVD/BasDpgwx01dkRimTcdqcKAnMHqeV3a4nNgt6d0Z3oathouL
        Kp1nzQhx8AE7xW8itO3dyJKs0pGFE3VkZA==
X-Google-Smtp-Source: APXvYqyY/5IU4uKdq9FUXoGJ7wsMiQArBiaK1i5XY7LOZq/P7x84WsZD5LFvXi5DUEu/Q2hNB/EWcQ==
X-Received: by 2002:a1c:3886:: with SMTP id f128mr7745421wma.151.1562155683641;
        Wed, 03 Jul 2019 05:08:03 -0700 (PDT)
Received: from [192.168.51.243] ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id j7sm2920336wru.54.2019.07.03.05.08.02
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 05:08:03 -0700 (PDT)
Subject: Re: [PATCH 1/2 nf-next v3] netfilter: nft_meta: Add
 NFT_META_BRI_IIFVPROTO support
To:     wenxu@ucloud.cn, pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <1561682975-21790-1-git-send-email-wenxu@ucloud.cn>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <366e228f-7253-e388-4799-f0f9c18d1111@cumulusnetworks.com>
Date:   Wed, 3 Jul 2019 15:08:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1561682975-21790-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/06/2019 03:49, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This patch provide a meta to get the bridge vlan proto
> 
> nft add rule bridge firewall zones counter meta br_vlan_proto 0x8100
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  include/uapi/linux/netfilter/nf_tables.h | 2 ++
>  net/netfilter/nft_meta.c                 | 9 +++++++++
>  2 files changed, 11 insertions(+)
> 

Hi,
When using the internal bridge API outside of the bridge I'd advise you to CC bridge
maintainers as well. This patch is clearly wrong since you cannot access the vlan
fields directly because bridge vlan support might be disabled from the kernel config
as Pablo has noticed as well. In general I'd try to avoid using the internal API directly,
but that is a different matter. Please consult with include/linux/if_bridge.h for exported
functions that are supposed to be visible outside of the bridge, if you need anything else
make sure to add support for it there. The usage of br_opt_get directly for example must
be changed to br_vlan_enabled(). 

Thanks,
 Nik


