Return-Path: <netdev+bounces-3179-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A4C6705E6B
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:56:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2AAF281345
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E85E41844;
	Wed, 17 May 2023 03:56:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37FE2116
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 03:56:45 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0868619BC
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 20:56:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L2YQhtAXVumrI3BMjxOMoeWRg+cAqm4UuofBLVPV46tU9OL5/tLfA1XhLkxsGw97RROjW1KyvV76NMKJvrxEONJxx3jDXP6RiWkvwvjWYdCrBpzvAh+vpUhiNos7JggSTWP+9OJ2CzOlFgWJxP9EhJDA1u6oVjBBXZtgFD5H3ysgBtF7mnybVfKvzdHMcfZT8mkJNeH2A+QlrA1IqCj3RcAexvugjMFUNVyNnOsJOdLix087cqGusXMQ1TmaiX6hKvuLkH8v2d6Nc2QnOzgPyhRk5fi8yLkDUlfMZqlP32g74lWIVIpZInfE1UGpFwj2nNm6JtYE3AkjJhqJk8bYFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O9bVhGTXEwaHQyUFcOQ1Cyu8H3DZW6PdPShNCNVYoxU=;
 b=Sjb9HelafbYGjorgepeMVp2188Z+wrXzDsr0IXWpPicdU4qz5ati+7gnGY0Uqdt/pBPs9vNtG2v0gQT5wklnqcwRGZUCoeym4vkmPKlLjxgdGTgtlUByuAVZz6sVRJjVGqTVKh3AJhwNMKzHbx/pWucCAurDM5EXJFNOe1rVPZQO2f54r95L9CckaBIcqLKNrFw6NvugJn8bGQZPYCBjH6s74gESHl1jtH/mDsj3JZ9GbJj2/eW6MgMlJEaDavrxsuRUfdjpU9l5qagxUW9Whpx+5BpuCRMPzbeq+jkVgihEwbmNOoOdeQ+lUaVWQHS4zIk+jm1BNQ33CDWf8wjRGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O9bVhGTXEwaHQyUFcOQ1Cyu8H3DZW6PdPShNCNVYoxU=;
 b=CjGFjP65kPVz1jE1GRS2Wfd0SwSYjbsRDPfCpCzoZjM1qE8SGtJs96/ytUjoK+tB5kejJQrkN9GMmlC8bNcsCW0y8Zp02OPdRYdA0RqkrtwTfsievoaSvTQLSKs/cadEBGisZ+7Y9frIREzx+viExC/jX0qFNYlMo9tj8Ti7CNY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 MW4PR12MB7262.namprd12.prod.outlook.com (2603:10b6:303:228::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Wed, 17 May
 2023 03:56:38 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc%5]) with mapi id 15.20.6411.017; Wed, 17 May 2023
 03:56:39 +0000
Message-ID: <236e3324-8518-12aa-5792-f91124ec0e11@amd.com>
Date: Tue, 16 May 2023 20:56:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH v6 virtio 11/11] pds_vdpa: pds_vdps.rst and Kconfig
Content-Language: en-US
To: kernel test robot <lkp@intel.com>, jasowang@redhat.com, mst@redhat.com,
 virtualization@lists.linux-foundation.org, brett.creeley@amd.com,
 netdev@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 simon.horman@corigine.com, drivers@pensando.io
References: <20230516025521.43352-12-shannon.nelson@amd.com>
 <202305171042.aJUkaxnH-lkp@intel.com>
From: Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <202305171042.aJUkaxnH-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR22CA0014.namprd22.prod.outlook.com
 (2603:10b6:510:2d1::29) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|MW4PR12MB7262:EE_
