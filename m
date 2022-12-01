Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6B963F399
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 16:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbiLAPTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 10:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbiLAPS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 10:18:56 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49386A95A4;
        Thu,  1 Dec 2022 07:18:48 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B1E4xMG015735;
        Thu, 1 Dec 2022 07:18:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=66+G9H22g4hRPtoYp3bmPUXEjzgdGyR2i/Bf94l09U0=;
 b=HGGAsPW1CNlDtMh8xxh4eH/0boNz60YhLcGWoagrmrd1G4GAKmkJcFayhVBaytkL1VsU
 1NpnXo5PxylCCtPd/BhkxEI3w9R+MHlFACzxtRdy6NT0DRHgJL1QmHwlv/yMXlaHdJGf
 +5Ul7ivtUf0JJB6P+K6+jez+EzAV7lIJZ6t2j7drEsdsEnCHk38Cb+VvC6l7hK9BJm6D
 cDJ6Gf9vVHRoz57uYsfQGh4zmA6g0wQZnQAjLe0ivx+MBAGKDVlnY1k0jnWwzdIbL3Gd
 YhG/Lu114UXxrW6w3GuZhTKEggEv7l+Mg0XxkOfcf2/BWlz82VGeK7JcRcQbxmXaVXpJ RQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3m6k712ayt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 07:18:36 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 1 Dec
 2022 07:18:34 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 1 Dec 2022 07:18:34 -0800
Received: from [10.9.2.145] (EL-LT0043.marvell.com [10.9.2.145])
        by maili.marvell.com (Postfix) with ESMTP id E1BB95B6923;
        Thu,  1 Dec 2022 07:18:32 -0800 (PST)
Message-ID: <639ba08b-12e5-a293-c10e-4f197a24c197@marvell.com>
Date:   Thu, 1 Dec 2022 16:18:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:108.0) Gecko/20100101
 Thunderbird/108.0
Subject: Re: [EXT] Re: [PATCH] net: atlantic: fix check for invalid ethernet
 addresses
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Brian Masney <bmasney@redhat.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cth451@gmail.com>
References: <20221130174259.1591567-1-bmasney@redhat.com>
 <Y4ex6WqiY8IdwfHe@lunn.ch> <Y4fGORYQRfYTabH1@x1> <Y4fMBl6sv+SUyt9Z@lunn.ch>
 <7ed83813-0df4-b6ac-f1d2-a28d8011b1aa@marvell.com> <Y4i24x8gSAs8/i0I@lunn.ch>
Content-Language: en-US
From:   Igor Russkikh <irusskikh@marvell.com>
In-Reply-To: <Y4i24x8gSAs8/i0I@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: lz4mUCWn5JfjuNDCkS9aFhs6wclXwH0G
X-Proofpoint-GUID: lz4mUCWn5JfjuNDCkS9aFhs6wclXwH0G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_11,2022-12-01_01,2022-06-22_01
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Andrew,

>> You should work with Qualcomm on how to update mac addresses of your
> boards.
> 
> Why Qualcomm? I assume the fuses are part of the MAC chip? So Marvell
> should have a tool to program them? Ideally, it should be part of
> 
> ethtool -E|--change-eeprom
> 
> but when i took a quick look, i could not see anything.

Normal production chips should have efuses (and macs) programmed on factory.

Here I assume we have preproduction/development samples which made no way
through the normal process.

Marvell provides normally all the tools to the customers, but these are
internal, we do not make these available to the end users.

Igor
