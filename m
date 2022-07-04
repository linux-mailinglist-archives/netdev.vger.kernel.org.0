Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A07564E34
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 09:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbiGDHEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 03:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiGDHEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 03:04:38 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFA51A0;
        Mon,  4 Jul 2022 00:04:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kg4Qq4a0c42os8lZWkWYxWlnuTZ47sR6Fny5pAmJjv6p5tDo9+A54qIL3lU57v7AyKwSXkpWtmLkQPEoBX39TaSK3R4Yrp9AMuUYQ1qPlJVXBBSuv2g6U+XDNfN/9tkgIDn7ZmEmvuats3Cb/ghBywKVeFN1cV1aGBj+AI6ujWcK6oFRGFHPyih76A7Tvr5kTLWPxkg+YC1VFImzizdyfAZG2RiPibIVCUu4zA4YI+6GBc1Up15LOcaTo8rx9K6VJXUW9zkZJanbJ3fR3SzUFBBCepaEmdrDJPQAMHb0mhOYjINtZdlzx1xXl3RWZjDbeMbdj17AJd0xtX1zwP3+Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XE3AH+HjgoQMymQl5iIm2mGl8v3jjxdIbky4kpdAtko=;
 b=XF/0APkakof2ZUtMsJlDb0aaVLd9relRIn/PTE2xFGMIPEOwOD7KvDJbCjzJaU1bg+mNjx+sPxsrs1SY4s8U0mAAq4tlj9ki4/HIQlSi853B5LmS0ZaPV8umEcPqgVPZi4UPbtqTZ5QDIV0eMl/TSC37ishDsr7XFfUR/iBKEPRoObWgW666UaLCihgYNepOObfGJQOoGnkFkcOTTNw6rkPSI0owXB/gMwLLHEzZELnJKgiwcEblqLc8kNu5fzqGPUv+CQNlmw7BgtttELaxsfFfO4Feil+UXvcgdGA1hGRqA0w6WPACUpZatInGAfc3zhTanI3WBYIFfyUOqKFP6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XE3AH+HjgoQMymQl5iIm2mGl8v3jjxdIbky4kpdAtko=;
 b=e/GZL6DXFrFywnzhN34zTKVeeotyBMW4zVb/bv9aowmpU0PgMr7tU86Ul4k/vxaQwe8C1F5OV+j4WMVabJrPURqqGP/tqZ2vavu7pZ3eKBb53riMxXhVviYkLAyQethbMbYx7Y5HhILALN6tnVm89jLNCzBXWJpT/udoGmTV3IM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synaptics.com;
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
 by BL1PR03MB6088.namprd03.prod.outlook.com (2603:10b6:208:311::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 07:04:35 +0000
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666]) by SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666%6]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 07:04:28 +0000
From:   =?UTF-8?q?=C5=81ukasz=20Spintzyk?= <lukasz.spintzyk@synaptics.com>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, oliver@neukum.org, kuba@kernel.org,
        ppd-posix@synaptics.com
Subject: [PATCH 0/2] DisplayLink USB-ethernet improvements
Date:   Mon,  4 Jul 2022 09:04:05 +0200
Message-Id: <20220704070407.45618-1-lukasz.spintzyk@synaptics.com>
X-Mailer: git-send-email 2.36.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BEXP281CA0013.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::23)
 To SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4be881c6-c2f0-4777-8355-08da5d8b6fb7
