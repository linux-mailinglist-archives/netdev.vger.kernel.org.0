Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDE720721F
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 13:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390645AbgFXLb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 07:31:59 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:1806 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388470AbgFXLb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 07:31:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1592998319; x=1624534319;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ytChrvYAloZwmq/t2qRRQKdJIdRvD5ZigkU1TGR2Ylk=;
  b=bVa580UVe4P1eOQ12ADT9omVfi6UrO5iWvaOKpAx4IbEmphNp2rK5l3H
   BvlZJQHFqgHk4OxoNmgqDh9LMvAzlfmBDstqyp8fq+y4KJfOXe/x9/pow
   JzLGrUgStCHwOoLYb6Pj7N84rSRNDieSOTNPCsVRQdFn/fJpqVJ+1wFry
   K7kRXgNxvkjNBstCUoX1QcR8Gvo2UhPDkpf1hlHe4I0EPI19ZY7br/k0n
   NuilMum9892bk2HrHL94dnfh2+G7Dk+MVC2ebE7BKWOsN/QW8gSw4+Dk7
   +4YlcIPOYYJGI+7nOvwCEhZhbrhJXPGhvmUcKUldw7KVr3orl8BYnNMpr
   A==;
IronPort-SDR: Otnu5zaWQnGtJeKyFJ4oY4LrHRbzk1keJeICfFcy3n7QvBPhI2tkHpler6TjeFRsQFjTIuLjPC
 rkecIdjwTgPbC8cAWgWHGOXs6mw/g5SasaeFeB0YK4KvfLFJUHEGihqloZ65K7PL/lZxfIr4Fm
 7bxyS1Tz1FAqbTSy9xla2EBe36cvR913P/g+auO53KwNyUsPmLK5fp5p9+7cLZTUyEh/rmkz0t
 pMhLUnLKC5RO9XsCiX/Gj6QjIjxUs4bdhOr9VTfq1BFJjJmRbYk6fflBU2r6/d4GLH6Kz7J1Bn
 sgM=
X-IronPort-AV: E=Sophos;i="5.75,275,1589266800"; 
   d="scan'208";a="80727156"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jun 2020 04:31:59 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 24 Jun 2020 04:31:57 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 24 Jun 2020 04:31:57 -0700
Date:   Wed, 24 Jun 2020 13:31:56 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     David Miller <davem@davemloft.net>
CC:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net v2 0/2] bridge: mrp: Update MRP_PORT_ROLE
Message-ID: <20200624113156.hsutqewk4xntmkld@soft-dev3.localdomain>
References: <20200623090541.2964760-1-horatiu.vultur@microchip.com>
 <20200623.143821.491798381160245817.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20200623.143821.491798381160245817.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 06/23/2020 14:38, David Miller wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> From: Horatiu Vultur <horatiu.vultur@microchip.com>
> Date: Tue, 23 Jun 2020 11:05:39 +0200
> 
> > This patch series does the following:
> > - fixes the enum br_mrp_port_role_type. It removes the port role none(0x2)
> >   because this is in conflict with the standard. The standard defines the
> >   interconnect port role as value 0x2.
> > - adds checks regarding current defined port roles: primary(0x0) and
> >   secondary(0x1).
> >
> > v2:
> >  - add the validation code when setting the port role.
> 
> Series applied, thank you.

Thanks. Will these patches be applied also on net-next?
Because if I start now to add support for the interconnect port, these
patches are needed on net-next. Or do I need to add these patches to the
patch series for the interconnect port?
What is the correct way of doing this?

-- 
/Horatiu
