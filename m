Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7C1F8B20
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 09:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbfKLIwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 03:52:53 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39368 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfKLIwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 03:52:51 -0500
Received: by mail-wm1-f67.google.com with SMTP id t26so1997314wmi.4
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/4ilrxOZ4QdJ3UAgm96VMI/hVQ/UHpZg4vUaW945RSk=;
        b=aPZJaNpEqDsGZd07oyKR/UqP127LqAjk+WBw7hwfVMN0FoWn8Kz88BWPovdn0p0Hdn
         etVge4dcyyOlncyHRIp/SrzCa9jixeA5xTceibSlk3mTdSH0nZQMqE/TZ+vZ65lu7RE9
         BdWtvuS4aObI1J8/ycZGmCHJxbd9nW3KX7Xu0ZzP8cLosg2EMYs3FApz/KQp2bB0n6hL
         cL7x1GCaxz6Bephfjz7MZG1CIImNYgbbiowJitpiferperrMn/vk3gE8ULGd2hiGCXFN
         CQKL3pU50oO41lZsHvZQvb7tJ351KhVVEFYBOy5Jr/e0KJPJ0WFdYi4bkCyxbTA9+jUg
         FuNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=/4ilrxOZ4QdJ3UAgm96VMI/hVQ/UHpZg4vUaW945RSk=;
        b=WS3VgFkQ02JF6KkGq0nbIyB6ZNgOrYFuvrzSPMTIDEZpy6WtJJzLY0O2fZSmzQAQnj
         vooqQAh5D3rnf4vybC9VC/i09Rv/f54KIFk4/XjJ0GiW7zgOFXJJL88IvGWqu0kIIZXu
         e4Z40Rdbb5utw+VoegSOcK09xkBVhWnKUQgiOG8g2SWcgr5u66tJwf/JqkJ/t+qGd62U
         tqv8Sm8903GwSSt8O8oFq/AQbQyK58imTqQZ2uXUH6X3qJQYadXCwvrClrDcg+VN8wVO
         J6ndHUeHygf3hhUeLCyxJJjEbW4YiBmiQdfnEajS09iptdrKU/vVlUABKjj8I5NZnHii
         0ufQ==
X-Gm-Message-State: APjAAAWNAUb5Nz2JWlExJFVEIyu77J4Qg+k8CMOu7bZqyT7PcTaFa733
        ZOqnymMKvw9GrSyGxNHWDWaIVMvZvFc=
X-Google-Smtp-Source: APXvYqxB+LhiAPOVc20S1pf0/sMiK+DUibXaSNSdU9a5OrptV2LYhTLqmvcVDk0wDC06CP5vUIyMdg==
X-Received: by 2002:a1c:3843:: with SMTP id f64mr2652366wma.129.1573548767671;
        Tue, 12 Nov 2019 00:52:47 -0800 (PST)
Received: from ?IPv6:2a01:e35:8b63:dc30:3456:63b2:eba1:f7d5? ([2a01:e35:8b63:dc30:3456:63b2:eba1:f7d5])
        by smtp.gmail.com with ESMTPSA id 72sm264150wrl.73.2019.11.12.00.52.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 00:52:46 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net 1/2] openvswitch: support asymmetric conntrack
To:     Aaron Conole <aconole@redhat.com>, netdev@vger.kernel.org
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
References: <20191108210714.12426-1-aconole@redhat.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <eb0bdc35-7f29-77c7-c013-e88f74772c24@6wind.com>
Date:   Tue, 12 Nov 2019 09:52:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191108210714.12426-1-aconole@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 08/11/2019 à 22:07, Aaron Conole a écrit :
> The openvswitch module shares a common conntrack and NAT infrastructure
> exposed via netfilter.  It's possible that a packet needs both SNAT and
> DNAT manipulation, due to e.g. tuple collision.  Netfilter can support
> this because it runs through the NAT table twice - once on ingress and
> again after egress.  The openvswitch module doesn't have such capability.
> 
> Like netfilter hook infrastructure, we should run through NAT twice to
> keep the symmetry.
> 
> Fixes: 05752523e565 ("openvswitch: Interface with NAT.")
> Signed-off-by: Aaron Conole <aconole@redhat.com>
In this case, ovs_ct_find_existing() won't be able to find the conntrack, right?
Inverting the tuple to find the conntrack doesn't work anymore with double NAT.
Am I wrong?


Regards,
Nicolas
