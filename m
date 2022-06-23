Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8EB85573BD
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 09:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiFWHTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 03:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiFWHTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 03:19:19 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E3045783
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 00:19:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UV+FeY6HXBt6HHVyEuRf+j7u2VQtE4T0W6Vc3fqYyjyHN3uGJ0Dq7tIJztR2VkCovckVKrzj/gO01DBGcx0CLY0dCvxhOvw+f+Ki3/p3JaneGBYLK3upqbfgCd/IyyAIoQ4MXN8JiRN7mhrxolEiMc083DPC98s1jG9Y48h73qvYp9JNdy4CK2sPET6lcXrV7OZuzX1xFNCIK53K1QYRcewXbifKz7UsS5Fru/B/i/VHuaAIYH8sFktjqDkAqbiJris841nY+cVFMg6g3r1HUFOjSknqaWYRqtfA7iwXv3bairvcricAi2DmQuCv7ygAbF7Gtn8Uc6Jp5bYhyECdYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pTrDsrZLFuZAMSEE1m4YqcpO5/a/KA0/lQN6n5SmqdA=;
 b=k8DWtCQtYjE36eG2BX9tiY56FHF0ktTeQ/wiQ52vj63ApPAd9E6bduZAzoq6TOmuYM0Ew8w/dWbLh1OXvQx3KehQZEwv6UFINMcyApLIgEtvvzOPfVLCalqi0IcEHcdhN0dPzd2zOx8elOE8OMu6IatnHZYeTbdGpG7SxHCt/GXgaDenJeeCxb8j100r/Ms/dkGUdxr5d6jri87+0C3fwlteZzzR0rTBbbHiO/THgH5iF1JDw565x3ex9PafICiTcszfU4Yr0QZaWJyhEmumwcFzjj3i1qCFQFtHAuDVMdIBMEbbmnxq731dRdqG6k/ouLrhq01XjhEr+gy0yyRCLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pTrDsrZLFuZAMSEE1m4YqcpO5/a/KA0/lQN6n5SmqdA=;
 b=HmONbhBhHvt4DgDoGDWr2sxJSBCSn3uxVc7yer6U53wJ204n8ANmiBAhiKEgkW/zbkQFh08Wn+2WRiGEqIl4UkLWGZOzLam9a1xqhsVbK7tPnHPE/88YbKpzzT3b2KEgxnxVzfVxQyDJ7ucGczIoAGDkl4r+88zgI0zJ9qMaOGt0NrGFzz6gji9LNvK1omEbTQgt49nQPuNlZayyZIPLB1BdAdFqCTpvGF279RuOsu33LLFkyDN3XW7biH7XqEleJ3syJ4T781C2KB28pi5wKXlyRB8gysD/Sj+cfCm8OXuAPBsrugYJoC5yOBTsTTB1gKd/Twx7kaBwEjhR1TsGBw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20; Thu, 23 Jun
 2022 07:19:17 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::6da4:ce53:39ae:8dbf]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::6da4:ce53:39ae:8dbf%7]) with mapi id 15.20.5353.018; Thu, 23 Jun 2022
 07:19:17 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/8] mlxsw: Unified bridge conversion - part 3/6
