Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560924A6F8A
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 12:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiBBLGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 06:06:32 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:65528 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229552AbiBBLGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 06:06:31 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2129makG008551;
        Wed, 2 Feb 2022 11:06:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=R1GHe0oltkH2lpXeC/k+h87hlMLF7f1pEJwt5W37xWQ=;
 b=Rj4C+Gd/TAr4gfnimQlCYxCXHjHhKOlZJdADC0+S34olbUdi8hVxzIPtzxfOm5zA5dQG
 fCLgUnRLd/J2m7OzySI4Qmilh7LF8HfBXg43+XKgeY5dUW6dW5Ymmq0UqZksm+zKOQ4A
 mTgC+lZb9Gge74dLKFZ7AYUEZYH1wLxGlhiKHfPfIuKgIDVgFcuyc44BwwRd4BtNoFoY
 vpJsBuhPKKLLfs2Ih3YGNfbcH1WYSAYTchZjC3RFg1ZtODyVvw9sxmrvaPiOLgefA4fu
 ws2uTrYzD3eKVdmShQ8P6i35Iw07J12TLkfCHfnqcwMiDIaC8CRSrCdU6cBS/+xQYIlP 8Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxjatwspk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Feb 2022 11:06:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 212B0uv2166342;
        Wed, 2 Feb 2022 11:06:19 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by userp3020.oracle.com with ESMTP id 3dvy1s0sqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Feb 2022 11:06:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i6DSyr30SS9clffN3YfykUzLf1k/vdvcvQQyeR5IjuBZHnAohzdX0Pr6d5hFjLGTH60si/WeQtNavfEtKrVYGBmvaVxMj7PYotAPc+Yxch/opKp8pNKM+r2caTGPbd/Y4ySt4R+ZfAftS9lF1KxBv4kyTih1yX4xat6ByFzzts5xYqZTrU6oyVU1LTQMaOFkpIHZsaFNIeJVaD0Vh/lu44nhPrjleD3ATu63Tf0ihIGEC/B4DSIcQ52Wq1cXVZ854k1tBjWeImwYH5ekF6/8pTfraxLILnJjoYRCgVv0BeenyS2/UIg2lqnTPs941LnleAWrjDRND7m/ucZqYjoP/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R1GHe0oltkH2lpXeC/k+h87hlMLF7f1pEJwt5W37xWQ=;
 b=drFeusx/ezc/XD0kIu7MrYpcSeKfNmplnKG4sDBth3LFZRlMuZhxVbvTEveyjEzrajoSQ8tWqc5o7sxfPL4PVXh310H5ql4/qw9kVRXl8wv03fXnjFJVtIu3pJTHdK6E6C2zOdOBk7I4e9+my9t+ngGvh/Mh34rb8bFAYn6oXx3VEh6Zws9hKxAXpT9QG/3SF/cg/iPNxvLrl+4C0xIKR70OSDKcI2UkZniFgpG7YY/y1+azVdB2Iv1Y77Ghsxw4tRXAuHULhqbUo5gtshYnoZIeYUR7lPQteQXyWKtm7FULrhDlgi3aTIlfEr54Bu44JS59KGzqiIHoaEzP0xeHGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R1GHe0oltkH2lpXeC/k+h87hlMLF7f1pEJwt5W37xWQ=;
 b=eTRq0T7UOUNZcvHx+Tzcnvun4xj0layv+81aB/GyMZKul8kgtCF6YLo47CTXPJDi3X7DkpKPjTFmiOZ5L7ikYd3KHVKUrYv45UaFMlh8JAwrmNywbFB5GN4X/YzzmBHxl8wlpVsy/psBOPgOwwvKfHoHCdafYTy6Rn4TyqmC+U0=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2111.namprd10.prod.outlook.com
 (2603:10b6:301:34::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Wed, 2 Feb
 2022 11:06:17 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8%5]) with mapi id 15.20.4930.021; Wed, 2 Feb 2022
 11:06:17 +0000
Date:   Wed, 2 Feb 2022 14:05:54 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Joe Perches <joe@perches.com>, Kees Cook <keescook@chromium.org>
Cc:     Pkshih <pkshih@realtek.com>, "kvalo@kernel.org" <kvalo@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "colin.i.king@gmail.com" <colin.i.king@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: remove redundant initialization of variable
 ul_encalgo
