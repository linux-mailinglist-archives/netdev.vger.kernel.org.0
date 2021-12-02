Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63168466138
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 11:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237551AbhLBKMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 05:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356777AbhLBKMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 05:12:46 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D501AC06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 02:09:23 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id b13so19892198plg.2
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 02:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d42BNwqNiqF4HQH+LDU0XHPxt74blicgu0O+sIATgJQ=;
        b=Y+qI4opjIhhladWqxIzEVZ/oYxcPkOLrBzdixt/+Mcmd2M7LClZoMdMFvRiiG/KbqQ
         TBYJ3MehNac2PUU/Kn6S003GZeyixPc3+juDtaIXBqtblIUE1AOMCmRj+IGHJqFCfHJE
         6KhRyPBk+8HHmZxq4a+lOcAJr+lfkxB7z9I9lrQfXTk7I0WsuiE/UuvMWHpdQ1lj6V0z
         K4MlTaBYVilfGxohBS5NxCOgKNXdOTClvPbofNLoGh1Itow5P6uN4xBODfuxQG5Gz2VP
         LzHq7YnPvyzsdgryRMNQyYtvjGXfDFq0Fg7lh0y8Rpdwq9fqqzB/y9smuyobOUdGKYFi
         07dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d42BNwqNiqF4HQH+LDU0XHPxt74blicgu0O+sIATgJQ=;
        b=Qk3ix8d4BVXhoHEP7IldNy0onNb/G1anPU2+m2p3uAsmQh7UZ9BPBLbcDQhZTrEjov
         Ce5hMyzLi4UZnCQ+vHZfmoPWcawI4eTCmjOWJp4K4rkKcMCTAD3rNYBhEZ3s7UGhxsLE
         0VlXzJ2zR3n8ofFkPY4lapzs3ij9W+zd/dvGEoM36Z1gqkAYiOdLAi5pWuEiLefQK75Q
         /C7j+T+7CUWDxDmaYjNdHXhDaTIhP5aarD5ilKSpXVrDblHsoqSPh0YZXm7RpBepFd7p
         ZR8lvVcoJhaIzO+6vWEwBJsf3rFA0KuViQCq6tvdE4PWCMjrVRJolJZx7fsQEIrB/kIS
         8dIA==
X-Gm-Message-State: AOAM530q0JovGwxi4+FrWMmCYtrdJtIMvgdAo09PXnrl8VWk/dokBJPY
        CjbTBJeZwvRHNb5fXYcNU73T1dmrXV8=
X-Google-Smtp-Source: ABdhPJwiLHDRhOAbKkLjbzb346z1pb9keuHrUJJlupUzMiLYVko6E+uUrjeTNEMGyox5hy84IXmUOQ==
X-Received: by 2002:a17:902:e852:b0:143:8152:26c7 with SMTP id t18-20020a170902e85200b00143815226c7mr14221585plg.75.1638439763176;
        Thu, 02 Dec 2021 02:09:23 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x16sm2623017pfo.165.2021.12.02.02.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 02:09:22 -0800 (PST)
Date:   Thu, 2 Dec 2021 18:09:16 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        Denis Kirjanov <dkirjanov@suse.de>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH draft] bonding: add IPv6 NS/NA monitor support
Message-ID: <YaibTHR6yTuwmUwa@Laptop-X1>
References: <20211124071854.1400032-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124071854.1400032-1-liuhangbin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 03:18:53PM +0800, Hangbin Liu wrote:
> This patch add bond IPv6 NS/NA monitor support. A new option
> ns_ip6_target is added, which is similar with arp_ip_target.
> The IPv6 NS/NA monitor will take effect when there is a valid IPv6
> address. And ARP monitor will stop working.
> 
> A new field struct in6_addr ip6_addr is added to struct bond_opt_value
> for IPv6 support. Thus __bond_opt_init() is also updated to check
> string, addr first.
> 
> Function bond_handle_vlan() is split from bond_arp_send() for both
> IPv4/IPv6 usage.
> 
> To alloc NS message and send out. ndisc_ns_create() and ndisc_send_skb()
> are exported.
> 

Hello, Any comments?

Thanks
Hangbin