Date:   Thu, 23 Jun 2022 10:17:29 +0300
Message-Id: <20220623071737.318238-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0178.eurprd09.prod.outlook.com
 (2603:10a6:800:120::32) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d808a79a-fba7-4ad6-0278-08da54e8aee3
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB251846AF76612246CBA2ECD9B2B59@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kV6fIXNiTk35Lit+ca6rKhpfSZUvjgZwxCToYZgag913W72NKTtGOskjB2fgkqnm8heKVQ6h+F5gcTmtKUqa4f7dL76VAnYM6auYsE9UKIPs+zN+6q9YSxUQCwcBoGLJcTPG6yTHNo7egnjHI0mHJgm35n3EB4ovoQW6qQ2mwDKlY/NoFYO4zuOYE3tvGy3SJhfrEb2pRjDG5QdeXlyJ6cCD0qndTlN2QIVcqxH3/eTniAOOg7qBaOvB03GXJkvtgSbAzt/mJX3BJA+TZ/H31eW12VW5CicdlONbqQcigfEgKrbWdo53uu/gIKC8zsEXw2TfU9FbWlIJhqZEDLFX7j/hUAxjJzT6xrzu6uxeJe0vhdiOKZQU6UEqK5Lw1OcetvKhdCNfNJe1mP7TH/cZUtuXzyw37xTPhi5nWWKX7Uud0wgKTXxVL0381nei40WIOgWAoEXO99xZT1hmcVnPikI8CQ0nv/T+LpkVoAs5yIiKfY9nyb6AGHBjsgz3LtyYllL23hJUlDH5RDF1I3LGgcvDJS1lrI10ryzaTljsThjMJv8U8iU2+4XvEXIEqrVUm+7n8WPAXwotbl/nKFY9+tcann5u20rOFsxAZmD7kKhzclvQ3083h310VCQ8UPx+bNFITG/veuZ/MeLkh+PutZZXFavFaRkPN4yzvZnSVMPbCMGkrSjwmvoNDdHqysKOurgyE+XmEYurxCY9WmliQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(4326008)(8936002)(66574015)(66476007)(8676002)(86362001)(1076003)(6666004)(6506007)(66556008)(6512007)(66946007)(107886003)(186003)(6916009)(83380400001)(2616005)(5660300002)(36756003)(41300700001)(38100700002)(26005)(316002)(6486002)(478600001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pNSUkwC1phjdTMSTmgwo4eYd0waQ/qCzShrYSUyDd5P4n3W1YzoAbop3fVCC?=
 =?us-ascii?Q?HRLeYt5cYnXRzpZKWp6CdBkw/n9cuikayb1CLNdA32MJ3m5pIH36PIaEp74X?=
 =?us-ascii?Q?2+V87bPLd0NDKv+iWEvXuZ9zhu6YF7sVfRM0sG8wJWb/pU2rz5VIpUk/8vOp?=
 =?us-ascii?Q?WWCTaHtT6zLwmkJ4jwJOLVIvfVlygpaNJrDMLkGgDe1iGzR4PXgmfRATIX3A?=
 =?us-ascii?Q?RS1dOpnOPrTz8B0G5eA9c7OxpWlB/yDU6kb4UUYjPanCWUrhXHbhQNlsOsXS?=
 =?us-ascii?Q?r83/lFzn3/xZ55dMKB6vFgUGzkksR2Qc5107Wr734Lc/60Te1zFwragcqU3n?=
 =?us-ascii?Q?hY0HOGlstkqQ/ZquRxKYmgqhe7L/bhrlbZ3l0BEn+s/xHci2ZSx4Ntdjsa3z?=
 =?us-ascii?Q?xC4h9rc8EHVTsaHH5OQXXgKBrbsLizv3YKDVJean5FI2YTgTnryK/5U24h20?=
 =?us-ascii?Q?eW/A8hP/Tzvmm/Cu8GYalM2Xe7KU+QrGtJtuTnM3ueUSbYmdmyMM2aU48Ion?=
 =?us-ascii?Q?YIJv0gkzbtzpJR3pzy7QTrkNIYDKIUtR0jPhRArucxxpzQKUmjTe+kivo/5d?=
 =?us-ascii?Q?MK3IMF8R/LfFITgtQR0O8Np8UZuWQIu1SsvKq9lRFir6ynf8OWZROzOMKGb7?=
 =?us-ascii?Q?+lEw2xnMAHdrgmEf3ECl5/ka8waPvhTYcOv7BZL3HL8ai3Mp9QFUrH1KZL63?=
 =?us-ascii?Q?JKHsDHgS248CD0VGm4YgFQUewOq8xFBNC48oYVeVZFH6CCj+AjepBPK/wXK5?=
 =?us-ascii?Q?OtE1KhO4QVqhSnODgwklCtlW2q0tZQ8LtzOZN0MD94OLaS1DRcMwbuHpiLQH?=
 =?us-ascii?Q?hQl9DG3JoORxi1XRyB/MQzG3hItEuKjSzP32/EJCJ5rxVTFPlGShdwyqZSQh?=
 =?us-ascii?Q?vGZelazUIbSO5A8SgWL9HD4rvsvNwKgJV7KmW1BP8Yr3a6lYSBJUQ14ji83b?=
 =?us-ascii?Q?7A8JQmGhThqgmrDskqRl0nMtDoJWOI1NZv9AlLYeOeP7gyk7EkJ5IP0+9EOd?=
 =?us-ascii?Q?VABjtrNWnhykw5ISmmw+U7Ds3qPRIB/Zrklknxmgo+MMzUwTqwE7IbUmTbSp?=
 =?us-ascii?Q?KCRQ2+UBZc8iEPg4rMXhgPe2T81Ncb1kE/OBhsZkG1/PBohW3Nd4yu1WGiIO?=
 =?us-ascii?Q?+J+CkmVRAGcQVcui32i4nfYPloILQ1pZLXEBN8LWzdCya7cIgHhrZynwXfSp?=
 =?us-ascii?Q?AkUOu45xJFE9IEdGL+4hDBgVU8xJgnsr3kd0vsdmPOl+5yir7Pcpa0UHh44y?=
 =?us-ascii?Q?gKJWyOoGEUaESW7+8nDwo+jwDnpdyKiA96LLKeNZQ3nFqizM1ATgevaN/ViF?=
 =?us-ascii?Q?ODx6LG/l8oMgZPlUT9cPCoy57cuMXuxrFr640A+BYuXQyuStmtcXQPsVd6GT?=
 =?us-ascii?Q?QbH9K64wPwPhePRgiYaMQ0pcxHqvq894zfh4IZou4iMyOYCuHizBuIZiIKjm?=
 =?us-ascii?Q?IxKE30lZLezNN5ZHhXXUx2a6LihFcrcCOdm786Cs/+62zSOndc/H4mb5MyL/?=
 =?us-ascii?Q?Q0BysIcbe0LLl70LsxdXgeDVvYW4Ovno6OHBX5BJCEqcdg45r10hp1oGb4bB?=
 =?us-ascii?Q?EqD/T2XYcxvz/ShcvRyxW8IWLU63MmHGACLcRaNCKOKB9/xB2LT6VVThjNS4?=
 =?us-ascii?Q?QiU/O0PJTP2JHJUWVfLcI5vUZXFhT0K0WlZA/1Fidy2st22iUSUJp3oZ01Ph?=
 =?us-ascii?Q?1iyW57RB3ff9EFf9Ox2B1F1o/03dRCTJtXV+BoTV0pjufLfOqwXWMobRgYns?=
 =?us-ascii?Q?HAB7Ms76NQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d808a79a-fba7-4ad6-0278-08da54e8aee3
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 07:19:17.1792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jc2SobsxKKO/e8pvkauoSGfhFnvfPzRd3LhnTIz5FHYnb9xjZdHMdbOdLDd4IjpqfDjGbw5Q6Qhmg/Ks+5LaSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the third part of the conversion of mlxsw to the unified bridge
model.

Like the second part, this patchset does not begin the conversion, but
instead prepares the FID code for it. The individual changes are
relatively small and self-contained with detailed description and
motivation in the commit message.

Amit Cohen (8):
  mlxsw: spectrum_fid: Maintain {port, VID}->FID mappings
  mlxsw: spectrum_fid: Update FID structure prior to device
    configuration
  mlxsw: spectrum_fid: Rename mlxsw_sp_fid_vni_op()
  mlxsw: spectrum_fid: Pass FID structure to mlxsw_sp_fid_op()
  mlxsw: spectrum_fid: Pass FID structure to
    __mlxsw_sp_fid_port_vid_map()
  mlxsw: spectrum: Use different arrays of FID families per-ASIC type
  mlxsw: spectrum: Rename MLXSW_SP_RIF_TYPE_VLAN
  mlxsw: spectrum: Change mlxsw_sp_rif_vlan_fid_op() to be dedicated for
    FID RIFs

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  10 -
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   4 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   6 +-
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 203 +++++++++++-------
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  26 ++-
 5 files changed, 142 insertions(+), 107 deletions(-)

-- 
2.36.1