X-MS-Office365-Filtering-Correlation-Id: 685f6959-40f6-4f57-8c05-08db568ab790
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	KuXl+r2rOiN7DEMRWCK7VRzQ8xH6VWBLVg1qHEpufzU5sT4FNgFczwA930/DhJGEqM6+Tv4pg+0dvWLgv/r8jPiMIrwB2lYZFaVJClnxMvut45W2LU4buVhrrAUX6hHvlOK7+1mjTjKeAGyzhiaPyovMRkrijGNB54uZGMu5lX4wenxxC4EaBp4HlnYHlajRDQwqtR2Fe7Ct0MLwev/nYwn4GgwK8qZogUlUtcN45yK8UbGb74NyvIGpLvobUZNcc7mKNZs4EBS9PdlV9bgCh+MKhKOTl4jo4wa/UY8qYkHrpFXiwaWdDxlIkNyLBAUBTdKVB4DvbySFNSFDifXeymwlQB1JaYKDbtkqPojqVKCLrDzBwctjJWQQ/CzoKYP0O4EGdjryztech9BlFjX1c7AUz5/YYYNTs7vhVoYDykJG4loveLZW3NHzo0Ss2Cam13q2l3dVCfmUwg8/lnUAg5jiN7fhPAx2IXSbz3aWbHzVeoaIEHSfeH13LyEaZm2oOciGPq0+/j2Vp2e8CdDH7gOnEjSRFpve5Uel6UxxW0WfJWlHBhDMBTEunsyGOkejZeOZxlb9V+lrVpFxD0w/ziaxF5jh7L2RIfaLQxaLrTRBZDEYmACZ2rxgdg5V7l7Idx/Cf8XLckyMsKj8CVY8uLSz1Gv7twk7o0PdT5sJKpU82AB0OfiWAVpvbehvI8ka
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199021)(30864003)(2906002)(31686004)(44832011)(38100700002)(5660300002)(8676002)(8936002)(41300700001)(36756003)(316002)(4326008)(66556008)(66476007)(66946007)(2616005)(83380400001)(86362001)(31696002)(6506007)(26005)(6666004)(53546011)(186003)(6512007)(966005)(478600001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SmtrcWFOS2tpak9qaGtjVWxMZzViV2hlMVBVRUxOVDF3OVA2enhrUXh5R1dx?=
 =?utf-8?B?RE9mKzRaUUJ1eEV5YjBGdEVRRnZpa3N6M3plTEpzcTVnRWxPR0JqOTBBRURM?=
 =?utf-8?B?UHpnUHU2NEhPdXdrRG9PMmV3blZUb1Y4cVk0K3VDSFRPME1oK1dMSTQweUN4?=
 =?utf-8?B?NWFTNklHeFpBTm1wVFVNTUVHQm1tcXhZQmtNMS91bFhXclkyOVZXNWNNNzR1?=
 =?utf-8?B?MkxMUER6ejJGb3RUQnc5ZkdrSW5mTllreWJyalh1KzBDcFliUW1LNnJBZVho?=
 =?utf-8?B?UnowNndoZXVERHZUNlFCeENiOXNGYjEzZTFGMWtYQXJzdzJqRlNpV3VxTnlr?=
 =?utf-8?B?NG1XTFN5S2Zpc01McWhtOTVaTXk0K2dJSzhMZkFVS3VEbG5oVzFEYUVLYXZG?=
 =?utf-8?B?cjlsb0VwbXBZREY4NmsyMTRhdkxtSXBlV0h2VkRZZ3VmdWZmZGlKTnI4ckty?=
 =?utf-8?B?dlE1Ty8wcDZyWGJVWmVUMUR6U0R3T0F6TW8vYk8zajhOTjhLVGgvdmdMNVQ1?=
 =?utf-8?B?TGZqUHNMWWpwcWRaaUd2Y2lrQk9IQnpBdjVjdGE5c2NBQWNTOE5ZZ1ZCdlZp?=
 =?utf-8?B?TC8rMEZodXg5bDJEeWFMMFI3KzZEYjRRRTRURmpWdldtVlkrQk84TWVwbzhR?=
 =?utf-8?B?c2hxSDNKWUZjaXhMei8yRkFwWDhuSVlwb3ExMW1CYVpDNHB6MmdyM2JrUzZm?=
 =?utf-8?B?SUdTMkNLOVNVczhjWXpSa0twWGpzcW5FTE1ESFhHVTM3NXZsVlR3SU9oOTQ4?=
 =?utf-8?B?UE90Zlc4SkNTd0R3VDBBTGkrNWJQU1VtajltU29icktKWTkwakc1cW1GSWFQ?=
 =?utf-8?B?bnlmVEptZEM3SFg5cm93bHVOVzdZNlo0WGRwVFBma2U3UVdoam54amFHWnVY?=
 =?utf-8?B?ZE5YZGppK2Rjekl2eGp0YWxuNFo0amU0KzNHT3Z1YXczdmNlSlBBRURRUno2?=
 =?utf-8?B?WHRvRDZVcW44SWRBUVlYWU1INVVkTGRyelFHU3VhaktWVTlERUM4VVgwRHZH?=
 =?utf-8?B?Q2FNR08rb2pOMlY1MWFYeHo1RVpKRlQvTzlLUElhK2dIaHU1eWtQMTZCb1Vq?=
 =?utf-8?B?OTlpN1BSaFhFemJQT25lRVFvdU15RmMrOEFxNU85WHRjMFdRQXZMdXdWQ0Z5?=
 =?utf-8?B?UTlTN3dGUys4djVwMjk3UmZPNzRUNDBUOXg2bEpxYjVqK1ZMY0dqenFmVUFS?=
 =?utf-8?B?Y0UzbGorNUFIQmZOdDZtSFFFUjdrU3VTLzlCK3BNQUVXN2RaMVBpeWtHcC9l?=
 =?utf-8?B?NWpvR2dWUjZRL2lNb1RGMHJwaDIrYTBYcDI5UDB2NGYrU3IrSW1YWG1iamFV?=
 =?utf-8?B?WVdDNmkvaHVldHRONUtZV3gwSXFKay9XK3pqOWhKQjJGVXhrNFVVOVdnNXdo?=
 =?utf-8?B?a0hFaUlodFRYV2dpc3liS0tUOUR1R2R2RlZaVDNTdXF0UHp3dXphZjJyYmcw?=
 =?utf-8?B?OUNDd2hsMEJnNFRwZjZZZ1puU0hiUWZFUEIwQ25aSm9mUnVpMmw5cmp5MGVF?=
 =?utf-8?B?WVBhTjkyd3ozeG16ZWhOekx6MG9RTy9KNzFVdHU2cHdxa2FBQVVqYUFJeDd4?=
 =?utf-8?B?aTFnUVJMbFJWMGFnWkVWTkNRdmNqMVRnYmdkcGljZEo3cEg2OCt2bXcrWFYz?=
 =?utf-8?B?VmhHZFFESnZKcUMxajJWMWRwUGVGZVcwOVRqc1BxeGtuWUFqRkgvZksrYzBt?=
 =?utf-8?B?SFlMbnRiZzBuaERuTjQxRkRUaGZLZEtHWmYzaWE3U0J5b1BsWXBISnlsK3R4?=
 =?utf-8?B?N0JtcFJ6ODJxOTF3aXNtZU9Tdkc5RUowWDJndTlLQ1RiVCtFa3BSdzFCWmUz?=
 =?utf-8?B?UzJxTXpHaVB5eTZBa1Zpcm1ES1ozY2FWZnBzZmtjcDBRRHJLTkV0T1U3UEp0?=
 =?utf-8?B?akN0VmJUbXpzbVZ6bHR2NnB6NmM5Z0ZCMnZaM0lETHFLMWlON1lIVVNRaUlF?=
 =?utf-8?B?SDBKWnZYNytSVUtxMHdWVW9ndlFUMGNWV3Q5RXNsL0U3Mmpnd1FQeUpkM2NC?=
 =?utf-8?B?WlpUcFJnbGdhTk1zSXNqSFl1elJZTFRRQnJVWFdhaDBQQ1hiQTBTVXZFSzdV?=
 =?utf-8?B?UW1IaE4vRFB3R0dBWEYrUlY5Y09GcnpJUnl6SkZiSjg0Z2RoWEJXL2tScUV4?=
 =?utf-8?Q?HEgcEjUUBXf3/hLcBC5aLyB9e?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 685f6959-40f6-4f57-8c05-08db568ab790
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 03:56:39.0785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qibs8S4rUpp7XxL7TdvnqwqL6dNm3b13s/Ld6QAKqU2nKZw509yaw0p4r2sNzyX+77pMTvkQ61HLmWDGKQSh1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7262
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/16/23 7:24 PM, kernel test robot wrote:
> 
> Hi Shannon,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on linus/master]
> [also build test WARNING on v6.4-rc2 next-20230516]
> [cannot apply to mst-vhost/linux-next]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Shannon-Nelson/virtio-allow-caller-to-override-device-id-in-vp_modern/20230516-110049
> base:   linus/master
> patch link:    https://lore.kernel.org/r/20230516025521.43352-12-shannon.nelson%40amd.com
> patch subject: [PATCH v6 virtio 11/11] pds_vdpa: pds_vdps.rst and Kconfig
> config: arm64-allmodconfig
> compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project b0fb98227c90adf2536c9ad644a74d5e92961111)
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # install arm64 cross compiling tool for clang build
>          # apt-get install binutils-aarch64-linux-gnu
>          # https://github.com/intel-lab-lkp/linux/commit/4942556344e0c7cdf4719dfbd0e17c0f2b620b30
>          git remote add linux-review https://github.com/intel-lab-lkp/linux
>          git fetch --no-tags linux-review Shannon-Nelson/virtio-allow-caller-to-override-device-id-in-vp_modern/20230516-110049
>          git checkout 4942556344e0c7cdf4719dfbd0e17c0f2b620b30
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 olddefconfig
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash drivers/acpi/ drivers/infiniband/sw/rxe/ drivers/staging/media/deprecated/atmel/ drivers/vdpa/pds/
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Link: https://lore.kernel.org/oe-kbuild-all/202305171042.aJUkaxnH-lkp@intel.com/

