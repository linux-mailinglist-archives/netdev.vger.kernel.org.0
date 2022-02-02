Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 394E64A7039
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 12:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242715AbiBBLpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 06:45:21 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:20052 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231171AbiBBLpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 06:45:20 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2129cSPL011406;
        Wed, 2 Feb 2022 11:45:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=rySwR4JhQT6VtGIRBQeGTIs4rfcjl+kYONLHY2CMJsg=;
 b=r4yH3V+TuL3yz3uWni470s0vcq+JhMYbqp3eUNSUW/PSFFn0M7SYwPgqUsLxhnXj8AS4
 9fAmQVyAVPatuVPdombDeFB6pwBSb31eiepHQHK87psou+ZoilaN3Fbz20vA+5Q1NcsF
 S4rd7mSJn8qCq6/o5uDjnjm31rcn1lEx3puwytdBvRX4QvXyXU9OeNvKzF9gNMCuvOBL
 HILAfdWIj262oygpRKFdSBeOgA5zUqIPY9lXB3Wut2OxYbqUQD0UmtsSTpMfYdqm89Mr
 FKg+qUmqmKgzTQTfRx78xpFAFEo+01rDGND7EjipArs0Y6BLxA3rVABqi2Ua0cawivBs 6g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxj9fwt41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Feb 2022 11:45:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 212BfiTD093347;
        Wed, 2 Feb 2022 11:45:09 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2048.outbound.protection.outlook.com [104.47.73.48])
        by aserp3030.oracle.com with ESMTP id 3dvumh6qpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Feb 2022 11:45:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HZt1+gFos6WmE6302ZgU1zptFCKtqY/33no2ZFKUJWDLsBIQTzjjo6/aafGqkor6IY9tPtLBM+P2Db9cYtXpMAex9UY6cKZuoUFKgk5qXuT8hfh2sCxtw7BJ9iE10WaALdKdUD2nva4YO54G4YaDsLULn6KohKMuxcwhm8q6cBt9azWT3A0dPcNMiaQub98T08JjKtpLt92rhD7nxVzFWIvmoaw5yQOTik1y2+F7b4WFHi7LF4TDC3M1y77SSgJzL2FcLmVroIh/6f2iepVNeSX19tyrqNlVA6eVnP6KkvvcKIDasWuNmA17ZybbBF8pqUZKIVKenEYTwUcMDWf9aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rySwR4JhQT6VtGIRBQeGTIs4rfcjl+kYONLHY2CMJsg=;
 b=a6OS4MJdfYLibyYFsFOVz97skpzYpJV/AOT1QBp07ns9E7I2/euQqb10Q9ap/VteH7a0KXaqHqCSYAYML9Fkty0VzwiXhBGugBjKf431t4VqGrJc85XNRvPVUrnVTL7kwB0ixG/3poRhyfnB89h6ASXIIVECcY+0c0BNwp5VGExDivv16i8cv3+VOa2B2B2ZefCiiK0ZXAwOihzEU53LaZBQkJ+gu8PLCuH9LZukGYEQbe50b1l7QDP58OfmE8xR3Jtakny2236N9ywHzlaySOQFk10Mu19SXOTXkaceqU7f+JJpTTNBj26M48dV8eLMV8qKaJQjRRONgy0FJTHezQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rySwR4JhQT6VtGIRBQeGTIs4rfcjl+kYONLHY2CMJsg=;
 b=tzrWVe8CW1nzNwGcsPWQEbMvMmk6ifqT/tqXfPfyL8pzaYk1nlK4cL7ySun9PiRnfKjIBVtoVXik9Z1X8PvMdLwaxRR2zoEUksWtR31QtzBS2OEaylhWEDtUqQwwEMN2HONBHVMrkQzLupUibCvtWhxgwbiz3qVU0KBtkgQRqZU=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BLAPR10MB4881.namprd10.prod.outlook.com
 (2603:10b6:208:327::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Wed, 2 Feb
 2022 11:45:07 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8%5]) with mapi id 15.20.4930.021; Wed, 2 Feb 2022
 11:45:07 +0000
Date:   Wed, 2 Feb 2022 14:44:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Joe Perches <joe@perches.com>
Cc:     Kees Cook <keescook@chromium.org>, Pkshih <pkshih@realtek.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "colin.i.king@gmail.com" <colin.i.king@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: remove redundant initialization of variable
 ul_encalgo
