Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED1CE4F925D
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 11:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbiDHKAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 06:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233910AbiDHKA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 06:00:29 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2079.outbound.protection.outlook.com [40.107.20.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7965C165BBE
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 02:57:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i8d3rw0kpTI7nQpX2xJZKiJfYrfBgvwgD0sUTcXpiEUWEactPmixBGsfk1g3SkHSnHwqPMV205ttGChjN9VGRbbOx+6TuX0C4zmHiIXcP6ew0V+NkfazikhnjwFWeEUW//cCLf4DG2L6cf014W94iH3QvUaUr3Dfvu+F72DnQ+1COPHi7l/w1Q2IxRraY2KOjycWMQflEdx1AlqtShhzi+BkKSMtAd39pqZYzTcOnFxxnFUY3aLElosBYn0qWgBZI+TvCFi/UpyETuhnk8O1oIeJhEry/GCYkpVnrMkofLAN9C2Nt8A0VAUyW+InDjluOC7Yr5SovDw7WFdFQzIVKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F7LBAo48TA2UmSaYFdqcm1lOd+wy79CfHPFzq0Ijv6c=;
 b=Q6HMrvu7a0X2KEUODkfV3Y6ae1TE7je4CrDGZJ6qQikO59wlPfS0d7T32g3jeRFNKVMAsM8H0BKxMqYKQpeXNGgTK0WhWSNMBj+og1hOPl3KmYLRvx4Toe35kv1siMMrr01txco/eqsXe8oV8+fCecMGiWLTWMPgPBXA0mXt5UP4BzfFtJPw/VQAahk7l4832ZZRz83uUBEMS4tts2Y19BprBQNXaJeNJb250Xz80npumuhMyoqn9akOaoSy220btYcNSRy3t5OoAYh/YBeYXTltfVT1BsUjBKCY/hL4/POOPqA3D2Zagyhuhsje5Nknrzujq+/XfenSaSxIofFk3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vaisala.com; dmarc=pass action=none header.from=vaisala.com;
 dkim=pass header.d=vaisala.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vaisala.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7LBAo48TA2UmSaYFdqcm1lOd+wy79CfHPFzq0Ijv6c=;
 b=BMUvrwY6hzr4MAYb2tAZowWDFxl/q/Whk5YB6uTisogE6nxKzldxjg8BU/HX1KtrUhTYiQwhrko66vquke129EXJehhv+3ZZN1S8SaCRIYGtoGZgccLloQmMDKOciJtRT8GNe4CTWhKJaWhnY64lo2TglNPoqaxM2Rgr1iafLl73th8AgJKU4T2wnzYxAH5n4J2P2cyLYxqh9KO0SLXIT/kLzYr/lENfoZSkZG+UL2T626q2f94kPgcfohcpDI13zic/xqS/jSLC71Fa8MmwpUBM8hDQPOxMpobl/93lxj6a+/Nttl0ho8zklNHv/wW6T+/HGGIPELX62A24JyeUbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vaisala.com;
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com (2603:10a6:7:81::18)
 by PAXPR06MB8252.eurprd06.prod.outlook.com (2603:10a6:102:1dc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Fri, 8 Apr
 2022 09:57:28 +0000
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::382a:86f3:70e2:e1a0]) by HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::382a:86f3:70e2:e1a0%7]) with mapi id 15.20.5123.031; Fri, 8 Apr 2022
 09:57:28 +0000
Message-ID: <adf4ce47-142e-711c-bde1-cda1fc0a196c@vaisala.com>
Date:   Fri, 8 Apr 2022 12:57:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] net: macb: Restart tx only if queue pointer is lagging
Content-Language: en-US
To:     Harini Katakam <harinik@xilinx.com>,
        "Claudiu.Beznea@microchip.com" <Claudiu.Beznea@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Shubhrajyoti Datta <shubhraj@xilinx.com>,
        Michal Simek <michals@xilinx.com>,
        "pthombar@cadence.com" <pthombar@cadence.com>,
        "mparab@cadence.com" <mparab@cadence.com>,
        "rafalo@cadence.com" <rafalo@cadence.com>
References: <20220407161659.14532-1-tomas.melin@vaisala.com>
 <8c7ef616-5401-c7c1-1e43-dc7f256eae91@microchip.com>
 <BL3PR02MB818774AF335BBB8542F22072C9E99@BL3PR02MB8187.namprd02.prod.outlook.com>
