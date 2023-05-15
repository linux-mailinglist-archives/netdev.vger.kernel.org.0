Return-Path: <netdev+bounces-2617-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 39A1A702B86
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:30:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FA9428124B
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:30:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A935C151;
	Mon, 15 May 2023 11:30:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524C81C13
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 11:30:19 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2105.outbound.protection.outlook.com [40.107.212.105])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52FEF1;
	Mon, 15 May 2023 04:30:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QPSamaWCak2nEtWz69f7Su/BHz3WzEBMk9suq+eV5xVJF/ZQaodih9gFn7LLrFVwpuYRXB7rG8o5Y7Bt8o6UdWktSlmwX82wU1eb1E/6ZCnNv4HgmBUnSHWiY/PhLejjHMC/p7jNPDMZCaYua30c9TGnrzKnJ+OAQiw5MygVWn8pcUw4JKK1hVzhDm2B7kjFT3l7zAq24UWvJIamb0B6AkvJUcgYN86v/BrPIwFPieIHLpiyQ3nTTQadOJ7Bt9KZzB4rAW7s+u5t1JbcX0PhE0cvBZOiw8GFVE/48TeF5Ng8xHX2NcL4PJj3YfisOynyz0AhCDQRbr5lJm1LJXUrIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GElICwNjFy0HiBeElMaaLExXGCwQyUgIwkQI2OIL5rs=;
 b=AEJYQ792Gj3xertpdC4dXDatOfZ+J6PIq47nd9g8enhYvLnqNoifS2jAz6s35OC5RKrSY7SkNOTUlBV34C4gppJnyvkmGq/huicFXiEgu1Uibku4Bemta43ZikPUdMKib7bocl73HqTDkJwu5PtzC0RvfLzqIViIbxDVHZIHa2ksIySaBo4LUfoG2wzd+3owQTMjDVmSC++sqiMTkpXLHv3ciFco6kHqrDa3RRvMjLonLOohsEf0GVb3koMwiVWpA0Cr8aP03hp04TRdjdFJnv2V86qx2QmCIQYx9z9ZdeWbOc2ijfVNx4ZWgAzGgDA9fEZ9XDS9aLRjfWZGqovJig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GElICwNjFy0HiBeElMaaLExXGCwQyUgIwkQI2OIL5rs=;
 b=tD7TRW5DXADVp5UuAJ4D7m18AeQRwVVZ37fBy1/Xg78gzzWiHdhqecfcBcEyQkc+S6ujqcSkHMdCQCwx0WJGQ7ng7FgCyrxRHZ44b0MGRRq0n9M+Z3egCeWDzH5W8Al0m9Pc8AuYOw+ii2a/Zq7FqE5Kg3Ahsi2oBKaNSdLdgvs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6433.namprd13.prod.outlook.com (2603:10b6:510:2f1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.14; Mon, 15 May
 2023 11:30:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 11:30:14 +0000
Date: Mon, 15 May 2023 13:30:06 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Luca Weiss <luca.weiss@fairphone.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Balakrishna Godavarthi <bgodavar@codeaurora.org>,
	Rocky Liao <rjliao@codeaurora.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
	netdev@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH RFC 2/4] Bluetooth: btqca: Add WCN3988 support
Message-ID: <ZGIXvv4hQXn+jmFS@corigine.com>
References: <20230421-fp4-bluetooth-v1-0-0430e3a7e0a2@fairphone.com>
 <20230421-fp4-bluetooth-v1-2-0430e3a7e0a2@fairphone.com>
 <ZE+6e7ZxJ2s9DHI1@corigine.com>
 <CSK97HK2XBSR.1Q5K7TUE55HH7@otso>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CSK97HK2XBSR.1Q5K7TUE55HH7@otso>
