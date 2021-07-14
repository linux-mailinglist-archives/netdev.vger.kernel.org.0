Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B943C8038
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 10:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238499AbhGNIgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 04:36:01 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:58678 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238483AbhGNIgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 04:36:00 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16E7VTq5001757;
        Wed, 14 Jul 2021 07:36:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=hMgKIjhX32jowcN5bAaDuxrqNxsUBnXfBGbWx7e7sic=;
 b=dmVhgBtJtZ6LlaPLP1VPqVPvpdnyiFdL+68q4MDEAinEs+aRAZ5BH2iAr9KbKdBmMEyj
 LbTBlDZh0SLa3slbe+wikOKRE5ct8W8P3Q1veIjwZR1vcska2SesH3csay+mGVjj/A1X
 sAu1fW2g/ZiUZNh/mvUJeFIrCvcnm/KE4THxxolmIDqP3+8YrnJsq7+HWZv8aaGEsbSA
 lex97raR1Ye75ygmpRE/o7ysZDEj4wYwXWn6ufH1aNLve8oEMJSg3a0Pws+u7AJGHuvY
 fFgt8FPjyzJNsKIzi/2+TcL72j29kdmoFs0zNr1+zt3luti5jk2DfHoxRies5i9zg1NO 7Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rnxdm8dd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 07:36:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16E7UYZ7131772;
        Wed, 14 Jul 2021 07:36:41 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2043.outbound.protection.outlook.com [104.47.73.43])
        by userp3030.oracle.com with ESMTP id 39q0p7rh4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 07:36:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=abEBAxus8Q+9+836c6rUYL4oftdcKRouzq5IERojzZywdoQbu+WRMpQZ6owmFm8M5FZA7Jf7qgoV6WsOpjsHBMKxJSb5HlmjCgLS+iwHQNw5fu1M+uL+XOIZzGhhmmtdubCqSz5zRJGw1WHV1U8G72DEwCKami6KJ/oKC5zEHH6dsye+u/IljKWZI6dmBN0RWYiaw9HbPB0QUnSM0IR8bFhw0FwNKegQM6k/aLytTufJz3Zt07g5C6IRzFJ2qLecIn1qf2/Yz1Ha15cBJAXAVb/aYlm79gKrurmj922TaYMOIjAopywq4TgorzuJE9Rd1B2+k0DFFFALYJ1G9v6jkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hMgKIjhX32jowcN5bAaDuxrqNxsUBnXfBGbWx7e7sic=;
 b=CYJrl0EY5Saumi4JaT6o5M+37uMyLf/Rd/vl54nPepvwG16QJEYZ2aVLExIA6WrLjNt0FXwE7uOLsAmunQ6oVQdQYAICR8uFLRmKjeYiI8OXHVV/7KrvjTyTjiM0xQU42m23dmDajpAm/ErQDr3ZVfvf5a6ZXccvIsgveObRH0Od01mI7HFf6EoSYR2kXhz3+FN/GpLmvAaNevhfzS94AydAbGAPTAlLuCJ56FvUWNO2CBPiIdH2nGd2fIM4w/f3FDGJmS9ULnt3cZgiV2XNcTQkzkZlXLQ+Y2L58oGNilTMhEDHLiyL4HJzuQPELE1vIge9rwtIOKnKoDGSoMEjfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hMgKIjhX32jowcN5bAaDuxrqNxsUBnXfBGbWx7e7sic=;
 b=B/JnK3iEuwOpGyo1KYypuL+KMQwxA5rQgtqdCj5H98Wc2fPzj+7YmHLvHABiMcpZVUePDpjpTdo93m7benoLpkO74Phd8p3h09D3VIZQ2ld/BSisTHVhN6yAKkE4Wj4yUwZtyLrQePsOTCOXNpPloe9dvLiAFOE8cqrUYDtntkc=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2158.namprd10.prod.outlook.com
 (2603:10b6:301:2d::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 14 Jul
 2021 07:36:38 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73%5]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 07:36:37 +0000
Date:   Wed, 14 Jul 2021 10:36:14 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] usb: hso: fix error handling code of
 hso_create_net_device
