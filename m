Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB2C556FAC
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 02:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359154AbiFWA63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 20:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiFWA6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 20:58:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCA119F81;
        Wed, 22 Jun 2022 17:58:24 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25MIt6Vo004680;
        Thu, 23 Jun 2022 00:58:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=nMQhN/qwkr5yox6HBxtZCeA0Y16uYYAMnaIb36v0bJA=;
 b=yyjDctafFRIwFnGIFuFqsXOYzZoEdOolME1KNqb4l8PpdVUpm+iLairu3LXuVIaqn8us
 bpcECZ8nBWEO1D38Q/bszwcbgLie5HjjyytBIJQfcmObKuXm7jD5DhysTky9+kZQzf0k
 Qc9F2HzTiFlFqFgH26zbv1NjN7H7pcDPBGEbPgbkQkCIy5FZCBue3m1kGNB7zkgDPEqt
 JZex5NZQ1hziwxGutS7g1KorB2ZTgYgAK3SBUcyj5jrrP9/LT9ZQUFn//zztbgyG21al
 QUd5+u7F4NwLJIp92IKFKRpBfMfLh7Q9kSo6WzM7j0FYK9RbcHEym0YAogby8VSJY59a wg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs54cssbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jun 2022 00:58:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25N0ofBC005220;
        Thu, 23 Jun 2022 00:58:18 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gtg3wxg6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jun 2022 00:58:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L29qgfX6JIPR6oC6/Pvm49kxSNYoTSqas1uz6fo3Y1Sd8SzasfyWaklwtAh2ORF58s2HYk9KSbmRiHGShXLaCY9rLCa8DyqqTy++BzZx1drjZjOZk93N6H2o2FKgnGfxMUsfHFN86FP7SsH/qBG1QKpxkMMBIFXJmJ8b6bsON5GNi8UJUPRb3qmg5d6MJN5Cw/kWKRuP1hOCfBm+eluz0Vw2w4BADdEQtNYg3VihMMpJ6vHTve0RKdH4cjmlPUTIdR7m6/gyBljwdVwLm4ZZxFddy1KDl7w6sLKsKQnf5eE7rJST3y66Eut8K9UcPrkqX4WLRYBvz78rvdH88ztE6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nMQhN/qwkr5yox6HBxtZCeA0Y16uYYAMnaIb36v0bJA=;
 b=Nlz1YXWX2H3WD14GHz/MJIPHPXjxXSH2imULLR55+1+L7lPqxRYjDV1CAGLlP2BeeIaguD1tAYLDfdNNfxL+ujstyXDRMQbT3EA4/1MZbquHgKPfpyj+XgjPvg+cK3rN2KTR2LtOi1Fq7LwC1F4vHTDTt6XV1sm+8HnE7k/kUuHjkY6cf6IFcQ9tI2tdx/PWHVYGqJ0CHTWrnBzQHlee3FO05WK/4tIdq53ZnefjzCUXK4r5pJSEXf/p9oRipPZaXCPpeLkOhP0T4bIZbqkCQhpRNq7qfv/RzJcR06dD7aKSVD7KrwCjoLFMt0vRnyAGyTD1pycW6LGegvLk07PwJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nMQhN/qwkr5yox6HBxtZCeA0Y16uYYAMnaIb36v0bJA=;
 b=d4Ihp+wP5qAi8pcqw9mHfx8oQGZY+/WLR+gfvgG9epfH94Dbe/y2XSiA7nT16BRX3uXm3Sobwh+Vu2zyeKoue2iSjPwgWWXF9XdW5LgoZ0RrRfmubH6+NnJKgau4Wkw9cAc4f+EszKFtnSRVcMp2IUNOTEBqk21M7/kPAMi21iE=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CH2PR10MB4118.namprd10.prod.outlook.com (2603:10b6:610:a4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Thu, 23 Jun
 2022 00:58:17 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::a022:c9:1cd6:8ef0]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::a022:c9:1cd6:8ef0%4]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 00:58:17 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, "tgraf@suug.ch" <tgraf@suug.ch>,
        Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH RFC 29/30] NFSD: Convert the filecache to use rhashtable
