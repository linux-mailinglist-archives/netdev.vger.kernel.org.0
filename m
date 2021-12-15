Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0552F475404
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 09:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240689AbhLOIDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 03:03:32 -0500
Received: from mail-mw2nam12lp2042.outbound.protection.outlook.com ([104.47.66.42]:33449
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240682AbhLOIDb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 03:03:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9saqMwqLTZ3vhBM5A+bRPLEPPRNesPSN5EJkcRQOL3mjVolQc/GdhRorka9jyxwyQrqSsTQFWmR+lmzLIkfa5kKSONX7yzTbHoWSRmsaqEc1DU1Aj4adUDisZjXZK74/sqaqptOuqHOmSSG2nwfXyw/n3FOCCUWAFpz4uORFhx9Mqs9y37kO+yDyCQwp4kT0+MHvIx+PA//h+kCdO48VIs8ypcaDUT5L7lhGx2bsImbK8jwl/UqfDyR3m+kiaC+8pEK9jsq1Gi+q+iLARdQNJs9FIoAJBJ6oBKBkuewgHcXq5554yMDogDuK/cFlo1LkPv7gFVRqf6ajtRnnY0jdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rZae3so/vA2RwgSTc1iiLWkZCAXaKbrqrjzfuO0CCw8=;
 b=nXWbMd3ryZG6b7XJq2lgC9viIVAPQEGaSvq1QcSD6EHfIN5utmC756olIJl0598jgakOeuvkFJMCl8TTEfTKMChIubgkZjhR+SLsWaDLtmhhe0pIoUFxjfjxJuxow2UfR8Zs+moR84mXo6XFc3Z8knQSJI1CvOI9qFfN7NIsuP/I5ETbjvYo1uPJZ78o+AS/I18WNojZN0kFl1qJ7CneRAgTyxZ05KMOr1c4e3pP+SIzR4ixeyaxvp5CVlD7VClg6quiN9Olhw/KK6p7f4o/KtXjwipU4/sq7oH9WezLZzKeKcSWwlPCaA4aKs263Uanx8aJMknilBk6WxBiOJcWdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZae3so/vA2RwgSTc1iiLWkZCAXaKbrqrjzfuO0CCw8=;
 b=Qqyle6XNWLL/TkvGPVnvTDQfQZX7SZpf3v5l93jduJwFAjQOmw0Ta8PnZqco7wYFgVthMeUkCtAI6YUEIHC/7TMXCDwIYMc4DLCShRjL9HBP49L7roAGhBfykmlhR39XoUXJm2QsYCwrKepUo0jeV8Cw0RIgnEwnSGqVFmQLxBA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5620.namprd13.prod.outlook.com (2603:10b6:510:13a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.13; Wed, 15 Dec
 2021 08:03:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Wed, 15 Dec 2021
 08:03:28 +0000
Date:   Wed, 15 Dec 2021 09:03:21 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     patchwork-bot+netdevbpf@kernel.org, davem@davemloft.net,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netdev@vger.kernel.org, oss-drivers@corigine.com, roid@nvidia.com,
        baowen.zheng@corigine.com
Subject: Re: [PATCH net] flow_offload: return EOPNOTSUPP for the unsupported
 mpls action type
Message-ID: <20211215080320.GA4870@corigine.com>
References: <20211213144604.23888-1-simon.horman@corigine.com>
 <163948561032.12013.18199280015544778926.git-patchwork-notify@kernel.org>
 <20211214143428.GA463@corigine.com>
 <20211214083355.6c706658@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214083355.6c706658@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0PR04CA0016.eurprd04.prod.outlook.com
 (2603:10a6:208:122::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d59499f-b06c-469f-8d96-08d9bfa160ce
X-MS-TrafficTypeDiagnostic: PH7PR13MB5620:EE_
X-Microsoft-Antispam-PRVS: <PH7PR13MB56205FBF28EFFD4DDD5B71D9E8769@PH7PR13MB5620.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FqHMteQHjmL7okP4/vHVEHgKigT2MtWiCXarOm7kFAcVGXnyJH6LwhwRPXA4fUvBcMoOVW88A8up1ILDRfSHgFI6WkcYldOgl/gJ5QnfDPBP5l4FtKfO/35tGd3EMvzdQk/xBgGZK6GEqT8XkF6ZzfDkuIQsmYZNE/x6YWF6Ni5QYJ8GYEBudk96IP12tDc1EYnLjiShou62oQz0AjhaydyGAiEAM49Zx00g2DkUEnMEoqjeIa1+eVabBYYLVplCIznIRjsoZrhUhWUmYxuADUaJTJG8f1zG0mvIygBSAQIIRyakxDFm7jfWY2L6LLUzPBJ/hZlpiLKDcP/sUfgzKZ9UVLmZ+ggAoVIF+tt8bBiiQjzExnyJkqyiAHzgiEdXTFqj0QvSdn/jTFWWsB6vAnb39jCMx+rivU1koJyWT8n6QOForfOA4Eyu0qtUm5OgToBMYhw+YSBuunewLhX4cF0HpfyqUQ5Dsp5thWQGEqBXf7wdHeD1bF1q9Qq//rzwN3KvZJpjrw5jGj2UJZjldys1WCOo/j4XqRD7yqy+BOdTlk1vp8JNDPDl10kq65eDnhQiAXInfp6JtL+tnDCJrDoUIZsFK2uhYv+QVBe+gmNAOUVM9AtSLzzIPYhlG9PuvguNx8pMmH53czoI92Tx8uln5AeVBwzQYthV0QNIzd4zPMhwteYi4lJZ/Pjfj5lPcuYjGpCx6VoInZF//HpEiAQ+2Glsn10g+woL+/TUsmM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(396003)(376002)(39840400004)(136003)(366004)(4326008)(66476007)(8936002)(86362001)(8676002)(38100700002)(66556008)(1076003)(52116002)(107886003)(2616005)(6916009)(316002)(966005)(6666004)(508600001)(66946007)(2906002)(186003)(36756003)(33656002)(44832011)(6486002)(5660300002)(6506007)(6512007)(4744005)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fqmRmPAf2BDCgMHonzoYh5ywKPbiz8Of8meV95aqv5X0+A7xtF6h+vBy2FWR?=
 =?us-ascii?Q?cRn/tnx9gO8JQPb2QtfoAJqjuvJqp3duUdl1N66bLqcf8LA4bJWfcw8T1btt?=
 =?us-ascii?Q?GdQEmyXxFd/zfB/5TN03QrGOtfOICZqB4LHxDV36UsuhMxaoLEYFFjLIoyq/?=
 =?us-ascii?Q?0SwP1zd927ZlzW3v0trmW0QdeYTXSsEKooYfLNkhCVqVQTPciKyP+nkNUcpQ?=
 =?us-ascii?Q?Szx4MB7ufq2MuCGbmiNEEotvmigqLs4I55y2rwDwafQNu8uxcCQZYEqiqfIo?=
 =?us-ascii?Q?FDv0r9f+ToFmM0WFnviZV2zDyEACeZGbElfsYijbXc9ULg3hO+5QRERlxKKD?=
 =?us-ascii?Q?Caqj0zPBHb3Dzb3lIUq3kAZXuo74/uUcy/p+5xtginaeyblepQ3Vqc2VAFkr?=
 =?us-ascii?Q?rSlJrkEDlXQR3a2wFKrDaZIWYOZMzf9h4SVIHXb3OTH2mQzdrk0xfqAXd1TQ?=
 =?us-ascii?Q?pK+hRa48eQ59PpXT0bq7NYaV0oanTTyOAfDY89lJGU7J7k8cFFonq/3lRUE5?=
 =?us-ascii?Q?ADSmN/zL8xgo8eF2g5tI3DGLF8DyuAh36kVqVVkygaYzQCTot6rP/ozywomv?=
 =?us-ascii?Q?bnKaWBWDw/zMIq7mMKr6PNFv1pCRi9VogHCKg1pxWgug0Huce6X1HpJpis5I?=
 =?us-ascii?Q?10LVOWnNjxLymiig+nC1DPznoEKbBw5yfJLQQXsvEOgTPT/R3xsiAfhFBw5m?=
 =?us-ascii?Q?AsWbecVrbRQn8Hy0U7F3hHBVXufa9iHqmYrwDMA4wTIo5ElocwGLquBhnEj6?=
 =?us-ascii?Q?8/me+dxakW3f5yx+B5eOknUAaP+2MYyda3c+IdXTRlU/86+73DVIYZpPiIPE?=
 =?us-ascii?Q?mvsdrKdagV7CM9n544o/5w8x50taNgvU4YHAKVYYwlCVgB3IySBrsIdJAo8E?=
 =?us-ascii?Q?OTo3QcBKSfO2LgSGhCicrMRhAP19rtkVZAqW+i7tAMnndq/LrTRU2igeeOXi?=
 =?us-ascii?Q?WLSSd+Y8WwC22J5rRnzK6Ft8q7JdN/EkIk024rOaH3zZau8VdrpsVOxtbrsa?=
 =?us-ascii?Q?Jw024kvzFDvm7hIwlfbeHqNiL2Cx7nj05s97PI3/jH01UEKim+pgx+VyQyuO?=
 =?us-ascii?Q?pCHeOKJgbzboH56cZqMnIxA0y2UVFTw1bpE3Hf8UkdHXpGP4dbIhCS/bxswa?=
 =?us-ascii?Q?eJmkF0FzCCemJ+Y3NOCY7JE31BKKef6Vi/rzfzWCWBJ8npxRKIWRe0t62ZwN?=
 =?us-ascii?Q?10OmpxqSTYO32ksomjlogTx8+UPAuphVmuda/12sKRM36qwYw9tEWUJ0SvOt?=
 =?us-ascii?Q?OJqXIqO6I9oiYzQP8Xld7mA2EkqbS8xpIdwUPg29MgSVvTDqm3bwLsJ5FYQ/?=
 =?us-ascii?Q?wSYGD1tzWoF3hdqZy0XdlNFPvCQy4eF6Y8zHkyqL6rt8Azi/ziYEpqP1VZbq?=
 =?us-ascii?Q?Oo06FsGxMJS6NzDbWHCsXaxTPHq8u5nHvHLrJkEo0aC2pG1LMsAUqSQbQfZ1?=
 =?us-ascii?Q?JOnOmjBTykOOntgdZfDyrS9vx4erE2q/Au7md8qI/hXwA/Nrp3/22Hf9h4VM?=
 =?us-ascii?Q?Gtb78aVjuJsiR8QrVEk6Rl9++7sXFWerrN/ISlxQEjQyo+YJc7hWLqqiGlxI?=
 =?us-ascii?Q?eJwgN/8WsXXkABDNxK4d7i61GP6CXptCtIZ9olxumwdrtvjfVLaEgpVYyP7m?=
 =?us-ascii?Q?y75/4hvf7sEf20XQnQi77XHGJ2xFMZMkOX4cz9iF2rK99PVvTCHAniySd7e2?=
 =?us-ascii?Q?h131VhEgMTG9FZNDfyHw+Ot8g2VKWbvlsoYsbpq81ovJ6/O+/pybnIuZrjuO?=
 =?us-ascii?Q?w6MEhX1ZTA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d59499f-b06c-469f-8d96-08d9bfa160ce
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2021 08:03:28.6416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kPZTUT02Cmt8hZ7Ow69iGLO6dKGREuVVQlbymbht6e2/sDf0reo6Uv5Zechatf4QApD61CqH/fS95/kkcBxfKrvnrsPl0mCB4HBEYj/J4K4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5620
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 08:33:55AM -0800, Jakub Kicinski wrote:
> On Tue, 14 Dec 2021 15:34:29 +0100 Simon Horman wrote:
> > Could I ask for a merge of net into net-next?
> > 
> > The patch above will be a dependency for v7 of our metering offload
> > patchset.
> > 
> > Ref: 
> > - [PATCH v6 net-next 00/12] allow user to offload tc action to net device
> >   https://lore.kernel.org/netdev/20211209092806.12336-1-simon.horman@corigine.com/
> 
> Can it wait until Thu? We send PRs and merge every Thu these days.

Sure, no problem.
