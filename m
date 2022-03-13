Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9BA4D7726
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 18:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbiCMRNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 13:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235089AbiCMRNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 13:13:15 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94950139CDC
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 10:12:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFrZ4HZQaWR2jIjvCDWnMen5hZkBMDhzRTAfptqTzI29w4QHuOnRnVCl9jjoOz3c1FtH84r8/FY6JQ9+YwcTX0+PGa8o5PmJXUTa/8IZtJRpPTZn71wQHzxcoICf5MV8q/CxTjtwrWnw9m//saib5DO3PFs1nSiz1CWB7Ctgag99HOttnkh+ErC87hGn26TEu5damE4KlWnVqymSP9pEzwkIYdU8NLLdycj8YPzblYjEOEL43qy+lFXrvCLWYEgTtozJeTyLvEEERG67EN1jCQ37nrBKTWhwJ75/rdoVE6FuJx7zqB+rIcPN5+F9PQQPIFbwrHWl5WmTqH6oWUJxJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BejbB5xc+6wZcqoHa26shGkuE2xGhmX6K4CsVTtqIB8=;
 b=SUY5z9hQkEULkpQRqI8PUxqc2IdPRTqFCEL6KNmsgMCAe1DGG6zARbc5mtKlIhnBW8lA02l0PFMeiat3qCAO7DqmWAl+CkDIwm5IEfjtGjqUOZNlCByh7jsm4S56WvxW3frDtERvriW6U11e33FJdaXo2jFFRxKrXgEI0JsX1/S99dguHUE3mcT/iR3/biml2mLeu4bWjC1p/zqyulfuGucUI7mSKsaHfWRifJN9L8Z/VZGwAy8+elm92lEuk1Cp0Q2oMW6nNAEgkPA8TQnsRiNIYLJOcO1DmH/EhEUZwJlPrpLIKaamguD2eLlWi9LYo/ecv96CBul+nCLeYOZ/Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BejbB5xc+6wZcqoHa26shGkuE2xGhmX6K4CsVTtqIB8=;
 b=fbsoMsRYiITJug9V9qisyTTm8uwibASaRoRX5BhEFHBLOullxo8EFlkQD1Re6+h7jw7gTPYIJaErOFy39OnFk4k2Hr9eRpFkGQKae3BfPIpcy1/sXth9i5Dufl92vwyQhUHKdq9q+4p2JQl8jwC8soRKAULJSoDX5AsM4Yyzom57tgEX9pqd2jZJIUDKuqJFuLvaUJfJccKqMxxEXCWGryXjD1Y32h1zxCG4aPEZmbS36K5eFYtJi8O9uEkExFRY2kBpUolvuy6kYR50C9mpWDnfO1VwXGkkhzbBKERZB/D6c7JmsKhwrkeyv1o3ypFHQTf8YMa7OPqLggFnc+2wLQ==
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 MWHPR12MB1327.namprd12.prod.outlook.com (2603:10b6:300:11::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5061.24; Sun, 13 Mar 2022 17:12:05 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::c53a:18b3:d87f:f627]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::c53a:18b3:d87f:f627%6]) with mapi id 15.20.5061.026; Sun, 13 Mar 2022
 17:12:05 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "dsahern@kernel.org" <dsahern@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@nvidia.com>
Subject: RE: [PATCH v6 2/4] vdpa: Allow for printing negotiated features of a
 device
Thread-Topic: [PATCH v6 2/4] vdpa: Allow for printing negotiated features of a
 device
Thread-Index: AQHYNthoeklbw80p0EiqoLVCpxZ09Ky9ho0AgAAGfXA=
Date:   Sun, 13 Mar 2022 17:12:05 +0000
Message-ID: <DM8PR12MB540052FDD5D13E3DBCE55B51AB0E9@DM8PR12MB5400.namprd12.prod.outlook.com>
References: <20220313124629.297014-1-elic@nvidia.com>
        <20220313124629.297014-3-elic@nvidia.com>
 <20220313094810.3dd7aacd@hermes.local>
