Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F162AA46C6
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 04:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbfIACVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 22:21:46 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33902 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728215AbfIACVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 22:21:46 -0400
Received: by mail-pf1-f195.google.com with SMTP id b24so6938275pfp.1
        for <netdev@vger.kernel.org>; Sat, 31 Aug 2019 19:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=j/bryxMvVgkUVvWxwbSxh8NVWw68bDlev24NCEAeDps=;
        b=jAnjoCNssOyWmxjyY+4FxOnyCrPrKNvy5vTAjOUSLX+QGTI2cMAbmFbAMHyQtWDxDz
         qsEifoQqxIK4/EooqmKnr0dkuU69erAplYZW9ZIHpswKYJjBvkdpxysUjsuXZPZqzd1B
         lHbBs4iGk1oFfrhlVbQPQvBeIVEZq8dvDE67b1HggT/vpOd4HbV04cPc6rSLQIvpNoex
         uSDfIfSxhM455w8wpz4Mi1s4npMXGL3wnFs+kRKlBVrcgTtwBtplder4fMqLnlrtC36X
         r4kPQGGhhY2lKsycXYRVQNBilRyzlbqWdAFGvvj8f9qDVsG3lr/eSnbqmDj0qLqehobV
         hCQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j/bryxMvVgkUVvWxwbSxh8NVWw68bDlev24NCEAeDps=;
        b=J18zYo68MSorgPWImhxktO15LLJmKBVH7ohQmrEwMGgMJE0ODGf2osQbaXMwO8eP7U
         alrhVJ05eg5dc5cgbd/QAjg6xDkHNx/lCSfsK3w72wUb4up0VJkl2T33/SivLTvdots4
         Qd+PzfvkJvWSUCGqFqkvh72fkgqvIaMzv3KHslcDU5SUQO8hDHkEJVNRasmUfjDUwYtz
         x6G7ahOS61Ls071rChgKx/PVnmujJDUnHexVi2X3/kqpNdg0IAW+YXirJh7CnhAgBzwj
         ajeLmgSs/PdST61enCsocDRjxvLtOrVJaDAwzyzLjR8W0UnMt83ZKQMbOk7KhSrKtW1L
         Z21w==
X-Gm-Message-State: APjAAAXRzVcixiPaAdUlovIAoKshj9ZszLxrBUijiI8ASsJHdqGZrZSF
        WnNZPKnSVCfTFCy1jEW3+D+UeULJNU8=
X-Google-Smtp-Source: APXvYqyOPSqc0JntMdGgxvxkQTZmTuZamVEB/oFu4/LyhMj62fUqD8+Q76XcRMh+ssmJh7KuAbFKyA==
X-Received: by 2002:a62:7646:: with SMTP id r67mr5246785pfc.116.1567304505283;
        Sat, 31 Aug 2019 19:21:45 -0700 (PDT)
Received: from [192.168.1.82] (host-184-167-6-196.jcs-wy.client.bresnan.net. [184.167.6.196])
        by smtp.googlemail.com with ESMTPSA id v15sm11359695pfn.69.2019.08.31.19.21.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 31 Aug 2019 19:21:44 -0700 (PDT)
Subject: Re: [PATCH v2 net] net: Properly update v4 routes with v6 nexthop
To:     Donald Sharp <sharpd@cumulusnetworks.com>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>, sworley@cumulusnetworks.com
References: <20190831122254.29928-1-sharpd@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8c96c3c5-6f76-9b2a-2935-6d5877360747@gmail.com>
Date:   Sat, 31 Aug 2019 20:21:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190831122254.29928-1-sharpd@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/19 6:22 AM, Donald Sharp wrote:
> When creating a v4 route that uses a v6 nexthop from a nexthop group.
> Allow the kernel to properly send the nexthop as v6 via the RTA_VIA
> attribute.
> 

Dave: I am on PTO with little time through Monday. I will review/test on
Tuesday.
