Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD12ADEC3
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 20:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730655AbfIISWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 14:22:05 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41480 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730531AbfIISWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 14:22:05 -0400
Received: by mail-pl1-f196.google.com with SMTP id m9so6898687pls.8
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 11:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=vG6VuqE6geve3tpL/KKpm7WkQz8oKYnKqgMS7iCqrDw=;
        b=0j6vssGBKu4gjjwAFal33JOYEXrfc04DvlZALwZAK5AYEDyqh7g02EIe+Of9AGBy9V
         NofJ+UKfRm4VCNDuBlc2DOgWgAjTx8VOCQyjR+9QcO3kHakha6EiYedqsfgk0JLZ/cud
         lasdz2QcT8jzJOpqLrIaPMvIm+nk9H85n8PzTVlw9+gAOi4TTsuiat24dNvV4yErtWHb
         O92109nYKHCh25PlVZrZHw5JqKkqMWHD1ZpI3xaxt4HLTsX9y0ODcu0Tma5oTKUDroHy
         Yv+gEa9O6pyVBgxLREYywrpIeaDG8jnt9UlHcsfLij73wlxEnDqaA+Psf1POGb7iWFfX
         3jiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=vG6VuqE6geve3tpL/KKpm7WkQz8oKYnKqgMS7iCqrDw=;
        b=c+rqkx5jvlKdpw5Zw748itGZIity+fHvck35WV7WP3ZRkYN/MJrDVNVNAWDAWW1dxY
         Zs9+2r0V1LtDAgA3IYW0YJ9sfB8PTPCVUgLvq/nQ8kti1A6Tl1NCV6rauVQ6x5nbqp40
         WusNqqxhJYy5e0cMIEhyJ+l1Odriln0LWUPjF3w6AwMLfWx+VpTIVUPjI3g4aoNCvAX2
         2DjlawoPfcV//gffUaXf0cq+1ARWHWiVeNe+53yzkZSYzBrqte3sVKlHPyrQuFWTQ1Z5
         od6tCVTYLYyMCgS1D15e9hGy8VxNUVsA17fzgylGwA4xfHa2OGOqSK6FQw7kw+GtHRly
         upzA==
X-Gm-Message-State: APjAAAU3uPUOFEz2avubmaPuv+sOZ0hen470PWS8wQRQt09ANn6g4lz7
        JoG88yu2MlPZsn6TMF4VhQL32w==
X-Google-Smtp-Source: APXvYqyjNJTLwCG2ouVwQx0t/kkbP+nhbVWATowyeWAARkfqL1B7r68vNY6naL4T7MCCItYuOf+tZQ==
X-Received: by 2002:a17:902:b40c:: with SMTP id x12mr26178238plr.236.1568053324588;
        Mon, 09 Sep 2019 11:22:04 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id v22sm12738511pgk.69.2019.09.09.11.22.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 11:22:03 -0700 (PDT)
Subject: Re: ixgbe: driver drops packets routed from an IPSec interface with a
 "bad sa_idx" error
To:     Michael Marley <michael@michaelmarley.com>, netdev@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        steffen.klassert@secunet.com
References: <10ba81d178d4ade76741c1a6e1672056@michaelmarley.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <4caa4fb7-9963-99ab-318f-d8ada4f19205@pensando.io>
Date:   Mon, 9 Sep 2019 19:21:59 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <10ba81d178d4ade76741c1a6e1672056@michaelmarley.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/6/19 11:13 AM, Michael Marley wrote:
> (This is also reported at 
> https://bugzilla.kernel.org/show_bug.cgi?id=204551, but it was 
> recommended that I send it to this list as well.)
>
> I have a put together a router that routes traffic from several local 
> subnets from a switch attached to an i82599ES card through an IPSec 
> VPN interface set up with StrongSwan.  (The VPN is running on an 
> unrelated second interface with a different driver.)  Traffic from the 
> local interfaces to the VPN works as it should and eventually makes it 
> through the VPN server and out to the Internet.  The return traffic 
> makes it back to the router and tcpdump shows it leaving by the 
> i82599, but the traffic never actually makes it onto the wire and I 
> instead get one of
>
> enp1s0: ixgbe_ipsec_tx: bad sa_idx=64512 handle=0
>
> for each packet that should be transmitted.  (The sa_idx and handle 
> values are always the same.)
>
> I realized this was probably related to ixgbe's IPSec offloading 
> feature, so I tried with the motherboard's integrated e1000e device 
> and didn't have the problem.  I tried using ethtool to disable all the 
> IPSec-related offloads (tx-esp-segmentation, esp-hw-offload, 
> esp-tx-csum-hw-offload), but the problem persisted.  I then tried 
> recompiling the kernel with CONFIG_IXGBE_IPSEC=n and that worked 
> around the problem.
>
> I was also able to find another instance of the same problem reported 
> in Debian at 
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=930443.  That person 
> seems to be having exactly the same issue as me, down to the sa_idx 
> and handle values being the same.
>
> If there are any more details I can provide to make this easier to 
> track down, please let me know.
>
> Thanks,
>
> Michael Marley

Hi Michael,

Thanks for pointing this out.  The issue this error message is 
complaining about is that the handle given to the driver is a bad 
value.  The handle is what helps the driver find the right encryption 
information, and in this case is an index into an array, one array for 
Rx and one for Tx, each of which have up to 1024 entries.  In order to 
encode them into a single value, 1024 is added to the Tx values to make 
the handle, and 1024 is subtracted to use the handle later.  Note that 
the bad sa_idx is 64512, which happens to also be -1024; if the Tx 
handle given to ixgbe for xmit is 0, we subtract 1024 from that and get 
this bad sa_idx value.

That handle is supposed to be an opaque value only used by the driver.  
It looks to me like either (a) the driver is not setting up the handle 
correctly when the SA is first set up, or (b) something in the upper 
levels of the ipsec code is clearing the handle value. We would need to 
know more about all the bits in your SA set up to have a better idea 
what parts of the ipsec code are being exercised when this problem happens.

I currently don't have access to a good ixgbe setup on which to 
test/debug this, and I haven't been paying much attention lately to 
what's happening in the upper ipsec layers, so my help will be somewhat 
limited.  I'm hoping the the Intel folks can add a little help, so I've 
copied Jeff Kirsher on this (they'll probably point back to me since I 
wrote this chunk :-) ).  I've also copied Stephen Klassert for his ipsec 
thoughts.

In the meantime, can you give more details on the exact ipsec rules that 
are used here, and are there any error messages coming from ixgbe 
regarding the ipsec rule setup that might help us identify what's happening?

Thanks,
sln


