Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 222A24D776D
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 19:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235228AbiCMSFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 14:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbiCMSFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 14:05:30 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E0279384
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 11:04:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PYWLmnZZeg/rsdg/AfaLYEobsaNM0zuVjHbIKvgUcdIQK6eaeSraPO1Y2zFpbZqOec89rxlj/prNljJQREAmfQbU1GzBtSV0UaiJYEYi1SFSAw8DJIwhWyhcD7yXJzB2dVzlnKNfIf2IrSNM9yQ9Ef+Sh6Yd6Wzbo416bLkMwheD3OCZzK/A/yGM7sU+WwQrFwO/+UJqmoc5zue541E+yHMro6x/Qcc5MLIQo8MP5Vjzmh1CRPO46WlOukI4GQlMj1GoVXW0FlCqgkhcPfLzlbrJggZtW4U5eQGp1zMqwmfL07EUvXG7MSZjmhVKklLIzJGzXXlMmwXh7YdaflLwFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JEcId0xnUiITAfSc3LDU7dr+AwqEM4RRnLNHQeD+qtY=;
 b=laMCg6vZ+YmqvQts7wZVJLoFuE2j+bRA4662m+ZyRLIUm9XJ6rm5jfE3/cHcWI85fw0WdZhXOLGEOrJnqJj8ywYW4gsFPcXEEkWiHLR5to2KWkEyzbIb/YDXK8NgZrl6lO1NwqVrsHG/PRc4y1YENnqwCG0IGA2Frn2wwmqFkGY70j6GPAnQRKUz7fUswvWIVYFH8GqL/lPfFiofn/tgXKJd2ANkgtO4xO6gRUOlKYyvZE96s2JuA0vUKcynRVkZnn0KPkGrA4ovfMDOBLcDKBopvbkYHyeZtNIeaPnGZCDXdjlt5t9EawlLfTzqRt6fsodneMXV/eLwZrZRpXWbNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JEcId0xnUiITAfSc3LDU7dr+AwqEM4RRnLNHQeD+qtY=;
 b=YtmI98eJL3r8LGm0/+4fOfTptvsXYhfDwzp6iOB96DVBJ6S7sxtI0bYYzzixu1w/DFqT9Moaf9OsvuwXLg/yiAedPI7Y6KCTwaMY5DgzogKDb9XtMkN7rdI7JGFEtRPPQAxNx/HwVradDikzx0tHF6iomaUJM0Xi2nRrnyX8WFa6cxXmk6sGtc2t6gpeVL+tzQEvdxXFmYC/JSxD5SbitcbCEIvEXfyqHenx8tO6DHCMQDez3sn4Bc5WOwo+ty9yS1qKfCVNAbvAGBWcQmx/D2qQJB8/XquznjCIK72VeMwUFLsttxaDGpH47KJzj7xo8uQJx0mcAKgFOE7BvdMPyQ==
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 CH2PR12MB3703.namprd12.prod.outlook.com (2603:10b6:610:2d::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5061.26; Sun, 13 Mar 2022 18:04:19 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::c53a:18b3:d87f:f627]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::c53a:18b3:d87f:f627%6]) with mapi id 15.20.5061.026; Sun, 13 Mar 2022
 18:04:18 +0000
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
Subject: RE: [PATCH v7 2/4] vdpa: Allow for printing negotiated features of a
 device
Thread-Topic: [PATCH v7 2/4] vdpa: Allow for printing negotiated features of a
 device
Thread-Index: AQHYNv2IELmBUhoXUkSx7mD3Z/gSXKy9kwwAgAAIGFA=
Date:   Sun, 13 Mar 2022 18:04:18 +0000
Message-ID: <DM8PR12MB540017F40D7FB0DA12F7AB8DAB0E9@DM8PR12MB5400.namprd12.prod.outlook.com>
References: <20220313171219.305089-1-elic@nvidia.com>
        <20220313171219.305089-3-elic@nvidia.com>
 <20220313103356.2df9ac45@hermes.local>
