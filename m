Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1614B4F8413
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 17:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345154AbiDGPwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 11:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbiDGPwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 11:52:02 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2062.outbound.protection.outlook.com [40.107.223.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFAD13F0A;
        Thu,  7 Apr 2022 08:50:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6w1FXA4eMDORYRr735QJZr8StPkns2hP8KRu48f1MtQPYfEs8llGFOqmxxpa9bkGIyGw9Wi7IUJMt/KbTm/cTzoY+w3GJPWigpza0w3mhc8Mvud9wdvpulI58AnqVmrY7DinmGmt0UQe0LOfhU6P4nTcsYJiJuQ/yySso4nMNV99kv3kXKbRTCY9BKkRTPg3E+dGL1QnhIlRnIcJp3EAMcsdGk+UzSpeHzJqFjTBDV/QVx5mtyBZhel/0kvXryTZoVfcv0RKRymuECX3PTEWYmTo/K+ybyBG0BMZlXJojaRpZetyjhx2sTPMvGkuaD27VJX3+DgPYY6VFrsdG8OwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ghzqX1IhvzJx3ltuGkwaBJE6I1n282cOVF/fxr107V0=;
 b=cd0SkMfY4aTwK/5aPJiJdFS0TdOmR/pt6f5dUcotxsrm3mXJq4FJ8h9V6EtQTkP5fN9LxTFnqVCnW6w4wfjJfh0+afvratOxA+8NprF+j8ZD0ZkrWXdFZOaInbQ9qTdLYxImuiwJSiE/EK54HUKrq2LZsDT0EhPcmcjHPZHfsY3wFyfU1Uv6LeyGb2niTzafs1cZEs146jD3PTilMaUXeWS8ZXon2jJejFZ7ArotO3lFw+i7EgsrFhdm3viRr4q+lD6rWNK9Whrqo3Wq9HuG28VnwrDa3v5Z+HFJRVdaTM3vzmuay9Y+0j2KnfdV8XnbY0KVyHOHZlHuUDKFClHUBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghzqX1IhvzJx3ltuGkwaBJE6I1n282cOVF/fxr107V0=;
 b=PubAPZGbyAGiszbgpUJ57j/YAsJRjAaKkXtIRxYU8fgIGej6BqMkNWO5UEKGwebzwRN8r0DqfDQhqhM/++zwTBXuVc/vuh2uy6luqogkBWYqXYNwrwnwdUEVvNofHmtgj1kmA5VTv9FwU7n9I2sqhwA2TrPVL8SaBu+pCZmFj1mh0NqtSd0ERt8BJ0+Writp70BnV3hBj8NdWz9J3DZ8Bh1+nvyb4zjDudXRu5+m8sdnkNBv/HKAqzI7Yj99SFJtMGFFCxi4TLet3G64dfzY0TxcC1UhagqN/EG/9loCJdRr6Pl0j7vZMMGe7GYC8W1/cFQhME/Qjl2OqkuX7KrjDQ==
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by CH2PR12MB3975.namprd12.prod.outlook.com (2603:10b6:610:2f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 15:50:00 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Thu, 7 Apr
 2022 15:49:58 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 15:49:58 +0000
Date:   Thu, 7 Apr 2022 12:49:56 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Ariel Elior <aelior@marvell.com>, Anna Schumaker <anna@kernel.org>,
        Jens Axboe <axboe@fb.com>,
        Christian Benvenuti <benve@cisco.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rds-devel@oss.oracle.com,
        Sagi Grimberg <sagi@grimberg.me>,
        samba-technical@lists.samba.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        target-devel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH v2] RDMA: Split kernel-only global device caps from
 uverbs device caps
Message-ID: <20220407154956.GO2120790@nvidia.com>
References: <0-v2-22c19e565eef+139a-kern_caps_jgg@nvidia.com>
 <810e22f7-a48c-dd65-5665-8db757f3ae29@nvidia.com>
 <20220406215431.GK2120790@nvidia.com>
 <6f577f5e-deb8-b961-ef45-1aa31f440578@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f577f5e-deb8-b961-ef45-1aa31f440578@nvidia.com>
X-ClientProxiedBy: CH0PR03CA0357.namprd03.prod.outlook.com
 (2603:10b6:610:11a::6) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: adee98ab-983e-4ef7-52c7-08da18ae4481
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|CH2PR12MB3975:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3176296B88F65369EFF0C7E2C2E69@BYAPR12MB3176.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BuDqb8FCGJLzkTnT3rwR8uIoc/ekhR1PydvVn8unn3TFHO9KVWfHy/mn7WhPK627+myRP1mnjfvS6NIo5qyiuGs0vRBVboJ6Zrc4BQInvyvMgam5Vfzt+kmdA2qnlkYp18XsQHavMcAcBotcEE9mWK2Y7UKjCZZaNMxC72HVPENFzupvI+DjBiQlgKgfbaLZUkz9hFLynYasbijFoYGHV3zg2ERCpKCQCOB3p8ZIb9+S4oAiaTPj6kHEascCQKe6pX5BxQvRvB5cDL4uZhoFYqsKm9ddOon9FWXjBRStH/mZ3E0E4myjyRR/jIQPRCNnUC+DYfc+aHKiZ1Fb7jmrJZ3b1tDgEGtHTVcVfwzXF5pwLSnknlurHdaYaiqz5a5hUMnmodV+LlGd45NxTBrwzpsl59sysWi8tOH3lFKRl1nVMkNVtYT/cJpnqn1xLgFsWT/JWY3TWAufKhbAHxYyZPPGPy+9yU3Yx7pKzamCRtsmZ/YSROaeOpWelVIxId4bSvFzy43/5v1J/Mdo68/l7r5CGYBjh34zMoYvs//CgzAuzKq4I++fODedrJycyF/OOnMdqbLJTVU5cHp0/InTMzlt7jH6jbRLHfKPq+Hh6fmOuvyJnAG3WCp9k3Wg1xXpArFFpPqcR/3FdBixGgNYiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(7416002)(316002)(6636002)(186003)(33656002)(1076003)(37006003)(7406005)(54906003)(2906002)(26005)(8936002)(5660300002)(508600001)(2616005)(36756003)(6862004)(4326008)(66946007)(8676002)(86362001)(6512007)(66556008)(66476007)(6486002)(6506007)(53546011)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CDYiWlfPkj+Fd6VsWscXKRw91wUTA98aeOwPfcSN8BVMEDwu3f1tVcSC0sle?=
 =?us-ascii?Q?yw5RR2+GVpWi/TrfUDPFz06GYp+1iuC81wY1FDb9K9QNKmIK4W8lWpRalY89?=
 =?us-ascii?Q?zeYfhwpLHTPQAqrY5zt8FoBdjYQ40dOidPxFWlZDqTcPY3FbcMn5fuzkbZnT?=
 =?us-ascii?Q?UBgPbKHce+KpILHNsGmk94pdxxW6cazxqqUkOucvA+rJ3V9SBnrXFF7xpBMO?=
 =?us-ascii?Q?oNWCqS9BAmmOYVfBVuWrt2HTA98MrQia5GkxZ2h7hUi+FFHuuPK8ers1n67j?=
 =?us-ascii?Q?a+X1/u97DgCNmIpAuNRZeC8LIzXcEh0IEGlvTGbcOgNg2ZAO3w56NwOT2ga4?=
 =?us-ascii?Q?D54eVO4XI+lU8lyWBASsI/41HuwYFhzvqF5fhTwW8B5h0+Me+KCVh9kvTpwQ?=
 =?us-ascii?Q?KQLGbyLw0fCLOFIl8DpCroi0HkF4IIIFm5l2sOZnbVroY4Hrk3dlSfJxqOb+?=
 =?us-ascii?Q?lxoJvBhNhuGgGvWS+aOhBd/2212UMqTZXSRaTGkX8w6l/RhAxaEtRPFWMlpo?=
 =?us-ascii?Q?AjXNPurybrbLw56TGu7r8SNKEt7dVqIutAk7nmOKdktqqs9V16ZOsirAqSKR?=
 =?us-ascii?Q?QiPl0kWhTHQ57pyA3hyV7Vd2VZSF0rzdxJL+ONdNobdL8lmT1yNB2ykzOUze?=
 =?us-ascii?Q?sIWOj3xMWGNj9elj2HmaKdDel33Lm32x1Jg2voRr12K5v/zDQ9F1b587vMVy?=
 =?us-ascii?Q?p3m03jVWs2eWEJQmlzuq8CX/Owo5fMfXMue51yj5lO/RY/LjTNdukPXMUtCT?=
 =?us-ascii?Q?FC5+2G0hy/N8y3mjhLQyx4bG3hos1H59YBKxehNf3+UrBtNAY7u+PEwoDRix?=
 =?us-ascii?Q?FHYlPWkADOe/hUF2ZGX//6khqyWTXyWGreYLgn9EwqyLDtfIlTPe8wmxx0I9?=
 =?us-ascii?Q?gED47GnL3Z8E/TKL2j/noZ/rkUlszp/sAPeRxVH4qxbkJemI2MJB3ytY7RgG?=
 =?us-ascii?Q?SRWb9/Dgt0Z9ASpJYKr6+L3fcFa/i48o7NMbpx+SM7YG7qqLh0/6A9rl2P4a?=
 =?us-ascii?Q?lUY6xxgDF++pD1/xp8yTz1prSiFFwgGeRU3FfYq7Vz69ktrcXWpJS/fLlIA1?=
 =?us-ascii?Q?1f9JHToHwcbrPoLluqUNCQ4PafDvTTHY4pnwjF467Sh7NyfxptOcgTaSTmlv?=
 =?us-ascii?Q?uM13yHKH44WNfo44BCuyaE6D/Ooz26a7OYMjCGQrahNlFAY4qzWRF/vBfax2?=
 =?us-ascii?Q?a07/9SeT7HrLsNibpLW0vzxIVzHsUTwUKaEBExqNbwHraQ07nwyRt6EOJ513?=
 =?us-ascii?Q?GMg65otqkgBkfGxBe9muabkdiXAspWeK8v2cUUptg99fKcyyzeQ8Qwxmgl9Y?=
 =?us-ascii?Q?E6TX391tlLklOULqORkAXHf7sQDfzSpJtFguDL9zJrdVHHoT74Q9wOZCNVEE?=
 =?us-ascii?Q?wzh0y/0hKHlrHSTeDKDhq/mBR4DBp5FALTfHig9qBBbT4ibFte5jcsw122jt?=
 =?us-ascii?Q?8J1euP99iiguQE959L+v5hUH9M+FEOCdZaPzNwr2kj15MYCN7gyXpu1vx4Bx?=
 =?us-ascii?Q?9RO1u1thEsR7WH30t6Ir8rTX1jOTtPz9SEZy3T0BYDYNzdYaoIin+4FU7HHG?=
 =?us-ascii?Q?45HAhvl9phWgTR5vLCjQRX0aZZT3MIsxl4ylv+xNy9xBX3bNxcWq+TmbSW1l?=
 =?us-ascii?Q?FmR+X3fiup4bmNDhfZ9vd66o2pl0hej/S3ezK87zdPJLUAfEshDoGj4PsW9I?=
 =?us-ascii?Q?CwIbvuLy7vTyok9tgCSwMpA7CMn5C2w14O1swH9rEUKG+WUGCo4R8pkIfNS+?=
 =?us-ascii?Q?KzkxQDwk+w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adee98ab-983e-4ef7-52c7-08da18ae4481
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 15:49:58.0454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d+IT6Y49z7fOtfHZSJ+YIqU+AsNZMeHd4ZIp9WCCB/9zyVcvpuE61riQCn7raz3u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3975
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 10:09:04AM +0300, Max Gurtovoy wrote:
> 
> On 4/7/2022 12:54 AM, Jason Gunthorpe wrote:
> > On Thu, Apr 07, 2022 at 12:01:44AM +0300, Max Gurtovoy wrote:
> > 
> > > > @@ -267,59 +258,53 @@ enum ib_device_cap_flags {
> > > >    	 * stag.
> > > >    	 */
> > > >    	IB_DEVICE_MEM_MGT_EXTENSIONS = IB_UVERBS_DEVICE_MEM_MGT_EXTENSIONS,
> > > MEM_MGT_EXTENSIONS is used also in the kernel ULPs (storage)
> > It is not about where it is used, it is about if it is part of the
> > uapi or not. Cleanly separating uapi from not uapi
> 
> from the commit message:
> 
> "
> 
> This cleanly splits out the uverbs flags from the kernel flags to avoid
> confusion in the flags bitmap.
> 
> "
> 
> so it was not clear, at least to me, that some user flags are part of both
> the uapi and the kapi.

I tidied it a bit:

 Split out flags from ib_device::device_cap_flags that are only used
 internally to the kernel into kernel_cap_flags that is not part of the
 uapi. This limits the device_cap_flags to being the same bitmap that will
 be copied to userspace.

Thanks,
Jason
