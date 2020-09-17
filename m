Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4740526DAB0
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 13:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgIQLsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 07:48:40 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:36258 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726823AbgIQLsN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 07:48:13 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 07:48:00 EDT
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f634b970000>; Thu, 17 Sep 2020 19:42:15 +0800
Received: from HKMAIL104.nvidia.com ([10.18.16.13])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Thu, 17 Sep 2020 04:42:15 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Thu, 17 Sep 2020 04:42:15 -0700
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Sep
 2020 11:42:04 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 17 Sep 2020 11:42:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JvUiA4xwntFL2R4SQycP/w25OXPHPVl77F5jWEFo1LhxT7hHtSWdrUsOG/Danxeo7HDydryaLvtzZEWmnPsgCwz+oMttW6LdPQnljXuKs94Gg4LDi5NsEf6K8Tek14cpBl/e7A7ceqBURyZcLv/hu670Urn2eWhB/9um8fRDcODtvBeeaLI4hcZyKeGoiXQ2HgWBLwDuYqXcf3LMOm/zGR1/tXzgNjC2pMtSlnUWyYiXwj0q/30yk1pCSMsPMHpNokzJatXUOHg5UT0iTF9DwnMMbVPRAimeaJ+bSy729RTuFTwlSNLpFcSpSf40rS4mlWYpo3gcyXEuXstD9QpikA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vy8OmMtlr8ET5ylzAjs58xOaSWhYBapenD/Q8WKdeWU=;
 b=PzIr2wDNuNTGlHsXKndqNko7oQw1BFny0V83Tjrw3IWZ0tQK0YZMGuW6rtTC48fahBLS40pucUxfazr07ba9lDzbVBCLLnOPTyMAxzThB16QPtNzj1rFVaBb7XW8RoGEHC6AnPHLy/V2LdCJFj0o+PbRU85Qzi0iLQRhuLP+l+yRG/+jnaDRdIIlRfw114zpbM2dGKEK9xh10FmNnFRDIjHx6nAOS93XvIG2RKE+bY3eYoa1MCrUUfwBF8tY8oDHbnijTGInmJeYavEzsF9chFoZuL/Zap1CJFKMvKzgrgYa+i7P7TSDOiD78ulHDZGOsE9ho7nhdEYcEY8VTRpOxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3403.namprd12.prod.outlook.com (2603:10b6:5:11d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.18; Thu, 17 Sep
 2020 11:41:55 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3391.011; Thu, 17 Sep 2020
 11:41:55 +0000
Date:   Thu, 17 Sep 2020 08:41:54 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Achiad Shochat <achiad@mellanox.com>,
        Adit Ranadive <aditr@vmware.com>,
        Aharon Landau <aharonl@mellanox.com>,
        Ariel Elior <aelior@marvell.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>, <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        "Somnath Kotur" <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>
Subject: Re: [PATCH rdma-next v2 0/3] Fix in-kernel active_speed type
Message-ID: <20200917114154.GH3699@nvidia.com>
References: <20200917090223.1018224-1-leon@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200917090223.1018224-1-leon@kernel.org>
X-ClientProxiedBy: MN2PR12CA0027.namprd12.prod.outlook.com
 (2603:10b6:208:a8::40) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR12CA0027.namprd12.prod.outlook.com (2603:10b6:208:a8::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Thu, 17 Sep 2020 11:41:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kIsIU-000QJF-6D; Thu, 17 Sep 2020 08:41:54 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5a5a970-2fa6-4144-866f-08d85afead89
X-MS-TrafficTypeDiagnostic: DM6PR12MB3403:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3403CADBFEDE27976A11B69BC23E0@DM6PR12MB3403.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6edCIGsgXgi5jrLtNQSGv7rlkR8fFmQ4B8DZ5m1nuaPoAdp0kt4PQKpe41yP2ElTN4nnLECcS3Aih496Ek7TKHGEEPon1ihLrO4hsB5UNNlVCVKuZmR6wY7xKSAEsVDb3KCxSHRUJMk6/GA/+W/Dd9vU7QoSyeV/PcieW9ZlXj/iq6feZ0pNiPrsEp+a7rvvUdAuHnmM8vBdFO5ybwoXM8kRvppCZx5yw//zNMnA7ftkOlsAi/C3bHvbn8K0e3HGZTCLALM1QO72BfeoYjECBRoCWmMxSnV9NKI9Poga2+nfdhZ3zMrj3KM4QByAkNIqPdyv6Bcun4acKSOJA+ClTVSI1T+xBzENJAub9fe/e+b6FtJBsU2SbVnokrScFnuabrxvpXo7sYNqg0c7+GAXk1qhq6qw93S4emRiOXONAUMlbQ6MCRi0zZ/r/6QWR1HyjcRA3QDWDK9QeTNACfsiCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(9786002)(9746002)(1076003)(4744005)(8936002)(478600001)(54906003)(83380400001)(4326008)(6916009)(86362001)(426003)(8676002)(2616005)(2906002)(36756003)(66556008)(66946007)(5660300002)(66476007)(186003)(966005)(316002)(7416002)(33656002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: WcX2kLySIywO3yUNPXx8LStFvnWf3Y9S5iBNrPUNZynyafuT8Kdc8dYsfoh6N8kYHQq4vkLGeZw0EAmsoYj4ihqbGdd1hTW5pboSiB9WUqtrfa9HE3TZrlAW2swwv2qkmKUxS95dR8hbcYPx5AhqGMUjbDwjpVaQNQOMI5ydyHtmtn/oPvxeMKE2zcElydCT0sVkRlMHrHTRXEEqZeYbyfA8yRJFYIkSQjYk+WtVBS2s0aLOeQrZH7l/16JN7SgabmBc1lNkYd8mZacUkSa283FzU7eCTiszTzJjs+jjhyBO8PVEK2WxP6pjRp8yje1ztBPzWsZKIqCFb6b8ZJqT6j9IJskKJpmnfeCAQmp7wbmCoInfAtfGkStnRpa99A5o1D2eOAcQrNUAzMAtx0wFaKUmKel5tpp+ut6dXKNkKi8H6uzipginQb+iFd39JDZmUIk3d6DHzY/F7UG0rbu/Qvr0fHOtnsp+zP0KAYv/6H2Dzy4+VcbXnDNWT8Sp6Gi6t8A83TKA8OQyZxiDJnTRIGgcp73SjmlOxU+66j4zwXfjh1LjhU/TVoAtKMggTHuz96O50OLY50rNswHwLX1JEzi7I+CcBv1+5hRrPvj+0yAkenBfy0JbK9VMHK1VKsSGRalOcX+CM5M9Lo6uj9VTvw==
X-MS-Exchange-CrossTenant-Network-Message-Id: a5a5a970-2fa6-4144-866f-08d85afead89
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2020 11:41:55.5457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 789RPrlr4tTh/oI/nY05VbHZuPQDWGcvESn7Ksz/rs3ojCWBk7EgB7znN64q3Gr2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3403
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600342935; bh=Vy8OmMtlr8ET5ylzAjs58xOaSWhYBapenD/Q8WKdeWU=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=O1v0hwNNqpyWbDJJtHAnQjryNCBhujbuffwqBIvNrnNp/3zgVZq9Kb1pK++txcqnn
         u/Ye57ZuM+GZoLFIC6X7r/GC7j8tLOMdT/Zz5DmtlS1ygrVkBiH3uxzhIsqmQzUC/Z
         UOzsDdmBgEz/8vLm1tAzU/EPk6JjrmjiMdFb07nHp7lAwXa++JCk675EfSaAZRQi23
         hp/INO5Hqpjy590rcZNwOLJcQBsHxrvmO/EGjsD6wWBEqb4gNOa9rBBuUVbAcQ4E/1
         ipyo2HMC9kxhodYqsGC4UmMqK1d/WPGKgxa06aH/l49N6E7bQBQ3WaUvcFqTnJBuBh
         UWtP/GnH+zdUQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 12:02:20PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Changelog:
> v2:
>  * Changed WARN_ON casting to be saturated value instead while returning active_speed
>    to the user.
> v1: https://lore.kernel.org/linux-rdma/20200902074503.743310-1-leon@kernel.org
>  * Changed patch #1 to fix memory corruption to help with bisect. No
>    change in series, because the added code is changed anyway in patch
>    #3.
> v0:
>  * https://lore.kernel.org/linux-rdma/20200824105826.1093613-1-leon@kernel.org
> 
> 
> IBTA declares speed as 16 bits, but kernel stores it in u8. This series
> fixes in-kernel declaration while keeping external interface intact.
> 
> Thanks
> 
> Aharon Landau (3):
>   net/mlx5: Refactor query port speed functions
>   RDMA/mlx5: Delete duplicated mlx5_ptys_width enum
>   RDMA: Fix link active_speed size

Look OK, can you update the shared branch?

Thanks,
Jason
