Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1228550E783
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 19:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244060AbiDYRyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 13:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232240AbiDYRyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 13:54:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29063101D2C;
        Mon, 25 Apr 2022 10:51:34 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PFc0ri025371;
        Mon, 25 Apr 2022 17:51:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=0eIS7g0k0aUo2FgdLYwP1MgHB5wHgL/9UtfJtIvfsVE=;
 b=pVZyIXN8XVwL937mRceJPic5Cs8O3C7F9nRS+6YD0161CdAX5byrzBaiJfH4+G+Cqamr
 6dH2ViveYoqnxX8ynKZBgLxcU4yOtsZe1ITTcPmPiFUZJvH5e3ZuUfZRh/jPermrQunv
 tu97VC2irgtztJaM+wTC3DxdmljgYoV266nWmp27fz6Ez14JF79nKBmbwyBm9kOKdhli
 G6zQ5Wg/GPMMQXgbzIG8bVvKTrs3DzIhBHKzfnRB42BRdiWM1r9EOwvuqS7TGTTusQ/6
 wj7EH8t+yAHdHRH26GBH4VU+g6HbCl2RhiyjHbbZQAD7w5ZrkqI42Iu+rR8tKfj9XDjj Og== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb1mkyk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Apr 2022 17:51:20 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23PHoQlr006269;
        Mon, 25 Apr 2022 17:51:20 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fm7w1xujv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Apr 2022 17:51:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jmx+kjIn1NqWvD/6ovyYc9syPWk+7uScDa6aT9YkdxZUYkw3rwn96KQbwYuTks7EuaLRODaSR1sGYQJvWXciOGnZHQHj0wrpVxlK8nKa1eccrLKuTJ2SHuG073NAuRGwR2HdXpFx2HnAs8suyzoCBjPriwLdyYhBTVX66Ax+tHs8eREl9l9ITX93E6a7gOrYsiHfVKDUHcqo+MZFo/WPDG0y5k/Bofc7tkottuSFcifwqdo8QpovJHyizKxrXNhGcjcROfOt/cj/zlMMm+b7vtvtwU+dTPFL5UydHNMc8efdopuFdonUA6cOAHqK+hyzyoIIvDgHuBik7GZZPwWlyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0eIS7g0k0aUo2FgdLYwP1MgHB5wHgL/9UtfJtIvfsVE=;
 b=PH8OfjV77COcKR89GJ/qSDgqsnutDcf9Dwf6fDDQJ+G1Bhu1IvYqRvo+rqCUa2JGRO/oOeYnETO30+Go8hZNvVmxc9f0edEbTi8V09kzgIXLxWGBXppsazY/dEdjXwQsDxVWqlfp37BpZe92MZllxt+QixDW/9PkdMHkRXeytNHEf7KbrsE/DBKM01Oqal5/xMlwdzNFENTl5UUe1B3fLhCZ8WwQqlE7nEDYae9yBnwPpJZRvWob6skej8lLTDIxqNP00NYnalEtPL64j12qrWEiKMnSVGTwrHo3UxrypN/V996KiIyUYtFt8NUlAkm69W+aZSeMHb8ArTfG5j7J6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0eIS7g0k0aUo2FgdLYwP1MgHB5wHgL/9UtfJtIvfsVE=;
 b=rK5h5242ksAWAX/st5KlsmEG6rirJddnZUl86rtNX7wHp//0rV45S+YstcHfPkzbP5q9j/bTCz7b0MY4hrUx+AMVhj/ZxpaTgDGtPUoRCj8tzV17xVXFRVd7KrQS7AAWEC9y9eNzrcQo4cuSuBpnFLiXmsE/1NevRvpaTzRHOGM=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SA2PR10MB4809.namprd10.prod.outlook.com (2603:10b6:806:113::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 25 Apr
 2022 17:51:17 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f%7]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 17:51:17 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>, Hannes Reinecke <hare@suse.de>
CC:     netdev <netdev@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "ak@tempesta-tech.com" <ak@tempesta-tech.com>,
        "borisp@nvidia.com" <borisp@nvidia.com>,
        "simo@redhat.com" <simo@redhat.com>
Subject: Re: [PATCH RFC 2/5] tls: build proto after context has been
 initialized
Thread-Topic: [PATCH RFC 2/5] tls: build proto after context has been
 initialized
Thread-Index: AQHYU0RpxVnRY+Drn0ePT6rxyiRYi60A6HUAgAALIQA=
Date:   Mon, 25 Apr 2022 17:51:17 +0000
Message-ID: <FE0E7BFD-7BCC-49A8-BBB4-060D924D28A6@oracle.com>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
 <165030057652.5073.10364318727607743572.stgit@oracle-102.nfsv4.dev>
 <20220425101126.0efa9f51@kernel.org>
