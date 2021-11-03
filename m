Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71961443FEA
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 11:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhKCKYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 06:24:36 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:24976 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231278AbhKCKYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 06:24:35 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A39iCwB001851;
        Wed, 3 Nov 2021 10:21:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=RSY+RB3eoKP8cnERLWzaInXrwpJg5huOLU+uJyFjea4=;
 b=iPzYDYdo9Ezx9iaXkQ7swixVsbIZwLRLRfgSOo799A63t8A/17Y90uDp8BhoUpn5gNs0
 Kb+n0g+WCojB7wJoQcD59fd3B/BtGlvFyPZyt+IjG+6AHgVvX4fxmM54rzS5leAQZiLP
 D2NeoXYsUPWEnL03nYGSDze5JutFJDqg5xJQeqWlOmbPGcE/QMC1C9c95d6Y8dVAlOyr
 e+9j25YP/p1k4/ycsZQw7rv9IEizHCQaLB/mDrT7E9jUJOIh7k83vNjBc9xWBSFMwy/C
 ZEkKSDxY6uSLW87xjnlHz0DlX3ywuqBKs3y9kIhsZbxbe7UCs6UWFeWC9VxC5KWmv10Q tA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3mt593yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Nov 2021 10:21:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A3AB0Rv081496;
        Wed, 3 Nov 2021 10:21:49 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by userp3030.oracle.com with ESMTP id 3c27k6t01u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Nov 2021 10:21:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g8a8kbg2zAZgDg9vEyORTGrm60dXUthoPjYIWn59gGkE+insAa4F3u02+RrT06uXibAjAnKupppWM6n4pv4aSpGwmnuyVlIqJxiOsb7TvvnGEV6DRGa2HNEeM69QeLA8pF4QMZVQDlLK4sY7nDqfibd8rpJaSmD3x5lVeCfbi/RpNJP9Fddk+8xh6BNKrdqPzWw1v/2FSDUov0+7TCzW1IiLZyGfFjW3QkPYfIzTHct3a38tNvSWxKNcXL3N33wGXxSsI4sOrVq09A3a5T7v8tFzaahQDSDtOB7CcS/MuSBSthcA71Nhl2HPfqV8GhN9hU/oG96jCQgxT1Jv7UIX1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RSY+RB3eoKP8cnERLWzaInXrwpJg5huOLU+uJyFjea4=;
 b=BAz8ypQZZKyjbgl+/GW5MYUyIWqhusNb7n2DSiFu2tTqY1EhMHCHaWYot6DVZuSmYrWC6XyTyW+PDhbx9pYvJem5GWnzcpeotObzy95lUk6d9kcp74hruzguur7FVVib6yZJXjCazhbJYzAXHBD6EzUt9BCawfV6DhMMyjVcBI9cCDwYEVNKLAQDcpRgzAuD7+gdv48lG18A/Q20UQ+PnZH1Jaezn/8VdCgvusVp4VD/LkWeY56lS887yk3eQrmY7Q1ZyRGS4fqNtmEQ4oYuexn2AMtzHdjj5lMJrp5kR7mQb4cx5xOtK0iPOpgM/NdMQTdOqM6szRjiEBdpvelKPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSY+RB3eoKP8cnERLWzaInXrwpJg5huOLU+uJyFjea4=;
 b=V08knbz/Mod7XBVCplNED6Z4VeuYHAysRyJriXlpCd5EfNsPbw1XpbZCu70ofKLobBsZIsgZcVEwjDDRy3U61zkxQmksyyGzw1B6fSyfCFjv7fpb8Vp8z1s8e/cxl7tW7dTJAbUCB+aQ5OUmE+/aGWNhyPF/DCjsOj2whWpeNB4=
Authentication-Results: realtek.com; dkim=none (message not signed)
 header.d=none;realtek.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1615.namprd10.prod.outlook.com
 (2603:10b6:301:7::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.19; Wed, 3 Nov
 2021 10:21:47 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4649.020; Wed, 3 Nov 2021
 10:21:47 +0000
Date:   Wed, 3 Nov 2021 13:21:29 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pkshih <pkshih@realtek.com>
Cc:     Colin King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] rtw89: Fix potential dereference of the null
 pointer sta
Message-ID: <20211103102128.GL2794@kadam>
References: <20211015154530.34356-1-colin.king@canonical.com>
 <9cc681c217a449519aee524b35e6b6bc@realtek.com>
 <20211102131437.GF2794@kadam>
 <c3de973999ea40cf967ffefe0ee56ed4@realtek.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3de973999ea40cf967ffefe0ee56ed4@realtek.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0013.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::25)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.22) by JNXP275CA0013.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Wed, 3 Nov 2021 10:21:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4eb4fe1-05b5-432a-83e4-08d99eb3bdcc
