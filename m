Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990C6558C08
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 01:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiFWX74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 19:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiFWX7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 19:59:55 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F13A52E4A;
        Thu, 23 Jun 2022 16:59:54 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25NK9Ms6017778;
        Thu, 23 Jun 2022 23:59:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8XYsVvuiUskg9F/zvhhLgDtXIxSl+WytbdpUmAGgxW0=;
 b=PDO7yuhMf82kj+xAoWRWSqOxEK+nW8lFGXSqhZ3w+0DcHN3GTrpPDcpa5i7pQ550UZrp
 d3PWssOnPaU6HcWQOkTS9Jj6KtCGeN8kWHoBZ/UccKZrngyxmV8oEGBEqP3b73dIm68O
 gHgSy7dcL7g5FwigTpvgGt9Ot7uOD50gTn9QsNetDsJF2vI8L/Mmu/RGsQWljEBus7su
 c3r5Sa6viYa+H//zP/yskYyzkrmO6bmmP6gB9lPBap2pbabn/mnfM+e+5gqbLa1d0ESU
 ldImGhTiqLGNkpIvAlauXEfCs30qnQPTUQKdpElxQ8lT7Pg0QmK7AQgTRMiyLuRi3ssh fQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs5a0mjd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jun 2022 23:59:49 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25NNo56r010915;
        Thu, 23 Jun 2022 23:59:48 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gtkfx3wvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jun 2022 23:59:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tf4Y8fEz+qe8Im/K4grBGBIy/6NkcHi/9gvxzX34G1eDWF16QhdTGKFb95A9WYDcJg2XEhI3wq/S3VFyE2wwY5oQrg6yoF3M6iDSuXsaWegNxQkzofOBABTaoN8nhRhe+dOH7LbGmZNrXOlADqTnojgfICRyQlD6a9S+H5ux8p/sVpCL7iOtCpfnohDU0oRGQnUlDSLe+0xA+pNvQ0F/fhzjLLyELjt3rh1sCYys72wfmv2UYjbwbpLDxyssOEWulEn63631ilO+CXmJJc7jSVB02xTy5P+co1zc5Zd8FOevJWHBPxkZvlBz6yzLBbJnDknr1XGBJBmRWk6Wei6Usw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8XYsVvuiUskg9F/zvhhLgDtXIxSl+WytbdpUmAGgxW0=;
 b=SPyca3hRLTe2oki4F/g7okOO/8Vvv9s5J0fQFn20KU11Va6QnGhiBReYlUm9SaFEWDUyWe5gpnnMIcxmv6fePxOp7cAtQyfO1xRwCMuM0SJO0tC3x5KgQ/bNowHCp70yd0QMu1QfpA/RmuSv3XzRcUgufOcyVCX6n+57MWVISMGws4ObLOYT5siifq8EV2Rf1VUETzwEZTkK5mWJUUxL8avPZ5Rtch8fkNJVGJgUDU2+3Lx9IuyFWjX+vYwaR4KzwGmnrUkl9C6Ga66uLzp+s5j/9zR3mBLuZB3c4TqURDbnaPtGIaTi2kLyNNI14Zd4iTI9TAywUTRjH9a/ImKRGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XYsVvuiUskg9F/zvhhLgDtXIxSl+WytbdpUmAGgxW0=;
 b=jsJkfQPdVPN0nxJQDL/e7n4Haq7MvKstDqghUynPLcEdIOB4EPy8ouXw67fgKyRSwOwPOBMFxlmOPdxeZZaUZ5qrZ0WEvLf5IuYPeREuIGVzJM9XNuLXwwpKFtookHOeqxJad1Hwk9J1l6GogHIYdSXmS0smd3doMQbiXEDhOC0=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SA1PR10MB5887.namprd10.prod.outlook.com (2603:10b6:806:22b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Thu, 23 Jun
 2022 23:59:46 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::9920:1ac4:2d14:e703]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::9920:1ac4:2d14:e703%5]) with mapi id 15.20.5373.017; Thu, 23 Jun 2022
 23:59:45 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, "tgraf@suug.ch" <tgraf@suug.ch>,
        Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH RFC 29/30] NFSD: Convert the filecache to use rhashtable