Message-ID: <20220202110554.GT1978@kadam>
References: <20220130223714.6999-1-colin.i.king@gmail.com>
 <55f8c7f2c75b18cd628d02a25ed96fae676eace2.camel@realtek.com>
 <20220202050229.GS1951@kadam>
 <90e40bb19320dcc2f2099b97b4b9d7d23325eaac.camel@perches.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90e40bb19320dcc2f2099b97b4b9d7d23325eaac.camel@perches.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0018.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::30)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f57e2be-b51b-4ac6-5752-08d9e63c0899
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2111:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB21114538DD25FF7D70C0B34F8E279@MWHPR1001MB2111.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UOsFn7LznaNsa5nc0TvNknINnsLnSNNex9gxO7r8zyEOwpsm49e8WwEFjZOg7W0gj8hOeSDS5vG6XzV35ZoskXBkDMysqslASVEcsqJTbj2dm0RrwEcewSKZlm9/xKbF0DlUedzgzZXRR4B/8y9rc5CV8/OlbcH+mLhmp0nPGdSYoovilDXOI0DUG1hx7yuPU2bg/uSF4ChvVJ/MDSbtfBNlVqqHhife608AE4N5IRjJOZ1y45naSDyYFm2I9w7Ixww5oq8ifXyOuqmavCFzoFhb9fL/bKQj1u+1Z5EXi5+k9S/88nzHnuKsifv6ydh1jmapneRlHD3Cm5e6qWlkM0U/EGO0GXG7kqZ1PLmD+zJIn5vaR7C/lsfUSUJm0spIqmmRkEn2p3NM08QMBGrW7tgWWGgFDu8sATRhm8vLBI+LOvhV+LXmtxuOqCEuxO7dr95MwmH0vAKBl/Q4JWlVQRsyE7hMgRbDkrZFbgs8lCHpihqZd6DHCapB1aRkHDdFw1ssQKIv4n5WlMztLHKqO0wI/HoQP+lpcfkliC926Deh163CktJahybSYMjkJquNAudA67BvMudtFunxz7LEVTikFypZ9Vchc6oTx2nC9TpxNILpDqm73V8uvtY9okqEkzmlQJ0Z69EeNyuAtVS1wqV/nd1Q/32SfyuRdYeYT02QDOuz+wVPeRTtE684jEqPp9WYvSMZ/LlwXkP5Aj+kag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66556008)(54906003)(8936002)(7416002)(66476007)(110136005)(38100700002)(2906002)(38350700002)(6512007)(5660300002)(66946007)(9686003)(6666004)(6506007)(186003)(86362001)(316002)(8676002)(44832011)(4326008)(508600001)(6486002)(26005)(83380400001)(33656002)(52116002)(33716001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XaL7bXcqhgmJ+SEeyp2n76ezEWhkFoQSzycOBMm79HmyVMfKHrJXYAq4xa5u?=
 =?us-ascii?Q?SwbLQh+ezY0FZFHgraeZ5Tfxkr/5ysO6Ofzer8ITcrNNFNXb+WEoEhHOCrE6?=
 =?us-ascii?Q?vUS3d010KpDSDT2SfimoZF/DwwC4kSvaUh+/AvWqT36/tplwF+0Kccp3MtmZ?=
 =?us-ascii?Q?U1G/SmceogdqWAqjwwIcFPKFRDht/9TtyObFHHMEtjtQJaytoB6FUBZhikWh?=
 =?us-ascii?Q?533xXsYF/fqP7EB1IGNE9IM/uT7kucw8B7oNbs34h8EYuH55mlZJX1iB/6J5?=
 =?us-ascii?Q?YlZg+Mdhrpmv7fKppLIuUenBOrRkiJNJJ0DONtHkuZrJ9M8gkgAe3hxND9KQ?=
 =?us-ascii?Q?uSc961RDhQFZ6qGnVwrR2EnIOOj+VA/5Is0xTA804N3n+JtA4JflM3frPfmG?=
 =?us-ascii?Q?7b+U9evAmkYNwuAQTAkpatLWWTIydk5Q0cirW6ro4jY99A9OYHZ2h/kJNDIw?=
 =?us-ascii?Q?u9/r7i7ybuW889s3AY6IqcusSOkFPbDqcRJatmghYxCNVCqDNktXbkPXNWPY?=
 =?us-ascii?Q?jQMdeSvd7sGRU+oQR0jFdSLFdcrwmFaBPvaePjncqwj+GbsWRw5wqDN/FOuu?=
 =?us-ascii?Q?E0HdVShWr7H6s9uG6hf38Fe+3gtl8lfmcIIjTMwdlnT2rSQ5/cWJ3NrHg7oi?=
 =?us-ascii?Q?CWgZwQJ0VFWq4n0TIlNrFfYnwpUkK8EUx3mglaEJcwrnOHRvSHIu/5K4333K?=
 =?us-ascii?Q?bFtPzcMSm76918CXLpZD4DJ3afsmdrtkaVgZK5jvqybOAuy05RsInW9vYK5w?=
 =?us-ascii?Q?fqG0xmNL+X0w6OfG74XS1OeyghqS3uFhIJHokQE9Uer9LygY3UnpaLagGXbD?=
 =?us-ascii?Q?H71DpWzMxIUqHotLqlmkDPl22Yk3gqFQ4icPTlmfEfK97aCosguy9XDnycnS?=
 =?us-ascii?Q?dtz+zZjzs1D07VwQDEiMQ+Fei0IgW5XPxqfY0YSnrNNW5gTSr6zlt5Dx6SDC?=
 =?us-ascii?Q?2V9wunN3ykGKSsP/HtI5HdKIPbePqP5O4MpyOqrzL8zJUbINrgGCbdycbgiB?=
 =?us-ascii?Q?vHOvythO26F1R6QrkBiKSgzXxGISoQO9GFfrm9vhCsWPlB8B23Iy3AG73t4K?=
 =?us-ascii?Q?tMe5PxBGKqtv3E1AURrrNcB9zDByWI5JHOthAN2R87HM41zWSOt63iRS8TUM?=
 =?us-ascii?Q?AH3CGMffML0lyCIjNmZeTLhW6+D95unV949JnGGLqRNzYDUM0mB3DIjdsSb2?=
 =?us-ascii?Q?6x6fGszlYWpw1ZehpLLwBOo6aW45jRkb3sBG7QhqLAAGUBDh7fci4YQSYNRi?=
 =?us-ascii?Q?+l5+WT3tXQaiR4VrbnCWpO0DEPXocdpUKBjjgxv4B93ME4LadKC/kB3/WVGB?=
 =?us-ascii?Q?MKWBYp98ucfyPwG6upLIKLc1h8mGIeZXmG3T27Tco0ONnFJYcAcCTA2VlJCW?=
 =?us-ascii?Q?itFW9Or7N2jr6t84Z8rBKCSVsiVWnBDEFgRojblPFyI1VIMLYTlriyAO8D1W?=
 =?us-ascii?Q?66dwyn0TxzoLrLcCZ7MlS35jiDbvB3p30LlUhBCNmpaenIoqj6MRyUWQ1/ZC?=
 =?us-ascii?Q?VXxci51lf8LGtsVwACb31Q9RCe0YzS6ztxhfnM68evNBgXQ3NCCtWsP5fGm9?=
 =?us-ascii?Q?ygZDm205Fk1ySUecu2Tak7YSZZxuTMtRXDKRSKPwssGJbTLZH0nL+ZHRmVRU?=
 =?us-ascii?Q?0SRGUQBkK1NOTu25du68nvbsUz4GqCYSfJucnbGXE47CtJ6RI1anjJHJR3Z6?=
 =?us-ascii?Q?Sj7tPVlpajsjhzL/mIPeiZWFhps=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f57e2be-b51b-4ac6-5752-08d9e63c0899
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 11:06:17.1328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a+EokbtuxFNU8HRaZOrx30ZV6aUbxqJyBdjhDS2orcvRg6edJlu/kh9Jhf4//aA6RyWTdUE1LYGMNmrbkIzCW49BRKCe1uEMQHwIYleu6D8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2111
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10245 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202020059
X-Proofpoint-GUID: Es9NMPL71DIJp6gVpDwSKCgejQSoZ-JZ
X-Proofpoint-ORIG-GUID: Es9NMPL71DIJp6gVpDwSKCgejQSoZ-JZ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 02, 2022 at 02:10:40AM -0800, Joe Perches wrote:
> On Wed, 2022-02-02 at 08:02 +0300, Dan Carpenter wrote:
> > On Mon, Jan 31, 2022 at 02:53:40AM +0000, Pkshih wrote:
> > > On Sun, 2022-01-30 at 22:37 +0000, Colin Ian King wrote:
> > > 
> > > When I check this patch, I find there is no 'break' for default case.
> > > Do we need one? like
> > > 
> > > @@ -226,6 +226,7 @@ void rtl_cam_empty_entry(struct ieee80211_hw *hw, u8 uc_index)
> > >                 break;
> > >         default:
> > >                 ul_encalgo = rtlpriv->cfg->maps[SEC_CAM_AES];
> > > +               break;
> > 
> > No, it's not necessary.  The choice of style is up to the original
> > developer.
> 
> every case should have one.
> 
> Documentation/process/deprecated.rst:
> 
> All switch/case blocks must end in one of:
> 
> * break;
> * fallthrough;
> * continue;
> * goto <label>;
> * return [expression];
> 

I doubt that's what Kees had in mind when he wrote that.

The extra break statement doesn't improve readability.  It also doesn't
hurt readability.

There is no reason to add a break statement after a default case.  No
one is going to add another case after the default case.  And if they
do then a dozen static analysis tools will complain about the missing
break.

I looked through the code to see if break statements were more common
than non-break statement code.  Both seem pretty common.  I got bored
really quickly though and my sample might not have been representative.

regards,
dan carpenter