In-Reply-To: <20220313094810.3dd7aacd@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d56e5c38-b4d3-4cfc-b708-08da05149969
x-ms-traffictypediagnostic: MWHPR12MB1327:EE_
x-microsoft-antispam-prvs: <MWHPR12MB13272182A27F25C8DD6F0C0DAB0E9@MWHPR12MB1327.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hCccPhIJLywyWtodMsvvxWsbu4JtT0PxhhrkY5DRrEhpYNxI0YPkSG1uDpTRTnEzNDOFMKsLH4H1YU/PbekHNmAhXMCRTL9jbvs2Ak0IyKsam4PuCXqjTFgItqbO8V1G2H7Xc3HonNvW7qdFgJp0RcbD/67LtHlstMY7y7ljk20XUL3cM0wQC2BYzPf9USEx4nTciHJ6Vv3vxyBP7bNVaFxH5vHRJUaygcsMtBByoiuzvRdXXCnnA4kvkS9ho1RVfyOuXOx56eNV8MvuPjv4T660bu+UaLvM6q6B6he7FgSjq+F/c/sdFX3SvwAXcuBm+0QdJSmhCSvFIAmcyIWqnqDWba6LvqP3qOgA/3KrGfZ582ZPmHnN5V18Wdxw7KoIP4CIeKjey+IXeHH1grPAv1mNU2QU7B9Ort2TVltIOyKD81NB+fGdHfqvFg1Sg03iuOVGE3z/F31cpq6hSW8Kx+xmcLuB2Tjow+fgwMI5e7aaFzdCyvQMm9YPEpIymSUTbDo8JxgHTzysy+k82lDRGmUYXvMXqUcb54V6wdPFWf1NHq313Hw4Nw4HpYKJGf9dIUoV3UyfjxZIpvdE9tJP4nNU49KseLepfFOnuqnO/d2GwuKpvAAkELv2GmvVmTUUKdlRztT1qPda/E2AZyIN5YInxdeBbPI7eyOJJYyUW3wm/MIia/yBusVWiD11F5SQsjqycW3d2HkeKomXZ55rfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(86362001)(9686003)(6916009)(2906002)(8936002)(71200400001)(7696005)(122000001)(316002)(107886003)(33656002)(6506007)(558084003)(66946007)(76116006)(508600001)(83380400001)(4326008)(26005)(66476007)(64756008)(66446008)(66556008)(38100700002)(186003)(52536014)(55016003)(5660300002)(38070700005)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4HnMEBkNfNIfMXjXP2v7//Evhqon3gMEmDr7L6pysxMKGBSfLnQCjtU5wEHH?=
 =?us-ascii?Q?U32fhSnTUAj+WS0W4UunZZDDT5HJLcEX5xBsE08HypaPJjYQirlEEakwFYNG?=
 =?us-ascii?Q?Y/y3w0H4YfdPGGnS5SuMejDBEk1cT4cWsATgR5S5rFRtyp4w4SWw3FM0ZXD8?=
 =?us-ascii?Q?9t2jKUaqSZbdWqjoT4lPDvny1ULOPwt6eFb0E4RXYkynLH9pSXUSnvfaa6Sg?=
 =?us-ascii?Q?jY5pdcSqiIh2Q1rTZruu4Vr13or4xdcql+RUzD86Ov7alR8Oa6BzvQz4qdxT?=
 =?us-ascii?Q?d42s8KgoQSOZBIpEpyCm4RvEoLI6u/aj9n1pmVNCr+DkNq6wMNt8/teo6+1o?=
 =?us-ascii?Q?3azjRMT6cjoVS3XG9+OYqJhKaweQRUUuRMi5r5vEI21XBowvMzap5O0bN3xS?=
 =?us-ascii?Q?edzjZ7Lmd1BFXrVTJzDUxCFqov4E0bM8nuaaTnbP+8uR0KbbYdaD1Ja1TIvb?=
 =?us-ascii?Q?vhZp6q6GprAVABiq7C1y70KF4RxwXNCvQL87VN04heJib6xT8ZbOm8xoYCqI?=
 =?us-ascii?Q?UW7tQO/4lKaQkxK2/VA3wFYl/TAkGZELRtcbzrpsE8Pcbk22cHezLFfuOdsY?=
 =?us-ascii?Q?8z686t6tZWbSzbyZtruGU6UtrvuPpFxFWUje21lmzKunDfRSRvMnOdklJfv3?=
 =?us-ascii?Q?oCuxN33tB6RwsRu2QBfKIJR0IUiSSnvh3QzAUQtJHJ9iEs9EZKj1Abm68nCg?=
 =?us-ascii?Q?doGR7tfhoKUg2EyeTKro+dUYv81wQXvRxoxmzyijmJG4z2r0x8mHF4t0/ZkQ?=
 =?us-ascii?Q?B4vGHYRVmwJ3N9xCsGqSddXChSmlWGNsP7TcQ9hmd0fq3McKRKmKcAwRRhpF?=
 =?us-ascii?Q?iDEDayFJ3fQz4NtSpI1HxdGsed3eTPml3MRnsQB+IG1Tm926adU2qGY/ploe?=
 =?us-ascii?Q?cscnULx9r1/jLPfO0k/VBXmDA6ejhZiYtOKSqS8qXCuxJQ5FKilFfNOTe+OE?=
 =?us-ascii?Q?dbgrgvDvnpBVr0giYDT5Xvh5QTJF9sWgnL3lGwQsP7oFRKXqEOk2Y+Uh3++2?=
 =?us-ascii?Q?bF+PhpdiE06914lEFtu9ZOq78YxTCGb8YIKl9J35ugE1zGP10YAozokIy+MA?=
 =?us-ascii?Q?8O/Q9MpzIfXtucNWlHKfWXExOv2Fg0ziuDRYe1YY5Gh2vOtlKgplap/E/2a5?=
 =?us-ascii?Q?iZpmzObknF1Jx5r73LiiS3WOOUqRUUnWUdP8+KpED90KB8sZWlCfiJAyVikB?=
 =?us-ascii?Q?aZpe2hr2tYC+rW2DUJlGOMWcTmeNgjd6CIMBkuw9oblZz0me/+dHAJD5h++g?=
 =?us-ascii?Q?A9GIO9WUFRRg8IzTKz+qhimhRxr5C7LCaBEXnqhXQCojXJyd2VFN9ZOD1USe?=
 =?us-ascii?Q?HcUQoJahqPAW5eXgANRnJU5CydOFKOUxK49WCxDjSft0MS1IbSIUpynFf2a7?=
 =?us-ascii?Q?u+YAqAnOn5WM/M1a/ET2FhmsWkQC04KFdBUu+NBrMTpmXUYGG6kN4MDy0g/I?=
 =?us-ascii?Q?Lrn7Bia/PxU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d56e5c38-b4d3-4cfc-b708-08da05149969
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2022 17:12:05.6559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FrfJL1o47ac1Jj1X/c6F2hJhaBt0HEZPNoWlrGJTiH46v3ifUpK28UoV8HKfhjxo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1327
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=20
> checkpatch says:
>=20
> WARNING: braces {} are not necessary for any arm of this statement
> #280: FILE: vdpa/vdpa.c:466:
> +			if (feature_strs) {
> [...]
> +			} else {
> [...]
>=20

Sorry about this.=20
Sending v7.
