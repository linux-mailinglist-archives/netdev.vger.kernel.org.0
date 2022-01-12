Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E12848CAE3
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356159AbiALSYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:24:12 -0500
Received: from mail-sn1anam02on2065.outbound.protection.outlook.com ([40.107.96.65]:31415
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1356156AbiALSYI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 13:24:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SGss5AzbmR1Kdqc+yM8256UKbYnSK1vJmeoK9tssKRwv97uYRQ7UwyV8QxcBntK9dC//NXutHbvERmcwgJ0CKpey22RN5pWinJ08uKvfzRncCSWZJ1TZLPNMgRpOnc4m+ReeXCbaU6crJlzeEP0XZYlyfOBd4iNpWx4HUbOaeVsMWKV44AA2j+u3YBB5QFpRrEBeHvDssu7G0cUwNMXghsTvriCl5Ea2f5pQYJnbAcNwNHNVXN7DXWE2sICtJ+phvfMRtAxVFuxxUsvivUooFaIPVBN4oZZNLt4WNr018vVPi36+o/chW/FuD5LuA70YISl8/hFmNtGWnAm7Uc4qaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tKBltEL3WmYDL2NteATNsm5tueyD355UOVUJm0S5rP0=;
 b=MhYZP3iAxGe/IJpniK6rIW8Xc7btQVlb12GgivpjkQYloaB/62i4xb7HzN4mqDNjaPHTFiQC1LCP03uGk4qvt17OMMUeMfeFMmExOamMZiAMJP2ANSCpSyR2ddEst3Pxr2lB3/sWshYxKwxjw4ru1Cdstp8GW6Eu416H63anNG0SUqNUMnC6Sh+vxNg8glS3G2CNqrjezKPwSuishOFMmErg4rheutFOrDOvDfaGzbK5tDEr2UYVHxr6S8XK/E8Jb5kMJ3GHd3ue1KmTIwVUG5CMiw35LGx7AJeauDEMuSDN0LwBdOOB2KpRD3QkgolXeRwrRUZ0Xgjh9Rl5bY/4bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKBltEL3WmYDL2NteATNsm5tueyD355UOVUJm0S5rP0=;
 b=RYeAlDDfzx72DJKMOucBX9xKKlq/agUKqWwnvMEtKVtObbziIibNkFGuZ6NdQ9RpWgvOzTXJeXmiShJYzwv7Dn4zjuOJGT069X8FEiDxnlOOUo4yRfMs/CD/UL6Sq9puhOEPcHdX82A/wU6+EDSoiyr6pwHtXH3X3x3QaGt6ocQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by CO1PR11MB5172.namprd11.prod.outlook.com (2603:10b6:303:95::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Wed, 12 Jan
 2022 18:24:06 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Wed, 12 Jan 2022
 18:24:06 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v9 08/24] wfx: add bus_sdio.c
Date:   Wed, 12 Jan 2022 19:23:59 +0100
Message-ID: <1655654.vHqhSpDN13@pc-42>
Organization: Silicon Labs
In-Reply-To: <20220112174848.db5osolurllpc7du@pali>
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com> <2680707.qJCEgCfB62@pc-42> <20220112174848.db5osolurllpc7du@pali>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: SN2PR01CA0064.prod.exchangelabs.com (2603:10b6:800::32) To
 PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 051097c2-d173-4ea5-b6e1-08d9d5f8b7b3
X-MS-TrafficTypeDiagnostic: CO1PR11MB5172:EE_
X-Microsoft-Antispam-PRVS: <CO1PR11MB5172FF1BE539C4C1E1E0FD9993529@CO1PR11MB5172.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RLmeHy17oNYSyI6uvkaolYQAyRHWefZ7DUGu6t8qzacIACz6U7ooFu+MqKbNDtfdLWYyyoQkn06Qqp6jUMAWlfeq5EXSOPgrJZAseLLIp9Yx8hXwfQgb0CphnyaMscVijbfmui0PHEQmR99N6NzbSzDdyHV9PgW6X01kAjmFyhscJaZWJ/LbVP3VvZFJbe7cEJt1Z/PIAtHXgZhDUH5IuLtHbHu/Y/ihXhkdyO5SvDs0zakTzl7+/DMLHDWGbcXcaxFPwAQLhgk01r+ELeLH60/p8mQgdXIP+Zq8kvcpsbcWfEnzLnMZPdDQYmNhDOFiQyS3YkpFYat8OE5xnNmqCHnZFGPibQmM3rCxPqjuEDEuRq/ENTMzID0Q0ls9EwMAXqjJXF6UYD+tFcB8EdTqxO6/AXQNO9M5oc46MXkNioN6wnY8cU7h7pAv5ZcA3CAteEZ1N4xQ/C+RzGwc3N5zxbFBF98tOtfYvSC6EKus8dVQHqujyQJB5eDGrSgj2/mSYxSzXevgNqeZoGCVZFpacWM+FKph/h6eDexqIm8Y6ubDiUeVu3Z/qEbZX0t1IAkf9d5K4GVGIEkOu+9XsIsPqcJpr53DDC5yXwj0jz+FXsXZPoHTCPmMthMSXhdrsIOBAvp7HrrCjYSedzI2HZgC1GokRFyuoxsRk7QQLTYcRnYN0wYqJiqE8WhKbi3urqNO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(6666004)(5660300002)(66556008)(66476007)(6916009)(33716001)(66946007)(4326008)(2906002)(52116002)(38100700002)(7416002)(8936002)(8676002)(508600001)(6512007)(9686003)(83380400001)(66574015)(86362001)(186003)(316002)(54906003)(6506007)(6486002)(36916002)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?cu9kwBcxxXHYt7506+JZAM2m/ldMQLLq9vlZ2OAhY2yQs/cU43cDGXjC7T?=
 =?iso-8859-1?Q?RGZgiE854SFwvimRXRVK24XQlt7Pd8mMTq7GOV7DgS0Jg2QQd67lGIhMRd?=
 =?iso-8859-1?Q?kUJEtu0xLTXWbkNgt1bE9qkMafz2jnuMsbtjzcSN+HS+pg6ao/5QxPA/EJ?=
 =?iso-8859-1?Q?nxjpQOmtpgDm6lTc3PqHmBDVUzML2rNucsxqSNi0QZYDbvxFIzV1qztj6y?=
 =?iso-8859-1?Q?wlIpTve7qTPQ/QltVqvIaFWuaS2U4vlF8b+gHlhX1thk/SCGxZALBkb+d9?=
 =?iso-8859-1?Q?yA3DKxMPnnmPmDt2VtGAooUHYYyykH8ED2JKq5tqAnMpNW4rPopLArA2h0?=
 =?iso-8859-1?Q?jG0z/WZRQ0TCsBaJjfT3f97Lgv5+0gTeb3QnjWiQrvBLcPllyOj18cKiE1?=
 =?iso-8859-1?Q?tdSSimdGyOBN+wyALdYdpotnNAvFUBrGwCY7uf3xqkUM5AYJcZY/fJ7GBd?=
 =?iso-8859-1?Q?fOImaVaA2bukCcu7UBPQrFO5iwx5kCYje19YkYUGBXH3xYQXPSDAP65zAW?=
 =?iso-8859-1?Q?WL/CHHsxBE6SnOErh0WJkBQbf/4MOnJgTIQalWLGNOkOhvbWazW3iIUddD?=
 =?iso-8859-1?Q?xkkCAwI03Eg63XgPtX9LeZC8Q7O2P0AqyhAlwSxgxo2WAt/PJLYwY4W2mi?=
 =?iso-8859-1?Q?nqT1hEK9KJjvd0mV9AP1/FnbVnYqLTtN6SliBLQCrgvYGuYudhCskxOLsH?=
 =?iso-8859-1?Q?08ld2yLILuBBo11kHk4+Mc47UFoNFg9LYuwKDsq99Tm4y09fiCTYixPLPW?=
 =?iso-8859-1?Q?0J3io4pcKaba7jAs/AFAh1W8/VwVLJMeDikbsu+jrNRFEe/GoiYFO78X6x?=
 =?iso-8859-1?Q?npbaHCgFS5oxoRjV8vADxKsD1LhFUZv6ANUAtSFFfuD9hThS7deDmkxY2l?=
 =?iso-8859-1?Q?Tfw2BxnzbnTQpjEWs9eWWxDDUxZ+n4nRbQlVYRzE20zpIUdmbz5RAnWQKC?=
 =?iso-8859-1?Q?ZBXW7MAFKbQCHACWJG+IJVORCCLMNDXdZA3JH6yoccXWChqhoR18ZPGw0T?=
 =?iso-8859-1?Q?FpDSbCFAq0zr6jHujqUIVcHwRX+y5GOPY0Qu6FpCfVivTXfnExDrhKtyAY?=
 =?iso-8859-1?Q?ZrXQnSZEV23OjhGcaWcVbm0GAUbzzbC5cUvhMsK9fCEV+5akBBhiDgpRan?=
 =?iso-8859-1?Q?Uo0rx9lYTnwo51YrpOAkgaagcAgmiNDtO7q0DXfOfBIGSqgnvc64PGhm/5?=
 =?iso-8859-1?Q?xzS+I5WOfpaZW6/MgIvt86Hm1TR4QNXfqfYkBiBOCPE0KON7qrGtVwnw8/?=
 =?iso-8859-1?Q?lOKW7Lpu2mjqaAMsLOGjEgyMbUL3cqiqEDAt1pazPFB+E3Vt00RQuZtlrR?=
 =?iso-8859-1?Q?qR3YNUuFiqtPfkS2s41IfpbjvVAtEuaiRs3MCiSEe4etxV0tcr/+3scoZX?=
 =?iso-8859-1?Q?EtUjVdtcqkpkw0XdX1HIacS7/desa/g1ic9uiw3KBBb/I3HUF2+NMDcsHH?=
 =?iso-8859-1?Q?4hvskXBE/NkvwLSUGkA/9uVacI8rZ2DVekpzIlDEKVGc/XkURLvTyFEUMV?=
 =?iso-8859-1?Q?2eNus0UZF9XzCr9AKAVaMqe+9njCst1fnuofkc6Tx4XvEung/sot9gb3oT?=
 =?iso-8859-1?Q?IOlygxnflXG5C8RINs6cJLnFrWlJeQ7zEJdMiraOZBbZ9s3mdLBngb/4N6?=
 =?iso-8859-1?Q?WNw8LpqXhycw8MTxugMZZnPJzx9xR6NNqWhlL7bou6jMyH6iI+jzZspwNW?=
 =?iso-8859-1?Q?tA+FZF+sc5haVTSWvuWEwEjNG67oMiQBIsGdRCkb9/hgMtB4R7DHGeHgyE?=
 =?iso-8859-1?Q?H+D7jciqEYAMChXO/sZwYjdTU=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 051097c2-d173-4ea5-b6e1-08d9d5f8b7b3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 18:24:06.3530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4vrYE6RV29z+ymdXcUXnISC+ifM5M6Hti14rcFGL9p3eyksrBF6+IRKUHtY2cwgKiEGKX7z6jx0SMhB2L7RQxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5172
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 12 January 2022 18:48:48 CET Pali Roh=E1r wrote:
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open attachments unless you recognize the sender and know the=
 content is safe.
>=20
>=20
> On Wednesday 12 January 2022 17:45:45 J=E9r=F4me Pouiller wrote:
> > On Wednesday 12 January 2022 12:43:32 CET Pali Roh=E1r wrote:
> > >
> > > On Wednesday 12 January 2022 12:18:58 J=E9r=F4me Pouiller wrote:
> > > > On Wednesday 12 January 2022 11:58:59 CET Pali Roh=E1r wrote:
> > > > > On Tuesday 11 January 2022 18:14:08 Jerome Pouiller wrote:
> > > > > > +static const struct sdio_device_id wfx_sdio_ids[] =3D {
> > > > > > +     { SDIO_DEVICE(SDIO_VENDOR_ID_SILABS, SDIO_DEVICE_ID_SILAB=
S_WF200) },
> > > > > > +     { },
> > > > > > +};
> > > > >
> > > > > Hello! Is this table still required?
> > > >
> > > > As far as I understand, if the driver does not provide an id_table,=
 the
> > > > probe function won't be never called (see sdio_match_device()).
> > > >
> > > > Since, we rely on the device tree, we could replace SDIO_VENDOR_ID_=
SILABS
> > > > and SDIO_DEVICE_ID_SILABS_WF200 by SDIO_ANY_ID. However, it does no=
t hurt
> > > > to add an extra filter here.
> > >
> > > Now when this particular id is not required, I'm thinking if it is st=
ill
> > > required and it is a good idea to define these SDIO_VENDOR_ID_SILABS
> > > macros into kernel include files. As it would mean that other broken
> > > SDIO devices could define these bogus numbers too... And having them =
in
> > > common kernel includes files can cause issues... e.g. other developer=
s
> > > could think that it is correct to use them as they are defined in com=
mon
> > > header files. But as these numbers are not reliable (other broken car=
ds
> > > may have same ids as wf200) and their usage may cause issues in futur=
e.
> >
> > In order to make SDIO_VENDOR_ID_SILABS less official, do you prefer to
> > define it in wfx/bus_sdio.c instead of mmc/sdio_ids.h?
> >
> > Or even not defined at all like:
> >
> >     static const struct sdio_device_id wfx_sdio_ids[] =3D {
> >          /* WF200 does not have official VID/PID */
> >          { SDIO_DEVICE(0x0000, 0x1000) },
> >          { },
> >     };
>=20
> This has advantage that it is explicitly visible that this device does
> not use any officially assigned ids.

Ulf, are you also agree?


--=20
J=E9r=F4me Pouiller


