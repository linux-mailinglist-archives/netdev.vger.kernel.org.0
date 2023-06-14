Return-Path: <netdev+bounces-10630-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B126972F749
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 10:05:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD6F61C209CB
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 08:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD95417D7;
	Wed, 14 Jun 2023 08:05:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01AD7F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 08:05:12 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2111.outbound.protection.outlook.com [40.107.92.111])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10868170E
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 01:05:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EfpbUPdfmn8XYA1UUIH42TV5TU7c37aFcKklaxrRYng4jd9iSHmz+wHK6DZxrrHrfAYycuFCw9sNS5QAis4jdRFjZQJsGAjsPB8qdZ8f0a9US7/gbAX0kx6b2lDkUUyfipgnaNRAc0UrsbUwsBt6Gv3XH/9BiUc45otFCSOs8NeJeijDYFqwK2e0YepQcdqMs5UK1VbMWsS8N25nkJy7mrfmitTUelEYg8R9n3+mR8Nib9CR40BbiU7sV/9zxJ4qTpa2uELrIkKE4JKZPfW5ZP2NBFFWClltSUH17b9c0MAj1knGbv8dHFnEPBAfhogGgwFAl3ZH31u4MEBEyxpaPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YoP836zG99KAzKRqRX5KK5vO/WHdxhxR3db18tLZqTE=;
 b=CFjrVX79srAq8NkAAmujjZ4ZE+oujH2G/3rxfcM3AvM2Lz+pbUe9UXv0lJI8grVXVuAO6vpsawJh8dVFregUA86Ul0sD5YHLRY8D9kWIHpZk1geTG3VmirCMKDGlkImooXw98XamceTqIvwaE3SHiFbDQjtd0w0U50/Uu1wDNPsiHePSgpilBcnJ8nuviPZsWBB1jvxm1ktki8Dr1JJUvujfQdb2osBYOQypanFCOGUcTnqKsYukr65C/vrUSuhFdzuT5gTdjbUmKljTxlICr4+yoaKhZO6TlcALQO+VtgXlo3U7IZoJAxUo9ioH/DYlNAwveVX7xuqA3ftOXQ6RrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YoP836zG99KAzKRqRX5KK5vO/WHdxhxR3db18tLZqTE=;
 b=p0omXlnDzGWCd8tk163Z1j6XfOEVR49Ju/0O8RpJYT+g7q9ysqiuy92g5QuPbCkVEbmAWFrOlN9BwbuyQko7ICfDb0g9WflBBXEYERCRl8Mozl7Rk+xkODABiGicUS62t+rIA4RmF6J1g640X/7hfCIloZq47SJW83gmOOFLBXs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3937.namprd13.prod.outlook.com (2603:10b6:5:2aa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 08:05:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 08:05:08 +0000
Date: Wed, 14 Jun 2023 10:05:00 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, netdev@vger.kernel.org,
	Jakub Buchocki <jakubx.buchocki@intel.com>,
	michal.swiatkowski@linux.intel.com, jiri@resnulli.us,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: Re: [PATCH net v2] ice: Fix ice module unload
Message-ID: <ZIl0rPQ4EWr10JpX@corigine.com>
References: <20230612171421.21570-1-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612171421.21570-1-anthony.l.nguyen@intel.com>
X-ClientProxiedBy: AM0PR02CA0104.eurprd02.prod.outlook.com
 (2603:10a6:208:154::45) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3937:EE_
X-MS-Office365-Filtering-Correlation-Id: d3de1d6f-0261-41e3-15b0-08db6cae1185
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	K/FxrW+qI7Uy3TYjS3dbiFcQUQupnspd/2yLUefUHwXQROjRcuLUeYNF45kJHP9Mt8gK3y1zalmPQrwZSRQl9LwhUh3Al+wB1XfCdFfHysNFU9Xehef2Cnu1PSqxrmJZbKpESb0pMuShMmmDuisv4+UBRJ0lyseaRX7hRNwTrSyUkKLY9gRBFyKJxtnv/1wqMZ/TTY2yNugwzSbJHMrzq+l2RPEgMQqmnQsdQ51IdHDZw5PI6FESUXiAJn0f9e58+EsSO/JhBMPYMf9IbjRkgdiLcEnXazOidnQtdoavv9eWvFkFVRJrqVrJ+T3JlDumitSiyYa0wtrgEsioUX7iwM6mlcuhwfHDkFxCBb/H2numglvTVLjy7LkEptdQSJhaH71Esyqf6J0Q+pZQWO8hhuQzuZRBcD7E0ahUjHeZzhTYBtpDmPj/1YUj6Q439rHpOJtPxiFWG3/Qo3ErGhCMfxW3og7qxWmfijxI7gQmYh3wX9cc8P/0IUaeiBBdiYMuOL10hAH/W6SObepI2Ks/DAGO8mM75GIXiUTz2I7cmgWTq4Pw8VCN9h43qBGqxoNl6egikyWb0IDM4YgCBBxKeZOyZjG98ri8l8a8aScbORI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(136003)(39830400003)(366004)(451199021)(8936002)(6486002)(8676002)(6512007)(41300700001)(38100700002)(478600001)(36756003)(86362001)(66946007)(6916009)(66476007)(4326008)(66556008)(316002)(54906003)(6666004)(6506007)(44832011)(5660300002)(83380400001)(186003)(2616005)(7416002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IRpMuVvlMwvTUx6YsaghcMaOas2Ebfzf/s+tbmeOZwUVwyOt1JYjsCudek/F?=
 =?us-ascii?Q?nVEYjZ8hHxRNAJ7Tej8ryu/QzZ1JtQTdTiEXGNEbFEjV88NRTHyzvU+RhAq0?=
 =?us-ascii?Q?MeFmeXrzZi1k68iSNbRSWwVL/I+6NacLdGC6bTWQGvXFHqlipqPZY0pbV44h?=
 =?us-ascii?Q?V9aHQS0dNu0mUxa8JV40tHeJVU9Zywg+PvRPSwRkhmaVqQLPCMxLl7lccauK?=
 =?us-ascii?Q?yf0KB1lVklrbuK2Wzh/q8tqbdT2W1MICJFLbLd2djr3c5S8aZ/Dl6E4XCJky?=
 =?us-ascii?Q?aMae80nPaxZRcjoRqf02wdEm5pVyxT/QnguAtPUgVCvgaiKHCIvp0WbccF6N?=
 =?us-ascii?Q?5WU++C09qayPz0QUafgY9m6v+5g6acwWfoiE8yWcZJG9U/T+xXoZ9aaMvPAR?=
 =?us-ascii?Q?E+hHkRNBlhI91Mj7tI/RyJtiXti3gukIUeUDFT6NTgFLcWkrbUIDvAoWeiiX?=
 =?us-ascii?Q?dkGFrxPvHQuVN1L+/G3HuyxnJ824t64yYUkiMUUpr+TT+uCxEBRqKjzG7rta?=
 =?us-ascii?Q?F0H8oNQWL2O8LP9Le3KqLFn7hfoET1uGueSH9sXad8DeYf51iUQm0jHIjJj7?=
 =?us-ascii?Q?pqKJjw/Vuv36y1DISPXnae04/2/rZv7m/7spIA7mUSOJ+FcRq2ZKSwvI5sgI?=
 =?us-ascii?Q?2HihpKPNuNRMHnp4ziir8QFNBc1Tl/4wdzjrECTJrX3pF3Rtsh7V6qC4KZIL?=
 =?us-ascii?Q?e9VFZx+pWrjk06N3rqIpbblmUs2BqlvBJgvSwFbcpLOuwaR3bg8K3E/2q05D?=
 =?us-ascii?Q?V2fEB7wfIy0rpoBDodQqZWELLCD7naIFGkoBBKSI9QvjWN7kLcn4QFYr8gk9?=
 =?us-ascii?Q?D8otkFMapg7jX90hFvTSoQvZHmd8+ZAJblh/LQQTx1UAdXYKoa6ByvM3chu2?=
 =?us-ascii?Q?y4d+m4AlUkETE6bhS1f71P9YShNva3RCR4ZAnDSxGDMLtV/FAPAKPxArJQmN?=
 =?us-ascii?Q?Io+9u/Hehg3VyPVnnQf3or0phE2C62HuCuIFeBhS/Vr2FcJX3ku6Anu8RCyi?=
 =?us-ascii?Q?jErDt15Qbl+VtVpJOZY/44Oxp7MoOGFAZ3xn2OEibvO51gFiBHVFZKRisWk8?=
 =?us-ascii?Q?Xka3E62+r1I2PSphXRyAxmuFhHLJsmSfP0/QSZ1xqj9Znx/27dWdU9vg0ohK?=
 =?us-ascii?Q?mFamU5BbD3XpoRwkJbqNO+GacSg7GffAmtPqZ0tziZljOnVOim6ZwaILT7MQ?=
 =?us-ascii?Q?nqnOoq24oAPIECtJqMKC6zzeyL3a8gGO8YUdDkMaapCSoiXJknl4VRBa2xlC?=
 =?us-ascii?Q?PZBCwtu2A1/eQFl8CrBKznUkLa9+8yBQ4CZxsNg7s6ZFRbS+mV5eyFmRRi5Y?=
 =?us-ascii?Q?TUr2PBVNZ7mO5drh0UEZopilEeY505o59xp3b6OZkqTY4ld8ZJxHwH+4bLdH?=
 =?us-ascii?Q?SSZ2y6Z+21H1TBHKxZJbHp0/f2fw5cQN/W7DePnGCkJgI0gYYgzsfr42IG/B?=
 =?us-ascii?Q?/cHlVeUF8DBdg3ch55STJD12VrAW3IXbHpFjLhCzUbwMTuyrtZjDrEVO68uD?=
 =?us-ascii?Q?I2WbfQbKUKHVwwzSxcYgAVWS4zaIdxMc5T+Siw7bY7zB5JrnHCudn9rEmOuJ?=
 =?us-ascii?Q?IsmcuhRDNYhnrE4DXP8NWEoHqaRKeBW8oF6IvO+0jKuM8hj5NsXvtovZCxbp?=
 =?us-ascii?Q?Kn2zwQjcIaWiKLxIIYRl2hgKgz3ZxAsofgO8w6CntEITL7kkvqJcIOA7qyZc?=
 =?us-ascii?Q?zuYyQQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3de1d6f-0261-41e3-15b0-08db6cae1185
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 08:05:08.2552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rCTPiIvx1nd+IgqKXlazCfB6czaK5Q6rADA1W7fBiesI6OxJHG8D/Gr5XmrLrXE7UDXQ7LVC077Qa8OhirrgAkWEporg57nOgwbCCu5tQWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3937
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 10:14:21AM -0700, Tony Nguyen wrote:
> From: Jakub Buchocki <jakubx.buchocki@intel.com>
> 
> Clearing the interrupt scheme before PFR reset,
> during the removal routine, could cause the hardware
> errors and possibly lead to system reboot, as the PF
> reset can cause the interrupt to be generated.
> 
> Place the call for PFR reset inside ice_deinit_dev(),
> wait until reset and all pending transactions are done,
> then call ice_clear_interrupt_scheme().
> 
> This introduces a PFR reset to multiple error paths.
> 
> Additionally, remove the call for the reset from
> ice_load() - it will be a part of ice_unload() now.
> 
> Error example:
> [   75.229328] ice 0000:ca:00.1: Failed to read Tx Scheduler Tree - User Selection data from flash
> [   77.571315] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
> [   77.571418] {1}[Hardware Error]: event severity: recoverable
> [   77.571459] {1}[Hardware Error]:  Error 0, type: recoverable
> [   77.571500] {1}[Hardware Error]:   section_type: PCIe error
> [   77.571540] {1}[Hardware Error]:   port_type: 4, root port
> [   77.571580] {1}[Hardware Error]:   version: 3.0
> [   77.571615] {1}[Hardware Error]:   command: 0x0547, status: 0x4010
> [   77.571661] {1}[Hardware Error]:   device_id: 0000:c9:02.0
> [   77.571703] {1}[Hardware Error]:   slot: 25
> [   77.571736] {1}[Hardware Error]:   secondary_bus: 0xca
> [   77.571773] {1}[Hardware Error]:   vendor_id: 0x8086, device_id: 0x347a
> [   77.571821] {1}[Hardware Error]:   class_code: 060400
> [   77.571858] {1}[Hardware Error]:   bridge: secondary_status: 0x2800, control: 0x0013
> [   77.572490] pcieport 0000:c9:02.0: AER: aer_status: 0x00200000, aer_mask: 0x00100020
> [   77.572870] pcieport 0000:c9:02.0:    [21] ACSViol                (First)
> [   77.573222] pcieport 0000:c9:02.0: AER: aer_layer=Transaction Layer, aer_agent=Receiver ID
> [   77.573554] pcieport 0000:c9:02.0: AER: aer_uncor_severity: 0x00463010
> [   77.691273] {2}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
> [   77.691738] {2}[Hardware Error]: event severity: recoverable
> [   77.691971] {2}[Hardware Error]:  Error 0, type: recoverable
> [   77.692192] {2}[Hardware Error]:   section_type: PCIe error
> [   77.692403] {2}[Hardware Error]:   port_type: 4, root port
> [   77.692616] {2}[Hardware Error]:   version: 3.0
> [   77.692825] {2}[Hardware Error]:   command: 0x0547, status: 0x4010
> [   77.693032] {2}[Hardware Error]:   device_id: 0000:c9:02.0
> [   77.693238] {2}[Hardware Error]:   slot: 25
> [   77.693440] {2}[Hardware Error]:   secondary_bus: 0xca
> [   77.693641] {2}[Hardware Error]:   vendor_id: 0x8086, device_id: 0x347a
> [   77.693853] {2}[Hardware Error]:   class_code: 060400
> [   77.694054] {2}[Hardware Error]:   bridge: secondary_status: 0x0800, control: 0x0013
> [   77.719115] pci 0000:ca:00.1: AER: can't recover (no error_detected callback)
> [   77.719140] pcieport 0000:c9:02.0: AER: device recovery failed
> [   77.719216] pcieport 0000:c9:02.0: AER: aer_status: 0x00200000, aer_mask: 0x00100020
> [   77.719390] pcieport 0000:c9:02.0:    [21] ACSViol                (First)
> [   77.719557] pcieport 0000:c9:02.0: AER: aer_layer=Transaction Layer, aer_agent=Receiver ID
> [   77.719723] pcieport 0000:c9:02.0: AER: aer_uncor_severity: 0x00463010
> 
> Fixes: 5b246e533d01 ("ice: split probe into smaller functions")
> Signed-off-by: Jakub Buchocki <jakubx.buchocki@intel.com>
> Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


