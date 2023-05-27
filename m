Return-Path: <netdev+bounces-5904-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 681407134FF
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 15:28:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 110522816AA
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 13:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E981F11CB2;
	Sat, 27 May 2023 13:28:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D5611CA7
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 13:28:52 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2123.outbound.protection.outlook.com [40.107.92.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A6F1A8
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 06:28:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTt7Epjyn4Ra3U9QMORhayb40LOtnu2Y2Pm0ZvC6Y39PKLZpfhcKwZPydrOu6mbWByIB3UErTYyMhHmCSP+FQ2zZdIiO4WJ7dsRq0neOk6pZJ3cKosDxOVjEgHdGiOrsE6hTCfiVa/daqcttQrke/gnTjXQeFTO+j2w172CrwQTV+lR1JTJN0Ol5xpzTelLMGbWGNUkmqSp5jn1A5IP1n0vIZvfNjIcUVUm/UF+MC6CLPQ6z5OlkV9M7Z1CrutxVMPO6cTZuo7FyyFIT7Ot1yrdJuLtvKUXZN/3blzu7qmUvJuOS9RvLAPr+Wa1rMeLWNJdq4DEDC4oon2R9Oz586w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RFcA6hgXltcwg4lwqZeQumOZG6kPY0tdjbrwOeGH2yI=;
 b=k5+1efPUhjbcA4tv5tyfx/p0NL9T87N2Ohk5TgNeeaQWomsPxUNxAU5jhCBdjZNkDVt2oigGU2lfiLgMTOkaxJvTrST+hNWzi+IxBytSmPHEpwxUHwUHxQ36MTEBpaASKqPw+X0BVFlSVv4qZoajPGYSMJQbECH7MYmpyAQPEYS+LIWdWAQw9KzOMmECqHKTn3NxB7M9hlDevGO0JR/+Y8GRxuXvGL/Q1ePTuN4PA/A8I1/wNAzK6RfPQGs9iP+vzUrET6Fl8PcZ8i9JJb9PR83lDRXQMAjbtEYMJowywheWb9uhv/wKSopwVK2HsCdwXyVsuPkk5i96U6etRmuvIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RFcA6hgXltcwg4lwqZeQumOZG6kPY0tdjbrwOeGH2yI=;
 b=F9nZgdVTtDDMV5xbxmVMgitrUUEGGW7/2pmOZ+iND+KEXKSpaYdJUbBH3leed141gAsCt2QNSWwbeAf0o5zeY9wGC3pRLE2DYrwN3MwgXnlQaNdNVjJHIwcRglKlL4p7l0wf9HNiZ+HRnoD0u30qYLfjPCAHglWOdskOSonRd54=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5472.namprd13.prod.outlook.com (2603:10b6:510:12b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.16; Sat, 27 May
 2023 13:28:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.018; Sat, 27 May 2023
 13:28:39 +0000
Date: Sat, 27 May 2023 15:28:33 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Michal Smulski <msmulski2@gmail.com>
Cc: andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
	netdev@vger.kernel.org, Michal Smulski <michal.smulski@ooma.com>
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: implement USXGMII mode for
 mv88e6393x
Message-ID: <ZHIFgcxgh2quGxZj@corigine.com>
References: <20230527002144.8109-1-michal.smulski@ooma.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230527002144.8109-1-michal.smulski@ooma.com>
X-ClientProxiedBy: AS4P191CA0017.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5472:EE_
X-MS-Office365-Filtering-Correlation-Id: 3857add1-0b8f-43bc-c9c1-08db5eb64852
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gu8TRvXxKHhIfjcuFFzrtoFvHTvsIH5KEog9MIjVpf50huFizlVkE57I0pWOMI9bywyNsFiswHjmgnGDtJIKLpXrH3aeraRU0vUumu+JpbDnTvGGd/B9JAgC5wQEHnhn11z0vraTF2tES+rKZAcMiXDeXb8pNLmJ9fsrNFAUGOyV6oMJwvxqF2HPFcrdq83JwUCB4R9JDtacrjTXgR9zDGm5iC+Jw04XnpZHxd6VXaUnLF5ivKz9B+93C+GVIgbuu0MnoVb4ge5lbU3SZc/nMalxMqK/v+0q3jCPIXtTsCw/uW+pubWZnUDsYtfDAKr7FzimqI2z/37WUv3EMSA+sV6zKgSwOTsQHY7FiHus7R9EqlWVI/VLwsSrNXne1us46vzaZQi37bGg80txK/UCeagnBHyMnA3yUAq0zNARIqTh+Mdb4lpnWmdRy1vcFNlOpH8Sn1qtfbx3JenWmdLFmS9D2qs3h7wS571wyggM30LYkiRwQMOxHkBc9R+mWGoNknE7oD4qgJs0ElHJOoEUq2/a4b0oqWfO7PUhqQrpBRqwi2N2b4mxMNW5/fRyfV1pJbc8EpX17gYwyBokKTbZNrlVmwA0RmlT+0XuFLf4vYv7zqiff5AM+VvOydxPrC1TQ19WBwXAHqm5y6isCagSlsuYY4ZuvFH/RC+GOq/9x6I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(346002)(136003)(396003)(366004)(376002)(451199021)(36756003)(86362001)(66556008)(6916009)(316002)(4326008)(478600001)(66946007)(66476007)(6486002)(44832011)(41300700001)(8936002)(8676002)(2906002)(4744005)(38100700002)(186003)(6512007)(6506007)(2616005)(5660300002)(6666004)(138113003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NUtyQmdEYUF1ZUtoWkNLZ0VLaFVrdU1MYVJmMmlFSXJnQ2FPb3hITGpjdEE1?=
 =?utf-8?B?Z3pmbG5jUkE3d0RuVExhSlNJS281dW9UeDVMRW1nOFE1TlBWenBXdTlFOXEw?=
 =?utf-8?B?cERuOGpCNjZOTHV2azdjZnZpd3FLRWxKUXpxWFVRUFJleFo4WFRReG1ldlcr?=
 =?utf-8?B?ZDFRL0dGVlpmbWd1QlcvRE9ONDJPbUVGOTRMQTFid0NPNEJwUXl3cGtjTXN0?=
 =?utf-8?B?UFQzRytEdXROQ3dJeXIzZ0F3WC9sbUl4NTkvZlRBaThHTmxCdCtQeUpMWmN0?=
 =?utf-8?B?U0ZLTzFFOU1kSmEvNDFaWkFOS2kvNnNBNnM1QmRDUlR1VXhrRzdjVTd3RjBI?=
 =?utf-8?B?T0tPczluQWMxdjVLKzRnMWR6ZVZxS0NZWmR1VDF0RW1VeHpvWmNvUjkrY2dO?=
 =?utf-8?B?M3hWWjBBQkZJOGQ5V2R5VGZ3ekFNdnJQaUNHeGJERE1uSHZMTXZEMEgvZXRv?=
 =?utf-8?B?N2ZhMUdkWVpsVDg4VmFjQXZZdHkzdXF4Z3RiMnpWbkxoN3QvVituVkdpbllY?=
 =?utf-8?B?RlN3VHBJT0NvQmpNMHl1cVRuaGw4dDA0TDRtcWl0YmdFSHlNQ3JnMWowbm5m?=
 =?utf-8?B?Y1ZHa2MxTnE0cGVjdXJHNXZMYm5QOFZ0eVlFYUZUWWhhYjVrakl4aTUrTzAz?=
 =?utf-8?B?ZTVoR3JXeFdYdGh0V2F5VkNsZ1FSNW9SODNFWDl6ZVlTbFo1T2pMQXNQNW5z?=
 =?utf-8?B?Ui90a1NFbjBGQ05FaGVIeTYxUDQ3NTdkdUdXaFEwaEJqQlZMYlQrYzlXQ3gx?=
 =?utf-8?B?OGNocXVaSWZVM0pmOERUUWtwOWE3clRmNGxaT2RDSUlxeGNSaG5BZjZsdE5G?=
 =?utf-8?B?U0xMN3g1WDlmU0h0bkdqWUJiY3Fodmd1YUg2L0R0WVJaSGxXNGdKOW0xRGlx?=
 =?utf-8?B?bmR5ZFQzblJ1ZjhESWtRdmE4SHVQTlU1MkFMcnZzNTVCNXdpQXQ1S3JESEww?=
 =?utf-8?B?Rm1Yb2Npdm5ZMEZIeUh1YjNoK2JUTTBRczlRL3d0dEVHMVQxV08xcncwS0Fy?=
 =?utf-8?B?QjZxNWJjd2V3Qmd6UzlnQnc3K0plUDVORmczNVA4VEx0SjhiK0syRWFyRUhk?=
 =?utf-8?B?dVhYY3BYY256QVpkeEtCOVRPSVlueTRQbVVwS3RiZlZMc3UybGluNjU4eGhY?=
 =?utf-8?B?QlZOUEVZbk1FNVJpUGJQMlE3Tm5mMW10ejZob3hPK1UrKzVlcWpxUTg3cm5H?=
 =?utf-8?B?YmNlUUVnTVVtR21KZjBIRk1Oamtka3J1SnNBVDJOeWFENW94WUJLZXFDbVNF?=
 =?utf-8?B?WkxMWDF0dTY2dFlzSm93VW1jSU9oNlAxallnbGxYOU9TKzZUUmVBSmV5WXFB?=
 =?utf-8?B?OVZXNWJZZEhUekl6RnRkYXVvNXFYQlBzVmhLSlBFSWJ3dnkyRWYrQ3VUTjk0?=
 =?utf-8?B?M0Z1ejNCT0JnaHhWb2x5NU1FRm4rUVJDT3lPUEpzeWVGRlBTWFZwUkZ3dENU?=
 =?utf-8?B?VktCa2FGaHl6amhrd1VCKzFSWkZIYmZycHFhSXdaVlJDRXFubWNUNzRvRHNi?=
 =?utf-8?B?ZDNqYmVFTkN5ZHUwQ0lHbmxHSHIxREwyc3V2L2drelZKb01RVVlLSktoR1k4?=
 =?utf-8?B?ZGkxNVc3U2lkUnVzc2JIMnp2QXZwM0M0MktjZ1JWcnRLSkVjNmxYeXp6VmV5?=
 =?utf-8?B?NFNkckVWV2F4dlMzSFk1R1lkZlZQM0ViTVVOeWZnNnlhTWcyZ01aZnlUWkVT?=
 =?utf-8?B?aWYvT25MNDdtd1VRbFJOLzYva2R3RVJ6eU5BOVp3S3krRFRLc2tYUXNJdEhT?=
 =?utf-8?B?Q1RwYzM0WUpFbWdZV0praVdoUWNDb1hORmo3QWpxTnh4RUZ6OTlQLzlzK3Ri?=
 =?utf-8?B?UmIwTVhIQ2pIWkdLWFRTbDNucTJvNWtuMW1Fa0dDRTNuK1RUaXhlWUhqd0py?=
 =?utf-8?B?OUJwQzNyMUdpQWpFajY1SkZraUd2Z0FmaWRPd016NnV2MWdVc1hUU2hnVzNn?=
 =?utf-8?B?b1Y3dzZzV2g5MGlJUjRYbmdUSG42YVY2Nktrc1hQNHFYM0l0Nlhkek9jcWF5?=
 =?utf-8?B?U3d3Q2orV0o5V05Gc3lGNW5yei9rK3NKNHlOZnhvdzhjaURJRkZiMHV3OE9C?=
 =?utf-8?B?OWFWNmV2LzdEeCtOWWl1dnlWOEZnL0hteG5CWHJRNnZrem82Z3BVVWN6Ui95?=
 =?utf-8?B?MnhtVklWcHZPRm9FMVVVMmdsVU8wQTVrVHZHUktvOVRZTWJLMFdacEY3c2tU?=
 =?utf-8?B?MTliRWsvQmloV3ZEQktXV3ZXaWdMSHlDRm9zS3ZBbUtGd2hHNjR5dlIxRDda?=
 =?utf-8?B?UGJlMCt1R3FCeWNFNENtRFlxY1RRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3857add1-0b8f-43bc-c9c1-08db5eb64852
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2023 13:28:39.4752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qnjVOTRQ4Y8SHTC/NrxEzusS/MTo6nqs6zFM58FOJFiH+0Tt98+AeD3AGZqJn0zcTTl9elA6x/+MnV+WjCcZsigUAdGhRIas757UP0YzaCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5472
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 05:21:44PM -0700, Michal Smulski wrote:
> Enable USXGMII mode for mv88e6393x chips. Tested on Marvell 88E6191X.
> 
> Signed-off-by: Michal Smulski <michal.smulski@ooma.com>

...

> @@ -1477,7 +1481,8 @@ static int mv88e6393x_serdes_erratum_5_2(struct mv88e6xxx_chip *chip, int lane,
>  	 * to SERDES operating in 10G mode. These registers only apply to 10G
>  	 * operation and have no effect on other speeds.
>  	 */
> -	if (cmode != MV88E6393X_PORT_STS_CMODE_10GBASER)
> +	if (cmode != MV88E6393X_PORT_STS_CMODE_10GBASER ||
> +	    cmode != MV88E6393X_PORT_STS_CMODE_USXGMII)

Perhaps naïvely, this seems like it will always be true.
Should it be:

	if (cmode != MV88E6393X_PORT_STS_CMODE_10GBASER &&
	    cmode != MV88E6393X_PORT_STS_CMODE_USXGMII)

