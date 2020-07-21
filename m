Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93772227F93
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 14:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbgGUMFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 08:05:53 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:57310 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726266AbgGUMFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 08:05:53 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 26B8E200A0;
        Tue, 21 Jul 2020 12:05:52 +0000 (UTC)
Received: from us4-mdac16-43.at1.mdlocal (unknown [10.110.48.14])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 222C08009B;
        Tue, 21 Jul 2020 12:05:52 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.48.236])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id AE2724006E;
        Tue, 21 Jul 2020 12:05:51 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6B13B400069;
        Tue, 21 Jul 2020 12:05:51 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 21 Jul
 2020 13:05:43 +0100
Subject: Re: [PATCH net-next] efx: convert to new udp_tunnel infrastructure
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-net-drivers@solarflare.com>, <mhabets@solarflare.com>,
        <mslattery@solarflare.com>
References: <20200717235336.879264-1-kuba@kernel.org>
 <a97d3321-3fee-5217-59e4-e56bfbaff7a3@solarflare.com>
 <20200720102156.717e3e68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <ecc09a90-1946-fc6a-a5fd-5e0dfe11532d@solarflare.com>
Date:   Tue, 21 Jul 2020 13:05:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200720102156.717e3e68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25554.003
X-TM-AS-Result: No-2.871600-8.000000-10
X-TMASE-MatchedRID: y/2oPz6gbvjmLzc6AOD8DfHkpkyUphL9SeIjeghh/zPLwwwRZ45jJSMn
        HClP1IKbO0Q/dPql61GOhUAaUyeM+ROlf9nbYOCmRXgK+YLiGCZzmB71otxffClwAFvgc5IPLA/
        HEYcS9ijhHC4Czd4qMMH58Xc+qWTLuV9eQHCYbHpl2ityh8f8aff6ZSoNZQrIn7jOJQ+rgvFU7b
        LqnQz/DAtv7Y3W12RRmd9OY81M7yGBqAsuTFDTpLdHEv7sR/OwV0QSZ/pNFUGE2ut4EHvMmcojs
        sFOIPQE/7yMlJ1P+1FW7tkPKoW8vtwxB/xqf6wH8KGJCiV+3/J9LQinZ4QefNZE3xJMmmXc+gtH
        j7OwNO1j4sBw+p1JZ3EDEhpC39cHcamj1OwjvrRWnzSzTe/bwLINebKNNAxFjqxxJB2IaZuzLDq
        KAWb1Z5BpjfTO1B2pZwTXo5lJUPnD/F9jlWD65lHTb2Y4zo/QutwTzHK3ELl3mFldkWgHw/FbH3
        cFJjLJwL6SxPpr1/I=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.871600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25554.003
X-MDID: 1595333152-z0jD-rNwhANG
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/07/2020 18:21, Jakub Kicinski wrote:
> On Mon, 20 Jul 2020 12:45:54 +0100 Edward Cree wrote:
>> I think I'd prefer to keep the switch() that explicitlychecks
>>  for UDP_TUNNEL_TYPE_GENEVE; even though the infrastructure
>>  makes sure it won't ever not be, I'd still feel more comfortable
>>  that way.  But it's up to you.
> 
> To me the motivation of expressing capabilities is for the core 
> to be able to do the necessary checking (and make more intelligent
> decisions). All the drivers I've converted make the assumption they
> won't see tunnel types they don't support.

Like I say, up to you.  It's not how I'd write it but if that's how
 you're doing all the drivers then consistency is probably good.

>> Could we not keep a 'valid'/'used' flag in the table, used in
>>  roughly the same way we were checking count != 0?
> 
> How about we do the !port check in efx_ef10_udp_tnl_has_port()?
> 
> Per-entry valid / used flag seems a little wasteful.
> 
> Another option is to have a reserved tunnel type for invalid / unused.

Reserved tunnel type seems best to me.  (sfc generally uses all-ones
 values for reserved, so this would be 0xffff.)

Alternatively you could change it to store an enum efx_encap_type in
 the table (see filter.h), and move the conversion to MCDI values to
 efx_ef10_set_udp_tnl_ports(), since that has a defined NONE value.
 But that means converting twice (from udp_parseable_tunnel_type to
 efx_encap_type and then again to MCDI) which isn't the prettiest.

-ed
