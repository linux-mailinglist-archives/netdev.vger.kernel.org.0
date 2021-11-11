Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E6044D64E
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 13:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbhKKMIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 07:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbhKKMIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 07:08:04 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BA4C061767
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 04:05:14 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id i8-20020a7bc948000000b0030db7b70b6bso7068704wml.1
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 04:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tMFpP54OCsCSHrzRrnM143PWzqa9349LKS4OC1oMfKk=;
        b=knZWFaGCGTgKuJUzJIAMRmqrQ58wbTtWBTaZQg7R8RImMHgOUDpt2HM1b9TkuuccGd
         8jSJOGvxtE+AqxBsXEX3e6bwdhiWLcFwl7NW0Ibh9hwwALV9C+aMYohkdFhj4bpoC752
         uR/FX56oIrGSYHKQlSQOYluUKg/IWbXZ0anawzqJN9PRHcqpp4p6G5Ebggmxuttb9kFE
         VFHy4EK+92NTCItKLThfoKssqN6nJIew2u/Ky+IqsZKnjs5xuR8RdiZOXCxwRz4haGPa
         rtD4+oQClpMK6aZVB/JZY4W1omaHu+ZExQlYHtxPv4F1SIG2chhbinNDazuEzpRiLfI+
         1+iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tMFpP54OCsCSHrzRrnM143PWzqa9349LKS4OC1oMfKk=;
        b=lqhuIsvtkEUCiD8uaMlRt5RLJBVFRJVyKDskUA9V2hJ6WopRnNRiBdF+tWyzXggd8D
         PAWy99UqGBio49Y8frMeCfA1z/jN1KI4egmrVgGLmkEwPB6TzfjULq5h+IX0vJg6TNwr
         4NFZcnNbHJA5zb536bZaw4fpH1hUkZ0GwxWEgAzEQpCs+Dse8mK6tnRXcIAG/teaio7o
         UhO/5VfX2fB84jyRx0ut+N/0S7TMK5BwwMWxulQZwmjG91Zo7NA5JElaWZx9+WoqjjMG
         dCXlEFy3EGkyXQIRN5gB9jPlD98cneSJ0bRzMGqDycgHBX0s4rL01HY8Ve/VMY+IOi5j
         UGaw==
X-Gm-Message-State: AOAM531BNND0j1Usr6s/EO4g0Mz05CrrvUAehRQPQmkrBg4S0dhgCUnr
        tGzlGp4AMjFEdjZC72zbFkKvUQ==
X-Google-Smtp-Source: ABdhPJwIyqeu6HLcMRtM7A0G8OvYD6Qq7Kpkc7xNqFFRJoOI7Xw6DpL/RflRO2K7Akkqdp2usNPjDg==
X-Received: by 2002:a05:600c:24d:: with SMTP id 13mr7434979wmj.156.1636632313506;
        Thu, 11 Nov 2021 04:05:13 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id u16sm8141729wmc.21.2021.11.11.04.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 04:05:12 -0800 (PST)
Date:   Thu, 11 Nov 2021 13:05:11 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <YY0G90fJpu/OtF8L@nanopsycho>
References: <20211108101646.0a4e5ca4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYlrZZTdJKhha0FF@unreal>
 <20211108104608.378c106e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYmBbJ5++iO4MOo7@unreal>
 <20211108153126.1f3a8fe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109144358.GA1824154@nvidia.com>
 <20211109070702.17364ec7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109153335.GH1740502@nvidia.com>
 <20211109082042.31cf29c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109182427.GJ1740502@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109182427.GJ1740502@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 09, 2021 at 07:24:27PM CET, jgg@nvidia.com wrote:
>On Tue, Nov 09, 2021 at 08:20:42AM -0800, Jakub Kicinski wrote:
>> On Tue, 9 Nov 2021 11:33:35 -0400 Jason Gunthorpe wrote:
>> > > > I once sketched out fixing this by removing the need to hold the
>> > > > per_net_rwsem just for list iteration, which in turn avoids holding it
>> > > > over the devlink reload paths. It seemed like a reasonable step toward
>> > > > finer grained locking.  
>> > > 
>> > > Seems to me the locking is just a symptom.  
>> > 
>> > My fear is this reload during net ns destruction is devlink uAPI now
>> > and, yes it may be only a symptom, but the root cause may be unfixable
>> > uAPI constraints.
>> 
>> If I'm reading this right it locks up 100% of the time, what is a uAPI
>> for? DoS? ;)
>> 
>> Hence my questions about the actual use cases.
>
>Removing namespace support from devlink would solve the crasher. I
>certainly didn't feel bold enough to suggest such a thing :)
>
>If no other devlink driver cares about this it is probably the best
>idea.

Devlink namespace support is not generic, not related to any driver.

>
>Jason
