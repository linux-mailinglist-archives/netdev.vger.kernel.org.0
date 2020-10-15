Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8BB28F13A
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 13:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729599AbgJOL2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 07:28:43 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:21554 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729588AbgJOL2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 07:28:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602761311; x=1634297311;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RcZqIHyhK/ws9zYsOyz4fhzkQgVNjCJZMvGu9SsFGQM=;
  b=F1eyBEaJpvZ7+vhxhrETBNvNrGsHWVasvF1BRKglgpVnA2jM3oeIjosh
   JowHqC4SXBeCzefAITblkoD12q21E/daM6CKfaR0ZM6TF662leQwMcvZz
   GeH4Hflp4bMuxYYRycKRTlPclRZVB7wENH5GsUteRNrrOhIrldfDYmop9
   wjyYczHHDGEhlqPfQC57I5gnTsyuZ2vanebdCl+mM9jQ3uAWYx8R7+OMe
   hvHiVXQOfQH2JuuIav+Rak0pLOpvO/RVV/p+f44NbEgpMdoR2GXkqmMtq
   fmqE/vtGZR/7NO053//hbPPHQsAYP6kstd6TyIzq/ASaZWIQHZEcZzSls
   w==;
IronPort-SDR: Aq3lUfUp8hdvGGkH7tT9+kYC8WhYsL0YY5w9xeczhGbn8PcCnH8D5Sz7cBJaDsOBY1oN9q/Ep7
 oIguHmyHgCZ0iHDWihjNcIHUyslsvtYcmxAGUJF0thuG/QRbUxFDU4/MslQCN+GHitdrpYBa1s
 svynWsyn3mc3pkp+OwQtjGmov/ROaf67T+EYK/73FzNoFOW4pFMZQtyvylresz3RA+RMwxPoNS
 +G4eUehZEgp+nTzYFCNzkV/UqbAIL5tyGeTNQQUqSFvfiR2HVBVnLSPdLMauGhfRDamDNU2reR
 qfw=
X-IronPort-AV: E=Sophos;i="5.77,378,1596524400"; 
   d="scan'208";a="99624467"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Oct 2020 04:28:30 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 15 Oct 2020 04:28:30 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 15 Oct 2020 04:28:30 -0700
Date:   Thu, 15 Oct 2020 11:26:49 +0000
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v5 04/10] bridge: cfm: Kernel space
 implementation of CFM. MEP create/delete.
Message-ID: <20201015112649.pzx7q6mwjhrxaiha@soft-test08>
References: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
 <20201012140428.2549163-5-henrik.bjoernlund@microchip.com>
 <20201014160042.4967a702@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20201014160042.4967a702@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your review. Comments below.
Regards
Henrik

The 10/14/2020 16:00, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Mon, 12 Oct 2020 14:04:22 +0000 Henrik Bjoernlund wrote:
> > with restricted management access to each other<E2><80><99>s equipment.
> 
> Some Unicode funk in this line?

I have changed as requested.

-- 
/Henrik
