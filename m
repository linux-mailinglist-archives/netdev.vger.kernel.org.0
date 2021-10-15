Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCD542FD67
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 23:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243085AbhJOVaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 17:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbhJOVaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 17:30:09 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45775C061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 14:28:02 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id v2-20020a05683018c200b0054e3acddd91so14603655ote.8
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 14:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kbNi0Kt3wXtJGF7cC+kzSls+UPemjN8p+7i3L8b9myY=;
        b=dzpMpe/U4m1eVVi9/OJExKViLZZNVTsIjDysq6M5cbYrDrEHjIEQKW7qeNc0Xu0vB5
         hn7j/nPgC4E2udVl3SLe+/Ld1CKDfDXXOLq8cH6iWKaquZtGKqMVNO4fASabI9JVECnq
         UtgjI/Xo+hqDCVOsw26M10U+EqHl5CEkzxIJ8ILNW63zWofN86dJLfOkI1tvffBboaJO
         ejH2MQSQsNmrGzYRWury8cgToKs6EIZjpR0lVrwesC731uoz2r/XhwBYN7NQ1lyjDSjl
         3/XI5K4FTeqVTtd3jG1OirjgeH78RvatYzG9LlRm2G/t+c40BHEh3M2up08cBFZ8YNxl
         q7Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kbNi0Kt3wXtJGF7cC+kzSls+UPemjN8p+7i3L8b9myY=;
        b=Zq5GGraE0bTZEfdWQNDCj/qCnQMGKMWcjn5t5apN91GDXc2AbGDvcGOGZLrzelEtT5
         s2xyXggej9xiXRIh/t7e8ywau4axpX9REam8B19JjKt2LbPIhZ/4mRmTTsQoD1d5WB4B
         X6GMHUR9/jbVCvBmiEPsgRDpzH9sHVTWLtZZwQq+4jDeV/BS/VRBp129n78Rn3ligxeE
         fZpbtnIzYdSt19x+yEbVE6uckdTS1F/1t+m8yoPfkZ4vHGh36gk3w/um+/axTzSogPhk
         Z4WxTmE9mmkNzsnPtG0/mnbMuvOnlNsUdANVslMqXdTxWNWIJEAum4mZ+RdCer1StmoJ
         bTaA==
X-Gm-Message-State: AOAM532KsBTcBSxfHQe3oFRhpk+31FQJUAuy6h1+6ewioXFI048Z9rhf
        uovU0LrBBb0tkyJltwgKxbKU4+WfaukjEw==
X-Google-Smtp-Source: ABdhPJw6aNRoE+D8Fpew3bQ943i8f1tfGhObW/Vgt22SoP5sdqhozzDJ9jX6wEEwZfWPU2XtcBzqaw==
X-Received: by 2002:a9d:26:: with SMTP id 35mr10014266ota.68.1634333281714;
        Fri, 15 Oct 2021 14:28:01 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id x28sm1553737ote.24.2021.10.15.14.28.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 14:28:01 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: When forwarding count rx stats on the orig
 netdev
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@mellanox.com>
References: <20211014130845.410602-1-ssuryaextr@gmail.com>
 <1a83de45-936e-483c-0176-c877d8548d70@gmail.com>
 <20211015022241.GA3405@ICIPI.localdomain>
 <1e07d35a-50f5-349e-3634-b9fd73fca8ea@gmail.com>
 <20211015130141.66db253b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <372a0b95-7ec4-fcd9-564e-cb898c4fe90a@gmail.com>
Date:   Fri, 15 Oct 2021 15:28:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211015130141.66db253b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/21 2:01 PM, Jakub Kicinski wrote:
> On Thu, 14 Oct 2021 20:27:38 -0600 David Ahern wrote:
>> On 10/14/21 8:22 PM, Stephen Suryaputra wrote:
>>> On Thu, Oct 14, 2021 at 08:15:34PM -0600, David Ahern wrote:  
>>>> [ added Ido for the forwarding tests ]
>>>>  
>>> [snip]  
>>>>
>>>> This seems fine to me, but IPv4 and IPv6 should work the same.  
>>>
>>> But we don't have per if ipv4 stats. Remember that I tried to get
>>> something going but wasn't getting any traction?
>>>   
>> oh right, ipv4 is per net-namespace.
> 
> Is that an ack? :)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