X-ClientProxiedBy: AM0PR06CA0119.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6433:EE_
X-MS-Office365-Filtering-Correlation-Id: d69ce4b9-1576-445b-4673-08db5537c02b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	aj86ON0ek+iekJmI09ZbSjklojAz1E14K+phCHDHBBYk/V+dzH7cTjg+TwT8V/5W77lVik8H+yUpVKmQa7LhebMxyPXmz9EglEaitbnYf2oOztNBAzrW8io6oMd64RtLMm/F+RWNA9HvRINsS/mhg82JzJ2+9Rtqlxap8vfcoMBLzUEaFO+MxLfhlywJSP9h7ZJYxZ/Zm3Z5B0Y3LznZ3Dw5rXHJeHvONAkAXeXSavaQHngcETrHo4nhHycB659+liPtnWkTmDmLJmQUVvpRa9jCwXrHT1BouKFtuyi2ehfOVGc7f0iF7dUGQmYF0mBI6r+bli3eWbeBHTxV5+RMmta3N+0uaMbJOhbMb7CUQQiUZ/7g3Rv+hl9zEo62jK8ORQM5V8dYxhRTvTUBHdnpOJD2xyr/eI9acVPMNsSOahT9H3lD4UCERtyXZyLhNKFSIWCNpBYbLef2VCLM8i8W/v5lS3G8pQ7Oi6GoW2Ba0h1NqHQoLft1jfsk6NOWtBNcpfwJ5h/+tJkOL70FPGegicajb9xxXzDtS0Kz7ya5umiboBpZZjqDIJhvjg5MwnTJFZlQZdbeFPHVSNO+POfdVglajuuzC3URYTlQSSgmG8eITQahYk/u8E4Ol4j3NSL20jGqvZJfzuIliwF01NDnlQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(376002)(39840400004)(366004)(451199021)(44832011)(2906002)(38100700002)(316002)(41300700001)(5660300002)(8936002)(7416002)(8676002)(36756003)(86362001)(6666004)(478600001)(6512007)(6506007)(186003)(6486002)(2616005)(66946007)(6916009)(4326008)(66556008)(66476007)(83380400001)(54906003)(87944012)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YlEnWXXSi04kMzJiAZxzYQEBItVuNcPFINROlschOXSCY4ytxX0j+Z24ugvj?=
 =?us-ascii?Q?DdkNUIYAXHOCNXpgeNqKx5hzuYzjjNhlqse/iBh3kQzzeDyfqd3nLGFgMgb1?=
 =?us-ascii?Q?TCJfNLM6PKujwgnzv74cwBSjyY3DTGvfhb0ZkjSzCBHg7u/7TsXVV8lgoVCK?=
 =?us-ascii?Q?SRJs47ruICCK+o7DWGq4z6l/7FZXwbaPKhzjd5V7mieKPfLY43zte1OM6pnZ?=
 =?us-ascii?Q?HMf7p0rPcJDDU+grrsN9eO2ITcDO7+qvI/QMTU2lVpcC/49Lb4onhd6kWx1c?=
 =?us-ascii?Q?04ie2d/kSsooRUeo2FpcJEm5RPeRNJ6s36QXD3d2JcSBN32R9bxMd6Jr+rp1?=
 =?us-ascii?Q?ugQhXWi1iAnjLpO07WY4CS0glBMLLmnbefO/wzcS2vsvLdHKhpHEffRAvLW5?=
 =?us-ascii?Q?qYa+q8Oqeem9RSE5Dm/zd43D65hIGPtp4sW9PrjfYwe5V7mR0MuWSXkAjwuc?=
 =?us-ascii?Q?MmLPWvcwQ/VyF9JxM40D0hWRhvtno0aUydNnZVv2wwhU4WGEWWV6sJq0CoCp?=
 =?us-ascii?Q?xodTW5qS4MJaU9XBwwboMHqtJDm3DEqPzF6SZFrut8E6oKLdqnniqicqHyUr?=
 =?us-ascii?Q?h8c+pWPObioC9UrP4aKYWkwyAYLneHj4IfVIsOo7ldpMZ5DE/+Sfv2WqXUbn?=
 =?us-ascii?Q?uLx92AfEJnDol3KetSz1bTxkY7RVChz3/UnEM/Y1niJ4q9xMI5Ma6ICukbN3?=
 =?us-ascii?Q?5IERiTOGRwX/LJoJ8DPvAeuTxlus3RqWpEbryyB71Pd6l2ATf9MmH9vE8vz5?=
 =?us-ascii?Q?u4aLjbmyXcAMpMM1dom5SYj4L7mMy6ctNsSbjR5FYtVK/Cosf9I/qhkuvQch?=
 =?us-ascii?Q?d4EL1s+e24KD+MeT3ZFtqz1B4D9qpR7OHF48J9Bgys/52VBYfs64088R+FoX?=
 =?us-ascii?Q?Hkqidqeidb9cQPQi62Si1vO08cppHWdBrpvgRpetUkoox6j8eWRbZQo25aSY?=
 =?us-ascii?Q?N+WDyoMQxpOXugg+mXaK7Btyq2h8mIa3R2FtfPo7rtVg0Nq+Xtp8/qXRsV3l?=
 =?us-ascii?Q?yQhXxSbKfn/vZZ1PqbiZJuLH1Ve/cZkT28c6jD65dhMbYbz0PRWR7Xfjos3N?=
 =?us-ascii?Q?KWTfAdg+DkkXS/qfM8gK66cUUa4+3ODMbp+pBQk+G3Ei3L9HuMGcUAe8JT6G?=
 =?us-ascii?Q?kFg+r45sQjj4Q2UJBu2OyODnmzF2fVPSMB3N242wSCMPhuj1v7Fi93Pl/bai?=
 =?us-ascii?Q?xklJzCBBNK4ROZu7STOXfXv839YrZ74WNddVi0QpviStF37xpPLx0EOnpk8h?=
 =?us-ascii?Q?Q8eNztDQrNBoW+BXMZXqthgeZQd6j1NLtx2YYBVB+HXtSkvMQZLwus04aYs2?=
 =?us-ascii?Q?8rHgxcgW84byvHWV/5wx7LT7S6TosXKUelpnsoTVS6poR6uLt0YDh9G5ANHk?=
 =?us-ascii?Q?dTMRXubQYxtdhkuIgSvwTDxjIIdMUEkRYRyruxIf+Pgm+nLc7iEa1ghvIGPv?=
 =?us-ascii?Q?J3eJJQBt6GhbalsxEhHaxygPW/Z/A8y9jfanyoiQx93KU7ivvq2n/vnNgUuX?=
 =?us-ascii?Q?C78Xv8wD4Pi9EUMfwFURfacor3uTZgPy4NsuUEPTMHd7AAw7y8J3S7VaG0yL?=
 =?us-ascii?Q?5+EgJ9ikANJxnaa+S6T4+5GlqK1Sxe/WWsmsAQ+rOAv3Me+/vTM3LAYkIyiB?=
 =?us-ascii?Q?tF2CdQlLBYdah9mPRWFmXjF1dBk5K/lAI3X3CEX1cZB0pv0tblsHtFOgmbtI?=
 =?us-ascii?Q?zYQNMg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d69ce4b9-1576-445b-4673-08db5537c02b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 11:30:14.0633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jyAntlO+4wbAK8uAEwR1cXm9n9gbwoJpMohBnuJeRtEp4aDT6BprICfWHx9RUiniQ1/tf3z6AGSTpybL+JxYwGbOYKwjelNt9s3iNn553Ow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6433
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 01:14:18PM +0200, Luca Weiss wrote:
> Hi Simon,
> 
> On Mon May 1, 2023 at 3:11 PM CEST, Simon Horman wrote:
> > On Fri, Apr 21, 2023 at 04:11:39PM +0200, Luca Weiss wrote:
> > > Add support for the Bluetooth chip codenamed APACHE which is part of
> > > WCN3988.
> > > 
> > > The firmware for this chip has a slightly different naming scheme
> > > compared to most others. For ROM Version 0x0200 we need to use
> > > apbtfw10.tlv + apnv10.bin and for ROM version 0x201 apbtfw11.tlv +
> > > apnv11.bin
> > > 
> > > Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> > > ---
> > >  drivers/bluetooth/btqca.c   | 13 +++++++++++--
> > >  drivers/bluetooth/btqca.h   | 12 ++++++++++--
> > >  drivers/bluetooth/hci_qca.c | 12 ++++++++++++
> > >  3 files changed, 33 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
> > > index fd0941fe8608..3ee1ef88a640 100644
> > > --- a/drivers/bluetooth/btqca.c
> > > +++ b/drivers/bluetooth/btqca.c
> > > @@ -594,14 +594,20 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
> > >  	/* Firmware files to download are based on ROM version.
> > >  	 * ROM version is derived from last two bytes of soc_ver.
> > >  	 */
> > > -	rom_ver = ((soc_ver & 0x00000f00) >> 0x04) | (soc_ver & 0x0000000f);
> > > +	if (soc_type == QCA_WCN3988)
> > > +		rom_ver = ((soc_ver & 0x00000f00) >> 0x05) | (soc_ver & 0x0000000f);
> > > +	else
> > > +		rom_ver = ((soc_ver & 0x00000f00) >> 0x04) | (soc_ver & 0x0000000f);
> >
> > Hi Luca,
> >
> > perhaps it's just me. But I was wondering if this can be improved on a little.
> >
> > * Move the common portion outside of the conditional
> > * And also, I think it's normal to use decimal for shift values.
> >
> > e.g.
> > 	unsigned shift;
> > 	...
> >
> > 	shift = soc_type == QCA_WCN3988 ? 5 : 4;
> > 	rom_ver = ((soc_ver & 0x00000f00) >> shift) | (soc_ver & 0x0000000f);
> >
> > Using some helpers such as GENMASK and FIELD_PREP might also be nice.
> 
> While I'm not opposed to the idea, I'm not sure it's worth making
> beautiful macros for this since - to my eyes - how the mapping of
> soc_ver to firmware name works is rather obscure since the sources from
> Qualcomm just have a static lookup table of soc_ver to firmware name so
> doing this dynamically like here is different.
> 
> And I haven't looked at other chips that are covered there to see if
> there's a pattern to this, for the most part it seems the original
> formula works for most chips and the one I added works for WCN3988 (and
> the other "APACHE" chips, whatever they are).
> 
> If a third way is added then I would say for sure this line should be
> made nicer but for now I think it's easier to keep this as I sent it
> because we don't know what the future will hold.

