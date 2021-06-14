Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB9F3A6961
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 16:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbhFNO4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 10:56:05 -0400
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:64131 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232798AbhFNO4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 10:56:04 -0400
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15EEn1Tc004883;
        Mon, 14 Jun 2021 07:53:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=rFt2KQWWo45HeH0gQqRGHASxjEmM1NBcLakAfVZCxxM=;
 b=uYo/sy+I9gW3fMgE/8AKFCTyYq3Huahs4oz+MWqs5GCFvjV7ZV99NM8OgbKqS5aQwz0u
 cjJfFU06SP5Lhwrq/5uEc7arCCjmQa5NjXWCK2UrYfCoMquOEeDSrKdhD+tge2OMmdIm
 y7QPNVy8sTuxz6DZqJf/P2M0BJkW3aVNsY2t1POpjv4lM4fD5epSEK1FN+dqkhTVyC72
 VmVm+CWLwzYmTnzmhMsNtF4bVfs18kZsObos5BJgRNkvTeYCGEMKUpfVDqkTRlQXlNQv
 G+wlRHhkZNjgSnjGdDQ3RUSG5CXqNXmRPdE9yrxs/q46NVf+pIWeq52aWm9RdzQlD6Nh bg== 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by mx0b-002c1b01.pphosted.com with ESMTP id 3960u411ed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 07:53:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HCxBlUPQ5J2odxHRMfDUPAETPzX7A5yrA1Hh/UtIUhS8QSGVxM18VUn7oRlycdEtN5Fj8/KnK39xUEtR1jeIAVE0u1iUx4bFPV5ms2DVTePgwmcqRqHL4/kRxgQTayrXUkLIByOlggFvouoZcx6IZnrs5Aqxgt/Xjz13qsdTgv9YMTHFhTeBXegpDqITLq7lZCadi1+kA97XQyNPQhogp7WB2M/JCQwKBV9syPV/BLt99rov7YrP2tNgY1tUjOGRbfWEDrdY15aSHa9GJN+YL/Ulg1Uy+z8gGAqicPUDFyPHic56uFGyo1ljEjgJ13WrVfuKJiuiw3Kdv5fB9rhF5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFt2KQWWo45HeH0gQqRGHASxjEmM1NBcLakAfVZCxxM=;
 b=FeqmbngHZayThZ1uAm3lOOBXETog/5h+071NO3Vf/770tHS8NXd+H2H0aSeNRoN2f6Ppu4QE66sSAatCV/PPSq/+HfeiSHvD5me7NXDKtUbTmmrBCZ5ekDqyaz4OE3CAO41/SvpPikJtg1n7DOarU3yFKVO+C3ZtT5w2xn69hbLYOYANFPIAkPJZrBSGQ5VwSyKAXGEqFWfh7e6BfG+o82UYtL47MrrDfyAZh79UQNxHMShPGj5EKdjaAC/xZi4y4PD4o73pgcoDvqqD5Fc7sl9Fir7tsTh8gFP6GWag1rVN3oHejoPH1EOcojOv1RbHEoTJD4F0EK0whgrmmOEVWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=nutanix.com;