In-Reply-To: <20220313103356.2df9ac45@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 895789a3-63ce-45d2-a52b-08da051be4f0
x-ms-traffictypediagnostic: CH2PR12MB3703:EE_
x-microsoft-antispam-prvs: <CH2PR12MB37034E721E2973EFABD09B59AB0E9@CH2PR12MB3703.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QaAFVtjScXMercO0rb/h62qPpdxc37nSWU6shvuxIYnD/Ia15UC19nRdiBFHifTQIuge0QdD9duAmRzvRTlrswnFHesIsUATyXkKbIbFB+vLVnGsEe042A5AZ5AnQH03WTLSkQvOF4wLU0xUsYoJ/9YobUnKqMBsSCSBWPveVn0TfPShCpDrKHZCMh67NFOcUrc5EjWXwnJn/di5n9lMt0HsZ8xmn/T7WclyTm+CeqfOkaUQCcjYFKlwKR0K6WgdUfAbDIeZVQYtJvMWjUhUuf1YQ6q1UWLfL9FPhKh8dnHw3TotunBqavzKFaHxA/1/WOUJ+gEuo1nTL2nDDQhsbPFBwtxY2KDI75BaMpatKVl45g2aRYvaqwj7Rlal6nkafKGvFBz6PpL+Fgm4GdSi8ixe57HyvO/6JNjYx9FazVsYbWD4IVRfYuBWzou+B4VlS3S7IyogyJMNWgrbD4b/wQSQVTWWzcTp7qy0qJndCAylCIT8UJu2gPeFn1RW9OHJxRK3amf/JIJAtpOBawsRg1sJXw/UgHni7UJJvD+YyV7BlHpbqEs1Vk6l8Y2rVjqTwDt/m+Ya3zhDJSZxRNoY0VEfwL2GkVs26SxYLAuoGrIFcqAo7EBMZfW9G0IcqcGUj5WmuAuFGxHLp4mpodr1Y+l+Og9nwHy/klH+g1nNoF/VtE92CQ2DQJh5Jucv9WVHExjGtZYPTthZCfk7R3ocug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(9686003)(316002)(122000001)(508600001)(54906003)(6916009)(86362001)(33656002)(66556008)(55016003)(76116006)(66946007)(66476007)(558084003)(4326008)(8676002)(64756008)(66446008)(38070700005)(6506007)(7696005)(71200400001)(38100700002)(2906002)(52536014)(186003)(107886003)(8936002)(26005)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Kc2yM7MSTOPHQEkGNKh2HCs3jrTvYcun6e3vQhHTJVvk4uG9CSQSl8ftHRAg?=
 =?us-ascii?Q?cq0ASBDAWu6r65Yx8K0SDA75+6ksnDWrbI/DcdIGfknXDoIBGS8CuDy3XvDn?=
 =?us-ascii?Q?OhMiPLB39PUaEOgY2R50us9DXPl7FHHbpHX5r5bCVUS2cvIsXz8vvtjEN5Wc?=
 =?us-ascii?Q?Su6ToebRapsK2PXj5sEO8fjXwPiPjVd9iTJmG0PtaAcIPVxe90FZd4PawOFo?=
 =?us-ascii?Q?KkozwlvqE6DmSm982PNWjRZBlr/leaLSbL9pPYJuZoY/0E3Rx2KZ6PtsEBoc?=
 =?us-ascii?Q?bfU6IWZlp2zGK6Tmoa7DxssddEQkL9SlD667dC1EYUiVYw212HnGkc/8wVn2?=
 =?us-ascii?Q?8rr7vIny3wauLr6+N1AsIuXiFdJAzaFU3Hu9xiL76owKDmfuNEM4jAM5yoLK?=
 =?us-ascii?Q?DhIXXYYgt7FRoiwT6yqJhwmcpO1uzZedzrFxxdeoQaSpKZKyC4Kp4g54rIkk?=
 =?us-ascii?Q?MM8ZxoggwgmgdToCBSZLhyBwVpYYR218Zkx//ZiJY7EGbRwOmxTkkuhy58+w?=
 =?us-ascii?Q?sP4dwqao+Zkr/mHrU7/CzBHNyBsidWk1FuVi7FFITPVtI00suYzGtJ7OBaWA?=
 =?us-ascii?Q?mURP8XXMSHnF/71vXgmkdKB7RoxslQl09yAzCXDLDswbfip5E/OZK8fJJ3wi?=
 =?us-ascii?Q?HgXCRUNeyUS+Rn3PJHvYGbVZx+ckvF4jx54bAJLUpPmmj40y5mqtyDlpOrW4?=
 =?us-ascii?Q?aPN1tJih43Wkd6e12cuWdvYyNAbSGAAPLT4JmsGnS3VEod5AsBXFW+trPj5R?=
 =?us-ascii?Q?yWpRkXID+OS67QexY3AsMYyzZR+xniJc/dUgFIrsPDyhw+KEsS8sGkZrUbKj?=
 =?us-ascii?Q?KL5aE5iQBPF/awAVjp052HDSPaiRea5G4HF/nJ//1vVTwAjQVRZVwNQOqQ/w?=
 =?us-ascii?Q?VMDEJtJpebE/LPDQSLVVc8Y8tu8fAKKLgJt1fw3go3yP0GOvE14htEwWD9ut?=
 =?us-ascii?Q?iJTQ2HRwExpizj57ZZV199m86CoZcg3jcC30oV2fcwbXIqqQCYstMN/Z2HdR?=
 =?us-ascii?Q?eCGO+DJ9NaXT7QJP4OYADbWrHqyasZX4jRQ/9/J6EzHrZXi6rim9KEVu4FcK?=
 =?us-ascii?Q?OeIWfXl3+UIcFk5h8afp1+64V2IeKirLVU3JlXI4jPcswLTIyLXYJlGSacq8?=
 =?us-ascii?Q?nFW11hzjieVvHR6K0bGU67Z+rFsXhadkdvYW3+i4yBbCNgKqskW8Ex+kF2lk?=
 =?us-ascii?Q?VtqMFPKQuZkk8nf9WjJbFgsfA3GdOlJQEnhDudC/lfiVSi0rm01rGe4qK2rq?=
 =?us-ascii?Q?D5hiq33jYbTqgJxVwYzsYKn7dDres8xqb19p1QMni2B+ubNfAGef/0QBIxyQ?=
 =?us-ascii?Q?LlhfgzbMkp5QhUNOS+5HcB8WdufeLE+LtDs5aUIjwuJ/oVpdXTHNLXJvmPnJ?=
 =?us-ascii?Q?2pQ4W3ayOVXRnou8jPqTO6n2/Q5CpHcx1VEapAd8sew8oTSIkxk5mg3S+ZjC?=
 =?us-ascii?Q?+oWc63d1nEM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 895789a3-63ce-45d2-a52b-08da051be4f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2022 18:04:18.8953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v4ftaBqI4XoKGwf6fNgd3ctdHJA7cz8Ow/mCtfzHyHmTAKgBr2AG0XoAgIdP1OZE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3703
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
> On Sun, 13 Mar 2022 19:12:17 +0200
> Eli Cohen <elic@nvidia.com> wrote:
>=20
> > +			if (feature_strs)
> > +				s =3D feature_strs[i];
> > +			else
> > +				s =3D NULL;
>=20
> You really don't like trigraphs?
> 			s =3D feature_strs ? feature_strs[i] : NULL;
> is more compact

If you insist I will send another version.
Let me know.
