Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBEF31CFFA
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 19:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhBPSNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 13:13:35 -0500
Received: from mail-eopbgr1400135.outbound.protection.outlook.com ([40.107.140.135]:22972
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229744AbhBPSNb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 13:13:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wu3Do922MFu5DAiwu8lmSw+s9ip5z2x8fMuzO8hAPtoHi2CruR5LrKZGdzu7IKEbajrEJuj+Uz8S0CfUhIugvRv3uagAVm3Ext4UJixSfb6CGxmK0JWa0qNRyVAbTMHlWgQYEZdkLkCZFmRRGzputozqKQs4Aa328uu55olOqweEpGxEXaofIYB4/eKjXb43xj3PfTcFybFhJg+b9vhc+Uz1zMAVT5jSzp1B0eKD7qPhb2SYnyUnPoVKpSTDIl1maK+PYvaEmdTpXJM/j0eFTeOeEAgDeNL7kndmdMEkVLak4e/mW7vqfIydafVeuj9Gpr4+hpUUDSWPUMQi4BpNGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lfdo4EXUWsvfeK7RC5XlTcLQIFcIew9/P9ll2yjt/58=;
 b=bVcEFfL0UJtPE6Bxg9g6V/qVZuBRbvVcUJzRF64D35a9idtGvLCwh49d6lUa0pN6ukL7GmO8HF/2eiVS+zzqbFn2VP+QBEDuJxExDWgFOHzKj5ljoRUjPFR0MAfXgPCPilcOlEv4J8aLW3AboJiiRjluZ4KAbQd2hkzprFkfPrPdJv1nRwygT5sH3TPjRwIT4M142Gx6Qb7UzTTtUBzWk5lZbZPbOBmHj2grvFIpcTwdydP/anXH+8DXl5JjfvNJkqNZ+e8KZ66ALO3dbd/jt8q+8P0hdIk0HxnW4pZIlUGgcRcVG5gwTlmoDoiFF0ULmxiap0gMCiji8pnIwrES+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lfdo4EXUWsvfeK7RC5XlTcLQIFcIew9/P9ll2yjt/58=;
 b=apfoNNK31SpZha7G2l5S0TH94zsFiW8AnQpJTq5q5rNAvBMU95nPofdR2Tn2/SL2TIBaqyDd2LI20RIJq+m8bbZ4H/Eu2D4rOfrJgeac4lo/phufm8KzU04P/ex/agiOqIxHSYJoaWGFg92iML+StrCzJU2AjVVJA0toTuz+fGs=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=renesas.com;
Received: from OSAPR01MB5137.jpnprd01.prod.outlook.com (2603:1096:604:6d::17)
 by OSAPR01MB4259.jpnprd01.prod.outlook.com (2603:1096:604:59::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Tue, 16 Feb
 2021 18:12:42 +0000
Received: from OSAPR01MB5137.jpnprd01.prod.outlook.com
 ([fe80::d46f:1a71:68ad:42a4]) by OSAPR01MB5137.jpnprd01.prod.outlook.com
 ([fe80::d46f:1a71:68ad:42a4%7]) with mapi id 15.20.3846.030; Tue, 16 Feb 2021
 18:12:42 +0000
Date:   Tue, 16 Feb 2021 13:12:29 -0500
From:   Vincent Cheng <vincent.cheng.xh@renesas.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/3] ptp: ptp_clockmatrix: Add
 wait_for_sys_apll_dpll_lock.
Message-ID: <20210216181226.GA5450@renesas.com>
References: <1613192766-14010-1-git-send-email-vincent.cheng.xh@renesas.com>
 <1613192766-14010-2-git-send-email-vincent.cheng.xh@renesas.com>
 <20210215114822.4f698920@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210215114822.4f698920@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Originating-IP: [173.195.53.163]
X-ClientProxiedBy: BN6PR22CA0040.namprd22.prod.outlook.com
 (2603:10b6:404:37::26) To OSAPR01MB5137.jpnprd01.prod.outlook.com
 (2603:1096:604:6d::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from renesas.com (173.195.53.163) by BN6PR22CA0040.namprd22.prod.outlook.com (2603:10b6:404:37::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Tue, 16 Feb 2021 18:12:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 14ba234c-bcb7-4388-c7d9-08d8d2a6736c
X-MS-TrafficTypeDiagnostic: OSAPR01MB4259:
X-Microsoft-Antispam-PRVS: <OSAPR01MB42596B2ABCA3813145D56D73D2879@OSAPR01MB4259.jpnprd01.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vDe+jI6af7k9IC0PxSuft2BFEwz43tO66aNbzI/7c/u4yqG0MfwvRG4QI3g9XVemap6FOjbSzvmkURgGvq0yqSvXxSHqxIPrubhl6rRBhYgnJEXttofueXhkS1klvClobjFFRhF/mPxqqTHWp7aPFWGpBbHxJSApj7NoB5ErsDfWNah7jA/WjmD3QJpjLlZIBSqzL5J/+blMmwf36iAAx/VPEzLOP4pW/zTGEAsd0HLWhd0Yofadf10pNTY2wjDydgUTjn6OnBS1ww1/JFzJ95aR5en6UxSpNVsIcwVExLabDo/3LqRDxWO8RRs9yR2J/cMpO6sGebCHzcBIjanEblz9GuPEn9uUBen0F/eqCH/B6IThK1JMzMzAyb2NepXCOPACgv9Qag+WdHw2PKy4SJtfAIWQamT6TrRd+DtNgth9p3JXgI8PuJ3QeZETNEvK9raM97t8+0k3o5xVh8wQnm4C0Hx+gSzJHEEfosojua7ZDh+xzB//JsPgpICIXKz4tGcAWM0tkk58eXYdww3cdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB5137.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(16526019)(2616005)(33656002)(7696005)(36756003)(6666004)(8886007)(6916009)(1076003)(956004)(26005)(55016002)(66556008)(5660300002)(66476007)(86362001)(2906002)(8936002)(316002)(8676002)(478600001)(186003)(52116002)(83380400001)(66946007)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?a1dYemhQVjVnMTRGVU1VbUhMV3grdTRQUHpWV0JUa1JFZDBUWHY5TGUwRThB?=
 =?utf-8?B?bG4xaXNnelFhSDhoZHdaTElRUHNScWxuZlg4d09PY0s5UTlISFJ6OVlzWTV4?=
 =?utf-8?B?RjZKangvMEpiTTdSL2ZIZGd3UWszQ01MSlNiR0ZaOVVXNkRqd0x5QWRqSXQz?=
 =?utf-8?B?QytqeTVWUHg3eVRFaVQzbVNSS1hyZlZQNmFZeWxwRzJSa2ZPOHYzMjhieWZZ?=
 =?utf-8?B?YWdQTWdaczFKZG9Ic3NCeVpmeFpPcWNLRHFNbUdvVlhHUFNkOUhFNmhUQ0xS?=
 =?utf-8?B?djBJUDJUVXoyZ09Gb3laNmdNMjF3U3oyZGpBRjRJLzJrTDFSb3lEZFFtT1pl?=
 =?utf-8?B?V0dNMmg0cGtrMWtLVllTeG1KbVM2Z3ZKOW04dUhXWmJUVjF3RXNUQzlCbExF?=
 =?utf-8?B?ZHp5VVVuRmpUQmhoNU9LUkhhUXlKN2FMTEJ2OWM1cGZhQWkrVHp0U01DTVpi?=
 =?utf-8?B?cVZQcGdza1BZalBqUTlwUG5HM3cyWVFIN0VKUTZ5bkFMaEo0eUo2WVU1bEUy?=
 =?utf-8?B?aFBHTnVoTnZLZkk4Zlp0dG9aN2h3ZVJiUlVpWTErQVFMcUtRd2pFUDcyY3ZT?=
 =?utf-8?B?eHJ4WkJSYUNTWVdYN2NSd0NKT0ZkZlZER0ZyLzN1bUVVRzNqV1JuQUNBZ2NZ?=
 =?utf-8?B?NFpsbW1yR01ka3UrR3daRFJtTlAySzJvMDBHek8zV2VOcG1RUkxaVVlHem1x?=
 =?utf-8?B?US92Z1JzV0Zrc1ByRXYyVXlCWjNEVGdqUVpSQnBRUnFlbVlTZGs5YThET1du?=
 =?utf-8?B?S1hvR09TL2hPRHlocWhJcE1VbWFZUlhnR1NhdTVaYUNOWUtTcGhZY1F3Mkdp?=
 =?utf-8?B?eEl6VGxqRHFZN2xwMkgyTlRCUy85YWxEeUE3eElUSUVnczh4TjlPN1JJb0N4?=
 =?utf-8?B?REVEaDRHcHRvMkdVeGVjSWF4VE9mWnJ4RTJBQ3dHbktybGt1VE84UEF6WFov?=
 =?utf-8?B?RVk5VFdXenZFZHdRQ090RFl3N3BZSytadko0cEtNSXlOc1BENDRlUkx3ZHQw?=
 =?utf-8?B?S1ROdUZSOFpLbVczdzE2VVlIeCt1NTQvZVZiTlBzYWhYMXhsVytLZ3Rqck1y?=
 =?utf-8?B?bS9yVS90WDY5SXViT29NOG1OM1hMb1czVkNGL2NzRERRa21Gc1IxcVlwUGhT?=
 =?utf-8?B?VG5rcC9aRERpOUxBL3NvNGl4N2k5RnFURTE4OXRQK0FQRmh5ZVhuZlovSkJV?=
 =?utf-8?B?YjVEQzdXM1Vpc2d4MUxZWE84NlJQV0VGdmtvSEpyM0xMN0ZQdjRydU9MaWNM?=
 =?utf-8?B?a3dKMWc3azlqUHViN2JwY3VLMUxxaXB6WVUvTEdPVm84eDRPb1pZYm5LT3F3?=
 =?utf-8?B?a2MwVVNCN3gxYngwQkhtRGR0NlBKcjIwb3RtaEw5T240bmtqTkovOEx5WU1i?=
 =?utf-8?B?eU9JcVhyZ0lRNlYyaTVDN0NUWW1HTW4yMlhkTWZlNWtQaHNIQ2xkZVVtMnBy?=
 =?utf-8?B?ZHVOVWRGS1NWYmtVOFd4UG1KOE9hY2RqZVRxVXU3NzNTSytGVFhCZm9EVDhw?=
 =?utf-8?B?elVKUE14YmxtMWhuVFhXVVBBcFN2OUNaZk1HN1A1MVp2YnAxaldtd0dEbmt6?=
 =?utf-8?B?aks2YktVRVAvbUZSZzJaT2pDNmRVVk91ZzFrdEozbWVkRTlITVdpakhpZUtz?=
 =?utf-8?B?Z05lOGI5cGw4WW01SldnTDZQOGN2YUlGNXFEQWExYkZERmZSMUE2RjdLMS9h?=
 =?utf-8?B?bW9TODBMY0JkQzk2bGxRbHlTem1Fai9LeDk1SXhLWlRVenpGcVJQcVhBU1Fo?=
 =?utf-8?Q?EEWFXHP+tNmU/fwPchG9ozSicH2pqEz9IjBfEpX?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14ba234c-bcb7-4388-c7d9-08d8d2a6736c
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB5137.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2021 18:12:42.1654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gINa4KgBu/oAh9+OdyTfrAICsGzamEO2Umg5dow0TZA9Py5em+qwOrZFbTEL8+u7PLYzDQnXUzi4sp3ie3tIk3L1Yyz4qR9mv2I6nwvbHwA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB4259
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 02:48:22PM EST, Jakub Kicinski wrote:
>On Sat, 13 Feb 2021 00:06:04 -0500 vincent.cheng.xh@renesas.com wrote:

>> +static int read_sys_apll_status(struct idtcm *idtcm, u8 *status)
>> +{
>> +	int err;
>> +
>> +	err = idtcm_read(idtcm, STATUS, DPLL_SYS_APLL_STATUS, status,
>> +			 sizeof(u8));
>> +	return err;
>
>Please remove the unnecessary 'err' variable:

Yes, fixed in v3 patch.

>	return idtcm_read(..
>
>There are bots scanning the tree for such code simplifications, 
>better to get this right from the start than deal with flood of 
>simplifications patches.

Totally, agree.  Thanks.

>> +{
>> +	int err;
>> +
>> +	err = idtcm_read(idtcm, STATUS, DPLL_SYS_STATUS, status, sizeof(u8));
>> +
>> +	return err;
>
>same here

Fixed in v3 patch.

>
>> +}
>> +
>> +static int wait_for_sys_apll_dpll_lock(struct idtcm *idtcm)
>> +{
>> +	const char *fmt = "%d ms SYS lock timeout: APLL Loss Lock %d  DPLL state %d";
>> +	u8 i = LOCK_TIMEOUT_MS / LOCK_POLL_INTERVAL_MS;
>
>Using msleep() and loops is quite inaccurate. I'd recommend you switch
>to:
>
>	unsigned long timeout = jiffies + msecs_to_jiffies(LOCK_TIMEOUT_MS);
>
>And then use:
>
>	while (time_is_after_jiffies(timeout))
>

To clarify, the suggestion is to use jiffies for accuracy, but
the msleep(LOCK_POLL_INTERVAL_MS) remains to prevent the do-while
loop from becoming a busy-wait loop.

#define LOCK_TIMEOUT_MS			(2000)
#define LOCK_POLL_INTERVAL_MS		(10)

unsigned long timeout = jiffies + msecs_to_jiffies(LOCK_TIMEOUT_MS);

do {
	...
        /*refresh 'locked' variable */
	if (locked)
		return 0;
	
	msleep(LOCK_POLL_INTERVAL_MS);

} while (time_is_after_jiffies(timeout));


>For the condition.
>
>> +	u8 apll = 0;
>> +	u8 dpll = 0;
>> +
>> +	int err;
>
>No empty lines between variables, please.

Yes, will fix in v3 patch.

>> +
>> +	do {
>> +		err = read_sys_apll_status(idtcm, &apll);
>> +
>
>No empty lines between call and the if, please.

Okay, will fix in v3 patch.

>> +		dpll &= DPLL_SYS_STATE_MASK;
>> +
>> +		if ((apll == SYS_APLL_LOSS_LOCK_LIVE_LOCKED)
>
>parenthesis around a == b are unnecessary.

Yes, will fix in v3 patch.


>> +		} else if ((dpll == DPLL_STATE_FREERUN) ||
>> +			   (dpll == DPLL_STATE_HOLDOVER) ||
>> +			   (dpll == DPLL_STATE_OPEN_LOOP)) {
>
>same here.

Ditto.

>
>> +			dev_warn(&idtcm->client->dev,
>> +				"No wait state: DPLL_SYS_STATE %d", dpll);
>
>It looks like other prints in this function use \n at the end of the
>lines, should we keep it consistent?

Looks like the \n is not needed for dev_warn.  Will remove \n 
of existing messages for consistency.

>
>> +			return -EPERM;
>> +		}
>> +
>> +		msleep(LOCK_POLL_INTERVAL_MS);
>> +		i--;
>> +
>
>unnecessary empty line

Yes, will fix in v3 patch.

>> +	dev_warn(&idtcm->client->dev, fmt, LOCK_TIMEOUT_MS, apll, dpll);
>
>I'd recommend leaving the format in place, that way static code
>checkers can validate the arguments.

Good point.  The fmt was used to keep 80 column rule.
But now that 100 column rule is in place, the fmt
workaround is not needed anymore.  Will fix in v3 patch.

>> +static void wait_for_chip_ready(struct idtcm *idtcm)
>> +{
>> +	if (wait_for_boot_status_ready(idtcm))
>> +		dev_warn(&idtcm->client->dev, "BOOT_STATUS != 0xA0");
>
>no new line?

Nope.  Tried an experiment and \n is not neeeded.

	dev_warn(&idtcm->client->dev, "debug: has \\n at end\n");
	dev_warn(&idtcm->client->dev, "debug: does not have \\n at end");
	dev_warn(&idtcm->client->dev, "debug: has \\n\\n at end\n\n");
	dev_warn(&idtcm->client->dev, "debug: hello");
	dev_warn(&idtcm->client->dev, "debug: world");

[   99.069100] idtcm 15-005b: debug: has \n at end
[   99.073623] idtcm 15-005b: debug: does not have \n at end
[   99.079017] idtcm 15-005b: debug: has \n\n at end
[   99.079017]
[   99.085194] idtcm 15-005b: debug: hello
[   99.089025] idtcm 15-005b: debug: world

>> +
>> +	if (wait_for_sys_apll_dpll_lock(idtcm))
>> +		dev_warn(&idtcm->client->dev,
>> +			 "Continuing while SYS APLL/DPLL is not locked");
>
>And here.

\n not needed.

Thank-you for the comments, helps make cleaner code.

Vincent
