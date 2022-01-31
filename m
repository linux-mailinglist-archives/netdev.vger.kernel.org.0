Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9063D4A47F6
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 14:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377541AbiAaNXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 08:23:13 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:2468 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376589AbiAaNXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 08:23:12 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VAThHe019151;
        Mon, 31 Jan 2022 13:23:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=7VTflFPpvvIjoJRuq+gGxX9hfCZ5qUNQtmWor8yG0A4=;
 b=asy47KY1xTWjwfW/2prLV6FrQaehO0TUhvJf7Jfrby42kVs5R8u1XuNiop2Kp9UZPPdF
 ZCG6j/Ro/3YEsNzvGG7yoBRLQqtWmeiXuHmNPkZUayQtMIZfzoHZxR/ADFB+87bE3unB
 9of+tNXPUdnEYWrtYZAvpIX1hCAaXQ72QQXVGKiRmPWp1A7N2XUXlvNScBfxSRhlTVFL
 oV6SN+KScFLf8HoCptExii13wabGdjZwI9B1FDtHX3EPJKy8DdLDvE2Kal8IYVyFD3xO
 q4P0I+u/OHrKZ7NjGiZ0BwA1dWHfOp9lpXPTzOHjjejZdZGhInyucZs8kTNXr822zfRv Kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dvwfb3wx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 13:23:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20VDGFOo117135;
        Mon, 31 Jan 2022 13:23:05 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by userp3020.oracle.com with ESMTP id 3dvy1mpmsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 13:23:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c9MCDh4CZnCNQCkum50S4CP7q6I/VTQFe5i6IgmjQ9IsgFQwkKU45ONKT7bEb+ZTpQh4zIIsVwpo/pzwFbUcstpzJK8Kqkqo2CBtzTXoZgVODk3cIQuvSftFyveyvijRvU8ffSQde3lPTdRowoTJPJRqTFj3ZZ8ZLB5z0AqhX0/cNuXncQ8M3SXg7+ogU1ESwtIg2GFeo0sGC8oKggKZ6JHuyiYMIxxgAAFeugl1do8O1brNdQwcxxYmIGlbTi0Vf9bVuHx3wOsPz8ZtIpWaxr1Mj3xtDsui/sDAQf9/uD5ilVMidqVHlqwODej5Ln3PB9q8NtippnQMH8HBP+Y/2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7VTflFPpvvIjoJRuq+gGxX9hfCZ5qUNQtmWor8yG0A4=;
 b=bIZM2CwPm0PiYtEP+n36zDvHXY74Ag0l4LhwfXWCQL09CVju6IeQwtZOUzW+ZRR7JNc5dmQhAVDbrwWr468zk1+648x+P3/hKJls0PGL6ObKZWQQq7u8ZSNBPYD+/0PsqbQwrTgx36x+qejGy3/h6847zoOqVjZ+nTtxbpfHCeAotAOW5w+fGfgoi3bRLwO4q7b6BJ+pFsxRF8VtPjWCGrBjIAAqL+DU3kXU0YN4rbfgIwulZRaCRJRuzPq2Geq+WJIpHGSX858xogO85b4tGFO6LxYjaD/sX7Mamwdz7mMwm/JPUtDwwS/qp9FNCy0gb9UPt/gIdgeOs4vM+lTfvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7VTflFPpvvIjoJRuq+gGxX9hfCZ5qUNQtmWor8yG0A4=;
 b=ZeDUmwEpCpDZ6/yNIln5JuG/XPcto9MlrFodWDeKBaxs7vTNvy3wGcibH+LEGgRgdzNadpq7TkVYyYnuLrJJ2IlsG5v8htHxUBxYtKKNZpRBDpP2JyeC9ZhOo2ozlxOV6BSa9ss+6jS/7qEifJlKLOH09iLVYYFpQf197qMICFQ=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SA2PR10MB4620.namprd10.prod.outlook.com
 (2603:10b6:806:fb::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 13:23:02 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8%5]) with mapi id 15.20.4930.021; Mon, 31 Jan 2022
 13:23:02 +0000
Date:   Mon, 31 Jan 2022 16:22:41 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, jreuter@yaina.de, ralf@linux-mips.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ax25: add refcount in ax25_dev to avoid UAF bugs
Message-ID: <20220131132241.GK1951@kadam>
References: <cover.1643343397.git.duoming@zju.edu.cn>
 <855641b37699b6ff501c4bae8370d26f59da9c81.1643343397.git.duoming@zju.edu.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <855641b37699b6ff501c4bae8370d26f59da9c81.1643343397.git.duoming@zju.edu.cn>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0017.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::29)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3b0c6f7-ece7-472c-2281-08d9e4bccec6
