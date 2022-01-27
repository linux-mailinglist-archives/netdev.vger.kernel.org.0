Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2D449E581
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 16:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242829AbiA0PK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 10:10:57 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:52415 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237394AbiA0PK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 10:10:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1643296255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Cdx+xUfecmdjsw2CMR2ZgqzLpq0kcnsYUPIvUPgob8s=;
        b=J4VEqiqH7U/UrnQpFIhvrexQFgcwlDkvhvDNpqwdydUCch8PFuc/AbTsEtO9W2ZPc705Jx
        fGAGIBrwB4KsNJbWJPCIlMZQ1dPHfrPi5j1GqtJmoAMpehDGg/FoVPHma5ju7dyc6ikH+s
        fUB5Aj2fmiNb3iWuTzYCOwmx4r46qWA=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2057.outbound.protection.outlook.com [104.47.14.57]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-22-qvuXX2LQNO-TJl0_f21p_Q-1; Thu, 27 Jan 2022 16:10:54 +0100
X-MC-Unique: qvuXX2LQNO-TJl0_f21p_Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xjqza4KN1fPOSc6CRpO3ZiWZ2gGoclLY7sXZflp1N/yEUapw7SxcVxujEFncWaAEmvf+/ueR9kCPQqjPfIi7u80PzVX7ScLiJQZMlrYfNdrAPPXBIKIDYCZW5aziCb5lgM6k+47zy5M2kBMB2GXlXyjlRJcegb6o3ThNRF8uC/2lofCmfOQdWLTXMw+oqtkmb1Cn/6QHcpFVjTJx2bKyzHWpjFDQd2YmlNrfLyrpezaT+M40jx2aXQrqAKjkImDVuS2VLln6CsvKTPyJg1jQN4aJ5KLdPKsdVZX8PHdJQ/+5rz93Pgw/DPkWcnL/NlFmF3ZMxJPGRTioes+uzxs1eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cdx+xUfecmdjsw2CMR2ZgqzLpq0kcnsYUPIvUPgob8s=;
 b=ZGLl3MnNQWbTgSigvq9X/opCTGu/2CkeQLvZAXSKlr/TevFBJHZ/Ig113jF6q58hXgQRpWoC4wwsFpqm2DlU2/nrD754gzU7d5EQvaJQYCdVZOFLSeTJSpo0dIkaRpxsgbUDsYInpa3+uTEcPWLdUhcdwCBxRzI92pKwxUCZUSDIKySbibCfEL+a10O0IPYWoJSe8j9E6HN8obIt+V2aCTloVS2KbHP5kxvyRWNUmpzYCWAUJlInkT4LcgrtS67rOpCsPIe8buOeUR/2yXExGsB9k7k2l6C3uHbizuJc9Sjs/BlVU/XUfJbPd9agbMZ6yilUyYOYQZZfVrJYc8FLUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com (2603:10a6:10:243::20)
 by VI1PR0401MB2239.eurprd04.prod.outlook.com (2603:10a6:800:30::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 27 Jan
 2022 15:10:49 +0000
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::e1c3:5223:dd71:3b6f]) by DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::e1c3:5223:dd71:3b6f%7]) with mapi id 15.20.4930.017; Thu, 27 Jan 2022
 15:10:49 +0000
