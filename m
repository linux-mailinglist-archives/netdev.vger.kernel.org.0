Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D0E41ADDC
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 13:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240483AbhI1Ld0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 07:33:26 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:7606 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240449AbhI1LdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 07:33:15 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SAxF05028569;
        Tue, 28 Sep 2021 11:31:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=08lIf9vqpeWO1FQeZmR9Lr9WaBAuDsfpixGvxyY+khU=;
 b=AAVo5QTtQZiRZ3vxJVc737GBsmVvFGflGCeQFGBQdyz7g7LtVssUwqvcbupAUrPaBD+n
 bapPcilOdV+dTZ/5wKCoKYV/KediKjtgsrT5oQEzHiZMSIl0vGUeR7LQPflB3ATdiI8c
 QN002De+lJJxqkFGCsBcrIbMvr+u4+FHMjBZgLsRzZly292GUMijT2AQDTB66C7IM6w3
 EvX3izbmGfGcaKnwmdS6NmfHh3mg0YNmnnCNGU24DpLcW0H26CSdXoHHcPiAzfaxhkfD
 Dr39FnROH5iN1uhi6Z96pYkxrwmH7MJNPDq9bAXRWJBHONnrliZ9LrWn0AmfBG8hxKYA dA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbhvbx228-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 11:31:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18SBVDIG069465;
        Tue, 28 Sep 2021 11:31:16 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by aserp3020.oracle.com with ESMTP id 3b9x51y7nk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 11:31:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nirHWrN/4lY8OkG9xipx8MVSvMSOKdbAkob3GdX6qTvFsoNcYme+F/BHoe793kxwf5Ut3PIMM3R4wdjq056Cgvm0AU7+OTi73Oh01qGzO2RIIRlVxgQkghaQJi9OdFokLWvnQTSyJtrfw28sS16jZaCOggkQiiGp4NGedN9iWL1Ysi/lrXUBbMk207hw4Vg3cULAqz9xLmwKTzkRG88qmHlm7iF/ZliD5vQnl0jrgPWnQiwTHY4qk+IvTqDi1q3Zq+ZBL4u2ayYs/XpO0ZFIAVyAlhQxnPFOUs0Ldb5J5Lycc2o4FwOWX55CDenvK1C3iclXtqLJ4M7lJ709QLjVzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=08lIf9vqpeWO1FQeZmR9Lr9WaBAuDsfpixGvxyY+khU=;
 b=gFFnEcJA06ek48NEUbnqdKCh7tEDKP017q2q6I16lkgwfUQ03tTK304rifgzSmAhosovKHF7bnqQAeE/VOJIve+czq1Bd5gFRWM6WtVzerCgwPDtJ/KLbiLTouxuXNQD8y/K7IYd3nFZCpg/K+YLGEkWrXuCakwFFCYmYwc39ZGKB9a/Juqb79G5i1naxC9GfGLk3CoL1NH99NqicoR0TNKwQ99cS7FQdX61IYJnxWzNfliak+rUpPGafAo/dsakVHc+ejwRGzfdw+MrnZ+DMFzqfsbVqMLT04m5/bA7g6u5CNIvfifQETzgmXyvdmlvNMQj0lgxbZ7Dmg4ebBJrDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=08lIf9vqpeWO1FQeZmR9Lr9WaBAuDsfpixGvxyY+khU=;
 b=SILEg64Wdb3fw6cocsWsFKJFiXRMNCq0PxnCUcj/SlUUifpdkW3Q3tyFGiyYSG4lTX1nSgTzR4hbnII3wTLFQgVKA+5/IhJ3z0K136nf89J4i4WKOZVM4tpsx0JRqCjlGk0UfkR/mkyXNyzcw5fneBXI6851W3bkGPKZlZKvJks=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2205.namprd10.prod.outlook.com
 (2603:10b6:301:2d::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13; Tue, 28 Sep
 2021 11:31:13 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 11:31:13 +0000
Date:   Tue, 28 Sep 2021 14:30:55 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Yanfei Xu <yanfei.xu@windriver.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, p.zabel@pengutronix.de,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>
Subject: Re: [PATCH] net: mdiobus: Fix memory leak in __mdiobus_register
Message-ID: <20210928113055.GN2083@kadam>
References: <20210926045313.2267655-1-yanfei.xu@windriver.com>
 <20210928085549.GA6559@kili>
 <20210928092657.GI2048@kadam>
 <6f90fa0f-6d3b-0ca7-e894-eb971b3b69fa@gmail.com>
 <20210928103908.GJ2048@kadam>
 <63b18426-c39e-d898-08fb-8bfd05b7be9e@gmail.com>
 <20210928105943.GL2083@kadam>
 <283d01f0-d5eb-914e-1bd2-baae0420073c@gmail.com>
 <f587da4b-09dd-4c32-4ee4-5ec8b9ad792f@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f587da4b-09dd-4c32-4ee4-5ec8b9ad792f@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0059.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::12)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNAP275CA0059.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Tue, 28 Sep 2021 11:31:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0c87086-80ee-48e0-14a9-08d982737a23
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2205:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB220515B2FB2B984A54070B7A8EA89@MWHPR1001MB2205.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hs7Y1ILhdnnDV940Tutof2dGykaClhhz5U7Es0YoF7TNZFuV+WP78VxMfA0kdSbpHcCAZVS0U/F1Mle8W+0lRbLs7p201sa7nGqashroiXm2VteaEMQ1AexxX5Y29qmvekPw9ZUpVS9XtMqtf3W3PMxwCRGMwj2+XF7HW2xvO7/aRmWIjr7gwLSrqotEtT2lVjlTsKnvAQFKRHIRxWBD8c59X9bikCZcDbvo6Gd2tCleGeez4kvGNAI8bcpGYRrdH9hDZ6IjdNEtK9E+vAFtVZNx3hrNJ8LBtFqPR/hFe296XmWlvo5aoxjXdXNxKoXkKAe9uXXk15D+sAGP4N/YHDMhs+VQQPoYUwQovTvDICu8Sjb0+mLatDvtlwj+Y8NSnFUgWEqq/jhjn1BUgPFicrYxUb0dmpoBnR2a/w9sundNCBuAeH2kritcDmdxjBW/xmFz0HiJcfJE+8s3r/EfSiaOGvoo8/65ZAIpd3eIpJW/MMgIU4hrs984XkvnUEu7zt3UhlkS28sT2h68MZK5KlvyeX3pgQfFntHpsRKhmlVzndiwQBTqEYkyb9CAlv33enu5/ggurWgRmZw+BxgX/ltdaK1UqmNdDraEU2DjTijOCHqMji5FCLDvGwPr38ypn1SOpLYAH6yN5htvZWsTgLGB8qEHt0H+FcATJU0q48REe/D/sXPcr7neWItvFeksiZYR7NFRmcIhgA0IPBzoPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(8936002)(8676002)(6916009)(7416002)(186003)(38350700002)(9576002)(66946007)(33656002)(956004)(66476007)(66556008)(86362001)(38100700002)(53546011)(6496006)(52116002)(6666004)(33716001)(4744005)(54906003)(44832011)(1076003)(2906002)(55016002)(9686003)(316002)(508600001)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZSU6w4C/t5GoGfxcmOVMVMuOavkko6FyB3lGPLjHsG1hiYnTHgBZCBnBrq2C?=
 =?us-ascii?Q?dqOKzNy4WiLE7jKgEr3JLkqjtMjyhDG0T3gNBOh1lGd7Zeut3sVtVVONqzKg?=
 =?us-ascii?Q?h8I/ZH7yjiZ26r0Gs4tDW5coKeBCEtPTN7sKFtY76DMRq2DC9rYmXM6J7vIB?=
 =?us-ascii?Q?l47gBpaamL73H/fxEmqBPmkrHjoFP9xft8wc0lTjWqAlnKhsQSVoJA4e1J5o?=
 =?us-ascii?Q?je6wLN3a95mG9a9whEwEf2x7wipPaESZC3k0QrJ304/wnZMBZ3hhw1lfA2Z4?=
 =?us-ascii?Q?+x9eWwkbZfoZiZR1WbNoi+mKVV5D4k5F9XQZbot5h9RfxVSPnot23PrskxRn?=
 =?us-ascii?Q?b2MXkn+lpfo87ml2Nu2QYlX+YQ3rCU08V6Dcs5uGfM7HwjNXFadYwJv92c9R?=
 =?us-ascii?Q?x1o15ZYGZ3J5BlvD/Mh13e6yR0HC9wQUGmIQsJOjh+z7i/bk7mq/oCLdQaT6?=
 =?us-ascii?Q?hPTUN3IX2+rBTuutKSpF5h/Su7cK9qful/j+jhIa/t1Qu+lb4Wz8ZMA6Tvkw?=
 =?us-ascii?Q?9rECweBN9dHCwt4qnON/6sTHt/I8IFFg92chZqBu4DxQTewUWEXrNLmFel5m?=
 =?us-ascii?Q?wl6gceIVv2lpcyEzMFbpnYaAs1uJ5s8XWr6wAjJF436k/gEav5MogkxsQXuX?=
 =?us-ascii?Q?XBYYS4upCWr+0qgfFnb5JvcVIozjLAmiHJs4ISY0in0w9Xdgawb/COBbtVjO?=
 =?us-ascii?Q?Ng3vCW0/AiITfhRFcqAweezYg74BcFVT6s3cp3pOv1IuCP69w2zTIuWmz+jg?=
 =?us-ascii?Q?v6dlhl0HTqq6ybYmduCglfelEYv8IXcA1TEHdJiFOLehYmO6CxEclFXSOQrB?=
 =?us-ascii?Q?qfbtGS2JpZ9uBKJTYBylyXBhCcfxB1Q26hbSxhZUUOhFrObd3ktSz7SF1fhD?=
 =?us-ascii?Q?HrSh29Jn67hB3ODNQrqtTX3Ls/uNq9LfH4PLG9bwk8dpijDyA7c4os4viMqT?=
 =?us-ascii?Q?XA22tG7XCMOZNBNc4oYoPnKgdor+vbse4KOKr0nVkN8lyAnWoEtg2yhlmOrA?=
 =?us-ascii?Q?cyfklsB0kbAvGo4HrTjrXTbcsL1RjI7ra6vEcLAP2rZ1NfA6Vdi5BW6wauAD?=
 =?us-ascii?Q?QumXL9QjHoPLp1NFyQmhL6CRHR0CXzTuAU6wwGWKXp8+FSmyzZYAhwHnYM/E?=
 =?us-ascii?Q?D5v+jvmkSV35wu2JyJgENlcOHzY3RJyX9MbLu703vWnJTmnL/4j1a1Wd6Nzu?=
 =?us-ascii?Q?ufuNfwotDYaifP7dOOYQspjOAxYJrtDvzVt/3iapLJ8grRWKZkjaLAAWdKcs?=
 =?us-ascii?Q?jrEgpTcYRKz3PZXCUFWWkUiXqc9BZ5RdD24DkIBIlM03vIC5rnyz2Zy2fjjF?=
 =?us-ascii?Q?mYYOgPFrPeXOfjU6MgJQT/DU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c87086-80ee-48e0-14a9-08d982737a23
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 11:31:13.7231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S38igHaCOCGPHc1A9APvDLRrUjyMMcvkKQ4s3WTUmGOG+pmlaYT736AkRopQvOXPTN1LspmqWJ+wlfHk4CtT89YdqzrUq2Ptv0KL5/q2cLE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2205
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=801
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109280065
X-Proofpoint-ORIG-GUID: E4nu5C1DBWYEKbt4zEx9rC18XeIuIa52
X-Proofpoint-GUID: E4nu5C1DBWYEKbt4zEx9rC18XeIuIa52
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 02:09:06PM +0300, Pavel Skripkin wrote:
> On 9/28/21 14:06, Pavel Skripkin wrote:
> > > It's not actually the same.  The state has to be set before the
> > > device_register() or there is still a leak.
> > > 
> > Ah, I see... I forgot to handle possible device_register() error. Will
> > send v2 soon, thank you
> > 
> > 
> > 
> Wait... Yanfei's patch is already applied to net tree and if I understand
> correctly, calling put_device() 2 times will cause UAF or smth else.
> 

Yes.  It causes a UAF.

Huh...  You're right that the log should say "failed to register".  But
I don't think that's the correct syzbot link for your patch either
because I don't think anyone calls mdiobus_free() if
__devm_mdiobus_register() fails.  I have looked at these callers.  It
would be a bug as well.

Anyway, your patch is required and the __devm_mdiobus_register()
function has leaks as well.  And perhaps there are more bugs we have not
discovered.

regards,
dan carpenter

