Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0451E63B4CA
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 23:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbiK1W0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 17:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232854AbiK1W0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 17:26:33 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DB7317D6
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 14:26:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g6mn8mgw6PNc7CT/LjCwzYGaulKsNluz+Gp7rP1lG8Wr9h5A1rOVFUMhogd2+PqI5NuwdLvxjPgEobGFxmiKbCk8oKYL5EusgzIyJPOo+yPkCMXybyBcAqlxbI23AZyElHTfO9HLVwo7GzEc6iywdbNsnDWA6luC6z/J9l+5em78k3VZWFRF8ZZGxGWD0jLGPeDjEeGLpT3DRH7XFhSTP0VTK1PFxf+Piqg5WWNqiwQqXUW8T0ENkp9ZD6uAqBPf1StIqjhYmqqK7D0AoJ8wm/of0bOXleNgmFudInQUXCVi1xPaG7YtMeJGY1Ft3x4jVo95GxeY/H5O4DVENw8BgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k6k6XJLXTwsmq/zxnl+qZ23qMe8vJNZb+sG34vc82po=;
 b=XG4UWl/G/QTY1dsNgzseDT2x+/EL8YbJwH2sMMgUECekX1uFXpJmzJucEk6feUyPbK1ceOlpf3gFD7Mr60UklcusPu9hPZLZjUbEmdh8dVT2cavgd6OtXvD0iQmUWyzZz4jVpHLNvKuC7NBKbSOs5Xv7agkZhBxs8RZN9tCj0v2eML4rzB0ANJIzFpZoVi4kYMV0Krvyjepx3SOy5XLID5MnC/nez+VZgVudPpAWae6cxP1xgFcbbVcMGTwH+YwapZQ0UlPPkw1sQSByhHMmx+QwS9CweUezwZo5kB0xHjgI9Je3KjLwRVaHLko2U77DhZqlyQyCdNtynbrlVmZSng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k6k6XJLXTwsmq/zxnl+qZ23qMe8vJNZb+sG34vc82po=;
 b=EGp0LNqcvTkwPI46MGcGFtSOf4RMggdew6d5O3RIjlovpcBqw6pLhef36T7P6YRmFBMrDfUAQLSvNgOU0b+ACYX1uHfR5hL5K7iaCJmtHTPLwjfvt5n0SO2NK1tDyUTxR09tyFnPvAlUOtMWNzIfencMiN/eBaDPTKAxuUpxATQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CH2PR12MB4924.namprd12.prod.outlook.com (2603:10b6:610:6b::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Mon, 28 Nov 2022 22:26:29 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 22:26:29 +0000
Message-ID: <f7457718-cff6-e5e1-242e-89b0e118ec3f@amd.com>
Date:   Mon, 28 Nov 2022 14:26:26 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [RFC PATCH net-next 10/19] pds_core: devlink params for enabling
 VIF support
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        drivers@pensando.io
References: <20221118225656.48309-1-snelson@pensando.io>
 <20221118225656.48309-11-snelson@pensando.io>
 <20221128102953.2a61e246@kernel.org>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <20221128102953.2a61e246@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0018.namprd13.prod.outlook.com
 (2603:10b6:a03:180::31) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CH2PR12MB4924:EE_
X-MS-Office365-Filtering-Correlation-Id: 722f4aa7-0629-431c-9e45-08dad18f9870
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HQf2UTu6gfjkKJ08RSJWkStRA8VFsjqAZx4Go4urGSfOg3CAWCalBUHpN57dKPPV14eAVfULhKcwZBT0NNPXpwtj+ReMXyToHjrSsXZPgnfNjWuTI0ZZzlAwGdiBUClLR3bUEM7fuAxqMDhM1CdHM3lo4w06U16Pe4on1+6XRMQKJzLbXsWMKanZgfGRpWC3hejvTPkUvIz9DDM3aW7Nz4KGz/W1gfhIO8Uk0sNVKI2qrpi7W/W/CMQIXVhOhTEJteTnHcYt/XY6gR0gsI8TJZmjdxuZupQfHhPB8bQl1EJyh0Mdj8fgrSS4brim1dVlOIczHy4mXiLONlmFxspP/3UYs+dSf2W7ERRZmAyMTqRJs3wCG/dZfLoc/h8dUUfn7wqVvig2yvw1WFBNXtO8zha7BT4zNAsYV3chyqJyVdrj6JS5T4X6kXXBUgF4QHO8K3FbBt+W29qh0N60H8pLcbZcH/4uTguRKYBUJUm26Wms+0PA5Vw/OUqtfgryGs3flzWAR1UEPpN35gUEPctdWRn1jJxe8fYS9qGxxxdW9i7Gms7F94+HPUNZNXfIcxXMne6biakTt7s88Ve2OODj8EpNXY99cvPDTE2uQDuzr8YI4hB/nOu8uOeFGNd46O2q956bly9P2352kO5WNxrcpYUCXIXX7EBEvXH8HdhqsS0WNqAJK/8pWHOsVg4w+2ZsIQe9pbI/qkkYGiCubgcXbhab71adg+zYDDlwOPrIcyU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(366004)(376002)(39860400002)(396003)(451199015)(5660300002)(4744005)(31686004)(66556008)(66476007)(4326008)(8676002)(8936002)(41300700001)(110136005)(66946007)(6486002)(36756003)(2906002)(316002)(478600001)(31696002)(6512007)(53546011)(26005)(6506007)(186003)(2616005)(83380400001)(6666004)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVVtbkNCYzhlZ0RxQzZXNHZrbFBWTDF1bTExL0JNYXRUeWVRZkd5VjhTYUNN?=
 =?utf-8?B?dy9MNEh0Q0xIdVBOSEdRL21PcE11TW5HVlFISGV1c2lCV2R4Q3IzR0o3RTRB?=
 =?utf-8?B?Ri9uU3Jrc25OcmtmQUQrZTI1UW8rdU1HQjBQSXVVYU1QN2oyTTNpeXZnbkFh?=
 =?utf-8?B?M0JYbDBsZG9EcktLME1mUjlGVi95VDhFRiswZ0xtTkx3dGFqaHVEOTVjUGxC?=
 =?utf-8?B?bXNmTHdGbXlDd0JVdDhGcTVuRlJ6WjNEdkwyTVExTXlOZVdsL1NYRks0Qjlk?=
 =?utf-8?B?YktZNlo3Yml1M21XaVJCNm5KN2ZFZFVDQy9lOGgyUnFsdFNqZEFkRnZkUnN6?=
 =?utf-8?B?Nk1pUElpNUh5Y0JJamMrNXY3eEJXUlRBSnpQd2xqRHNHTDBBWUJkbUgrSFBu?=
 =?utf-8?B?N3Y5UUVNNHA5cUxGOWo5U0poY3VxY05CWWJ1bGl0bVpMUEpIbEZNWGlPQ3gr?=
 =?utf-8?B?K0VtbStDUEFWTVJUbDRkQmxiNktpZE5FNE9TeWtqWDF1NFZzZ2MvVEZwT2p2?=
 =?utf-8?B?SHNqKzRMa0gzQVBTbSt0bEtwZEI4YjhGT2hXYzF6N3lXMWN1WTk5MFpFQWQy?=
 =?utf-8?B?cHNuLzY0VThVSnVPalNmeWNNZkxET0xaQnVCbG5ZNkZtRkpNcXhGdGVTTWhO?=
 =?utf-8?B?R1JuOEk3UlJ0OXYrc2JNOG9Ia0RmbVRuYkpjRCt5OEpmU3daM2pucGl0dmZa?=
 =?utf-8?B?M0JxYzkzSGx6SWk4OWxRdUc1ZHNWZGhXbUtUQVhFdFdWbVRtQzF2QXBCM0lU?=
 =?utf-8?B?a0JPU1lZRURtM2kzSGFoN25LcERVTmkwY3lYNTVlMkp6MFVPOUVtamYvby9J?=
 =?utf-8?B?bzNvYnBLNWtWQ3ZheXZOUUErWEhlbEFSZkJnei81Vzg1V3gyVENja04wTU00?=
 =?utf-8?B?RmtuL2ZrQVViUXRrUFpVbUY2UjNtYVNHUThSUk1zd09DYmI3aFdWeklDdUNN?=
 =?utf-8?B?NC82aWV4RnlZWTFVTlRhRGFsaE5ZcXEwUVZBamNEVHBiU2l2RUhWTnNabHFW?=
 =?utf-8?B?ai9SOEJ6VDBVM2VtVDVVdTVEaWswL0xtYloxaFhHbCtrYXlMajZtVWNmMkdv?=
 =?utf-8?B?dXgrbUtNZHVjaUhVdDM3QXBqN0NiamZEMFJJRTFLd1BzekgvY2NUVE80Q003?=
 =?utf-8?B?eGpQSE80bmdHV2FFdGttNE4zY3FpV1JWaTdZV01VWHBtQ2R2U1BXdmk0ZjN0?=
 =?utf-8?B?TDBFQkoxSjVKVWQ4TVBaSXYwNGl6eEZrTStGcVJGenhER0VDSzVQL0IrYWRj?=
 =?utf-8?B?a1RnMGRFTnNKZ3QxQ01uR3E2NUlOaHdNR09rSGsrN0V3aVljT3FVTyt0T3VY?=
 =?utf-8?B?REVDd3NPS3VKSy9pQ1NNOTFRMHppK3NFUW5mKzRWNUMweFphQ1pBRXlvcHJl?=
 =?utf-8?B?Vm5nWk1Cb0ZSOFcrSVAvS1Rzd200ekVHanZrMkUvUk9WS3dIUi85Z3N0NFg0?=
 =?utf-8?B?TU1aeHlFYXJuczlVOU95cTE5Z2lHNnlUSjcxbG9qdkl1VjhPbzQzVHF4NVNy?=
 =?utf-8?B?eEhOSzBaczZvVkpvTG1SZXVxSVNwVWpJUFpvRmgyWkJLdGpMZldlQkZoK2lx?=
 =?utf-8?B?UjNEOWEzWUZPZFZIUlowMXluNk1ZSnBuU0dPK2ZFSExrUHJUQm01MlVjMzdj?=
 =?utf-8?B?Mnp5SEYzN0JZcGsrVFNLdXVLRzJuUU1RemY4S1RXNXV1dWRlSXJDa2htNjZQ?=
 =?utf-8?B?ZHFkbFlWYVMwdTFTT0JSNldkczhMZ1JPUTEvQ214YWtXdm1LSVJaYmZNM2dj?=
 =?utf-8?B?R2ljMVh0MGg2VWdWRFRMdzIreXdtZ3pIYmdXM1hGT1gzTjBkaTFGRUZWR0Q1?=
 =?utf-8?B?TkZjWHRpdFZwTHNLUWREK0dtTm1NT01RNzBCRzFId0E1ejRKNUVNZE8zc1pC?=
 =?utf-8?B?OXJPaE96WEV5WVkxcW9LZlhZaUNUVzdBY28vZTg5SVB0N1l4NjVCTzUrSmpw?=
 =?utf-8?B?UTZ2bkpBYW9rZkhRQ0pKNmlMOW1nUFhhTloxMmN6ZUdUQmQ1S1B2dVh6a01S?=
 =?utf-8?B?b0RaVVNIYkp2RmZUZGlCMC8rT1VHSTliWDFTRTVoNTZSOFRselk3akYzcDNv?=
 =?utf-8?B?eEp4RzBmei8xQmNoZEd0cy9zd0tHamthQ0I5cFVybkhrU016ZjRHMXZWWUs2?=
 =?utf-8?Q?Ffm7rqmUkLDA/e+bMLGY9XBEH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 722f4aa7-0629-431c-9e45-08dad18f9870
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 22:26:29.5486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uK+4xgJlns6lYUFpAvJ5KOKZaWcyeuZpoU4va5Wddd43GwPegn+ZpWdbncqfAqwMiXjWXxULLdpSQYl+D6KUzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4924
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/22 10:29 AM, Jakub Kicinski wrote:
> On Fri, 18 Nov 2022 14:56:47 -0800 Shannon Nelson wrote:
>> +     DEVLINK_PARAM_DRIVER(PDSC_DEVLINK_PARAM_ID_LM,
>> +                          "enable_lm",
>> +                          DEVLINK_PARAM_TYPE_BOOL,
>> +                          BIT(DEVLINK_PARAM_CMODE_RUNTIME),
>> +                          pdsc_dl_enable_get,
>> +                          pdsc_dl_enable_set,
>> +                          pdsc_dl_enable_validate),
> 
> Terrible name, not vendor specific.

... but useful for starting a conversation.

How about we add
	DEVLINK_PARAM_GENERIC_ID_ENABLE_LM,

to live along with the existing
	DEVLINK_PARAM_GENERIC_ID_ENABLE_RDMA,
	DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET,

By the way, thanks for your time looking through these patches.

Cheers,
sln
