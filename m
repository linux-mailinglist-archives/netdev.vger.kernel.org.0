Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0C14B7065
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239217AbiBOOvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 09:51:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239321AbiBOOv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 09:51:27 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2907711AA1F
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:49:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPPoXzDI+GaYzbTeS1waNBYMTUnYp6xRfYbCajdPuwmQq6nUzMsCng9EuBCLWk8v5mkU2NzigESNiBnEuRhDM4npjTWcLiNislHUZqsAu/gdHM4/qvN3uj+v3Y3gJNB5Uk7XJwWPU0HTfNbq5mTPjSpQ6QWhhuSW6jbvN/3mvpELctH/3GtQyn6+TsjnQKqRlc8DqJerA6p4XeYXRO3NJRSbhm1BzlFOnRJQ4Sn+4ApRufe5eqXjoKQibqJzDNkIjf/qoldy8NFW9GcUy17Z5k7DM+B3ZrD0JLMoPJl18w/qfabZz86ZW2+4aayOu/XjcH9HKyxeGTbdpWycklo1Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2T+LTuoWPHU7cwxpUtH0Gu0BOwHJ3pfUW+++iILvgU=;
 b=ka/uK110VeSB8vUEXpLziL/kp4NhffyGRTTpecjFAZdAqgCl5xL5KBlTSljom/RLz76lRn7GOGwTD/N7iTRTtq5Klf+7vmH731rCOHo8imdhHesmchpAxycTnafsgVtkmEei5BFhVfFKZ85aEbGjIN5lFATGIFZESydW5AVXY/RhH1DuHmPSE7/0VNGVNgYOwbRDdGAdNA4Ti1r5aTNVK69h0uqDG6sdqIYN/i2qX3LvP22S98rLTzBlqOY1dowNB3fgWYYpii12MUei7DfvD7jByhmhA9VjauBA02NBdU68qivN7GVkXH0LGm5wRiD9gS1bbcST5pjVRyd6uIOqHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=temperror action=none header.from=nvidia.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2T+LTuoWPHU7cwxpUtH0Gu0BOwHJ3pfUW+++iILvgU=;
 b=OEaon8m49EL788EKEKPovt+uItrqD5OJ+MPlpT2JbushARpuWX6RRPIOlMuPEnrT2jhsxILlAFN4k7a4jLvGjJGOLNgCdrlHGnb9G/MwKqkN/jQ41lI6EwPtuyME42sSY+IL166GOt0WohNz4fUbJQRQmCcvfIqr2BE0P6Ad5y6CYutxEYHopB3qsv9Z4GBkX5nZmZT9cQF31BXuVs+XaXSi0bE6Tep7AW5aaR03eNPzJriHiI4Uk7nLCQ0jW1LR7aG0uKd3Q8f/bcWcwa9ymLj1Hi2rdsN5QBBiLbcx5sDt2dPrBzGYukJIjd8AtujuuoJXGkSaGM13Lrs/6vWkdw==