Thank you, Mr. Kernel Test Robot, I have this on my list.

sln

> 
> All warnings (new ones prefixed by >>):
> 
>>> drivers/vdpa/pds/vdpa_dev.c:568:7: warning: variable 'err' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
>                     if (unsupp_features) {
>                         ^~~~~~~~~~~~~~~
>     drivers/vdpa/pds/vdpa_dev.c:669:9: note: uninitialized use occurs here
>             return err;
>                    ^~~
>     drivers/vdpa/pds/vdpa_dev.c:568:3: note: remove the 'if' if its condition is always false
>                     if (unsupp_features) {
>                     ^~~~~~~~~~~~~~~~~~~~~~
>     drivers/vdpa/pds/vdpa_dev.c:536:9: note: initialize the variable 'err' to silence this warning
>             int err;
>                    ^
>                     = 0
>     1 warning generated.
> 
> 
> vim +568 drivers/vdpa/pds/vdpa_dev.c
> 
> 8b05d813374db7 Shannon Nelson 2023-05-15  524
> 8b05d813374db7 Shannon Nelson 2023-05-15  525  static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
> 8b05d813374db7 Shannon Nelson 2023-05-15  526                       const struct vdpa_dev_set_config *add_config)
> 8b05d813374db7 Shannon Nelson 2023-05-15  527  {
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  528   struct pds_vdpa_aux *vdpa_aux;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  529   struct pds_vdpa_device *pdsv;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  530   struct vdpa_mgmt_dev *mgmt;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  531   u16 fw_max_vqs, vq_pairs;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  532   struct device *dma_dev;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  533   struct pci_dev *pdev;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  534   struct device *dev;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  535   u8 mac[ETH_ALEN];
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  536   int err;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  537   int i;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  538
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  539   vdpa_aux = container_of(mdev, struct pds_vdpa_aux, vdpa_mdev);
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  540   dev = &vdpa_aux->padev->aux_dev.dev;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  541   mgmt = &vdpa_aux->vdpa_mdev;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  542
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  543   if (vdpa_aux->pdsv) {
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  544           dev_warn(dev, "Multiple vDPA devices on a VF is not supported.\n");
> 8b05d813374db7 Shannon Nelson 2023-05-15  545           return -EOPNOTSUPP;
> 8b05d813374db7 Shannon Nelson 2023-05-15  546   }
> 8b05d813374db7 Shannon Nelson 2023-05-15  547
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  548   pdsv = vdpa_alloc_device(struct pds_vdpa_device, vdpa_dev,
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  549                            dev, &pds_vdpa_ops, 1, 1, name, false);
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  550   if (IS_ERR(pdsv)) {
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  551           dev_err(dev, "Failed to allocate vDPA structure: %pe\n", pdsv);
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  552           return PTR_ERR(pdsv);
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  553   }
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  554
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  555   vdpa_aux->pdsv = pdsv;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  556   pdsv->vdpa_aux = vdpa_aux;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  557
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  558   pdev = vdpa_aux->padev->vf_pdev;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  559   dma_dev = &pdev->dev;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  560   pdsv->vdpa_dev.dma_dev = dma_dev;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  561
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  562   pdsv->supported_features = mgmt->supported_features;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  563
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  564   if (add_config->mask & BIT_ULL(VDPA_ATTR_DEV_FEATURES)) {
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  565           u64 unsupp_features =
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  566                   add_config->device_features & ~mgmt->supported_features;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  567
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15 @568           if (unsupp_features) {
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  569                   dev_err(dev, "Unsupported features: %#llx\n", unsupp_features);
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  570                   goto err_unmap;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  571           }
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  572
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  573           pdsv->supported_features = add_config->device_features;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  574   }
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  575
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  576   err = pds_vdpa_cmd_reset(pdsv);
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  577   if (err) {
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  578           dev_err(dev, "Failed to reset hw: %pe\n", ERR_PTR(err));
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  579           goto err_unmap;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  580   }
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  581
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  582   err = pds_vdpa_init_hw(pdsv);
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  583   if (err) {
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  584           dev_err(dev, "Failed to init hw: %pe\n", ERR_PTR(err));
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  585           goto err_unmap;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  586   }
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  587
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  588   fw_max_vqs = le16_to_cpu(pdsv->vdpa_aux->ident.max_vqs);
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  589   vq_pairs = fw_max_vqs / 2;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  590
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  591   /* Make sure we have the queues being requested */
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  592   if (add_config->mask & (1 << VDPA_ATTR_DEV_NET_CFG_MAX_VQP))
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  593           vq_pairs = add_config->net.max_vq_pairs;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  594
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  595   pdsv->num_vqs = 2 * vq_pairs;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  596   if (pdsv->supported_features & BIT_ULL(VIRTIO_NET_F_CTRL_VQ))
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  597           pdsv->num_vqs++;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  598
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  599   if (pdsv->num_vqs > fw_max_vqs) {
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  600           dev_err(dev, "%s: queue count requested %u greater than max %u\n",
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  601                   __func__, pdsv->num_vqs, fw_max_vqs);
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  602           err = -ENOSPC;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  603           goto err_unmap;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  604   }
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  605
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  606   if (pdsv->num_vqs != fw_max_vqs) {
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  607           err = pds_vdpa_cmd_set_max_vq_pairs(pdsv, vq_pairs);
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  608           if (err) {
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  609                   dev_err(dev, "Failed to set max_vq_pairs: %pe\n",
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  610                           ERR_PTR(err));
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  611                   goto err_unmap;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  612           }
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  613   }
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  614
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  615   /* Set a mac, either from the user config if provided
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  616    * or set a random mac if default is 00:..:00
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  617    */
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  618   if (add_config->mask & BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MACADDR)) {
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  619           ether_addr_copy(mac, add_config->net.mac);
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  620           pds_vdpa_cmd_set_mac(pdsv, mac);
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  621   } else {
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  622           struct virtio_net_config __iomem *vc;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  623
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  624           vc = pdsv->vdpa_aux->vd_mdev.device;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  625           memcpy_fromio(mac, vc->mac, sizeof(mac));
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  626           if (is_zero_ether_addr(mac)) {
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  627                   eth_random_addr(mac);
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  628                   dev_info(dev, "setting random mac %pM\n", mac);
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  629                   pds_vdpa_cmd_set_mac(pdsv, mac);
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  630           }
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  631   }
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  632
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  633   for (i = 0; i < pdsv->num_vqs; i++) {
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  634           pdsv->vqs[i].qid = i;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  635           pdsv->vqs[i].pdsv = pdsv;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  636           pdsv->vqs[i].irq = VIRTIO_MSI_NO_VECTOR;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  637           pdsv->vqs[i].notify = vp_modern_map_vq_notify(&pdsv->vdpa_aux->vd_mdev,
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  638                                                         i, &pdsv->vqs[i].notify_pa);
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  639   }
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  640
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  641   pdsv->vdpa_dev.mdev = &vdpa_aux->vdpa_mdev;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  642
> 10cd19d8803330 Shannon Nelson 2023-05-15  643   err = pds_vdpa_register_event_handler(pdsv);
> 10cd19d8803330 Shannon Nelson 2023-05-15  644   if (err) {
> 10cd19d8803330 Shannon Nelson 2023-05-15  645           dev_err(dev, "Failed to register for PDS events: %pe\n", ERR_PTR(err));
> 10cd19d8803330 Shannon Nelson 2023-05-15  646           goto err_unmap;
> 10cd19d8803330 Shannon Nelson 2023-05-15  647   }
> 10cd19d8803330 Shannon Nelson 2023-05-15  648
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  649   /* We use the _vdpa_register_device() call rather than the
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  650    * vdpa_register_device() to avoid a deadlock because our
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  651    * dev_add() is called with the vdpa_dev_lock already set
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  652    * by vdpa_nl_cmd_dev_add_set_doit()
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  653    */
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  654   err = _vdpa_register_device(&pdsv->vdpa_dev, pdsv->num_vqs);
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  655   if (err) {
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  656           dev_err(dev, "Failed to register to vDPA bus: %pe\n", ERR_PTR(err));
> 10cd19d8803330 Shannon Nelson 2023-05-15  657           goto err_unevent;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  658   }
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  659
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  660   pds_vdpa_debugfs_add_vdpadev(vdpa_aux);
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  661
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  662   return 0;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  663
> 10cd19d8803330 Shannon Nelson 2023-05-15  664  err_unevent:
> 10cd19d8803330 Shannon Nelson 2023-05-15  665   pds_vdpa_unregister_event_handler(pdsv);
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  666  err_unmap:
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  667   put_device(&pdsv->vdpa_dev.dev);
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  668   vdpa_aux->pdsv = NULL;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  669   return err;
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  670  }
> c4cc9ee57a0c5b Shannon Nelson 2023-05-15  671
> 
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests

