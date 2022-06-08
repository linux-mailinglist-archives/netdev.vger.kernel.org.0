Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F55C542D05
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 12:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235583AbiFHKRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 06:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236502AbiFHKRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 06:17:32 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18514290B21
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 03:04:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PcT8yp43KzfMbe8wZ6w92qB6r+QGiwejzaw+mKlqn0MJw6HQKauEfWTJAU6CpxPQWx17XXsj2Cr5L9UxKqtGjDVZSQ8hl7NigIVfaJOdzxsA0ycIT8LQQOTGZ1XFwXNcY6wSafrek6aDlA5JOo7jQcxP1vu6fiBAifwICMkTFMyTR7N4s3Mnv9ZtYqfacicz9fq0oXPWrX2Mtu3b3cmKN1r0pjXj1/IjCvKcq4p9c6/OsirEr3FdDGgLJ1Kw2BWj1DmBFioiB6cQN/afwbZTC/9XAN2uRiU58jdPFQndAYnzLdVr2mbsPGv2CHwP03FVYBDeXuB//sI46PUduRUmMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DOIGEho9BLKqH2BNprpV2pDDMjRAwITthYbKencjNqQ=;
 b=dDlHmNVGWo3HwD/lXHWp0Ya4qug0zX17CN8ylSS7pDdh5etOWYSH+7GSZtmm+EqTi9NbfzoWWlnu12GTLqaYAUl9uWY0A6SiU27zN606SO6Hsmy1KBEnm0xUEzg4NWbbPZcrQdn1ZkKQ25f8ruU+/cAlEdEp+nqBJD2Lp/7xBT/b3Nm6Ug70ZU4opYgJC7cCpQicaAHtML4Wbl4gWf6YLgYth8K9HZ0p2hUatDpezX70gpD4xeANyZidC2a8exCiSx0SCBP+oCZpUAkWAr1L5HcpS5+m6xBn18wDrrvXAcQhmuMN3PyrRjZwZ5i2PYPlVFMiwtIsmwwgdydQtH1Rxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOIGEho9BLKqH2BNprpV2pDDMjRAwITthYbKencjNqQ=;
 b=rZlW5jSi8UjR4rTD7xz6dxnWT70I2P/UFNFcalI2sRdgdOiFOIDtsheIYY/ZMCOCQsI3/XDlk2xHp9Rkh8HRj6BO63UseZx0kk6qIYLPZACtbj5OLKoawyu+wA/Dc+wKy9fhGTdAaDJ3eOP+D4xpfGP6jyk/VzgzVL1yC7PCdyyoqn8eIpY4Sz+TpYbobKH4/4Y4sVB9COMH/oMjDtmlYqSIBiNNUXwFdwLTGxzbjgaWoaYttSege8OV64XpQ2W/SZbxkIvVsAepLHOLTRAWRPXXBH+7wZ8aD+zEmQCz31tby7lUGD3DLSrkBktIf2KrmjrcKiTS98Wu7Zbs6D7VrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by DM4PR12MB6277.namprd12.prod.outlook.com (2603:10b6:8:a5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Wed, 8 Jun
 2022 10:04:55 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::b133:1c18:871e:23eb]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::b133:1c18:871e:23eb%5]) with mapi id 15.20.5314.019; Wed, 8 Jun 2022
 10:04:55 +0000
Message-ID: <4ce14f74-33f7-92df-b13e-75c360c04a98@nvidia.com>
Date:   Wed, 8 Jun 2022 13:04:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH iproute2-next v2] ss: Shorter display format for TLS
 zerocopy sendfile
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org,
        stephen@networkplumber.org, tariqt@nvidia.com
