Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53BA6B12FC
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 18:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730254AbfILQpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 12:45:51 -0400
Received: from mail3.affordablehosting.com ([173.255.168.27]:52800 "EHLO
        mail3.affordablehosting.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728562AbfILQpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 12:45:51 -0400
X-Greylist: delayed 760 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Sep 2019 12:45:50 EDT
DKIM-Signature: a=rsa-sha256; t=1568305991; x=1568910791; s=default; d=reliablehosting.com; c=relaxed/relaxed; v=1; bh=oLFL9ECSckkpaxXFEVuBXbydDTc5ymWF4jvMBiMOl1s=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References;
   b=5D20VuvgLa32hqL5mirkdpIzUYxHA/1o5rbhuug+qS8GtnfMt8rWkAtvXgwAERJOivm4qOhLd/HbS7iGJMsKq120ZpoRa3WKnUhlmRD2eg22PoqJXHn0ZRX76Kcr9z4syXQwTxHCLcDLScnZpramJq2HMojNWkhgahw4fcFAPfw=
Received: from [192.168.1.103] ([74.197.19.145])
        by mail3.affordablehosting.com (Reliablehosting.com Mail Server) with ASMTP (SSL) id 201909120933111661;
        Thu, 12 Sep 2019 09:33:11 -0700
Subject: Re: [PATCH] ixgbe: Fix secpath usage for IPsec TX offload.
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     Michael Marley <michael@michaelmarley.com>,
        Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org
References: <20190912110144.GS2879@gauss3.secunet.de>
From:   Jonathan Tooker <jonathan@reliablehosting.com>
Message-ID: <9d94bd04-c6fa-d275-97bc-5d589304f038@reliablehosting.com>
Date:   Thu, 12 Sep 2019 11:33:09 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190912110144.GS2879@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/2019 6:01 AM, Steffen Klassert wrote:
> The ixgbe driver currently does IPsec TX offloading
> based on an existing secpath. However, the secpath
> can also come from the RX side, in this case it is
> misinterpreted for TX offload and the packets are
> dropped with a "bad sa_idx" error. Fix this by using
> the xfrm_offload() function to test for TX offload.
>
Does this patch also need to be ported to the ixgbevf driver? I can 
replicate the bad sa_idx error using a VM that's using a VF & the 
ixgebvf  driver.

