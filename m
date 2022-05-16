Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52BDD5282AA
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 12:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbiEPKzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 06:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbiEPKzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 06:55:07 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF922898D
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 03:55:06 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24FLS5sc011520;
        Mon, 16 May 2022 03:54:54 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3g29sq6rgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 03:54:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rz+qJcWgxxnAHadD8druqzgXRHQoWHHhtkpXn3SJjuMhXty6J5dlWYzNFqwdWrHUIqJx0Ddn1Fx3ZYFRxDVvmEFgwFvOiume5MCQsaWYOlamT+84UwjAlCoKbUVGUlddqmd0dC0GSaMHWvUiehxM9TGcNncQPlcq1yfWkR8rdfHu8mzHnslzeGiDoOcFoI+mppriKcZmwhG3Y6nruE3Zh6nWsbLxnD5HjjMcc3qLRdddKh72fqYcSBpFWAAmiIrSaWDGoKat/oaX0Vo9Be41B/vRVlRXA+KcpaMzKvKfExVMjSlaCa17h3bI2qfl8lZgzswUt6rmGnx9LmM3itLHrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gkL0xc/4D34KrObY3rfSAFTr0NbJGVF2OxjZt8I200M=;
 b=ArWD3DELOHF6qCteocRJOguqERkjrpCwcjm1fRzmeVg25V1hP6t/OMQ2UCqjDzVmC93TC4orisiIemI2/ArXQ0B1ySOpNQJTfQHdEvrTE1AbWlY8oUExWYyKzdx6O2+V4uIuhz5BASljHnlQt7isUJ2ORBYRcDFbCLll1QWL88by54D5c69jY8TWUJcitmJQOnR3R3kVlwLpAjnQ2JbDsMOY2S/HgUysEUP2yQd1rgs1KhU+zbJTdJXLteCgVNtFb2kXnRIHTK5ycK19MYfPEpl5Oo8kYtv/MVw5D7PabUA9wFjZnOmXY5oCikECuNdYKO7WlGe45JvVgaNFLo1D3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkL0xc/4D34KrObY3rfSAFTr0NbJGVF2OxjZt8I200M=;
 b=tqKDnvBVA9dQolNDDt0F7ZLdVj3lympurkpfJksnrhTky4ZYTzbOSxAIQj07ZKEE5BxHRqEvGe4t4czRYDp1Z6cCgcb6hwj5Cl7M/UcLnvnNaiuU+jtTXcyrqRF5EQkvxYayVmzmAaMd+mcON8Nn4lKfcdMS5XM46kz3YJZEXm4=
