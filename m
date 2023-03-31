Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58446D2130
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 15:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbjCaNKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 09:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbjCaNKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 09:10:41 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2080.outbound.protection.outlook.com [40.107.94.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555187296
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 06:10:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DHSycMFn7NftIL1S9ns7ZK9cVMCS7MzzFkWCr/ChyWtnzC9pDrWiUydmK9wsH5R4Wj8hCAqd7Q8ULpR/ieH7LoDsTIriRcoE8mae6SJjSZ+4X1/0fwulholqQPZkGqQQajWFUVbtfbwq1kb6NTO1TfB/w3OwxTA6jqnUYkpyrZADjPuykQPhoHefSC7KBkdLT9PpZ/q4xIrfS8nlBXIsVRp5sKzsSXr5SXQBooQLXXx2tsMo1hcNx2+ARfhgQ/ZzPqIPSVYuIlPlntK/eK8ftZMaZUjm2lWTpk6CwIg2QF7/wC58EdGjWiOmIlYg/6b5ims8ZefVUscc3H6xwUGDhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GRLNnmrut9WNy7LkwNchNXwbDawRNQJd63XnTMOmp68=;
 b=RS7J0fRwhnMqr/+MsVfiBfZpFnC77ImXL1VCEMeDgcSoBoxVPEqYKbgEXQfOtN17Lv8pOQ9Y5GJI50Fe9SxfgJfQZLxDKCxZjO6zX8b6nUYYVCbavb5wV3rkCLtIaNkAIPkHihU46lnPadYqNFD74C7dxr1cXy8sGiMi5VOBvD+bJCIvy31ofv92cCBZoCbXD2PmU4TT9MV738MIprHmhMb0vuTqOB8OTbWJDKhlzPRKmCJobitv0Mm691SYEcu1AsaDWJAWfnjYU5sCNbTMINABAfVt3zFlSsYt9kTsrHfy1qIrjUiUBapS06pAz8aVCwJexsvDF0evTdMHOO45zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GRLNnmrut9WNy7LkwNchNXwbDawRNQJd63XnTMOmp68=;
 b=kKdQxSLd8j+FzaN1gJ4F3CSNdV9p+3VQW1xyUAl7VsTrEuhlm8o/9IzMpXSRUwqHt1cFmdep84lkd79Pb2yRWfzMggPJvkgFte5G1jFrbD/pV5xdxWez2PuyRWF5MptX+jE9QRWpVMSVGipCP1UVcFgBWs6zKA2lQWSReI6K2tKCZmsdNWEzB66v/ybT9azUKgDRzLLIbz7dtoB/H4ECItTj1ZlOXLuXNhvybP8fi5pAKjvKO4FjIlaIApJrNbuC3rEIiEUBp1t465OVUXebOMncYEfNhB5ggHCiOFj/9VPV9Vs94ruMjD4r07HCWZzZbeWBiCtuOCqvVT/mAj1ZmA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SN7PR12MB6742.namprd12.prod.outlook.com (2603:10b6:806:26e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Fri, 31 Mar
 2023 13:10:38 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6254.022; Fri, 31 Mar 2023
 13:10:38 +0000
Date:   Fri, 31 Mar 2023 16:10:31 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Andy Roulin <aroulin@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, andrew@lunn.ch, f.fainelli@gmail.com,
        mkubecek@suse.cz, mlxsw@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: Re: [PATCH net] ethtool: reset #lanes when lanes is omitted
Message-ID: <ZCbbx8N5QrzM0ZJK@shredder>
References: <659c7c1d-6aa9-0d90-00e4-7a6025ae40b5@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <659c7c1d-6aa9-0d90-00e4-7a6025ae40b5@nvidia.com>
X-ClientProxiedBy: VI1PR09CA0110.eurprd09.prod.outlook.com
 (2603:10a6:803:78::33) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SN7PR12MB6742:EE_
X-MS-Office365-Filtering-Correlation-Id: 90eab548-aa1e-449c-4ead-08db31e95222
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RubNpzszBESyLSOH9UK/ksAM5oKynnP1strPtPEg2D6IpA3wdreyH2m8sdjE4WIK6KpU05fck9GnkU60wcAFoYYj4iHa/xtNfUUWfOBXsQdmzJY1kuIo09lT+ZNk2KBAGp6bdXYSiDllmlgpeYn0aINodDyZ6X06DToI6PK0N+aa/e8jsJLy0Iq9tiq5KIgsiV3+qrmDG0FnemLEf/b346/vEuA1iyunE2i5VfDvPBn8EjE8ze6uj++ZtXd2ZxyrT/hkV/VbtoBwlFhQm1Lo9PqZTSO6cc4yr8BEQdSZ0nyj12o+VdpKojHRAhHH8jliXbJHWVaplXhD0F0AJljfiAtUZjOv2UsjPmZol9OVayrLcvk6x2hZ9aVUKEKQLp+54jG9smvx7jb+0rJMwVeGFB/v5jrL6P/0gpVJpzLV+B4qbKuIDqmfTl9lpE/3OzmpqKUsaTe0+9JnPAEXKQS8CxEKwFD9bAHkaoedGwtVmj7IiqK/E5VRoTEk82bLDYmvoiYMkcAqmurAaH96IGSUffjR1qUB3QyfAYJotmUFGb8uM91nLTTAd/Vuh7Oyv4H2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199021)(38100700002)(33716001)(6862004)(5660300002)(8936002)(86362001)(66946007)(41300700001)(4326008)(66556008)(8676002)(66476007)(6486002)(83380400001)(6666004)(9686003)(2906002)(6512007)(6506007)(6636002)(26005)(107886003)(478600001)(186003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gycdlckTWWgqdEULiikhoiTHnnrPGXMzGgndNlP0LHeba5w2KOSStWMk5HaE?=
 =?us-ascii?Q?lpQZFXNRU9sfrH1vNo9pfVdwJpt6aY3USymbpIIFdoz9FG0D3bBHLvaf+JxQ?=
 =?us-ascii?Q?g2M3Jyva8NXo2Gg39CDBK1CtnNTtR748kV+bVAqVz9SF0DJk710zIiIg8VpI?=
 =?us-ascii?Q?zexTymBlCU8jkyOB6bMMHm6qJhj/JQQdYVRAJZs6+eeT0DdcO7n6TltoWxfD?=
 =?us-ascii?Q?UmSMiTIKOmRXkJmbdJX4eJmbUocEIAnPHstkKtXP8n/gjzjJ24lAvG+F2+03?=
 =?us-ascii?Q?E4ENYHHG21EUy9UOkW/ganWkrwWSyORVs/vDdobzH85gHENKcuR0ksCwNt0J?=
 =?us-ascii?Q?ybMKgLfTrd8AEby9+LkIvkrrkwMIcmkOFYKU74PQlWSk7iQaNoyZlkZ98uhb?=
 =?us-ascii?Q?SlSCXxb2/DMFGpfLjJiaSu4cu5cgHvIsi6N0qc6wG2JApNhfCZnnz8dRvxWM?=
 =?us-ascii?Q?ZoMt318lrVqy1G84eSWltgTUfK4z10l8bMSSqOZqj2M9zoHyLLs5JuQh+jYt?=
 =?us-ascii?Q?YbhPWS8KRbSZaf9+thUnHFoeLBVptoCydByi20a55lAhl5PblrVwCgOb1qY8?=
 =?us-ascii?Q?pOawVHKtz/5L3KWA0y6cmW2JtsuZcXHYxmTG4m7p5pZA0wiqP5nNb7uSWqts?=
 =?us-ascii?Q?E+lE12MWBDC+Legbh5362Ob8yAyFxIXobswDfByve9QzHibnlzuzwH1+ijJO?=
 =?us-ascii?Q?EZWbMXQ1hP5L2ouPpbAoX7/FN+4/lp1K13FWOh6QE1sx7w3X1nMo1TNJ5M8U?=
 =?us-ascii?Q?ysf6iS9L3irtTAdJMTtnh31EV5al1O+1D+nQnJbHdi0Y0b01O/c8eJKyJGJ8?=
 =?us-ascii?Q?1XYdUJvOYuaWuDvyjgY98SNLtF7D10ZJbt+aBCtD8I6ppSuWkvn6qHE+avi8?=
 =?us-ascii?Q?wirGpQDKFEzbObFWd51tH9QunVrrXM2gzWYqsUZpiuPPvV65vq8Q++6uwHSC?=
 =?us-ascii?Q?tRDk4LGnJ28mKyzUHeAMUEwibyEkgiIWKFiNh3kDyVFEQ67wHDMXGWWHEfv7?=
 =?us-ascii?Q?N3Zq1Y6gGaeiqvyjltpuPCjrCKLl3WMJiCAQDmovqxl9dCX69W6P878ZML/m?=
 =?us-ascii?Q?X4oNA0UGrptmZOA21saLbbIMkrZ/oJ3KEdizoqln3NmCRT6c6t3qWLe6RtEV?=
 =?us-ascii?Q?RVYQ90cAdEO+1gYZk4MSZR37gijKLdpgs5i2NjIQ+6sJ/BRp20WcKGGC6g4X?=
 =?us-ascii?Q?sf+8zVHA6kLJpkUT9hTwKcBK1wIh2gXTR+S0gwGoy+mUeTugogv+maGS8Zmz?=
 =?us-ascii?Q?IvfLov0h9DntfM/lGp2sQi1jOj9ReEZnbn59ufTWo4autoOGOkCUlnbn4uye?=
 =?us-ascii?Q?hcSTgxhPHVz9/FvcH5EVJ2ZuiG1bkM9VbMvU43rkPkahSZXPIT6fEMD7VQSA?=
 =?us-ascii?Q?y++lIdpQboGBq1wrCNNeoycLqz2m4dWFbgVEc9ecnRBOExW317Okl5KGZjd1?=
 =?us-ascii?Q?Z9HDX8RN04kaERm7kOFKbrB+wr4d9CI6gJMNm4tSCrSVCdmryXNj37qJrWuT?=
 =?us-ascii?Q?cnhfSctHaK2AyzfxhpcfZMNZfNvkvu2QlaNjNrxwiX4qcTvNs+r3TMr/OLsv?=
 =?us-ascii?Q?HIY/7qslSr8mlkBbT5fKaydALrim+lnKRRosAyT7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90eab548-aa1e-449c-4ead-08db31e95222
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 13:10:37.9733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EAkQnmmXFC7938bU17N2vkwFXzaNkgGNgnLkyGfEK7OxZ31jOCN4hVNNsD01jVfsGYhhqPwGNsfaRClnNAaSYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6742
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 11:38:26AM -0700, Andy Roulin wrote:
> If the number of lanes was forced and then subsequently the user
> omits this parameter, the ksettings->lanes is reset. The driver
> should then reset the number of lanes to the device's default
> for the specified speed.
> 
> However, although the ksettings->lanes is set to 0, the mod variable
> is not set to true to indicate the driver and userspace should be
> notified of the changes.

Code looks fine, but I suggest including before and after examples in
the commit message. Currently, the same operation produces different
results based on the state of the system. For example, if the starting
state is:

# ethtool swp1 | grep -A 3 'Speed: '
        Speed: 400000Mb/s
        Lanes: 8
        Duplex: Full
        Auto-negotiation: on

And I do:

# ethtool -s swp1 speed 100000 autoneg off

I get:

# ethtool swp1 | grep -A 3 'Speed: '
        Speed: 100000Mb/s
        Lanes: 4
        Duplex: Full
        Auto-negotiation: off

But if the current state is:

# ethtool swp1 | grep -A 3 'Speed: '
        Speed: 100000Mb/s
        Lanes: 2
        Duplex: Full
        Auto-negotiation: off

And I do:

# ethtool -s swp1 speed 100000 autoneg off

Nothing changes:

# ethtool swp1 | grep -A 3 'Speed: '
        Speed: 100000Mb/s
        Lanes: 2
        Duplex: Full
        Auto-negotiation: off

I expect that after this patch I will get the same result regardless of
the current state.
