Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6C11C8A9E
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 14:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgEGMVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 08:21:48 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:59136 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgEGMVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 08:21:48 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 047CLhEB001501;
        Thu, 7 May 2020 07:21:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588854103;
        bh=JWvfWclonD6Bzo7rOxCtbpXK+eT3Sd1HK3Ywfsl3O74=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=UlqZVAVwqKHMxIbsp/jESft2kwHiF+ZGJnylzVhQkZm00r81DBp9SozLFPcNGqYwi
         brY2OYCCxmamjCXqcDyMpEG8xA9HnizYeVwomF3hhzN/4MzJRnADpXHrfz5xrAkJ9c
         e+f5kR5H8ldo5P/pTivAImrohllDn7gQHI4pyjJE=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 047CLhum124434
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 7 May 2020 07:21:43 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 7 May
 2020 07:21:42 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 7 May 2020 07:21:42 -0500
Received: from [10.250.74.234] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 047CLgUC119441;
        Thu, 7 May 2020 07:21:42 -0500
Subject: Re: net: dsa: HSR/PRP support
To:     George McCollister <george.mccollister@gmail.com>,
        <netdev@vger.kernel.org>
CC:     <vinicius.gomes@intel.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <CAFSKS=Mr+V0zFVBZyZu2zoY-yF3VZuOu+if6=P_0pJiaCDwmRA@mail.gmail.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <79fd0e39-4f01-d111-c22b-34da1ff8cc9b@ti.com>
Date:   Thu, 7 May 2020 08:21:42 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAFSKS=Mr+V0zFVBZyZu2zoY-yF3VZuOu+if6=P_0pJiaCDwmRA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi George,

On 2/18/20 12:15 PM, George McCollister wrote:
> I'd like to add a switch to DSA that has hardware support for HSR (IEC
> 62439-3 Clause 5) and PRP (IEC 62439-3 Clause 4).
> 
> As well as many common switch features, it supports:
> Self-address filtering
> Forwarding of frames with cut-through
> Automatic insertion of HSR tag and PRP trailer
> Automatic removal of HSR tag and PRP trailer
> Automatic duplicate generation for HSR and PRP
> 
> I've also seen other switches that support a subset of these features
> and require software support for the rest (like insertion and removal
> of tag/trailer).
> 
> Currently there is software HSR support in net/hsr. I've seen some
> past discussions on the list about adding PRP support and adding
> support for offloading HSR and PRP to a switch.
> 
> Is anyone still working on any of this? If not, has anyone made
> progress on any of this they'd like to share as a starting point for
> getting some of this upstreamed? Has anyone run across any problems
> along the way they'd like to share. I've read that the TI vendor
> kernel may have support for some of these features on the CPSW.
> 
> Thanks,
> George McCollister
> 
Yes. We have support for PRP and HSR/PRP offload support in our internal
Kernel tree. I have posted the RFC for PRP support to existing HSR
driver to the list. I think that is the first thing to do and then work 
to add offload support for devices that support this in hardware. It
would be great if you could review this series and test it on your
platform.

https://lkml.org/lkml/2020/5/6/909
-- 
Murali Karicheri
Texas Instruments