Message-ID: <20210714073614.GU1954@kadam>
References: <20210714071547.656587-1-mudongliangabcd@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714071547.656587-1-mudongliangabcd@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0028.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::16)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JNXP275CA0028.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 07:36:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0083f2c9-4765-4805-a258-08d9469a1d19
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2158:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB21581F2688993DF7236404548E139@MWHPR1001MB2158.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RZdfAZEcUCpbFGA39Fb+wFA19qXdybNpA51r3ce2srAjZW4nYHbcFJ2x3+K5u7NfrC59t5ElUZ3w46EW+thXvlMU2QnKlQMEDciuZBxrGneQQ4fi7nq/Gji5Q2wBsrBm0+SgoUHoo4736aOq2+YqUI6VriS73xmM2ciYyrZdW+lk/JJMarAFXn4yEWrSI46UqDPHF+ex51jt3r2UpSO5dHwH9kYfA7CH+FwoqavUlw04vcS+WKG/EL2g8YIiWjQCElx8F1gPDch0PciJa8rRj0AgknOW5Nb5tUzfTqAFrIT10kMnHz0HUzJCOglgPDQIrhgqf5E0C+2KT5YyNjfNSIaEj9GPi7NF8XWsc/60Gud2ntpP7cSvcypfKBzJ0TZoP04G277IoECAk5t0RY3/+syiyVtWyCmrqC9MIitmsCogGSZCKhYHR/UvkMgUjYfyPQ8ChNzXvSrSHf2EYmfmzLlThm+Pn2nebcVM97V0iQ1GS6h9b/dWZr4iE8Vgp9+3D68tsUE3Xe+CuigIilIpvaynKcUHIO/7VtmvGxvthn5cSorLhs98ux+WcHiOK8EfEtOVMqoiqvGrtoncTwA/QiSdWkPAhLV22RJVjAcvhUvjQhmQ7usMM+hUn45uonGX2+MxCfJBzqxYdxT9450T0PFGwKTTfqyKYAdWIh3F3Vr8btqiYzJkhC4fT+chBYuPZoykgFgHAGWPNN/ehah9XnpSWlmnT2ypw6MqMZX+aXDG2aJkgzYYXdXNB3UIJXpiSDLTz5c8LYj8+6Kqs/wXc0iJLuwxts23ZSy2uwSYqgqLZ5+2s6RPCcnxSGy3L+IV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(136003)(366004)(39860400002)(346002)(9686003)(5660300002)(38350700002)(38100700002)(33716001)(8676002)(55016002)(2906002)(6666004)(33656002)(4326008)(26005)(6916009)(7416002)(54906003)(83380400001)(186003)(9576002)(966005)(66946007)(44832011)(1076003)(66556008)(86362001)(956004)(478600001)(8936002)(52116002)(66476007)(6496006)(316002)(99710200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qKvxTAgs+/+mz3g7WaBTy0ozPYfqWq4oubqoh8/ytoOnWJuEw6n+ansA4Yge?=
 =?us-ascii?Q?MokpF6SWZUk33SmCIqQZCxOBAaOo5CBEjH8bDEyHByY3rTvBqgo7VKvky5ue?=
 =?us-ascii?Q?SQ4lZ/oXgiSMAGQKSn2UwJq/acR/3v33eIdmCWQG6olGrhZhdKIArr0Gvd/c?=
 =?us-ascii?Q?4UrH/lE2JRJG+JmE6ObT3UfznTGH0r4Rk25eL8AdLhvUipPV6XENM451wdQM?=
 =?us-ascii?Q?H4XsW+xyAiR3ROiquEOb61xY6Xn8PVM+kYnbal67Q88s9T7x9kquemzCn9i9?=
 =?us-ascii?Q?9YR1xfJXFZRH5vFe5EF6L6lCp/bYbtfgUwpobJeejb2K9RyJDEs2vcnhC++v?=
 =?us-ascii?Q?i8aoupGykrSI4DWmvEmqsbyvdJ34zTJm49DqERUEj/s9FBvMYdg4oxsiHFIa?=
 =?us-ascii?Q?76BIUSVbxAX5wDYItYdiE1Q5jqQjiEr0hebf+Rm6vV1ZQVAM3GdfZ34saK2E?=
 =?us-ascii?Q?7UzJT5s33rVt005tNk1oZ9IMJAnMhpDt3/w9ZE2tmznHzIlVSQMYymthrgyf?=
 =?us-ascii?Q?Qu6w8/dv/EU9kMzHZByOtlkUuzVzXAY5QKk33e9clPWnTrTw3XDG2ko78qGT?=
 =?us-ascii?Q?yMW/wwecGf/nwpRmEkFqZ2VqiVSzMvpFJexql1zSq1XXNRqs9P7LRB2jpF3N?=
 =?us-ascii?Q?a/R4IWryTAGCX0TuHhZZ+DNJUvzV6GbmQFeogOKhRiMmFEEFsY5fvirSyPdZ?=
 =?us-ascii?Q?AmMf07eito1cBudMPVzN4qkLvI+kVV4rFXXHEF5YmtkkehOzc2UgUAZ9kO21?=
 =?us-ascii?Q?W7No+gE/mkCkvVcAv7udlQyaojNlNmrBE9+UsGvNf3HixwGqfb0M0/CEAuJj?=
 =?us-ascii?Q?lLPyW2xly3ctBqm5Cg7HM+1y9Uw1pGZtlFwEgRd82iNU2J8euddoEJY/prRI?=
 =?us-ascii?Q?UIaBqjujRnD9VYq+ngiX27XmBy1pmJGZIU1jDqaHYJG+QCXQDEirSiMGQ5d4?=
 =?us-ascii?Q?VMbK/uSfWl4PlbHMlZltnAAmxwYuDQ1D0C835+HliiRkvMg6NrGznyHCylg+?=
 =?us-ascii?Q?5hVbNTHhXpMcbNFh14U4aYuzWlD4VxWSk7M5Qh0og58jR7rO6d4rwiRgiE21?=
 =?us-ascii?Q?ftuM99aG04xcEij2PhgfoFf4FuueJ9Im/H2Fb0EUs1jYF5rKw/gnwqpkY5Nv?=
 =?us-ascii?Q?Fm9Ro3XkHTexpPX/8mhvQkoA4tHkY9jYuOFbXLeK8Q1J+u1jr1aUfGPkeRGO?=
 =?us-ascii?Q?Bku/G5Q40PrBLKkZxDr2deg8fZtyE1pIDjaEXyP+5oDWU6WALugXKcrl0zrJ?=
 =?us-ascii?Q?kz/a8dupYWscdxiuwsTWBVGDvyOhqqXpFX1jV8OI5V0mREM7Ou0XZNkQudVc?=
 =?us-ascii?Q?3rcqeIrrbBxFTG/oObUmAjJL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0083f2c9-4765-4805-a258-08d9469a1d19
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 07:36:37.8282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kdPL7QYW35VbHtRypVqdD542DiH8Ci/LQt/xSYbzRSwvATufBHYkP26lfsV+WYPMRq5m2WaDDsWFF4kPalWjCTyQaiSVOccCU5Lh1XSRYPc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2158
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107140047
X-Proofpoint-GUID: o06lIh0eD0Z9cn3th8U1a6WLRd0cKSNv
X-Proofpoint-ORIG-GUID: o06lIh0eD0Z9cn3th8U1a6WLRd0cKSNv
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 03:15:32PM +0800, Dongliang Mu wrote:
> The current error handling code of hso_create_net_device is
> hso_free_net_device, no matter which errors lead to. For example,
> WARNING in hso_free_net_device [1].
> 
> Fix this by refactoring the error handling code of
> hso_create_net_device by handling different errors by different code.
> 
> [1] https://syzkaller.appspot.com/bug?id=66eff8d49af1b28370ad342787413e35bbe76efe 
> 
> Reported-by: syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com
> Fixes: 5fcfb6d0bfcd ("hso: fix bailout in error case of probe")
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>  drivers/net/usb/hso.c | 37 +++++++++++++++++++++++++++----------
>  1 file changed, 27 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
> index 54ef8492ca01..90fa4d9fa119 100644
> --- a/drivers/net/usb/hso.c
> +++ b/drivers/net/usb/hso.c
> @@ -2495,7 +2495,9 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
>  			   hso_net_init);
>  	if (!net) {
>  		dev_err(&interface->dev, "Unable to create ethernet device\n");
> -		goto exit;
> +		kfree(hso_dev);
> +	usb_free_urb(hso_net->mux_bulk_tx_urb);

Obviously this wasn't intentional.

> +		return NULL;

But use gotos here.

>  	}
>  
>  	hso_net = netdev_priv(net);
> @@ -2508,13 +2510,13 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
>  				      USB_DIR_IN);
>  	if (!hso_net->in_endp) {
>  		dev_err(&interface->dev, "Can't find BULK IN endpoint\n");
> -		goto exit;
> +		goto err_get_ep;

This is Come From naming style where it says what failed on the line
before.  It's not helpful because we can see what failed.  What we need
to know is what the goto does.

Use Free the Last thing style.  Where you just keep track of the most
recent successful allocation and free it.  That way you don't free
things which aren't allocated, you don't double free things, you don't
dereference uninitialized variables or error points.  Plus it's a very
simple system where when you're reading code you just have to remember
the last thing that was allocated.  Every function must clean up after
itself.  Every allocation function needs a free function.  The goto
names say the variable that is freed.

		goto free_net;

>  	}
>  	hso_net->out_endp = hso_get_ep(interface, USB_ENDPOINT_XFER_BULK,
>  				       USB_DIR_OUT);
>  	if (!hso_net->out_endp) {
>  		dev_err(&interface->dev, "Can't find BULK OUT endpoint\n");
> -		goto exit;
> +		goto err_get_ep;
>  	}
>  	SET_NETDEV_DEV(net, &interface->dev);
>  	SET_NETDEV_DEVTYPE(net, &hso_type);
> @@ -2523,18 +2525,18 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
>  	for (i = 0; i < MUX_BULK_RX_BUF_COUNT; i++) {
>  		hso_net->mux_bulk_rx_urb_pool[i] = usb_alloc_urb(0, GFP_KERNEL);
>  		if (!hso_net->mux_bulk_rx_urb_pool[i])
> -			goto exit;
> +			goto err_mux_bulk_rx;
>  		hso_net->mux_bulk_rx_buf_pool[i] = kzalloc(MUX_BULK_RX_BUF_SIZE,
>  							   GFP_KERNEL);
>  		if (!hso_net->mux_bulk_rx_buf_pool[i])
> -			goto exit;
> +			goto err_mux_bulk_rx;

In a loop then how Free the last thing style works is that you free
that partial allocation before the goto.  And then do a

	while (--i >= 0) {
		free_c();
		free_b();
		free_a();
	}

But in this case your code is fine and simple enough.  No need to be
dogmatic about style so long as the functions are small.

>  	}
>  	hso_net->mux_bulk_tx_urb = usb_alloc_urb(0, GFP_KERNEL);
>  	if (!hso_net->mux_bulk_tx_urb)
> -		goto exit;
> +		goto err_mux_bulk_tx;
>  	hso_net->mux_bulk_tx_buf = kzalloc(MUX_BULK_TX_BUF_SIZE, GFP_KERNEL);
>  	if (!hso_net->mux_bulk_tx_buf)
> -		goto exit;
> +		goto err_mux_bulk_tx;


