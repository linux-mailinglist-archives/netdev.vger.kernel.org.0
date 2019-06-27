Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D44257D69
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 09:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfF0Ho6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 03:44:58 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46241 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfF0Ho6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 03:44:58 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so1280448wrw.13
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 00:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fRhMiuM9D6lNqKr68YbS2wqBEbQrlCyklKLmB7I52L8=;
        b=suTzBU5N6EkJIWq35Uka0kDQWuiTo+/EbommBMOxKid8dyF8atsySar5l1rISdF5JR
         f1dVxxzOTVLOYT+9jr8Xo4LjspHImaKHMTyB3tKX9Ce0ynQZXuq4dQog6CKBQ/FuWkpu
         fmX6UACWyV2k/iUc8MJXIX85prldCEDIXbgyUmFj/d8ufh7+mS+4TlexuAmELOZvsWNB
         ahXwnfENQVhhSDaHIK9wn3UvyzUJjSN7R43zgCAiY0yxvErWtGnj5UyBLocx58h6VXlI
         D70lvpUjxbHGtZuvXXGW0463m8XLAQZTViUjJOVU6cYzkKVa690fn0vm+sL1mmaW1hqq
         7pPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fRhMiuM9D6lNqKr68YbS2wqBEbQrlCyklKLmB7I52L8=;
        b=RV7dNSa1hWsdNiH4WiRidfxoUu6Qom+k/Z2P5ILaZGUKWwreDTx3Ri2SkPXYgXY07x
         YhWQCEfZq0WUNsheeLiVnGMRS83HbkEpOoV5JX5bKY+Uyab9K9ux6HYuKU/eFep3PDKf
         oN99HzfvKKcsB/dOjM+WKMuGAAk/nilC94Jg5tboj58hnvj6hRE/NeNBhLDDlnUGsjD/
         JY1NIqn9NIbeIEtIXShxYKdcFU+wpbeYUiIKMpScgy6NbAEyG/Ksg+JShwg3kgS44XzE
         8jIjwUg3K0fH3TJtoSL4LobR3nqQFAqc0Pcb84awa0ZfA1a47Bvt/9uETlwvT9JHM6PA
         MasQ==
X-Gm-Message-State: APjAAAVTdfzJVu7MzQpYum96pHsLPzTWi5JtlDsqMIWfFyDv8YdahRpR
        XCODFL9QhYZJnG0e/zIsrKbZew==
X-Google-Smtp-Source: APXvYqy00J8Sq1s22y/DIkO4hpql2w3C4VePv+24bHNULGhow+wfUwNhXVnqYGuPu8qdzdLk1r7p7w==
X-Received: by 2002:adf:ea92:: with SMTP id s18mr1831696wrm.257.1561621496090;
        Thu, 27 Jun 2019 00:44:56 -0700 (PDT)
Received: from localhost (ip-89-176-222-26.net.upcbroadband.cz. [89.176.222.26])
        by smtp.gmail.com with ESMTPSA id g10sm1487752wrw.60.2019.06.27.00.44.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 00:44:55 -0700 (PDT)
Date:   Thu, 27 Jun 2019 09:44:55 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Miller <davem@davemloft.net>
Cc:     yuehaibing@huawei.com, sdf@google.com, jianbol@mellanox.com,
        jiri@mellanox.com, mirq-linux@rere.qmqm.pl, willemb@google.com,
        sdf@fomichev.me, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] flow_dissector: Fix vlan header offset in
 __skb_flow_dissect
Message-ID: <20190627074455.GE2424@nanopsycho>
References: <20190622.161955.2030310177158651781.davem@davemloft.net>
 <20190624034913.40328-1-yuehaibing@huawei.com>
 <20190626.192829.1694521513812984310.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626.192829.1694521513812984310.davem@davemloft.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jun 27, 2019 at 04:28:29AM CEST, davem@davemloft.net wrote:
>From: YueHaibing <yuehaibing@huawei.com>
>Date: Mon, 24 Jun 2019 11:49:13 +0800
>
>> @@ -998,6 +998,9 @@ bool __skb_flow_dissect(const struct net *net,
>>  		    skb && skb_vlan_tag_present(skb)) {
>>  			proto = skb->protocol;
>>  		} else {
>> +			if (dissector_vlan == FLOW_DISSECTOR_KEY_MAX)
>> +				nhoff -= sizeof(*vlan);
>> +
>
>But this is wrong when we are being called via eth_get_headlen(), in
>that case nhoff will be sizeof(struct ethhdr).

This patch was replaced by:
[PATCH] bonding: Always enable vlan tx offload
http://patchwork.ozlabs.org/patch/1122886/
