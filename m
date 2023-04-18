Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC966E6988
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 18:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbjDRQaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 12:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbjDRQaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 12:30:17 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDE318F
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 09:30:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFgNuXXLMhJaD7VOX3j8LqAswAajyT4JJGR06Niq2tzE2qaZMuG1Oi6XlBiKmTaL8+nGPWUuOiqcxIXrdyHQ+M9YBytbbRr+E5uieLu2OaBMDZ2AsCgqKycEtx+SiCr9YmG2QMdObDSk32ePs8cIMv21V8jO01FEU8mVux3Wp+HeDS4nUsTmOeyNf4/F9o9AdSYGg9dc4mApWGZhZnIhZTPXmmqofL0JLp4gudCWwceFV73mZ6GlqgJJ2p7CwOB1DLedRughk4J4E67Usc+U5Aoukfllo6/SMBXMLfe2WRCa77MCW9K1G6cVpdWWbkCxGY/l/kDOlWOtgPs4+wkw3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dI1ioSvpsCd2NliaFZNK0X7qZQCY6vx2q63pej8vJUQ=;
 b=YhJJyMwYMWgxzmbMBjWkTPDpUzfukrGx1HWCXV+QinoK4GVtwCQ+GwTnVdFyzSfDIg3fQVdzWLnIElBtRDol/3ifhcNtMc17pu9khqqV8bcjlvg6DGnjyKdx2juYioYgxViw7baqZYkzIrBzj0Cxw31i5j72wUaHXwZUQCwCXHJVRvDF+JD91lhG2ISn74COC1yHcFCihnHrasYXQEb587VihmirsRMs414mtAgIEhyxM8BkGGsYgk9UeVuXyJ7V8jE5KbOgTXkrw0vXqjC76aoUc8DAlg/bp620d0xlDiyUqPH60/3zMNWxF2R6tX74VihsthBKOyX/k0Gu4VCOZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dI1ioSvpsCd2NliaFZNK0X7qZQCY6vx2q63pej8vJUQ=;
 b=S5foPO/NKJbL3ez4Y6xSJBgVJx3iBH5N9J99d7p6enj6V7U6W5/ABMsDj+f8ZaKFdUoTUls7y9ij6ZT1a+uGY7/Za2NLrug4ELxn7toKXegacnV6vnAGxt5p5ZOgtOEj9XM+QwAIeUvgq/kOn8SQCNx4JdawTGG+D/5K7iUZ3hY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6573.namprd12.prod.outlook.com (2603:10b6:930:43::21)
 by SN7PR12MB6713.namprd12.prod.outlook.com (2603:10b6:806:273::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 16:30:12 +0000
Received: from CY5PR12MB6573.namprd12.prod.outlook.com
 ([fe80::f1d6:fc33:2d4e:d370]) by CY5PR12MB6573.namprd12.prod.outlook.com
 ([fe80::f1d6:fc33:2d4e:d370%8]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 16:30:12 +0000
Message-ID: <73efad41-4f38-62dd-939f-25071da6169e@amd.com>
Date:   Tue, 18 Apr 2023 09:30:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v10 net-next 14/14] pds_core: Kconfig and pds_core.rst
To:     kernel test robot <lkp@intel.com>, brett.creeley@amd.com,
        davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, drivers@pensando.io,
        leon@kernel.org, jiri@resnulli.us, simon.horman@corigine.com
References: <20230418003228.28234-15-shannon.nelson@amd.com>
 <202304181137.WaZTYyAa-lkp@intel.com>
Content-Language: en-US
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <202304181137.WaZTYyAa-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0040.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::15) To CY5PR12MB6573.namprd12.prod.outlook.com
 (2603:10b6:930:43::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6573:EE_|SN7PR12MB6713:EE_
X-MS-Office365-Filtering-Correlation-Id: f9129db1-9e81-4344-cfc3-08db402a2eee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N+JUg8fHg8/eELRnngkb6to9a4GgqwIo6Tf58GSVhuA7gAuvi85B/PbD9nOA5UrXLimZ4ZSzbmoCNTYdtA832LQ3UKCguM0aC68a71q2Z9ouiZfvvssUUktT+H6Do/Sl2ocYRDXoRpW6HIVm6/erAnYqbiRaq8PenypV8DBb55Eq8LS4vqrwiQu6Vm7FHECj6Xs6eN1dg9DmJ5WB24MkglxogFKVWpVJ88wvQiFUk9Sq+DpTwat2K+bU3AZoIx7ysCvq8KStaA6mDMh3/p+rF7oNtl41oaQwPjfbSlAaeg6KhTKRPQaNOimYUH9Oclo0ZOmcJk5OQpG3EwvxIBIoACjStGICeZPbbikJj/+4wWpUllBlh3OX8e1ZiJ/z9VeBrxpXThgZR2wugOedL4X9U6kkV2AhDh052WmGmjHUSYWFnH95DavHq5T9/YLsz2PKJw5bcnBGl9Avlv/Dh6/wjunhBdf5wMu1ywu3BCmdn39G4yDsHFVpnDWuC5+DfxIeB/jUJ6TfBbenHT99CjU58PDNatLm/sQdlWhYlIJE8lVhTlqy8gRuLk1n+hgu3oygsiCWMF7QuA1e8VZ/ShmxW8NyThR1u8VXHy7xR5RM+RuLCmaOWLPmpBhUF/bSf3We2sonferKqILvGuzBISavQPl3BQF/8gavAzhTqL+8qLJVJzUsmPCnCglHs0yHfZ30
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6573.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(451199021)(26005)(6666004)(6486002)(2906002)(38100700002)(478600001)(83380400001)(2616005)(186003)(53546011)(966005)(6506007)(36756003)(4326008)(5660300002)(316002)(44832011)(6512007)(66476007)(66946007)(66556008)(31686004)(41300700001)(86362001)(31696002)(8676002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VW5HTDJVVldTVjFlVVhEUzBHNjJaTS9YSGFicnJKT1dZMndNTmpvdVNPYW91?=
 =?utf-8?B?QjdSZUV4dFY4M0txQnpLZmFNcUx0WFd6cHRSckx3YWxrWVZOQ0hLc3JIcXV3?=
 =?utf-8?B?aGxjdEwyY3NXNFpFRVNQMmNzSDBybEk5bmpzaDcvUXBZeFhpQ21tR0U3THY0?=
 =?utf-8?B?VndoQ3VXUEhnMXh3TWcyVVg5d1ZJRDFMWEhjNnhoMW9tU2RvZzg3N3lzWU5V?=
 =?utf-8?B?akhuTDVWVjcrcHNGemN5V2ZVc0UxejIwbUlxYm5YbThMMXpPRGdWT3ZIWEZV?=
 =?utf-8?B?ZVMzVit3R3k5YTduckp0QnlQenU2VUNRaStBODgxZENRSlcyUG1GTjVYZDdJ?=
 =?utf-8?B?dHo5eUtoZEJ6QWtXR0drTWhuTmdPUVJlMGI1YkVlYUhkTmpPTER2N0l5dDU3?=
 =?utf-8?B?a3FhOWdJMk4xeXpGTExNdm02MllTa09nUmJtQTFHSU9DNTloY3ZOUUF1SVcz?=
 =?utf-8?B?QUViRGRwcFVLQ2RwZGNid2ZWZlhYT0FTRHAvbkJtVG5pQnVKajR5M256RVJh?=
 =?utf-8?B?c2w3ZWNXSzZ4aTZNQWc1Sno3ajlCNUphNlptWEN3QTZiZ0Y5S1lZRUgwOHNX?=
 =?utf-8?B?WlFwK1M2NEVhVjRtNWZLY3VTaXkreXVwVGlaTzBpWHJzeHNvMHRwZVltV1ov?=
 =?utf-8?B?Q05EUndnNG96MXRpM3hZTGZ5QlFTcTdXQUVlbXJTNHR2K3hBU2VsNlh4VVZ5?=
 =?utf-8?B?UXZkZitDZytQQ0tJbVRaRGNqR3pqL0tNMWZPVXREeTJwUXNhYlB6K29zVXlR?=
 =?utf-8?B?VXRxT00wYVgvYlByRWlyQ3V6bjNHU3JRMWJoK0V5K1hNVzdtVUlCR1RHeE9y?=
 =?utf-8?B?bW5VSGV4SDRsQXhLV2N6ZmwwdlI0WGtjcmNMZWhRNkRUMG9ZNG05VVRHd0ox?=
 =?utf-8?B?ck9ieWJKUHE0VEdPZzZ2bFNYUXFVbUJocXNUZkFZdnBRMEhscTFHQXErSlhx?=
 =?utf-8?B?a2lwYXMzcWlxaXdjSXpQUzFjZk9YUHBVVmJoenc2ZzlhdXBKSGlXMEl0NDNH?=
 =?utf-8?B?T09FMmhTTEhHRVFsL2UreThBQkZuMWw5NUVsNEtYcTlUb3piNWRDcDRWTHV4?=
 =?utf-8?B?TEZRVnJUdmcyNHh2N2tCVXpsenBodzhsU0owQXhqcWN2TGJSN1ZYcll1eURV?=
 =?utf-8?B?NFJ4MVU3S1Q5bmllVCs1cXVvQXRpbHpBTDNBS1dBRDg5ejhRaHprVGRGZGNv?=
 =?utf-8?B?RVA4eW9CdHNmbkowenc0QWU2Qk5MVTQ5UWJYT0VoSFV6MTI5Y3lESjB4Yitt?=
 =?utf-8?B?bHB1RTJYQ3hUQmdwNXBldnhYN3VTcS9HblljYWFUTU9wUVdGM1cvcnF2RkpD?=
 =?utf-8?B?N1lMaWd5eW5ublZIZXRuWHluRndUeWRtOWFrcU41SnBSaFgrVTlCVnBhdEQx?=
 =?utf-8?B?RFc1UDh6dDJpNXppTnJpNTgxQ1hPRFZueVUzSFduZEV3K2I2aXVNQlBORDdG?=
 =?utf-8?B?dXBMVWZsYkhNSWl0NStldFpvNk9jQnVITFM4R2pqcmNVS0UyM0NnUGpWL2xC?=
 =?utf-8?B?MjN2clJvTnUyQWF0N3ovTEs1aTVtK1paWVBVL0pkOGE1L2IzRnJPRWVMbWo5?=
 =?utf-8?B?OWRHQTNhRzdXbWdSWUw5T3NxMHp5VnJ4V2wrZk02UnVmdVcyM29idXlwbjlu?=
 =?utf-8?B?Qm5xaWR4clVGNjBtc01TMDkvRG1zZFY1aVRCNU5lUmtaVTRrVEo2NEczTGRx?=
 =?utf-8?B?bmNSZWQ3Nk5RaHR5Zi9IK2JsUUROTEl5V3BLcSs0L2JUS1lFdUY5UkxqWHVr?=
 =?utf-8?B?bEppLzQ4Q2N3M3A0Y1k1MzI5dXlZY1QvSEpES0RlSXBqR1lRdEtwYytrZmFh?=
 =?utf-8?B?OVpnQk5YZUVya1NkSUFwKytYck9GMjkwY2huT1ZPb1RJdGJsdGxUNHRMYjVW?=
 =?utf-8?B?eExPc3ZhQ1JseWtZVGNqNUk2OExlSmtvUnBzUzRUS2pQdWhQd2hMcVJ0R09i?=
 =?utf-8?B?b20waW1CTEpacVQrWG10UXRnZmFhcW4zUzlKblVIOFFIQTRXVEtzZk1SZ0w0?=
 =?utf-8?B?OUpVeUhNSk5QbkkrdGJhZjlJZjF6TjF6bnRDc2FUR2d0Z0JkeU5wOXZNVnZj?=
 =?utf-8?B?ZGlHeWcyekFIM1p5dVkxR2pNLzM3Zkk5eWV4Wk1UWUMwV3RPQjVJV0pPekUx?=
 =?utf-8?Q?N+QFpz9lCNEt4qG3HF/0DyTif?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9129db1-9e81-4344-cfc3-08db402a2eee
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6573.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 16:30:12.5518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zJwYimWPH+WOjyCx9fPABOZEPtaIWVjex9jjcaltsimnYzkxQta/WCBnAZiavd3ezgOEyd3YTEuyeKgaKj8pwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6713
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/17/23 8:56 PM, kernel test robot wrote:
> Hi Shannon,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on net-next/main]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Shannon-Nelson/pds_core-initial-framework-for-pds_core-PF-driver/20230418-083612
> patch link:    https://lore.kernel.org/r/20230418003228.28234-15-shannon.nelson%40amd.com
> patch subject: [PATCH v10 net-next 14/14] pds_core: Kconfig and pds_core.rst
> config: sparc-allyesconfig (https://download.01.org/0day-ci/archive/20230418/202304181137.WaZTYyAa-lkp@intel.com/config)
> compiler: sparc64-linux-gcc (GCC) 12.1.0
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://github.com/intel-lab-lkp/linux/commit/98284802ba918b756684dcf00cfa88bbab5cb498
>          git remote add linux-review https://github.com/intel-lab-lkp/linux
>          git fetch --no-tags linux-review Shannon-Nelson/pds_core-initial-framework-for-pds_core-PF-driver/20230418-083612
>          git checkout 98284802ba918b756684dcf00cfa88bbab5cb498
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc olddefconfig
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc SHELL=/bin/bash drivers/net/
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Link: https://lore.kernel.org/oe-kbuild-all/202304181137.WaZTYyAa-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>     drivers/net/ethernet/amd/pds_core/auxbus.c: In function 'pds_client_register':
>>> drivers/net/ethernet/amd/pds_core/auxbus.c:30:9: warning: 'strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
>        30 |         strncpy(cmd.client_reg.devname, devname,
>           |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>        31 |                 sizeof(cmd.client_reg.devname));
>           |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Yes, this should be a strscpy(), not strncpy().  As much as I'd like to 
fix this one thing Right Now, I'll wait another day before I repost the 
full patchset for one little tweak.

sln


> 
> 
> vim +/strncpy +30 drivers/net/ethernet/amd/pds_core/auxbus.c
> 
> de85ef78c6b4f6 Shannon Nelson 2023-04-17   8
> 283e6c9307d7f4 Shannon Nelson 2023-04-17   9  /**
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  10   * pds_client_register - Link the client to the firmware
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  11   * @pf_pdev:      ptr to the PF driver struct
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  12   * @devname:      name that includes service into, e.g. pds_core.vDPA
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  13   *
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  14   * Return: 0 on success, or
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  15   *         negative for error
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  16   */
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  17  int pds_client_register(struct pci_dev *pf_pdev, char *devname)
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  18  {
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  19    union pds_core_adminq_comp comp = {};
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  20    union pds_core_adminq_cmd cmd = {};
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  21    struct pdsc *pf;
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  22    int err;
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  23    u16 ci;
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  24
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  25    pf = pci_get_drvdata(pf_pdev);
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  26    if (pf->state)
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  27            return -ENXIO;
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  28
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  29    cmd.client_reg.opcode = PDS_AQ_CMD_CLIENT_REG;
> 283e6c9307d7f4 Shannon Nelson 2023-04-17 @30    strncpy(cmd.client_reg.devname, devname,
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  31            sizeof(cmd.client_reg.devname));
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  32
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  33    err = pdsc_adminq_post(pf, &cmd, &comp, false);
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  34    if (err) {
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  35            dev_info(pf->dev, "register dev_name %s with DSC failed, status %d: %pe\n",
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  36                     devname, comp.status, ERR_PTR(err));
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  37            return err;
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  38    }
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  39
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  40    ci = le16_to_cpu(comp.client_reg.client_id);
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  41    if (!ci) {
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  42            dev_err(pf->dev, "%s: device returned null client_id\n",
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  43                    __func__);
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  44            return -EIO;
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  45    }
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  46
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  47    dev_dbg(pf->dev, "%s: device returned client_id %d for %s\n",
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  48            __func__, ci, devname);
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  49
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  50    return ci;
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  51  }
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  52  EXPORT_SYMBOL_GPL(pds_client_register);
> 283e6c9307d7f4 Shannon Nelson 2023-04-17  53
> 
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests
