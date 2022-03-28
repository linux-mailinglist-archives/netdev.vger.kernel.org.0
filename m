Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8094E9B28
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 17:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238031AbiC1Pca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 11:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237822AbiC1Pc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 11:32:28 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034BC5D64E;
        Mon, 28 Mar 2022 08:30:47 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22SA3wkm009217;
        Mon, 28 Mar 2022 08:30:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=JOa9lKRk0ig5AOvMEv+seW8e0/O62i88R9zNmhF6FIA=;
 b=C8xqh4w5fzWHy3Aui4tVbFXz9f/dH2zWjpQecpqhPNrs7j7MSDbk44xSE3BXEiszH1+U
 3ej8vB0Qkuibw14UpD1nNhOW59uasPdaW0oo1VclQMOiJVRAqswkw5hiRZDkj8xL1k+s
 51TxCAw3+zzq72koyeIMG4Sei6FE7gRWAWE= 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2045.outbound.protection.outlook.com [104.47.56.45])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f2252aa0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 08:30:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRtzL8e+gQCEg82PnF0MKssrNGNneQUwU5fKP2CH0smwemEipBPYp8iKzRx/RQKmBWtAR6ubPowWAMNG8UHpfOOu4kSW8pbxKWsBI3JtQ7Y9v3WZ/nLW3wJERRZ6sKFcNBYknX6uC9Yrk55FQ2P7a3H+3kSVXOwqad9FJT1DubVafjOIVzum7OWYQG0WK+6QoXvi+P01FB+zU10gNkSF/50ZfTonQF/7oDhjy9/kYhvvyI01NdZ0fljK74BY/Wv1y0mKckA+E+aBEo2qbGR5k9r1GM0yMQesbofub3pMdgGBXZr399kZFOW5xyzXAJLwRzb+i7GEhppv7wm/FMldJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JOa9lKRk0ig5AOvMEv+seW8e0/O62i88R9zNmhF6FIA=;
 b=ZTzkzYrD4iEhaOxgmV45SomRJAvWEV+MnzlwH2W6Ys6nDQWbtzbavq6cnqAEaRMUUwWKIIPCx98u90F9pk75bkRsbvOiOIicpQTSabOWcdshE5mp3szZ94B6uPS+mQ5n3tKV3HkpR93Dpk//RAR2XlkrfOeqchiGUS20U2YSSZRJaFjcxwzFKnfQsj1PDFVCRkfh2AFIA/M5ssAk4cA5xPPkM1TKJBk+S2RkBeBB7UIy62knJ7RCRK2v53BZHqWoZPsMX4Vb0PcypfrZx0W78s5ABpTaPc+JzK5Q67Pikb+gZQuf6dhLzHAp3BbyZWWkkOu6xP6S5tLHRZcoSQIdQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM6PR15MB3035.namprd15.prod.outlook.com (2603:10b6:5:13c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.22; Mon, 28 Mar
 2022 15:30:24 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::4da5:c3b4:371e:28c2]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::4da5:c3b4:371e:28c2%7]) with mapi id 15.20.5102.023; Mon, 28 Mar 2022
 15:30:24 +0000
Message-ID: <77377a51-f9d6-0ed6-afc2-387e4e7df3a0@fb.com>
Date:   Mon, 28 Mar 2022 08:30:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH] bpf: replace usage of found with dedicated list iterator
 variable
Content-Language: en-US
To:     Jakob Koschel <jakobkoschel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
References: <20220327215010.2193515-1-jakobkoschel@gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220327215010.2193515-1-jakobkoschel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: MW4PR04CA0209.namprd04.prod.outlook.com
 (2603:10b6:303:86::34) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48da5a21-ac37-46b7-3437-08da10cfe0eb
