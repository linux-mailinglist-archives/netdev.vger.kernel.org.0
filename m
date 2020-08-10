Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE22240344
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 10:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgHJIPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 04:15:32 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:55642 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725846AbgHJIPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 04:15:32 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 4A1FF2005A;
        Mon, 10 Aug 2020 08:15:31 +0000 (UTC)
Received: from us4-mdac16-4.at1.mdlocal (unknown [10.110.49.155])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 48E28800A4;
        Mon, 10 Aug 2020 08:15:31 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.30])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C6C1C4004D;
        Mon, 10 Aug 2020 08:15:30 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8BBCE140053;
        Mon, 10 Aug 2020 08:15:30 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 10 Aug
 2020 09:15:25 +0100
Subject: Re: [PATCH v3 net-next 03/11] sfc_ef100: read Design Parameters at
 probe time
To:     Guenter Roeck <linux@roeck-us.net>
CC:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
References: <12f836c8-bdd8-a930-a79e-da4227e808d4@solarflare.com>
 <827807a1-c4d6-d7de-7e9c-939d927d66cc@solarflare.com>
 <20200809002947.GA92634@roeck-us.net>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <dcb8dba7-d259-4aa3-96d5-066b725ae84b@solarflare.com>
Date:   Mon, 10 Aug 2020 09:15:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200809002947.GA92634@roeck-us.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25594.003
X-TM-AS-Result: No-4.111400-8.000000-10
X-TMASE-MatchedRID: O/y65JfDwwvmLzc6AOD8DfHkpkyUphL9SeIjeghh/zNHZg0gWH5yURWQ
        iJK2ZcM78XVI39JCRnSjfNAVYAJRArmoaxDEjSmvcTela9Ppnny8BJu4qIKvaVAoBBK61BhcZ5t
        OIILVs8nfWs89M0W8hGrpSxhrLECDvvC0orDlBTeeAiCmPx4NwJwhktVkBBrQjBlWW/k2kQBQSF
        bL1bvQAVgXepbcl7r7UIpZaoDhfchKkmzCTCQdVGoB23pr+qPpipEPIoQjQ7Nt17tDlbCilYZmJ
        PKdw1Hk8lFAmlVGCXh9JuBOZpbMw5B4seMC7x758B1+fkPI48NcLq4mdz+nRKyCWSW0HzF0amjO
        S5qVJMM7pyVyc/F9UH7cGd19dSFd
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.111400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25594.003
X-MDID: 1597047331-nh5BGh-0_Oe1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/08/2020 01:29, Guenter Roeck wrote:
> On Mon, Aug 03, 2020 at 09:33:20PM +0100, Edward Cree wrote:
>> +		if (EFX_MIN_DMAQ_SIZE % reader->value) {
> This is a 64-bit operation (value is 64 bit). Result on 32-bit builds:
>
> ERROR: modpost: "__umoddi3" [drivers/net/ethernet/sfc/sfc.ko] undefined!
>
> Guenter
Yep, kbuild robot already spotted this, and I'm trying to figureout
 the cleanest way to deal with it.
See https://lore.kernel.org/netdev/487d9159-41f8-2757-2e93-01426a527fb5@solarflare.com/
Any advice would be welcome...

-ed
