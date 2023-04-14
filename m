Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52CEC6E238C
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 14:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjDNMoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 08:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjDNMoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 08:44:06 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2751E11C;
        Fri, 14 Apr 2023 05:44:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N80IcChVKCaLX0rGH0W6h7Y/6FGc7cdX8U0Q/NJ6ZlwlMWxpheX5GhKYnEC8T5VOXBVR4SzV9bZ+LAAwaOXOb/D7Ouy2bIr3pi7LVh3MqOiLSIlalkH5Eod95FGkRswDLgaAj43oIqsYVOQngM1CPC6poOHyuAenBQUA5RkgcuCLgHP8c3fnLS5Jm/DxvBHPgTzgmYQU1UTnhnp0LGx+dhOb+4bIRHtFEaPPFwolcj1OQ7XTmUskbXPukWD+Xpi2lwbb49Sb1er31hMikUKlAqI9S8RX2M6bRRiUJG8IRbfKqT0k2kR6/7aOfMIMJ8s/kBtsmdHtWCtkwQeCy/xwrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+wIcDrPtbI8hLALSVV9EF83IgZ2I6GvvOlereHFoyTw=;
 b=dcr4tYVvxHeTF+VK5jVllBR8rMmsbTV0XymBhutpzS/oHKEDcYVpf3zjfAVOpqCoCFbd0IXtl4vSqVlJnwUfXBMyBWEg5N9khgDf1Ha4LoUx23LapMVR4as0vfMhtEraDz0Hc+nkQKBj0zr844JHG2yEmPoadpyRdAJuAcDAzKqF73a6Z9n2ncHIEBWnJ3HeSnZkGqLrd1PM8hDjfPb3bJRQ5f70daI6/ER36N9YOux0iw4UbuFmnHmQD2KmYN84uLCYe7cSYR21q8qoavrnAXxfsi4UXi2mhNLpOh4EZ3gl1OScfGhbQSP2tHFhqBN6aG5JS8sO9aqH1WeFXd5qBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+wIcDrPtbI8hLALSVV9EF83IgZ2I6GvvOlereHFoyTw=;
 b=AzwkVRPYbPtNoR4xfReFqw4GBfUx7vQP6MwrDwGG1KBC1q7jzB5W0gHMzkbq33TfGgVvbXzvlpW5Zn4Y0M2mS1yu4s0gcXveSQ4+s/mC7PgK1t3ofoQiML16OVjSB2urjOIvjQEWrSksriUkZi+HCeKoadpX/4T2zN+qWAXCKnCvnX9vfp0PppgbiuomXD5hIAZ6DQAjE+7X/ZyqwZmBwx4ugIj04SwxzfycyNbqUfleHtqnhZqVwGIx4lFaH7DeXHzKbwqN6JzceR6c0iWfxdIScslXd1OfjzPV8aHcMBLckNdJFzSunPQFuA2Z306nf5QtJWE0RsWsWxWPFNdG3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5849.namprd12.prod.outlook.com (2603:10b6:208:384::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Fri, 14 Apr
 2023 12:44:02 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 12:44:02 +0000
Date:   Fri, 14 Apr 2023 09:43:59 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com, drivers@pensando.io,
        simon.horman@corigine.com
Subject: Re: [PATCH v8 vfio 3/7] vfio/pds: register with the pds_core PF
Message-ID: <ZDlKj/AvVxwkt4sb@nvidia.com>
References: <20230404190141.57762-1-brett.creeley@amd.com>
 <20230404190141.57762-4-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404190141.57762-4-brett.creeley@amd.com>
X-ClientProxiedBy: BYAPR05CA0100.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::41) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5849:EE_
X-MS-Office365-Filtering-Correlation-Id: b975f0fb-cdb0-4930-f103-08db3ce5ed1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +dqN/KtshTXyW9ZkyntEhSUbZmpnfvMTQaXWKc9mhPZCHeUz6s228J14dlj8DS1h6AOIjSd8dSD+jwMU+HSSM5l0geq8JdaTu6bKCkeVd7ODBtQJ6KC4Xasg5xbwdi6va2YToLFPyAmjxRKkH+pjWDPCQmuWIM+p/sJ5VspJ52xHdV2e+x48BF8LC+pG3PiB0lXnVNkxxrZARIbSlKyDb6GiDh7LJmohLITotutd5EqP2ERXfuuNqP1FrHAqgLxQTajNPW+B5Yc2HvQWU4MdzvcYotO62t3jU2/mZ7jRGmdCmcIuQjmbXqGLFVUrlJ9SW9WvJXTJHTnJJeSROxveb7SJjXaG2fE82ZyJtdxj6aV5pMnf3l6Lq6ppb6gevIQUd/SZ3AoUU6QxIpPnvTCmBs34YnmN/2aCfuhTXLDJLR5vnjOZwT1oVmlnP4FKWNBOyuQpa9VUPRJH2+JdcQsX8M0q+sgZ7LJR6F9setd7CtfwSAdnZAPfxMbvp/NZdCQiN+i6oOHHkBmZ75zlnApCgCqPwk1zw+YNF9Z77J5PILAGWjkSAhD7ic22tvhf1oKs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(451199021)(36756003)(2906002)(5660300002)(4744005)(8936002)(86362001)(38100700002)(8676002)(26005)(6486002)(6666004)(6506007)(478600001)(6512007)(2616005)(186003)(66946007)(66556008)(41300700001)(6916009)(66476007)(4326008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pw6lBdyE1JxS0H37Im/iRG4Zoc9Rr8cIt7qV0xnrebbi8NBxLGPIZ+eAcCz4?=
 =?us-ascii?Q?bRkXsrcfYBIWzSnkp0DKkTDbPzJl4nbYNkVR7v84mlfjCsF7rUOuGS3LfydD?=
 =?us-ascii?Q?Pr9vM7pBT0xki3TWB47kVYOAVi4I+Nyd9PR1ZqfH3USq0yE/SQiHV+Tpj+Kf?=
 =?us-ascii?Q?xgAmGtfYTdk38kRKFbN6p0jgafljFep6XpejeTZSsxLq9OBhEPBmMX83ERpd?=
 =?us-ascii?Q?GTgQGpsUApx7bRn7yPmJxUKY0f0RM+ODvdWmZeP17q3VmhHMTjH0x05KfX1W?=
 =?us-ascii?Q?3fxvdhzeJ4SqPILvRrVx+aT+DIwxclCtVejJIX2L1WNwPhXmMBUiaq400ToO?=
 =?us-ascii?Q?Py5yNd0Y17Y8lXIHpUnLe305Oa7yggOfMqhZuEL5lUaHVgzCMcOhiBK9Ze8A?=
 =?us-ascii?Q?adFVB1fo2xTnlqMZLFwl21jSaY5V4MP/NJYp8CyEeX4CEw8stnovi5jwQVJt?=
 =?us-ascii?Q?DeqhLZh1zhFgy/Gzw8Y9GbbRPzDrbv7vsigzDYW9UWP0utuRkF0/La6qLvbx?=
 =?us-ascii?Q?Kl1gNanRIdAoMk77NBEzMfF8gmJTm9qn7Xfi3Gux7881j3z8Lyq5vfTLdbOR?=
 =?us-ascii?Q?qTGAsez9rqVjyXR1ixyAcaFTS7ns23gmHPivHWAeueMwqLXPFCHkbSwQwiny?=
 =?us-ascii?Q?RkZvtDF3p5olDMOrd1UN4rHNLNNPa3euRTyz7PA/P080dyDmyiQnfqhGHNkG?=
 =?us-ascii?Q?bd4/VIY6tofvJCQmsvt1bunqMLYTH92pWvcYUtca+HqrPGDbm9HWYgArBQMV?=
 =?us-ascii?Q?10eDna6rRqbdR/SVpbn3RLF2zEvq+Ary8dXCzISnO1+9FwFYfhO2JRG/rMVb?=
 =?us-ascii?Q?g0XjaOeH4/xNZozmLNnsHQA+w08bAuWk4DVy9jTuK69Y5VVWFf8kRkggxLtD?=
 =?us-ascii?Q?MGNh6Vlwp9YybjR+UAbwaJ1VbRK/omOs9qHd/Zz021Sm1GLfSRaIOKBXR3Fi?=
 =?us-ascii?Q?rfzy1+EmQbhMQyV3VpspaMhViRLvvmHYmBFz3fL3ssnoReWLEvQAfl+hGkjc?=
 =?us-ascii?Q?1lNh7ryNUWBHdkjFJIWpumOzoPY/3zcWMfweMvyUp86a981boNedKwrjLt9s?=
 =?us-ascii?Q?e5vOAuPZJtM1j+FiYVPwh/rloaIqmed6OaoMsF3p3+TZZ94Q87ZhtLWKjkc3?=
 =?us-ascii?Q?TRJkdrK5M7iqEva89OB0ncfOTR4bYATbLVsI+cOrQWmWXEf12R/Yyn01oIkt?=
 =?us-ascii?Q?nGGb4hfXUzrV8Bn+FBHwy0tc/qUjJ5bTxxa/Mpy8oAUtsRoBWVDjFNfpzXBP?=
 =?us-ascii?Q?OPeEe7Uit9DC+oP1WownlHbrDLXWOJDTAu7rLqwdT0vrzoukQwi/8AS32mLI?=
 =?us-ascii?Q?caIMMXaa71mPB7Mu72NqeehU36PIlMdqsHmednJrY9WxygDFKg3PFelry4ax?=
 =?us-ascii?Q?HWEHAN7HsCo50evdhrGvQiJjvw+ZpJXDzPuCjEo1bJZD2dg/A+3oL4vulyU8?=
 =?us-ascii?Q?Z7LlUqcUt3Vxqn8gin0rSPP19pcA2c3mCrgRB8I0e9sAJmggaxI+Y7n0Ptp9?=
 =?us-ascii?Q?C0tAqLZ+iU89P5vDdtT7faH378CrkbbVGUy4UenT4f1VedThEBQnbI9mvF66?=
 =?us-ascii?Q?v7lMVxVSAnABG92OH0aPjodipWrrI9jgHOLCAWfw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b975f0fb-cdb0-4930-f103-08db3ce5ed1e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 12:44:02.8197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sGoKDpvvENqSpYYg9SLhJzWOU60d++6xPQmMpwCrSCvK1Gq2w/ECVGl5DJ8eV51o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5849
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 12:01:37PM -0700, Brett Creeley wrote:
> @@ -30,13 +34,23 @@ pds_vfio_pci_probe(struct pci_dev *pdev,
>  
>  	dev_set_drvdata(&pdev->dev, &pds_vfio->vfio_coredev);
>  	pds_vfio->pdev = pdev;
> +	pds_vfio->pdsc = pdsc_get_pf_struct(pdev);

This should not be a void *, it has a type, looks like it is 'struct
pdsc *' - comment applies to all the places in both series that
dropped the type here.

Jason