Thread-Topic: [PATCH RFC 29/30] NFSD: Convert the filecache to use rhashtable
Thread-Index: AQHYhkLHlIdZc73yTECQuJnTH2oZX61cJo8AgAAFjwA=
Date:   Thu, 23 Jun 2022 00:58:17 +0000
Message-ID: <1BB6647C-799E-463F-BF63-55B48450FF29@oracle.com>
References: <165590626293.75778.9843437418112335153.stgit@manet.1015granger.net>
 <165590735674.75778.2489188434203366753.stgit@manet.1015granger.net>
 <20220623003822.GF1098723@dread.disaster.area>
In-Reply-To: <20220623003822.GF1098723@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd62388a-8b71-4a17-578a-08da54b3755c
x-ms-traffictypediagnostic: CH2PR10MB4118:EE_
x-microsoft-antispam-prvs: <CH2PR10MB41186D7F9692B3C1D407235993B59@CH2PR10MB4118.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O6KFUIb1jqaH0dnMHPGhLrum7VS54i36UW2FtsrpptTfjRtBAa2p7VmXirYqZ+ireddjcX9hI19dNQoUdeoeXGTyG3M4Omj0zrdmKK1xY9ljGS/DORMUfG7tek9lyviUnvpmFKWPqihzOlCRmHiFMyDwmTCAXzNLupECWx2gUZ+fmO4RvRrKemPqBbPG9+RFpnoRSrJvVrJvFRlIdgRATR3FJxKlU/TsyHnVa2i72ykUC1HzQukTSGR4biqtdjh85OWAhEEGR9LAjVmtg9hOipEXquc3s52oOSXFb50P0UNPL0lwyCqiKONdSrX4ACMxxnmrZggxphoN0+nQ+WeGblyZG1LSC/nzDFcfw2x1S8P6LrofI7yAidItgHpTf/bKBea6JYk3m3LEdhilCy0MJWekl+r7GSI/DUuD5h/9sEzmPL11EBrfM+GfQpz4fxwr39AjFqx35hiEA0WiLeLTn2tAMQXdXlHZufTApRGybEKzGtmeqcA+TrmY92hznnMZAwfZe+nAEL8oN1k9WlUmdBPHd4jQqTHpBxGvIeNaM5XFkW+981o3tO7oW4RcEenS1Hkw5b9//zOAe75W8b3WQ4sZomfmgBdmL3M4oTkZ8HVnmMoka5sIZ5zzm8MPlP6R0g4GqGI2aHVshwFf5ANpTY5P1Tn2J2r6BMSHjAdhFcgKwqNe/PzTPkEuepC5fJp7jCigpPdC5YMh3fE2mdxwwx0IyOC940mQqDbTOFNVh0TuNQfyJogzfzfNZ0uHzwzKPAEV0uquYvJqqVnDGL/2u6wdKRmbvNbjLCSm4BWthL4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(366004)(39860400002)(136003)(376002)(5660300002)(33656002)(6486002)(6512007)(53546011)(8936002)(86362001)(478600001)(71200400001)(6506007)(122000001)(66476007)(38100700002)(54906003)(64756008)(2616005)(83380400001)(2906002)(66946007)(38070700005)(76116006)(91956017)(66446008)(36756003)(6916009)(41300700001)(186003)(66556008)(316002)(26005)(4326008)(8676002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iQYNrdlcb7FzKkcY6BV3Ms7USBU0aUA2kKeAO7+8i0JDxyIsiQ+wYr1JyfoZ?=
 =?us-ascii?Q?0jrFOqM0zBGLUIFtPuZZSuXDLU7QOUlJgZrf+Q0cmSJzNnSAIvrndUtRMT7U?=
 =?us-ascii?Q?yF+Cue/5MOPmwQn83m3Qo8gtTCyTOkDkmeaoCLa2FQN5YshSP6+d18ClPwOM?=
 =?us-ascii?Q?1/NQC/iyn/k4PcLGZyixSW9njBhLCxr2P6o8kxYxPgeAsi0sbT40+LV2mEb4?=
 =?us-ascii?Q?Gs8sLbnyi6f6PxE2VJv/zwiSi/4Yj1tOgJyHLxhB02+H2ph8FRdAb7xj8Dds?=
 =?us-ascii?Q?k2amGDN4pu2vIxNqnBOyj6y/OfA+Jjl6dxeBkIoCCf0SOP0veIPiiWng5JUl?=
 =?us-ascii?Q?imoswfubLOjdmTfsBIQH/G4eoIkOP6hZOQ6ZBRvh2Zl0vVRO8hjIGo8k/GSw?=
 =?us-ascii?Q?9ML3bLnGrnSOQI55zPLlZpAgxDBxxpM3h7SxMcGs6s2kiVBnD0tdjU0KDrEp?=
 =?us-ascii?Q?V+0y4kowV3OsqR56FzYpljB9MG1tar2lu0EZLzTB1TN7+Wde+JGkl69ePvAs?=
 =?us-ascii?Q?5H6SM+g5xMMOF14Qnoldb46eCy2VE0YofZd4MLzEntodGE9vGC3c+25uetxd?=
 =?us-ascii?Q?JtQVLvNqOwuJCevdD4livVau/FGuZW7857Z3hlsAmZnhroWYlCBl80d7/p5q?=
 =?us-ascii?Q?xEkaNmN/wS+E7Ziu2mampqtvHKdmjIXFMu8dCb/uVjdHdIgDGAQC8O9essWS?=
 =?us-ascii?Q?8ZslsWFO06o+7K0YZq73KM7pzGfl5zv8GvuYstHqqUeP2zPfY7aKQ4UAMpao?=
 =?us-ascii?Q?5FEmXhD7h9b7OwIAc5Xj5VN7figUXOsjqypOOLwhy2PMSRpKJsUKpBIk6373?=
 =?us-ascii?Q?AlXsNRKGXLsMCtOxa03FLxJ3rCLK1aU2GF2RycZeuywXBE9rJa/VnSdth8Rd?=
 =?us-ascii?Q?sR6W2fadei+f+3aqaUMoi/+3w8jT1iI69QtpUzr4SJS2JARxxc0kVpMdNac0?=
 =?us-ascii?Q?kfMlH1nHPHSLABJBElqRsuBUxamcAIPhgjbgLXtGSdKZSAj1CxflTKNjl+wp?=
 =?us-ascii?Q?kw7okDnBY/UY1WrGfzcSl0aqZYDUDSxZndrExne0QinMAinPHoGS//Mkmrzz?=
 =?us-ascii?Q?ICx6gQn57u+Oe+n1u0adD7KhkcwmV4A1ndh6rVTrT5zDZLg4C1sKCF+QAgjh?=
 =?us-ascii?Q?/9BpmAVeCjb8b+fRXUbNx1J+qiwDHdX5lIWmnCWzq3XUlFtzT/1LLzefocsa?=
 =?us-ascii?Q?MrlFHaAyNibCedAXP/n/Qzv11sBewjoNXaWJKNuOnrciEfqBJOeghFoDDGL+?=
 =?us-ascii?Q?ds3TAJdsO+2r6teFefgu532YxPAa64e8MVo230OfDXToirajgFcdX6x2Srbl?=
 =?us-ascii?Q?fd9LhWbK2p77wfTvZeDsduaKsc5xfczEXzZozqOTZ/piHzTqgVCCSRFJNXu+?=
 =?us-ascii?Q?pYYVixfcBSRElDYa56t98AC9c3NOmTe/H2e4PEA9MIfs5N/Wj8HdbGXnjiX8?=
 =?us-ascii?Q?wlwNmYUFzw1A7dlhAmy/2H4frVEvDVQgpgn1/xM+/+3DqbKhYHZNfSIZsc/C?=
 =?us-ascii?Q?s/08H7MPTSCb8ipJQfZG2/DWuqRAdbVznkcBzyBNDHSnfvaINQtzOMNzTGcN?=
 =?us-ascii?Q?2TqGyyAv1jbnmCuIyz6B2mDEKqsd56f6zsSyuT/QXnmANnlJ4fWF6lyCjyxY?=
 =?us-ascii?Q?vauguJshOmKAk4eMWuOyTeePZ3dC8oyE+1upgZkVfAXQ9CP7ipTIEeStQZLb?=
 =?us-ascii?Q?JfkFBHpVSJcYZFTIhCL4IlUZRV1gS4eUHO0qVpd+5f40Q26+KJ1oJkWpJSEM?=
 =?us-ascii?Q?r8Jp51NUs4LawrTqxXpJg7GbkfrN6yM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <543EA3397FD3534C87080B4220FF0D60@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd62388a-8b71-4a17-578a-08da54b3755c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2022 00:58:17.1055
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t7MzZ9jA6zZotvwrE2WwylzDyobOTSQkVD6xvF8bcHjwDNxUNRkTDJ5mDQOwka52fq+uT7AInVclgdxuUUsP0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4118
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-22_09:2022-06-22,2022-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206230001
X-Proofpoint-GUID: CPP5OYq3pv6d9vxG_GFKmO-nXk3NoNZf
X-Proofpoint-ORIG-GUID: CPP5OYq3pv6d9vxG_GFKmO-nXk3NoNZf
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 22, 2022, at 8:38 PM, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Wed, Jun 22, 2022 at 10:15:56AM -0400, Chuck Lever wrote:
>> Enable the filecache hash table to start small, then grow with the
>> workload. Smaller server deployments benefit because there should
>> be lower memory utilization. Larger server deployments should see
>> improved scaling with the number of open files.
>>=20
>> I know this is a big and messy patch, but there's no good way to
>> rip out and replace a data structure like this.
>>=20
>> Suggested-by: Jeff Layton <jlayton@kernel.org>
>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>=20
> Pretty sure I mentioned converting to rhashtable as well when we
> were talking about the pointer-chasing overhead of list and tree
> based indexing of large caches.  :)