X-MS-TrafficTypeDiagnostic: SA2PR10MB4620:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB46208E06D80002C7351C120F8E259@SA2PR10MB4620.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M1OfSdD4ngq6dL3EVRb/zt0IVoMLsQ3GRNbWEJLZeUWsJ1YcBD8Q53vAhVRW04swvNO9pJNU5fva26YKj1aBHbJAwwEnO62rn/x+sAKlDWNRvzgETvJwL8J/Ch/KQ7QzjXyEZTiKFjMXf3jIooHxT8uRD052YMiILwEQAeEUYko3tsIy9Syum8Xuj1lCgua4Ggbl2eYWjbj9i+fUQ7bsTPIGMG2bZCidSChq7373x15emEZlj4+jMXh7EEnkYBZjICnnxEJqR9QrjrDb4vVEE6yifmwPZ0R0Xx5A8Eno1z9wIFPfwaICgdcO4U2LyynUc5aQtH3Qiq46cqGBA2Ug/jHATuRTSFMNQenXki0rgdze8JReudUBQxgg2sns3MxTORZWQyJ9Ec10g16hDVSK3ufyrVrvC1/6Q7sKJVySQA1AbflqE1AYmE+HRMYycKW+uYODuEAKp2ZDOJQtjwwmDm9VbRn5j5BGBYbRCcLmMxanc8DrIHylVEx41a0I6ZDypPflq98wD0GbrRHTavzkKvJEs8BDKy6THrkoNAy+gC+L7Nd4ZW2erbD4Jjd7VDrdglmYmyL8I8pn9WunqCvdz7p5aVExyKlF/V9b4QNtejX6Ub62ThuUsdXS/t9VDQZOlhvRrLd46yDlky84gAgpKI4jYE/7qNKgkh+/60EuDYOyWl9/JWmDxdQ8SCGmIsM7x1/eT0g7KBpXs/jmv2zeUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(38350700002)(38100700002)(86362001)(8936002)(316002)(6916009)(66476007)(66556008)(66946007)(8676002)(4326008)(33716001)(5660300002)(6486002)(186003)(26005)(508600001)(1076003)(52116002)(2906002)(33656002)(83380400001)(6506007)(6512007)(6666004)(9686003)(44832011)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K6EemPVURZpoyiWOx0wyvlVPs7qx/JbtpHMdCKIsGIQ14SzL1ea3dSIVaDPI?=
 =?us-ascii?Q?BYv5y4x0i1oOIkapha8TBzBGKArxLSin+l2Ybzfwj2DzE+fLfMZJV8l2tkhE?=
 =?us-ascii?Q?Wqe4p6IuKkCBYuPd8vgXLb8+Zae8bYZLhH6HI37K+38z2cGUCL5vc0FXV/lt?=
 =?us-ascii?Q?VFxlVupeodFsE7b+Z9mh2y7lREBAcY4y02BrJD1bPOV7Ocx42wtmB10MfwYq?=
 =?us-ascii?Q?45RPXFiNXBLogkc4x7rUMp7HNZAL5NIsklO8ObeNTks10ez0AmBAg0Bup4tQ?=
 =?us-ascii?Q?VV/vU04JfWlU5WS7kwhdRdKPt01cgsMSkPWI7UHrFn5fmzkUVq3VuNW7NVoV?=
 =?us-ascii?Q?dPQFZv3zOiyvum1qyeoFAgt2gy6Y1zU/Or3LNXllTxudnhsmgiJ3fs3GYGYN?=
 =?us-ascii?Q?LV/nUNxK7NbFn0FK3JkF1gfQZP86lStshzfg0PZq0d6U1z4BlT9RmTYIK9+I?=
 =?us-ascii?Q?mGFaz8xsuwgDvPFy7rj+mR63BVzLTdHy91BYspGwXt4MNE7+YHeJNtf7N8vW?=
 =?us-ascii?Q?LbmvC05iK/7myrcQnn8s0BDs/DMYpZbisVXrz5jVCYV9cZUk5L1uCCMwmjA4?=
 =?us-ascii?Q?sNyI/3voe3oaKdvVnfT9a5O2Sd11y3++Wa0E9fy+P4O0Jd0ruAuBltlFrhXp?=
 =?us-ascii?Q?hEg/nAepGd7klqxIYdiJHRCk5oOHKym8pJb7OQ8wnhGsfQaI91RKnp0xkJPt?=
 =?us-ascii?Q?5+BcAuFAhA0FSuHNTDxp+fzX/bUY1L9o/vK1AvkT4NwR7Vcv8fwiU3z5ZJP7?=
 =?us-ascii?Q?8oUQtUlEDGvwR2IXSjMifkAF4P3JHXx3HNRJ7TnfMke8+wtUvwMmsn1TjsHg?=
 =?us-ascii?Q?4v8QvA/rZcbeZgVa7CpPaNcsSiOoG3P1wfPsVFj7f24Sqed9n+ev9eG4ZCwb?=
 =?us-ascii?Q?SqDVOXW8DdrDrMDrlcG+2C9qZSDxapIUneq+H6qselXuJ5VwkytO/h9bqe1c?=
 =?us-ascii?Q?6lH1vYyzdA7VfOJ4a6dtUj9wnXJWxSlGaYU446dGjZVeCbcGv1Vz4w5NcoTA?=
 =?us-ascii?Q?4cYr2j71UaBfvHAF0TCLM639QpjQEvyofbA3KuvEbeyYe0TllX7ZhRexqS5s?=
 =?us-ascii?Q?/CO19TncEH/FveFq/yx30t40PXrJUry+YVPl95S3/at9OzCzmmdr7QvrEom9?=
 =?us-ascii?Q?1ZFuBsZTLB1AUU6K5U7xEBK3sb/WZwmKs6csH+828kXCsoJ5fhv/9rGEaIXj?=
 =?us-ascii?Q?9g+QpaTZ4ByEeMifyHwhYoA9HZnx5Rixp83fVKeixwfM7wnkoV4aSw7PscQg?=
 =?us-ascii?Q?Yf5WUrqeE/waPYWgLsJ/uOmdxvhoQfc/8hF1t19CkHkC0wR8yYpKJymJEPOF?=
 =?us-ascii?Q?fFvpJoUUlWgUL5hw7nya4hr8XFWCTOcH4LGKWl00j9rGR54sM3qSTgJBXy+T?=
 =?us-ascii?Q?FoSnkAEQns81q4vGSHU6NcGoTGyk/tilXZ8HRbu2SjPWiGZlakPPK6v1CfH9?=
 =?us-ascii?Q?96MQB0M8S7T4TuLfSkwWIdcD9HCsGYXqeajzU4louvXSxa48KpEPFvi+9PUU?=
 =?us-ascii?Q?3tJQRT4Con+zVeaACJdYFmtIOUFNxsIdLsHlOkdGSp66qF72SJ2DXie7ByZM?=
 =?us-ascii?Q?JSyNrQ8Yuw4rEcUGBaCmZXYTtVSSBk2D+xIZremkRy+pOFgpXfeza8XBGTqu?=
 =?us-ascii?Q?TNtWmh8Urob1r6am7ZWIP4+Ix1VA2q5geP4Wj2byhLfiAuZQSlgy2/rhXF9f?=
 =?us-ascii?Q?EqekzefFeE0tk2DpQD2HoEd9KgI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3b0c6f7-ece7-472c-2281-08d9e4bccec6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 13:23:02.6211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1MszPGnSuShml0EEj9rwKG20/iYSxMraBeBmvX4/jXLeoeLv9HTH/f02Y8rcw2fbBei/xQegZDVh+1+4TMwGvMWaIYsU4giGNBzzN22aNZE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4620
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10243 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201310089
X-Proofpoint-ORIG-GUID: 6MOMNFZXoKmH3yz--sGOfNSY0l7040XA
X-Proofpoint-GUID: 6MOMNFZXoKmH3yz--sGOfNSY0l7040XA
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 12:47:16PM +0800, Duoming Zhou wrote:
> diff --git a/include/net/ax25.h b/include/net/ax25.h
> index 526e4958919..50b417df622 100644
> --- a/include/net/ax25.h
> +++ b/include/net/ax25.h
> @@ -239,6 +239,7 @@ typedef struct ax25_dev {
>  #if defined(CONFIG_AX25_DAMA_SLAVE) || defined(CONFIG_AX25_DAMA_MASTER)
>  	ax25_dama_info		dama;
>  #endif
> +	refcount_t		refcount;
>  } ax25_dev;
>  
>  typedef struct ax25_cb {
> @@ -293,6 +294,15 @@ static __inline__ void ax25_cb_put(ax25_cb *ax25)
>  	}
>  }
>  
> +#define ax25_dev_hold(__ax25_dev) \
> +	refcount_inc(&((__ax25_dev)->refcount))

