Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DFE599BDC
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 14:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348557AbiHSMVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 08:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348040AbiHSMVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 08:21:18 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7EB100F28;
        Fri, 19 Aug 2022 05:21:17 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27JCDkXR032416;
        Fri, 19 Aug 2022 12:18:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=message-id : date
 : subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=CCE5L5LsoSPRqKeBt/ohi2OIWEI9ClK6lNUrbZ9Wk9M=;
 b=KWj0Yc2RjUSgsPnwVAtUQQ/LruqmI4KDnE86mON22vH0XKeE0/F0p3rgCxuh2u8giQnP
 XMsWqVwNVAsMb6kFiIbkLrFUw1fZ9plu5r9zst6Qac+mnqAv9kWwrYtci92nIFM/Ej4j
 kZmQL3h4VM9vuIBoWAxViniRwNUOiBQtgqOZSjKTO2tgBN2FwrYHlAkPXM6SZjKQPZng
 Qf9ANpgmeMM4T/Na2yL4qDNFl4d0blTGh0OCSmZDPerearqhC3zD0tywy0W2hCqVpbkG
 yHsDMoKaQ33KIa6OVRdR4nud5jtHYs3mSVrmUZnQURiyrxzCFVdM9vajmwYKyWXR9u/+ yw== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hx2x8nak5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 12:18:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OcAnU0JsTEZz+6fI7gn/QDZzqBdTpKhlsYrZ/r132n23iLoDX8nG+h+o0qBwJdDrAyKHpzfektJaYYkYtGlLncLiNFAhw6SPDElEvvWDGTrAiBp7EiM0RcJgXJ4xay4Rzp/fSgIetTWJcebiV1gNkQDMPofGwfrLNxOHffIydqDdzraL1ceF3rnx4Z5c5z+M6Y3OZVqp86Pbh60vfqmzDh5oT81EJ3KRMG8D0UVd1OiHfIHwGY/zXKq4gpnMeDNRiMoLiIvn2mcgXS8hPDId6UPteQtixnQNsTanT44wfokYHX4SwCnC/SMfO0hqfFYPoZP0yA7pjKFMyNChVanFFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CCE5L5LsoSPRqKeBt/ohi2OIWEI9ClK6lNUrbZ9Wk9M=;
 b=XCjrSYFAUXHRoubeXLTJVNbJrgl4cNsI778L8nykenE3O8T0sJITCGBBKMunpk4OSuTFLWmyhuf30TEjAaimUtuV8v8ktgBKmyTw+O47Sn2JWU/a2i55guJUpG/M8sMU/hFJaSVjfD6gBdu4564ZLNq5Dp4RGzN5soUfwr6MIo/VBeIgCYilOAt1zyu/KCnJ85EyZ0Nb4J8ydBU0INLFHAhMmanQm/7hjSXAUUdhDXaP1A46Dv5xB8jvk4MRt1U0/qX56fDugS7b8uO9Rvxjtwzrkly5vuudTSVnjhwVAJZoDbdYff/P7nKpgKpJrOJtpR5WHA8v61HTAy+Dcisc2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by PH8PR11MB6611.namprd11.prod.outlook.com (2603:10b6:510:1ce::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Fri, 19 Aug
 2022 12:18:38 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::18c8:8786:808e:6e9a]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::18c8:8786:808e:6e9a%8]) with mapi id 15.20.5525.023; Fri, 19 Aug 2022
 12:18:38 +0000
Message-ID: <57b4c8e6-4a32-cc03-f469-c4bd6dd1eaca@windriver.com>
Date:   Fri, 19 Aug 2022 15:18:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.10 0/1] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Sujith <Sujith.Manoharan@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "John W . Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220819103852.902332-1-dragos.panait@windriver.com>
 <Yv9ymGE9ZNPfUjBm@kroah.com>
