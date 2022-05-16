Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45DA527CF4
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 06:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237509AbiEPEqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 00:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiEPEp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 00:45:59 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E247F54
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 21:45:58 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24FNrF0J031489;
        Sun, 15 May 2022 21:45:40 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3g2bxsn86c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 15 May 2022 21:45:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GneGCz+L9EvIDdG48zdhURAUErf+Br7Ditr+h64/XSE+r5Y1LkcR+oRBuaxRGhmW8iPV5FCw80qpoVUV/pwQAYGbV2dlHAzUUGxPGKHUlQ8irD9yQAhMRrYvIQR99wbF1MWiNQZ8eoHCBTCaZCseFK85/aRE7U2RfQbKpV9l35tcqyhXs7YPrvK+RA3K8C+mcouWSv56P5FIQF8zrzS7nbsfOkG8mwg5nbO21JHMzvlvjslA65Cr8yPtt4oFHYHzcDuZ08KcTaPykvZXwEe2PL1rO94bc71fg1Q6/RIayhTwlptOF3uLZXXdyIRgtbuI5Aj7KgUB1DM/aX0NkhV49A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K7YrVlPcT6RjfhzkPLowk+dI47vxoVsiv7nTKsq4UbU=;
 b=Dx21JLrr1A4xF2estFq78f74l5z0674F/lSWEIElW73mubekWm0SgD7TeZAeKcduCq+ybHCZPgxY4nXjtwZlJvKdhZdMGhYhXfYnKHBsxugBhBgc3dW64Uhm0SgzOuMlgFemzspGLkVJXQSNHYSTX0W0UeqV+XN3mf/6u8/M5pDL+UE0sZFq4GBl2VLyFO9Oy5mz309SWXHC5UGrd8pSi7Fe/Pe5++EEtI4SFVZsneMZMOaB2RcXsvXuU8fVsfJdVJN2YBgVoq4ZgrNnSnNkjSZyC/yU3VjEqNPW1A9b76/Pb7vZ4imHGL6mRsoKFg6hIoHXkt4B6Wf880qp0z5MaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K7YrVlPcT6RjfhzkPLowk+dI47vxoVsiv7nTKsq4UbU=;
 b=tC0M1asgpUuHvj209Okq87FvR0DMDbYKXPlGZfHl8UjP2cdjfKfaW4IX0uxP0K8A67j5gkzAAi2zbhIvjJIqBAlgv9pmU4c2PQS+A/4tFfANiu1dS96MVkNzMNMjlqnTBIL7DGbjNEJC3Su5LgIqt6jxolLJ6QccGex2llO3dcM=