Thread-Topic: [PATCH RFC 29/30] NFSD: Convert the filecache to use rhashtable
Thread-Index: AQHYhkLHlIdZc73yTECQuJnTH2oZX61cJo8AgAAFjwCAARRXgIAAVYAAgAAYJYA=
Date:   Thu, 23 Jun 2022 23:59:45 +0000
Message-ID: <EDD9404B-ACBA-4284-8AFC-8AB4536481A3@oracle.com>
References: <165590626293.75778.9843437418112335153.stgit@manet.1015granger.net>
 <165590735674.75778.2489188434203366753.stgit@manet.1015granger.net>
 <20220623003822.GF1098723@dread.disaster.area>
 <1BB6647C-799E-463F-BF63-55B48450FF29@oracle.com>
 <2F100B0A-04F2-496D-B59F-A90493D20439@oracle.com>
 <20220623223320.GG1098723@dread.disaster.area>
In-Reply-To: <20220623223320.GG1098723@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7999de92-39a5-49dd-6f22-08da557472dd
x-ms-traffictypediagnostic: SA1PR10MB5887:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kd8NSZFJkMoxMQqquMIG0h+o6m8gIYjKhU/uDZZGU3s0cMXNUvBoWZa2FMhrEe6lc7LQe3nW8jH9y+Fn9kweC4Jyy4Z0xVwaB4QrEuKKSM2Ly/c0b9MAafhjvrlVzRn+crVQ0XQ2VCGGD7MEbM+oksdKyILn/+qgwc/9Gu90Ph5tctraDbv/YHttbPeDUpUaDq+khPZMvpky6iGKzcBqJP4S3ykktf3lMHY7ioqQJELm5z4FC2v+mhIBwTeI3ySWQHhTYHVTgVqqYecOhxFQJfVdkIKItKAxiG33qwBcI6kGqc/g8rfFvpdfFAcC0/atm4aE4PqMj95xNl9rMCfCq7dkHybnHjTFQc4f4urvJaCwLv7mXh99QwrztQINJ50qPzgqin5p8qkJ7eUlrQX9V3DpmH1L1UIJZMBWxjiXqyDGXamhI+nrq0cIIlm+hJL/ndI5wKtSU+ro18loLnwtv8p00C1pSCeX0W2xuFF3oUq7PYXP8+tcF3WCd8oCy6CQXkchcnQtsgVcXZCWwf7v2XvG5GLqKLiBVnLMgr62vYhwa3Y5oNZCvKJAs/c9uevV+hdL+WjufFUAtrefmixrvuauZOiEg0//P6PNcrokMtP+v9SCdxylLkwcRnLIlt5MUAme1U7XSaIdodkUUuT8FGR2nVW4nXglcflA9cfetGH0zqbPpyy6yLuO/o2gWshGAmVJpYl/rYlyliEU9eq/zuo+IL6fG8lXTvXcj6Sc/R1Cp9dnmFilVqTBRsnZc7X2jY7PDkmMfgOnEcLvlXNLxfy+CL3fU681an95qiDHpIO/eRUcbiFawxF20qR4sGiAHOD7N4qlqvzto7q7hORwrWsCZq6tlvZj/dAiGnsF7VE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(39860400002)(136003)(346002)(366004)(2616005)(83380400001)(122000001)(186003)(38070700005)(38100700002)(5660300002)(8936002)(66946007)(71200400001)(66476007)(53546011)(6486002)(2906002)(6506007)(478600001)(41300700001)(54906003)(26005)(6512007)(316002)(4326008)(33656002)(64756008)(66556008)(76116006)(91956017)(8676002)(66446008)(36756003)(86362001)(966005)(6916009)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXdqRVkxSXVBajg2NGRwVGV1R0RRWmJnR3J2MjJveENLOWM2eURrbVducnE3?=
 =?utf-8?B?L3l3MDJyZitGekNvdjZ5U3dpSmhOdlNqcVpXeWNzNmkwcUlROWxMdHFhcWc0?=
 =?utf-8?B?TDVETmNWT2NmQkNob2NkRWZJZlJJWUFBWGxXVzVuUC83Q1prQlBLRC9uK1hq?=
 =?utf-8?B?OFlVcFVlVk0yMEMyZHNUWDcybDJMZzZ0OEhNMElXOGp5elBEZVNJbjBjQTVt?=
 =?utf-8?B?U29kM3NOVDZNYTU1RmRXak95VXpMVk9hRmN0VHlFYzlLWXFTUklVbXdkazFk?=
 =?utf-8?B?NTlBcldWTnF5L0lGSTZXeU5abTU4SFphVFNLTkhOL0pEckwyV2YvakllNHNo?=
 =?utf-8?B?N3ppdjliS2JRdHlRWGVSV3duMUIvVDZEbGJYVEdDSmdFZGJQOXFDVU9QNmVE?=
 =?utf-8?B?Y0xjbWhQZE9yWWo1eHk2KzI4UjFMbGtPNUZlbzZ5NUhMV3BtOTgvUTNrWnNm?=
 =?utf-8?B?R2ZEMi90NUU1QUxzaFdBV2M4SHdhbU9GM0xvWVlqTDNSVTZwQ2lveHVyelky?=
 =?utf-8?B?ak5XMloxcEJ3dk1pU0Y5VlU3TUFjMG9uN0F2b3RNS09MQ295Y0VNcjJvdytL?=
 =?utf-8?B?aXp3UC82RkpYTWREQ2cwVWRBNXkrZUtxQnNzWDQ3NkxWWVAwWVJ4bGF4QXB6?=
 =?utf-8?B?WHY1bEg4T1NLdTBCUWRaSTl2d3AzTWIvR1BxY25RTzUrYTJPZGxUSXEvM1BU?=
 =?utf-8?B?YVplQld0bTdJcGdrcnJMT1g5WmtLQlB6TjdYYmFna0lDRk1nSDJHVHZwYVlK?=
 =?utf-8?B?Y0MyQ2I0K1lXZ3AwVFFWS1RkSzFpQ2M5ZURxQ3g1RkN2d2pNdjdmZ3NTbnNH?=
 =?utf-8?B?WnZVOU1odWJXNTFSVDhtODFIL0Z4Yks2UFVMQjZna3JWcU5hK1E5QjZENUMw?=
 =?utf-8?B?N3FFaE1VTUNOakV4VmtwTWwwQ2ZGR0xPV3kycUtJbi9McjE5bWRWUHcvQ2dD?=
 =?utf-8?B?YlFwRnRnbVNka0RhZjZBR3dpbk13WjQzU0tQSEFOdno3c09HVEYrcm1VSFR2?=
 =?utf-8?B?VlpNQ25uTGtCV3BuNUFRVnRCQ1dsd0tvUmw2QXRKNkV4Ky82dTduSGNmdGty?=
 =?utf-8?B?NGdkZm8rZi9JMkE0eVFkaEVSWW5pL0tlcVhtcUw5RFZ2SGpLeWZrcW0vSnlJ?=
 =?utf-8?B?cG5yM016UVNkN0RMbHkzMEhGbGI3Q3RKZ0RqTVVEcWs3OU1lOXNwblRwRVJX?=
 =?utf-8?B?U0xTR1pPK2loT1JGYitseUJsUnlRVUNFVXNJM01DTndya1ZqS3JwaFc4Unlv?=
 =?utf-8?B?bUo4dWduNTRkMnF2VXR3YmhidkdPQS9oVkl3NnJMNmZiWjF1RDFWYlBGTDNy?=
 =?utf-8?B?R3gwNXpuY2hydGFIOUtUakc1YmcrbFFxSUsxaWdFTGVtdDNzZmFLaGRjaGhk?=
 =?utf-8?B?TjI3Z2U4UHhQYjl3eXh4dUNybjRpTmNyTStseUZLN1JrZ1VXb3VabWprb0Z0?=
 =?utf-8?B?TTlnaXNLL3R5RzdRMXdQMU5YbEd4eEJDRUdGelZNcFo3S2FuY1htOGVUME90?=
 =?utf-8?B?QjRzWEtNSzlDOVpIOE0xMDdyUmhBNlNKWVNGZTFaN1BwWnlqekFSZStuVjJ3?=
 =?utf-8?B?UWRKOTZKdEQwTDJtdDNCUXdaZGZQMjRMaUEzc0ppZkRRb0tTU1FXMjY0NzUx?=
 =?utf-8?B?Ky96V3VUS3ZYMjAwaUpMdzA2QkpHb0JLM2xtQXJWS3BYZkJQMVc1R3V3TUk4?=
 =?utf-8?B?ZjJ2ZnBSWU84bG1nQjQ4Ymc5TzAvYTVOOGk4R0xCeEQ3QVo2WWNVeVp6VmRK?=
 =?utf-8?B?VXprci9SWFZPK2h3SzlhU0NHMWEwQzZtaXE5OTV3Z2xZbU00WGdUYi9HR3hs?=
 =?utf-8?B?ZkFadkRGc3JHWnoxRFVwYWgvQ0hyOW9RVVFIZXd5UUtLOEg2NmQxRGYyY3d6?=
 =?utf-8?B?Y0lkYm9PNURuaENwYWp0Nk4wSEgwcHF3VHVYYWhsWjcrb2JlMFVMNjJyV0pw?=
 =?utf-8?B?bEhvZDMzUmUwWHdZUXJJZU9SOUhBRmpKQ3ZHd2RraHlDYjc4b0I5cU9vcmJO?=
 =?utf-8?B?MElsbjBXaURmcjg1emsrOGxZeHBYTTI0U2ZOSWdDN3cvdktlWlg1MTZHZWpS?=
 =?utf-8?B?VTNkMnpaYW5ENUtzY1NQYlVVS2JpdTJxT3hocVMrWHBiaE9aR2w1cVZVMFZV?=
 =?utf-8?B?U3JZWG1nTUl1NFhMbGRldksva2o5Q0F1WEtrNEVPZG5pSi84K1ZVZTdxV1JZ?=
 =?utf-8?B?R1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <45CEE7268B24974DB078328BCB55A0D0@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7999de92-39a5-49dd-6f22-08da557472dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2022 23:59:45.7872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VsVtlwNEGhdmyvHQDUMeRmV2iSzuySNJKMBqkaQ/NB9cUKzVA41laWS/fWZPTlUOAF73yGZ0BFvpKJ4fDuTtzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5887
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-23_11:2022-06-23,2022-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=989 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206230092
X-Proofpoint-ORIG-GUID: mL_WTY_N20gBiniBjc6TQujgL4mXz797
X-Proofpoint-GUID: mL_WTY_N20gBiniBjc6TQujgL4mXz797
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gSnVuIDIzLCAyMDIyLCBhdCA2OjMzIFBNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZy
b21vcmJpdC5jb20+IHdyb3RlOg0KPiANCj4gT24gVGh1LCBKdW4gMjMsIDIwMjIgYXQgMDU6Mjc6
MjBQTSArMDAwMCwgQ2h1Y2sgTGV2ZXIgSUlJIHdyb3RlOg0KPj4gQWxzbyBJIGp1c3QgZm91bmQg
TmVpbCdzIG5pY2Ugcmhhc2h0YWJsZSBleHBsYWluZXI6DQo+PiANCj4+ICAgaHR0cHM6Ly9sd24u
bmV0L0FydGljbGVzLzc1MTM3NC8NCj4+IA0KPj4gV2hlcmUgaGUgd3JpdGVzIHRoYXQ6DQo+PiAN
Cj4+PiBTb21ldGltZXMgeW91IG1pZ2h0IHdhbnQgYSBoYXNoIHRhYmxlIHRvIHBvdGVudGlhbGx5
IGNvbnRhaW4NCj4+PiBtdWx0aXBsZSBvYmplY3RzIGZvciBhbnkgZ2l2ZW4ga2V5LiBJbiB0aGF0
IGNhc2UgeW91IGNhbiB1c2UNCj4+PiAicmhsdGFibGVzIiDigJQgcmhhc2h0YWJsZXMgd2l0aCBs
aXN0cyBvZiBvYmplY3RzLg0KPj4gDQo+PiBJIGJlbGlldmUgdGhhdCBpcyB0aGUgY2FzZSBmb3Ig
dGhlIGZpbGVjYWNoZS4gVGhlIGhhc2ggdmFsdWUgaXMNCj4+IGNvbXB1dGVkIGJhc2VkIG9uIHRo
ZSBpbm9kZSBwb2ludGVyLCBhbmQgdGhlcmVmb3JlIHRoZXJlIGNhbiBiZSBtb3JlDQo+PiB0aGFu
IG9uZSBuZnNkX2ZpbGUgb2JqZWN0IGZvciBhIHBhcnRpY3VsYXIgaW5vZGUgKGRlcGVuZGluZyBv
biB3aG8NCj4+IGlzIG9wZW5pbmcgYW5kIGZvciB3aGF0IGFjY2VzcykuIFNvIEkgdGhpbmsgZmls
ZWNhY2hlIG5lZWRzIHRvIHVzZQ0KPj4gcmhsdGFibGUsIG5vdCByaGFzaHRhYmxlLiBBbnkgdGhv
dWdodHMgZnJvbSByaGFzaHRhYmxlIGV4cGVydHM/DQo+IA0KPiBIdWgsIEkgYXNzdW1lZCB0aGUg
ZmlsZSBjYWNoZSB3YXMganVzdCBoYXNoaW5nIHRoZSB3aG9sZSBrZXkgc28gdGhhdA0KPiBldmVy
eSBvYmplY3QgaW4gdGhlIHJodCBoYXMgaXQncyBvd24gdW5pcXVlIGtleSBhbmQgaGFzaCBhbmQg
dGhlcmUncw0KPiBubyBuZWVkIHRvIGhhbmRsZSBtdWx0aXBsZSBvYmplY3RzIHBlciBrZXkuLi4N
Cj4gDQo+IFdoYXQgYXJlIHlvdSB0cnlpbmcgdG8gb3B0aW1pc2UgYnkgaGFzaGluZyBvbmx5IHRo
ZSBpbm9kZSAqcG9pbnRlcioNCj4gaW4gdGhlIG5mc2RfZmlsZSBvYmplY3Qga2V5c3BhY2U/DQoN
CldlbGwsIHRoaXMgZGVzaWduIGlzIGluaGVyaXRlZCBmcm9tIHRoZSBjdXJyZW50IGZpbGVjYWNo
ZQ0KaW1wbGVtZW50YXRpb24uDQoNCkl0IGFzc3VtZXMgdGhhdCBhbGwgbmZzZF9maWxlIG9iamVj
dHMgdGhhdCByZWZlciB0byB0aGUgc2FtZQ0KaW5vZGUgd2lsbCBhbHdheXMgZ2V0IGNoYWluZWQg
aW50byB0aGUgc2FtZSBidWNrZXQuIFRoYXQgd2F5Og0KDQogNTA2IHN0YXRpYyB2b2lkDQogNTA3
IF9fbmZzZF9maWxlX2Nsb3NlX2lub2RlKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHVuc2lnbmVkIGlu
dCBoYXNodmFsLA0KIDUwOCAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgbGlzdF9oZWFk
ICpkaXNwb3NlKQ0KIDUwOSB7DQogNTEwICAgICAgICAgc3RydWN0IG5mc2RfZmlsZSAgICAgICAg
Km5mOw0KIDUxMSAgICAgICAgIHN0cnVjdCBobGlzdF9ub2RlICAgICAgICp0bXA7DQogNTEyIA0K
IDUxMyAgICAgICAgIHNwaW5fbG9jaygmbmZzZF9maWxlX2hhc2h0YmxbaGFzaHZhbF0ubmZiX2xv
Y2spOw0KIDUxNCAgICAgICAgIGhsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUobmYsIHRtcCwgJm5m
c2RfZmlsZV9oYXNodGJsW2hhc2h2YWxdLm5mYl9oZWFkLCBuZl9ub2RlKSB7DQogNTE1ICAgICAg
ICAgICAgICAgICBpZiAoaW5vZGUgPT0gbmYtPm5mX2lub2RlKQ0KIDUxNiAgICAgICAgICAgICAg
ICAgICAgICAgICBuZnNkX2ZpbGVfdW5oYXNoX2FuZF9yZWxlYXNlX2xvY2tlZChuZiwgZGlzcG9z
ZSk7DQogNTE3ICAgICAgICAgfQ0KIDUxOCAgICAgICAgIHNwaW5fdW5sb2NrKCZuZnNkX2ZpbGVf
aGFzaHRibFtoYXNodmFsXS5uZmJfbG9jayk7DQogNTE5IH0NCg0KbmZzZF9maWxlX2Nsb3NlX2lu
b2RlKCkgY2FuIGxvY2sgb25lIGhhc2ggYnVja2V0IGFuZCBqdXN0DQp3YWxrIHRoYXQgaGFzaCBj
aGFpbiB0byBmaW5kIGFsbCB0aGUgbmZzZF9maWxlJ3MgYXNzb2NpYXRlZA0Kd2l0aCBhIHBhcnRp
Y3VsYXIgaW4tY29yZSBpbm9kZS4NCg0KQWN0dWFsbHkgSSBkb24ndCB0aGluayB0aGVyZSdzIGFu
eSBvdGhlciByZWFzb24gdG8ga2VlcCB0aGF0DQpoYXNoaW5nIGRlc2lnbiwgYnV0IEplZmYgY2Fu
IGNvbmZpcm0gdGhhdC4NCg0KU28gSSBndWVzcyB3ZSBjb3VsZCB1c2UgcmhsdGFibGUgYW5kIGtl
ZXAgdGhlIG5mc2RfZmlsZSBpdGVtcw0KZm9yIHRoZSBzYW1lIGlub2RlIG9uIHRoZSBzYW1lIGhh
c2ggbGlzdD8gSSdtIG5vdCBzdXJlIGl0J3MNCndvcnRoIHRoZSB0cm91YmxlOiB0aGlzIHBhcnQg
b2YgZmlsZWNhY2hlIGlzbid0IHJlYWxseSBvbiB0aGUNCmhvdCBwYXRoLg0KDQoNCi0tDQpDaHVj
ayBMZXZlcg0KDQoNCg0K