Received: from DM5PR1401CA0013.namprd14.prod.outlook.com (2603:10b6:4:4a::23)
 by DM5PR12MB2534.namprd12.prod.outlook.com (2603:10b6:4:b4::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Tue, 15 Feb
 2022 14:49:42 +0000
Received: from DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4a:cafe::3c) by DM5PR1401CA0013.outlook.office365.com
 (2603:10b6:4:4a::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Tue, 15 Feb 2022 14:49:42 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=nvidia.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of nvidia.com: DNS Timeout)
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT061.mail.protection.outlook.com (10.13.173.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Tue, 15 Feb 2022 14:49:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 15 Feb
 2022 14:49:41 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Tue, 15 Feb 2022 06:49:39 -0800
Date:   Tue, 15 Feb 2022 16:49:36 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
CC:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <jasowang@redhat.com>, <lulu@redhat.com>,
        Jianbo Liu <jianbol@mellanox.com>
Subject: Re: [PATCH v1 1/4] vdpa: Remove unsupported command line option
Message-ID: <20220215144936.GE229469@mtl-vdi-166.wap.labs.mlnx>
References: <20220210133115.115967-1-elic@nvidia.com>
 <20220210133115.115967-2-elic@nvidia.com>
 <ca2775b1-f755-d50a-7a23-0db8c4e220d9@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ca2775b1-f755-d50a-7a23-0db8c4e220d9@oracle.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ea2ac22-02f3-4825-cd23-08d9f092663b
X-MS-TrafficTypeDiagnostic: DM5PR12MB2534:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB2534809ECE216865724F2E76AB349@DM5PR12MB2534.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BJRghnfnglrdhKqelcSOxRNCdEtSleVimsDh0Onj15R8tSdAKHeR0LbiOdW9+MN3K2oeI0AY/DociXzP2dGCPBzUdMPIzG7xs19Zg7sp+goXGQpbl2RerO56sbUYKWiQaCWoUyPRHg09MIoTMD+dFEO0tB5ZiLRYuc1t/KowaCPSVVO2hOxCbn9RxZTRaBIMwkLYrVkuwvokFBemoKjvbSA3ZOajhXznXuTndg8n8j7SrqjyK7i6XkB369bBFfDgB5WehhF2Ubf1RGwfvOrLba4CWLGyXqxIZYbmEpbpK8fv/VYSqlfPcHnvGsYY17yP5xX/LqLqh4vcr9bVaUu8ucJ6wEVYTc3NJlptrCp+LmL4H5kQ6Wamf4F+/UAGGxzhddC3UN6WnjkaHHR+WKEUMs0Q8ZBdv0YeZlW/kHQVQQvYZ1YpBaYb76nQHkU4rBSyO2j60OUmPbiarF55VzLPY9lKk2AwzMecpLPwM0DtJdr/SeUrEedWPgfU/NOPfFdd4iKg7miGTT8e5bitT7oi04TRWgQmNZPcfT+oyG+ktflPEKHTZ4Jv6mLN20MO2b3T8tREt79/xYzXsdP3o09j/j5RKSlDxpVAPJV4O8Bo+kNN9XMFf/8iuM5PW6S1MSGAw+omRsPV3NEdQFnjUmmfzNrX00q8fr05zmNbpBvyvzJ3xxM/9O6WTCip5Kxw5QW+Oic/eSZSNpataLZ+wOqDLg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(316002)(53546011)(8936002)(36860700001)(8676002)(86362001)(4326008)(2906002)(47076005)(63350400001)(63370400001)(83380400001)(7696005)(6666004)(356005)(70206006)(70586007)(16526019)(107886003)(336012)(508600001)(55016003)(186003)(9686003)(1076003)(426003)(26005)(33656002)(6916009)(40460700003)(81166007)(5660300002)(82310400004)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 14:49:41.9472
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ea2ac22-02f3-4825-cd23-08d9f092663b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2534
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 04:44:14PM -0800, Si-Wei Liu wrote:
> 
> 
> On 2/10/2022 5:31 AM, Eli Cohen wrote:
> > "-v[erbose]" option is not supported.
> > Remove it.
> > 
> > Acked-by: Jason Wang <jasowang@redhat.com>
> > Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
> > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > ---
> >   vdpa/vdpa.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> > index f048e470c929..4ccb564872a0 100644
> > --- a/vdpa/vdpa.c
> > +++ b/vdpa/vdpa.c
> > @@ -711,7 +711,7 @@ static void help(void)
> >   	fprintf(stderr,
> >   		"Usage: vdpa [ OPTIONS ] OBJECT { COMMAND | help }\n"
> >   		"where  OBJECT := { mgmtdev | dev }\n"
> > -		"       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] }\n");
> > +		"       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] }\n");
> Maybe remove -n option that is also unsupported yet?

I didn't notice this. Will review all help messages and fix in a follow
up patch.

> 
> Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
> >   }
> >   static int vdpa_cmd(struct vdpa *vdpa, int argc, char **argv)
> 
