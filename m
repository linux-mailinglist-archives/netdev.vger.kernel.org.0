Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABD85298DE
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 06:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234909AbiEQEjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 00:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiEQEjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 00:39:20 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17793B293
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 21:39:18 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24H0BmP4027669;
        Mon, 16 May 2022 21:39:12 -0700
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2173.outbound.protection.outlook.com [104.47.73.173])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3g3rsqtxfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 21:39:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MgrHvWWhrI6CNQ5K4vpKkgimNGZ52lX7dnbQ3iXVc4Rcs/EsGpTuueU0Iyt+4zLLitTyeaJ2t7cUmX/zVW0lg8d1CsGcyqP9aptMR/YRyk07z+HKgje/keSMRmruE7HAWZzmV0ehy0uSISgGQtLLseMAfBXo/aAYycMCqT5b3ZKRO0NBZlWFIX7V/kNKXnznto8qQ8cL3v0jr9sOvg7qFso/k22oVtZm7yA10/w0E94cnNXURrvX3+RuA1UN4Y+g2q47vDbHh7vS2yIK7GBuwi6q6+XmzCmGINCd698s5XN/m8/DlzftELoEy1JQbTJWvzz8YRGJ1VaUYAknqXqWqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ArFRKycmjFv3Yve9cUKNbp1abBznszavSN9qPIBhG8Q=;
 b=LXzODmOQXpiO5ZWMs4fl+funuOjo75Lao0/+bT9DNfXDh73z3vZJFLGI2N2ff570lM6HzzLn3yCawaIa/4UQ70Xl/s1AfrmxfmyBX+y+Ol+exc1CArw2mVGyZw+4p09kd+vvnoggxksQOz26kvu2woiAFj/aASyY4MlACYurKAHBeFeBjlFkY5sArjXLAY9K/HRsBdnxrXogxbJ6gtUasbhquiSxCZ0Ttkb9kgwzaqGCuXuYouEpibvDxWWz2VtQddfVAEav97VmihRoDlWozBtZl8JQv585V8NDRo2wqqI+MUExquuCzJH+eGTVDGuNEzC6q6ZuQQqIew4TFUuZiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ArFRKycmjFv3Yve9cUKNbp1abBznszavSN9qPIBhG8Q=;
 b=djBY365PGCC/EnVTBKO0280TJiLXmNsiY48Q8e5ocsIo02EtyxmqhtFEm/a3CxVGbc/SM6mrWpfBA38hsptj/eETf3INlKmH/Znv0/TJQNTZGoTJDB9KEA39WDMii4KNaoetQKwVOzV9a+6+eCaaZhCVO8MfGmbKOu2PpQuQz8s=
