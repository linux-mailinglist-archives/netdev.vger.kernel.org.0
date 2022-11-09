Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAE76227A2
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 10:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbiKIJyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 04:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiKIJyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 04:54:50 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FA712AA3
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 01:54:49 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A98eJZn011834;
        Wed, 9 Nov 2022 01:54:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=O3kHryDUOC0j/L2O4pkGCSCEnryv68VGKzwyojPxD44=;
 b=QuMXDvUuw4yVd3L67x4Ouv0t+aNoG+QIgPXWguUhpK3lNwhSebhAZiKLPa3bBeFqUGAW
 3/tS+D1KNOxg2AmRc3hXNmo69H282e1ufHPKsDRrMYmzIX2jfT3bECEFE7NbRMA6Hmzo
 Yc0n0i0Z5QT+cYRxHrOObXtJr3T6oEIBNQk7dlukd8F8cDiSUQtC3pOt4O1TvggkLZXm
 WFIayIyui7FZq0hUpb2wpQHJhpW/nyKqeakUfXRjGOONktXOzrX+NSY/XjsfSxvVZ5YO
 ebm+TUayOhC9ehG2D8EdfWLx0Z2t/p6iZEQIz7H7uZkaY14S7yZkrURO7ETUnJfTWnBI VQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3kr8wbr7rc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 09 Nov 2022 01:54:42 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 9 Nov
 2022 01:54:40 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 9 Nov 2022 01:54:40 -0800
Received: from [10.9.2.145] (EL-LT0043.marvell.com [10.9.2.145])
        by maili.marvell.com (Postfix) with ESMTP id 6D23A3F7045;
        Wed,  9 Nov 2022 01:54:37 -0800 (PST)
Message-ID: <54d3604c-a3da-24b5-af23-3cd5b8a9208a@marvell.com>
Date:   Wed, 9 Nov 2022 10:54:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101
 Thunderbird/106.0
Subject: Re: [EXT] [PATCH net 0/2] macsec: clear encryption keys in h/w
 drivers
To:     Antoine Tenart <atenart@kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     <sd@queasysnail.net>, <netdev@vger.kernel.org>
References: <20221108153459.811293-1-atenart@kernel.org>
Content-Language: en-US
From:   Igor Russkikh <irusskikh@marvell.com>
In-Reply-To: <20221108153459.811293-1-atenart@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: -g2Eax_WsvLBlyjn4a3cY98JuVmFc5pj
X-Proofpoint-ORIG-GUID: -g2Eax_WsvLBlyjn4a3cY98JuVmFc5pj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_03,2022-11-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Commit aaab73f8fba4 ("macsec: clear encryption keys from the stack after
> setting up offload") made sure to clean encryption keys from the stack
> after setting up offloading but some h/w drivers did a copy of the key
> which need to be zeroed as well.
> 
> The MSCC PHY driver can actually be converted not to copy the encryption
> key at all, but such patch would be quite difficult to backport. I'll
> send a following up patch doing this in net-next once this series lands.
> 
> Tested on the MSCC PHY but not on the atlantic NIC.

Hi Antoine, reviewed both. Will try to test on atlantic when possible.

Reviewed-by: Igor Russkikh <irusskikh@marvell.com>

Thanks
  Igor