X-MS-TrafficTypeDiagnostic: MWHPR10MB1615:
X-Microsoft-Antispam-PRVS: <MWHPR10MB161548E16CEDE324F826EDAD8E8C9@MWHPR10MB1615.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +v0VsGzMYcN2pn8ycjhTf6L36QTUzbGzt/otoD6Zy4/zTWYJ/yltx4rp2/1k6GOMVmf5AM0p5KEIfb7XNaP2J61DmRQaSO2PptqoCY2crwo55uJ1b7uSi24wh57sZxmRVlaIEN+W3s/ivN/xLTGarJZDRi5IoapJJV/Nq7IaoEqwfmuwGiwfbVFOy4ILxJSrO62qq8PknJPOry1VRICZHPppFUmAEiCXAB0nHUu0k0WzoVl37eC767PDySpcXUPes3YdGuKmjiHuhBfpnCO9+bd0drszk6zR6gXjh4FrQNGalJfk8j/MzbhS8VYw+/Tk2n0x/rW1NhR0JvBWIf6O/hEv/kPtNBF8iDjEKL+51EcjUr0V1NgVoG66hAchUf654Tle60L8pBXwQJIe0g/TuFcbwg7Yhdiap2xSsA3uIYx8QBRZsXwKlBGggCCqCZdGJ9yszUZuKAKzOprnusmKD0A8tDoOzz3ihYR/pPLw6XCgVfEZz9uBHGmsNyCqfJHsyHX/JtpTlKxWzTTT5e5uxAByQcsCWesVCTVVHjWHJysWnb6NkT66gQvvr6IyvoKNRd5cqRC77sumlxmfjmtVf7LVQdZ5WGjJ6AP55mrKdAt8n1h1HYUUU4xIycGiA2U/Uy/ozsFpOc2q9ScJLneNRiAodBvdmY2bT+XKGbTe/1ZmUgXRB84s1iiuk4lNtDqQrKE5IJJ9zc53NBH1RGMXkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6496006)(52116002)(1076003)(6916009)(38350700002)(26005)(38100700002)(2906002)(9686003)(5660300002)(54906003)(55016002)(186003)(8936002)(508600001)(8676002)(44832011)(66476007)(83380400001)(66946007)(316002)(66556008)(33656002)(4326008)(86362001)(9576002)(6666004)(956004)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yyTNsEnUDpamse1PzF3MUZ4vFtBgoZZwbyinJCj+dvHmylWGLRyFVVAIzAi2?=
 =?us-ascii?Q?qCnR/1gF8xsNC0JSKGRn9VFjZS1hQ81aCB3k2TOgOHPRSfyduuIzWJx0b1Hq?=
 =?us-ascii?Q?+MWejd5966OnyCIpEY8DV6Msu3Q1RXP5AcOGDL/6dwfNEhj9sFCZSQXNJZmz?=
 =?us-ascii?Q?1SMt4yWoC6WxfkXBzXjr2T7rgmU8pMkrBSWW6LByJoBIyXldhUXuWpwAVGB4?=
 =?us-ascii?Q?YZteZehoLxrX7E59zYCUMojlyjgw0V2lr5RK2qj+Okhmcarn/vbfVnc6+vqM?=
 =?us-ascii?Q?JGKc5u8+UCk8VxyDjb4tNJw5dA/asj211vNVegqW9TLSlGVKBrTsRaAGCAOF?=
 =?us-ascii?Q?16tBc/E5u3USruXe2+2bF1YtsE0OspJJUvAIZa7YA6qc5awiM76SkWcRbB1W?=
 =?us-ascii?Q?d1YiJQU4rMANB5b4hdFAeyNNe6TCr6toYe8XgrDO7FqIkRYXA/nxR78FOBr3?=
 =?us-ascii?Q?4PLlJucIeQsU7TiUkkrunpc2oMfCgNHUpSNwnqNCrnusrlRhFbhIl5hS5vdV?=
 =?us-ascii?Q?rJGFX8muXnjbfmjtNPNmuedoeRF61N20tCvZe1lnjYA+BpYoCMvFT6j8QSxW?=
 =?us-ascii?Q?J7Vgc7AUxqWtA+cvyK9qA8JMvy2e/4h3ZeH3pvnQ1Ckr3fWh9jTNDQJgHjNT?=
 =?us-ascii?Q?zp43e6JtWupGVOH7M718nQAGPi+YF9RnEGuO/CqqS4aMLrNjkXCRw/uw5w1o?=
 =?us-ascii?Q?Pk/lCUqMiGJkAv78NNWtBGFm9jh9zXDDYeRmz6UHFWTiwYTqPCB5pNVmgQuo?=
 =?us-ascii?Q?CIccR0sHT8dQjL4XimVdf/WI/znouNlhcgQIB9G1MbLuKEXYY2r+m/RPd5dY?=
 =?us-ascii?Q?J/AiWWEjdB2GVhogRLNPMnMiHY3A0aCmuQIvwtMtlpXjLkH7UjXknppVaIUd?=
 =?us-ascii?Q?w04/WY6Yu/nT5/pIol6k4bvnEOeMOd+oK8gD9OL4nEq1lAhYEWINY9S0Wwxr?=
 =?us-ascii?Q?qfs8bTkESnkamSSCwTBwBIPvdXkTcVeC1tHX2AWfPB6pa1hKaOuUvfpl4Cr7?=
 =?us-ascii?Q?wliJQGJMN1jrqoPUrMf/0C1Yt8CGJU9THdAlGgedGXat+7wMLGvKBhIqlu2c?=
 =?us-ascii?Q?GUM54d8hmJjyi2KEKDokepFOFNXUq8MKZbzyElT1Q8WX5X6grbxYU+RQv4ng?=
 =?us-ascii?Q?/snjaqLZfwDMJxtqV22zclPDcprM1IS3OUeo3u46+mgRrH4NyTWdrbJbKFkj?=
 =?us-ascii?Q?1I3AecD2HZxYOzH3n4y0Qu/Q7DvnbyGtGWcpsnad4wM1oAv171bwbf/AtVOR?=
 =?us-ascii?Q?cp/+q5hyGCzgB83+VkTrB4IFkRufaRZtEyFXrVSAGQKWrpaIdZeXfMYa9o9t?=
 =?us-ascii?Q?fZkHiTBKYd7jfnRthbup6vFau56Ll6KS4VcueZW8+t7hn3W/w1B2KvJBtmg7?=
 =?us-ascii?Q?LdBClk7yZlT+jTCKS4jSABpCHpXXeXUjNRaXPyjhoHjcgmOOaGGOLgnHgJjd?=
 =?us-ascii?Q?RrLJ5Vx+83PsAUYAbko3d8q68nldISfH1VDGyg8PgpjwJxq30ruVQjVY85K7?=
 =?us-ascii?Q?rGa/a1AMyJgMjJ+Xu+rBxCCp98GNELSrxnrNGYXpqfVoY+4ExFplhxS47yNm?=
 =?us-ascii?Q?HRBFMM1/EZe2JpQw+4y1pHC00REzkOmBMciBgFp4fMpRg8pT3tYMobRVjGN5?=
 =?us-ascii?Q?jyhKKrvVk6Gl+d77mMKHSe60nrqIZe6YCApedaofTDlx+GrJTjEC2aBsnY+3?=
 =?us-ascii?Q?IZJmvw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4eb4fe1-05b5-432a-83e4-08d99eb3bdcc
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 10:21:47.6173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rNG68CLN3znkKhDO4DflMwqoxPGo6uwF5h8XunT5V8K4dtNgTcvV0MV7siXX5VSC6wWbfi60tsSsgDsJ+UDPMUDK9zM3zPJqN0qtDsBpZMY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1615
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10156 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111030058
X-Proofpoint-ORIG-GUID: lvMC1EOH15DkpoNSXZMlZYECHCHOjRXB
X-Proofpoint-GUID: lvMC1EOH15DkpoNSXZMlZYECHCHOjRXB
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 12:36:17AM +0000, Pkshih wrote:

> > > > diff --git a/drivers/net/wireless/realtek/rtw89/core.c
> > > > b/drivers/net/wireless/realtek/rtw89/core.c
> > > > index 06fb6e5b1b37..26f52a25f545 100644
> > > > --- a/drivers/net/wireless/realtek/rtw89/core.c
> > > > +++ b/drivers/net/wireless/realtek/rtw89/core.c
> > > > @@ -1534,9 +1534,14 @@ static bool rtw89_core_txq_agg_wait(struct rtw89_dev *rtwdev,
> > > >  {
> > > >  	struct rtw89_txq *rtwtxq = (struct rtw89_txq *)txq->drv_priv;
> > > >  	struct ieee80211_sta *sta = txq->sta;
> > > > -	struct rtw89_sta *rtwsta = (struct rtw89_sta *)sta->drv_priv;
> > >
> > > 'sta->drv_priv' is only a pointer, we don't really dereference the
> > > data right here, so I think this is safe. More, compiler can optimize
> > > this instruction that reorder it to the place just right before using.
> > > So, it seems like a false alarm.
> > 
> > The warning is about "sta" not "sta->priv".  It's not a false positive.
> > 
> > I have heard discussions about compilers trying to work around these
> > bugs by re-ordering the code.  Is that an option in GCC?  It's not
> > something we should rely on, but I'm just curious if it exists in
> > released versions.
> > 
> 
> I say GCC does "reorder" the code, because the object codes of following
> two codes are identical with default or -Os ccflags.

Huh...  That's cool.  GCC doesn't re-order it for me, but I'm on GCC 8
so maybe it will work when I get to a more modern version.

regards,
dan carpenter