Received: from SJ0PR18MB5216.namprd18.prod.outlook.com (2603:10b6:a03:41a::12)
 by BL0PR18MB2114.namprd18.prod.outlook.com (2603:10b6:207:49::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Tue, 17 May
 2022 04:39:09 +0000
Received: from SJ0PR18MB5216.namprd18.prod.outlook.com
 ([fe80::2459:114e:d9c6:efe8]) by SJ0PR18MB5216.namprd18.prod.outlook.com
 ([fe80::2459:114e:d9c6:efe8%7]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 04:39:09 +0000
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
Subject: RE: [EXT] Re: [net-next PATCH V2] octeontx2-pf: Add support for
 adaptive interrupt coalescing
Thread-Topic: [EXT] Re: [net-next PATCH V2] octeontx2-pf: Add support for
 adaptive interrupt coalescing
Thread-Index: AQHYaRNJ31mU8ERc90iDJW9vzPcRHa0h00WAgACqL4A=
Date:   Tue, 17 May 2022 04:39:08 +0000
Message-ID: <SJ0PR18MB52165D46518A63E214F4FBBFDBCE9@SJ0PR18MB5216.namprd18.prod.outlook.com>
References: <20220516105359.746919-1-sumang@marvell.com>
 <20220516112817.4f7d99cf@kernel.org>
In-Reply-To: <20220516112817.4f7d99cf@kernel.org>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6390d834-aa35-4867-59a2-08da37bf2ed6
x-ms-traffictypediagnostic: BL0PR18MB2114:EE_
x-microsoft-antispam-prvs: <BL0PR18MB21147BC375CA0B646E6A3A5BDBCE9@BL0PR18MB2114.namprd18.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TrWDIsA19Ovc9+wim0pROokBYXWDr2wfSncoLnl2FgHdxY2GtRyQzqz2ALmKhzlJ+1PNxIYXL/I8C2KnFaN5vcL3uqdTqnQEZJIP8OFnaE2FoOaJN3BavXIuE3GkhJzE1TqFI4U943Leeana0WoEe2RNJs77/ALyAPZ8CrDKXiCwAhbHHzZLPRY0xDGNDZOgzUzfWgZfG8d2sQfFlsamb5quK7KV4TANHGNtdgfwrjWDRMMaWZ0FoiijCTURzxIGkskrgNBizGaJ6zbOIK17sJHHiBThRvOnOjGL/swYyizj6FuQsurHHidxMZLlz6nBXjfA5f8ZLpxPrRqRo/X9pKS750vUY5/az+zN3okA1z5OOyDox/Tswqmpnnwo2XiHtNAn0nx5q1gE+YiuGidPpk8VKbeLeVzAYwQSqkptM48A47Z1MThKsqV//lOrHZRZYdJblo6hLfOnHaw3Xm9w2+qKVVJ+0zwPst0smBcd4cQOuZpuTQE8rFp6wqzootVhkkVg1ksGxwROXCqODGB9rbmyfgwC4M20pm71onFSRehs5CPsXDo/5pDL+Ju8vbIlYBlgvShq72w//r164M9j+EnlMdu8IU6qmGcEhXpfDGpeBpmwxTSEh+9xMHfS3Hrp2rpXrCpKTUYJXwDFjfcouzBH3/H630H9jojIhzWs/Jy+950ybXHFkJ8Z81KU7JTarBiZ6nzMAsb8FZlZQzMkQg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB5216.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66556008)(76116006)(66946007)(66446008)(8676002)(66476007)(6506007)(33656002)(71200400001)(26005)(6916009)(64756008)(54906003)(316002)(2906002)(9686003)(186003)(8936002)(83380400001)(55016003)(122000001)(52536014)(7696005)(5660300002)(86362001)(38070700005)(38100700002)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xzTp7FuCsCrXWuOFMM4HXsnBGhCXmEydcK3TJysfg+P3tGwZe1xgBjEF4KX5?=
 =?us-ascii?Q?Ql7sMin2y80H7o0+KyKW8od3AicJ8PQedujyczZl9cRa2i4c89dZJKhCXSHe?=
 =?us-ascii?Q?MEtyb+m43BfF7tXmj1FYhXEZmikWZr1CUapVRpWXXV08XNsziTCXYZqYF3dO?=
 =?us-ascii?Q?Io3e8BKToGt3UMxZJceI29RMChaefKEnNBJYniuBG07p8TT2sGPEOT2A5T1C?=
 =?us-ascii?Q?V3tihFAkbcXno4iGLJqd3jsAZieQn+akZJQ2jO2o+GnyouAOTPQ1g+GnCcRw?=
 =?us-ascii?Q?IeMsNHtt9Dk5japKvN3opxF6oo+KJzFHQ1JewqXIzARHQhPcPNamWJZM1/KV?=
 =?us-ascii?Q?B52t29220ZzDovlqX3hM2t9m8OX1aIiD77hIQwJq3PpZu/i5cSo9qCGjW/WY?=
 =?us-ascii?Q?bjKafLQ8K1Off8Y6Y0tz1RVZwVRw9hLBUCaelDQVPw4n0okwlbhuNn50NrfI?=
 =?us-ascii?Q?SUDnHmuTsuuFVonEmBti6SJzuVx/bx/odTMLQwHPHyfI8ac+LZIq4cERBJ8/?=
 =?us-ascii?Q?0pQ/cBQ1HPqtrduQbckMwFMgcmjZsxm62PVeHWSPRgJ8dR9tfxv9HX8jX10E?=
 =?us-ascii?Q?5WcfhHoTbF3AxXc1MywnotPO74ZFYJvd6OuYYxVrAHPw33c3ZLCWxdw+5+pc?=
 =?us-ascii?Q?HDO+79oLH+uxJRWCCQ4yoEzOx4mj1JJZ8covxm4JkJQuVrYG75cZaO/36o9w?=
 =?us-ascii?Q?HeVsNKd/mt5Dic2QdEhxJSFk4gbdeeNDkhKh0JIDf3eNKRX/JvPIr3ufsRLf?=
 =?us-ascii?Q?wcvI/HiV5D0gcTH2bJgeeKmIpSIgk1QASudmi5LavEN0XtJeeSnQwp8LUYoz?=
 =?us-ascii?Q?otoc+V8nVCOWiLlC+iT0vHUj3H3l3ogSLzJl6QEDHKaTXtkjFoijJ5V8gM0e?=
 =?us-ascii?Q?fKmiYoK2xq78RWMvIiCl6JgkCnKlnoOmzM7pyYoErVszvb7IGaMUeNQykrwv?=
 =?us-ascii?Q?4FUjvR/Q7BbiBUBgVH4mH8lTZUyZ9OydhRYRxMsRCbSb5FOtwPYOF7vlke1L?=
 =?us-ascii?Q?x8YW7yuCoJX/JVbAr5TD6nsKD89z7JFOaRiga7xEbowQbqx/Jx14LLX4IEyF?=
 =?us-ascii?Q?H2t7ReNsKG71Qcmeg9O+q1fp/ZiAzctwXb3vJ+f7niD9gRGOnMR3CvUlugbf?=
 =?us-ascii?Q?70kugM65eNPd09MRE6FU+PNPz2WTs3Gz8PRFneB5qnNepwIGfTgBUoK3TKfo?=
 =?us-ascii?Q?aUuUaj8PJhHJNltuHsl/cgFyesjaKxcGn/cBiHRjB1JZpXHzCrxleD1HkiCk?=
 =?us-ascii?Q?CgWiNJNmTiTbdRoITdDh6i4DO4DPPMZE0ULYs3oRxOf/HdcVkGjiNSfa1w5J?=
 =?us-ascii?Q?89viVUwxondlcKcBRphPg5sRtx2Qj+HAAxa3YhoW8ifDemBjD70glYO+mIVl?=
 =?us-ascii?Q?vr8zW3TrB+t/xYie0h5TBBQT+HcRIFl4IwlVs2hakEcJIS5ysTJxWkGr19ii?=
 =?us-ascii?Q?Zkh9Sjtvc2eNW3dWT2GWoup6yTt49TXhxRgcfbqY6u4kAeKC6rT0uYPznBmI?=
 =?us-ascii?Q?knIRPt1sh/8W3unf3SvBoYMhcsv7ugeKN0G+48x6l+v2NzI4FhC/PeFUK+8X?=
 =?us-ascii?Q?kfMEjbsKcyZ68iFy7Rd8sm+HOm/S2yc8KpwKnMPWg8fKHNDW3COswIDKq5Hm?=
 =?us-ascii?Q?BBzZBn5lGKIF0zj0t+LM9/iWBv55IE3tv4s2gmrEPZVGJTuNSJoaBKh1MRXY?=
 =?us-ascii?Q?qxG+eNoHips/I/kVdWMnQhCH9qLx82+SGgaEwr7H4vZMlIy+iGnAvDVhDYM+?=
 =?us-ascii?Q?7q29jznBxg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB5216.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6390d834-aa35-4867-59a2-08da37bf2ed6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2022 04:39:09.0271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YkDAQTED80q6woOhBw0uZdFUVy5qnQt4JiJvKkT/Kyib1DLpDccR9dJp1PZsGFfsmf0cnHy8d2g1TBOhngzk5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR18MB2114
X-Proofpoint-ORIG-GUID: q64jeMRIG-XOPNr1NtoKHODLVhvDFZAC
X-Proofpoint-GUID: q64jeMRIG-XOPNr1NtoKHODLVhvDFZAC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_01,2022-05-16_02,2022-02-23_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> @@ -1230,7 +1262,7 @@ static int otx2_set_link_ksettings(struct
>> net_device *netdev,
>>
>>  static const struct ethtool_ops otx2_ethtool_ops =3D {
>>  	.supported_coalesce_params =3D ETHTOOL_COALESCE_USECS |
>> -				     ETHTOOL_COALESCE_MAX_FRAMES,
>> +				     ETHTOOL_COALESCE_MAX_FRAMES |
>ETHTOOL_COALESCE_USE_ADAPTIVE,
>
>Ah there it is. Now you actually tested it with upstream :/
>
>Please wrap the line.
[Suman] Done.
>
>Also please reject user trying to set asymmetric adaptive mode since you
>don't seem to support it:
[Suman] Done
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
>
>If I'm reading this right user doing:
>
>ethtool -C eth0 adaptive-rx on adaptive-tx off
>
>multiple times will keep switching between adaptive and non-adaptive
>mode. This will be super confusing to automation which may assume
>configuration commands are idempotent.
[Suman] I see your point now. Updated the code to make sure adaptive-rx is =
same as adaptive-tx.
