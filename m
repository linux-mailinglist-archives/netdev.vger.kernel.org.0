Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C291CB52A
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 18:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgEHQsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 12:48:14 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6724 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726951AbgEHQsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 12:48:14 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 048GZu7k008848;
        Fri, 8 May 2020 09:48:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=SyymdrpQLXErYuC0KlWgtrD6U8TuXRwzg0wTd4A6bR4=;
 b=Z5TjOXecg6bBRcmQ0thoiC7AvFM9MwhNyR9q1bePvRL17N+Q7Y9/RNr4pib3CXb/EyVD
 727dSSuNomgkoa5mQFzTaLLnAuGlqFno/9uY/IlicNHlJ5DF4Yzrc8ASwOMc43yly+WA
 YO2rO6pqRZ5E5nYRb4XsxCOT1WLVDZ45GFzY7Z9ioa3lgjCvzbksd6y68JzPdzx7v3x4
 xEIXK2wiQRAhEz15pvqFdCX9uVIKCeNURNWlqENqVYtifYJfpdzz5b/nEefqstiS1pnf
 vYAI+VDsikLntTYmPdJ62u4FwvvzR/nk8hLTPsKIGYitQqNScBJg4u9lZyWn1ZcEO2uJ ww== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 30vtdvbmnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 09:48:10 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 8 May
 2020 09:48:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 May 2020 09:48:08 -0700
Received: from [10.193.46.2] (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 21E5E3F703F;
        Fri,  8 May 2020 09:48:06 -0700 (PDT)
Subject: Re: [PATCH net-next 7/7] net: atlantic: unify get_mac_permanent
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        "Mark Starovoytov" <mstarovoitov@marvell.com>
References: <20200507081510.2120-1-irusskikh@marvell.com>
 <20200507081510.2120-8-irusskikh@marvell.com>
 <20200507122957.5dd4b84b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <628e45f4-048a-2b8f-10c8-5b1908d54cc8@marvell.com>
 <20200508094218.260acc03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <d509d2cb-0402-8053-7e9e-99bff970b11f@marvell.com>
Date:   Fri, 8 May 2020 19:48:05 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0) Gecko/20100101
 Thunderbird/76.0
MIME-Version: 1.0
In-Reply-To: <20200508094218.260acc03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_15:2020-05-08,2020-05-08 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> Thats why the logic below randomizes only low three octets.
> 
> Are there any other drivers in tree which do that? I think the standard
> operating procedure is:
> 
> if (!valid) {
> 	netdev_warn(dev, "Invalid MAC using random\n");
> 	eth_hw_addr_random(dev);
> }
> 
> Please see all the eth_hw_addr_random() calls in drivers.

You are right indeed. Sorry I somehow overlooked this sequence in other device
drivers. Agree, its better to unify behavior then.

Thanks,
  Igor