References: <20220601122343.2451706-1-maximmi@nvidia.com>
 <20220601234249.244701-1-kuba@kernel.org>
 <bf8c357e-6a1d-4c42-e6f8-f259879b67c6@nvidia.com>
 <20220602094428.4464c58a@kernel.org>
 <779eeee9-efae-56c2-5dd6-dea1a027f65d@nvidia.com>
 <20220603085140.26f29d80@kernel.org>
 <2a1d3514-5c6a-62b6-05b7-b344e0ba3e47@nvidia.com>
 <20220606105936.4162fe65@kernel.org>
 <21b34b86-d43b-e86a-57ec-0689a9931824@nvidia.com>
 <20220607103028.15f70be6@kernel.org>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <20220607103028.15f70be6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0271.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::19) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e4bc9dc-3a0a-424a-e47e-08da4936561c
X-MS-TrafficTypeDiagnostic: DM4PR12MB6277:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB627722D2887DD5001DBD774FDCA49@DM4PR12MB6277.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kYf/HasX6em8VfE89LBAhTfE3/JGKZ+o94lSsFjrAsfJgmVZ6c7K2uHBcgkWnPQx21en1R5c7jjVbfoMfR8JWqILMYRQQF/f/iPZ78oBVX+IZzSUlrSFvGDadthNgAXg5d55iUAFc9S5+3R0FcroVyOrPAV2FS/wtrtkQOGgj+5dtgdzVidCWFxN2TR9scdOxX2ShG43ivS6gfT1xALYHeGyMHPK9Uefc9AhinQOy+OmqGpkrKoI+Y6S+8c34NLJ1K4PweYKZHTxgsYOArl0dhzWcGptcGuhVOB6EmTBClNytGAehwRp9Zr/3XWZYprX1EWgvR2/sF38pXzqtUCk67zXm/arn8tqoYL4/Q6NaJqNXTrdcVxCjqvTjPjk4FC1hKYtSkVUMy5AJ7MQJhfcKjKXi9uNQTl6ugMpcr9CSZjaJrlLhmxAqmDMZ2+ZlGKZa5FTfVdMahRtB1zpe6Ce9kzUJBof8hSaaHCNMi34ykHE1gGNzZ9ic3avHZu1HNxFldyCkYhv8r4T9EccH4dQgChK1Nhab4uDavPbawpfvleQcG8YwtSFeUhGvxQANfDw5bQtjupNyeng4nDVkWlQKq1C4i2i0egXyC9TChMRvX8QYxJOZuNOWOZ5hHn7KHx3osj/QHnK/n9f2E3lZfsq3VV7p2sAyS6goTeGySb43acj/i1J74QX6tcY4iJC3rasnvj8Ezzc6hx9K6LAjN4KfzmNAnnaC/dYNIMFHVPjLkw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(31686004)(4326008)(508600001)(8676002)(36756003)(6486002)(38100700002)(8936002)(6666004)(66556008)(6506007)(66476007)(26005)(6512007)(53546011)(66946007)(2906002)(316002)(107886003)(186003)(5660300002)(86362001)(2616005)(31696002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUNSL3hiL0pyTjQ3bUo1VXlUbS90cTJ1V1dmUjBoUnEvUnZsd2I1cjg5bWdM?=
 =?utf-8?B?MGo5eHJMVjVLNjFUeEcwcU1NN2NsUE1aclArNDlHSVVGalI0RmhBYVRMWkdz?=
 =?utf-8?B?VzlxQzEwWmRzTjRmRy9GSEVCSTNqV00rZEJ4akNaKy9FajZYVGJsbmYxZzFw?=
 =?utf-8?B?Tjd6alBsOHNJU1lZWjJ2T2Z5YnNhbkxhWHZocmhhZ0k4dWZOOU5TSUpDNDhL?=
 =?utf-8?B?cjExdHBXSktFaGRMMjYzUWhVOGRNeHZZZEZxVTFWQkFBZkNoWkwwelVIWGkv?=
 =?utf-8?B?UnlzSW9wOFlqcUlHb3RhdUZLc3BLTTRUOEJ1RDNzRXR6TXVvK0ZkWlFZWU1X?=
 =?utf-8?B?TDYycEEvNFJOWXcycnhvNFB0c1ArMmdDSjZPUmZvT1doQUhnN3pLWnZnOURl?=
 =?utf-8?B?aEdteTZzTTdEL0RFWU5JWU9NTmdycFQrTnF1QUtMcVFWOW92KytKeXZrTW9T?=
 =?utf-8?B?dGtpTTlhemowS0dOV21LRDB3MVZRV1gxY3hZdEJJZXZzRnQ0NCtGTklBelZv?=
 =?utf-8?B?eUFlNDA1dzRmREl6WHFtMEVndmZZdEJ4OFg3emVoK2MvT2t5TWVSRlhDNnZ5?=
 =?utf-8?B?M1BsZ1N0WlROTzl5YzlPQmtadFNra2dGWlhxMTg3ZDNsUi9ZZTQrUXFDcjRJ?=
 =?utf-8?B?bWlpbTJHc0VldHRuSlhsR29CWE1xcEJxYTYzcUwrSVV3SzRxdEJHNGFPYUNm?=
 =?utf-8?B?U0NKcTVUVHYvdlBvSDRnUjI4NlVEMy9UeUFzM052SEhLZGFMQW9xVGhPa0xR?=
 =?utf-8?B?QU1kVndSVDVraXc4S3J3eDl0YVh6cXQ0aXp1dm8vbElVQnVvYzZJNzNKM29Q?=
 =?utf-8?B?ZXdJOHJvMS9TTjMxRkNuTWY0eVFtZDZlckJQRkJqeVNKL0RtZ2dwSWoxbFZj?=
 =?utf-8?B?UFFzdEJzQ3kyQStnb0lYRTAzbzdwcmVZSTRrNEpSaTc1MkpYRVhQZVN5aThI?=
 =?utf-8?B?WFNQYzltM2l6WFltVDhZZ1V4NmFkWml3SjdNZExxUTZWZlM5MnpzeGtFUHYw?=
 =?utf-8?B?akpCZktyUW5DSnFtWWYyOXl4Y0gveVVqUUZPaS8xemg2N1JpLzVCSEJZT2JO?=
 =?utf-8?B?M0QwYTVER25YMGtWOHpvMUNhWitWQnZTL0RLdXp1elVLVXVNQ2xEZWVQTEEr?=
 =?utf-8?B?U3QwdXhIY2h6bUJJWFJXd0Fqd1BLQzhNWHdwQ3FXWVNKTnhaQ2FwbGF2eHk3?=
 =?utf-8?B?d2RIMXRvckJlWnR6ZzJjUTZTbmNjanlvNEVYb1EvOFhVV0VvYlcyTlAxYWtG?=
 =?utf-8?B?NGZDZDl1bWhTMUF2SXNOaVB0YzYxNUxTOTRVQ09zZTQrZ3V0aE9GNEVlTksz?=
 =?utf-8?B?TzBvZUN6b0ZLTzNGZk9LYkRmZ3FYQmtIbkZGcFQ4bHBCOFdvZUtxNmhObVFJ?=
 =?utf-8?B?ZWZNalVGSkRLbnFPTjhybjMzSGtNbGJiYWp3d3MzSStVbkRBZlZtcG9lSEZ3?=
 =?utf-8?B?cFdZd2xkMTNXTTI3OFVkNUxGRWFqZHg4SEtiaWZYdW43R3F0UXJhaDdyVmoz?=
 =?utf-8?B?bXZGc1d1T3NlMlZpdVdVMUlWV0tpUzNxdUloVDBwQUd3VkNCNXBQR3RWSFFk?=
 =?utf-8?B?VHJKK2VHV1Z3M2psMDZ4N3hzVHV0ODJzUk93b1ZDbmFtOXM2blVLQzR0eDdi?=
 =?utf-8?B?QXAwOGhSRXRIdkFqcnJUWS9VTzdQcUpOU0dBK1UrcERFOU9oMXVxaEhFTUty?=
 =?utf-8?B?VldNV3Jyb01aU3pkNVZNcHl6UzJhbjh0UmFlNkpMZVFRa0g5QldsTWdReCtw?=
 =?utf-8?B?cWNNaVBvQTBqRXpNb1gwaHVkQldqOVZjRTRjczFkbEkyYi9VVi9Sa1MvQTQr?=
 =?utf-8?B?SysyYkhTeXlwUmxUNFM0RlAzeStXanpBcDk5L240UUcvOVRwbm5PVkVxdFJO?=
 =?utf-8?B?K0ZnU0k4K0dPNk1PNXVMaW9uczUzRUgzbkYyaEFpalo4Y2xoMG9lWWw4WnhI?=
 =?utf-8?B?UWNvbFk3MFBFZnQ1cS9CVE9LVVdmMSttbDVESkduVEdBRk96Skg5dDNGNWJW?=
 =?utf-8?B?VFErZHJ5ODRMaDlmRS9rVnlMcUxGZkRwTVpJUXUyMDViTVp6bFhqdDZYV0ZI?=
 =?utf-8?B?NzdqbTY5WEVtTk8wQk5pMklUZXJob01oSzFYV2ZWeERVV2VRMGUwNVp6SDZY?=
 =?utf-8?B?UFRIa3ZuR3BDbStrOG1PdmhzYTRQM3RRZGJPdFdJVFVWQVByVzhNUGxxaVhC?=
 =?utf-8?B?VERuZjRFT3FkMmxFOXdxTzdoU3F3OWx2OW5QaW9abHpjZHpGWlFSQVV6Yk42?=
 =?utf-8?B?eUVrVGNUWi93VUovdTdKZ0dhRnQ2R2RvTjZ4bTlPc1lZbzdHckdTdzZUek1R?=
 =?utf-8?B?UjFUc3BmTjZLcFVIbmZVQjNScXFlZ3BXZGZqWGpHSUYrTy9sTDJ5UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e4bc9dc-3a0a-424a-e47e-08da4936561c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 10:04:55.1110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V+zPe3LNVlrVUIDDrlTqfSrohZ2mLrmLPDc3mm/3pYcT9Xp5FCd4NpIKCrOLFWohNyzclV72dGJv+MD6DNoXiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6277
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-06-07 20:30, Jakub Kicinski wrote:
> On Tue, 7 Jun 2022 13:35:19 +0300 Maxim Mikityanskiy wrote:
>>> That'd be an acceptable compromise. Hopefully sufficiently forewarned
>>> users will mentally remove the zc_ part and still have a meaningful
>>> amount of info about what the flag does.
>>>
>>> Any reason why we wouldn't reuse the same knob for zc sendmsg()? If we
>>> plan to reuse it we can s/sendfile/send/ to shorten the name, perhaps.
>>
>> We can even make it as short as zc_ro_tx in that case.
> 
> SG
> 
>> Regarding sendmsg, I can't anticipate what knob will be used. There is
>> MSG_ZEROCOPY which is also a candidate.
> 
> Right, that's what I'm wondering. MSG_ZEROCOPY already has some
> restrictions on user not touching the data but technically a pure
> TCP connection will not be broken if the data is modified.

Sounds similar to sendfile. With bare TCP, the user shouldn't modify the 
sendfile data, but the connection isn't broken in any case. With TLS, 
the connection may be broken, so we require an explicit opt-in. So, I 
think, a similar rule for MSG_ZEROCOPY will make sense: MSG_ZEROCOPY 
works out of the box with bare TCP, because the connection can't be 
severed by modifying data, but it will require an opt-in for TLS.

> I'd lean
> towards requiring the user setting zc_ro_tx, but admittedly I don't
> have a very strong reason.
> 
>> Note that the constant in the header file has "SENDFILE" in its name, so
>> if you want to reuse it for the future sendmsg zerocopy, we should think
>> about renaming it in advance, before anyone starts using it.
>> Alternatively, an alias for this constant can be added in the future.
> 
> Would be good to rename it to whatever we settle for on the iproute2
> side. Are we going with zc_ro_tx, then?

Yes, I'll submit the patches.
