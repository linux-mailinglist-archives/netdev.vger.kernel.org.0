Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52CF23C6D83
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 11:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235181AbhGMJfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 05:35:12 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:41098 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234997AbhGMJfL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 05:35:11 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id DBC8A45C91;
        Tue, 13 Jul 2021 09:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-transfer-encoding:mime-version:user-agent:content-type
        :content-type:organization:references:in-reply-to:date:date:from
        :from:subject:subject:message-id:received:received:received; s=
        mta-01; t=1626168738; x=1627983139; bh=gD0UuHaFhtXE1CjYlSQQdnWtb
        kTcj4oOtAaKhS8m6Bo=; b=Ur2vjL8XI1D1BEPiiveK3sXgIHaUN24tyldZ6QS+v
        sPh3LOD4JsHronEa+gn29eap4R+jG+ST2TLf8zNiNpwhbBg5TCRYukspNCLAKjO1
        hTQMmNN3TDsyOCWIGVi8V3aaWf6LeqHF2lWVUykRn7Yitl7w3uFbcFQ/CQOm/P6T
        gI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DlROguvzsDIE; Tue, 13 Jul 2021 12:32:18 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 8D66149E06;
        Tue, 13 Jul 2021 12:32:18 +0300 (MSK)
Received: from [10.199.0.247] (10.199.0.247) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 13
 Jul 2021 12:32:18 +0300
Message-ID: <bf3df39a60917e0d5ac7b6ae7fbb3a083f244e00.camel@yadro.com>
Subject: Re: [PATCH v2 3/3] net/ncsi: add dummy response handler for Intel
 boards
From:   Ivan Mikhaylov <i.mikhaylov@yadro.com>
To:     Joel Stanley <joel@jms.id.au>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>
Date:   Tue, 13 Jul 2021 12:42:05 +0300
In-Reply-To: <CACPK8XcdUtzZCPcmr+=b5kJ=563KroEtfMATquwkqd6Z11JCDA@mail.gmail.com>
References: <20210708122754.555846-1-i.mikhaylov@yadro.com>
         <20210708122754.555846-4-i.mikhaylov@yadro.com>
         <CACPK8XcdUtzZCPcmr+=b5kJ=563KroEtfMATquwkqd6Z11JCDA@mail.gmail.com>
Organization: YADRO
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.199.0.247]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-07-12 at 10:03 +0000, Joel Stanley wrote:
> On Thu, 8 Jul 2021 at 12:28, Ivan Mikhaylov <i.mikhaylov@yadro.com> wrote:
> > 
> > Add the dummy response handler for Intel boards to prevent incorrect
> > handling of OEM commands.
> 
> What do you mean?

When you don't have proper OEM handler for your MFR_ID, you'll get this as
example:
[   39.073873] ftgmac100 1e660000.ethernet eth1: Received unrecognized OEM
packet with MFR-ID (0x157)
[   39.082974] ftgmac100 1e660000.ethernet eth1: NCSI: Handler for packet type
0xd0 returned -2

> Is this to handle the response to the link up OEM command? If so,
> include it in the same patch.

It is not the response, it's provides same way of handling as for broadcom and
mellanox manufacturers.

> Can you check that the response is to the link up command and print a
> warning if not?

Yes, I can. As example, ncsi_oem_smaf_mlx doesn't check the response, for me
it's like unidirectional commands, same for this one.

Thanks.

