Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3454263EAD3
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 09:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiLAII0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 03:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiLAIIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 03:08:12 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4361C12E;
        Thu,  1 Dec 2022 00:08:09 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B12AYOp024672;
        Thu, 1 Dec 2022 00:07:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=QlV4YzWyDEKHu3ZA8fQXtw+am5fVbDPoDzlHK8TK6nI=;
 b=UPElCX2ejajY5jwOmzWnZdI8ppFU1cVutHabjJjreCoIERRY6jP14bXMVDYFDcp1+VpW
 1juskkAzfrYj7kJf2RQu7MLvpaXe7OSu1zooRh2RVVkbWYXM328FeIFkZfpdTrfDnhDi
 1g2gJs8aFaH1wB75zy4k6CkCMtp1xIyFjKJPz4fLevKEat5lewiExmo1AErCxEWH/Hm2
 c7oE3yCHJI3pOLQ4hXZ+emxEW6H/KBRG//hxbkqX4OLbYg8CVxXkrzd4nRcNWyJhvusS
 Umtth4Ice8b1owcBI8cCx7MyH6SrhokmPva74fLiOhFaX5h5tblurRSGOyS0eW7PZEZC aw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3m6k8k103h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 00:07:58 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 1 Dec
 2022 00:07:56 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 1 Dec 2022 00:07:56 -0800
Received: from [10.9.118.29] (unknown [10.9.118.29])
        by maili.marvell.com (Postfix) with ESMTP id C41F63F705D;
        Thu,  1 Dec 2022 00:07:49 -0800 (PST)
Message-ID: <7ed83813-0df4-b6ac-f1d2-a28d8011b1aa@marvell.com>
Date:   Thu, 1 Dec 2022 09:07:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:107.0) Gecko/20100101
 Thunderbird/107.0
Subject: Re: [EXT] Re: [PATCH] net: atlantic: fix check for invalid ethernet
 addresses
To:     Andrew Lunn <andrew@lunn.ch>, Brian Masney <bmasney@redhat.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <cth451@gmail.com>
References: <20221130174259.1591567-1-bmasney@redhat.com>
 <Y4ex6WqiY8IdwfHe@lunn.ch> <Y4fGORYQRfYTabH1@x1> <Y4fMBl6sv+SUyt9Z@lunn.ch>
Content-Language: en-US
From:   Igor Russkikh <irusskikh@marvell.com>
In-Reply-To: <Y4fMBl6sv+SUyt9Z@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: Rc8qE33fkyFS3vduHN461Z1WZrw45Cgl
X-Proofpoint-ORIG-GUID: Rc8qE33fkyFS3vduHN461Z1WZrw45Cgl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_04,2022-11-30_02,2022-06-22_01
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> That won't work for this board since that function only checks that the
>> MAC "is not 00:00:00:00:00:00, is not a multicast address, and is not
>> FF:FF:FF:FF:FF:FF." The MAC address that we get on all of our boards is
>> 00:17:b6:00:00:00.
> 
> Which is a valid MAC address. So i don't see why the kernel should
> reject it and use a random one.
> 
> Maybe you should talk to Marvell about how you can program the
> e-fuses. You can then use MAC addresses from A8-97-DC etc.

Hi Brian,

I do completely agree with Andrew. Thats not a fix to be made in linux kernel.

The boards you get have zero efuse. You should work with Qualcomm on how to update mac addresses of your boards.

Igor