From:   Dragos-Marian Panait <dragos.panait@windriver.com>
In-Reply-To: <Yv9ymGE9ZNPfUjBm@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR0102CA0043.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::20) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4af1940e-b81d-4bc8-bcc9-08da81dcf1fb
X-MS-TrafficTypeDiagnostic: PH8PR11MB6611:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0sXxo6+yXF2smNK0lW7xKvB3/v8gWLqKIISnzp5nteENN2CYUnb2zO4JqTpRbk21p9hq3u5JxNBY+A4rItzdoIAGs8iBtRXHCLKEDdfqXANtWrMZZBfkThkDNOMDkhLb1XQgioq9cbWUf43otWEOV++iR3zDVG/HPK2tW/K1nzNtNWe8GekRdOcoWy2AU+vTL8wie8sPavym2Z8OTuISoYxBODNirrovGAHTw5+BB5xTxu5bjublhbz9vT3KGI84qHPcN1ihkzq5CsK8x/nzQ7c7YvCCDQG/DL3zbIb2/J2eJl+WLzz+oj/QEVqfybrKOu/rzvMr2yHK9aOedmvttU7DTrkdeLcxQQKVP7d65I7eEEj/ECkbe8W+kmDuruF8R48LgpAT0UqHsP6s2d1KFB11J5vMWl3o9lWvECH58Gm/1AfCPnZ4v9Qs4yLG6KHia7EFI2WGXCUCuDB21lzf2Y+nfkwYJz0NRz/epJcGn1J7MMMH2A54J5L0fwijNR7kiHTDCMif0IcOqsqmhj4YGysX01EbeqULc2e/XQiUn+gSGRhbN5//EGvzHK/eAwV0I0XmKw6PjfZ/4T9ktiMrQ+dLfU8FzIr4uEsEHgocEOc6MruChGLlXwvep+9zh6SsLZoffMrvrBN4hosSZltVrqc/rm0qNSo1NYg8uiOrpiR6hUfhcf76E0becZGk6b5REpHFIo37BZppAdtVu25Gm6W+BHVKpBR+c+DJU2w9ya4oKvdOKoVNa9v6NthSdGqI4WD41ZqAG7111XGe7LHPMw7bM/MP14fZE3bA6oOXj3dg5vdcuxJdfrvqOFXdEELatVxrEHaZgOn1fvCBuuAMtPwT7uUlwZq721x43fsq0lU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39850400004)(396003)(346002)(366004)(136003)(316002)(26005)(4744005)(7416002)(41300700001)(66946007)(52116002)(38100700002)(6506007)(53546011)(66556008)(6512007)(8676002)(4326008)(2906002)(66476007)(2616005)(6666004)(31686004)(36756003)(6916009)(5660300002)(31696002)(478600001)(83380400001)(6486002)(54906003)(8936002)(38350700002)(86362001)(186003)(966005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUc5L25yQlZwRndsb0xKU0Nsb0hWNUJXWlZ6VWFLRGRFYkxKWWNET1lqeDBL?=
 =?utf-8?B?ditLeUZ2REVBeVZ6WFpCN0djcXBoOFlOL2d2QUNSQ3BUWDJud3ovY3R3RUxY?=
 =?utf-8?B?K0E2cnEwQmF3Qkhid3ZlK3lValREMkRJdGc0TW1PWDJqcDhkaEtBZmZSRFlZ?=
 =?utf-8?B?MnlWaERsTDREOHA4MXZGODJ4Zm81SEYwMWpZek1qS2Z4ZFVUVEUyRGVBeDhx?=
 =?utf-8?B?cXI5VlRMK3BrTEx0NHIrNFFiLzc3U1oyL0FOQXB5a0cwVlZFV2JJUUxoYm44?=
 =?utf-8?B?MlJHQlJTeGZGTDlPdUJsVjJPdk1JR0VaNHJvRmlDTjhMNzVTM3hpaXJHNWRD?=
 =?utf-8?B?S0NTRDhXN0lWZ0xkSlBuY1Y4Q3FRUXF3NnJKT0plRnhGNStVempLd1NSRUtL?=
 =?utf-8?B?T0dKKzZRdnhzbEJJWjhYQ21xZ0JFS1BwZExPRmVydnBNVHpYSjQ1aE9Eb2Vq?=
 =?utf-8?B?NG9iSkx3ZnNGUkFEbEFxVStqNUYyWTN5eE44aGtYMmJmN2gydjlTZnZneWVn?=
 =?utf-8?B?c0RlbDlRNkQyODJoWHpScnY2RTRSMUZNRWh2WDlwQVJRWGlzMzFyTTNJQ1hK?=
 =?utf-8?B?WnI0aTBwYTgyU0o3QUlwSWZDd05ZcTl3bkZtYTJRZTJnVDZOT09LcVJYNFVV?=
 =?utf-8?B?aDl1d0FndEdIaFNrSXUxbUx2dWtMY3lBL3Z4Q2RoWkxsckVVR040bjRmUDZT?=
 =?utf-8?B?UkpGaVQ0d0x2blZYQmhkMDFZaEFGRnYyY1kwWEpXRlMzMWtBU1k3VExoR1pv?=
 =?utf-8?B?ZjBUTUo2NTlpOEs5amZOZ2x4MXIyY3lyemlTWkFPWGRhOFFjVVhXbkdpcm82?=
 =?utf-8?B?dkhVUE84SE5hWGp5YlpRYlZpQno3NThLeXNiRnFsYzZQbEU1NTVNbUQ4WXhK?=
 =?utf-8?B?bUcxL0F6dksrN2RKeit5N2Q3akVTMWRuWmJxTVRzUHNRdkwwQ3pnNTdwK3FT?=
 =?utf-8?B?TlFmL3ZtL3RkUlc3Wi8vYVlTU3pLUVBlRzdFOCs4SmtmZjRoS2tFSkhtQ3Z6?=
 =?utf-8?B?OFpJeGZnMUVpbXJHOHN3MGxyQTlraWNnazlramEwZUFhaWV5T2FOMHFDRzAz?=
 =?utf-8?B?NVlwT0JKM2R3TWRFeDdyZXdsM09OZUp4aWdCSjdLMENWN3A1VVBSSlpvWTlF?=
 =?utf-8?B?aTBrdUNuZ0xySzNmRWl2MXk3d1N2eUdDdk9mampRZmJjeHJzUSt6a2puUFFx?=
 =?utf-8?B?UTQyRVRFcGRTUmtTdnNBTVkwZXh2R3dOYVZBUEQrbFpzWkYxdFF2Uk5jeEJ3?=
 =?utf-8?B?cVRwdDFiZWpJR1FNSU81dUI2WlVxWkt6SVg1UzFjV2NUU3FmM1JEUS9iaHM1?=
 =?utf-8?B?NEVpYzdVSjYxQXJVcTM4UmlKV1NqYkllNTlzQzBRVnlPY2xFdzdUU2dKbW1K?=
 =?utf-8?B?d1ZWRytySTJJRnZkTWx6YkZjUXFBcXZPNEtCWUU0UG9JTFpmak9lQ0pzY0NN?=
 =?utf-8?B?N0lCVEhzN2xReFMycW9IbzU1ZGpub1VJdGhlT1hvN000c3FqUWkvckNiNHNo?=
 =?utf-8?B?NEFrelpnbFYrYkNJTTNDcjNBTEE0WVRTKzd0ODZWb3ltQnNjcDBaUlorYUVy?=
 =?utf-8?B?MGhjVUF0Ukp4QzRtQnozb2NoNEpQMkhtM2s5L09TNmhyalpUVFkwbkdtR3Nj?=
 =?utf-8?B?UXBtOTE2NTJya2t4c0t3cklwSmVXWER4YUl0QmoreEVjQzhsdS8wRHByVmVl?=
 =?utf-8?B?L2lPbGdCdE1PbkxkRkNGRmp5clp3QlNrZk9qeTA0dWdRMENMbzh2WndJSlF1?=
 =?utf-8?B?dUN1TTNCS2dzY05kWUFaOXFGcW9qSUo3VjlvU0ZUMVN5NkdKNmxLZ0phZjE2?=
 =?utf-8?B?aDJiMzFLRzRuL1k1dXU3QW9CQVJoNHBDTlVQNjZ4Y2piWFMxQnk2VlA0eE5F?=
 =?utf-8?B?Mmptc2hmSXlId1F1YnRXNTZ2MkpLNEM2bWRNdDJnMWthc0RCejRhbTc0NXFs?=
 =?utf-8?B?L2VKS09Vb1JuRm1PNGpUM0JIZEcxVHFPa2ZtSnFlZUJBdzkrTytpYUVwRlhR?=
 =?utf-8?B?NFU5bmNJS2duazFnZEF3VW5ua2Q5OTJodGt5N29kc3F1SDJYaDlHaEVUbDl4?=
 =?utf-8?B?d3h6cHdWektvcEJVV3Nnb1dTRjgxTm9jR29pc0gyK1FCUVlRQzEzbG9xTTRo?=
 =?utf-8?B?UHZKOU5BMk9iZTZuT2pBblpRamtBa2VvWFFJb1dvblF0bzdMTWlEMFNFcHV5?=
 =?utf-8?B?NUE9PQ==?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4af1940e-b81d-4bc8-bcc9-08da81dcf1fb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 12:18:38.3173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8/JIPPHpJqL6JvvOwItvp6xO5ALtbHrTAMMrfAB3uyeGXmsekecthLkDgYR/0ReHJMXhas7JVzUC/g32M9Kdau4fgeobnSOyht+8LXMZlSg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6611