Make this an inline function.

> +
> +static __inline__ void ax25_dev_put(ax25_dev *ax25_dev)

Please run checkpatch.pl --strict on your patches.  s/__inline__/inline/

> +{
> +	if (refcount_dec_and_test(&ax25_dev->refcount)) {
> +		kfree(ax25_dev);
> +	}

Delete the extra curly braces.

> +}
>  static inline __be16 ax25_type_trans(struct sk_buff *skb, struct net_device *dev)
>  {
>  	skb->dev      = dev;
> diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
> index 44a8730c26a..32f61978ff2 100644
> --- a/net/ax25/af_ax25.c
> +++ b/net/ax25/af_ax25.c
> @@ -91,6 +91,7 @@ static void ax25_kill_by_device(struct net_device *dev)
>  			spin_unlock_bh(&ax25_list_lock);
>  			lock_sock(sk);
>  			s->ax25_dev = NULL;
> +			ax25_dev_put(ax25_dev);
>  			release_sock(sk);
>  			ax25_disconnect(s, ENETUNREACH);
>  			spin_lock_bh(&ax25_list_lock);
> @@ -439,6 +440,7 @@ static int ax25_ctl_ioctl(const unsigned int cmd, void __user *arg)
>  	  }
>  
>  out_put:
> +	ax25_dev_put(ax25_dev);