X-MS-TrafficTypeDiagnostic: BL1PR03MB6088:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XPGtUKoE8opqmhGjOppS+Fl6l2LS3j/LJNMfnAeLLaZ+iPrxscEIbTLJNy785fEl3pjPFPnT2HInRZQtM16F76Bf2tJDP0Jdfaheigl/7Ek2NYUTKM07639J0B57bY+Xx48HN4OodkihnSs0CTx4PPpZcOLqU9A37T7rhz9pjHu99KQEXChnRILgEPucoxRo3tXcb3h2pOtdqwD+PJN/Qjnx3VaUymfpyNSgKEW0D6d9F8nAnmnTruLzNIRbS0s3u+FWSnPl+C/W57f7Iv+ILU3dEzOrCDcpNLnsz4Cc3/KuLgpq1yDtLjbXgGbzpqYE1YI7b2D0Youbk7OMuxlK2LG+94Pjs3NOkiXnf6B56LVLAwPZEKT6C10yP7DiEZ/kN1+wRrzVAN0UHvZsamW3Qd54ApWX6JCKnFbH5pWuaRFHqfmVQDOUsP4dP1s6ADaFQhdlMRKr9piYiV21RmmMV9zuHPg3Ic8+6lcYxUlLvhiAk5QNoStMQ/UGGqOeP1axET+7ZNp6lqNxs5zF+tUucBZ92byZS/OwT3PbAd63ANpZcxMsyFDapljXsP48OxrmOs9bIbhQJBdcktwen47GRJ+IZ+4d57J7Ark6u+UegcP3f68F9KbrSEmUgPupW3jtOLjF9jFok9IiK1ysP3A8pvoy3cA0qR263gajdNtPKecukFqmWUrY+d4Ga/VgV5sUxg3V/akK8+EZJgf/5wXdpCGClWSOdsBZuxmIT+pxglU+i8oKvi0tLBRHn8iV9f3+dHcZwfYmqBgfRnvPcJKTW8UtEhDB/+y/yeC9krpARDo+EUExWXLgwhfpolSvV4Pf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6533.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(366004)(136003)(396003)(39850400004)(8936002)(66946007)(4326008)(38350700002)(38100700002)(41300700001)(4744005)(316002)(36756003)(6916009)(186003)(6506007)(52116002)(107886003)(2616005)(2906002)(6486002)(83380400001)(478600001)(6512007)(86362001)(8676002)(66476007)(6666004)(5660300002)(66556008)(1076003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NCtBVGQ2VWt3ZkJYMTlqeFFnS3J5MzdZTUhpUzB0eG5DVnhJODdzNFhRbTQz?=
 =?utf-8?B?c1h4MGVhaGYrU0p5d20rSnZwOG9SaEdiYUhTeDJobWhFRDVPMFlKSjU5ZWox?=
 =?utf-8?B?d2htM3MrUExNbzFwaWIyMDB1dVpKNStKU1pmMnJWS2U2WlFhcTZnMU5vUjlH?=
 =?utf-8?B?VWJqY3dBTkhseFVlYnlLYit3MzVmS04rK1NVVE1tSUY4NGg5Y2FSSWlZMHBv?=
 =?utf-8?B?enZ4UE5wUFg4a0tRVHpzTW1yd1dUa3NDTEM3WVJtMkFhZmNZbVNEMDdqaHg3?=
 =?utf-8?B?MVpMK0pDbXZlTTVYUkdUV08zUjdwcC94SThEdG9OK3NZNlJNUlR0WEF1S08v?=
 =?utf-8?B?dWcvSHBqUVlNckYvUFEyRm9QL1BSM3ZjbFpTWUQ5a2lHRVZoTGJHYi83L0RV?=
 =?utf-8?B?b1owUjdnTWtlcFhORTMyYmJaVjQ3RHdsNTBWK3h4MzE2c25sbGVvWTlYVDZF?=
 =?utf-8?B?bnlTdWV3WnpQMmEwK2ZPKzQ3dUFQYm5ubjVFVStabnBvTDlucWFnVzYxcmtT?=
 =?utf-8?B?UzRuNXk0QTFDRWcvbkN4U24remwwSW1Td2lVTlhWQ0dRejAya3F4bjVra1R4?=
 =?utf-8?B?elYwc3FCZ2w2YTZGSm5ZMy8xczFWV2xQUld0SGcvZmpwZkoweHNYQjZCYUZZ?=
 =?utf-8?B?ckRLMGVObjgyS0RwQ3JSSXptYzR6bVNqbkM5Q3RmdkdUMkQvanE1c1Q4UE1n?=
 =?utf-8?B?cHpWVVZQcThrZUpUMGd1NmQ1YU9zQnNuTTNObkViMU5EclRqbkdTUEs3UVYv?=
 =?utf-8?B?TDN1aTVpcHlMcjkrNEttNWQ1RE5iSU9xb28xM1NYSWI5Tm1WbXBabmdEdGE4?=
 =?utf-8?B?dVlWc1pvbVdVRW9iTXpXUjlkY3psMTR0bkJzUlZwR3ZYOFRXcWJEYnJJYzFN?=
 =?utf-8?B?TTJuViswUVpiSUV6YXB1djAzcWhDcFhQV0NCck8rOHg0Nks3eUdzVFhrMkNY?=
 =?utf-8?B?UFFJdEVXS1p0S3JqNDZCeGd2WHVhQ2t4UWpyVFB2ODJzQldiK2JCcUZSSjZ3?=
 =?utf-8?B?aWpQTHczQUxZUHUzUlFhV3JLcUE3WnZoenZkSTlLcTFtMzVxeWc3bWxPcFRR?=
 =?utf-8?B?RTh6aHZxYmtHQ3Jzb3lCQUJqYXVxQUFkRGRvcGwzYkNCOC9ROVl1MlBKQUZt?=
 =?utf-8?B?QXpsYTVIRjBKcFhzQWZWSThNTTRxbzZYZTB6aXZTSnJtakVYRVVrSTJPZitD?=
 =?utf-8?B?YUoyMk54ZnpoaFpkWFF6cERJMUE0S1JlcGFRQ2UyVmwzY0p6WGJuekxMRHZv?=
 =?utf-8?B?a3IvRmsvemJ5MkV3R2g3enlISnRlTFpET2dnRTdyMHhkZkJ3ZVVSQWZTYnN5?=
 =?utf-8?B?NkxFNEIxeldJdFh6K0ZkeUlEdWdONFc3Q1AyZ0lzS0Myb092VkhkU2poYlht?=
 =?utf-8?B?RHIramhuTnZraUR6RlJGUXpRUDZtalZxRXlwZmtFY1lzWkE2eERpbkdPY0M2?=
 =?utf-8?B?bXF3T2d0cWpMK2h5SG9hNHRVM01FT3piTWNxK0xLNExoZWNQMFY3L3lFdDRz?=
 =?utf-8?B?TG9VVHN6WFk5akxrZFdIWVBhL0ZtSlY2aFZSVU5YQVVaczEvVkVnNzczM05O?=
 =?utf-8?B?a3d2ZTloVG1TNyt5azZzRWRJTzZOVnBVSlhid2pYS2VVbTFpaUZ4ald0MG1W?=
 =?utf-8?B?bzgxdUNyTFoxREFOeHdQZGdPMDJnVDA5RzB1b3BoT0FMR1hBMVBLeTBtY3l6?=
 =?utf-8?B?NWJONmU5L2tsZE5kR0J5UEZqaTI0bEJJTW1qeGEyaWVCdFNSdDFPYjFHRGhV?=
 =?utf-8?B?VGRHWElvUVRDOUFZb2NiYUtzYmhzOGNlZWQrbTV3V3U4WkExdnFNQjZzMG00?=
 =?utf-8?B?ME4wa0lSRWNjT2RPVG5YNVNOTGlacndWUnljZnZGYWFUeHppWUFJRGdiZHUz?=
 =?utf-8?B?SCtBNWxDNlBDdVFVQ3FLVjFPcFc1Z2tvbnNRc2JrNGZWYVB2RkFjZDAwZ1pH?=
 =?utf-8?B?WUVRVHRYNXFZaGFsZ3orVXBqejQ4M3l4RFVjUFdOcVY4WVFBZGRDeEhsTjNH?=
 =?utf-8?B?QXdIa0xQVk1KZGRDbVZsQTZ4TnpNZXBjOW1CWnFkakttYmMxUVBJdjJNeXA5?=
 =?utf-8?B?cnRjdU5wWlhOQUY5T3UzYTJJTkZTYlFQRHU5V2MxUy84cHhSWG8yOVpzV25W?=
 =?utf-8?Q?tHZS3vB5nG3/lKWgzuBJHUs1j?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4be881c6-c2f0-4777-8355-08da5d8b6fb7
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6533.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 07:04:28.6087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xFLf74WqLlIhHv1nxIfnYN3RSO+D55W+C1KsMdnpk6lQkW7uAhsn2oQc0AqX9Cx87NY1a6cwivqIAVe0K5/bbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR03MB6088
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I am resending that two changes again.

This are two patches to cdc_ncm driver used in our DisplayLink USB docking stations.
They are independent, however both of them are improving performance and stability so it matches Windows experience.

It is improving the experience for users of millions of DisplayLink-based docking stations that are in the wild.
That tweaks of NTB TX/RX results in approximately 4-5x available bandwidth improvement in extreme cases.


Please take a look. 

Regards,
Łukasz Spintzyk 

Software Developer at Synaptics Inc.


Dominik Czerwik (1):
  net/cdc_ncm: Enable ZLP for DisplayLink ethernet devices

Łukasz Spintzyk (1):
  net/cdc_ncm: Increase NTB max RX/TX values to 64kb

 drivers/net/usb/cdc_ncm.c   | 24 ++++++++++++++++++++++++
 include/linux/usb/cdc_ncm.h |  4 ++--
 2 files changed, 26 insertions(+), 2 deletions(-)

-- 
2.36.1