Message-ID: <20220202114425.GV1978@kadam>
References: <20220130223714.6999-1-colin.i.king@gmail.com>
 <55f8c7f2c75b18cd628d02a25ed96fae676eace2.camel@realtek.com>
 <20220202050229.GS1951@kadam>
 <90e40bb19320dcc2f2099b97b4b9d7d23325eaac.camel@perches.com>
 <20220202110554.GT1978@kadam>
 <a0ee4c6252ba69ec1425421ed3f297b12dfdcc3f.camel@perches.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0ee4c6252ba69ec1425421ed3f297b12dfdcc3f.camel@perches.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0042.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::30)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5889931-0ba9-4bbb-7653-08d9e641755e
X-MS-TrafficTypeDiagnostic: BLAPR10MB4881:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB4881E32EEF3498F5A04722568E279@BLAPR10MB4881.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:499;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3yH45n8H5RjkrPeXazAnAE8rVOasV+DMEQcaEHfH3C1iDH72R/vOJh/hdu9pOC74OZ+Hzzb9hb7FKN+YSvuhHm8B2sEXxoyriu4Z1V49JBp5XsXDaRyVCu8Pd+mwzBwPbbY8gYEQoFJUWUEO0SCedBygQ4xLyX4xUDWSNfaokq4/SZDBeQ4DsyoBS371GboOFDJ6YDGmutmRFS4twXrbsvJ+oWstOUHWK1ym2ihoyBoDHO7yA2eYraApoRSFq3vnlOzKajattHs3lr7YjgrZaHlAHQLlBabCrOpKtC8YtbaEm8c1m4dcFXt8QgtJ6cMOH6f6uiyGwJO347lW9uxkP8yofJM9aRqLkqaprlYMOycaB8igGE9ocaY49k2Yc6b2IebDRtAErY7U5K9wg7sadVGyN7jSsgSiUD1NXkTgI+Qv6n6IJGmAffI2H/7OR63aZVRaGp5stPS4F3vlFlXZPTTe2vD/ww9M6y2CWFzX+fld+8ds1/Ip74NOC1khHmeblH/RxSeFA93jBYtoc1detin1SzJngI13//gQTdr7jRDq8Ib38MjcAjN7WMsJMBUP3Ca8OIYOyRbpgiweoU8Yz5JU0zarVLlq7mMkNkhqFwk4/2JfYvGNufz4DrQYWBXpuG5EOdDXGu9Upb7d1BAgODe2xMfq/aUSe9PuIV/SBwtfQEI252lkMpuDrQohu6V9diuatbeRNQNJCcOv+au6Ew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6486002)(33716001)(1076003)(186003)(6916009)(26005)(38350700002)(38100700002)(54906003)(316002)(66556008)(5660300002)(44832011)(6506007)(4744005)(33656002)(7416002)(52116002)(8936002)(66476007)(66946007)(8676002)(4326008)(2906002)(9686003)(6666004)(508600001)(6512007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bQoRiyB/rgU0tAMjv/a+h6Uh6GZrWBAETC25/OEddHiNcoOvcVGwuDr/iGxb?=
 =?us-ascii?Q?lbBV2Wu3J5Vbj8biciMebo3z/si4N+HidVd9p1oJpOBApwpRkj7y4kD0kCBR?=
 =?us-ascii?Q?TEHmuky6nEaXnC73uRcpgXYxz/kYgsHStiJdLXqjDqOUXW0hr7x2k1et0AfV?=
 =?us-ascii?Q?kIlbycJfxa7fITob+jJ6aD79HRtLnTHS9rC1WgdFcuJz7CeGBVu8RorNg4TB?=
 =?us-ascii?Q?+Q9TZBYJKwBmc2aHBpDy2txJ5pj4c0B/bjV+tHgksqpsnxAXR6/OxJNbQg6u?=
 =?us-ascii?Q?ZOznUm+WUFjyLTSleXlETZP0HnB2NvqyW1y2qQqvZZ6pTGqgFWCFo1/Kw+3p?=
 =?us-ascii?Q?rBZYr6n6j1nqNBSKHJe+4G0T72cg3vZ/y8iw02aou+8ZLroIXZbU+BSVdej4?=
 =?us-ascii?Q?ejUOeolRjRMpK0zuejx/9aQFelKCGIpyOdDLLc+Y+0HbdGwsdofyfvgf9vfw?=
 =?us-ascii?Q?qfXCjrmfPaskwOJ0RLdxaGqhqoBpvQcqjxaNsSwW2grPZGwBgENkQ7uePOUV?=
 =?us-ascii?Q?GfPcNq25mVWYni+zk8Eloixg9oD1iodQqyWrUAnjsLa9oFGbMp0RGggsiFLw?=
 =?us-ascii?Q?ZllcEriPP0EHn71Ul77bWI55MLwMM7cK1jDrqU8Wp5kJTvQpPPefBvvhLbR9?=
 =?us-ascii?Q?KMKOnBW1Q0PXQumIATpyswRJrJBmZSpiJdikIRyFL4t4k4UezsuEoRWSjGR7?=
 =?us-ascii?Q?RMFPy4iomEwCKG0tp1QzXQnDXe0Of/rDAtzb7QWb5ZOQuU3NQdwSV0mi2YJk?=
 =?us-ascii?Q?aJYzh2HxcUA7lpRErTxYd1EUapMIVX4BRZDZ7NY6MKHltceOSyM1D5lm8zZC?=
 =?us-ascii?Q?kGpGUPTHDIZ9tQyMUtcB9ahXDEAAgxoBp240FCLOAdTnN0QmQC+zf8EcKlgo?=
 =?us-ascii?Q?TV5i8vB667AqpezZRfZ6vfWgTWQPI8JodcGrhrme3mKgZmCHQuQ29nUng5m9?=
 =?us-ascii?Q?O3jmRMIRP5m/D3GIQoQb8TKCNyYIhCdOZAvD3/LW4vIZ6V2OzVnJ5W1q0yVa?=
 =?us-ascii?Q?R/WH4MUL7hkQtS7f8TtjC8PbMboHQgtn1CanB8tvHHHVuWqCkVVGLytlHKIp?=
 =?us-ascii?Q?T2073XThj7lXwU2HA8SlupIKtkh2qb2QXTpzNBRgpFp5rDE/mGtqnhLGklL2?=
 =?us-ascii?Q?PbhsKQ9ei26/lrCpLcrfYIG+SqbEu3CQ7WTZSNhqSVXgBt9PduJ5p5FhLwQ6?=
 =?us-ascii?Q?63n5jF4RwpSDfv0CIFWMfvPf2knDywty7uG4MbDp4C6mm2lM8nCL2qAu/Kdu?=
 =?us-ascii?Q?UIPHeJWlSSVZIDsyMBL7sIQ/EE9ZttBSMKreGsb5Ggpvop6D8BbrTCHD5+Hn?=
 =?us-ascii?Q?F2wuvJjDeu1Q721kYaxpVM7qRdLDW8PznSTJUh0SaeA207EaNGYKoQ3LiqAc?=
 =?us-ascii?Q?dUPO1koyxh4XDNmCqLDaUthkaDzHlgF+SC9FntnwvfGbb4zFe0FV31NnyrMW?=
 =?us-ascii?Q?e5TMCIVGvKIbpgwF4zt9HWuS6LGEdehSSghhalUPz5Ue+SnV8kJCITCezFbW?=
 =?us-ascii?Q?OmU0HB/yFROHX9A8ZKG9TTxwcv9hQt8C3A48zS+i/w231KdgLj+JYDXKJIF+?=
 =?us-ascii?Q?qLqyi8pNLLm833p2bCDt3paodThVdvatfD1KONV2wISwUp5JxYThijXpaSPf?=
 =?us-ascii?Q?L0CSYBEaiLGWZIb1sWRLrMdfW7UOZxs7Gdmf2gCfMSifKJs3T/ccRMNXBFXu?=
 =?us-ascii?Q?MXl+RKCZXZ/0XAmftRJ0Pra/4Vo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5889931-0ba9-4bbb-7653-08d9e641755e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 11:45:07.2273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H1dqVlAuKINyqwOBrGUlWJ9d0Ho9WO1DG4a8uNRBTvJKI+SrRJGUyGQZ8n9BcuZD8V6QJWea+UGGJTx/PUs06uyz3gYNn1Kz8j/WiM7wVrw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4881
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10245 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=899 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202020062
X-Proofpoint-GUID: MZ4roNrRg_N4XAkFkH848bpA17Qehd9D
X-Proofpoint-ORIG-GUID: MZ4roNrRg_N4XAkFkH848bpA17Qehd9D
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 02, 2022 at 03:21:17AM -0800, Joe Perches wrote:
> > I doubt that's what Kees had in mind when he wrote that.
> 
> uhh, I wrote that.  I think Kees reformatted it for .rst

Heh.

You should have mentioned that you invented that rule!  That's like
editing Wikipedia to say what you want and then citing it as a source...

regards,
dan carpenter
