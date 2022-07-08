Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3AD556B3B5
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 09:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237375AbiGHHlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 03:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237232AbiGHHlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 03:41:01 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD507D1C1;
        Fri,  8 Jul 2022 00:41:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jSXLLceaNnXyU6u0VUSNZhBdYoSS6c0nd4sLCsCZ9sn0IQK9di7srTHBD12eqG9/SttWi1gBj5SjwrbRPuKOBfhtlD8yWgVviNNvI5U61USXAQeoeBscFzyAD646UG6X9BnV5sV/vB0Wh6SYiVLKPnMClUc3cuavIhwHAbClantrfdl/CmihPEtUDJKU9lZ5INVHA8EEdZI7s0SK8a0w8yJWDBrNtFWsGYc0rSXwk8URrteWQv0PNx4d0G7HKhPFXpmoIEUz27FraILSRxt8zS8lYtjRAoXHugKSSLMPzbaxc3FJCR/DVqGdCLvG+JyjEmDd59WeJCKoQCwngtDBYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uqhrpRPCWvAfzwLJuhjDImZ6j/odiK23hZSBpapb48Y=;
 b=byrYY9a5JrnhdsRwNHyTciCMiyrHfGBg1qgLaDEAdqKkdDOvT2h6zXoUtx/ECvedIl4L0tIRl6oSTaPrsMAyHuCNvl0QGlUJ9c/OrthtuTlv/8SWTCgs7VNUQKHNnXnx4bWKsZpQKrQhEc23V9xhuAi+boDhpvHSutzxx1rGZm8F7zk/Iilns7bscCU5VCuslmRKhN4Cc7MDR/go5/aUWc1w1U01onk8vZeXcNirfm5HSOYd4e1DSR+j2xeZBZk03Sc8OCneGxP2W+MJuW3fQeC1RnEuOWKTtGZEa1moI6NXm1ksZkzYT9mec/0/NnU2dq4L9pO3yoctnbsmqMinWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uqhrpRPCWvAfzwLJuhjDImZ6j/odiK23hZSBpapb48Y=;
 b=OS03k8x7OMqzyQMxTKvK+NF8Dkgdzj6mq9TEjJcl+DWOh9121izrilN/E8jJIncbeSiczbhb5BdHfbZwgbSNeFbVSyjX4cCdFWi91LAPsiVcGRQosA0fe6imGAfeyUAxvZAf67OKUZFjQpYQmx3NhlHUqr2yk+lPVxJVZr+0N9s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synaptics.com;
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
 by MN2PR03MB4958.namprd03.prod.outlook.com (2603:10b6:208:1ad::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Fri, 8 Jul
 2022 07:40:58 +0000
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666]) by SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666%6]) with mapi id 15.20.5395.020; Fri, 8 Jul 2022
 07:40:58 +0000
Message-ID: <cb2d33f6-1b6d-57bf-55b1-59d48cacf492@synaptics.com>
Date:   Fri, 8 Jul 2022 09:40:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 2/2] net/cdc_ncm: Increase NTB max RX/TX values to 64kb
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        oliver@neukum.org, kuba@kernel.org, ppd-posix@synaptics.com
References: <20220704070407.45618-1-lukasz.spintzyk@synaptics.com>
 <20220704070407.45618-3-lukasz.spintzyk@synaptics.com>
 <YsKVp2U3wzuSMxtQ@kroah.com>