In-Reply-To: <20220425101126.0efa9f51@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a49f172-556d-4fb4-80ac-08da26e432f0
x-ms-traffictypediagnostic: SA2PR10MB4809:EE_
x-microsoft-antispam-prvs: <SA2PR10MB48092FF010B2B55C68641CD093F89@SA2PR10MB4809.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OQ7z8S57wR8JNTdIwErR0XSuu4ysYGcCqNNSK0F9OQ9IpIRWjC6y1IjSmsuAJ8dNBP+Fvycgd24m1T1NnYHXVFv2xbhKGn9j0XeLEnwv1/A6Yg1IFIZdPMx722JXkw/JX/EHexaOR7cmWFc/gMQi4nyHfw4hk5e4vZy0h3DPHPPRBbO8soCLL4G1n2mlAIAqmZ/AQA8+LFj/DAZm0AWqU8ElMHTokbYtF+GgI+qU7NTFbnfG1ZLdGEdwFoyhd2eceVYDAus3uuoRFYRO970oBOFH7aODoLfsWV3I7LNm/X8UIVS9yql8LbbpiYa0vbtIxqPc2936LUPA9L0PtE8yE52kFU88XXbBuq37EgKTi2X/hIl7fWlIBopFECYAAiCLT1A8gPEGpbMKy1DxKPtJLM6VwwR8V1SwKlieFnZzPvTah0WDtvf4pPCYNIV230gQBqq5RFc1GPXRPbgCX+S5U2pOBbEsmo3DBbqDyhvbJwtgEqz0sP78jQUDMHOtbmliST0N6U2Flw0n+KljMuvcmE/asRMSfHOKTZUpICCCBEi73cw//n227kKEENdEtCWrbZYlKHMsNW/P8UZwHY2+pm+Q1YZHDCcAIDmvhuFnTyizboNNOVcRy+xG1q5+GKy/1sGv25DR6PsLLd07OjMCXpEgDqWH1YMKXbrdCkkLeKzw6Rw4IF0FquNJ2gfMdKrOL0O5Oeb6MbkJLoDz975ogv4q+CYkLEW8nooql3+Y2me3AzxvmIDUPCSSfs9zLIsg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(122000001)(38100700002)(4744005)(66476007)(8676002)(66446008)(66556008)(110136005)(186003)(2616005)(54906003)(6486002)(508600001)(26005)(6512007)(71200400001)(38070700005)(316002)(8936002)(5660300002)(7416002)(53546011)(6506007)(64756008)(4326008)(83380400001)(76116006)(66946007)(91956017)(86362001)(36756003)(2906002)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pFI9rFRE+MIM+JLm7Tc7wlMKIe0HSizDwMbPFu323D8sjqPaGgHWs3OwWGs5?=
 =?us-ascii?Q?/onjOpaFRl0HEr0oUGqJD2egcdcxxME0pmfAAoIcmVwbVFdaBWoiqgRu39mk?=
 =?us-ascii?Q?aMwqlMmsKiX6RWcNgTJ0jerH64LGx/4yonbV3eIjUR7poLHT0M45u2r0G3eD?=
 =?us-ascii?Q?Jv04ckPtMfCUU8+7J/Z2sHZLyeVVPj882MeXU/0I7row6JtomJwYIbtP27Qh?=
 =?us-ascii?Q?BU1ddo5Pkfl6tr/kr9M4cJsrVrgKFmPFk0WLg9tyarNtAHnT0QBu8hiGAKKj?=
 =?us-ascii?Q?8D3EO90378LAgqpeG+NnBbnmlRFQxKWbWFYRh8SaG82X5g5EZNVa4S96sxuK?=
 =?us-ascii?Q?V3yF0paAbIL9e1HFh8aKPqLV5O6HPi0FH/yznnALePdjemzo7U6BS5n8OXzp?=
 =?us-ascii?Q?08m5UdExN8gu+0fl5dCNQeEHI8Xk9BDDziXWyPSlENmTwRFww0N5j2pXTsuf?=
 =?us-ascii?Q?vsDbrA7XmGinJdMlu50dGsE6NC9Iw5TErgBSynDNHrPP6MeoRI5dKsVkzAdn?=
 =?us-ascii?Q?HPeJ4tdG2O/mvXmT9WsA91VNktx05lmJktmVnRbgTgOlz/brlLDshz2c1WIw?=
 =?us-ascii?Q?qEDd2wTElb6CFDW7BnzG1TrA1KXUrb9BCkCikH074nGL96HbGTm8TpzF0e3z?=
 =?us-ascii?Q?7Gclnai/jn4itNE/gUUNPICWjnGYAdVUk38aZzTKQrJH1QWjZQwXxHhOBuY8?=
 =?us-ascii?Q?XMN0cFmxK4+72xRNEHdztEMYgv7rTKkW0OEsEVaxGjIgFqPAWwFhcblqg1/p?=
 =?us-ascii?Q?J7Nv7s8sRXoHSqGK5FOAyTQC3hrD/CpiSq8DpS0V6NHr9iqmt2h2fpceFaRZ?=
 =?us-ascii?Q?eOsBZp7sZ6GrJttpFjR1WT8Un4Fr74g1lD8Ojz4UJgvrkmBfmsD6JnXmlFRm?=
 =?us-ascii?Q?2FebbEx89xSGIJd8nIL/50cFRnMLNzDYfWFbIii/XrN84SKmuUBsHSZlKOpy?=
 =?us-ascii?Q?Mi8u9Ja5IIJZ813BpM1ybSwcJtMLRk6pYv8vUVDNSM+FAtiepIbMa8KrKhKe?=
 =?us-ascii?Q?Odd8GcMnPyyx0shBnsRVEoQ7rIQD94UgpGbMzxDDJC30KjImlEkyfbuS/Fuz?=
 =?us-ascii?Q?mFBQYplG+DCBoXiqzZA8GGlOVCzISVgo/xBEWs4ssHkJKiGC1AM1nNb9drOL?=
 =?us-ascii?Q?SPX0PXEkZUC0aIQgrktGDWjwDd3WYBO9Ffo/sUhT1ZocfQfvxKvAR7x8i8a9?=
 =?us-ascii?Q?hPCOPrFPkb2dS7PJ50jc+EBFrUm+sGHMXnBYdEpPLlG8t2UouHEyEdeMkr06?=
 =?us-ascii?Q?VKeB9BAjk/AbYmHmwNyfa4Kurvy1gjXUNwy3n+DAhrrfWzbr2ly1TI9Jb19Z?=
 =?us-ascii?Q?U3XCSke3ofE6WdB/mjpIRr+8HUocKiimmSKn5JGo4msuIM9k7NKimbwGCPi+?=
 =?us-ascii?Q?qld16R9CwGFCqIJScDFIB8CT6DBxiP7g6M5OKmwqh/SGQcY9B6+WN8iSSehK?=
 =?us-ascii?Q?COkcl4206q3noZEsjx/kH9qUD7WFVnP3TPmT3OM639R/wCJG+Zr+8P9+mLky?=
 =?us-ascii?Q?MRjUuD94G44NmpPT2m91XTSsjaOhCx3GHH3HV5CraPZdIzUseYD4KURUiLaG?=
 =?us-ascii?Q?dX+JejTMC7JkOtVbbJZbtExFz0QXDiqZcRqamQP3bxr6S4KeZlnVnW3cJwSA?=
 =?us-ascii?Q?N3cxvvNnvqlwdQQEu4+c9GgcUhCKgC015hiR7s5rOTRJQTSbs9tLktHKNQ5U?=
 =?us-ascii?Q?PxdHG5+3MVbptB0gim86mc+69vh81TuQNpu7Fh0+nvwkZzXBRZaV1wxc9X3m?=
 =?us-ascii?Q?bmKuHjRb0L1CUnxPJexW0yyViq5itvY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1EBEFAE9592B914D94F0781CE785ADEF@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a49f172-556d-4fb4-80ac-08da26e432f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2022 17:51:17.5211
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2XvTY+DFaHlrAg/bRjodmvDUkAZOOMW7dedVd0jUHxzKGp27NCki5Ki7RV+D5WTm94oKULFG26tDq+cQQQ/gWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4809
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-25_08:2022-04-25,2022-04-25 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 phishscore=0 bulkscore=0 mlxlogscore=893
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204250080
X-Proofpoint-GUID: xc5t3uxZsKILEZY_4nCh5dRGqcC4J10W
X-Proofpoint-ORIG-GUID: xc5t3uxZsKILEZY_4nCh5dRGqcC4J10W
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 25, 2022, at 1:11 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Mon, 18 Apr 2022 12:49:36 -0400 Chuck Lever wrote:
>> From: Hannes Reinecke <hare@suse.de>
>>=20
>> We have to build the proto ops only after the context has been
>> initialized, as otherwise we might crash when I/O is ongoing
>> during initialisation.
>=20
> Can you say more about the crash you see? protos are not used until=20
> at least one socket calls update_sk_prot().

Hannes reported the crash and supplied the fix. I didn't have a
problem with this patch series without this patch. Hannes?



--
Chuck Lever



