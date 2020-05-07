Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373F71C94FA
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 17:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgEGPYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 11:24:46 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:38110 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725948AbgEGPYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 11:24:46 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 30B3C6010D;
        Thu,  7 May 2020 15:24:46 +0000 (UTC)
Received: from us4-mdac16-11.ut7.mdlocal (unknown [10.7.65.208])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2FB22800A4;
        Thu,  7 May 2020 15:24:46 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.198])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 71F3B8005D;
        Thu,  7 May 2020 15:24:45 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D907C8005C;
        Thu,  7 May 2020 15:24:44 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 7 May 2020
 16:24:36 +0100
Subject: Re: [net-next v3 2/9] ice: Create and register virtual bus for RDMA
To:     Greg KH <gregkh@linuxfoundation.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>,
        Martin Habets <mhabets@solarflare.com>
References: <20200506210505.507254-1-jeffrey.t.kirsher@intel.com>
 <20200506210505.507254-3-jeffrey.t.kirsher@intel.com>
 <20200507081737.GC1024567@kroah.com>
 <9DD61F30A802C4429A01CA4200E302A7DCD6B850@fmsmsx124.amr.corp.intel.com>
 <20200507150658.GA1886648@kroah.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <ef4bb479-1669-7611-81c8-cd21497d9103@solarflare.com>
Date:   Thu, 7 May 2020 16:24:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200507150658.GA1886648@kroah.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25404.003
X-TM-AS-Result: No-2.816400-8.000000-10
X-TMASE-MatchedRID: 9zTThWtzImui6/VcDv9f0PZvT2zYoYOwC/ExpXrHizxTbQ95zRbWVuQS
        CMu2pzo2V+Tv6DTyreybymr8/mqLG3ChPHB61wQjIwk7p1qp3JapE7BSysLIIlIxScKXZnK06q/
        JR//r0aKEgl0njLljkkOYDRKaRR11Im+xW0g7UUOVOwZbcOalSzQAl7cHmp8GQ2acZEMNHfOjxY
        yRBa/qJZj9/HNwzYskxx7l0wJgoV3dB/CxWTRRuwihQpoXbuXFjGW2NKvxCj9jYZ/NGxgT2CFrQ
        BvXllNFLnAzKbHHg4wJviDLF0FH1OMHwvOdkGP9G7oA4Dt6vtMb5upnEBIKy43H+tbaVNuxooBB
        8uyeEuspZK3gOa9uGmJwouYrZN4qaw+fkLqdalOeqD9WtJkSIw==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.816400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25404.003
X-MDID: 1588865085-jKzinsEFD_cD
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/05/2020 16:06, Greg KH wrote:
> I can't accept that this series is using a virtual bus properly without
> actually using the virtual bus driver code, can you?
I might be misunderstanding, but I *think* a hardware driver likeice is
 the 'provider' of a virtbus, and it's only 'consumers' of it (like an
 RDMA device talking to that ice instance) that are virtbus_drivers.
Though tbh I'm not entirely happy either with a series that adds the
 provider side but not any users... and either way, the documentation
 *really* doesn't make it clear whether it works the way I think it does
 or not.

-ed