Date:   Thu, 27 Jan 2022 23:10:43 +0800
From:   Shung-Hsi Yu <shung-hsi.yu@suse.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: BTF compatibility issue across builds
Message-ID: <YfK18x/XrYL4Vw8o@syu-laptop>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-ClientProxiedBy: AM5PR0101CA0008.eurprd01.prod.exchangelabs.com
 (2603:10a6:206:16::21) To DB9PR04MB8107.eurprd04.prod.outlook.com
 (2603:10a6:10:243::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a820b47-5381-4d5d-beb1-08d9e1a73384
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2239:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2239FF10D72CE08EEDB79FEEBF219@VI1PR0401MB2239.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uqIQxTLiQfzE0ej64+xWNaP6KG6Qh4J/2NRXHhKJyYRABWMUF1RenBwaAVItv4XefGYfkm3Y2UX40ftpzfeQiVbtebl541IhUXN92t1iq2a/fsDu70oeHWdLMcpYr1mwIvcB3YqvqW8a6+VzOWE3TR4H43Fi4txU9TyojqfutF09AV8WmMy3wx5H0xZIMupGuRGpVTm6BbYZa8pyJCYhjzlbxculUNgMbmN/Oy+hpRfnx7cI3KDlrNXcORtvvhRJKT4gPQGjQv3ESbS5n5YsmokdmtLWxkKd7HpUxI8rX5fQczxZbOCOdQjyy4XGIXetEr+umTcvZLGtGKeVLJE8RjC3H5AxINowpvUvH/t/utrM1UzVpu71GpdAB8r49jS27TOD+alcaWUZ8bek5WpQ1bW0ABI9Rf74MQmwj7wXXjFpL/qFb2TqxyLPb4EsbqmPisuQ9G4YvMCeqQP0GJYaYfmdzn13HC9c4T5QIoT80LxJoWZgKyeQefP+MAcqIG+z4jyiRhMU3wdAGmzeWDNS92VdLjBPOPaQzJxV3bU0N6O98WKHrquMZ3GzEpWHzlANTSaEh90eT9FkDiQfCfsecqtcw97Cq00A1JBnnhD0iHAODe41PH09wTXInCgfG23sqNOAnOk1iDDJtRngmYNDth9pfHzDeS4ZTYAf61uRQKb2q0eAJkfjpNGi2YMz4sKd1ha/Pcl4ZSVm5VuFyiTxO0gqee+SzJEQapyg61C8KNo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(54906003)(966005)(6486002)(86362001)(38100700002)(186003)(6916009)(26005)(6666004)(9686003)(6512007)(316002)(508600001)(5660300002)(66476007)(66556008)(66946007)(8936002)(4326008)(8676002)(33716001)(2906002)(6506007)(83380400001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MkVHTXNEdWtlbFliOVRJdVBhVGhDamtITXpoamdla2IyT2VvNlFISjc0dXZW?=
 =?utf-8?B?NDJubkx5YW02VHA2T3Rud3RJQUNPSGRTUzVTa29MbUdualQ4elFqYnl2dXBV?=
 =?utf-8?B?VUFpSnhmTlpNamZhVnlFWW4vVVlmbU1hckl0ZGp2RGYvWFVUa3A3SXkrRi9Q?=
 =?utf-8?B?TVMyaFFDL2hNeTZ0TjVZZW5KdGtXNmlyYjk2djRaNmdLYVBnTzdQdHUvMHB0?=
 =?utf-8?B?RVRwR1dNeERsNjRnTXRqY2dQenNnWHFCRGgveElDUkhlZXVyODE5clMrcjVB?=
 =?utf-8?B?bVdaVWh0VG9RS3hKU3ZkdzVWMEJFRDQvSTI0ZTRPV0RKdmlSS0w3SXB4cHA3?=
 =?utf-8?B?c25rTEJyY1ZCSDdPZHFDdTBodU5TUlUxZXhyRlVSVGhvVzBBR2huNHlMVzAv?=
 =?utf-8?B?NG54NElpVUQ5WGZkVWdRam9DVGRpRmMyTUFqVEQ2TmtSVi81azRYRERpU0t6?=
 =?utf-8?B?RzVUZVNjLzQxWU5mbktiTGRQQlYveFhTRlhzUXpKQk5jZnlFVkdrQUZDakto?=
 =?utf-8?B?MXA1MVJlZXk0TVdiNG51UCtabGYrRlRaNDkyYlB5QUlMelA1OTFEUk92Sysy?=
 =?utf-8?B?NXNCR1ZZd2dLdDc2RjlwbjY3eGk2QXh3RzhTK0h6Y3VPdkI4STk4TGtFSDd3?=
 =?utf-8?B?Z2NLdk5tLzNZTDd2NHc1eHZ0SDBWTVBWdEFFUVQ5YnFqaTc2V09FSHBMUExw?=
 =?utf-8?B?bUg4U1J0d1RpMjdoQkVDSWtoZG56dXBIMkNwdHpTU1ZHV2lacmtKenFCazJX?=
 =?utf-8?B?UEY2ZG5abzRuWlhFMlJNSUptMEtsYURyS1V1Myt4cFBaTExwc2JHanp5YWVr?=
 =?utf-8?B?UEZNRFE1UkR1dE1od2pDUVRkcXl3NGJQOUVIUTJiOEozVEsvM05rVWtnbTZ0?=
 =?utf-8?B?NExRYUc5U1BySHNxelM2alBPQmhCNHhVQVBlUmt5SUwvKy8zYU8zYTVSMG1P?=
 =?utf-8?B?Q1NvbWQxZ3JSdzlpeEF4bnNsL0JDTS9LSlZySUFGWENGVnF3QlUySmVodnRj?=
 =?utf-8?B?VnZhWUx6cHRTR0cvQSs4T1FHeW9NbVhERmhVcy9vb3ErYS9mV2lmY0g5RHQv?=
 =?utf-8?B?NXhhMGxERVMvVUk0TjRyNVB2WitEY1pDZk9hdENYQmRyZnVodmJkMEZiMEkv?=
 =?utf-8?B?SE5iMDZDTkpGVkJuTzU5TGMwVXRrMDBES21ZaHlrL1N3cmMxQzNsRytrdFVr?=
 =?utf-8?B?VHB3bFgxYWRTMUNiM01UNkN1c2YyWEhQdCs0NVJzMWYwZnFmQjBzY0RUTlVv?=
 =?utf-8?B?YldPMEJMMzJhN3owVTJYWlZETUtlZW1uOWFkaDc5OEUydVNuY0JiR2NEWjBV?=
 =?utf-8?B?TVhNQyttMldVTUNzcnhhdCtxeTBrOUlZRGJvK2JmOUt4dUg1L0UrNk9mOE5J?=
 =?utf-8?B?a3oyYmkwTnFqVmc0M1RDQ0R6Y2VSUjczRlhtTTU4UWlQd1gxemFXNVJjSEpu?=
 =?utf-8?B?WGgxWUlWL1NuZ2VETE4yUXRldUFzSXlRSm5PZ2dTcWwwMkloME5MWU1BMHhJ?=
 =?utf-8?B?cmNselNPdThjQXZJNlBQWXhlaHNIc2R2TkdYazhydEo2NGY4NWI4Y3ViOWxu?=
 =?utf-8?B?ZkpDTlRta0hyTkd5YXB3RkNSZXVDdTFlZ1pVY0ZSZWpOTHR2VGxhdXpESzFn?=
 =?utf-8?B?RjJFU0xPaVZtVEYyd1pKaW9KdGNKaTlTNkRVbFN5ZnJrOHN3K2JiQUNSRnBa?=
 =?utf-8?B?bFpmWkRGK09BUWVSSzVVbHZzNGYzR2RKV05GakZremtSUVl3dHF4V3ZJaUsy?=
 =?utf-8?B?WlhjcHpTRUVKV29yN2JVVFViUEFydWVydGk2WmVWREtRTTA2OVM5SWRORkI2?=
 =?utf-8?B?bldWMC84QitCVHF3U0svbnBvMGU0VFdVYzM5NTR2eXEreUczdEs1Z09jY0RB?=
 =?utf-8?B?eHpMaEZSbmVpQ1NzU3cybnlwZmR6dmc1UjZROThUQUEwV0pMUldRZjlCbkVm?=
 =?utf-8?B?VU1LR08vbW10MWl5TlF6SDBXWkY2TDB2TkF2UHBaUEZtWEZRK0JXWUNPZVNU?=
 =?utf-8?B?Uk9KaUsxa2taZ1FUcDVPWTNzdU5OOHZwdE1pVm5IZkxLZ011YS9ydzZpODZ3?=
 =?utf-8?B?S2FIdWM0VnBTVDRsYlpCbGtITytMY05BMDhLWDdQN1B6bnJsWityVG8xNGY2?=
 =?utf-8?B?bmpWTzM5d1lLY2YyVXV4Z0h1RWtpSWd5cVptQnlGV0xiVTlLSldWYXlwWTNU?=
 =?utf-8?Q?i/tAKVplErVplyRcoW/8zyw=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a820b47-5381-4d5d-beb1-08d9e1a73384
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 15:10:49.6478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UWrFoLHIpnPizyfLne6tG0il2D7C39jM31UFvGcqtUpeGfXR+Y96KAV3thdQJs1rVr6cgxqKqitfvS0AGDGOnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2239
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We recently run into module load failure related to split BTF on openSUSE
Tumbleweed[1], which I believe is something that may also happen on other
rolling distros.

The error looks like the follow (though failure is not limited to ipheth)

    BPF:[103111] STRUCT BPF:size=152 vlen=2 BPF: BPF:Invalid name BPF:

    failed to validate module [ipheth] BTF: -22

The error comes down to trying to load BTF of *kernel modules from a
different build* than the runtime kernel (but the source is the same), where
the base BTF of the two build is different.

While it may be too far stretched to call this a bug, solving this might
make BTF adoption easier. I'd natively think that we could further split
base BTF into two part to avoid this issue, where .BTF only contain exported
types, and the other (still residing in vmlinux) holds the unexported types.

Does that sound like something reasonable to work on?


## Root case (in case anyone is interested in a verbose version)

On openSUSE Tumbleweed there can be several builds of the same source. Since
the source is the same, the binaries are simply replaced when a package with
a larger build number is installed during upgrade.

In our case, a rebuild is triggered[2], and resulted in changes in base BTF.
More precisely, the BTF_KIND_FUNC{,_PROTO} of i2c_smbus_check_pec(u8 cpec,
struct i2c_msg *msg) and inet_lhash2_bucket_sk(struct inet_hashinfo *h,
struct sock *sk) was added to the base BTF of 5.15.12-1.3. Those functions
are previously missing in base BTF of 5.15.12-1.1.

The addition of entries in BTF type and string table caused extra offset of
type IDs and string position in the base BTF, and as such the same type ID
may refers to a totally different type, and as does name_off of types.

When users on build#1 (ie 5.15.12-1.1) installs build#3 (ie 5.15.12-1.3),
and then tries to load kernel module, they will be loading build#3 module on
build#1 kernel; and with base BTF of the two builds different, name_off of
some types will end up pointing at invalid string, and the kernel bails out.


Best,
Shung-Hsi Yu

1: https://bugzilla.opensuse.org/show_bug.cgi?id=1194501
2: my guess is rebuild is trigger due to compiler toolchain update, but I
   wasn't able to pin down exactly what changed

