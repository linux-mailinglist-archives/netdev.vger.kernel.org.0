Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560646E470C
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjDQMB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjDQMBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:01:22 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2092.outbound.protection.outlook.com [40.107.220.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4299165AF;
        Mon, 17 Apr 2023 05:00:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ai+3WL86HI3dKHB04VmmhgzcRC7JtpsbVmo3BJtVQgcDAfJjEEYUHr8R81Ig8vMBbGyBW/LxLv6wCgA0Q55i2ex3wJTTF7WyQnj5yqbhiDVFhtAnmvDk8Y7eikNTzcyYnclfMW6MsjFlo2sucLAvGZzrjObwbWQSjvmYVGSxNj3sWvKDM0UL/E2a2VDXhkbK7C+2Cp3RjVW89ky8G8ovoh4NlVDRBjbNpNeC68vZ2KkHj6x4/q6JWLfte2qtt1Cao4ySbjIX7dh8VeTG7XQfFB0sdF9ZBFCNQ147G5TbcdxQfezACjQ7wEmpXpMimsdY5IYaP6W9CkzjackqrjW6Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1sCt0j7nh5WAnvCqxD31/2x7EkyjxxxCU/JHi8l8Bvg=;
 b=HKocIO9I4GnK+63SFc4Gbzcnp4eh1wN+H8X5xkP4EjsEEIsc00OQ7WFBPBU8luT6RNfoQNoByfAOlXU7O3xhauaXEe/tMCLxfB4bRzLNX7i1NlwzPL3BTsM1ArkOqV4Am8NmDkCLq5L5B6PvnXwEA9VS4JwliYO01i8rthkNQQlikYsXLmjDeJ3XQygZ99K1rX8Yfa4ibgbRw9ATTeF1/eLUSN4S/rlnSy5rQPmFAgSkIS7y2UsCP1ciW5YqKaQJuARonVRgiYPTaGh7sV0v57ajtZ+hBvhB/RfMPnk2Htcq1biLrbRHifVMRyDo4r81/61xvbVdV8AvwBvv4boBRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sCt0j7nh5WAnvCqxD31/2x7EkyjxxxCU/JHi8l8Bvg=;
 b=HYImFkB4VWAgLDxYQZ+4ZtEgsUgikdBh1Fc9nizN1s8zHp5A1CtdQTqHocNTyJIAidOGJbnPVtIvctjMo+VD62HKUm8VcPv2ODGC2Gc/DC1H3wYREIKixpK8ZmMVnCKcDtynFdSZBGOyYlLC/LFL+kf2iMpelrvgCwDp/N/xDnsz0emI+/rep/W2aEw1mryCEYY8e7Wwe9q/7kbqvZXBwORRSPAx/QIixQ/UyGpxKvARuzEPrN7oGwLE6Hp4C9tEaUDwIiANqjsTu5vjWuapgCbUGKWERt2wXGRV3K1TaH45PaaHj0BzC6aSQzhVdsJjRkAAufeHyPVAR8KX68Hjwg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cornelisnetworks.com;
Received: from DM6PR01MB4107.prod.exchangelabs.com (2603:10b6:5:22::24) by
 CH0PR01MB7154.prod.exchangelabs.com (2603:10b6:610:eb::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.19; Mon, 17 Apr 2023 11:59:40 +0000
Received: from DM6PR01MB4107.prod.exchangelabs.com
 ([fe80::f33a:edf4:c24:d88e]) by DM6PR01MB4107.prod.exchangelabs.com
 ([fe80::f33a:edf4:c24:d88e%7]) with mapi id 15.20.6319.019; Mon, 17 Apr 2023
 11:59:40 +0000
Message-ID: <181d6b4e-4a7a-c458-0292-c35317a0fafe@cornelisnetworks.com>
Date:   Mon, 17 Apr 2023 07:59:34 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v3 6/7] mm/gup: remove vmas parameter from
 pin_user_pages()
To:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        linux-media@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org,
        bpf@vger.kernel.org
References: <cover.1681558407.git.lstoakes@gmail.com>
 <fa5487e54dfae725c84dfd7297b06567340165bd.1681558407.git.lstoakes@gmail.com>
Content-Language: en-US
From:   Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
In-Reply-To: <fa5487e54dfae725c84dfd7297b06567340165bd.1681558407.git.lstoakes@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR17CA0017.namprd17.prod.outlook.com
 (2603:10b6:208:15e::30) To DM6PR01MB4107.prod.exchangelabs.com
 (2603:10b6:5:22::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR01MB4107:EE_|CH0PR01MB7154:EE_
X-MS-Office365-Filtering-Correlation-Id: cd3b6097-8821-4c13-a357-08db3f3b3910
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1DhMeSSpVv1b8F4hkxlMYIh7EydeM4Eig9BgKt4GccTtVkQTgISy6T7j3T1VyO/eTf3Uof+flnx9mpH1oim63IEEOey6tNlM7f1vkM1+GSyutPP+KEfkZocK4qMXrV6gM5jATPiI2QOirjQ/5cYNeuzD5juo2GGykYB3k0p6RJ1Lh4bttD759S9Y9LZ8mW9GhOgGw/I3L4Dow0rX97X3yM4EyeIWffO2/nmOaB8zAp90Kujp5q8zaF2eK3cfkNU4XSfTlmY+6Xqx4HNbVVY59WbPDyAe3xbS2YrGfWN5QIsjvs0p7Jn65LqWYIkhfqREPr4c5pBctxRHZ+zStDjx562ehDJ/yZ5TGxN4JKnveTFKZHBfwfuhnmIMZrapqA5biKPSzDxXtEc+lytCy0+3Hk7qq9alA05vOUBUQi0/jIpGsoXBpGFFj+wO0MjuPfM31wJnHKlt/qQ6fqq6zthA9FmYCiR1Z+32ngxVeF5n4gRRx+JVOWmkQBP8eQJb4Aoy2HCORqPuQ7CtO2v+K5IC6DRGMlE5U6/GfbTlBAnMV8xeW6Srnhxik53X5cgLoDjapeufETT3NiDMe7669RKG4nPre3tUDHkgrYNS2WDP8+jwXc80FgwrxrlPOe2d3r+EJvjBVENcX+DQ9xZaie1u3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR01MB4107.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(39830400003)(366004)(136003)(451199021)(110136005)(54906003)(4326008)(316002)(66946007)(66556008)(66476007)(52116002)(8936002)(6486002)(478600001)(6666004)(5660300002)(41300700001)(8676002)(2906002)(7416002)(7406005)(44832011)(86362001)(31696002)(36756003)(38350700002)(38100700002)(2616005)(26005)(186003)(53546011)(6512007)(6506007)(83380400001)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rml3ZzZZbHViVmRURE9Nc0xITndiUTVSMVE3OGZIajBHbzYrajlvWE5pMUl5?=
 =?utf-8?B?cVdzUzJuTUJCT2haM3g3WTFZdm5FTTNBU3JuMFQwblU1aUNIZ2dCZU5VRXR5?=
 =?utf-8?B?THlPMC9JbXVWWGFWdFczbkRsVXd1V25rWHA2VXNJUW1sNjRLMXRrSCtNYUdS?=
 =?utf-8?B?YmlJN1piNG11UVdWRi8wRkt4ZndJNFZ3MG0vSUlIOWhQMHo2bXJSR092bC9K?=
 =?utf-8?B?TVJRTWF1S09KL2NPU0pRSlRUUWQzcDBVcXIrMEU2cmJWTkZQVnFzSlYzNGxi?=
 =?utf-8?B?TzVLWTlZbHNmUjhTZkpPUFphYUFZYlFqNDFFWmVBY1MzRFh6TkVXZzVBZWxD?=
 =?utf-8?B?dFJTNjY2bGNzWnpTbUhOVUw2cFM4VUcrMklNL2c4VTR3Q29nMDZKWWdmb2o5?=
 =?utf-8?B?S2hnaGd3c2JaeFZ4RG5YREpDUGJMWk41a2t1WC9INHZzb2hFRm12OCs4WnBK?=
 =?utf-8?B?QTMxclp3OFQ2YUdyZkdxYWEvbjFGMW5sZUtKMXdSVW53c3h4em5mdGRvUzdo?=
 =?utf-8?B?RmlSVXJ6cW9Wbjl3VUJjWFUrclFwR2haYXhHdE5DaUh4S1ovWXM5ZkRzdDVp?=
 =?utf-8?B?cjU0MzIvNW0vSXN1TVVMUFh0SkswdWJnV3p2c2Mwa2tzMS9qRC9hUmp1bzI1?=
 =?utf-8?B?ZllPeU9lM1JJbGpUYzJlM2ZMSURHRWp4a1NmMXFYSHNvdkVLblYwMmlnWm9P?=
 =?utf-8?B?Y1M2dUJtR0JkOERHNTlNaFJVbUdIWElpQW1XM0pVd2ZjUkorUDBxODM1UWxI?=
 =?utf-8?B?ZDgyTTBkb1BsVzdxcmVkbXFFNVJlc2dRUHZleEdDRFFubUhSbFQySzlYNGNQ?=
 =?utf-8?B?TGtmaHhyZXBMV1hhc1NDY2FrWE5GcnNvZTlJSVd3QVcwNTVXVFRleFVncUxW?=
 =?utf-8?B?Y1BpZlViVkkwTE80a2ViclplUGlSd01BYkRMV0lITElIL1RMcjV6dGRTUWtH?=
 =?utf-8?B?NXdJam9ialp0ZGE1Y25BOG0xM3IweExKSEJ0T0d3UkczaG5OVGcyaGNFMWYy?=
 =?utf-8?B?REtIbjRBOFlDZXpyODFqVEJGR3JxUkZVQ2psbWhOa29mRzhacUloWjFkRDRy?=
 =?utf-8?B?OXkrdXYxT2xROU9yaHRxNmluL3RvMytEWFBhVjZ4alNJQTYrVWFIckltUmJF?=
 =?utf-8?B?TUFUOFBId1dUZXhXTTI5aHRsZnRranZ5MnFTZ3NWUnBrVnlQQmNGY2l6YnJj?=
 =?utf-8?B?VzB3MkZ5ZHBhY2Rtd2xQNzF0Q1htTHhtRXpRckh0SUZMbGFLdU1LNm0rb2xJ?=
 =?utf-8?B?Um5HcExHSlp4bDJyQ0M0azcwWEw0UkZkWUppZThCZTAvdmN3WUtxQ2dNaXN5?=
 =?utf-8?B?SWVKY2pXTyt6NEdCVVBRaG5YVTBNWWhyejRyd0krc2pqMG9acWFOU3JBbHVO?=
 =?utf-8?B?Ri9yOXFjUElPNmlCdGp3dXIwcUdxVi95UmNnMURZeDA4dDZxU1V4bmRqNHJx?=
 =?utf-8?B?akpGTDA2NmR5S2tHSUVUcnBKQi9MS1g4eVRGQ1pTVW53WjJ2WUJPZGlkR3d0?=
 =?utf-8?B?RGZrRWJ6QkZVOEpXdTFnVjh0d3YrdGc4VE85bUFyR1VsbE84cDUyRDlrWWlX?=
 =?utf-8?B?cjY3SkY5K0ltaEZpTng2czg5LzdGMkZ2UXZBcXBFODhBOGdTak5Nby9IMVhN?=
 =?utf-8?B?cWl0N3lkYTRzbFhMNTFpNGxsMW5KeTZDN3lTQSthQ1FVK2VoZkJndUZZZGp4?=
 =?utf-8?B?U3lXTVkzcjd2dHlmaEE0a1lCcGQrSHNiMURuWlRPWjlVTXhIb25hdGc1M0s3?=
 =?utf-8?B?eVF2bmk2NE55R1dic3lrMUpXeHZxUjdDcmhTUG5lUjU4ekQzSlJZbXpQWE1p?=
 =?utf-8?B?T0RkRzA4c1JPcXR4cmFWdUMvZEZKMU9Pa3NlaGVjTDBuajRzWUdDWXJ3YWRs?=
 =?utf-8?B?aEhWMjlyTXZ1eHgvSkZySFlHWll4d0ZRS0dSUGVaV3FjTUpmczB0NHRvVDJE?=
 =?utf-8?B?bDJQOE9HeXZKdTM4SkJhdjBJbENMam10azdSK2lkelYxNUR2U3pabDNpMFFE?=
 =?utf-8?B?VFVjY0JvUzFSRDF3bWFPVGM1eHU5RlM0ZWRGMjBMbk9CeDJpTDAzSzdhLzRP?=
 =?utf-8?B?N1RGTWw5bjl0aXRWUVA2Tlg5by9sbmQzTFpnUlYybExNOWxrRDhNeDc0Mklp?=
 =?utf-8?B?bWNCMG53djhVTFp0RzliWS9sWVRDbHl2NVY4SlZWcElTdmx3a09Cb2pQS1F2?=
 =?utf-8?Q?cpPvJW6u15b4gMRyamZQtFs=3D?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd3b6097-8821-4c13-a357-08db3f3b3910
X-MS-Exchange-CrossTenant-AuthSource: DM6PR01MB4107.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 11:59:39.8624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nMqnAoQTMA1pXaQyRDyRDkkNb1GPOwuspHLueg82Ikt0POx8RR4YI9q+9EAz7M36Pin5Tyy6o1Yxj223NE7da2kOglT+ArI8P7q8D6f2l0kvdg+VtlDNvydSvF0J/+r2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR01MB7154
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/15/23 8:09 AM, Lorenzo Stoakes wrote:
> After the introduction of FOLL_SAME_FILE we no longer require vmas for any
> invocation of pin_user_pages(), so eliminate this parameter from the
> function and all callers.
> 
> This clears the way to removing the vmas parameter from GUP altogether.
> 
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> ---
>  arch/powerpc/mm/book3s64/iommu_api.c       | 2 +-
>  drivers/infiniband/hw/qib/qib_user_pages.c | 2 +-
>  drivers/infiniband/hw/usnic/usnic_uiom.c   | 2 +-
>  drivers/infiniband/sw/siw/siw_mem.c        | 2 +-
>  drivers/media/v4l2-core/videobuf-dma-sg.c  | 2 +-
>  drivers/vdpa/vdpa_user/vduse_dev.c         | 2 +-
>  drivers/vhost/vdpa.c                       | 2 +-
>  include/linux/mm.h                         | 3 +--
>  io_uring/rsrc.c                            | 2 +-
>  mm/gup.c                                   | 9 +++------
>  mm/gup_test.c                              | 9 ++++-----
>  net/xdp/xdp_umem.c                         | 2 +-
>  12 files changed, 17 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/qib/qib_user_pages.c b/drivers/infiniband/hw/qib/qib_user_pages.c
> index f693bc753b6b..1bb7507325bc 100644
> --- a/drivers/infiniband/hw/qib/qib_user_pages.c
> +++ b/drivers/infiniband/hw/qib/qib_user_pages.c
> @@ -111,7 +111,7 @@ int qib_get_user_pages(unsigned long start_page, size_t num_pages,
>  		ret = pin_user_pages(start_page + got * PAGE_SIZE,
>  				     num_pages - got,
>  				     FOLL_LONGTERM | FOLL_WRITE,
> -				     p + got, NULL);
> +				     p + got);
>  		if (ret < 0) {
>  			mmap_read_unlock(current->mm);
>  			goto bail_release;

For Qib...

Acked-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>