Jeff's suggestion was right in the source code :-) but fair enough.
The idea was also discussed when the filecache code was changed to
use kzvalloc recently.

I appreciate your review and your advice!


>> +
>> +/*
>> + * Atomically insert a new nfsd_file item into nfsd_file_rhash_tbl.
>> + *
>> + * Return values:
>> + *   %NULL: @new was inserted successfully
>> + *   %A valid pointer: @new was not inserted, a matching item is return=
ed
>> + *   %ERR_PTR: an unexpected error occurred during insertion
>> + */
>> +static struct nfsd_file *nfsd_file_insert(struct nfsd_file *new)
>> +{
>> +	struct nfsd_file_lookup_key key =3D {
>> +		.type	=3D NFSD_FILE_KEY_FULL,
>> +		.inode	=3D new->nf_inode,
>> +		.need	=3D new->nf_flags,
>> +		.net	=3D new->nf_net,
>> +		.cred	=3D current_cred(),
>> +	};
>> +	struct nfsd_file *nf;
>> +
>> +	nf =3D rhashtable_lookup_get_insert_key(&nfsd_file_rhash_tbl,
>> +					      &key, &new->nf_rhash,
>> +					      nfsd_file_rhash_params);
>> +	if (!nf)
>> +		return nf;
>=20
> The insert can return an error (e.g. -ENOMEM) so need to check
> IS_ERR(nf) here as well.

That is likely the cause of the BUG that Wang just reported, as
that will send a ERR_PTR to nfsd_file_get(), which blows up when
it tries to defererence it.

I'll resend the series first thing tomorrow morning after some
more clean up and testing.


--
Chuck Lever



