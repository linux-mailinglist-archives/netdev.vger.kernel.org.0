Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87FDE6424AF
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 09:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbiLEIf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 03:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbiLEIfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 03:35:55 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2086.outbound.protection.outlook.com [40.107.21.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC96F5A7;
        Mon,  5 Dec 2022 00:35:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aNllKreQhGKyBQ0XXMrm5fuPsQExp1k2Pc7ZVLwvmLEkvapoSEoP0DiLZ0G/R15GU0xevWu5Mta4idwejRpbsPzbp1YP/VBIFc13k6YgS3ulQu9bOgG0INPeQS9VIDyF7jdlyo6EOEGn9Rl8z07dGOmFemI9/2sk7Z9NVPVPCP8ZaYdz8j03xmKDJ5tW67vVnFkYRU1Vo5UKf3XrpJbO/iyXCc+ceWkN9srG5i7Vh6cIo0oMH94nDLWYGEfUMeCq3QleBe/IgYB/7xvrygvYgcY3l5aklH/3gklLW11W/E70A//qcrdkd3lDusUxMB05E5HuY+q85lxW4PfY95/u5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vfJziV/CttUi/YAdzQ+bN5x/ybvCV4/v3hPh+6atuxk=;
 b=AtoV4pRJ6CtERgw0Xm+ZSxJknNHPCop5n0IH+32gcKA6Dmt0NRshqqUHjBDQN4CUBvnqPmuwzBjY6ZqFucXpqKp+kp5tjqNtVZrkm/K0rk3U/h0qHK5ye+nrikGizkfl1TUkRSv2VBHbUIJ+SL0R1NmH9vCv+mQwNyjEx+PQUOeueOlOxpDftQskblqUXN6D252PY+zKQSKHRBm5mHPvnXUkFck2hEX4LGWBk65GVdtTpL8h0AgeQ+nNv1BHv2h5EJ7QDL5uD4gBDL7L0i2rVZUQFw8EszE+vV9+/fTOFTV07qga5kP7fhlNILBV1amTZfOdwf4uVp5Z4J14dHlnVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vfJziV/CttUi/YAdzQ+bN5x/ybvCV4/v3hPh+6atuxk=;
 b=Jkdyk7lThGushMCAkndMrb5LqIpCjskFYl7xrU1F3xiOo4m7Pf5lqCvPtVcOrTUJxwNvU5jDUv/PHJY2JZFEjC+HDa42mhLpClsFR2McAiHfkFMNUypcB422vsMI1nTjypXg9xwDLHsX6Vp/IXPsCdQJB4cguF+BThrii5SlcwPCYbLTzNUjavxw/UPDYdjHe06FHxOJp7H8ERfKgP6dLf/+XMTqSYt2nIxHXWsrrYpXBwJqi72q5loUMmMVx+b6X2KVLicmbrmXrdfaR5j/y4MrWcc238Zc8bb6l9K9r3WPK3AacoJGP+RjtBM0gG3sk6F8LYqxspH8QYF3Gk6H4A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9)
 by PAXPR04MB9424.eurprd04.prod.outlook.com (2603:10a6:102:2b2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 08:35:51 +0000
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::ae59:a542:9cbc:5b3]) by VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::ae59:a542:9cbc:5b3%9]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 08:35:51 +0000
Message-ID: <9493232b-c8fa-5612-fb13-fccf58b01942@suse.com>
Date:   Mon, 5 Dec 2022 09:35:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 0/8] can: usb: remove all usb_set_intfdata(intf, NULL) in
 drivers' disconnect()
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Jungclaus <frank.jungclaus@esd.eu>, socketcan@esd.eu,
        Yasushi SHOJI <yashi@spacecubics.com>,
        =?UTF-8?Q?Stefan_M=c3=a4tje?= <stefan.maetje@esd.eu>,
        Hangyu Hua <hbh25y@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Peter Fink <pfink@christ-es.de>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        =?UTF-8?Q?Christoph_M=c3=b6hring?= <cmoehring@christ-es.de>,
        John Whittington <git@jbrengineering.co.uk>,
        Vasanth Sadhasivan <vasanth.sadhasivan@samsara.com>,
        Jimmy Assarsson <extja@kvaser.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        Sebastian Haas <haas@ems-wuensche.com>,
        Maximilian Schneider <max@schneidersoft.net>,
        Daniel Berglund <db@kvaser.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        =?UTF-8?B?UmVtaWdpdXN6IEtvxYLFgsSFdGFq?= 
        <remigiusz.kollataj@mobica.com>,
        Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        Martin Elshuber <martin.elshuber@theobroma-systems.com>,
        Philipp Tomsich <philipp.tomsich@theobroma-systems.com>,
        Bernd Krumboeck <b.krumboeck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org