Thanks. My feeling is that my suggestion mainly makes sense
if it lease to improved readability and maintainability.
It sounds like that might not be the case here.

> > >  	if (soc_type == QCA_WCN6750)
> > >  		qca_send_patch_config_cmd(hdev);
> > >  
> > >  	/* Download rampatch file */
> > >  	config.type = TLV_TYPE_PATCH;
> > > -	if (qca_is_wcn399x(soc_type)) {
> > > +	if (soc_type == QCA_WCN3988) {
> > > +		snprintf(config.fwname, sizeof(config.fwname),
> > > +			 "qca/apbtfw%02x.tlv", rom_ver);
> > > +	} else if (qca_is_wcn399x(soc_type)) {
> > >  		snprintf(config.fwname, sizeof(config.fwname),
> > >  			 "qca/crbtfw%02x.tlv", rom_ver);
> > >  	} else if (soc_type == QCA_QCA6390) {
> > > @@ -636,6 +642,9 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
> > >  	if (firmware_name)
> > >  		snprintf(config.fwname, sizeof(config.fwname),
> > >  			 "qca/%s", firmware_name);
> > > +	else if (soc_type == QCA_WCN3988)
> > > +		snprintf(config.fwname, sizeof(config.fwname),
> > > +			 "qca/apnv%02x.bin", rom_ver);
> > >  	else if (qca_is_wcn399x(soc_type)) {
> > >  		if (ver.soc_id == QCA_WCN3991_SOC_ID) {
> >
> > Not strictly related to this patch, but while reviewing this I noticed that
> > ver.soc_id is __le32 but QCA_WCN3991_SOC_ID is in host byteorder.
> >
> > Perhaps a cpu_to_le32() or le32_to_cpu() call is in order here?
> 
> Good catch, as you've seen I sent a patch separately to fix that. :)

Thanks!