Received: from SJ0PR18MB5216.namprd18.prod.outlook.com (2603:10b6:a03:41a::12)
 by CY4PR1801MB1879.namprd18.prod.outlook.com (2603:10b6:910:80::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Mon, 16 May
 2022 04:45:38 +0000
Received: from SJ0PR18MB5216.namprd18.prod.outlook.com
 ([fe80::2459:114e:d9c6:efe8]) by SJ0PR18MB5216.namprd18.prod.outlook.com
 ([fe80::2459:114e:d9c6:efe8%7]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 04:45:38 +0000
From:   Suman Ghosh <sumang@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "Sunil.Goutham@cavium.com" <Sunil.Goutham@cavium.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        "colin.king@intel.com" <colin.king@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [net-next PATCH] octeontx2-pf: Add support for adaptive
 interrupt coalescing
Thread-Topic: [EXT] Re: [net-next PATCH] octeontx2-pf: Add support for
 adaptive interrupt coalescing
Thread-Index: AQHYZdCfPcw3eJ+wUk6Q4KG+WTHcYK0b7MgAgAT9jjA=
Date:   Mon, 16 May 2022 04:45:37 +0000
Message-ID: <SJ0PR18MB521639671BD7597B7CF6C0BDDBCF9@SJ0PR18MB5216.namprd18.prod.outlook.com>
References: <20220512071912.672009-1-sumang@marvell.com>
 <20220512165842.4f0ed0f8@kernel.org>
In-Reply-To: <20220512165842.4f0ed0f8@kernel.org>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8fff2ed8-3ca5-4cb6-c9d0-08da36f6ec3d
x-ms-traffictypediagnostic: CY4PR1801MB1879:EE_
x-microsoft-antispam-prvs: <CY4PR1801MB18790EEC52610DD5854795B4DBCF9@CY4PR1801MB1879.namprd18.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CB5HKD9VJ04XPOZxeMLDXTBl/Pamwl0wRWqql9p8aMddHTk81tboGCar451j/611spaZgr94z8Mrm06bq39ASrsYVnSJ4w9t4PQSYpsI3YvmbVzSgdkuze1pNE62E1GXZqMUXiGbXhQvLrxVp4O0gazcmJTFNQWqdGTCF1rZ7i/osLftidlLNI4yCjwKvltlxWA/bgVkjCBTTKdn4llNEwZDDUHHSvezxuBKZoF6gvPDXQGzOHDPPFlTZdeuCfcLH6hoybt5M4Vg9ESeDIQ4y4/6A+W7I1vNcogIOVNxkCoYNmS94bbXEKqCiiY0HgScJIbYgIwWca9gvdUVDQUJ3ztTpGMZX7oFmiAmhhRSQydoS3BWsVRGgVKXpTcany55reECkZt02/vXLUqIsMnvnTHgj4ok1PJMoqa5PzeSxI2jajrDB6vWxKrgsgg9KlXvOWXo492FOiQNOQpE9KRxlgwdbtmQ1EZ/ZqsiT2v88D9OcSZEmiKycrrN74+b8CwvKgk0CBtV1SLjsfE6HjZ48i8fIUz00jiUS0gVCaOI6klNZ+tj5n6I4BZTPBcyS4hbWit5J4JMe0EsemPT9qcMZ8OdfuK4OrjoaGKT/9svGFmX7b4mtNuJbf2YMDNSBNZd7xwKiSp6w7CiyH+JOOul6gIo889b8Xb0BvlZj360qz2mxOy9ORPuVRwj+aUDeTs7+pZwsPhh+ZvBfyxAfRN2eg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB5216.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(9686003)(54906003)(186003)(6916009)(71200400001)(6506007)(2906002)(83380400001)(26005)(33656002)(508600001)(8936002)(66946007)(66556008)(76116006)(55016003)(122000001)(316002)(5660300002)(66476007)(66446008)(64756008)(52536014)(4326008)(8676002)(7696005)(86362001)(38100700002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xrBbs0QuTLEdiEzuMEsAj7vHsRhWFFWQ5AawAzkj8HeB9Dla6IRdXXwvRCq7?=
 =?us-ascii?Q?+xTnDMx+2KIvZXwY3LsUKYhYWLyLLu1kHEzRsCIa4yO7hGy7uU/+/BpUWslk?=
 =?us-ascii?Q?hs3iQPL56NoMc68T7vg4Dh16dIEh+VdHAI8AH9jRQloyxORSJKK+ST+mti2R?=
 =?us-ascii?Q?wjRaq8umnpKbTjkI2PXf/quJ/04e1dsc9OCmcQjo+LHqKfrM/5vTbRCna/gu?=
 =?us-ascii?Q?jBDHCz4cZmlMZJX3Qo44m9fPny9H7qMT84MSNcjZ3Mg6assCtR3J4cztc7jp?=
 =?us-ascii?Q?LTS+FsuFYLDmMfn5L+KyHwqZzbSckaYtRApXlI98nGYQU5ufcvgH54aSJ7Cw?=
 =?us-ascii?Q?E5Y5QwW0ueDIdLSQ3Allw4oPKbl7qJas9BmvakC3ABw6Yw/0X29stCW548aU?=
 =?us-ascii?Q?XBmbOvntWWnJ44y5bHXbJAVGVk7bUKk8vEaAQJ8NBI5iRRLBRU8l5aze5pug?=
 =?us-ascii?Q?Rr3AnQvfQlwC+c5le/PKEunnXW65LXsz8oHWT7YkGyJlejSGXLbkPMZojitl?=
 =?us-ascii?Q?ZPRSHK0tyE4mLA/2x76W9xZWTEMeiDh5AAZoy0SNWMySWRgBBpwEjhTTuqmf?=
 =?us-ascii?Q?lN79SfLEacHfYES40e0vH8Ntpez0BstcTWTKA5OEuPy74x/cmZ8lLLUsPynv?=
 =?us-ascii?Q?h6VsZDuc00IR8UY+H/C6s52xfiqa4ru9mEYG3yJCOr3U0mBVG1tbyk2Fk08f?=
 =?us-ascii?Q?hsDOuai1hqZi6LOQXRw6NMrSELhak5XZr8q27i9Z042VQW1hf6fXnG2nnVLA?=
 =?us-ascii?Q?x3LpKjJK3sW7tIA+x4h5cIt6nivjNRyMONkAv8jkR0EEfMh7vhFhfS04VVeZ?=
 =?us-ascii?Q?pHyCGDVm0FCRS5Gy1ywTnLSjcLdKTen+rdzC5kmSiR/eUpd/o1SWC9zt0lZi?=
 =?us-ascii?Q?qt9utMI9VCYPshBHjZF4YmAH5LmTYQvFps+P/ZCIrk+R42F34HRtAMfasAS2?=
 =?us-ascii?Q?z8hd5hUgKdcapqCd4Ua/iK1Exl0+18yk1/2aTYkuk/eYLaosFzJD1ouXEy4U?=
 =?us-ascii?Q?EE/0OeWnvogPBP+JNOsPhhE811JpzhKUfmKe036s6SF2EAzLoqmEoHhamqGY?=
 =?us-ascii?Q?hm9qKCuW+H6bwGNZx1USXE/qV/Ob6qnQuMXytCCe9nQEdDlLzUva60vZhPjJ?=
 =?us-ascii?Q?gUdy+JH2u3xWI52mRTwQIeYGdAVzQnpu7XjEMrx13C0bTBGhE1nMvHMhTM/j?=
 =?us-ascii?Q?wuO6MmASS9ivXYyQihML34dojljuLJFOpPaB0xRdjpzzkUP6XHUfsu3MungT?=
 =?us-ascii?Q?B0UJ15kQ43oZZJWJuuJ8rx2OylYZAKDSLNRuOJE1m8MoxHo5rVXr/ma7i4/y?=
 =?us-ascii?Q?rbBH5iYaE1U+WlmOGz2WdogVb6/aVzneUhcT1UcxyZjvWpBQdYMCECCdsK67?=
 =?us-ascii?Q?djRZ2KmyLUEFqe8U0aNXzVLEDdXZG7HtL4H93NfoXJp635xRf6VrH72H5Hd9?=
 =?us-ascii?Q?+XPMXObBMaMnn9oWGd9awCavG1S6vCoS68J8u8QZMh1Mx5fGq3ZrPeIPoK1A?=
 =?us-ascii?Q?W0arG6zWZk2uCxvGg0meTpYRs1NKG+ppDkOf8GMpl56lYdS+YEiE9eJK84p0?=
 =?us-ascii?Q?yUowoJeNwqhT2XDnQ3qjpQI3bEzGZ/wYmdK7muOP54bNGaCQDIl5qLGChngv?=
 =?us-ascii?Q?AeShzND9wZxqzitPtc3ZkjKPSL0e39Vnc8FwFwClCz82vYRqI5vh351pSdhG?=
 =?us-ascii?Q?iG5bVBbKZ+gAmZbXQVerX92KhimLmnjJjmShqpxq6Z7K8CSmwdZJjytjDylL?=
 =?us-ascii?Q?a/FTR2NqcA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB5216.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fff2ed8-3ca5-4cb6-c9d0-08da36f6ec3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2022 04:45:37.9517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MT6lHl7c2chAm/GoHOcMa4jCm72ntj2bbKgviZqMI+46yj/Tb7KXpMJtAc+4Sl5Naa6Jm7fcJ+1bAUi7rd57ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1801MB1879
X-Proofpoint-ORIG-GUID: TCKJH5q41U0-8g-Yd1QpSJgUk33E7Umo
X-Proofpoint-GUID: TCKJH5q41U0-8g-Yd1QpSJgUk33E7Umo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-15_11,2022-05-13_01,2022-02-23_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>You still claim this is tested? How can it work if you're not changing
>.supported_coalesce_params? Do we have a bug in the core?
[Suman] This feature is changing " cq_time_wait" and " cq_time_wait" dynami=
cally based on net_dim. Which other .supported_coalesce_params do you mean?
>
>> +	/* Check and update coalesce status */
>> +	if ((pfvf->flags & OTX2_FLAG_ADPTV_INT_COAL_ENABLED) =3D=3D
>> +			OTX2_FLAG_ADPTV_INT_COAL_ENABLED) {
>> +		priv_coalesce_status =3D 1;
>> +		if (!ec->use_adaptive_rx_coalesce || !ec-
>>use_adaptive_tx_coalesce)
>> +			pfvf->flags &=3D ~OTX2_FLAG_ADPTV_INT_COAL_ENABLED;
>> +	} else {
>> +		priv_coalesce_status =3D 0;
>> +		if (ec->use_adaptive_rx_coalesce || ec-
>>use_adaptive_tx_coalesce)
>> +			pfvf->flags |=3D OTX2_FLAG_ADPTV_INT_COAL_ENABLED;
>> +	}
>
>Won't this flip-flop the flag? You should probably reject adaptive_rx !=3D
>adaptive_tx.
[Suman] The idea here is to enable/disable coalesce if either rx or tx stat=
us is enable/disable.
If we enable only adaptive_rx then adaptive_tx will also get enabled as for=
 this hardware both RX and TX=20
are mapped to the same queue. We do not support separate setting for rx/tx =
coalesce for a net-device.
>
>>  		/* Re-enable interrupts */
>>  		otx2_write64(pfvf, NIX_LF_CINTX_ENA_W1S(cq_poll->cint_idx),
>> -			     BIT_ULL(0));
>> +				BIT_ULL(0));
>
>Unrelated and possibly misalinged?
[Suman] Yes, will fix in V2.
