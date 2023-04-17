Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4A36E4701
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjDQMBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjDQMBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:01:10 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2127.outbound.protection.outlook.com [40.107.244.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55076C6
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:00:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e9dPzoD5g72mUr4Fc6cwF9BWRqQ1n0SC9VrDF0D1FAjRSfcMFk2C0ZMUm8PnQEmkRHXhxuqDWXeecJBZbQDB37xPSBMw6HldRMw2r4+Jl3q1uElVK9xKiW+nlvF0mrrE9Vh0F1tZ+tXOo4MTwFzZxGHzZHdUfPX+6lwXiSwnkcH7eyJOK77USQrAKWQ4iJYSSbJAyb3q/sKSjgHa0dUx3C6OQ676+tVD0BaH/NXH1AYHpeQYbPS3ARsABOyyPJeB8ZW7yd8cClUFgA4u9vqibVhd/EnSaW1E2qQQ6fWgHWTKFmg1ix1oNm3AN+rYmWBqaseWysZq7NVInWTIlTxdOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DohwT5IchePYDpibA/vfzjLjmOY6oI97WHL5w7swp/Y=;
 b=DboKYAdj9286wCkKPgms8U5FAv2Q7qmxgS+C5Sd5CXpLjMQIezTL1V9cZ8yOnrPJEcjqR31q7rpxDzDRfDrcgBP0DajvCOlFTJXepMSF6hTZYH2/Qsr/z6ZAOFre5+fhbLBPB/GqHFLuPq7P67WKSKxDP9iB7oQk7Zpdcgf3b7plLjUVLR61oO0hfAzXLFst6/Mt0FRy2+Ed87uHQhgNgAO7nbD0bOxm5yWXlTxqk1jhGWVo/3bU5Fm7WMFCWIluccW5YeDFGp+Yd9pSvfEzZdLAgQIYROytOk1A1cefjP8qjBgxdZFG9wmNy4r/YhV5KXSNX6qylQl+sx2kWkPZwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DohwT5IchePYDpibA/vfzjLjmOY6oI97WHL5w7swp/Y=;
 b=tYhXiM+oNnr8dBzDyfTSh8FUqMzu8uGy+DNrNmLm9vSdFokwnLsMB3LjWwhPtWGB4zG2Ghvwo+Gno0+ny+OP84/wBxAiIP9bMpg/un1yUc7r0aeBGyM2L2YRRTbZzBgBxaXSoEMBvPkUp/hxRFXhQm86s6TVagQNhF40ew8goyw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4627.namprd13.prod.outlook.com (2603:10b6:208:330::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 11:58:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 11:58:51 +0000
Date:   Mon, 17 Apr 2023 13:58:45 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Michal Schmidt <mschmidt@redhat.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Michal Michalik <michal.michalik@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Petr Oros <poros@redhat.com>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 2/6] ice: increase the GNSS data polling
 interval to 20 ms
Message-ID: <ZD00dXsbi+teQJ5E@corigine.com>
References: <20230412081929.173220-1-mschmidt@redhat.com>
 <20230412081929.173220-3-mschmidt@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412081929.173220-3-mschmidt@redhat.com>
X-ClientProxiedBy: AM0PR02CA0114.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4627:EE_
X-MS-Office365-Filtering-Correlation-Id: e68b3938-d967-4b8f-6796-08db3f3b1c36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AJaKUm2sas2B0u9GHVvkoXyoSrlbkqQ92KIC93Y+nw5oJ74pivBDMF7bMirT8oOKtwTGNKUPjlkWcyGSIAldTRQuio0XTzLwfN/ZhZZ6wjlZFDgBjltEHfVvLpLOPn6tYJCILcuQTadwYQdlpUIrfqNG032Da0l+C0niT8yQATZOnN4U75KvPShfRkXMs59vquR68xG82aFkDs12+Of16P7OGVrU/e35xc1+0spoedDVGJz9WVMCNKnTgEAnSJPfhpfI3p6ioS/twoSQ+rMIpoD4V5501+BJJeHJpce+Bz4J54V+r8uxkMLbKLj2q7zv7xS8ehSyLk2Od+K+PluAT1cL8EsURvBJ/xfHpmgfuPO6qnD9EbI793bg7hnzZJvttYIzZ6sxffi55TegO1yBuPbks7nYrG68kruNn8NaqRKQHCbDPxeAezMMl2B8qxGIhNmsNPMQTmJV9LmkiIT1xuxkdxTBWqK51oc+VJaxrXnww2IISM6tHMZBcQJgJepSgwNdxuuXuerXXjVUj0W+9cb4Y1OWnsxPEBcmddCWIxlp2icwZe0kf7uFSD5DYzfu3/u/t8bZZQM61SyPij9nDvJpIsePbiljZhrxwOZ6ce8rZzcOLq9ez4ynY0GWLTG4VQWc1D1dozabdBlRgJdrAMNyZFXf8q4qE2lKr8utXrM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(346002)(136003)(396003)(366004)(376002)(451199021)(38100700002)(8676002)(8936002)(44832011)(5660300002)(7416002)(2906002)(4744005)(36756003)(86362001)(478600001)(6486002)(6666004)(54906003)(186003)(2616005)(6506007)(6512007)(66946007)(66476007)(316002)(41300700001)(4326008)(6916009)(66556008)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NtPkGUvRZlBJVjo3iENyYcA2kMZHWynSmQAvLx01KKd5C+Hmg6jB+re/N9fe?=
 =?us-ascii?Q?tTwBUfCyPO6ui5oBnCfJ3SwyWyoWT/0cQ8EhGZztu5YlRMn5mquNClEHEgnY?=
 =?us-ascii?Q?UDhmNPLlrv/N0/Q9+QO8hSHQ77o7cGR3u38xg6IvFR6LnqugBdrJ5/kU88T+?=
 =?us-ascii?Q?1vNRzkQU4p87PYXuq+3piPNL7o6tDX2xh3tgTuLe3056TF/zX9a7O3SoAW1E?=
 =?us-ascii?Q?yZL+SoxNggwmPbYX5MWOt8Ztgl3UE1UJuEoeU1A6wjsBe35LtKK4A76cL6pU?=
 =?us-ascii?Q?hvYeO69puXTEkPEL4k4PUgkc8ApzmiU4YuQXpgiIZWuFrvzIlzPchYaduMhl?=
 =?us-ascii?Q?JzM7j9sUuHS3LjaBzKalR/vZYFiAS7ThQMp5RfLOvZQsBEByhvihfCHSCv5G?=
 =?us-ascii?Q?beby/2xC8SqJo3dXWCHGeKLhjMNshWivMdewHtmszKVu5YUXgUUv6biDorXK?=
 =?us-ascii?Q?ls3d5iLUwqBDpzR9pB962hX02AtrTStV+roRuVCQwyA8mo5afVCbQAltEqD3?=
 =?us-ascii?Q?W/lZ0BeRF4ZOaN2ES+Kfj0hmhPgTWk3aBsfv49WSp+ZzYw7C5Gm+WX5NvuJn?=
 =?us-ascii?Q?b73Fu1RroTMCxMgecPucmz5+3SOPi5OU50Rzm/146MhuRJuZEb/Hihukq23V?=
 =?us-ascii?Q?wauhMH9xMTl98zIYV3e47WOb4KTJlCZ35UM0z4/eVNLRfxCnzguEgZqh8rqc?=
 =?us-ascii?Q?k5840jjVmgmNrrdri6kmNtaF+SaAI9gYX20uazA1Y6jwL4yq2MwumD8yv0iM?=
 =?us-ascii?Q?6sBLW3WSQOVQaPIOa4Lyr1bbgKvAadW8R3OiSSU5FHCu05cpvcCCk93T8ROL?=
 =?us-ascii?Q?HLNdAkW6AQOKcKlfonap26rZ5tQH3lqgWu3ytR0pi/jFqIi53B/5De00Tu47?=
 =?us-ascii?Q?xSkXz1HNaGkRsqTk2gboT/lvVO88HKfksUAAP6BaCvpARP6vOzLq7OEUtgYq?=
 =?us-ascii?Q?SMbT+5atqZtLNTapzgEgywAGyCxCRhcVNbB09yZhOUOp60UWahnT8XijFITC?=
 =?us-ascii?Q?1nkH5Xh5w5XNoN+e7NckQAWvTaBCWYk/0uJJlO/UQ/5rA494f1vl9L77wfPO?=
 =?us-ascii?Q?GrdhYFsE9PZXveq87EZ8qjB4RhLAbugwoMMmbz5pcDSqG5baPtL1AxcA/Orr?=
 =?us-ascii?Q?iaFSqYeWtgLSC658uWueNfQFDnGsLqNy+ZjPfrF2ttQ2Tit0aykLoOrtQA7R?=
 =?us-ascii?Q?MxIhxjtBcQPbY4/urdZipjNY1TYkrmvASQfrzhzwgrV+G3LcVrs9yVPs7GXy?=
 =?us-ascii?Q?7tYitH6OEfvWwp25lpweekwg6MfYY+bJDh6ZzA+sKxLYFmQPsxxRkCkzmd+s?=
 =?us-ascii?Q?clEJ7Jp0yMWHxYNWE9LlaPzATyJ2sNq1vszmjgTO3U7j8rGsHd+sySRcFkS/?=
 =?us-ascii?Q?2FpTe/clIKmuG6ZzxJVyhOf0pAPqaeD8bC35zm7hYHl3XmV41W+wq3gllWGk?=
 =?us-ascii?Q?rJKYqp7aO884OXmRWhhBZ415QgKsWuzfdQl8OxWpjZnatxdqpqUlfvqYo5bU?=
 =?us-ascii?Q?hCJnkVvVbLAP+ov2SYhRIstzDFvQv+mHtKNUOMN0ksZUzHaxevVIw/o1UBRE?=
 =?us-ascii?Q?DuyBOBdkOESzjeJd24Yb+Xj137z8vkBioNKfNuXMPnjpPv+nDVzP2i4p8Yk3?=
 =?us-ascii?Q?5ccJMZlv4/Q8lPjmgyBZL1CiLsfxueZ/YLVAKk8Lpd7RWFvMtfb6CB53QyAz?=
 =?us-ascii?Q?8Lo45w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e68b3938-d967-4b8f-6796-08db3f3b1c36
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 11:58:51.3087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WnFbmjyfHxbKer75pt38zyyNWj4HiSogM3P+CFJfjbNNO4ML7NX0gYiJXERGqmwdzIVwxNqIfh+ITKYAcCIJRhZTovQXXtq0uGyue1SR7P0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4627
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 10:19:25AM +0200, Michal Schmidt wrote:
> Double the GNSS data polling interval from 10 ms to 20 ms.
> According to Karol Kolacinski from the Intel team, they have been
> planning to make this change.
> 
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
