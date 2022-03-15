Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85C7B4DA3A8
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 21:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351501AbiCOUEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 16:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351472AbiCOUEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 16:04:23 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E2124F01
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 13:03:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m1lKMA+E356j99hhlcR9nuTXbuVVLSupVlpxxS4UgB6whlZPg7LVBPDoAFhCNAOUprxVYleuUicVNaF8ZrDEkCCzd2FBxmjtvnlFiiAWbPHQj3/bQFhY6CUdGOgHUpTlfiUYqrHB+fEz8HLNOpLWazixPaH+K1abm5WFnGy0kI+3f3aW3fODtxQUXHIvHb7E5N9tAXpKmAfpQTk3U6LIL94JLBAUzTUeAoFi+CKqB1RieS1h3ix7R3FU8QKw53XuDILgduvaMW3OLuTFg3uQSpzhdnRT1qJ6qrA5XIXRe5Y74DsazuqGwj3gjjmmSpu3omL2NZh7Vyn8qEW6V/kroQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g/pEebrXKguITYHb1Ila1Lz8k4r3rNQz37eucn7f1fk=;
 b=QUR9SOIWToS3q5QlSnuUg7/J0UHYLD9yKJuXTso+VMU5Zt1f3dzFO2XepfeLa9zAFBlAXjzgGFpTjFaHmjXMMwh6M14GrXW5FV/GOW+eO/FLUsmtVGbLHwYLvF5S84hZFB1YJhm7uMKfJlPDYserr5M3xs0iO/V9/ZYOkvbdyTGPO6MikXf4u9zAuTZ+Z1F5d/bAujjzpFV4X1jLNSBfBIMUPDMqhZd2xM/G0LkDkJVKPNrmOSxAbMfIhlEQcxC0pbknlfXK48FnQAYQlNje9YJA9IJ//AVL1wcAz8DGu7CLw0NUnLMf7FXNHpDChgukge97Ind1BQn3FtwBaJUGKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/pEebrXKguITYHb1Ila1Lz8k4r3rNQz37eucn7f1fk=;
 b=TkgC9edxwt7clsYNGdnr9WQAwsWle1nq6c5zADXhq8oZfEoFuiyFcJuwYbxb/0Y8FbEPWLvynJuq0sx7c0WmeLzFdkDHH4sefNcjWMTIf4BrctO4tH14+wnYC10WZ1X2TOQsHA8x7FSSy55dWu6DrSObsNemU8pS6mNfsiiGt8pquDuMKzMy1Fm4QGsf7UPjFZsQKPFE4mu/oU/nOJTA3lc4zK7UL7zRGKSQDq8d+nGIsHousvn9bT4drkhKhFBk5I2xIulPUE3TvhB980SxJtOpoOfq/EnxGByLQZqyFAXM714JQVRgzwADQy2jqMzbSOLm+Sbzmf9/ZzS0dKFxpQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by MW3PR12MB4508.namprd12.prod.outlook.com (2603:10b6:303:5b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Tue, 15 Mar
 2022 20:03:09 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::e037:47db:2c40:722c]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::e037:47db:2c40:722c%5]) with mapi id 15.20.5061.028; Tue, 15 Mar 2022
 20:03:09 +0000
Message-ID: <59620a57-f465-917f-1773-65fcf594d3aa@nvidia.com>
Date:   Tue, 15 Mar 2022 13:03:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC net-next 1/2] net: ethtool: add ethtool ability to set/get
 fresh device features
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Jie Wang <wangjie125@huawei.com>
Cc:     mkubecek@suse.cz, davem@davemloft.net, netdev@vger.kernel.org,
        huangguangbin2@huawei.com, lipeng321@huawei.com,
        shenjian15@huawei.com, moyufeng@huawei.com, linyunsheng@huawei.com,
        tanhuazhong@huawei.com, salil.mehta@huawei.com,
        chenhao288@hisilicon.com
References: <20220315032108.57228-1-wangjie125@huawei.com>
 <20220315032108.57228-2-wangjie125@huawei.com>
 <20220315121529.45f0a9d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <20220315121529.45f0a9d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0047.namprd07.prod.outlook.com
 (2603:10b6:a03:60::24) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d5c41da-2a5e-433b-ed20-08da06bed39f
