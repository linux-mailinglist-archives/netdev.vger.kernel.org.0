Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 908F651B6EE
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 06:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242670AbiEEESF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 00:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiEEESD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 00:18:03 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4B71FA6B
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 21:14:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eGfXYtHc/LEb69/7FVmo1IPHU9nssIKgsTnq9EdN4JAipH0GuFbyB9iE83/Dzcn+huSNym62oIyoMPjIXxuqNL86fC8gVdYk2Fmy4d169ZO6UxgR5r+K4Dzm+a51LiXZ8xeb87Ta2Ls2aNKoW6qfinA827IeNkEG0DxGCteSMRGu+ayK7y65KQaIsRdAhTgfuQopazlf5VumR3qilZYgnF+YUtwkc20GaZfV9AFwebkEHR/L8jA135pPJc4ixmUkqYp1ZJ2fC8+xGSDr3SmK4hUiJXGzX+5pJgfxhIVudq+Lna8nJH+unvZ6HxCYw6pYOsMf5M1nr6or1/4Zicv29A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BVZfbleJzjDJojJ+RG7iOIrRrTXJaVFyAiNmTzXGezo=;
 b=L7MWLVwOBmgIli/F28V+kagSgmU9e6CLKDdEIatpvrzxKrjtN34/z7M4jdVH7TMe99oKCn4kIpdZbSp6/rwAFR7tWG4oM7ICX+3zzszRjohL6rJ4EIXfV5IDO5ih8dlczKVo4G0Z7vtolv+oAoigEFmj/3MmzmVkDB0JJQh0CGqUkC/A0lXl5y4vpMSI0rFYWajA6TMN/R3cbuwRVoW+aLnE2d+8v404s3Av96YXFFVAChtkQp+5qIPIwCfffs71B8QQcKRIcO7wc+LpZhAT4PlFaPrBGK3t0CMBDiRYMJzAvTiGl4scc0QTv3z7iuBdld6yCvpCF8BSBVYZ8qL2Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digitizethings.com; dmarc=pass action=none
 header.from=digitizethings.com; dkim=pass header.d=digitizethings.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=digitizethings.onmicrosoft.com; s=selector2-digitizethings-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BVZfbleJzjDJojJ+RG7iOIrRrTXJaVFyAiNmTzXGezo=;
 b=lrIxA7M+fjwtdoB4DWw9i3YlGRwbaAiwEpGTE6OjRy4c6ArxDPF3nBbmSTb75t8SD3jig9iKgnybHR6ymqfZGQSoG/F4m2WWX4L5BV74Lz5OdsLUyVoezlkFuRGh4a3ikC5Hz00tvJ2FhY/9NfkMChUQCaAKYTw05bRyuruYOqg=
Received: from DM5PR20MB2055.namprd20.prod.outlook.com (2603:10b6:4:ba::36) by
 BN8PR20MB2676.namprd20.prod.outlook.com (2603:10b6:408:87::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.27; Thu, 5 May 2022 04:14:24 +0000
Received: from DM5PR20MB2055.namprd20.prod.outlook.com
 ([fe80::29ed:556f:c7b6:3493]) by DM5PR20MB2055.namprd20.prod.outlook.com
 ([fe80::29ed:556f:c7b6:3493%5]) with mapi id 15.20.5206.025; Thu, 5 May 2022
 04:14:23 +0000
From:   "Magesh  M P" <magesh@digitizethings.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     David Ahern <dsahern@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: gateway field missing in netlink message
Thread-Topic: gateway field missing in netlink message
Thread-Index: AQHYX4JgQ9a90BuNG0u1i9lIsMx3tq0PTj0AgABUASSAAAU7gIAAA+Yr
Date:   Thu, 5 May 2022 04:14:23 +0000
Message-ID: <DM5PR20MB2055047ED655F3A102E83C50AEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
References: <DM5PR20MB2055102B86DB2C2E41682CE3AEC39@DM5PR20MB2055.namprd20.prod.outlook.com>
        <20220504223100.GA2968@u2004-local>
        <DM5PR20MB2055CCC42062AF5DB5827BAEAEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
 <20220504205023.5c0327ea@hermes.local>
In-Reply-To: <20220504205023.5c0327ea@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=digitizethings.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db047d37-a61f-4a20-620b-08da2e4dbc92
x-ms-traffictypediagnostic: BN8PR20MB2676:EE_
x-microsoft-antispam-prvs: <BN8PR20MB2676D579BD0D74460F17EC52AEC29@BN8PR20MB2676.namprd20.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wMDALCIoe1D4b6MpNQYYiUqwK9I0t2udcckuibHQSPohkbBVl5cwxOMXnSjfpfWxA7dnuSclttlmwfs75PwldaOsWvWnRehX/FqWpEi50AhRrRwA35Z+dlvPtxYBBYzAsn1piEXrKori9E5J4r9AXJRpxp1tO2riFfhuYJ7sS/s6yAo07Rrc+EQNu+MiMuTRB1q16RCSWRZ5BaurZRpxJW+gv+EIxCvMYR7WjIlhJTuHouyqJkkZuLpm4Gn8JomRnKLEPHkzJqDqwPonOn5DGNdlcBAVEJHbMg7IeHmr3jrczgRegMVp3QbEgvX+W3Vt8E7iLZrwrDp9SrCfx/d0GQOzfcQ0bpu8Aji67iNoMJ1y9vuvAftCHiAWitSso8mjFAOTkMc9LeofOLlaYoRNi2UJTx/G1/y0n2LbbXQD4dyTkmR/XRsXDCEnLSEehbQPC38U7rDsdqAVyAlqWIdweSo4pc6CCuCUTV3sMGKefthAc0jNV8zg2Z5WjmnKHnTs0OeFDxL5Ny4dLouk0kPNmOibxfcoN8upOd4+9y+cb0FZVmHFYY66cm+2zM/BGudKgb5cdwKsU/cjnIKa3Btbe6aACIyi7Di8uZBYqJlcboVDfQ2JQ8HQ8cGlJLwlVniT7/MzCSHEqANasyq6AHDzc1NR0hwSROCgAHbhu0n3Dql09yO+Cl/3l4DfcuFXMPpr1JDe3Jl9FGx27tNvC25R8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR20MB2055.namprd20.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(376002)(396003)(136003)(346002)(366004)(2906002)(9686003)(71200400001)(508600001)(26005)(15650500001)(38100700002)(38070700005)(66476007)(64756008)(66946007)(76116006)(66446008)(66556008)(122000001)(6916009)(8676002)(91956017)(4326008)(186003)(86362001)(54906003)(8936002)(33656002)(6506007)(5660300002)(55016003)(7696005)(52536014)(316002)(53546011)(83380400001)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?b67oDGZuhzeyyCI4X9WwEyVLZDJ141Et/SHum2vasUl8+VCnxARceVYO1l?=
 =?iso-8859-1?Q?626wNULqn7MiafXogmEkaM2XT1l8TBzjtViQOyFpjIgwPP+Mnzjpuzrb/s?=
 =?iso-8859-1?Q?gaxW1o4U+kloqUt62LhiVkVvBED0xuKR5us4rqhK94ilk1WHrB4TAsbKPs?=
 =?iso-8859-1?Q?VyQGnq/h1DTQXnZwy8yS+aPNl7RNAbqdRwoD0lVOicQjTGZtUemT/AxiJZ?=
 =?iso-8859-1?Q?DvvreK3miboYtvFjAS9eSPkIAUnVLFS0t6TqkRZshujh+KcDDAQa5uWlhE?=
 =?iso-8859-1?Q?setj7UyPtVwuPFV+1BFrFWzJuvC86uLTZlFwBlNoz506KdEWiDToZzYa+m?=
 =?iso-8859-1?Q?fm5CRae14gTw7zJlpjOS6xBNuyn+yov6h7CHf9XyeCwDQfU0lbk4kCQUZ/?=
 =?iso-8859-1?Q?ulvaxJaFdLhy8yVPbxQurY3GrzwwjBLY0U7C/wcl+PGErY8PC2wUtIG2c9?=
 =?iso-8859-1?Q?KC3lQMd2CxptBvZ+OtKsN5s08Qrmtn/DcDN94h7hSasrDZs4c7cvYGttfZ?=
 =?iso-8859-1?Q?5GJYv9ziqmH1gfjT9SkVQNys0UggrKl3/1KaHj4AT+KSCrJvpu6C7wmtzg?=
 =?iso-8859-1?Q?YZdt7WjeJwIWeE8lvNaLceKs92YOX1kJEa6qhBObmDMyzOySAp0ToU5P57?=
 =?iso-8859-1?Q?DLNnrZqZhjvw+Rz7nwghH5Wpc95ulr/hl2dGbzJQ/6T7K+kYzfiNSgo2Wo?=
 =?iso-8859-1?Q?AZxnABx7Lxhu+Pprl5UUW7s1sL9vTfCL3Y51PPD6cw6/ZGN1I0MP136D6S?=
 =?iso-8859-1?Q?nVo/NosFxsoKxlUruCrPKCSYObbq/Pjrp2v6S9AurhKxaf54/2CRgLnmaG?=
 =?iso-8859-1?Q?56s70iiLf5q3ozSrC6D3hanJbfr4PHkzwk9VRnP2zaZtyQOfuCZqNSwjte?=
 =?iso-8859-1?Q?yIcfPDLFtBtpMO3uucKoU8djZMPw/7/NnelKUFli5lcj0R5fuBcw0fk9uq?=
 =?iso-8859-1?Q?15UPIGguvEPRiJCfvveTgiyGoO31JaGf/T/i7mYu+hXJqBNc3U28qyN10F?=
 =?iso-8859-1?Q?nbeq3A4KVxhHX6l4PE4DaV8xRJlPXqs4lVCqSzZAFkeHi1CU+NuRhwIsGy?=
 =?iso-8859-1?Q?N26wNxijRxnR/kaJZs4dUQuBjfZBcVEPmohtpfPlZi+gUyAgNGiXud/89F?=
 =?iso-8859-1?Q?sF+vMo6jsRdha7cmgw7yPVJpGWD8UZxldM8CXpVICUb4DgcpOiuJXhkSLO?=
 =?iso-8859-1?Q?mlsfHafoSQuhf2DUw3Pf0NlRVmIoKrT0CYdh81gvD6ywUVYgXIo3Zoa8VQ?=
 =?iso-8859-1?Q?rUocJ/UT52+0LjmK+t74q28SGVSEkFdQNdaVIk/68ILz5kGYaGAsgdkFV5?=
 =?iso-8859-1?Q?sSzrhXtC5AYt1M3EIKNP/jCUpG5/U10rVYPS0ohtnVSfJ1qjV0tnprG1MQ?=
 =?iso-8859-1?Q?mtlp3iRtZd/+htQMxU7LoAV/kp2y3glHm59Q9d6T8411623FMQhJ2mkJ4d?=
 =?iso-8859-1?Q?NVhjj5T8XC1KXdihBEVz1SNg+IcDOgQZVPyy+bv/ksUMBrbv72Sn/IO9Y/?=
 =?iso-8859-1?Q?CRC5TF04aEjBztNBar8qzw2ZLpRJPZu792z80OClgaEx/6XqVU5AFZleTk?=
 =?iso-8859-1?Q?yyfb/0uZgNE2N+w8IIm/+obZ9xc1QbxPvVrSQaZJm+qIuXE0tou82/Cpso?=
 =?iso-8859-1?Q?CISHZd+IA3nHk4zka19msCw9nz/8jCZZeyAZY+fagHQz2wSv6VvSJPJKMi?=
 =?iso-8859-1?Q?XyWUbTsAUZMcZ0EKICZrQC2avBgUhssLOTuBJWurhYaYVTZNg3y8Zn+GVV?=
 =?iso-8859-1?Q?ArJSLkel+WEd3CrnFFLfk35fDAdIrsw+HhqE7Z+qFeVmG2JQ6Jer9ypNTj?=
 =?iso-8859-1?Q?FNK/zJmMWg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: digitizethings.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR20MB2055.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db047d37-a61f-4a20-620b-08da2e4dbc92
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2022 04:14:23.6790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 49c25098-0dfa-426d-808f-510d26537f85
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wdqHL9UqHplUkcRPa3zR30Lm0Pi0RVNiukPQnEJi1XNgSXjsLFPDEkrf1BecvLsCcXPGls2Q0krYQSVcEjdH0vLqg9BSAIg2gW52Slz0An4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR20MB2676
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=A0Hi Steve=0A=
=0A=
The netlink parser code is checking only for IPv4 messages=0A=
=A0=0A=
Sent from Mail for Windows=0A=
=A0=0A=
=0A=
From: Stephen Hemminger <stephen@networkplumber.org>=0A=
Sent: Thursday, May 5, 2022 9:20:23 AM=0A=
To: Magesh M P <magesh@digitizethings.com>=0A=
Cc: David Ahern <dsahern@kernel.org>; netdev@vger.kernel.org <netdev@vger.k=
ernel.org>=0A=
Subject: Re: gateway field missing in netlink message =0A=
=A0=0A=
On Thu, 5 May 2022 03:43:45 +0000=0A=
"Magesh=A0 M P" <magesh@digitizethings.com> wrote:=0A=
=0A=
> The librtnl/netns.c contains the parser code as below which parses the MU=
LTIPATH attribute. Could you please take a look at the code and see if anyt=
hing is wrong ?=0A=
=0A=
Also assuming byte order and assuming sizeof(unsigned int) =3D=3D sizeof(ui=
nt32_t) is likely=0A=
to lead you astray.=