X-Proofpoint-ORIG-GUID: PjvsS0-aSr-f3UfV2jQFLk49pEp9IwjM
X-Proofpoint-GUID: PjvsS0-aSr-f3UfV2jQFLk49pEp9IwjM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-19_06,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 malwarescore=0 bulkscore=0 clxscore=1011 mlxscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=317 adultscore=0
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2208190048
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

On 19.08.2022 14:23, Greg KH wrote:
> [Please note: This e-mail is from an EXTERNAL e-mail address]
>
> On Fri, Aug 19, 2022 at 01:38:51PM +0300, Dragos-Marian Panait wrote:
>> The following commit is needed to fix CVE-2022-1679:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0ac4827f78c7ffe8eef074bc010e7e34bc22f533
>>
>> Pavel Skripkin (1):
>>    ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
>>
>>   drivers/net/wireless/ath/ath9k/htc.h          | 10 +++++-----
>>   drivers/net/wireless/ath/ath9k/htc_drv_init.c |  3 ++-
>>   2 files changed, 7 insertions(+), 6 deletions(-)
>>
>>
>> base-commit: 6eae1503ddf94b4c3581092d566b17ed12d80f20
>> --
>> 2.37.1
>>
> This is already queued up for 5.10.  You forgot the backports to older
> kernels, which is also already queued up.
Are you sure of this?
I can not find any patch for older kernels in the stable mailing 
list(except for 5.15, 5.18, 5.19).

Thanks,
Dragos
>
> thanks,
>
> greg k-h
