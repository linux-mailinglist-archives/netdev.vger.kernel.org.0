Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFDC43AB84
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 07:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbhJZFDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 01:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbhJZFDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 01:03:19 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFF9C061745;
        Mon, 25 Oct 2021 22:00:56 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so693982pjb.3;
        Mon, 25 Oct 2021 22:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s7nslNohfJCEGsP/OyoeNUaLjb7bW9o5JM7Cqf08CNk=;
        b=FNlKMWZAxNJ8wNYpkzrtUYXwmcZ0+Mj0FvAuZE5T4OEVtCevbhpnCNQ3CaWfK6y8tU
         /RlKm4+b4HF7sffDJr/cqLAWka7P3BPA7y4C/+8E4c5gGVqYeTl9j7ERqyfYg5nxuqaN
         9t92wy9NLqT6Xd2MIJRv2HvANjU1ReLtMcMg68NlLuGue6E+q/YOBDQXlTqNmLQmoKXs
         PLqMSCaBrBrs1XKO9G+sQm5NWlMvYAbhqRzuxypPANY7TOpHX2b8NQGWWr1l76TDrBwu
         T/ROx0KwwNOJqAp/VAvLKHdjG+UBd4hUNycq2PM57dzCaUVff0xX1st2ut2HNb0NulpZ
         h71w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s7nslNohfJCEGsP/OyoeNUaLjb7bW9o5JM7Cqf08CNk=;
        b=XeOIgHsSndlW1KkV2TmPCXT8OGUqLTk05nIxVxfGOSoKgVPAWirXZxV8nT59mb+zvJ
         qO+t9VGPDeceiaK+cwmU7g76XfKbmDgbwEbLYxXNjlJsFHJE5dZKm+S3Xdf/a8MNOqQt
         9/NcoNMh6fGpoKpGAV5GZEG1cQAKWkqQe1j1tq+UFdv5n+ksCVLCA+rT/T/e08Bq66Ro
         CsKDNNmmtXJvecyqTODo+BHfNjuV0HzszUChzWIpt1xk0Tfl44QVFRRbj6EnJdd/k6W3
         4sqruRu/02ehytns8bWHAyeDG3WrUi/NwSfOzoDHQTUZ1lpgELDi9QOt8cOeTPVlVnO1
         KYbQ==
X-Gm-Message-State: AOAM5315MTPyFIWJh7jOozqGPKvbDl+qZUpSVv/iiffPTjXKwynZblGt
        r1QOXrN/CeVcnioS3wBh1By0EYFMQdqkZw==
X-Google-Smtp-Source: ABdhPJwlL/XJOcsTdUSoMPzQmaPzAGBIsRnKZW8zynl+YRbw6bXRMXiorRSsI51Bdun+Dc/hCnMCIA==
X-Received: by 2002:a17:90b:90:: with SMTP id bb16mr24782940pjb.235.1635224455875;
        Mon, 25 Oct 2021 22:00:55 -0700 (PDT)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id k6sm5131258pfu.161.2021.10.25.22.00.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 22:00:55 -0700 (PDT)
Subject: Re: [PATCH net-next] amt: add initial driver for Automatic Multicast
 Tunneling (AMT)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211023193055.11427-1-ap420073@gmail.com>
 <20211025174613.3c0a306b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <d468011d-d100-e458-64cb-5f0be82b4e67@gmail.com>
Date:   Tue, 26 Oct 2021 14:00:52 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211025174613.3c0a306b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,
Thank you so much for your review!

On 10/26/21 9:46 AM, Jakub Kicinski wrote:
 > On Sat, 23 Oct 2021 19:30:55 +0000 Taehee Yoo wrote:
 >> This is an implementation of AMT(Automatic Multicast Tunneling), RFC 
7450.
 >> https://datatracker.ietf.org/doc/html/rfc7450
 >>
 >> This implementation supports IGMPv2, IGMPv3, MLDv1. MLDv2, and IPv4
 >> underlay.
 >
 >
 > Lots of sparse warnings here, please build the new code with C=1.
 >

Okay, I will fix it then send the v2.
Thanks,
Taehee