From:   Tomas Melin <tomas.melin@vaisala.com>
In-Reply-To: <BL3PR02MB818774AF335BBB8542F22072C9E99@BL3PR02MB8187.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: GV3P280CA0018.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:b::33) To HE1PR0602MB3625.eurprd06.prod.outlook.com
 (2603:10a6:7:81::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6bac09f-27bd-41b2-307d-08da19463065
X-MS-TrafficTypeDiagnostic: PAXPR06MB8252:EE_
X-Microsoft-Antispam-PRVS: <PAXPR06MB825236A1B1B8FA84A73B66D7FDE99@PAXPR06MB8252.eurprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zmO3+rHO4MUCwp9lGfSuE+PjhB3jwgzniuwa6TNz4siZGUK4d2c7yThTRrYvjRN5016/fdQQAbhLwHQHQG+7Wkh35+2NvNLLZxcH8WsDFIstCzggYSy9IRzOMVYeQZQv4Vs7gaXq2DeIPSCk1Ag3/jHKmvv1ZnH8FGfUYS3yfztS+jdcLETOpQtGebz8cFO1fmXfEHilGZDsbOh+A73u41pQuCkEm8vgTtpM2eveWoBiWK5UmDGqeiGU8FiVkxk8fjiZ9lmj8ZTtbgASnGVulWEDILIp04Uw8Nf9w68RoiOf8o8XLNiH52MqzkK31Pj6ir0ALmfzHbZgHqIghx/9CaiY/2W1frIo0ZLW0BdoiTTNoWLf30ncyoK2uSh53QxPEpS3V8sCc22jP5JxmKvg8f0QDx1cb5ccamkzlSjYy1FWv/U8YB4C86PPrl/TBXGYvGZMIrQvMrVQDTCwhyApKaCk4F5fe8+YaCg/wtsZbmC1XeXOjEcGPwdE0tJEA02gTOaXvIVHWnsUlmcxwCSWkTSPYwr2vYvwaCA9Nqo1VY2zawOoxuGDaZKaJ/t1fHFdqVvkenicldMAlFpbLGZ1yxBODDtXRcwHfENvHEhyWWDez2VO4mSxVdlkBA+WipcV3B1jPTkroZSCEEC5Zj+6gjxp3DTU4DguGDSm3Y5/m8KVD+igbPfYfDiulwTapRMa7+ej1a3wn+byhxMZZhvimVJEVfSIoZEk9VdICsHBa/cn6ujV/xV8CJ7SvlZjtsGDlNgQ4PtbQlfwcTHOcCLCkMJsCGQZDd6rwbrsVXRKloBlAHIQ3P6rkpy2r26Ag/DzmdOT2CI7/nOXHTtwR1CkFN1jrI2fObFu7UnjqIrCnrI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0602MB3625.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(66556008)(110136005)(38350700002)(54906003)(7416002)(2906002)(66946007)(44832011)(2616005)(26005)(83380400001)(66476007)(8676002)(45080400002)(186003)(31686004)(4326008)(86362001)(38100700002)(31696002)(5660300002)(36756003)(508600001)(6486002)(8936002)(6506007)(52116002)(6666004)(53546011)(966005)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHBEZXMyOGJRVXVVcGdDQXgyWXdwTHNFWXlCdnRDOVNRUEY0L3Z5M3ZEWXJO?=
 =?utf-8?B?ZElQN2F4Umc2K2lTWUE5eDk1YWFsUzl1WldtOEcvVTdQSXdNem5LcDJuOUtH?=
 =?utf-8?B?S1E4NTZVNkZ2VkY3dkpYcHhhYW5ZcEoyenR4Ump6b2pXL0d0bkV4Q1AxTTJh?=
 =?utf-8?B?QkVwZTZubGcwbVhrUFRTUnlwekhNVGZhOG9uRHdtb3dsS3NKS3VZRGhnNmRU?=
 =?utf-8?B?ajNWcTV4SU9rNnhlaWFKakJOYnhTMCsxZlpJUnZzZ1pMS1ZzY2d0b21Ra1VJ?=
 =?utf-8?B?TkNsZUpja2FpUDB4WERabXA5OW5FTTBEeDF2NkorZHJZbTJaN01aOXJIeStu?=
 =?utf-8?B?UDRMM0Fja0hkWDNEL1dhVnBlMkMwTXp5Qmd1bUE3MUhISUlKQlZtZUdIM0dB?=
 =?utf-8?B?SHdXSWZveXdwQ3R0TkNCdzVoUjUvcXpiQVo5YXdHak1wNjBUTUJxekNYZ0xE?=
 =?utf-8?B?VzhYY2JraDk2N25mRDIrOFdMMXVKSitVNTVmTnRXcUMzOFc3Q0NyTnRIQWFs?=
 =?utf-8?B?UkY1dk1kUktLbzg0WHJBZjhlM3ZqbThZQjQ0QmR5cnJQa0xYTXdYWVNWODRU?=
 =?utf-8?B?bUdUUkNYdktTSU1BZXl1blhtcWVYWkFuclo1VEdBN2hnQisyQWVBWlFSOWM3?=
 =?utf-8?B?a29lam9wMDNLVGxzWDlyc0Zra0trcWN1eURNdWdNbkVJOG5IS045SmpjUDMy?=
 =?utf-8?B?bEd6RkFhcVFOQ0x1MVhFNFFzK3hJaTJYUVcvc2FFNFNJUU1INVRqaGUrNVly?=
 =?utf-8?B?Q3puRUVxUDNMYXRkREJONXRzejFZK1pRVjhyT0ZydmpvMUJmOEM4WFV2Q0d3?=
 =?utf-8?B?VURyWlBqR0ROUjQ0ZE1JTVR1K3pvTEMvOGRtY3Rlc2ZsbUsyeEdUQkUrNDdk?=
 =?utf-8?B?cXJRbFBGOU90eFFrbUdyK2VYUUNDaU9HeEdEb3FSS3VudUFVdk9pMU91T0hW?=
 =?utf-8?B?SUJsclZlbEcyZjR1c2pZRkNJNlEzZFdBMkIzYk42U012ZWY1MjVCMTcxdC9I?=
 =?utf-8?B?c0czbjlvOWtaZ0RLK2RLVXBqRHNIVjhDRjdGSDh5QUF4VUpuRVlkdWFNSm9x?=
 =?utf-8?B?bGFJL3JJOWdaRzFTT3hIV0x2SE9xNnhaaEhLSDBMdFBwOEFHc1o0bHU1L3RT?=
 =?utf-8?B?Y0RXVWduZUZqclR6ZzBXUUcxOVhHOWFhSThRcmY5SndndVJ4NVRhQXoyYnpt?=
 =?utf-8?B?bC9PV2prYnArbU5WUkwwVmVkWjNOMGhvQ2Y0MFNqLytYcHgxZUhiVEszQnZ3?=
 =?utf-8?B?VVkwVHpiT3ZTOXNzSmRYbGY2Nm53VTIwSHM5YUt0T2dvajVWSitDbkhWQ0hU?=
 =?utf-8?B?RkZxcUIzNlhKUEQvejNuSjNrVFhSRHVaV1FTNm9GY3NkNklHSmZvNUQwTnZT?=
 =?utf-8?B?d1V2L0xSMDhNdGtzODBLZVYwTUJzUTF6Q0kvK2VTU2F1cWIyZ2dMZDdHWjFI?=
 =?utf-8?B?eGVZenkxUnpJS085VzZDNlB1dTlzRHRyMUo2MWIyWkdYV0szOW8xa0crTDJN?=
 =?utf-8?B?Z2cvN2FBTW1WMlEyL1JpSmxDdWxpekJ0Qm9Hamk2UFhCZmZYcnpSUkpldE1R?=
 =?utf-8?B?MHlnZS9jTFdIN3BWOWZOclJpTno3TVF1ZGI4ZFhPZFpUWGwzNHVhMVV5cVVs?=
 =?utf-8?B?Qy9Yb0hmdlE5aVhKdERLTnQ3VE11OWJnNXhjUFQxMVdCbXBIRDFySzFUenhj?=
 =?utf-8?B?UEhZb2lNYXBLUnNTQnhUa2JvMHlRUFZKV0dQdUNZNWVYbWJnR1JOeFB6RDJ0?=
 =?utf-8?B?VjRKTlFYaGV4TXFwSTlQN3BWU09HRlFPTmoxYzZnd01wclFiTnlkQi9wcDhn?=
 =?utf-8?B?NVl6U3ZWeXp5QTJBS3MzN09qNzVhL1hhcFpOeU90ZWM2V2QvUTBtdERnNVpv?=
 =?utf-8?B?enAxQUtwMmJiaG90dEdmZUc4RDVETWU2dGQvcjVtZnVlMmlNajJDUTIvcURC?=
 =?utf-8?B?TjNRdU1FU00rbnBkT0hCamxiSUkrQ29mVzFKL1VFZHZIakpxSzI2eXgwMFJM?=
 =?utf-8?B?aWd2RkdXL200V2NxdWdjVURWZThrZEFUMHF2SVpzN1I3Qno2bmo1UHRLZWxC?=
 =?utf-8?B?VWcvYkFGWEpYT1MzSTNBSmt1bUJxV2RMWFJMKy91WTZMYjNKbWRLcUdPaUxS?=
 =?utf-8?B?a01SWXo3RUhXS1p2SUJTL1p6SE5XSnZwdUJXRXY3S3JVTnJMeVhLQWh0dTJm?=
 =?utf-8?B?clRpN0RRYm5Kamo1cTg0Q3gwQlp3d1YweWM1bEljdXd0MzJIazZLa1BWSWM1?=
 =?utf-8?B?MktWWmIxZHNwZW4wdEZReWtJRndpMDBhZjFHcnJKVS91ZTVWbHY5VWQ2MkNW?=
 =?utf-8?B?YW5DWUxkYk10MnBLa1NnYUR4TVlQM0RkNWtqRDBjNEdselNNYXRqMzM1R1FL?=
 =?utf-8?Q?Nu9K9tC7iS3wyHKM=3D?=
X-OriginatorOrg: vaisala.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6bac09f-27bd-41b2-307d-08da19463065
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0602MB3625.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 09:57:27.9345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6d7393e0-41f5-4c2e-9b12-4c2be5da5c57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 41EVdFFZepahwoMNNd4ydy6/19CzkgrlYC9Pqmgv/Guz+auQWpmjSEPA8UM9ixnxeRCYsY1nS1PvTnbQqZpNmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR06MB8252
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Claudiu, Harini,

On 08/04/2022 11:47, Harini Katakam wrote:
> Hi Claudiu, Tomas,
> 
>> -----Original Message-----
>> From: Claudiu.Beznea@microchip.com <Claudiu.Beznea@microchip.com>
>> Sent: Friday, April 8, 2022 1:13 PM
>> To: tomas.melin@vaisala.com; netdev@vger.kernel.org
>> Cc: Nicolas.Ferre@microchip.com; davem@davemloft.net; kuba@kernel.org;
>> pabeni@redhat.com; Harini Katakam <harinik@xilinx.com>; Shubhrajyoti
>> Datta <shubhraj@xilinx.com>; Michal Simek <michals@xilinx.com>;
>> pthombar@cadence.com; mparab@cadence.com; rafalo@cadence.com
>> Subject: Re: [PATCH v2] net: macb: Restart tx only if queue pointer is lagging
>>
>> Hi, Tomas,
>>
>> I'm returning to this new thread.
>>
>> Sorry for the long delay. I looked though my emails for the steps to
>> reproduce the bug that introduces macb_tx_restart() but haven't found
>> them.
>> Though the code in this patch should not affect at all SAMA5D4.
>>
>> I have tested anyway SAMA5D4 with and without your code and saw no
>> issues.
>> In case Dave, Jakub want to merge it you can add my
>> Tested-by: Claudiu Beznea <claudiu.beznea@microchip.com>
>> Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>

Thank you for the effort to review and test this! Also thanks for the
discussions around this issue to provide further insights.


>>
>> The only thing with this patch, as mention earlier, is that freeing of packet N
>> may depend on sending packet N+1 and if packet N+1 blocks again the HW
>> then the freeing of packets N, N+1 may depend on packet N+2 etc. But from
>> your investigation it seems hardware has some bugs.

Indeed, this is not behaviour I have encountered in any testing. If we
were ever to encounter such issue, then it would need to be handled in
separate manner. Perhaps call tx_interrupt() to progress the queue. But
then again, this does not seem to happen.

>>
>> FYI, I looked though Xilinx github repository and saw no patches on macb that
>> may be related to this issue.
>>
>> Anyway, it would be good if there would be some replies from Xilinx or at
>> least Cadence people on this (previous thread at [1]).
> 
> Sorry for the delayed response.
> I saw the condition you described and I'm not able to reproduce it.
> But I agree with your assessment that restarting TX will not help in this case.
> Also, the original patch restarting TX was also not reproduced on Zynq board
> easily. We've had some users report the issue after > 1hr of traffic but that was
> on a 4.xx kernel and I'm afraid I don’t have a case where I can reproduce the
> original issue Claudiu described on any 5.xx kernel.
> 
> Based on the thread, there is one possibility for a HW bug that controller fails to
> generate TCOMP when a TXUBR and restart conditions occur because these interrupts
> are edge triggered on Zynq.

This is interesting hypothesis and that would indeed lead to this situation.


> 
> I'm going to check the errata and let you know if I find anything relevant and also
> request Cadence folks to comment.
> I'm sorry ask but is this condition reproducible on any later variants of the IP in Xilinx or
> non-Xilinx devices?

I have not seen this issue on MPSoC (atleast yet). Indeed this issue
seems to require the correct timing conditions for being able to trigger it.

So any additional information that we might get about possible issues in
IP is welcomed. However, the hardware on the boards we have at hand will
still be the same so the patch as such is relevant.

BR,
Tomas



> Zynq US+ MPSoC has the r1p07 while Zynq has the older version IP r1p23 (old versioning)
> 
> Regards,
> Harini
> 
>>
>> Thank you,
>> Claudiu Beznea
>>
>> [1]
>> https://eur03.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fnetdev%2F82276bf7-72a5-6a2e-ff33-&amp;data=04%7C01%7Ctomas.melin%40vaisala.com%7C352a532fe14b42ad01d508da193c6320%7C6d7393e041f54c2e9b124c2be5da5c57%7C0%7C0%7C637850044400650522%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=rsBnJEVlDqpSUIfL%2BuXzAgTUL4w9rqaR6A6OLAi9gNQ%3D&amp;reserved=0
>> f8fe0c5e4a90@microchip.com/T/#m644c84a8709a65c40b8fc15a589e83b24e4
>> 8ccfd
>>
>> On 07.04.2022 19:16, Tomas Melin wrote:
>>> EXTERNAL EMAIL: Do not click links or open attachments unless you know
>>> the content is safe
>>>
>>> commit 4298388574da ("net: macb: restart tx after tx used bit read")
>>> added support for restarting transmission. Restarting tx does not work
>>> in case controller asserts TXUBR interrupt and TQBP is already at the
>>> end of the tx queue. In that situation, restarting tx will immediately
>>> cause assertion of another TXUBR interrupt. The driver will end up in
>>> an infinite interrupt loop which it cannot break out of.
>>>
>>> For cases where TQBP is at the end of the tx queue, instead only clear
>>> TX_USED interrupt. As more data gets pushed to the queue, transmission
>>> will resume.
>>>
>>> This issue was observed on a Xilinx Zynq-7000 based board.
>>> During stress test of the network interface, driver would get stuck on
>>> interrupt loop within seconds or minutes causing CPU to stall.
>>>
>>> Signed-off-by: Tomas Melin <tomas.melin@vaisala.com>
>>> ---
>>> Changes v2:
>>> - change referenced commit to use original commit ID instead of stable
>>> branch ID
>>>
>>>  drivers/net/ethernet/cadence/macb_main.c | 8 ++++++++
>>>  1 file changed, 8 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/cadence/macb_main.c
>>> b/drivers/net/ethernet/cadence/macb_main.c
>>> index 800d5ced5800..e475be29845c 100644
>>> --- a/drivers/net/ethernet/cadence/macb_main.c
>>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>>> @@ -1658,6 +1658,7 @@ static void macb_tx_restart(struct macb_queue
>> *queue)
>>>         unsigned int head = queue->tx_head;
>>>         unsigned int tail = queue->tx_tail;
>>>         struct macb *bp = queue->bp;
>>> +       unsigned int head_idx, tbqp;
>>>
>>>         if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
>>>                 queue_writel(queue, ISR, MACB_BIT(TXUBR)); @@ -1665,6
>>> +1666,13 @@ static void macb_tx_restart(struct macb_queue *queue)
>>>         if (head == tail)
>>>                 return;
>>>
>>> +       tbqp = queue_readl(queue, TBQP) / macb_dma_desc_get_size(bp);
>>> +       tbqp = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, tbqp));
>>> +       head_idx = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp,
>>> + head));
>>> +
>>> +       if (tbqp == head_idx)
>>> +               return;
>>> +
>>>         macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
>>> }
>>>
>>> --
>>> 2.35.1
>>>
> 
