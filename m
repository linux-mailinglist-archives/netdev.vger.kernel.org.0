Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48A1A51A0E3
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 15:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350524AbiEDNaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 09:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350311AbiEDNaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 09:30:02 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEDC123BE3;
        Wed,  4 May 2022 06:26:26 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 244BY6kd029440;
        Wed, 4 May 2022 13:26:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=t4iaqOSmIxImHRpjcjZEQ8JaaqkHEUwtVV7WOK2Fjcw=;
 b=k3N9bB506Em69/IMvj7cARh0X1mc+6rpLYN8pDShamY5KNpbexceLrKIL7m2oFB7KOHy
 WHeSipu5Gg2xvkKxhtuC65fcf8RV96NQaXZWm85+AqwRZfKtxx/F0rL6oaabz86cGSTl
 JD0maIApGzRvqC2cG62Uzi60LHZjEZsmyyZeQsW+d9H1q9Cry97HaHBDGTD7pmo5BDTd
 RQbBlAIo5DRQxvVIglhYHfIXQ12WkSlymYuhDhEQIoNCEtPNhwxfrjqW66kTB8TyPq3X
 eM2mbbJRYA8qv6F4n2c6Fw75uqq8IIdIxnyDENblbQLcEprbHuqAfNgAuS8lCPkfDLXx Kw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruq0gfpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 May 2022 13:26:15 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 244DATMq011414;
        Wed, 4 May 2022 13:26:15 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fruj3cxdu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 May 2022 13:26:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ov7w5gHlumAP5/zVSLQ71IODzBuHT4mLLykQDorsvCX4l+bKss9mCZr0viyFEZ8nU2bdGUYz4yDIWZke6C3BNjJnD0nWc2YgJrA/jN36W224BrZFh+tVF2B5ofMI/KycVKoNsHOvOCu2aL+5+IcYaboM3Uf1fzMXnDWYyl/y5fmd8Fd30s96JGmycVL1t5L+3R4jG4tROf7PCtEK4bwl74y11Eu1cTMSlNz6tL8Z0x0VFTC+uSuK0Oqd3bJ06RN35gOs92LWdxd6ztxGPknHyPgUgkuwIYkJR9OLDifLxsAJ2u0E08of7t44mdlHYWt/0dqUQPkh5Db/1OUZOuvEsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4iaqOSmIxImHRpjcjZEQ8JaaqkHEUwtVV7WOK2Fjcw=;
 b=FdhVH4EfLW/DQ2hJUVZskeWJFnF85OFXWA+To/HJxkb+drfwJjHAexGy2LgyjBVnQDIJA2y+vR826LV2ahx6+TRKbchpGBls7RGaemRI+OCYRKnQP+MjVkXkKb8SZ3HX68UP3HiP0SsAlm8PJVLexr8PNXI+I8QDQRcJ/HR74IOU/ismRWoehygWh2vPiiTp0KSZlm71aJAFY7mEVBO1HMzOf7ey7SRYK7h0uzvUMirQHx24eP5O6950agFrU9h8iSciz0moTV5MAsk5dIBMNc+8rkSa5Kpp46zZ5yRU5X0eiHyHNkOkoM0w2HBgrtiqlGWyqvXIfLhoL6d0T1T7Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4iaqOSmIxImHRpjcjZEQ8JaaqkHEUwtVV7WOK2Fjcw=;
 b=a5Q1U4QImu43etnw85Xktg+lVRFyM1BIuohnzOOhbsy1VmeZqH+EK+YyOh5GkeE54rkxg459E4Lx0xIFiZrmEECK7LplTnFeXTauX6Xbdx+YIfbq+K+L9+99yDDjgSt3LD8otulnM0YDoyJkPheObQeBZDpNpa49wliSXR6bM2M=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SJ0PR10MB5632.namprd10.prod.outlook.com
 (2603:10b6:a03:3df::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 4 May
 2022 13:26:12 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87%5]) with mapi id 15.20.5164.025; Wed, 4 May 2022
 13:26:12 +0000
Date:   Wed, 4 May 2022 16:25:51 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Jaehee <jhpark1013@gmail.com>, Kalle Valo <kvalo@kernel.org>,
        =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        Outreachy Linux Kernel <outreachy@lists.linux.dev>