X-MS-TrafficTypeDiagnostic: DM6PR15MB3035:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB30355880E8735DC329D30B28D31D9@DM6PR15MB3035.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uYtM92muQMDty6BwFvBhV487Zjt87NTBDApZZW/gKJhP4bplt1QwyZdVsEF702GJFglZEs5+pZ/IMjVgOWPJhO1quScycMbKmjq7hA9zpvIZD0Ekm1XBJM9NkA6aKMO/Bk0W1RkfM7HuJVnpQy7kno74F4qIWC5WMADhQUWilgU/Vt5851P6ZZ0cOoN2eXnQKp95C0kPcyLuPOyiS25TWmrfQE5h6hLN0Sa0q2JPQ1TfAY/uFjn/jtmkP0CC1OqzQKOFDMTE9fgm/KYliCT2WQiwDJZE/c5dKKwL9BRw2F/Ook2vhOBNgTc7ePG6xLooToM8dMwCuenxdMWONC+AqNlOBlYp+tesTpLsOoGyn8l3aDeShIPRl0U2uKWl4pWJVDw+vyH8IhmTF3WtcDm0rfSKa4zTXhZx47TVZMvHOOEdo8mOB+M0R42v8n4FKgW6XazRSrP7D57q8al/o8oJ++eL7NA8o+jTeOOrLFXKasxSL6D83yD8xxcZ+kUh+GU/SaoSHbamcIMya/4KG8isoZ0z9btDthC7o11arlCWLkSmZ69PUhR+wFM9VLF/55+4wPgsk7sHbpk9pDtw6vga98HBM2D7MmX8JrEj76UCKpwm/P8JaDmxFY9YgnEYWRu0E+wzuURqzEjaOvKGYwlmlJ5W3dqfBDQ/pIvS5q91ixo/mznBC5l5saGicnW1v0x84bALttZzLUbM7kgcFpRr0dnGxnmEHX1kgLOSH3Gcy16uBJsod5zX9o9BngHBOElSexgASbD7cnv6Izf1WKOB6qmLSeXm7w2LSZUIEiMyLKLMlzLuY6+ZXt5KG9F2ICvE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4744005)(53546011)(7416002)(8936002)(316002)(2906002)(6666004)(4326008)(66556008)(66946007)(66476007)(52116002)(38100700002)(186003)(5660300002)(508600001)(6512007)(966005)(31696002)(8676002)(6486002)(6506007)(83380400001)(54906003)(86362001)(2616005)(110136005)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVVrREJEdGRHemMrY0wwQkxUNHVxdS9tS09UUnRPeHFmR3ErK2RUaHdrcjlT?=
 =?utf-8?B?VWxHMVAwQmpOZnN0bmxjK1lhTXRuK3kvZTgwcTh4MVVEeStQRVNSRWdaTzFL?=
 =?utf-8?B?amk4VEllZW5lTkJ6MWhXRW9yOVk4RGJLREpOTTVacFQzVjE2ZnBPdjZqZWg3?=
 =?utf-8?B?VExPS3k0QTlrb2l6T2NHRGpucUFrQVhvSDBGYW11cTFHV3RXVXloZzF3RWJ6?=
 =?utf-8?B?TzdQbVZMVEZEdkovVFJXeWphdk5jaW5ZdnVoWWJuRFFLN3dWL29INndIbmFU?=
 =?utf-8?B?OUVqdWZQMk1vR1RsNEdLRnM0SkpudHJBYWU2Q3kyT2M1SGU4ZDhNUmUvWXJK?=
 =?utf-8?B?TVdRbzlRWFRzS3R5cHhFVnExU2EvU3pwSy9Ebk8vVkw1dE9tWmhkT0ZIN0xZ?=
 =?utf-8?B?S2lUc3JJWTVwVFh5RW9PMUpRK1E0ZU1OY3RiY3lDMXlzOVRDNURmTVlNOGo3?=
 =?utf-8?B?VnlRd2dmMVkvNWhNNzR3SkFDSjR2MDJ2SXJERnNWbG9GVXl6QWpwYWM4TG54?=
 =?utf-8?B?ZDhrK2pGMGtGM3BXYm5XNE9OWEJEK3ZnZW03RUNvMHZyZlBZYjl2cUlxNkFL?=
 =?utf-8?B?RFYvY3RNUlVuam5lTGROK05ISkxmblVSTkt5VVg2ZVpaa1ZCVjk4clpqL3Q5?=
 =?utf-8?B?TUxaZlhyTlM5Q1lxTjFCOGxtcXBSNU40ay9EU3Bjb0F5VE9iTUdSRTFhVzZK?=
 =?utf-8?B?clRDYzlCVHFGZTR5TWVsR3ZNaVI0M0tDekdpL1YvYXlrK3dHRFkzK21lMFcw?=
 =?utf-8?B?bHl2TWk4elJFeWtGZFpEVzdBdm1QM08zVDJXT3ZCb2FNcTNpcVgrTlg0Ym85?=
 =?utf-8?B?c3VxL2N3cmNIZWw0dnMxS0EyM2JLZHQ3MkdYY2tLbkVnNE9DR2Mwc08rYXhK?=
 =?utf-8?B?dzIxRG5uNDJ1M091WWNqMjVNOGpXTGRJY2M4a1Rla2FEbERTZXNGWDhYVGo4?=
 =?utf-8?B?cnF3N3NWNmxnSlhzNlZ4SWh5WndMeGxDWU82TFVIc1lva2VrT1hoU3JRb0R0?=
 =?utf-8?B?RUtjTWc0aU5sS2FGQnp2c1dzZEdzZUQreXcxS0NCOFZuSVJMeXcxSDhVS210?=
 =?utf-8?B?SHh0bWxWR1YwVnZ4S2FjNnZUS1dMYlhKd3VtQ0p3OXplek9wWks3N3o2S3pm?=
 =?utf-8?B?M1M0TGhHOUxFbDExMFhMam1Lb2RBcTBlNnlyS1JFNnR3ZlUwT2pGVWl0Tkp0?=
 =?utf-8?B?VC9SU3NiY1RMOUFleGdDdzFFY2xmTElESmZrbUM5bXIzTUcwajRRS3Axb0JO?=
 =?utf-8?B?cFJVdXF6Y0lCYlY2d004Y0svQUYyaW51TW5scDZtTngwczVjb1gvQzRNWWRI?=
 =?utf-8?B?RHVoRkY1a01TMlFqZlZTYXlYbGc2Q3RhcFFzcGlCUHFxMm1BZ3ppZ1RSMzlu?=
 =?utf-8?B?dGxxdFE1eG9rcStldlVQMzNNUGJjNFluTTRhWTVPKzgzYnBHd3E1UnBnVkcy?=
 =?utf-8?B?bXl1R2kwQ1lOb2xhZFpRZXE4RHVjUVdIeDcvWXJDK01mdVBrZW9BbVpQSjA0?=
 =?utf-8?B?MjlNVmhGakU2WFMvaEV0MW53TGFiMU01ald3NWdtVGpLSDNpUFVsVG5odG9l?=
 =?utf-8?B?aGlhU08xdGg3QzhuNmF0THEvOGdqSmdqTjdQenhqL3NkdFUvbnU4Z1N6c3VN?=
 =?utf-8?B?eS9YeWoyM1QyY0FBMzkybkRlUGk5Z3NXdU9MMkl1bFd4YWV5UytNc01ZWTFi?=
 =?utf-8?B?WTVsVWlabi90cnUwNTdCQnM5K1dHWWhzb2VjZEF0TU5jMGw3NVU4Unh0ZWlk?=
 =?utf-8?B?aEJaY0Yvd01KeWpXbjl0VjJ2a3d3Nk9KbDdoMlNTTEMzbUcvQ2Zwa1JGMExU?=
 =?utf-8?B?MDhxaVovRjF3MkhwOUpPYzZlaTh1c2VLYWpweTVGWDFqZjV1LzBnK3kyM1JW?=
 =?utf-8?B?R0h5V3BnVDVmZU5ZUkFwc0YvZFJWWkNMS256YlNMRVZEam5UQkdnM1JDOWlR?=
 =?utf-8?B?aHlDdUtsTUZ0bmpjdXhvclpZZm9UcGFpdERUTnVneHQvSGRFc0Fic0JMN0Mw?=
 =?utf-8?B?N21wRXNxUUc5WVRFcFhBNXJzVE1Gek9GaUNZWjQ2bEx2UVN0eHJLZ0Y5NmhY?=
 =?utf-8?B?UFl4WDNZVWtMeVJ5NlFEek9hdjVUejVrYXNrWWVTTzZnbFNwT2p3V0lxZzJ1?=
 =?utf-8?B?cThZQktLV3cyazN6RWlwZEZ5amkzMGJoY0YzcDQzMHZUNndoUlROUUdUN2My?=
 =?utf-8?B?MDBFQ2QybTJ3ejcyZUZTdkhHN0tjZG1wbm1aQ0xRV1dpeGlQa1VHUjlMMDRr?=
 =?utf-8?B?L1JHdEV0QWpvQjFSa2RNWEFmNFgzSHFnNmF5VnQzUTBVby94a0w3TE1lRHN6?=
 =?utf-8?B?bHRLMjQzcGhXaHhVY2RJdDFVd0UyT0lOd1RpS3VGOGxGejMybHZxYjEycVBI?=
 =?utf-8?Q?p1rLcNYogOVZTUSg=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48da5a21-ac37-46b7-3437-08da10cfe0eb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2022 15:30:24.7100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7jhucM+zVVip9k0Lh7CC7I7ztY2oKjHzm0LSFC7aepO44K/ARbBLolgSOFJRTbZs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3035
X-Proofpoint-GUID: Qtt4naJ4Xg6am2P8Z5OWs2T9tDsXudyZ
X-Proofpoint-ORIG-GUID: Qtt4naJ4Xg6am2P8Z5OWs2T9tDsXudyZ
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-28_07,2022-03-28_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/27/22 2:50 PM, Jakob Koschel wrote:
> To move the list iterator variable into the list_for_each_entry_*()
> macro in the future it should be avoided to use the list iterator
> variable after the loop body.
> 
> To *never* use the list iterator variable after the loop it was
> concluded to use a separate iterator variable instead of a
> found boolean [1].
> 
> This removes the need to use a found variable (supported & existed)
> and simply checking if the variable was set, can determine if the
> break/goto was hit.
> 
> Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/

Since in the commit message, we have a reference '[1]'. Maybe the above 
should be something like below?

   [1] 
https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/

> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>
