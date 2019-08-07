Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32603853A4
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 21:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389265AbfHGTcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 15:32:02 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42002 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389098AbfHGTcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 15:32:01 -0400
Received: by mail-pl1-f196.google.com with SMTP id ay6so42315917plb.9
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 12:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AJ2kD05VCVUn8C16Taz5xyABWlqxVcueD1McbUdFuUI=;
        b=chQ7jTwX3lARGlPTLrYmVeLbZKcKbxZKhCoVxJOJRiaE0Ho87SrwZRvIjYep68j8IM
         M1uGEL2sE0Ci1nJFUZ/WwV8mV/jcy4lEPofuHAUGeJ1b9dLOhtw23Cxw/3M6jPsZHWEh
         kV+bWEq/PsBEKMpiHpKU4uEhN9dsrFyHCGETuiCBr3Unh5dzFQLyJ3IkkvZz5s7852XY
         8e/F4tUg2dQk9FEYHyW1Uo1iZPJL4aVYkafnbSDZFa8ArGT+vqUmDE2G2fay7XiZiL11
         myAteOBaNe8VK/lfct8UTEFsSrOeeBi3uWihd9KuQQ+8pv3zsQYWYNDsB8SHt2RUcadL
         aT1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AJ2kD05VCVUn8C16Taz5xyABWlqxVcueD1McbUdFuUI=;
        b=hZGNX9bd5FOlNbYC1qECqcXbD7FDSjiWbkDRNWbR0+U72uQJhu0dVRNT1z64yXsd0E
         cYvSBFWV/rn8TA2fn0z5vY/p0n0NABvt/gRClYeiKHJmJHluO0TSTk7GFVBuMbXLi3vD
         Ipvi1UtTQuxmo5eEcw8kkUrd+DvumNvgfW6TjR9Yd1nQNS2f4pghm0ZGIdWgNlm9xE1e
         CUA1Fe16UrVlZjmoc5JELON5AaHNr8/UfK8fe35m+JOAmiLTLYGgXDK4qjbYozbd2iyx
         WKYZpdLYa5sj7irhQn59+Bl+Z0WHMjyirsJ/254M6c+DM/gBxKp8qGui0cyRNNfBj11A
         6DPw==
X-Gm-Message-State: APjAAAXSHJO8oaEhh157+IyK7RuVHvCZqyqlphksJThctezUHWnU4PRw
        4kS0fBmknxDywpGtQ5sM8iMQWXEr
X-Google-Smtp-Source: APXvYqxm0+YRtWl6T9jIbwhJZPb+k3nRjpUuq7kpQwik9+/EjD34N6ZDqq75x0KBUDcgxP5r3LUs+w==
X-Received: by 2002:a17:902:bf09:: with SMTP id bi9mr9093989plb.143.1565206320884;
        Wed, 07 Aug 2019 12:32:00 -0700 (PDT)
Received: from [172.27.227.247] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id q19sm97852943pfc.62.2019.08.07.12.31.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 12:32:00 -0700 (PDT)
Subject: Re: [PATCH net] netdevsim: Restore per-network namespace accounting
 for fib entries
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org
References: <20190806191517.8713-1-dsahern@kernel.org>
 <20190806153214.25203a68@cakuba.netronome.com>
 <20190807062712.GE2332@nanopsycho.orion>
 <dd568650-d5e7-62ee-4fde-db7b68b8962d@gmail.com>
 <20190807130739.GA2201@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f3c47bd5-fad4-6594-7dc6-9e78285a38e1@gmail.com>
Date:   Wed, 7 Aug 2019 13:31:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190807130739.GA2201@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/7/19 7:07 AM, Jiri Pirko wrote:
> 
> Yeah. I believe it was a mistake to add it in the first place. Abuses
> netdevsim for something it is not. I'm fine to use devlink the way you
> want to after we conclude 2), but outside netdevsim.
> 
> Again, netdevsim is there for config api testing purposes. If things
> got broken, it is not that bit deal. I broke the way it is
> instantiated significantly for example (iplink->sysfs).
>

netdevsim was created as a way of testing hardware focused kernel APIs
and code paths without hardware. yes?

The devlink api was added to netdevsim to test fib notifiers failing by
handlers. The notifiers were added for mlxsw - a hardware driver - as a
way to get notifications of fib changes.

The easiest way to test the error paths was to code limits to fib
entries very similar to what mlxsw implements with its 'devlink
resource' implementation. ie., to implement 'devlink resource' for a
software emulated device. netdevsim was the most logical place for it.

See the commit logs starting at:

commit b349e0b5ec5d7be57ac243fb08ae8b994c928165
Merge: 6e2135ce54b7 37923ed6b8ce
Author: David S. Miller <davem@davemloft.net>
Date:   Thu Mar 29 14:10:31 2018 -0400

    Merge branch 'net-Allow-FIB-notifiers-to-fail-add-and-replace'

    David Ahern says:

    ====================
    net: Allow FIB notifiers to fail add and replace


Everything about that implementation is using the s/w device to test
code paths targeted at hardware offloads.
