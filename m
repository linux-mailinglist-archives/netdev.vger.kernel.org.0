Return-Path: <netdev+bounces-8360-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F96A723CCF
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:16:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6FBF1C20ECF
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94F1129100;
	Tue,  6 Jun 2023 09:16:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B8C290EA
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:16:45 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2122.outbound.protection.outlook.com [40.107.94.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E37810D8;
	Tue,  6 Jun 2023 02:16:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AbVbuJGBcEjrRok4vTojbRVKxx0jAOM9Xv7tdo2PJzk3nTzcFAZ06nEldrbrR97Noqbz/GTYPOM7g5YPOmun0DXins7+FJwQ9WNBbTWYQMVcbS3bb0mmKDEWMnwr9zAJiY/VaceJJnwllx3Tr7dseuGB/NOX7PS1rHRNtlsjjae0sWC62shyLPkAjRKM7a2xudOazJQHtkxjJ94yiV7Y9Mvmmrr4MqhG5wwd30E45g4JNn7io/OFZDFFW4KBiAi1I/OHQZsMh3VeID1NfZkdbvNOux5qqGiusrkKCs35KQxWvYWWz5dzTHWgG+jV05C8f5TRtR6UoXxKtNHkzu/img==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3GXwO+efv0Kz9jCJqUKq+o7y3U0ehUDN4LS139Asp7c=;
 b=QFfeNgbuVQULHAa9FBvC9Yz2774mpW0HDtLoj2JNudRaZRHFnc+0IW3WzFlKt+up1rPy88n2KqlAU8pn/R8SgwDr+tkN7naz6FUtU/4v0nbhrOxHmfjn0HCIo5Wj30wfipHACCeO0WSLz6kyHOdsw1c2BJKhiWljoDWTUltGcwvOcWKTwjCEPFJPrIWYnNd/k+2JP2wNMcXZCxUFF21oIgshF2meFySovmShWfMgtyCiBbv0GFZowplxG3f90iNm6IpPVYm7PxVIexGpk8eFq8WHQmvsmi6S5i88zjgA4mvwXosIBW9VACi8NF3N7glRuUJRX97xF9L8R3f496Xj1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3GXwO+efv0Kz9jCJqUKq+o7y3U0ehUDN4LS139Asp7c=;
 b=g2uUdFODh2Wnbw/9C7T9F8OGw1Eu5qPbpvc5RWw8T7URp47y4pVYWn1o/21vRJ/34Ub1gaQnfDh2i5xdAG3yjeNdAVicrDcBqAF6hGw9227xcVODTHk0LEceXLJcgt8A2oINFA8T86VOLpjZYEXfuNSBHNDBomobraZCoGNbkX8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV8PR13MB6397.namprd13.prod.outlook.com (2603:10b6:408:185::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.18; Tue, 6 Jun
 2023 09:16:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:16:34 +0000
Date: Tue, 6 Jun 2023 11:16:26 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Paul Fertser <fercerpav@gmail.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>, Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, Rani Hod <rani.hod@gmail.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] mt76: mt7615: do not advertise 5 GHz on first phy of
 MT7615D (DBDC)
Message-ID: <ZH75apdT19WDrwS2@corigine.com>
References: <20230605073408.8699-1-fercerpav@gmail.com>
 <ZH72YwgpywPNxbd2@corigine.com>
 <ZH74kw4M15qjDbTz@home.paul.comp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZH74kw4M15qjDbTz@home.paul.comp>
X-ClientProxiedBy: AM0PR10CA0023.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV8PR13MB6397:EE_
X-MS-Office365-Filtering-Correlation-Id: ed23e329-6d84-4001-06c0-08db666eb939
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Bva3dSlb2q0Tv8VQw6zzCjTRV04+T/fkxJcFi/Hvk+CG060ExRzf3q8RJQ/wdCZ0FdxRK0i6Iaijaqu15TXGl0fdEEiSeXA3USWSzdrZeeBcmxb347jR2KOiwDKtXYIEcDGL1Efths/tMj4uVtV2UKRTTAzc5Qr0xzdVaRUQNoivyZUEyGZg7BqHiPBJDfn10pvcUZaqHdJ928x4VXewx2erxATVAkP08A9a2OOLQE1iXncQvpQKIkAuHM36GEf7rCgzqjCKw7oXlr2ln8Asbh1kHrkHELZn6bJ1ApIkfv9FiOAAJCvHJZowLVxqN5qk+NS4SR+VWnTeH6T5m+Lo/HpvU8fXqgYbk/ncrOYqM5D1GcUa7/zPv4YJdNPdteuxqDFBo8ewcioothiz+A4RuO/QWHuUD64zNLqjDeyE5WHCnf2sdpnWPWjzv/pzI9WYOoU27MjoDxwJCj5rD0jJ2xtIlNPrgSkjlKVuvCG515OZSDYD/BxkE/ZeiVV+FCwe1S2SZX0WWBxT+EnZDDd0b7Ws3CpTu7Drf+tDjocCrSo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(396003)(346002)(39840400004)(136003)(451199021)(66476007)(66946007)(2906002)(478600001)(316002)(8936002)(6916009)(4326008)(8676002)(41300700001)(54906003)(44832011)(66556008)(6666004)(7416002)(5660300002)(6486002)(6512007)(6506007)(966005)(38100700002)(186003)(2616005)(83380400001)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S3xnnuW5GL0osBAqZNmyod4gQGv8AA9m3V8/MhWK5qPUublK1G9QFEqJ+9Ag?=
 =?us-ascii?Q?wBtWdTLj3oVBSBSdqoVVDyyZ4775huYMG1o8FLOKxIbXdZ+4JWg2QzYXKyb4?=
 =?us-ascii?Q?BBhLMtRC+90iC6t2FsDkPlmpHj0F/oM9Y9zwbLt34SFBoIdr6wytoatxYWPY?=
 =?us-ascii?Q?E9IOllte5ZHWa4V2lGSUQNR9vQkOcJ/I/PxK0w0tfR7EQjIwONpKf4f/sgKZ?=
 =?us-ascii?Q?Sg3Fn1ppkU3nBg4hAPgWjThwugHsq4rfqjUJlGm9RVaqLlW9GKpn8wmq/f/7?=
 =?us-ascii?Q?eKPMbDiDNbzQ9DCxXKH23Aknw7F15DrFe9gN6yV6VKNxUGNYvQsVlHDHmvnA?=
 =?us-ascii?Q?ZTSBtquHWHuS/vA4p1DhFov8SJyHXpO6Q8SsfcQJaoTOqiMY5l3e+6xY2cLQ?=
 =?us-ascii?Q?aAf0wd5+AlZngUEBYtwTkOamBGeqty6YYJBRFAyvAe2/FJVQjIdE251bU0vl?=
 =?us-ascii?Q?+u2s6cTo1s4W3fWHG8Jzk6vy1S5oAU7tnkNhWPjQ65W8xoZIP3eXWhSVPhgL?=
 =?us-ascii?Q?DW4By5IPGP9zc8ZXk1sPDXxcxkbBFbDazOQwVUuenFNrJyzWjVtG2bdKNShM?=
 =?us-ascii?Q?2vnX+/A9P365dFOCdIGZFCRXvsQJEKgLri0JzmXTBuwX8IyNsVTsRGHNS9Ht?=
 =?us-ascii?Q?ieffh3eSxW8EuQi3lljPROJuHPMsHzREB7aDFBM5OAqYlWiq0y+Rum9GadZv?=
 =?us-ascii?Q?mMIFUk0B61u9JrBO6TLxJ6+MHmE5vdOE3VXtD+Kmv6594mxf+AUQaMdkK73V?=
 =?us-ascii?Q?ykI9JRon0x8Qhh1Pyj3AJ2sibm7tv9cpnya/lbJatMXicazvauI+v4fxOYOv?=
 =?us-ascii?Q?ZAYjbs0ZwZHdmqMD3XJ1rBSXZ8CZ1cNOHtCK8edYI8goBiKztY84r7qzxUlR?=
 =?us-ascii?Q?49ekZMwrulcra5BRU0/39aP1xQh5gQLyHvMcCwHk/YL9gakmFVhDDT0rBMGH?=
 =?us-ascii?Q?PLDu7B8KqkcgVJ1bSOraBmj56w7bX/O9G0GNYI1OCQcxWkRuAiMcmrAdpztH?=
 =?us-ascii?Q?fEWglg0TeIsZ8l+5no8mG65cQxS/ps/8iWruesLn+JHx6Nf8/bR10nYr3rVY?=
 =?us-ascii?Q?w16WGLEOBpahbe/rgFWguSsaXT9E+8WiSNvQ3tK9t7tMvmce2ZQOt/7trTRe?=
 =?us-ascii?Q?mys1hcQfaVtG0wrHMbtI0cAvippyivldCdI9LYFQI/5aeg8lPa1iwm0v9TxA?=
 =?us-ascii?Q?ZuL1Txvm2FFWMZTc8kT3iV4JDpyAgWk2LSNP6hjJWM49PN5WVPe7V3G65qM9?=
 =?us-ascii?Q?jTOPhXdOCpueeRBTis8DqNg5pjcrZyGcsRbKt2cHoMTUzpHBtiWejTr9PFW8?=
 =?us-ascii?Q?OqzT1L2GvhaGV5Gy2M0jY0ndeOMY0tRnva+85af7kZNAGY6WnHoNnwBcknoh?=
 =?us-ascii?Q?iTaJ5V+lpL4ydTv2vZRZr2aSrAac8Xuxc/j0QCUzoiDk14OdGWv6fdNt8OcP?=
 =?us-ascii?Q?ENTuxVmedZFd3+QwxD9Uoovxovek5og8orjV8+2TQr2T+jjleivc7g0EZppC?=
 =?us-ascii?Q?jLR1Kuy9yw+UQhN91SOSFH7hwYZMaZUyw5ykSrUcZVhw1zDNRFHMmdSgHCHE?=
 =?us-ascii?Q?ilpqkEhp+g6Fncz82wlJEHzPGswgc/RtutPJiV6uDQLxeH+q77vmssEgRpLW?=
 =?us-ascii?Q?3yBixuj6LDqu8oxZFovpOSf5f+R6LV9MFwy3SxrAABTOwprxN1615k4FVA9v?=
 =?us-ascii?Q?u5uuiw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed23e329-6d84-4001-06c0-08db666eb939
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:16:34.4050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6cAaxU2xVsu2rcQlu9/lx7Wb4ImZWiqd8HiFcMUHD/4Vic2eNir1CoqJYQEWVfzk6gYcJl3U9FPYZx84gjPGDpNED1JJ9HKGQpSxwUNa2PI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR13MB6397
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 12:12:51PM +0300, Paul Fertser wrote:
> Hi Simon,
> 
> On Tue, Jun 06, 2023 at 11:03:31AM +0200, Simon Horman wrote:
> > On Mon, Jun 05, 2023 at 10:34:07AM +0300, Paul Fertser wrote:
> > > On DBDC devices the first (internal) phy is only capable of using
> > > 2.4 GHz band, and the 5 GHz band is exposed via a separate phy object,
> > > so avoid the false advertising.
> > 
> > Can I clarify that the second object won't hit the logic change
> > below and thus be limited to 2GHz?
> 
> The second object (external 5 GHz phy) doesn't have an EEPROM of its
> own, and is created explicitly with just this band enabled:
> 
> https://elixir.bootlin.com/linux/latest/source/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c#L104
> https://elixir.bootlin.com/linux/latest/source/drivers/net/wireless/mediatek/mt76/mt7615/init.c#L573
> 
> So it won't hit the logic change and it will be limited to 5 GHz.

Thanks Paul,

in that case this patch looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