From:   Lukasz Spintzyk <lukasz.spintzyk@synaptics.com>
In-Reply-To: <YsKVp2U3wzuSMxtQ@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE0P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::28) To SJ0PR03MB6533.namprd03.prod.outlook.com
 (2603:10b6:a03:386::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48477562-fbd4-4e98-fa08-08da60b53280
X-MS-TrafficTypeDiagnostic: MN2PR03MB4958:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U3GLIuSWYGnEFHXJSi/gUZN4uT/WyDp3RkO5y0dZW0mzSErrU5O1Pc1wlJOY2cufeOX0g6viHPD+uryeahue0V55Jy5Cp0B5VSYkCzg1Qv2PN0XeVHzfK0MtjPaPXxtS/laENemBsz+vtbmcm+++6lSuwBxWp+qkELroSQycaQp+s7NRnoFNIZy0+Ww07hu2bzQ0CvVQR9nhJtufQ1EaZlAi4dbBbcxxmE+xIYv3uqJ77TbX3CrjePBmbcKUhyN1i81f1oVC8VJXcYo78l1KvkHNJ9+9yNmDSOROpOW/cVihjNU0Z75j1dGdAJPYDXjdc6ojSFQRc/eb8IFYtKQVGE5AZ5IY/cWh7LkJG58K2YOWyo0eAHQkP8xkTuzWDhs3OewKeF1grjdeiq3f+JaltqIrfLz7ogb8llT1xvjg66YsgrDMbVrMOLuPN5XtCqZNRbIHkNdZsUnkMyo7hi5OVJeaCqgX+OwmfzHJSPeRrOQ8VZEONDmm1xmSKTPM59jB67WILdZug6Qq0aTbXmbs5gDRDkaUN8uLwVGn4dRrCdmxAeWRpMC0YBG7XjCxcS3/AoFW1v+tppwhaRPvRYmcSgIk1U7IvPbxFP6tw6P7WdIXquhJD0GvLYfUQay34Sy5B0BpeI8VGoq8kdjvPPkhDd5TFrJJXqRsSYTP/HuYuCm2XtwDdX0jr5O4NZWlDT8waq8qq4htuX+oMtMAT3mXwbZnL+sJoEfu3GZ5dMuHHQSrpkXl/3DOJHeJBJFJpN9kSL3WKVInliSEgYCxVSJ46h0Byka0JhpMBiJIlxkwoWa4fx4HrWWcGgAzxZxOxQ6H9lEti68Io9DyW6SmXPkjE8zBh6LfHKsWSHTE593pa7zpijrQcA09Tokq0eFUVYUp/hlgKac8EErCARgBsgV9jQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6533.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(396003)(366004)(39860400002)(66946007)(86362001)(478600001)(31696002)(38100700002)(36756003)(38350700002)(41300700001)(44832011)(966005)(8936002)(53546011)(6506007)(52116002)(26005)(2616005)(186003)(107886003)(6512007)(2906002)(66476007)(66574015)(83380400001)(6916009)(6486002)(316002)(8676002)(6666004)(66556008)(4326008)(31686004)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YlVTdmt3cTl0OUVkQzVZbEs4bUkwT0dvK1hhUVFIYXNwNzZOa2NNa2p3aGJT?=
 =?utf-8?B?TGNRQ1hXUHhjOXBQbFljRXFwV1NmNkF0SmMyUC9qRkJHck5UOGdGVEF3MkRP?=
 =?utf-8?B?WnlndWxlWkFPS2UwaE5VZFE2Tmdob29YMTYzKzhPWFRTUHg4Mnp1WDRSUS9Y?=
 =?utf-8?B?b25KN1NPc2pYQmsvNlhNWWxmc0o2VWdKL016UTdIcGxpSGNqS2sxT3FQOXg4?=
 =?utf-8?B?OWhxUktTanovb0svSVBIWVo0M2FkUE5ZeEtRYjVQZEoxczYwMVZMaThwRklO?=
 =?utf-8?B?bGhLYldXNEs2R0crNkpNVXp1MWk4c21YdFd3VTNiRTdpU2o4ZHpVb1R1QTd6?=
 =?utf-8?B?TUphMGRIN3ZYQVBkSEl3dGJjNFBzZFNNc1pXWExzV1pkRnFkWW9VVWdNSGxo?=
 =?utf-8?B?Z1FWejYxeE16anRkcnFXckRwblpFaE5IMFdxYmZMSUFFKzd5czQ2TkhPd0dL?=
 =?utf-8?B?YVBNcFpGT3dJdVdPWkVwcjk5c2hVaExqSjd4RzNiUVM3TDJiTUNMTGROUWd1?=
 =?utf-8?B?Nm9oNzFnaGlwRUxqOW50QWtqcllwVGV6bFJRWEI3ZXZDY1R4ZnpQZFNZYTIy?=
 =?utf-8?B?N1pXZGd1T1g2dkJ0Qy9BbFVUZHpXNkFad2NYckVUL1VQMXVVMlpMaVJsbW9x?=
 =?utf-8?B?RzlwalBRN1VNYVRUYzlKRXVUMTF0VmFRYjViblZad0x3Tk1HMzVtRWd0aEpk?=
 =?utf-8?B?WTBZRUQ1YUk1TVhOdlNRMkJIeVpYREV0Sk96NUFwK3pzY09GRkEvdFVWSWM5?=
 =?utf-8?B?QzVXdDNFOWZNZUd1V1dDbUluQ1cyNHUzeWlPU3RpZkZoQjJ5eUEwaHBvalEx?=
 =?utf-8?B?QzBlUU5ob0tZZEFTM3RGLzBnK2JxeTVHbTJ0dkU1bmV1L1QrZWt3NmlyWko5?=
 =?utf-8?B?Z1IwclgwN2VFb0tqYitUMXAxa0Ztdk1XNUZkZkxONnEyOGxiekdPTFNNczNI?=
 =?utf-8?B?S205d09jeStScnh1WmxXa2RJcms3Y2kvdS9ObnpRNVQwV1F2RmhudTVPQ2ls?=
 =?utf-8?B?T2FGQ3REL2hJY0hTL1gwSlBXakU3bis3emF6L3N6NFYvMXo0VVpPMnI0anda?=
 =?utf-8?B?cjl6Rll5Wjh4ZTJ6cmN1TFJuRWNnOTV4UlJqaUdlV0ZtcHlqOS8vU1dZMFJt?=
 =?utf-8?B?VGpwTnpYRmgwbG1vTTViUDNoYkhTakdCUHVPT0RNeER0TUpNdmpmTUZyOW1L?=
 =?utf-8?B?VUxmby96ZS9VTEV0NnhwZGNuWUFFK01hdHhQYmxORGJlbzdoejZJUGgrc29a?=
 =?utf-8?B?N2ZsWkttbDBjNWhndGsrb1NoTTB0U2s1RFV0VG1hNU0vZ3JTZDJ6YVhVQkpI?=
 =?utf-8?B?Smt3UlREUThxU1V0UzhOdHlyb3NlWWhMUFFHbE53RGliZjduTzE3bnJobmNU?=
 =?utf-8?B?VWZYbExCOTJRcEsxcWJQNHhiOTMyYnFSYVlaSExsaVNxdFZSby9zYyt5em5q?=
 =?utf-8?B?MVNzQ2R2NG1uYkFQZDRXanEwSkNCT1h2N1JIWkV3T25kZjF0L0tqOExZaXpm?=
 =?utf-8?B?SmtPeENsaFRpT2tXdENLUkhIcTVpcEtNblVGdEt4bVdXZTdEcUhJMEJyaWs5?=
 =?utf-8?B?RHEwNEFsbi9kbGJGd2lxS1QrT29HY1kwVUVBbmxSdmk1aGhza0VqVlFNS01X?=
 =?utf-8?B?QlpqS2NtZy9oWk9Vc3FGZlluQ3hmTm1IeUQ0NHo3N2FQTzNJSHJoeEpkY2tl?=
 =?utf-8?B?ZTNrT2JlNVdoVVFnNzdVbVMxNFhaTnl0aXVDSWhTa3dLN0MvUWYvalM0UVF5?=
 =?utf-8?B?ajVtNnFjKzd5UURTUkVuam5sdEMxVWNzRlFJUkdNa3Z6UUdOWFZpbW9FLy9B?=
 =?utf-8?B?SHJMZ09PWmUwZ0M5cmJJQVlySUNTamdjbytGZVE0Wit5RHdQWDRKYkp5UGZ3?=
 =?utf-8?B?S1AwbjUzQXdSc2RMRnhTYndta3VmMVZZKzcyQk1zR3RSYkVyS1RWbGMrZVl3?=
 =?utf-8?B?MW81SDNkdnI0SWtoYy94dlpFU0FzcGJGRk9DWnFZU00vcDl1SW4zYUYrd1BN?=
 =?utf-8?B?WGVhc1NKdHhLdDREangwdlJHMldsV0I1eU9tUnEyWVVqeFNGdThGVzR6TmpF?=
 =?utf-8?B?Z0dndit3aFFZTW5wanczR0JiOXlEMStaTU9sVEQ3bWNuamlFVHRWTmtSdzdZ?=
 =?utf-8?Q?VgFhbY5EKwAGaz8x3fllz+ysD?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48477562-fbd4-4e98-fa08-08da60b53280
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6533.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 07:40:58.1507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2oi00jEaUpjTnJtkzLjZaT8WU8iJZGUuzhQYxG9exgbUP+NHuCtXPd/78r6FaX3zfqxDaQFyam7HhkKY4ynVSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR03MB4958
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/07/2022 09:24, Greg KH wrote:
> CAUTION: Email originated externally, do not click links or open attachments unless you recognize the sender and know the content is safe.
> 
> 
> On Mon, Jul 04, 2022 at 09:04:07AM +0200, Łukasz Spintzyk wrote:
>> DisplayLink ethernet devices require NTB buffers larger then 32kb in order to run with highest performance.
>>
>> Signed-off-by: Łukasz Spintzyk <lukasz.spintzyk@synaptics.com>
>> ---
>>   include/linux/usb/cdc_ncm.h | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/usb/cdc_ncm.h b/include/linux/usb/cdc_ncm.h
>> index f7cb3ddce7fb..2d207cb4837d 100644
>> --- a/include/linux/usb/cdc_ncm.h
>> +++ b/include/linux/usb/cdc_ncm.h
>> @@ -53,8 +53,8 @@
>>   #define USB_CDC_NCM_NDP32_LENGTH_MIN         0x20
>>
>>   /* Maximum NTB length */
>> -#define      CDC_NCM_NTB_MAX_SIZE_TX                 32768   /* bytes */
>> -#define      CDC_NCM_NTB_MAX_SIZE_RX                 32768   /* bytes */
>> +#define      CDC_NCM_NTB_MAX_SIZE_TX                 65536   /* bytes */
>> +#define      CDC_NCM_NTB_MAX_SIZE_RX                 65536   /* bytes */
> 
> Does this mess with the throughput of older devices that are not on
> displaylink connections?
> 
> What devices did you test this on, and what is the actual performance
> changes?  You offer no real information here at all, and large buffer
> sizes does have other downsides, so determining how you tested this is
> key.
> 
> Also, please wrap your changelogs at 72 columns like git asks you to do.
> 
> thanks,
> 
> greg k-h

Hi Greg,
To my best knowledge that patch should not affect other devices because:
  - tx,rx buffers size is initialized to 16kb with 
CDC_NCM_NTB_DEF_SIZE_RX, and CDC_NCM_NTB_DEF_SIZE_TX
    So all existing devices should not be affected by default.
  - In order to change tx and rx buffer max size you need to 
additionally modify cdc_ncm/tx_max and cdc_ncm/rx_max parameters. This 
can be done with udev rules and ethtool. So if you want to use higher 
buffer sizes you need to specially request that.
For DisplayLink devices this will be done with udev rule that will be 
installed with other DisplayLink drivers.
   - This tx,rx buffer sizes are always capped to dwNtbMaxInMaxSize and 
dwNtbMaxOutMaxSize that are advertised by the device itself. So in 
theory that values should be acceptable by the device.

Here is summary of my tests I have done on such devices:
  - DisplayLink DL-3xxx family device
  - DisplayLink DL-6xxx family device
  - ASUS USB-C2500 2.5G USB3 eth adapter
  - Plugable USB3 1G USB3 adapter
  - EDIMAX EU-4307 USB-C adapter
  - Dell DBQBCBC064 USB-C adapter

Unfortunately I was not able to find more or older than USB-3 device on 
company's shelf.

I was doing measurements with:
  - iperf3 between two linux boxes
  - http://openspeedtest.com/ instance running on local testing machine

I can provide you with detailed results, but I think they are quite 
verbose so I will stay with some high level results:

- All except one from third party usb adapters were not affected by 
increased buffer size. (I have forced them to use tx,rx size as big as 
their advertised dwNtbOutMaxSize and dwNtbInMaxSize).
   They were generally reaching 912 - 940Mbps (download/upload)
   Only Edimax adapter experienced decreased download size from 929Mbps 
to 827 with iper3. In openspeedtest this was decrease from 968Mbps to 
886Mbps

- DisplayLink DL-3xxx family devices experienced increase of performance
   Iperf3:
    Download from (300Mbps to 870Mbps), also from historical 
measurements      on other setup this was (90Mbps to 500Mbps)
    Upload from 782Mbps to 844Mbps
   Openspeedtest:
    Download from 556Mbps to 873Mbps
    Upload from 727Mbps to 973Mbps

- DiplayLink DL-6xxx family devices are not affected greatly by buffer 
size. It is more affected by patch enabling ZLP which prevents device 
from temporary network dropouts when playing video from web and network 
traffic going through it is high.

thanks
Łukasz Spintzyk

