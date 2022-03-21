Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0034E301D
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 19:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352240AbiCUSis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 14:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348322AbiCUSih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 14:38:37 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED99182AED
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 11:37:08 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22LEDtKs030817
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 11:37:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 mime-version; s=facebook; bh=JaCCt4Poc92YrBmfdvELGeaBxc+yZfLSMSc68oBw/j4=;
 b=IGHX489fjlz7jBAnm5+x7K1WGXThlKw4i5/4iGUyXGhz/00lBmWvYZU3MHwDD+fdEJL+
 TPaL02e/ew0UsBzlkFLUTme9g4dMjD7lvr2p/hHrBgOBiRdT3XujZ2OcCr2MmuLJAPKa
 alIQPG7kbfG5Jd5015mYY3+RmtIymRO0EQQ= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3extxgtdbx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 11:37:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bAJnC3EXFD1KYE141KMRC/cdjKm3yKLhFiNVPe1K2+ZCndW5pplV6J3IaV3nc9/J8fYIz/+D8Q3eQ4sItxS3jaWTvLoaNiXZfBDFAVJhuQek2k9H9qQgxvd1ci75MwzDW41jTk6qK1LpEZg04PiIaU/BdIaQEcAsYkj7+QAhJfB2nL4WOX3mBqxj0kd8xTECz18C38W9+KaIytfhdVXVFvuOhNNaz9VgozmkwMF+WBxnhGsCPfStOzfl3NSgXlI0X4LXPAp57JUqj9k2hDlD4qQmnQA98wEX0w+WKwxNf+o+jo/wJmw4ySnka9/XdFCSYlIlLsFOlZyM+zyxDS/ZxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JaCCt4Poc92YrBmfdvELGeaBxc+yZfLSMSc68oBw/j4=;
 b=fLEvlKQz5f4UTUpwtdTjhRy5cJgCr95H1j3xpaTZCB1cQ+DZO2q54LnayTEmd48SdEOkCO4Gw7WDpU080fQHfJ33Z6OWt+8TOcPmV2mrXZMCNEzUQaoXkwyK4B4/Cx5KXOjq/s3/+aP/pux75hy6PKQFijBmiPvLLGhz9B3eyCqXO4CcHzAd8RTnkpK/5jm2NqCNQQf8rS4HOv2tgOJQ6HJd79OtgK3sVgehMrRs0dens0WBucda7Xvt8gTR9+7xWA2k55ubqVP7fAx9BtOLXVHHGlM1QbWQRQERaKMeiuMs59EiYB7yCHNWlPasZL9uvixUGNy4KlfX8znZFxLIgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5137.namprd15.prod.outlook.com (2603:10b6:806:231::17)
 by BYAPR15MB2517.namprd15.prod.outlook.com (2603:10b6:a03:151::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.22; Mon, 21 Mar
 2022 18:37:05 +0000
Received: from SA1PR15MB5137.namprd15.prod.outlook.com
 ([fe80::3dfa:5b2b:a0ba:6013]) by SA1PR15MB5137.namprd15.prod.outlook.com
 ([fe80::3dfa:5b2b:a0ba:6013%5]) with mapi id 15.20.5061.028; Mon, 21 Mar 2022
 18:37:05 +0000
From:   Alexander Duyck <alexanderduyck@fb.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Possible to use both dev_mc_sync and __dev_mc_sync?
Thread-Topic: Possible to use both dev_mc_sync and __dev_mc_sync?
Thread-Index: AQHYPUE8MVfkK9Fj00ejhhCMSFHdfKzKJrgg
Date:   Mon, 21 Mar 2022 18:37:05 +0000
Message-ID: <SA1PR15MB513713A75488DB88C7222C2DBD169@SA1PR15MB5137.namprd15.prod.outlook.com>
References: <20220321163213.lrn5sk7m6grighbl@skbuf>
In-Reply-To: <20220321163213.lrn5sk7m6grighbl@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36d3d9ba-89e1-4b5f-e803-08da0b69cc5f
x-ms-traffictypediagnostic: BYAPR15MB2517:EE_
x-microsoft-antispam-prvs: <BYAPR15MB2517BADF4A3923C2D2BB7F50BD169@BYAPR15MB2517.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DUKDW3dZ9vd8nx52EZDTnf50CuibT84VRJy22kg9rU06BJjVloStoaSFq2bj+30OUJB6haKBT5w3i7mMy7cUq4GBL/OEik63ciNr4KU0P9eP03fBjiXz4oa/d+UNMC91IJGtTnHgqQzlgmzuAqpOtjsujd113KQFu/VumzjqudpeyCLoLFe54XaDouXRms9eHloz9rNNaIRlFy8D1/3YJYkyuZkfzPWV9pne719eq73gFW6nCJndC3406WdA0vQyo1+BHEG+afQNYlDS6etYtbaEJGduyo37+mPHX/acIXo54DqlEExECJuV92lT9tjFqxjwrH3WeW607YrmtvRaU/96gLnBsf3lJh3e4V2bKopHaVNB3EBCXtgPcxtml5+QrsT+wq7Nfv/t/dYPtxRpYCUBJn00WxpTojLXtpGjaOUw3U0qE05oNUOeJ8CA9zLNTsL9ToaBInOc47xt2sV43Y9NRBnEq/Y34O/Lf37RYq5uYKlFK6Pbm0DpHzqb2bgfo+uJYKasvxlrAm6KRxGkCdpDx443X0QNyiQ87euTsQAh1CpJWgpBEV12WJ7DisK+AiLOAJOjd9RfUdw3eKRB/Mx2QZMK06m81/574XqhBaqSntmBdMJcyaXecuk6Wok2rFGfI0u8YEYZpDg95iRMnANbwAQ9TUFysscmRCBjk0l65d7wB5F+Lfy7R+I9Zdv17+uHgsuRltpu6LV0VfzmPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5137.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(38100700002)(5660300002)(76116006)(8936002)(110136005)(52536014)(66946007)(66446008)(64756008)(66476007)(66556008)(4326008)(8676002)(2906002)(122000001)(55016003)(186003)(86362001)(33656002)(71200400001)(38070700005)(7696005)(6506007)(9686003)(53546011)(83380400001)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Zj+Cg4vZuiSqzEpTsho1Y+buqL/zlmGXvsmhd2MG9QA9TuvCZMy9tYJd9yn2?=
 =?us-ascii?Q?fq51EWOO5S+z0YH3VzwIXcLvhmgtQ7SmFcktj8r8f5QEVn0ymktqM6CizlOU?=
 =?us-ascii?Q?weOdBmiPDcHsKJ/3W9OUaMv3QtNlFrmjs2JbZNP+HkqLJoLzJT9JQe2YTpRw?=
 =?us-ascii?Q?JYw4yRJQaT/P0aXefK4Yi61N85uoGZLfDTZCtt5I2oiJ3xeoQrlDYSwt4rtm?=
 =?us-ascii?Q?yrhmgwsW/kUETplqhZw5hIcMtGCKmot//zfSEjRp7xLbObUYGd/UXfCSF6rf?=
 =?us-ascii?Q?0o330LSz2aEw+o7wPWv81W+oyvDTsf9LVIYGF3b+QAu6i07gQ2UlHpQQbtzR?=
 =?us-ascii?Q?095A4KGTckou7QjhmRL/J+UvYgB2YTZdI0WOYwIJwb4NfE9+7K8gAKFuCpWr?=
 =?us-ascii?Q?yydQicvsDSrTa/tOFbcT6RG2PjtN7TDC15hW1i2bWHOQ2PM8haJJxV5GHHre?=
 =?us-ascii?Q?B9+BY5czwcze+lyZD/bJJh2C9moJEDHzaTLL46dvUJVi8XnXMM0Dkg4wzFIA?=
 =?us-ascii?Q?5DmbQkZn/BqzkQrgz8yd+lMrGHkZPdtnPB7AuaIW4X1HiAJeG16rX2Kypx0j?=
 =?us-ascii?Q?WDLPeJ0GWvGW8W+HNy5YrTwGNtQScFHltwYniCk+X3TNNgPVQn9xcpGE6Myn?=
 =?us-ascii?Q?PutHxuRy/IPghzVtatHDVQpJkodz/zKgQVfKdru4XIP41loQ7blpiOpJ8wSU?=
 =?us-ascii?Q?27YUk4UZWC6HJRPh/ccPlIf1oKkhrj2gjSrl2uHjn9tvL98oQr2XngKRPT4u?=
 =?us-ascii?Q?8a5fn41AM7WtYR4eEOOYjDWy5X/icoUg+it6QFpMQ89KlxdbSaVevr4+3Ovq?=
 =?us-ascii?Q?R6sheanCKdh+bBX0ooXJmQBZQ5F97h/YZ0VPTRE5YVXghuBhjV7S6fIF7eh7?=
 =?us-ascii?Q?3vxBBfd/rx7dDWzALEZT7r2we3PLU8N4BHt91D2sk6kK1CAgy1WtPebztpc8?=
 =?us-ascii?Q?lsAZibN2G7b3QgTqL/RlcDUyn/+9NUc8OWV3EQbiSwUhnDhx9Uj/+3Pqd+z2?=
 =?us-ascii?Q?SBLCy+XrEmNr6ZO2Wcom8TBHSkUxSmbX6Lw2Sw36CPTyXBwU1FKKcrs+7o/f?=
 =?us-ascii?Q?nNM1D849enZa/lPkK2a0JmY362LAfP5XHROWEYcbIHew+T7QfRGNzXrWPqVk?=
 =?us-ascii?Q?1x2mTI4XyFSCJ0f8T8K3w5RGtx0Oe85T3VCDiJIeOhlvhulayBYM01zfanXH?=
 =?us-ascii?Q?giHzuKsJRakf8lAWezu2wECllhYw9UIOcz3rLMJaVmO7NMwlOUoJIwX8xuQi?=
 =?us-ascii?Q?N0X3N9aJnOSWzTNOM6vhfCqDq7h5y0WjAz9Ce5N/zJLU/tCwYf+ZuwIfcghh?=
 =?us-ascii?Q?6K/3BxOF9/E8NakPuMU0pcTdoRKGGxKmq3ASdCVcSRWTjcBVB+piJzbseRMJ?=
 =?us-ascii?Q?WEHOznr/IDB9MB5GBJia6njPmlkKw8Xo/VYgAtTgVQImAcv6ohhzn1JBm0Xr?=
 =?us-ascii?Q?wg/WG1D/r5ywgVDAE9fwULvDM/h8Uhh/kEOPQH6G82hPE6v63ItLgxRW17f6?=
 =?us-ascii?Q?dH9HUvAbvmvDcFHAveRqrY9nDO1feFUzUpMh?=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5137.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36d3d9ba-89e1-4b5f-e803-08da0b69cc5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2022 18:37:05.3718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g5kU2YVEgIOm9YWf51FavpQKgWb7F2XYsFMldEOaR+17b9BtWq139VVgaoAa7m5oOtnWPWyXjX8FK6ArAz178w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2517
X-Proofpoint-ORIG-GUID: VShjWa-Dl4yciw-1LxNIWhrusNwAJDza
X-Proofpoint-GUID: VShjWa-Dl4yciw-1LxNIWhrusNwAJDza
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_07,2022-03-21_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Vladimir Oltean <olteanv@gmail.com>
> Sent: Monday, March 21, 2022 9:32 AM
> To: Alexander Duyck <alexanderduyck@fb.com>; Jakub Kicinski
> <kuba@kernel.org>; Jiri Pirko <jiri@nvidia.com>; Florian Fainelli
> <f.fainelli@gmail.com>
> Cc: netdev@vger.kernel.org
> Subject: Possible to use both dev_mc_sync and __dev_mc_sync?
> 
> Hello,
> 
> Despite the similar names, the 2 functions above serve quite different
> purposes, and as it happens, DSA needs to use both of them, each for its
> own purpose.
> 
> static void dsa_slave_set_rx_mode(struct net_device *dev) {
> 	struct net_device *master = dsa_slave_to_master(dev);
> 	struct dsa_port *dp = dsa_slave_to_port(dev);
> 	struct dsa_switch *ds = dp->ds;
> 
> 	dev_mc_sync(master, dev); // DSA is a stacked device
> 	dev_uc_sync(master, dev);
> 	if (dsa_switch_supports_mc_filtering(ds))
> 		__dev_mc_sync(dev, dsa_slave_sync_mc,
> dsa_slave_unsync_mc); // DSA is also a hardware device
> 	if (dsa_switch_supports_uc_filtering(ds))
> 		__dev_uc_sync(dev, dsa_slave_sync_uc,
> dsa_slave_unsync_uc); }
> 
> What I'm noticing is that some addresses, for example 33:33:00:00:00:01
> (added by addrconf.c as in6addr_linklocal_allnodes) are synced to the master
> via dev_mc_sync(), but not to hardware by __dev_mc_sync().
> 
> Superficially, this is because dev_mc_sync() -> __hw_addr_sync_one() will
> increase ha->sync_cnt to a non-zero value. Then, when __dev_mc_sync()
> -> __hw_addr_sync_dev() checks ha->sync_cnt, it sees that it has been
> "already synced" (not really), so it doesn't call the "sync" method
> (dsa_slave_sync_mc) for this ha.
> 
> However I don't understand the deep reasons and I am confused by the
> members of struct netdev_hw_addr (synced vs sync_cnt vs refcount).
> I can't tell if this was supposed to work, given that "sync address to another
> device" is conceptually a different kind of sync than "sync address to
> hardware", so I'm a bit surprised that they share the same variables.
> 
> Any ideas?

I hadn't intended it to work this way. The expectation was that __dev_mc_sync would be used by hardware devices whereas dev_mc_sync was used by stacked devices such as vlan or macvlan.

Probably the easiest way to address it is to split things up so that you are using __dev_mc_sync if the switch supports mc filtering and have your dsa_slave_sync/unsync_mc call also push it down to the lower device, and then call dev_mc_sync after that so that if it hasn't already been pushed to the lower device it gets pushed. The assumption is that the lower device and the hardware would be synced in the same way. If we can't go that route we may have to look at implementing a different setup in terms of the reference counting such as what is done in __hw_addr_sync_multiple.
