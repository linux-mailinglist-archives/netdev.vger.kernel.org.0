Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A7250F966
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 12:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344779AbiDZKEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 06:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348401AbiDZKDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 06:03:37 -0400
Received: from repost01.tmes.trendmicro.eu (repost01.tmes.trendmicro.eu [18.185.115.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467FA62BEA
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 02:24:16 -0700 (PDT)
Received: from 104.47.5.52_.trendmicro.com (unknown [172.21.206.109])
        by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 3CE0B1000125B;
        Tue, 26 Apr 2022 09:24:15 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1650965052.588000
X-TM-MAIL-UUID: 6fdb132b-385e-400e-891e-685b5ea67b4e
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (unknown [104.47.5.52])
        by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 8FBA510002184;
        Tue, 26 Apr 2022 09:24:12 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n99BRZiHBm0Ne7FF9BH1F2LrYPmFghhMhcWCBhnpbx53z48rBCwUqSUKEv9j9YGiDh7y7cQbYq+fz52EPYbIz/CSS+9d2RaV0DNGHevvRkDNFUxb47/y7nlKKhSYC04FQ7yLIAoRQkeseIvk1PjlBNJsVm5IgH0AlizyO4ZPsxNpexp8L7jNhAgbnJ88+bRBbJ8GETtZi6zTlypJXQBLZXOiLf84Wnle2bYSZpfsrzu394VV3hqo/BuRYlojFfXYqpKwukg0Kg+uasSdgXeZX6VU74IZefnTmScZd+NbBKbs7xZ6KfKT1pvRzzgpey+rZ0pjtdm0TmfG8cTjTlGVcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Th71CWUWUPueaJF14ZEex3R314WrrLtrwMDZZBnubuU=;
 b=hxCShC8KihVMiAsKo4MVqW6NW9vBciQ7mHMHWJQl/CQUxj4Dubwqto405rKpw/tIyNU+uCh34r4DAZu8X6++3xG9L+/MQKW76A7/kmTW4ur2lECuVqbc9I3jt1rrzbDxgPM6Pd9skhKo2lTcyARRT/Gu7FKwI4MKPGYjh+qdTtP6/Y6G6cFCNVW4mVx0QU2Nq94sN85bvWVLiAgaMIZzeTjolwbD4RyH79gGjqbyjRK8G4kUKaTB/jGro6iX3OW08Bt5X9AeSjZ/FSE9hH494b55aJvtTmrXxQXt6VmoLkAwOpkgI4ptwqXn2csp4bMywqIojt+wJ8v+oRFpoePOUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=opensynergy.com; dmarc=pass action=none
 header.from=opensynergy.com; dkim=pass header.d=opensynergy.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=opensynergy.com;
Message-ID: <ea0c7c48-a93b-e0fe-0a1d-e4c88c235f37@opensynergy.com>
Date:   Tue, 26 Apr 2022 12:24:08 +0300
Subject: Re: [RFC PATCH] Bluetooth: core: Allow bind HCI socket user channel
 when HCI is UP.
Content-Language: uk
To:     Marcel Holtmann <marcel@holtmann.org>,
        Vasyl Vavrychuk <vvavrychuk@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220412120945.28862-1-vasyl.vavrychuk@opensynergy.com>
 <9EA1D51C-D316-49CF-A7F8-765C58C18880@holtmann.org>
From:   Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
In-Reply-To: <9EA1D51C-D316-49CF-A7F8-765C58C18880@holtmann.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P189CA0027.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::32) To PAXPR04MB9106.eurprd04.prod.outlook.com
 (2603:10a6:102:227::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d76ee49a-66ff-4f1b-2edd-08da2766854a
X-MS-TrafficTypeDiagnostic: DB7PR04MB4059:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB40599DFBCDA6F2B676886C7CECFB9@DB7PR04MB4059.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AKpcARHN/3PJ7bUi4d44vctkioTSQtAh5Xb/lSuAnTpTkLQkTsjQ6JwnoaSTtyEoKHbJm7QpHww6lAsU48LrZT2ZUwr59BH2lyiEKpEooD36PA2TZuw2XNxWwX2suTu4s/wbPtaxGmWIfesJk1i+wjw0OXXTzDQPNyPKCwtakPjsB0TPK5bquNGPvz07Fkt0XmmAx8QB6pc9DgGgJCeykZjevsxgWneC3coHO6v6huJUoeXDPGgTJpOE6/FArqUPRi0FIogFgqn6HoNL3ev366tpdVAsyZIv2cu1jkxPKrvcexM0mINEazYOnOiO/3QPPo+wsDftexpEkX/0dosUgL/fWMIH1R4UHGlxrSb/T1lY7DxuDMLU/vm4ygtnrqFcv4XH55aK1sF2ey++RGweDqW4TkKGODPpp4yrTxNxUqsz5im0749f1Ackj0gY6d36s0DvSq7Rd9PnCZKv6cDTqcAP176JfUogV4fWpDZHUT36B/k4yEvrCKAeLouY9opH6BjXef8eJf0FaUcZA00W0Lhcwl5EMCmY38NuoIs713CcxqKZOdzvcfFlbOOb1lpwNzmilfnQyWJRu4YMVFBvyGPBlKM6OBS25XRGMQBPzV8+dn81gv45LiZ/4l61K6Rp2SfV0Vr58EK6SMmS6XOcT9N7p+Y6WRMWK/nfE86aXo/C95OpHdhViKO8lBJ0gc7cOdXDwprohJNNhxAWGydhUHquwnS54DYuW5623zvN5zk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(39840400004)(376002)(136003)(396003)(346002)(66476007)(8676002)(66556008)(86362001)(42186006)(83380400001)(7416002)(31696002)(44832011)(54906003)(66946007)(38100700002)(2906002)(2616005)(186003)(316002)(110136005)(8936002)(4326008)(31686004)(36756003)(508600001)(966005)(26005)(53546011)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWdibFdOWTdmTlh1K3UxblR0Y0krREZCTkdNSFV2dFpyUVdoM3hoV0tSU3Js?=
 =?utf-8?B?K05TbTgva2U3S2dRcnNZL05kc0xmVi9kckJBZWozSFowcUdhWU5ydERTb282?=
 =?utf-8?B?a3RGVEhrc2ZoMlNlTml5T25aZzhXS3NHM0w2SnVHcE5EQlprbmhlMS83WWVB?=
 =?utf-8?B?ZWFCdTgwNGZ1WmRNNWNURmdmcFd6ejY3UVZpTE5Kb0V3cCtOanJiMkM2dkpR?=
 =?utf-8?B?QmR5NWJiVWk1czUwOTJzeWFkcWJmM2gzZlJVTktVbDFHVHJ1aWROYXptd2ds?=
 =?utf-8?B?SUVubXdvVHNidTVnSnFvT0RMU2JEWHo4R1BnRzQzWTVucE85MDNTL202TGk1?=
 =?utf-8?B?Q3diS0R0Y1AzSGlMa3dlbzhYSjE3TkxJM2NsRGxCNmxDVkJzUkNrWlh0NmJP?=
 =?utf-8?B?dkVFUkw5UG5HeVZZVW13ZE9CcHpRYnRzNEVZMG1oQXBZYjhUUmQvL3RmTC9C?=
 =?utf-8?B?SnRiR29kZ0xYUmE4ZTR6ZmFXQUVMUkZjYWpFcXlpQmF0aHZRS1cyUHg0cGYz?=
 =?utf-8?B?cG8yVStBVkJPYi9JenVwMHovTWhWRHp3blV5eVhJeHJCaFJGWWE5ZWxZS3k5?=
 =?utf-8?B?Y3ZVYWdaNmVLSzhQVUJZMno1RFlrZ3FZWDQxdmk3bWczQngra2xOazZYLzFm?=
 =?utf-8?B?WlY5a1hPNjMySDRscGZGUlNYK3l1b2lrOUxiOTVKaEF1WnFDTVZvQlhXTE9D?=
 =?utf-8?B?cTMrei9hWUo5Q2N6bC84ekMwSGkrMHJ4YW9jYmNHNUs1R3B4V1dReVRGWm41?=
 =?utf-8?B?WEkrTzJkbFYvcGFiajhvME9yblFma1dGbHF4VSt1Nzg5NzFUQWZXVmU3cFNz?=
 =?utf-8?B?L1l1dnUreWF0UlZnVUJmOFhJSUlobldxbVlSN0tjMjVUMHZPTHhRckFDZVZt?=
 =?utf-8?B?N0xFMFM2aFBDaFdGcmRaSVM3NjNwdGhSZEJ4V2xlS29Ub2xrY0p1NW1CUm0y?=
 =?utf-8?B?cEhBekNTNENmZ014cFdONG0wQnZVZWFHWWNoUVlPNHZXYmwwTmpLZW9CWlhP?=
 =?utf-8?B?WGRYMVVnMWZES0RGTWhOYjd1ZE0zTmUxaS9yWEM0Tm5lM3hzTEJsVVl1STRs?=
 =?utf-8?B?OThQR3YwdHJ0QVB6d1RLczh4U3B4SGxNdVVLdTQ0UW40Wllac3VXWExUVitv?=
 =?utf-8?B?aTdwYmxzWkU1MDM1bTVqNjhva0ZnU0s1d01MUWNvcXhxQzJBN2ZyNWtqcnV3?=
 =?utf-8?B?ejNjdVVOR3dtMEpCN2UvUTc2VzkvaVJibi9nbGRxbVZkV1BCY0pld0prQlVx?=
 =?utf-8?B?bldSWndZbjNQeitmTjNLYUJ3WHJiYzRpNVduYjltbm1nSXV4bVpSbFk3SFlO?=
 =?utf-8?B?SW9TemUrU0d0K2NNVkRKdHU3ZGx5QVZvR3JtVlVIY1d0b2o0d2JBSXpzRFVJ?=
 =?utf-8?B?Q2JwempHemJBaDFwclllQmdub0QwSHNIbTNmWVFhVklVNmZTWkR0T0hGSXpt?=
 =?utf-8?B?MWVCSU1wT3N2N1MvTTg4YUY0YitRbDJZOEwrTHpiNGNYcE4vN0pRZ3pJS3NU?=
 =?utf-8?B?bHB1NUJYazJZVHlhbzhIM0twZkRXWXVkZmZubDhFYjZyTGdQd25LSE1PNmsz?=
 =?utf-8?B?QnlWcllFY0ZFVWpqN3g1OHhOdUR4emk1cWNZdmhYNnl3T2tSNzdsZDlMS1lK?=
 =?utf-8?B?RlZlbkJJS2hYQ2JweCszenFRbW84Y3AvTDRieklFVUNPNXBDbTR1VzZNMEk2?=
 =?utf-8?B?QTFVL0tRbFR2bGZ0ZFlycS9kcjQ2QWhUZ1ZPZlR3WVpmKzM1RUpXZGhNM3J1?=
 =?utf-8?B?T0syU3FGVHdkMjVsY2xoelBFZE1VaHJQU2VnYk1lZVc0N1ZoMTlqNnhFeGl1?=
 =?utf-8?B?c2NONW1KQmVGMUV3SnJpMjBIQkF3aWhqUG5LYWVOZzhISkN5clBYYTNMNW1j?=
 =?utf-8?B?Wk9ETzR5MjlYR2NzTXpIT05Yc1BYaTBpSGRTeXRLajh0R2dHLzIzbWRxTHdS?=
 =?utf-8?B?Sjk1ZlIybysvdGxKVGthZElIRkFhczdBRnNHa0FuRFVQYmR1M3FQUzk5RzJO?=
 =?utf-8?B?S2Z1ZVRRaVhtdEdqZ2VrdEs4ZlhTRlRDYTZQaG52SHd1K3M4WlBWdFN6T3A2?=
 =?utf-8?B?K3BuL3BDZDJ5T2U4WThIWS9ldjliUTdxWnlxSUNadFRHOTF4MlNNbVp1QkRa?=
 =?utf-8?B?c2V5KzhtUDZPT1dqMzJSM0FIcTltS2JtditXQWgrNTIrdzkvS05kNENuY0x4?=
 =?utf-8?B?eENQd2dlTWdHZ0Z4akRqRVcrdUpnT29jbm1wT1VhUHA5YjlEQUlvTGN1WlA1?=
 =?utf-8?B?c2VBQkZ2M3BRMjBLU3pxekY1cktFcVZ6TmFtNzhuVk80b1dFa20yQ3RoV0JT?=
 =?utf-8?B?dUNRYkdCdW5acHlBbXQwT1k0Smh3K3RUOVlTU21NRVhWbzVyWGlHZz09?=
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d76ee49a-66ff-4f1b-2edd-08da2766854a
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 09:24:10.4599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lH8qmIoKXoEz+4vZXwG41xojhD1+FOAqflUD6upxbcus6iMdVe8eN0MG2O1pubv4wqJ0X3dnOXQlQZ9R+ZYf6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4059
X-TM-AS-ERS: 104.47.5.52-0.0.0.0
X-TMASE-Version: StarCloud-1.3-8.8.1001-26856.006
X-TMASE-Result: 10--19.108200-4.000000
X-TMASE-MatchedRID: vbSD0OnL8/IMek0ClnpVp/HkpkyUphL9O8fk7n+zHAzXFJ7W3lIp49o0
        qNbNhZKlVcLzvvAcZUct/x9i2Zd5RgzkIbwJgE/FEzEoOqAAVLNNLPQl0QAltP4DDXoaCqk7ilJ
        mlF8p4QfplHhcW5EzjMvY6bQdecIl4FG4Cyz4VuYReM8i8p3vgEyQ5fRSh265TPm/MsQarwPU5x
        sKpwPfyQpCfWsX3u4oF6dov8Gg2zrxlOJuQNHlfRFbgtHjUWLywqZ0OS45Py5i2IuOMF2AXLnGE
        on+x/FhqCtC/8fgyE3r23emh+znp49+HWzUuQkw93bduyx/IZw0YL9SJPufX+QuInKvLeQ3MuTw
        baqEJZN8WT1PvdHHDFl5gHXJcVkKeghDV/oDeqp+yskgwrfsC30tCKdnhB58vqq8s2MNhPCy5/t
        FZu9S3Ku6xVHLhqfx33fj+sMArfMaMUyeC0staJwDp1OIv3zjQ/yXhuru+WsNTS/FFYL+sdvPwi
        a2JVHPJpUV89uZZ78+FfDc5UEa8Q==
X-TMASE-XGENCLOUD: 0d05273e-c75c-4aaf-8da1-b725fce82a95-0-0-200-0
X-TM-Deliver-Signature: 7C6EE04E4EF2FE8DC664CD3501162682
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
        s=TM-DKIM-20210503141657; t=1650965055;
        bh=SwOBDTwwNhfKbjVqKss7bfRJmrW2G3ePdxmtV9hFJcg=; l=2427;
        h=Date:To:From;
        b=B4vyy3NTDBMiHAgmu0PMIaO993dXM9TITrzEVbfWNm+M5etRk0CL8aD4FuNVakn1d
         XUAgp9UQ2xiSYR4cebI9BXJLF7osh2MH+9o5apXFHlJwv4X2sMqCLXtHX6W7F8sfn6
         eBBb/p28hx/lo9RDf+qlJgfrFIG5eKOpYmE/pg6/BWK2S1oNseWSwaFaEszSh9xJ2X
         jsFx7MfoA2ISRouD5OiZwS4MFaiRJPSy1B2wrHj030dMrMROqnmULQK4pNkhRg4PBU
         93rmbXl1KAj2jT/rjPYTG0IPVTuvRKQMOjoJqKo9qg1/5FkObbbdLG1rlFVqpgu37X
         u/qOOd9Ntky3Q==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Marcel,

On 4/22/2022 12:20 PM, Marcel Holtmann wrote:
> Hi Vasyl,
> 
>> This is needed for user-space to ensure that HCI init scheduled from
>> hci_register_dev is completed.
>>
>> Function hci_register_dev queues power_on workqueue which will run
>> hci_power_on > hci_dev_do_open. Function hci_dev_do_open sets HCI_INIT
>> for some time.
>>
>> It is not allowed to bind to HCI socket user channel when HCI_INIT is
>> set. As result, bind might fail when user-space program is run early
>> enough during boot.
>>
>> Now, user-space program can first issue HCIDEVUP ioctl to ensure HCI
>> init scheduled at hci_register_dev was completed.
>>
>> Signed-off-by: Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
>> ---
>> net/bluetooth/hci_sock.c | 4 +---
>> 1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
>> index 33b3c0ffc339..c98de809f856 100644
>> --- a/net/bluetooth/hci_sock.c
>> +++ b/net/bluetooth/hci_sock.c
>> @@ -1194,9 +1194,7 @@ static int hci_sock_bind(struct socket *sock, struct sockaddr *addr,
>>
>> 		if (test_bit(HCI_INIT, &hdev->flags) ||
>> 		    hci_dev_test_flag(hdev, HCI_SETUP) ||
>> -		    hci_dev_test_flag(hdev, HCI_CONFIG) ||
>> -		    (!hci_dev_test_flag(hdev, HCI_AUTO_OFF) &&
>> -		     test_bit(HCI_UP, &hdev->flags))) {
>> +		    hci_dev_test_flag(hdev, HCI_CONFIG)) {
>> 			err = -EBUSY;
>> 			hci_dev_put(hdev);
>> 			goto done;
> 
> I am not following the reasoning here. It is true that the device has to run init before you can do something with it. From mgmt interface your device will only be announced when it is really ready.

Sorry, I am not familiar with mgmt interface. I obtain device using 
HCIGETDEVLIST.

BTW. I have pushed related patch [1]. Comparing to this patch, [1] is 
less intrusive since it does not effect user-space semantics.

Patch [1] allows to ensure that device is not in HCI_INIT state by running

     hciconfig hci0 down

This will either wait for HCI_INIT complete and then powers HCI down, or 
cancels pending power_on.

If we apply [1], we can still consider an optimization to allow binding 
during HCI_INIT since this optimization will allow me to ommit extra

     hciconfig hci0 down

[1]: 
https://lore.kernel.org/linux-bluetooth/20220426081823.21557-1-vasyl.vavrychuk@opensynergy.com/T/#u

Kind regards,
Vasyl