References: <20221203133159.94414-1-mailhol.vincent@wanadoo.fr>
Content-Language: en-US
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20221203133159.94414-1-mailhol.vincent@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0202.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::6) To VI1PR04MB7104.eurprd04.prod.outlook.com
 (2603:10a6:800:126::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_|PAXPR04MB9424:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bbfcb66-9785-4b53-9072-08dad69bb728
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H+Uf3ScZHxIsPk5HcMZzHMyebU2xdSm/G60I+XiPGmQ7LPI5f6ueoHHTUsCxD1sk8klsV0pUDRQjYQZz6GdujvekqdAkuUWqL9Ia0aK9BfxnQLmE2Izp/0a9Wuh/BV3R/Ow0jTRKX4UY3Yuqhj7mITNITheCH0XV1AN6u/3Qk9C0E29TG3cpv7p5Wa7W20avQLuxOUoywuCUCdBRU3JPX9nfItomm1H32nmbSTTV/WUD6gXhkSNp2Vww58J9rU0OURJtMbMaTNc6/BLyG4+rgsZ0ddaEdeAykh6e2LZqOpKsABYkSJFOFdq1WGX7nqZAUaX6JeQljuVityUJUSEuGu9HD8cFqVWpGldVrQgrCe70w2S9LaXNMtT4XSor9UQ/AmZw/6vXpW/flDziyhEX/LvTkEliFlPzv4fgQT7i8JebjjYFkFYMUbItuy6P2EjuY1V6GaHdjyB8ec1u3912vKTWmhH1wKwHn4mD3ksbKiio0WI1QNVUpW/pAPsXskrFzAZOnabPXpVOMT4xXtQKQsmcjGOHztevTKE3RV0vdS/gKVTc2yz8PpmlhiX5Nd9e36KMmD93OtqGXxCzPSP6vz14ruWOoHBqGlFHFnmtbnUDZ3XcEDdJt3ArmHnyRUZw9hguHmdZCS3ZpJFrWsmMQBLumdEzkHeG2jIdIr77wTfMs63BAl7rA3exKie6rIvhuttB4YA6MSK3RGijeOwVbxARjEPJifLOUmvxKh2EFss=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB7104.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(39860400002)(366004)(451199015)(2906002)(7416002)(7406005)(8936002)(38100700002)(31686004)(66946007)(66476007)(66556008)(83380400001)(8676002)(4326008)(36756003)(86362001)(186003)(2616005)(41300700001)(5660300002)(316002)(110136005)(53546011)(54906003)(6666004)(6512007)(6506007)(31696002)(6486002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkMzOW9vN1BXZFk2WXRzeTJEQ0JpZkNrbFoxU0NGYlRPRTJpc0RQdkpKdWpQ?=
 =?utf-8?B?YytWRHc0a0Q2aCtaa2NzcEFueld0NHFvdUNueEQ3anlxS0lqckh1MnZ2MGov?=
 =?utf-8?B?SGEvYS8xdmVDUjhyU0R2VVNDSGMwMlpZWmE0cWxuSDgyOWNTc3NlZktqaUd6?=
 =?utf-8?B?dkUya09GVndSRWNlT0UyclBQa0ZkV0JRUm9qK2hIZ3RSbnBza3I5eDBta1I3?=
 =?utf-8?B?VElEUU9OemxYL1pJYzV6NTFrOGlmTnQzNitaMFcwZVdDdlJrb1A0VjRNWnNi?=
 =?utf-8?B?aWpJL2sxR2pRTXJsVFNMNzdxbWZhbThBR2Z3V1lCVmIwWnhZUFZvOXFPUWJN?=
 =?utf-8?B?dzRhOUVEK0FIbG1PUDlNaHRnWTduVE9JRk1FUDcxQ3hYMjduZlcrTkxwKy96?=
 =?utf-8?B?L0lYNVlZbjgyZEZxNWVPYnU0SFlBS3pGWERlL01HVlM0eHZXdmlKMGhLaTdE?=
 =?utf-8?B?NTlzTXNEZWRFd3RDWng4bXdxaElXUjB0TU1lckNMTU84bEhIcmVmSUt1YWlv?=
 =?utf-8?B?RU1BeDFndGZ0Y1o1Yngrb0NWTzFyckROZ1dzNXhKaThnSkJ2dmNBUzRuRUoy?=
 =?utf-8?B?YmVydjVVbzMrSDBnSU5QalVndGx6SldNQU1oM3pkK2NUUGFHSk9LTnRNSG9J?=
 =?utf-8?B?RzdxY0V3dmdxQlRQelVvTDdXQWgyY0l4YWs0Qm96MVJwUjdyNTdDc3haU3BG?=
 =?utf-8?B?bEk0REgrUkxUQ1VzZFRaTUM1QVN4WTlCNU56NnRNUWxQMmVnalVOVjRJTDFB?=
 =?utf-8?B?R2swYlBhRzgwR1AyU3oyZ2VVZFVvUVAzUm5BTW9DVm5WdUJ1bk5NZkFFVWs0?=
 =?utf-8?B?WmhoelNQUk9KMWRlNm9EVU1oUGhjK0NCMGZUczNKY2QzK2JRd3RvQ3BhQXlZ?=
 =?utf-8?B?R2VSamhvREFDa2VlSzc4U3hlRVExeU5hZlltSk05MDlCaVZkZXNXd2VXbi95?=
 =?utf-8?B?N1NQWDFDVVU1d2RXNWlGblVUbkNvdFYvMEF5UzhKc09HTGFUTGZRQkdKUFcy?=
 =?utf-8?B?NThwVlZLYXJzdm1oeGNVWTBZMnlMbDFKRGlXb1RZdUVGOTNBWElKUkVqTDht?=
 =?utf-8?B?OFR2RFBqNGdMQzhTTklhQnovallmTHlXN3gzWW1EdVRuN2REL2dEOXZJb0g5?=
 =?utf-8?B?NE5zRUtGcFVQYmRpRkh5Vjh4bzMyNW9adEpxVE5SMi9NbithL1JtTkRTU1RF?=
 =?utf-8?B?REt3Mk9KcVRtMmhEQlpYRU1EcXlTZlRzUnVod0ZnTVpzaUVhU3dRWkhaQ3lK?=
 =?utf-8?B?bytsckR3aysybDFPMGs4WFRZTXF4N1QzayszS28wZlg4YktZdmh1ejBwU2pq?=
 =?utf-8?B?OHFRRklya0JmOWVQLzhWOWhEaEZkZEZtM1hvWHd1RC9OMUw2YWh3TjY4aHZP?=
 =?utf-8?B?eGhWTUlQQVByLzVYdXhKWkhRZVd1ZGxOM3QwMUc2YXJsQm81aXl4RFFrRFVv?=
 =?utf-8?B?SEtOa2d4djdPa1ptcUZGNjgrYlZiTzZvN1RiQWQwRHQ5dklrcG54U1ZqWFl4?=
 =?utf-8?B?ZEtzZnlIMWVyMDdmaUdSby9BRDFTT2NGZ2h0RlBjUmltRjdHOUpncmFKVGpq?=
 =?utf-8?B?aXZXekRxUXBDRzJQbTVFdndNdjlOSW9RZXVUcHdPRS9qZ0FHeWRHMGl6ck9h?=
 =?utf-8?B?YjNlMmxBei9rcTZtR2d3Y1Ewb1lLaHpwL1RXbVNOdjZYMGYrYXl5VldoVFZS?=
 =?utf-8?B?NFpwUEtVcVorb1dzMnMxSjY1bGxlUEJkL0doV0IxOEsvTWNEN3ZNVEo4QnJ3?=
 =?utf-8?B?SUZybUExQ0p2VFhiTi91TXYxSVNlOUZmUHBLc3hVWjZHSXhhZG9VZ1QwTHlp?=
 =?utf-8?B?aHNNSTBKSEZoeUlVV3BxbjgrdlRzWWVFOFBMTmxBdS9GRTREYUMxNyt5OWdz?=
 =?utf-8?B?Z29OVWhkWjk5RXJjcVJaZ2FIc1VNM0kwNUpycEhNT1NuVDM3QjFnT0FyK0ov?=
 =?utf-8?B?cU52Yi9hYlhTS01KWDJqejQ4Y0xxVGl6MmZSWUpOWW5iZXNLcGtlTWNSa2NP?=
 =?utf-8?B?OXU4Z09IUHpBeE9IMlgySHZVRzFxQ1FRWklHKzlqV1BRem9MV3BtaTdleFQr?=
 =?utf-8?B?a0ptVFd0VjdqSVl1eCtIWEJHSmVRdW5SMUwzbkZqaFF5WnU2a2Z3NU5pdkVC?=
 =?utf-8?B?cjFqQWppSEtZcS9CaU9ITDNpOFRDYTNuVWM5VWdCcEs0QlRnendlSXUxSEpk?=
 =?utf-8?Q?meLg2OdDZ35uc8IW2qnFLqPgJf88ZHibOFCDzQe/+LVR?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bbfcb66-9785-4b53-9072-08dad69bb728
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB7104.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 08:35:51.1103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wHM7VEvw4EC09GKV2TJb6hZj2EIxIKgGNrhPFO4tv1ZGlsr/w2EohwKOpUgZ/g0t4tGw/IVNUE2kOGrLMzdq1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9424
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03.12.22 14:31, Vincent Mailhol wrote:
> The core sets the usb_interface to NULL in [1]. Also setting it to
> NULL in usb_driver::disconnects() is at best useless, at worse risky.

Hi,

I am afraid there is a major issue with your series of patches.
The drivers you are removing this from often have a subsequent check
for the data they got from usb_get_intfdata() being NULL.

That pattern is taken from drivers like btusb or CDC-ACM, which
claim secondary interfaces disconnect() will be called a second time
for.
In addition, a driver can use setting intfdata to NULL as a flag
for disconnect() having proceeded to a point where certain things
can no longer be safely done. You need to check for that in every driver
you remove this code from and if you decide that it can safely be removed,
which is likely, then please also remove checks like this:

  	struct ems_usb *dev = usb_get_intfdata(intf);
  
	usb_set_intfdata(intf, NULL);

  	if (dev) {
  		unregister_netdev(dev->netdev);

Either it can be called a second time, then you need to leave it
as is, or the check for NULL is superfluous. But only removing setting
the pointer to NULL never makes sense.

	Regards
		Oliver

