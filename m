Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 166D91B430
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 12:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbfEMKnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 06:43:12 -0400
Received: from mx5.sophos.com ([195.171.192.119]:35977 "EHLO mx5.sophos.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727272AbfEMKnL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 06:43:11 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 May 2019 06:43:09 EDT
Received: from mx5.sophos.com (localhost.localdomain [127.0.0.1])
        by localhost (Postfix) with SMTP id BC1E5F38C8;
        Mon, 13 May 2019 11:36:55 +0100 (BST)
Received: from abn-exch5a.green.sophos (unknown [10.224.64.44])
        by mx5.sophos.com (Postfix) with ESMTPS id 9D884F375D;
        Mon, 13 May 2019 11:36:55 +0100 (BST)
Received: from abn-exch4c.green.sophos (10.224.64.39) by
 abn-exch5a.green.sophos (10.224.64.45) with Microsoft SMTP Server (TLS) id
 15.0.1293.2; Mon, 13 May 2019 11:36:54 +0100
Received: from abn-exch5a.green.sophos (10.224.64.44) by
 abn-exch4c.green.sophos (10.224.64.39) with Microsoft SMTP Server (TLS) id
 15.0.1293.2; Mon, 13 May 2019 11:36:52 +0100
Received: from GBR01-CWL-obe.outbound.protection.outlook.com (104.47.20.52) by
 abn-exch5a.green.sophos (10.224.64.44) with Microsoft SMTP Server (TLS) id
 15.0.1293.2 via Frontend Transport; Mon, 13 May 2019 11:36:52 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sophosapps.onmicrosoft.com; s=selector2-sophosapps-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ayMU9qBzLBcWoaFXnWug/xjIsNgYb4uRwNcwU8qXbSE=;
 b=YEjvP2QY4yqhxzxG/HSeI/psqrnkrVvvEk8O/IM2UecFhdsKYBWOsFMFAXiabVL408xglCO0wlCNT70dpvVq1e/cEpWFI7fq+6A+kZM0FsRIs0h4rNTviMrhIqZHLiPCEHcktc/FiDeY4Ggn26L6L6HKv09dk9l/EKH48RwowkE=
Received: from CWXP265MB1464.GBRP265.PROD.OUTLOOK.COM (20.176.48.15) by
 CWXP265MB0775.GBRP265.PROD.OUTLOOK.COM (10.166.155.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.21; Mon, 13 May 2019 10:36:51 +0000
Received: from CWXP265MB1464.GBRP265.PROD.OUTLOOK.COM
 ([fe80::11bf:3c6:d636:8591]) by CWXP265MB1464.GBRP265.PROD.OUTLOOK.COM
 ([fe80::11bf:3c6:d636:8591%5]) with mapi id 15.20.1878.024; Mon, 13 May 2019
 10:36:51 +0000
From:   Jagdish Motwani <Jagdish.Motwani@Sophos.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jagdish Motwani <j.k.motwani@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] netfilter: nf_queue:fix reinject verdict handling
Thread-Topic: [PATCH net] netfilter: nf_queue:fix reinject verdict handling
Thread-Index: AQHVBcxgq4KNCrDWoUOMWqDhWMYmkaZozxeAgAARJ/A=
Date:   Mon, 13 May 2019 10:36:51 +0000
Message-ID: <CWXP265MB1464BCF96C61A8FD47619AE59E0F0@CWXP265MB1464.GBRP265.PROD.OUTLOOK.COM>
References: <20190508183114.7507-1-j.k.motwani@gmail.com>
 <20190513092211.isxyzpytenvocbx2@salvia>
In-Reply-To: <20190513092211.isxyzpytenvocbx2@salvia>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jagdish.Motwani@Sophos.com; 
x-originating-ip: [125.19.12.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a31426d-79aa-4dd0-6f4a-08d6d78ee911
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:CWXP265MB0775;
x-ms-traffictypediagnostic: CWXP265MB0775:
x-microsoft-antispam-prvs: <CWXP265MB0775674DCB638FE28708D73A9E0F0@CWXP265MB0775.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0036736630
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(396003)(39860400002)(346002)(376002)(13464003)(199004)(189003)(51234002)(478600001)(6436002)(14444005)(68736007)(71200400001)(71190400001)(102836004)(7736002)(55016002)(305945005)(2906002)(66066001)(229853002)(52536014)(3846002)(6116002)(256004)(7696005)(81156014)(110136005)(8676002)(74316002)(53546011)(6506007)(54906003)(4326008)(81166006)(76176011)(9686003)(86362001)(476003)(14454004)(8936002)(25786009)(6246003)(486006)(99286004)(73956011)(446003)(26005)(5660300002)(33656002)(11346002)(64756008)(186003)(66446008)(66556008)(66946007)(66476007)(53936002)(76116006)(316002)(72206003);DIR:OUT;SFP:1101;SCL:1;SRVR:CWXP265MB0775;H:CWXP265MB1464.GBRP265.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: Sophos.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XW4qhJrjAsW6CsUO+QxlvLcBZ3XYujvPWdcKsA1S0ufUEb10Sj2vYZRWeOrdLBsxKvvohi5xZOCxjU4evj8eabL/etVukOZHLs7WO/3S4yQT0PlhZY84CLK9izQ2DCEh5lvn5IFJB1GGOc7uX5uYN3/3n0EGhyGS82rBrGW6TUhc1c8ZWqVdeI689tZCmmLVvZfO/BLdOri02K9U4C/5xZkM+MtSOIa05CMbIsd3KGVnEXU5uZGoagW/hKEklYW1rrHG1WzlYSP+4lQSipW/ZIG0oDkcbd/l985Z9cNXm/LCiT1mL54nsLvP6aSu9vYGNsyzVKCR+rd/jU2xU5Eo+AePwwLtIQzBdqVd+ot7TOYscCxQUgP96emknk6z3ZpnnaOnjGCnQkTVibSbfybxkcQDjDkz0sfOZBw5Uf9pCUU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a31426d-79aa-4dd0-6f4a-08d6d78ee911
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2019 10:36:51.4016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 358a41ff-46d9-49d3-a297-370d894eae6a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP265MB0775
X-OriginatorOrg: sophos.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sophos.com; h=from:to:cc:subject:date:message-id:references:in-reply-to:content-type:content-transfer-encoding:mime-version; s=global; bh=ayMU9qBzLBcWoaFXnWug/xjIsNgYb4uRwNcwU8qXbSE=; b=VPKigIOPZArOA4gGzdTxf8p9pXioL4Qr2u4Vk+Kx5IN5VNatabFmvBTCkqn6MGztD5Bnem+I1ed9kbymkS3zBEZGGnCtPV5luAN6cqqfyVwfde5dMS/c3QIyK+ugZcUh/rrqEiRp3VcVTSwpzf22taXZwEcFfOdWNeYhM+6WnPA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo,

The case I am referring to is : If there are more than 1  hooks returning N=
F_QUEUE verdict.
When the first queue reinjects the packet, 'nf_reinject' starts traversing =
hooks with hook_index (i).
However if it again receives a NF_QUEUE verdict (by some other netfilter ho=
ok), it queue with the wrong hook_index.
So, when the second queue reinjects the packet, it re-executes some hooks i=
n between the first 2 hooks.

Thanks, I will mark :  Fixes: 960632ece694 ("netfilter: convert hook list t=
o an array") and update the description also.

Regards,
Jagdish
-----Original Message-----
From: Pablo Neira Ayuso <pablo@netfilter.org>
Sent: Monday, May 13, 2019 2:52 PM
To: Jagdish Motwani <j.k.motwani@gmail.com>
Cc: netdev@vger.kernel.org; Jagdish Motwani <Jagdish.Motwani@Sophos.com>; J=
ozsef Kadlecsik <kadlec@blackhole.kfki.hu>; Florian Westphal <fw@strlen.de>=
; David S. Miller <davem@davemloft.net>; netfilter-devel@vger.kernel.org; c=
oreteam@netfilter.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_queue:fix reinject verdict handling

Hi Jagdish,


On Thu, May 09, 2019 at 12:01:14AM +0530, Jagdish Motwani wrote:
> From: Jagdish Motwani <jagdish.motwani@sophos.com>
>
> In case of more than 1 nf_queues, hooks between them are being
> executed more than once.

This refers to NF_REPEAT, correct?

I think this broke with 960632ece6949. If so, it would be good to add the f=
ollowing tag to this patch then. It's useful for robots collecting fixes fo=
r -stable kernels.

Fixes: 960632ece694 ("netfilter: convert hook list to an array")

> Signed-off-by: Jagdish Motwani <jagdish.motwani@sophos.com>

Thanks.

________________________________

Sophos Technologies Private Limited Regd. Office: Sophos House, Saigulshan =
Complex, Beside White House, Panchvati Cross Road, Ahmedabad - 380006, Guja=
rat, India CIN: U72200GJ2006PTC047857

Sophos Ltd, a company registered in England and Wales number 2096520, The P=
entagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.