Received: from SJ0PR18MB5216.namprd18.prod.outlook.com (2603:10b6:a03:41a::12)
 by DM6PR18MB3162.namprd18.prod.outlook.com (2603:10b6:5:1cb::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Mon, 16 May
 2022 10:54:52 +0000
Received: from SJ0PR18MB5216.namprd18.prod.outlook.com
 ([fe80::2459:114e:d9c6:efe8]) by SJ0PR18MB5216.namprd18.prod.outlook.com
 ([fe80::2459:114e:d9c6:efe8%7]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 10:54:51 +0000
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
Thread-Index: AQHYZdCfPcw3eJ+wUk6Q4KG+WTHcYK0b7MgAgAT9jjCAAHCVoA==
Date:   Mon, 16 May 2022 10:54:51 +0000
Message-ID: <SJ0PR18MB5216BFF11DB11CBA28D8D6D8DBCF9@SJ0PR18MB5216.namprd18.prod.outlook.com>
References: <20220512071912.672009-1-sumang@marvell.com>
 <20220512165842.4f0ed0f8@kernel.org>
 <SJ0PR18MB521639671BD7597B7CF6C0BDDBCF9@SJ0PR18MB5216.namprd18.prod.outlook.com>
In-Reply-To: <SJ0PR18MB521639671BD7597B7CF6C0BDDBCF9@SJ0PR18MB5216.namprd18.prod.outlook.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a8c32f8-c032-418b-d854-08da372a80f1
x-ms-traffictypediagnostic: DM6PR18MB3162:EE_
x-microsoft-antispam-prvs: <DM6PR18MB31620ECCC6500B96CE0B633EDBCF9@DM6PR18MB3162.namprd18.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HkcAeFLpOVACNDqKIRQKRu99RQ7Uv+b/ku9iyJOR9B05vmKxnacpbf6uqI3p9TvzW4bG4NLrPw6YxzQ9XJx5kTZElO4YOzo90kDWKUtCUsuCMTgabEyXYGX31NgnMnG71Xwp5Fz6uFNNvdf7br2G9dx8GFjbkJHMJVx3gtiC4tfoGPjROJjTm9jv+M9Fdc6MlbY4d0ICpeSnAorVCh4vsWC0KyGPfYQ4JO//p4JqpRS5FXyYVL2UARuQkOjuS4tuFYdEr9NuwPgKwtiqM9jmMXrsu2Wi13CgqJA/iB2sqbhoHLfeeG6C5QbwXPcWkHtr37NonpDqwti8drfMDxuDoOf4wuR9C63kxuVCsVTr6cPt407cS9CfuTCt/i3Wbt9gU0ZSuJA9jqX3JiTkFSAquZNgfVfEb0XcxgzG48ua4kzAAodagehFrxWENQh0BM3JlP//HZrv01QmhX5c9/LT279pGbjHyyIzWY0rTQnhmZh9VCY8Ja0DJzcDPcpTuB0DoCA0slp4gTjhHvQQwKa6AYPgKcFtzhqirTVLagnKZaFHmr6Mg6IXNMfaeZwKGPd/9VIJUaSl4sSuuOkDtgs5HoLLwW7V6vCY9Pwl1Fod64Uu6TixxSeF1CfGrVUANOhW+J3dzVcF30dUADt9aadzTTTwwcwGKsIS3ztIby5PP97tSczxmCkPkv12Y+5SOmDyYDZFmIqRWY3zJbv3jt7lCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB5216.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(55016003)(54906003)(4326008)(26005)(86362001)(122000001)(38070700005)(38100700002)(66446008)(64756008)(8676002)(6916009)(83380400001)(186003)(316002)(9686003)(7696005)(33656002)(2906002)(5660300002)(2940100002)(52536014)(6506007)(71200400001)(8936002)(66476007)(66946007)(66556008)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0vGBdzjD8yxsSlG3UTNmh7udOam6fswDafiMh/ZKwq6i3h0SXA2jFncgF1M/?=
 =?us-ascii?Q?Bt1Oo9q+M2KVRAlMswi/tZi5LVC1lUyac/JwAKMM1673Vx7Yh51TFPLeZKiS?=
 =?us-ascii?Q?c6Ic/nvx1/NxMboOB/nZYLlQNMV2LQlExkhcb6s9wG0xNZcPUSJ9uuoHrr7I?=
 =?us-ascii?Q?Diuzlf9gTigPQZr15p75S89AkAI3fvyzLsxZbDJFVL2HPZzM/LyPRiGYlOdo?=
 =?us-ascii?Q?n3mu08wDl12s6gaXerX5o6prKZOyig36LNLhf2F8tzaYaQ9hPt3OCRB0eLg3?=
 =?us-ascii?Q?2BeWZWSPgccsEu+O6qMT3c1nsuYbaYgs5TXf/qGd5czg6c1BHNugp1yKc8l+?=
 =?us-ascii?Q?N7Yz90ENa2NFHh6J+PlQBa55xo9IP8QgUShgsDys/5T1gg3DehkqZ05SVAzS?=
 =?us-ascii?Q?CFjRMxpkCY/CfcvnPnUi0uaXcxXvNhipZkeqsRg82m22h2WtIgT8CnoUjXy6?=
 =?us-ascii?Q?zrZYU+VnbQd1QwhIeOhVLVMS+htbHD9bQLGpIWo2s9jWxYaxbNpoxdJxu1ck?=
 =?us-ascii?Q?JwWkIxglYSYdRj2K5Ylx++tjH8ENK6KMDVGqigdW3InwSSvA8ZtqzeTlLofI?=
 =?us-ascii?Q?cqNPzewJqzKVFiVOoAi1NIh2S0K7403IFjILvi6JJxU+xajAPiduVoksLjjI?=
 =?us-ascii?Q?oULc/CNoEbDkA4Q4AuggaTYJNx1uOmCZW7rREnIdMyS0So6WP9IbEAmD7jDj?=
 =?us-ascii?Q?BE2+1iiADerluYLZFAj/FLk4SkO0AQhF6byqAhOhZax4jOXhIFf/WMhHlSwQ?=
 =?us-ascii?Q?JKo0fZco64AATLXHKkN4yZmT0cfFn+uLWuN0Wt328f13BL8+XV8ZPC+9ae7D?=
 =?us-ascii?Q?EhJMTKGbGACwL08KS3VKhERSk/ZiEyIy6JfE/RZWt0g3sOaZkoHmg+xqytG7?=
 =?us-ascii?Q?H8MU/lJtu3WFvdGplcG5RYSj1HX+Bq4vtTFVwLnXTirGHfKvOLBYidYI+wie?=
 =?us-ascii?Q?AE62ZPGimN9sRQU0xYyXrkxq/JZJoy+WJ5QRVwcT9BXvLM0KFA2TNtEoJNs3?=
 =?us-ascii?Q?OelF2IvUWV5SkaUU6b0KdmQBcD4Gs4fWW7fjBQDJoC9qW3QzwQpsNAzaaatF?=
 =?us-ascii?Q?Md1GXosxgU5hLRPht+t0VKzzQugHvNVZcbE4dQUKPuCWIiYt2CIQZF/IsxB8?=
 =?us-ascii?Q?ZRE7CcGT/ttR+noAicD9h8juTEb1mHjb00bKjLYglKpzpxg+7ta0olhqQsAr?=
 =?us-ascii?Q?MkVljpIauOltCZIIwMv7gl7ZMZ7Dc20nG5OxoUF+0kJVPw/zVutSeLv9tQaQ?=
 =?us-ascii?Q?zKuUJYfmWB1GuX/RJMMzhnljwBQTLUhizAlEolfd/Fa4MS9TlKKHozeJVu6H?=
 =?us-ascii?Q?Edi0eeM3uG6/qhsSNv4kyoc8eDjR2QicG4NE6SKwMDk5OUqlg8JR6YIiZ9o2?=
 =?us-ascii?Q?f8Dg9O9IIw7cbxXdG1rEpp2GzWFORXSxCFa9Ik5d0FhMtwvqjr6BWctkBXGW?=
 =?us-ascii?Q?Gy6XI/GLmTzieFcJUT8LEEWewpXn/Yn/aJtGioBq3YfiO9POzEQuvJVUOcgT?=
 =?us-ascii?Q?BV4QOQP5tAV1WJNOpdsS0ikFRc92Tu+vygtDNz6GCyVZzeZXNV5WQfEzQPs6?=
 =?us-ascii?Q?ODCPQH3I7TeJWzs/VrrBtT4kEkkWBlaRO6k6zuXZF6RTL+Ew8Ob9o7Bekwxv?=
 =?us-ascii?Q?NeTsaEBM3g5FRXO5Yc37oMluI8APcXyOYX/WumAZDLXvAuTcxaAtp+7bIZqc?=
 =?us-ascii?Q?KVEYJZZWe7TYyTCmvhCXmWSlWYeTK4svlANZE0yhqolEbGtUZFMV+FwDFXYJ?=
 =?us-ascii?Q?VJRAhYgB0w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB5216.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a8c32f8-c032-418b-d854-08da372a80f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2022 10:54:51.7677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s4iGK2AYerSSZAh2o6CwSaQFJAmdyzIvhgEsVGGlu/4i2VjDBzDVaZBKstyOdIG74xLT/vDucBlDdfk1RkMDFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3162
X-Proofpoint-ORIG-GUID: 9EkLMu2O1dzLoNPMfsJyDgVsSWrqZOlH
X-Proofpoint-GUID: 9EkLMu2O1dzLoNPMfsJyDgVsSWrqZOlH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_06,2022-05-16_02,2022-02-23_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>You still claim this is tested? How can it work if you're not changing
>>.supported_coalesce_params? Do we have a bug in the core?
>[Suman] Added the flag.
>>
>>> +	/* Check and update coalesce status */
>>> +	if ((pfvf->flags & OTX2_FLAG_ADPTV_INT_COAL_ENABLED) =3D=3D
>>> +			OTX2_FLAG_ADPTV_INT_COAL_ENABLED) {
>>> +		priv_coalesce_status =3D 1;
>>> +		if (!ec->use_adaptive_rx_coalesce || !ec-
>>>use_adaptive_tx_coalesce)
>>> +			pfvf->flags &=3D ~OTX2_FLAG_ADPTV_INT_COAL_ENABLED;
>>> +	} else {
>>> +		priv_coalesce_status =3D 0;
>>> +		if (ec->use_adaptive_rx_coalesce || ec-
>>>use_adaptive_tx_coalesce)
>>> +			pfvf->flags |=3D OTX2_FLAG_ADPTV_INT_COAL_ENABLED;
>>> +	}
>>
>>Won't this flip-flop the flag? You should probably reject adaptive_rx
>>!=3D adaptive_tx.
>[Suman] The idea here is to enable/disable coalesce if either rx or tx
>status is enable/disable.
>If we enable only adaptive_rx then adaptive_tx will also get enabled as
>for this hardware both RX and TX are mapped to the same queue. We do not
>support separate setting for rx/tx coalesce for a net-device.
>>
>>>  		/* Re-enable interrupts */
>>>  		otx2_write64(pfvf, NIX_LF_CINTX_ENA_W1S(cq_poll->cint_idx),
>>> -			     BIT_ULL(0));
>>> +				BIT_ULL(0));
>>
>>Unrelated and possibly misalinged?
>[Suman] Yes, will fix in V2.