These gotos are freeing things which haven't been allocated.  Which is
harmless in this case but puzzling.

>  
>  	add_net_device(hso_dev);
>  
> @@ -2542,7 +2544,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
>  	result = register_netdev(net);
>  	if (result) {
>  		dev_err(&interface->dev, "Failed to register device\n");
> -		goto exit;
> +		goto err_register;

In this case register failed and calling unregister_netdev() will lead
to WARN_ON(1) and a stack trace.

>  	}
>  
>  	hso_log_port(hso_dev);
> @@ -2550,8 +2552,23 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
>  	hso_create_rfkill(hso_dev, interface);
>  
>  	return hso_dev;
> -exit:
> -	hso_free_net_device(hso_dev, true);
> +
> +err_register:
> +	unregister_netdev(net);
> +	remove_net_device(hso_dev);
> +err_mux_bulk_tx:
> +	kfree(hso_net->mux_bulk_tx_buf);
> +	hso_net->mux_bulk_tx_buf = NULL;

No need for this.

> +	usb_free_urb(hso_net->mux_bulk_tx_urb);
> +err_mux_bulk_rx:
> +	for (i = 0; i < MUX_BULK_RX_BUF_COUNT; i++) {
> +		usb_free_urb(hso_net->mux_bulk_rx_urb_pool[i]);
> +		kfree(hso_net->mux_bulk_rx_buf_pool[i]);
> +		hso_net->mux_bulk_rx_buf_pool[i] = NULL;

No need.  This memory is just going to be freed.

> +	}
> +err_get_ep:
> +	free_netdev(net);
> +	kfree(hso_dev);
>  	return NULL;
>  }

regards,
dan carpenter
