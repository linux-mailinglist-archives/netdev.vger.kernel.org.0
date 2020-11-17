Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B912B5D53
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 11:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgKQKym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 05:54:42 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43811 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgKQKym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 05:54:42 -0500
Received: by mail-wr1-f66.google.com with SMTP id s8so22677732wrw.10;
        Tue, 17 Nov 2020 02:54:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BV3dR49+TmzbbfuxnWVy7bWUO/ntmS41oS8pplsK7qM=;
        b=LoCBLHA7zmm8fmdpDwq//I6aRWUQtf69ebZ2Pwork8QdyUD9ODnHnrDFDg0/w4p8s1
         YD3k8MlCOfSM3EJUo+QZN33rivrnqgwYiE4Jhlw+hjUdzFSoZg44anLLv67ZJFA6sR7G
         zAbhazIWKOvz0DM/QKWAhbnK4/iyw7ryxZM7T26KbPz2jt2z1jfAxfPV4E7/Kc1LLGBk
         uZ8nxyey9gh96aVYBQ8AGMQ4yMdMKBbBcG51Q0pw4254KlhgvijM4A/M0d5XGI+20Nlg
         zqLXDeAlIJ9YmKrETDc8jv7msDrxvfuzmps7wNjR7qgjNLZvdaQaO4BHmQSAvsDK4NX6
         5NDQ==
X-Gm-Message-State: AOAM530U5WZ36yj41fOLeOBVsvYR8AVlBL5f1+3JOoMlcS8fp8oKnVrP
        UVvTq/6ismsg1+y4RkBfOw0=
X-Google-Smtp-Source: ABdhPJz1z9gh1py8eyXo87F2WkrqWbEC8YZw9py5b+kN+at9lT4vWJKqv8ov+5szql9n/lwJYNmdUA==
X-Received: by 2002:a05:6000:345:: with SMTP id e5mr23390958wre.333.1605610479790;
        Tue, 17 Nov 2020 02:54:39 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id g11sm27345546wrq.7.2020.11.17.02.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 02:54:39 -0800 (PST)
Date:   Tue, 17 Nov 2020 10:54:37 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, linux-hyperv@vger.kernel.org,
        Andres Beltran <lkmlabelt@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v9 0/3] Drivers: hv: vmbus: vmbus_requestor data
 structure for VMBus hardening
Message-ID: <20201117105437.xbyjrs4m7garb2lj@liuwe-devbox-debian-v2>
References: <20201109100402.8946-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109100402.8946-1-parri.andrea@gmail.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 11:03:59AM +0100, Andrea Parri (Microsoft) wrote:
> Currently, VMbus drivers use pointers into guest memory as request IDs
> for interactions with Hyper-V. To be more robust in the face of errors
> or malicious behavior from a compromised Hyper-V, avoid exposing
> guest memory addresses to Hyper-V. Also avoid Hyper-V giving back a
> bad request ID that is then treated as the address of a guest data
> structure with no validation. Instead, encapsulate these memory
> addresses and provide small integers as request IDs.
> 
> The first patch creates the definitions for the data structure, provides
> helper methods to generate new IDs and retrieve data, and
> allocates/frees the memory needed for vmbus_requestor.
> 
> The second and third patches make use of vmbus_requestor to send request
> IDs to Hyper-V in storvsc and netvsc respectively.
> 
> The series is based on 5.10-rc3.  Changelog in the actual patches.

Applied to hyperv-next. Thanks.

I also corrected the email address in my reviewed-by tags while
committing -- should've use my @kernel.org address, not @xen.org.

Wei.