The ax25_ctl_ioctl() has a ton of reference leak paths now.  Almost
every return -ESOMETHING needs to be fixed.

>  	ax25_cb_put(ax25);
>  	return ret;
>  
> diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
> index 256fadb94df..770b787fb7b 100644
> --- a/net/ax25/ax25_dev.c
> +++ b/net/ax25/ax25_dev.c
> @@ -37,6 +37,7 @@ ax25_dev *ax25_addr_ax25dev(ax25_address *addr)
>  	for (ax25_dev = ax25_dev_list; ax25_dev != NULL; ax25_dev = ax25_dev->next)
>  		if (ax25cmp(addr, (const ax25_address *)ax25_dev->dev->dev_addr) == 0) {
>  			res = ax25_dev;
> +			ax25_dev_hold(ax25_dev);
>  		}
>  	spin_unlock_bh(&ax25_dev_lock);
>  
> @@ -56,6 +57,7 @@ void ax25_dev_device_up(struct net_device *dev)
>  		return;
>  	}
>  
> +	refcount_set(&ax25_dev->refcount, 1);
>  	dev->ax25_ptr     = ax25_dev;
>  	ax25_dev->dev     = dev;
>  	dev_hold_track(dev, &ax25_dev->dev_tracker, GFP_ATOMIC);
> @@ -83,6 +85,7 @@ void ax25_dev_device_up(struct net_device *dev)
>  	spin_lock_bh(&ax25_dev_lock);
>  	ax25_dev->next = ax25_dev_list;
>  	ax25_dev_list  = ax25_dev;
> +	ax25_dev_hold(ax25_dev);
>  	spin_unlock_bh(&ax25_dev_lock);
>  
>  	ax25_register_dev_sysctl(ax25_dev);
> @@ -112,20 +115,22 @@ void ax25_dev_device_down(struct net_device *dev)
>  
>  	if ((s = ax25_dev_list) == ax25_dev) {
>  		ax25_dev_list = s->next;
> +		ax25_dev_put(ax25_dev);

Do we not have to call ax25_dev_hold(s->next)?

>  		spin_unlock_bh(&ax25_dev_lock);
>  		dev->ax25_ptr = NULL;
>  		dev_put_track(dev, &ax25_dev->dev_tracker);
> -		kfree(ax25_dev);
> +		ax25_dev_put(ax25_dev);
>  		return;
>  	}
>  
>  	while (s != NULL && s->next != NULL) {
>  		if (s->next == ax25_dev) {
>  			s->next = ax25_dev->next;
> +			ax25_dev_put(ax25_dev);

ax25_dev_hold(ax25_dev->next)?

>  			spin_unlock_bh(&ax25_dev_lock);
>  			dev->ax25_ptr = NULL;
>  			dev_put_track(dev, &ax25_dev->dev_tracker);
> -			kfree(ax25_dev);
> +			ax25_dev_put(ax25_dev);
>  			return;
>  		}
>  
> @@ -133,6 +138,7 @@ void ax25_dev_device_down(struct net_device *dev)
>  	}
>  	spin_unlock_bh(&ax25_dev_lock);
>  	dev->ax25_ptr = NULL;
> +	ax25_dev_put(ax25_dev);
>  }
>  
>  int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
> @@ -149,6 +155,7 @@ int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
>  		if (ax25_dev->forward != NULL)
>  			return -EINVAL;

Every return -ERROR; in this function leaks reference counts.  This one
should drop the reference for both fwd_dev and ax25_dev.


>  		ax25_dev->forward = fwd_dev->dev;
> +		ax25_dev_put(fwd_dev);
>  		break;
>  
>  	case SIOCAX25DELFWD:

regards,
dan carpenter

