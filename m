Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 609E84D5E13
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 10:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344645AbiCKJNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 04:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344505AbiCKJNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 04:13:10 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-oln040092075035.outbound.protection.outlook.com [40.92.75.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952751BB713
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 01:12:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pw+aD/lvHruMpjI6yWtc7lCYh+DoouO5a8zVY4l2+7c7DupHmfeoc00hie0k5yNHS6lkMqOc9qi/rINsQHPMQPOkIrHuUMTLwjRkIlGfmyMiz5nzuthIx4AHB6ffHxbMiye5ZD4jdoeFqMJpnGLnJdiWaLLcg0bHSG40K5CSTlPi8g9Vsgi90/Dag2YMUdFz1ZXiUoODjB3ebIc4ALwDbH5DWmi061DgWrgpgqPSdFCr3mTh7wFcpJxQIgSh54XgfElvNG8QiL1u6k3TQeJPS4zi55Y4jYXBNy1Kfl4InMM7jCfkumJxK405a/9LWOQ6dGSeAIYnhJbgLFc4Et0ZaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YBBpUgQyxubqkL4Br06cfR9bBTcHRPj+HjnilGqCMYo=;
 b=ntekvuaD/uR2GlvhGJBumcJC22ViFeeD9XVcTUooMno5JUf4pCO8LeDcF/sFxLK3+sVEET3kMdCIVfR6mGuwNUM1EEs0EUVQCHGliw15INOtWIjqMv/WR190FslP6LdPMaCRgvXDe4eeR/VsgPhAB/q7cLNjztlZukiIusbE0Uk/F5Qc3gYwENxzL7OEe5c3UML7SqSZF+6g9Mhy+T01Yu26JQFlF1R2cZaD9s5tSaR9pFwZyYgyZvx2/9SFmDY8/klRJofs7sFNuvC9qBCg55RvxchpDzAT7+LjaHuR0rwO8o9I1ZMS8jPgNooz+2LBFNkg5MsAqPOt5DsIFX9SXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YBBpUgQyxubqkL4Br06cfR9bBTcHRPj+HjnilGqCMYo=;
 b=JMqvaX/ZZ/xSU1gSf1M4Zfm2HBlVg4mPWUPmBiVq1CgQ0Q6aj2qVJcABZ5jSAn5BreDkeAtGvwXd1Rt/1vTWnZWuM+etJlRMM7SuLI+yn7KMgqIDL8zT3VV94pK94lfo6qERFaH3uy1/L2PARlMAp9XDI4tkCS62A7g9G7Ql9a0Ph5fjeiXOE+mQr3PcrM7ZFU9lyxG1m1V//wvAwnDcTuc/KiHtgBTqwJm48dtTjzHgzz1Bt9HEaOFQh/OBJ31kyPIkZe/O7LbniifL22skWaI7uOCdNM244kmBXH32PWnnBowgaOVwvlHZ+CBVAbOAtRJ2S/pe9yXPd3lA8lwC9w==
Received: from AM9P192MB0870.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:1f2::13)
 by AM7P192MB0788.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:175::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Fri, 11 Mar
 2022 09:12:05 +0000
Received: from AM9P192MB0870.EURP192.PROD.OUTLOOK.COM
 ([fe80::dc55:9884:100:6fa0]) by AM9P192MB0870.EURP192.PROD.OUTLOOK.COM
 ([fe80::dc55:9884:100:6fa0%5]) with mapi id 15.20.5061.022; Fri, 11 Mar 2022
 09:12:05 +0000