Subject: Re: [PATCH] wfx: use container_of() to get vif
Message-ID: <20220504132551.GD4009@kadam>
References: <20220418035110.GA937332@jaehee-ThinkPad-X1-Extreme>
 <87y200nf0a.fsf@kernel.org>
 <CAA1TwFCOEEwnayexnJin8T=Fc2HEgHC9jyfj5HxfiWybjUi9GA@mail.gmail.com>
 <20220504093347.GB4009@kadam>
 <20220504135059.7132b2b6@elisabeth>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504135059.7132b2b6@elisabeth>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0006.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::18)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a1019d6-917c-4081-ca83-08da2dd1a887
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5632:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5632D801491B95E518C590F48EC39@SJ0PR10MB5632.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: egH5XqNlNE348hbXZgUJKrzCnjMWI8QaMLcWLTc4rVTVXHcMVGEqPICL8gWn1K4kqrPioBUiAHKbf8BM0n8U5lOpgy3hYzYnIW0iege/ZU3CtXsTGv/WaTjWS/MJDG3eHQFVIKZfQaoRELT6rnfcQApzi8HpZffGH0Lfs+vsBQQEtRrajIlRhuSKgMI1D99572R5l1L5dcRKRSOxnWFIm8WnOpohLwHyWcAJ4sJiJslotbfvXEXB6YeFF1hLJ9Q1leqNU78D4xkqFpfaBaghznN+MSXRFHAs7TLfmwa+G8BGO2V7wRceNlsmuXbBDbsOL6X4bKiJYGfLFOFjjKtmTAWRdwZztVp4dueLo4TFNX3//vw4vSRXsy8oHi0eoSFF9hVzb3ahh0o2QLUyJIUbeNAn2YHRXjLI5UhriwnK6rT1WMv14OQgBqTdVOs0XCpG5Kv9Xvp0ctAqXOvO3mqIffGEwXCy5eaOv0PpWobjruTqh5rrt0ph3SdANv7xwJ4fCsDjxYCpqYghTs4nqdWLTT/Cnp6LDUDvvwWi/qO8lUafMZnyGAwJ6OQa6Y0ZHSyGVTXw8mPUg//RzUxF882HRmguhr/E7sggEb593wApXCb/gLOVcA28tc/FZiZoY3A2diY87c+avT+QHic6dQHnqyu6gXE54DXOuH4XaglafIniRWPpYwlubDPvTdQpAwtlowoVIqbuD6ulyqWGCF4y7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(186003)(1076003)(33656002)(9686003)(52116002)(2906002)(26005)(6512007)(4744005)(44832011)(5660300002)(6666004)(83380400001)(8936002)(7416002)(54906003)(6506007)(508600001)(6486002)(4326008)(66946007)(33716001)(66476007)(8676002)(66556008)(86362001)(316002)(6916009)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aNr/Vyia9lPs7nwzu/lGufE8hc0ra4ecE0o/E8tbAHjzQPoAHHkkzLFFVY8I?=
 =?us-ascii?Q?8B4KdypiZErLe6eWsNH4YV4G0modmf4nIQm4rKVdRh/tjxazuKHsKiKh0NSJ?=
 =?us-ascii?Q?+otTyXFiEyTQjyHk+wju6ncSL+FM78QrvHxzi5pXDl/8G4Vb6PvxxnRBxfJG?=
 =?us-ascii?Q?ZeU723AUCI6XHFQJfYUuFTE2a27+2BGT0NI92ONsgLr2Y+PdhoTwsvFRXq5x?=
 =?us-ascii?Q?rwtBbQVOxqcQlfz4q7EZUJq5MQl/JvcHAB8eZtM/PD947CPiazO+EmK9MMZl?=
 =?us-ascii?Q?OmNDlZQRSvbKiTcOW73Vmb8gxHtgRqWzihxl+75NrSTB6LzGfTJBy81/u620?=
 =?us-ascii?Q?+KTRcb//JtYM6KNsihLIMQZWOtj72bGuWKIF6NOoO6nsrpb5Q7zfH3AgSE1y?=
 =?us-ascii?Q?svzLHfGiV7O8VEkzjAwMH4H7U1rngZ0vuB5/YP2qo5EiM8CJVz5BoxqTdNGH?=
 =?us-ascii?Q?Ggcl2++WMfJ03rYoAGXgOtjS0hP3XKiKhmRF6QPXdIfcOVU8lVAqPl0wD8Cq?=
 =?us-ascii?Q?47FHgf29T4x2FjonAx5eSdWonr2UzgsTDvqTdNzcZyo7vmyIbhxsUO8P2uhi?=
 =?us-ascii?Q?WzmNUngDa7S1OLRlI/MNYDv4hW9RxIACGQiMPuC11omNvX9hu/UHW8p5WwHU?=
 =?us-ascii?Q?SsjVI11vCEakonGrmUTVGe08JhwlXtyYJyzjKb4m9ZGvOs6PUJaadTewruuF?=
 =?us-ascii?Q?AjxTu3QbZXvW3+/XztswvcTSFJDS0nwrCIs/PQyHzRBFt+LTxErQALXAGm6J?=
 =?us-ascii?Q?qWGYHHFc5r2xt/Ut6Uf3YqVjXYuTxb2jSGKzBAdYCqVW860g06VEDJf3yls3?=
 =?us-ascii?Q?k/u6wKb4pmf6PTkdMPY3A9QNhqIAk+1B0HV65sH2cxp9ZZniSizxGQFrC1Vs?=
 =?us-ascii?Q?ogIwfgZ+pkN4PDI0HNdTzPUTlFMcdlsNAyuZGnh3B5La0wYlQunKqYHGJgUx?=
 =?us-ascii?Q?PuOqXzuT823Je+oKGlrNrDVGGCqSlGlJ9so1nlj3gyZ1u5ddL3iz+7XVPows?=
 =?us-ascii?Q?XiwjkOZs/2oDsq6XxDvwXQMQqzOhNpPqvdrX9l5vMG7CTmnXngDkqPQXDzPB?=
 =?us-ascii?Q?1iCwRtFhV0PK64EKLbAZngOJs1bU9whyO0TRRlnJHCDkSSY3w0yW/BVWb8u9?=
 =?us-ascii?Q?ANpzq6JJhdofYsddVd0acjaUBRLPS36far2BDME0lEOZKwzUiSaCyTV8z6Ls?=
 =?us-ascii?Q?K7K9AvJqNWgwFBuukzMoTS/gaxlYlgtmh0CNtB5w0VgLzXb9kEsNiI2mln+G?=
 =?us-ascii?Q?o4SS0eUTJjnJy+O1ynR/yrq16CKOmTAwY0uTw789qtszr2QC1xSkUqFGOjvl?=
 =?us-ascii?Q?R89MPtuuQ1TH4ALfMA0S/OPfy5uhCoOJUzoVC4RH3V++t9n1t2wCgO3kbQ6Q?=
 =?us-ascii?Q?L+0iEYwek7OH7wy3FTt2DQLMA//Cdky7zhA/OQVlG0BYnL80uaDbl2JUXt7l?=
 =?us-ascii?Q?BTGW43BGtYbFUEamHe7F28Z7IMpWjQMzOx5N8pW5vo+2BXVZwqAbHu2kx8D8?=
 =?us-ascii?Q?Kix8y/0nphXZvX/YHKf4ExQVFw30Hfo4XL7nWwGohNRr1/T4xpAb7h9ZOGDn?=
 =?us-ascii?Q?jDUwHH9XCgpH0Cu8Ot7yP/v9BZVxpfsftqTsibFwV8hYF7sEWuE0393Nf2As?=
 =?us-ascii?Q?pjMGfl3uUxipb0tm5/NZ/Zi09xPswe7UcAL+1Q0NiJBfs6N8AZ/NXCtkwrIV?=
 =?us-ascii?Q?juuUl8J53AKem7DJCv/hjo1/FQwFX3pzk0ERoSiCPhk4rEMY24NMnH9mIxp1?=
 =?us-ascii?Q?frwi/2b8VtGEOp7BoIwaNaDPdl17/JU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a1019d6-917c-4081-ca83-08da2dd1a887
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 13:26:12.7420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ippmVmAc1/+KRZLd5TYzNS2IMCd2Rxh+7YlYP1chWbZHxmJJz6/7TljaVqsgZQJ3zMs4VMJsa6NevmYMMjApIJ43wXwpXLJ2QZ5T+Rq265Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5632
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-04_04:2022-05-04,2022-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205040085
X-Proofpoint-ORIG-GUID: mXdSOyF_xKPnOPUGmQoLEIXxNHlnqx38
X-Proofpoint-GUID: mXdSOyF_xKPnOPUGmQoLEIXxNHlnqx38
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 01:50:59PM +0200, Stefano Brivio wrote:
> And that it's *obvious* that container_of() would trigger warnings
> otherwise. Well, obvious just for me, it seems.

:P

Apparently it wasn't obvious to Kalle and me.  My guess is that you saw
the build error.  Either that or Kalle and I are geezers who haven't
looked at container_of() since before the BUILD_BUG_ON() was added five
years ago.

regards,
dan carpenter

