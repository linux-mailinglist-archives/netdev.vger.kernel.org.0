Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 137B91B6E5
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 15:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729311AbfEMNRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 09:17:37 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33488 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728409AbfEMNRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 09:17:37 -0400
Received: by mail-wm1-f67.google.com with SMTP id c66so6144191wme.0
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 06:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=umfX/I92ygceqHNVGTstL7U6TYxBwQwP0XG7WR27IVI=;
        b=JZIVoY76nsg22H5AvCysyInpUg1j8/gdt2d9YO47LaOmkZSelVqPSkoMUph04k3ByQ
         p0eiqtrC27oWVrOZQI3Gp6GBIuFMJJ/EddaUk8slpfafeeHyMfvW32lUTPndq5YQDPZf
         meGxEORIZvjfvx6YO6OUI/EX4s8QVUKU04yLpnOm2WYQ8mmjDXPMVrnHFb2j4VrPX6Li
         t9je1jBrQyo9P7E8Xi9ki/LZAmcyBd7p3d5LgJrBmiMxXoFAqfecniFncm3QfWfJyOd2
         JbvR1PjV7BqWa5lwtv7/drZ1yOKJJPysAmuCfKETMuZEbIZBhknvZ93UBxzs9aK6XALV
         mXbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=umfX/I92ygceqHNVGTstL7U6TYxBwQwP0XG7WR27IVI=;
        b=ZcvweqnXz8PIczeV4g/qI7+qfLns8oeNCPFR6y3snC7ZyY59m+NadE3JHVOlQ0BVKx
         kpXRf5Q4sPgxT5DDkKtd8PGbX3SAabcJgz/fi3wHiN6X/b+EH4xQX942oLjDLfcS7tGi
         s1Pc4cx3qDZAq702gL3Ry8lNidm1uEnzqRQIuJ0iIpYUmBdoFZi3AP0Uu8JxBOU8xEZV
         xQTV+RgMe5n5Q6dCFhnS+z2U5gP+HX2KOJMbRzII5WEXLEMvw9hNf3KjeSpccQZvQ4+4
         +mARU+xvA/e1FW0ioPefEWb4pEnb2F09dPbzYfep0WKniAVvXME3MIfIm+PKyHbHwlsi
         Z4ZA==
X-Gm-Message-State: APjAAAVQ9fK75S5WPKlt64x4TNcfeDGsGFBl7ygvt+orujgtEDHm7enu
        aOwnFd4flcStFI+wYhRmX2V1lyLGO1U=
X-Google-Smtp-Source: APXvYqzshuW/b3m1T7W0M2MjqqfKvtEambvOoQqZClpO8l4BNDcFOPS73SWqTIYNPj4RIuKbi9ePEA==
X-Received: by 2002:a1c:f30e:: with SMTP id q14mr16898302wmq.31.1557753455146;
        Mon, 13 May 2019 06:17:35 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:d07d:5e75:4e14:205c? ([2a01:e35:8b63:dc30:d07d:5e75:4e14:205c])
        by smtp.gmail.com with ESMTPSA id r64sm29449444wmr.0.2019.05.13.06.17.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 06:17:34 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] rtnetlink: always put ILFA_LINK for links with a
 link-netnsid
To:     Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org
Cc:     Dan Winship <danw@redhat.com>
References: <8b128a64bba02b9d3b703e22f9ec4e7f3803255f.1557751584.git.sd@queasysnail.net>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <a9ba6631-4403-67e0-152a-b2d85aa70d72@6wind.com>
Date:   Mon, 13 May 2019 15:17:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <8b128a64bba02b9d3b703e22f9ec4e7f3803255f.1557751584.git.sd@queasysnail.net>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 13/05/2019 à 15:01, Sabrina Dubroca a écrit :
> Currently, nla_put_iflink() doesn't put the IFLA_LINK attribute when
> iflink == ifindex.
> 
> In some cases, a device can be created in a different netns with the
> same ifindex as its parent. That device will not dump its IFLA_LINK
> attribute, which can confuse some userspace software that expects it.
> For example, if the last ifindex created in init_net and foo are both
> 8, these commands will trigger the issue:
> 
>     ip link add parent type dummy                   # ifindex 9
>     ip link add link parent netns foo type macvlan  # ifindex 9 in ns foo
> 
> So, in case a device puts the IFLA_LINK_NETNSID attribute in a dump,
> always put the IFLA_LINK attribute as well.
> 
> Thanks to Dan Winship for analyzing the original OpenShift bug down to
> the missing netlink attribute.
Good catch.

> 
> Analyzed-by: Dan Winship <danw@redhat.com>
> Fixes: a54acb3a6f85 ("dev: introduce dev_get_iflink()")
I don't agree with the Fixes tag. The test 'iflink != ifindex' is here at least
since the beginning of the git history.

> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