Received: from CH0PR02MB7964.namprd02.prod.outlook.com (2603:10b6:610:105::16)
 by CH0PR02MB7900.namprd02.prod.outlook.com (2603:10b6:610:101::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Mon, 14 Jun
 2021 14:53:48 +0000
Received: from CH0PR02MB7964.namprd02.prod.outlook.com
 ([fe80::f833:4420:8225:5d12]) by CH0PR02MB7964.namprd02.prod.outlook.com
 ([fe80::f833:4420:8225:5d12%7]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 14:53:48 +0000
Subject: Re: [PATCH] net: usbnet: allow overriding of default USB interface
 naming
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210611152339.182710-1-jonathan.davies@nutanix.com>
 <YMRbt+or+QTlqqP9@kroah.com>
 <469dd530-ebd2-37a4-9c6a-9de86e7a38dc@nutanix.com>
 <YMckz2Yu8L3IQNX9@kroah.com>
 <a620bc87-5ee7-6132-6aa0-6b99e1052960@nutanix.com> <YMdKWSjiXeiDESKR@lunn.ch>
From:   Jonathan Davies <jonathan.davies@nutanix.com>
Message-ID: <b71f40d6-42b1-9600-01cd-cba743c34d26@nutanix.com>
Date:   Mon, 14 Jun 2021 15:53:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <YMdKWSjiXeiDESKR@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [92.13.244.69]
X-ClientProxiedBy: AM3PR05CA0089.eurprd05.prod.outlook.com
 (2603:10a6:207:1::15) To CH0PR02MB7964.namprd02.prod.outlook.com
 (2603:10b6:610:105::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.249] (92.13.244.69) by AM3PR05CA0089.eurprd05.prod.outlook.com (2603:10a6:207:1::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 14:53:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 266f6003-02b6-4ecf-fa2e-08d92f44370d
X-MS-TrafficTypeDiagnostic: CH0PR02MB7900:
X-Microsoft-Antispam-PRVS: <CH0PR02MB7900C80467FA21DAD5B9AF3ECB319@CH0PR02MB7900.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ERxnGht05HFxyEtzPIY+uKbhRf3hofaCbMXY92vwv9m7mXhKXwncKzf4jnomnqjwQo0RaauDL+zRl8ft+bHjcT0DUOlVM/1WMohPc4WAWtpd7+6hkkHTMz6YLAIvpaDQo6tK8aGL7rh3HXzn9v11jxveDqMWKBId9Fv8LBemAQR+OaqYOU0X8r79Rn2t3Ox451LS1svaArG5P7Dt8t2yunnE+WReE0ck3eOB8GSKD2D10TvXT9c9OResdh2tvCFesy4EnwwBchAjCINeAbQPiGqKaq5OUZRk6ylblyL9ggSJLo8pzIaw2QrFBeYCnN+H0EY+D++RFOwAMcPmmzDGcymJpJDKAntL7EBSD7SB4f5XfEpsESzESmhN73MHM8RU67UASouF1bSBUMtAenpR2V3/9+POS8Pn6sCumC29K9ZojLiFCGw99UzvwTkCnAjYin7Q5AvQksboybjK0qHCG1YWDptybjkbPnJTtHDooY0cs8KoNyxWRMw7KhWiT7xgfvGl7bBM5b2Tqyp9sEwP25Z7osefcwMIvPSK7KU1M8VNbBdSRIOqWFvQqegiFjFfnef4ctDY+fpbi4Py7h7upryO1W01WMY2Ux7T/6rJnvl2LfrbA/d+W8Dp0mPG56PdfrY1x5lzMKX9D7lADbie3lZkBLhJ2bLG0r5TcAwWktmqZYWGGq36QrZECwU2sNyjlC5OOTq7qSyVR78hZ/iUcYP9u7bB0OGQ0bDQpkLjJ3s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB7964.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(366004)(396003)(346002)(136003)(4326008)(53546011)(2906002)(16526019)(6486002)(478600001)(31686004)(186003)(8936002)(8676002)(6666004)(26005)(66946007)(16576012)(66556008)(6916009)(38100700002)(38350700002)(36756003)(956004)(52116002)(44832011)(31696002)(5660300002)(83380400001)(66476007)(2616005)(54906003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZzJ1b2ZxQW9zNGdLTzFSelFseXUrclpDdS8vZy9xYW9QOTB4RkE0M1dOVkNZ?=
 =?utf-8?B?VmpRVGVScnRabnlOcmc0R01ZQjNoNzBkT21jOTZKSzRIeFVNVmgrU3JZRWha?=
 =?utf-8?B?WUptc3BzWGlzNlUzck9FVGxBV05JcGllY2VNVjFlazBrcEJWQkRkbzM2S1Bt?=
 =?utf-8?B?TmtaSmZncktFMS96QldLdFpORG9pYkxUZ2lNaFJKeER3bmRhUmxCRy9rbGhW?=
 =?utf-8?B?SmFaZWdoYXlTSmdsUVU1T3dobjVLUzdWMW9oc2MzV284YmViOWZxRzlCZjZC?=
 =?utf-8?B?NVRsTUUyMDdmNVRsejkzZnpNMnZicnVTYXZUTDQ2K2g2YzF5Tzl2Tk4xQ3ln?=
 =?utf-8?B?OTVETUdCb003YW9VWGJ4dW84aDlSaENaQnc4YU9UNHQxK3NGWUtBS0NlTkM3?=
 =?utf-8?B?dDdPRVlkbzNBZDV2SmFUYVhVU01LbGtISUJIam00UFBTd1I4SlVPL3NxS2ZO?=
 =?utf-8?B?bGFkU2hWV2E0SVo2STdVWU9OSlZQVUhFMXJMcVBleGx2L2pTZCtKSjN2VkRD?=
 =?utf-8?B?dmprR3pGa0hmSms0QTF0VjErWWtPTnJoSTdoQWdLRVUvdU1hOWxPQjNzZnQ2?=
 =?utf-8?B?QVpnZjJONURJWlovVTU1cHpnQmZibXdpYzlYcjVpbXA4d1R0K2w5b3NJTkFS?=
 =?utf-8?B?a3BLZG1pS2F2K0xuR3dvbUhyajYzZ3VNdW9xWENVZ2R5UkwwZ3JHTmlRaGdR?=
 =?utf-8?B?R0FZck0wOEIvbFJxWXBXRktpYmROakMwN1JubDdGODI5OXh5aVhxT2N5cDEr?=
 =?utf-8?B?Vjh1TEpOdm1aeElVcUZrK0ZlQnhJQUNYKzE3dzlGUG5PanNNVUFHVWV0b3lw?=
 =?utf-8?B?U1M4Z2RkcGFHM0pHcWZxbGlEVkMzK2J0UFpFb2JnWDNRbm9FQ25ReitOSVdp?=
 =?utf-8?B?dW42S0cyZVpOQ0hPeElKbWoxTTV2L1djREtPUmI3RUd4N2Z3WHhvTzRxM2ZZ?=
 =?utf-8?B?SUxaL2NreVZ4Rlc4NjhtSWNHZkkyUEhUWEpGMHJoRVZFMnZicFVta3RqbWxs?=
 =?utf-8?B?SDlCYU1DV1VrQVR2cThMbnRmSGxTMXNRc0VGbUQybXJqN0JGMndEekk2cGwy?=
 =?utf-8?B?VGVBKy9ncGZhWjFVUys0N3p2Yy9Hb1Awdk5aYlpJT01MYlNFeFFHd3ZJNU1X?=
 =?utf-8?B?MUtveFlmYjV5NkE3RVA5bkdyZEhOT0FKYThzekpuQ0NvVmI1MHVlZmRzek5m?=
 =?utf-8?B?ZHNhRVBEcVIwbmhSbkZaa09ieGtCTHR5RnYvdnZNWVQ4WHBMSFBxYmFJNk1M?=
 =?utf-8?B?Z1dlSndhVUU3Yng1SERSazNnSHdmY212ekF4V2c5MUhnNGtGZWU3dmNmaUds?=
 =?utf-8?B?REhIbHVneDBlUTJJMXJTTGE3dGNMRUlRWTFqREpKT1djajJESjJ1ODVWbjkv?=
 =?utf-8?B?MmU1MVZDTHV6aG94cHNPNHlGbk9VOHpESWwyMFFzMSt4SmhwdDg5cmpyUThw?=
 =?utf-8?B?MnFERG9wUnp5bGViN0dMN0txd2FMLzFXc3NJOThKQ1hFT0FqQ1FURlAzWW1t?=
 =?utf-8?B?RGdnQmVtc0pzcHVPWnhENFE1OVlsQXdxMUd4UnF0ZGVLakw3NmlEOWs3dkNa?=
 =?utf-8?B?dUxEcGRoS25QZEIxanJ1OWE5eUNmV3VSSWhHaHdnUTJmTVNRZWMzU0pWckk4?=
 =?utf-8?B?MDlBSnZvbEhQUHFDbDgyV1JtOEpnRWpnMjh2dGsyNEQyVXYvdUxnR3lhV2Vr?=
 =?utf-8?B?cndXQnI1QkE2RlI0UEE4UFBRVEpSRXFpRGxEWnl5bG4vR3VFQlpaVms0VWV1?=
 =?utf-8?Q?ZyxXr/zoBAI4Gmg18h3fgqL61pHh7S+C63bMA3m?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 266f6003-02b6-4ecf-fa2e-08d92f44370d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB7964.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 14:53:47.8914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZRiz0EDorrzYlcddrjQ8WreLKIKrc2TXKrdgpaGId+qtClSL1nATrX5gF4D0F9sqp6YHixTglz9Fs8iwSzrtLRiwaQpCDc83fcNeY3SkKTg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB7900
X-Proofpoint-ORIG-GUID: Qz6B3ssSnaBTFnt5MomT5E7OFMcXRSK6
X-Proofpoint-GUID: Qz6B3ssSnaBTFnt5MomT5E7OFMcXRSK6
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-14_09:2021-06-14,2021-06-14 signatures=0
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/06/2021 13:23, Andrew Lunn wrote:
>>>> Userspace solutions include:
>>>>    1. udev backing off and retrying in the event of a collision; or
>>>>    2. avoiding ever renaming a device to a name in the "eth%d" namespace.
>>>
>>> Picking a different namespace does not cause a lack of collisions to
>>> happen, you could have multiple usb network devices being found at the
>>> same time, right?
>>>
>>> So no matter what, 1) has to happen.
>>
>> Within a namespace, the "%d" in "eth%d" means __dev_alloc_name finds a name
>> that's not taken. I didn't check the locking but assume that can only happen
>> serially, in which case two devices probed in parallel would not mutually
>> collide.
>>
>> So I don't think it's necessarily true that 1) has to happen.
> 
> Say you changed the namespace to usb%d. And you want the device in USB
> port 1.4 to be usb1 and the device in USB port 1.3 to be usb0. They
> probe the other way around. You have the same problem, you need to
> handle the race condition in udev, back off an try again.

The point of the patch was that if your intended names are usb0 and usb1 
then the module parameter would allow you to nominate a prefix for the 
initial names that's not "usb", thereby avoiding collisions.

But I can see that the consensus is to live with the possibility of 
overlap between the names initially assigned by the kernel and the 
intended names, so this is moot.

Thanks for all the input.

Jonathan
