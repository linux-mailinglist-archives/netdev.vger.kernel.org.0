Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABE8487EE
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 17:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbfFQPxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 11:53:08 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45151 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727782AbfFQPxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 11:53:08 -0400
Received: by mail-io1-f65.google.com with SMTP id e3so22164828ioc.12
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 08:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U0ruEPCyt/rSl3ATIYxsjmz3yjhU3eOsQTL04ON+yKM=;
        b=t9b6KlmfSbfYa5mHCxIjYzsK7/jquL0IP0wW5729PdiMhI5cadKLHSeFq94XXcg2Ek
         0Kb8wN8aNilcvr4gOBHOyw3i5auPoQatlebNsDszFNjvqN3RG62M1z6tMuj6UDlu6SE4
         93eACo96cv45DcsR4MxpBTWJZN5MF5r43r5YBzIqqbNs7JZ6+osr1zqSo8vwfMO7eASQ
         KByvj/UNQ2JqsPpVYUgPvkRla9BEpzvTnBvz1N7ugLQKIwmXqFy6226O8xhoOzAY8rdT
         JzFs/xO1OfOui6/vbQ3dhJZ8/qZ1941eJLQwP2JaoiCrZdBnCIyqymtf1J3HbGF5+FhJ
         VVXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U0ruEPCyt/rSl3ATIYxsjmz3yjhU3eOsQTL04ON+yKM=;
        b=fKu6Q6uX5HqWSDBHkyiI2Mjn17cJ9eJDxq85JSN6fP8GgSgOzpGsMlOcWy1DdDsCq6
         ohlFx6iDM4WumxGNYWZscnz0oskMauWAf1b0UKBm+6v7Ztufq3eG2unTcNG1hVy7xgW2
         QOQAHzzDoSm4GyJhizsZif+61D2jfBLgW7w2vGy43npeWxnFQI3dIcrfDiztvG9+4zFt
         baCImkOTtCgp8segN5c1RPQ6zuJ9EOFVOLiBjzXFMSeeNe8F1BxjGnwZIraPko4v9Cjx
         +pVYXnsneaaFp73LjeOIwg/T9TgEni2w6r1+yzo8seA+ce61M2rkVvAGl69/MB8j//9k
         GpDA==
X-Gm-Message-State: APjAAAUFbD81ysjZS03LUu0zK+oBjsyiBEfGeD/cQPB/hlCyFRqSqj/k
        qGl9B4lX0CyMweT5nleaSzE=
X-Google-Smtp-Source: APXvYqxdzfnBOH0Od6g4kvzWxCOy5FaJFQP95PO3A3NR2SAZxTsMzIutLOyosLHSYIG7v+bVOdmj+A==
X-Received: by 2002:a02:77d6:: with SMTP id g205mr53525176jac.13.1560786787729;
        Mon, 17 Jun 2019 08:53:07 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f1:4f12:3a05:d55e? ([2601:282:800:fd80:f1:4f12:3a05:d55e])
        by smtp.googlemail.com with ESMTPSA id c17sm9450575ioo.82.2019.06.17.08.53.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 08:53:06 -0700 (PDT)
Subject: Re: [PATCH net-next v3] ipv4: Support multipath hashing on inner IP
 pkts for GRE tunnel
To:     Ido Schimmel <idosch@idosch.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com
References: <20190613183858.9892-1-ssuryaextr@gmail.com>
 <20190617143932.GA9828@splinter>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e56ca29f-8d80-b9ae-112a-4ff55847313d@gmail.com>
Date:   Mon, 17 Jun 2019 09:53:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190617143932.GA9828@splinter>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/17/19 8:39 AM, Ido Schimmel wrote:
> 
> Do you plan to add IPv6 support? Would be good to have the same features
> in both stacks.

we really should be mandating equal support for all new changes like this.

> 
> Also, we have tests for these sysctls under
> tools/testing/selftests/net/forwarding/router_multipath.sh
> 
> Can you add a test for this change as well? You'll probably need to
> create a new file given the topology created by router_multipath.sh does
> not include tunnels.
> 
> Thanks
> 

