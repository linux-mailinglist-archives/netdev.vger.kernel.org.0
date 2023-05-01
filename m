Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D726F3260
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 16:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbjEAO6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 10:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232281AbjEAO6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 10:58:36 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78E61A1
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 07:58:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CFzCNhOMrY906sBsQHNPjlqxNNT+wKp4UDdal41Rn4ZVMc1lpA0DCBzZteQ/aPS2w4tc3e11rFeJPPGSuADWnxK3v6WrMAHFL2PI3aq+NhECtlap+jVYl2kb3cuNTjO4PyCUfkVgDegWZMLTdOdxxSr4RGe2fniX+g3e3Vu8RoEt2kay8xO6J6RBFd8dq6Sha8O0qNvXqTPENo29IdmVXk1afXWfF7N3VDKjD22eDG+avXfP8oEY81rWYMWKtyJAo2aQ7Zg/wTDyOZSvhQoJtk2IrBQ2mgeVFjHJGDjb5cabC/eZTafmQXmEBcEfsQFuLZDLnzImJtA0AcQk0eZWew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I4wEDboDppL/A2vkTOk0c1gSgaE7ycsnO+kA44B+EWo=;
 b=Rk7pRE+OnOfdhkUUWYDrF0Qk0XtanIjWbiA29g7ZeQ4IYTAAUkf3SAJ8A/+Qe2nOs/KyD//Wmxtzi8pkMiNDs4n/4pQ9ld29T0CC0pBmLH4w2mVuSXvhWBxul7CQhh16dKE9wamoX7tUvs56i+PM85MF6+pYS+ONleyy7a9faIVml1IOw8k+wprG2YqhuK5ohCOLcE2RkzvLhduns5bj26u8TsntbsIGTUMKJW7visHGa9kyEo3jjCQ2yIJxoC6k7r4KQCjPIcgK0OlGqTiKR7BiSlPFzlsc4dFS3pRdvPzDKUlLa6hFF8pRiMGnzzG0GrJnMjAG8Vj854fwRpHCvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I4wEDboDppL/A2vkTOk0c1gSgaE7ycsnO+kA44B+EWo=;
 b=h5vWLXq2/jqP7Zg9Rf7y/5g0oRWV/0xvlAcPSa6bSsH+weEO1CISKwgCB8Xm1usJLpD2rUlSxAt8I1zmdyZbilAioSICNnbOmdqgtqhGEPN6N5L2f4eEaVzUhFdbTmSNLCc4/5Uo0fuolLUWq4ZUAWPMvPi+35BOE2YR/l3CE+Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5376.namprd13.prod.outlook.com (2603:10b6:806:20f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Mon, 1 May
 2023 14:58:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 14:58:31 +0000
Date:   Mon, 1 May 2023 16:58:24 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org, brett.creeley@amd.com,
        netdev@vger.kernel.org, drivers@pensando.io
Subject: Re: [PATCH v4 virtio 04/10] pds_vdpa: new adminq entries
Message-ID: <ZE/TkDUYwpVzv1m9@corigine.com>
References: <20230425212602.1157-1-shannon.nelson@amd.com>
 <20230425212602.1157-5-shannon.nelson@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425212602.1157-5-shannon.nelson@amd.com>
X-ClientProxiedBy: AM4PR07CA0036.eurprd07.prod.outlook.com
 (2603:10a6:205:1::49) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5376:EE_
X-MS-Office365-Filtering-Correlation-Id: e85e8c85-2e1e-48ad-667f-08db4a548724
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fsREvt7uOElWyWDrXF0CEKXYpqVdgI358gokdVuFtEz4txVJlM6CbOyR8BJNPIy6E8JCUX2WKTON7vLRPIon8o6KVgvr9eXyJegf3j7PXka5oT6No6HdbO/Tzee6auSRbhvEgCMcXfuQQRplihcUTp8yy5pZPcbKU+PpkJyv2i6BCsT1vjQvpfZkDzYltvjK5lZ7CrySKdQ42M2iyCZ7TDdu4+nzns/yu4KoT5NcF6Df7lqevvfW6VBVH50kRPOG6wyknca/FprOuPKgjVYRaRTL3yKjpU6hmYR+c9Vl8vYVaGPdmi6xMaSMROeuiNYWi9JOjhsuuQ4Cb0xVVyrbGBSRyxa765l3XbLyuBg/OECfyOAn2y0vK2xQ2okpw41HBEDiev/yu/Z4ovpE+uVgmPq7fT/aM7OphIwA9SfY9EdMPP2ys4+bZBF8Svl+Y+WgWba9xt9LH6aPz2Bpsxm51056qXmlsfuLQ6kqDhmWgg7KhiulHP3FXNpjpd060LI5CRbY+LLsxUlCSoRVYL4t2fDlHiVUYphz0oNz8z96pWZVu9ATyFyiqoZS56pBga629WOgk8Ulo36wm603KXcnL4cDU8r46BrInPvYWsFanOU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39830400003)(376002)(346002)(136003)(451199021)(316002)(41300700001)(478600001)(8676002)(2906002)(38100700002)(6486002)(6666004)(86362001)(8936002)(66556008)(83380400001)(44832011)(558084003)(66476007)(66946007)(5660300002)(4326008)(6916009)(2616005)(6512007)(36756003)(6506007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qN7/pHEep/vPtsSQuNOiqzWSWbfIpNG+K1/EUhVIpfqz5HZLXpSduPS3PD8C?=
 =?us-ascii?Q?rTkvhp9e7uR9uoFan+c6C1yjm5mo5SoahpoGnPjzxvCHucgAbDtfWi1nJXQW?=
 =?us-ascii?Q?em3BvYV9IoUtElIl3PoHqJhkcmBAMrtqQZHQ5ZdiYXMMKE/jDIj9B3+N8Ngr?=
 =?us-ascii?Q?fkf/l2/hTaaWTvwtMdGRj4FIeTT/T0k3wd5eQX9tSerMU7ndNEUMrChBPrry?=
 =?us-ascii?Q?99cRy1tBvnnBem8LPX8Hbwnmmizinui4Qedly04IbJAVtAowGOqCcUJ/yQr0?=
 =?us-ascii?Q?d4sxa1U6bLum5QFy5j03G/hnn0QIAL0JDirrqCVUkhk3W3yEbQJ/mgRZApcE?=
 =?us-ascii?Q?RU4qvRpoSt2c0ULV9HctO9S6hLhEuHz6Zw26JYAJauFyjlS18aDDB2FFGuKo?=
 =?us-ascii?Q?QchoqTLWd1z+mNOM1FN61KoeOEV94uE2NIo2t6AfO6fkGDqRBT+CkYHnuJ5W?=
 =?us-ascii?Q?wg/65VOkmtPzYhELnx5a10NCmN7xCMFXCH+lA5TTRaRUO3HEKdo4xhCNZPlz?=
 =?us-ascii?Q?ZSgB8U3GTwEWIK5U1IRql+Z/A6MY5ZjaxNJkmNkzPeSW4ZJ4z5jAlix2ni6Y?=
 =?us-ascii?Q?tjcJek4/nIkN2Lrct3RbPe3hTR2VB6vGvnv3T9oIU/SEm4hjX3ciGqjJOMUH?=
 =?us-ascii?Q?9nPI2Fw9SEqN2HjrFiBVOLpT+MZddotOXhFHNVdLlJ/i8h4vRJjk9D3fB930?=
 =?us-ascii?Q?3caq981e///6LRXeR3MXv6Sl68vEsfeprwNUku+7h661ShazM4YIqmpqJY9A?=
 =?us-ascii?Q?PgijoUKodbluteeHpfY7DK65Q55/ahnHmWar0WYu2C6dgxgCuXxG3N9KIcJv?=
 =?us-ascii?Q?mI2fzh1TsRedGdofPxS+ovIRg1ZmOv+eLU+ezmLPDTXD/9BIWHQgjt4W9mXm?=
 =?us-ascii?Q?oLlCVwG+M8DHc6Sx7OmM5ZOPStxjcZHB/te6AbEgCshP46d65T72Fzwfmo4M?=
 =?us-ascii?Q?5sST5KJIhABDO2ozk9wIDpytm9Ss0kH99zpJZRjliIMVTv5jm3T6Qm3MPWfv?=
 =?us-ascii?Q?2MJ1kdMzW/X8UsV62YEzR6AidNbUnj0na2lzXrJ4Vlitdrzs47I9WOzsS9oc?=
 =?us-ascii?Q?laxQumt3JXSi9iImFFbya6uyO4wgc5LN7IjAgxq0sJIKO+fpp8qT3B266SqK?=
 =?us-ascii?Q?fmW/ivD0ok6KdL+d00sYmIhc+FvRFk2AN2okl2pr866i72NAMM5CLTSUWGn5?=
 =?us-ascii?Q?fH3qkAoGhFi+xsmEG+icXJIQYU8Vyg9YZRPYLBbOQ43gEVHE8LqJGZs3ZP06?=
 =?us-ascii?Q?1VrsC7yr4d2Xxe1ExhqvuVBRRH6m6OECpF5yPjCO/aL/2DCRagYzvwiegcxZ?=
 =?us-ascii?Q?DQ7hosKwXFZn+DSDiL8zF7rc02FHYz97MSR5VKtvP47PgorCNZgau0P33Jjt?=
 =?us-ascii?Q?aYlFcSRI7rUssD9Shq5zDeYDbYZ+5kiD0LL4I2tukI+qZL/J99Npt+8UVdzr?=
 =?us-ascii?Q?6vaZn8LSjhNhHpH+Rr8UGRXI25KMEW5VXG+0qs9cy9t7/+V/maIrqUC3D9vN?=
 =?us-ascii?Q?JAFUftrIIBMu85G4XAfI1tUn/9+eAYTCinuPHBDU2axOBvsHcVrhqOAVH9OV?=
 =?us-ascii?Q?u+coIzgj6XyR/tRRpPTKvLIXmCksrlaETLPspb/cfyijH2ypWjfUFfRltJkf?=
 =?us-ascii?Q?FabWWzpQqOdVB80bGIx6oEmVYUa+ptlCx92Eb/3oKy2BcVaMiR5emJjk+MMP?=
 =?us-ascii?Q?Vq9C7g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e85e8c85-2e1e-48ad-667f-08db4a548724
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 14:58:31.0232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8wMwG26HWMnNOcvhQXYBYqAdIi4bc6FKU0CX197WR13mPlDXyFsbYtrZlIBl7jr+J+1d11EqZHnZ9+8tWjugUQTqW9SOadqGilTFq4j2LuM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5376
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 02:25:56PM -0700, Shannon Nelson wrote:
> Add new adminq definitions in support for vDPA operations.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