From:   Michael Graichen <michael.graichen@hotmail.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: ARM: BPF: xdpdump unknown opcode 21
Thread-Topic: ARM: BPF: xdpdump unknown opcode 21
Thread-Index: AQHYNSf9FyowppyXpEW229fq+rpPLw==
Date:   Fri, 11 Mar 2022 09:12:05 +0000
Message-ID: <AM9P192MB0870BBE4A20C11BA29954DC0AB0C9@AM9P192MB0870.EURP192.PROD.OUTLOOK.COM>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: b0935478-f788-3bbf-458d-c13ce36cef2b
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [F0TYdTn8pODa064OVh20KTx+0Pjrwz73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0196bd83-a716-4470-dcce-08da033f3664
x-ms-traffictypediagnostic: AM7P192MB0788:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cuUjljD5buWvyUuEGKe0z1iWBDtVZXnhN3ZIuU1Oc6R5qms6hYAhoZZ4/h4G9qCZqySY2ZK30UP3TUlwJ4Mn+xeLprTX5I7DMxSqEmvXaHHYiYCrBRjnZ452PEnpo9S+s24dxNxe6ii1IKnwe781fKdhWeWZks/beVii3MZwYbDYG8xTMTHTVH1cIBz4jPC/YqGQgx+62fAoTZANqgvaHTZCNgn/zP7b3yTof4+/281CFMewPZpTm7tTJ9rt+f+T5oCtnT1ky9FVfbeNEM55d8+RjoWAJy3IFX5+BRGpN0P8OobErJX8vSJIJuvJqe6vnJbTFZcjRHwXqplxmImOVDTI/I2wpj1Atuzn7xxi3PT+egyiJVrD7l0MJWpgLGLBGWJpGCU2vTpslFDDt6E2FSWIw6KJ8Takx68GWQmFOYcsKUGMXfpANCg/d6mfwp0mqhaBYSfNJMFiFJkJVmfCR5FSdRxZUpg7zJBCld6QF8Mt3rvG+v7viCDrtFgMDqSwTuXLolKr43tw1ERWX5Ny8qy+DSKxhTuuG5J+Wqm4cuzNwo87BGPVxHyaNTf57qAS75Hrx+rodWzt81ixrPGiMA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?CGixRtbVJY2ZSYgPHgtmp1aLRi6k3TIuGa2QvrAThe5TMD0BiuJaGS0tZj?=
 =?iso-8859-1?Q?cYUPYPy8phX6BkbtMIOhcKycRhl3aysIn7DKiEW0vwYyUWZDrfwvi+nCGK?=
 =?iso-8859-1?Q?vXn/vnG/9kiYoWxM6jGEfQxm4S8X1rRtim785/CPNj0UZxtvV1cbjPDqRF?=
 =?iso-8859-1?Q?xycnGD7wIZVBJINwy3+Xu3MDQKo6qLzf/siaXofCXCl5D+nV562q4TzZAY?=
 =?iso-8859-1?Q?vXTCCSCxfu5fJlB0McmxGFZHxiy9TVawta23FabInQscvPr7jJIZpdO9Xe?=
 =?iso-8859-1?Q?B+Yz1hV82nMkkrVQn4H1/UiwIcgy19in2Dy1BBXV3ct1sCJ7mxO/PfGx/1?=
 =?iso-8859-1?Q?KpiuvYXPLkdDYgNe4u/yBqkzeATHPStyOTYDCWIBzFFjoxskVaclWQ+TBK?=
 =?iso-8859-1?Q?CxtBnWZi9GPQf9v5BRoPhxB1vyC449HXgsWUXCIS64RHUNSlWp46Kz2Ego?=
 =?iso-8859-1?Q?ngElnP+cVOnrNMAMZyj1Yl/2Gi1d6ybMseE9pnBLouPjEQT2UZ5Fci8tA2?=
 =?iso-8859-1?Q?apYiENT8nNDrSCe8zHLHQFBhY/enX1bzoS3teLJbKXHkzHVWN2sOJT/bGw?=
 =?iso-8859-1?Q?0DGrpuP8Sba5Zo0KGHQQcCq81snwKDRhFoKO1d7UwDg3bQnanqDGyIq80o?=
 =?iso-8859-1?Q?/cTCvnpAqduIMDQE2PrvhCRj3UEQYc7cwC3NwmznRpJVoHG7YGnL3S3u0v?=
 =?iso-8859-1?Q?/edCI45t6E9kiTvX1qhiR9/NvvFx96pWx4NMD5BoGq6wtmBpQXnNl4rHML?=
 =?iso-8859-1?Q?O24fzCFAEqh89rPN1mh1NBpUl0j18poDJmjjraOLAsT25qDU6GN8I/def0?=
 =?iso-8859-1?Q?KOqTx6dwWOGf6qRWeSJ0GYu5uRKIUqCRh0jxDzjUJqeeK1yA7olojZVOGZ?=
 =?iso-8859-1?Q?XcFGY2V19UAyCickJmSypH2PtNp9SE4kMzJP5AbwOgdFW80pH1OiOmpz9H?=
 =?iso-8859-1?Q?FS2YaZWWQlQG+mNC/L7Q/qNy7TabOSCsFY+/IbkPWTmt4UBjqh5URxML8O?=
 =?iso-8859-1?Q?Z4gwd5eHPJ1gzhIF0RtUa1bwFCXQv/+MK1Db3sXqLV/sRb/NG2pOd/rmct?=
 =?iso-8859-1?Q?u6hksVndyNlbxpG4QSydJmu8w1rGCvCbKjA9S+RlcLEvzCWvMEnKoZ4jQP?=
 =?iso-8859-1?Q?WovXHcZn8TZqXK+ywLcEeUdN4xkNIMPDHFXt+lB+1fKfy/+dws?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-fb43a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9P192MB0870.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 0196bd83-a716-4470-dcce-08da033f3664
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2022 09:12:05.5968
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7P192MB0788
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey all,=0A=
=0A=
I try to teach myself how BPF, XDP and JIT are working.=0A=
So, while doing this I started 'xdpdump' to attach to a running program on =
a 32-bit ARM (i.MX7)=0A=
=0A=
xdpdump wants to load /lib/bpf/xdpdump_bpf.o but ends up with the error:=0A=
=0A=
libbpf: prog 'trace_on_entry': failed to attach: ERROR: strerror_r(-524)=3D=
22=0A=
ERROR: Can't attach XDP trace fentry function: Unknown error 524=0A=
=0A=
and dmesg tells me=0A=
=0A=
"unknown opcode 21"=0A=
=0A=
I have checked the Kernel source code under arch/arm/net/bpf_jit_32.c=0A=
and figured out that opcode 0x21 should be BPF_LDX | BPF_W | BPF_ABS but it=
 is not implemented.=0A=
Well, it was in Kernel 4.1 until 4.13.=0A=
=0A=
Can someone help me / guide me to reimplement this opcode?=0A=
=0A=
Best regards=0A=
Michael=