X-MS-TrafficTypeDiagnostic: MW3PR12MB4508:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB45086E2220B5AA6FF90AD8DCCB109@MW3PR12MB4508.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K0/OHzH3YY6m7rAmEW3Z0JlO653IbFM12iV4QOPOpI0l0wwO64X9ljNI2QYiaJLNy0D4+qKqMGDWhO603wyMVJ7IvXGkGWXDxRA01rYjPi/qBVw6ogHpW56G+UaWDmmk8teXQ+3uw1jf1QTV3o4PL6WC9zdxEywHZe1qcPS21ySq1ZyTKZSGdT80eeYmSNxrMRMxenMZrTP9JA0dgbPJHksvJUm/v009tcC3klEqNc6BkplN0ARrS6TGGx6lVeXhgOmeSB9KWIObsz34BQPHUgTkznfN01W5q2Ytn1xT+qCYsh6P3qqXasQA/JHnmnOyKL/ABuF6qi4btpvOQzA3p1Ofaoh3IuFVgJA6byiZinm9XMsrNYfIA9NRa7bou0aBwCtMEseP2SG5313KtNMHxB+x/OcPhY8jEOb0mHNgbl7fAgpIJH8/MEkowj/6PpF8mb9wcbgsHobRs/XBrPvgl2xvTMAS2VDzY6nZLBPm7DvtH/Z2HhXBANcTh6rOv7kaaxzPcg8Ct9fB/m9i+pi3zEdJI+Hng4xVn6W6nrlVmd4tNyBbntEbnejjEDGWsNtDbbuvvwxn+Rp64qIAxWQ17IuLjsu1P3WLEsbb95ln+ZbZPVDiH/ifw3kbO3lj3niOf6qzL1FTyO84VFozeIXmAeelHxVcOIVQlRKb6FEcfL7b7OSbSVsTzGPlq9J/3SHcXS/eDgawbzXG1EWb01jbm14r0MHeLxur+wFCQsNwo2/GIrnP63GlHEnsKSUY/RGz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(7416002)(5660300002)(186003)(53546011)(26005)(6512007)(83380400001)(31686004)(38100700002)(36756003)(6506007)(6666004)(8676002)(66476007)(66556008)(2906002)(4326008)(66946007)(86362001)(31696002)(316002)(2616005)(6486002)(508600001)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnZ5aTh6Z0Roa3V3L2tTWURxRW0vam84OFlyV2pPQmZXcTI4QngxdllUMDI4?=
 =?utf-8?B?R04rdEczMVFvSlF2OHExWFRoaTVCRUp6M1U4cHVqbW1WZ213SEV4M1BaeHBY?=
 =?utf-8?B?U2U5RVdGanNVSFNNZDFqTWZLZExlcHFDdEZoNXIvV2ZqUWlUcW1VR2ZHME5S?=
 =?utf-8?B?NzUzY3lCV2kzaUsvRW9nUGg2KzFrZkM5YU1yNGMvWDZUaHhDKzlCTlFTM0xR?=
 =?utf-8?B?Z3pHUitMZytNdkJkcjlUQjBhQVE3QURjU3dBck5USjJ0Mzd6NkhyM1k1dGNk?=
 =?utf-8?B?N1NWU3pnb0o4akRRSWpwRWQ3WW44SGVRVEc4S3ZuWExDZmlvMnE2cXdUUUFk?=
 =?utf-8?B?TG9mb0xzNDQyd2c4NVBOcExqbFdhM3EzRmxQTGdJa1JCT1dWaWpYL3BvSEJJ?=
 =?utf-8?B?azl6ZTRyS204MlhENFdVcVNSM3RNSVBhT0hGLzNMeFpVTXhldkJGSUljS3pO?=
 =?utf-8?B?SlJTNGtEL0ZlUEhJZkRtcVlXQmJsUTFqcWZ0ZXZRK0VMTVNIOVFnNEo4RVFz?=
 =?utf-8?B?Z0xCK3FKRHlYSzVweGlkWU1NWE5vWjVKcGdWZHIrWEhsWmZ3M004d21QMHlU?=
 =?utf-8?B?NlFBU2xCTk0veW5QUjlWOFFsaFRNQS9FTFJXQTNob1UrNjc5L1U0OHZHYVZ3?=
 =?utf-8?B?bTR0V2NmTjhkK1EwQWJrTGJvb0lMRzl4QUNrS2lKRkZ4bXJVaGlWa0k1OVBw?=
 =?utf-8?B?b1RoVTNDcHB2RnJRQkpFakhxeC9sNVc5eFE0QkVibGJ3NVBNVVRMNXk4Zmpl?=
 =?utf-8?B?NUo2RkMrYnkxVm1DZ0xCc3dkQWtJZXRhSmVOaXpZL2FLbGVSUXlGN1hiVk4z?=
 =?utf-8?B?NGxaS2RBdW9ETnpEUzBLejVvZG1ycXNIK09zQTR5b1lCWUl0WkNiR2tncnRj?=
 =?utf-8?B?ZzNVWWppOWwyaHBhZ1NPY3pZekRHTGZGVEs1U2N4aWlFNCtwMUY0YkxGQzRm?=
 =?utf-8?B?Y056RUtGSDhDekkyOEtsZmtyZ1RKWlVsMDlzM2tQZk5UaGtUZG5BNUlwVUlF?=
 =?utf-8?B?VXBKT0FycnJYOGhoOUgwRllsL2oySk8xWEc1NUUzR0R3djhXN2FUbkVzMTBP?=
 =?utf-8?B?b0k0MDhJTkplb1FtVlJIck9ZZ1ZTbkxYekY1NUNKcy96aE1XeHBCVjlWdHFt?=
 =?utf-8?B?WHVIYloxMDBMMlVnNERXaVViQTkzSFRVc2ZzL3NZL1A4Ykg5b080M3FpbTl3?=
 =?utf-8?B?V1lmRGFKRWVnbmZtZFV0QmJOclprM29wZ2NFTWkyTG93Nk0xaDFhaENHOERJ?=
 =?utf-8?B?NGxGVWVQdnoyaUEycGRqcXovZjVlRmp1MXRKcDFteDBsMWRRSnFHVmU1MzVH?=
 =?utf-8?B?QkxGQVlSeTlUVWFLTnlvUTlXNktNc0g0M0x3NWlVOW5rZVhKNXNlenFjanM2?=
 =?utf-8?B?c1orZHBMN0pPdUI1aVpiY21EMGlEVkpZOWNkWFNHVDVEdk9IU044ZXlrMzN3?=
 =?utf-8?B?RkFnSFpOSk5DQXZ2RG1tcmh5NHFLak5UYkZoN1FYeFQ5RDhCNkdLQko2WmdN?=
 =?utf-8?B?Yk93MXRKY2hRNFJWMGFzTkFwQkFlWUlXWmZnOVQzRmdUeEorbS83b0hVOW02?=
 =?utf-8?B?MDJmcDF6ZmxZZXJ4M090RGZOSmZEVERFVTh4TFV4bDhxeno0QXR3VGwwVm5t?=
 =?utf-8?B?dnNaSGFrdGxwZjA0c0JZeTIrenB0cG11S0dSMy83YS81cC95Q1VHZWE5SHFV?=
 =?utf-8?B?K2RGOE9NOTVIbUQvSXQ3VlZWRGhHWmpGdXdya09YTXRRN2szYkZTekFvS1d6?=
 =?utf-8?B?SE11OEhGcEYxM2l3QkduUFFSNmU2VE1wSVFlU25ET2ZsN0xvdFVwVUxSSkNa?=
 =?utf-8?B?eWRBTjhHOXkveHc5Q2IxMElIQjJWWU5MREgrU05YeHVuUHdpUGJaNUlFSVIx?=
 =?utf-8?B?NkgyeEJTY0pQRnNnUmlMRGRmNzkyalgxNnd1cW1neDA0bUZQWDdKbXFHZDRJ?=
 =?utf-8?Q?wlLQidDQVnlnYLk7DsNSJWaOgarN82LY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d5c41da-2a5e-433b-ed20-08da06bed39f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 20:03:09.1622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bqVmTSP+3Gt2kuVjH07RLnh+Ef4PWcWk58pJvgpx57LgsXpAbpWQWSuzKTNZIMsQe+usRotHe9MAnzHIVcgOtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4508
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/15/22 12:15, Jakub Kicinski wrote:
> On Tue, 15 Mar 2022 11:21:07 +0800 Jie Wang wrote:
>> As tx push is a standard feature for NICs, but netdev_feature which is
>> controlled by ethtool -K has reached the maximum specification.
>>
>> so this patch adds a pair of new ethtool messages：'ETHTOOL_GDEVFEAT' and
>> 'ETHTOOL_SDEVFEAT' to be used to set/get features contained entirely to
>> drivers. The message processing functions and function hooks in struct
>> ethtool_ops are also added.
>>
>> set-devfeatures/show-devfeatures option(s) are designed to provide set
>> and get function.
>> set cmd:
>> root@wj: ethtool --set-devfeatures eth4 tx-push [on | off]
>> get cmd:
>> root@wj: ethtool --show-devfeatures eth4
> I'd be curious to hear more opinions on whether we want to create a new
> command or use another method for setting this bit, and on the concept
> of "devfeatures" in general.
>
> One immediate feedback is that we're not adding any more commands to
> the ioctl API. You'll need to implement it in the netlink version of
> the ethtool API.

+1,  it would have been nice if we did not have to expose the change in 
api for features via  a new option.

harder for user to track which features need new option.

ie, if possible, it would be better to internally transition new 
features to new api.

(i have not looked yet if moving to netlink will make the above point moot)


