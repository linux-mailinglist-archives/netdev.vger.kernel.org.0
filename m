Return-Path: <netdev+bounces-4917-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A950F70F2A8
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:24:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FD22280CA3
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:24:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE229C2EF;
	Wed, 24 May 2023 09:22:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0A0C2ED
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 09:22:58 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2113.outbound.protection.outlook.com [40.107.244.113])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349C2E4A;
	Wed, 24 May 2023 02:22:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dwk/4YiZG75+siW5Qp4okVpXzSRBBSY44/PrS0It0MpOOg0Zjv0OmDxBk7NQ8kuvpOqlcFNLcFzVfTN9hdOrCSppp3CPNHa/Tn8EVYgorL+x/2MDrqqxtTNbLlUTj9mPC/VpJdwat6lM9HR/TVTK/DPE8YoYKK/wCdS27/ao8HXYZ+ICztvK8DWja197kpQXrqznCdzcUxWyZAKSB29AwQ8wLg6oUN0kKp9QYHvts/QPEhdj6j52y2Fo6GtmGxOPs0Ff/UJN5YplLQQF44ImPgwuZboo8gYkwz1XF0BG50UBK2c9oq9dwkul0Wiyz3+r/y1v84+AjYWmy1ZYPWn6Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DPuORpZ3IY8xr83rr3y0Tm223oRubv/qR+hsUD/I0II=;
 b=DSBICX66mpkxccJS9zZTBYmLhRkt98hjjmsQiULwy1HWJwCSteiPy4bGrKYAnb9aIEyVl5MmmZet72I/ZAF3ZfYnel9lcbKsjiFOo1qWHl+E+xwUwsqcOu7vKp0ThIhLxRJmjpPHT8CB8S075Mb8oKV2CvnxCH4xoYRjLCSVmT18sP7mgmhHsczUvuSd6v2G2lHMMZWF1d1ds6fYLs6j6fEdGvqYArHi+xO5o8qBcPJ6xcZf11ruRJJE83CbCeowA0U70lHEUQZ62gXnKR8639H2eeVm1ru3aO1v6waFctULLxX4hGbU36U4JwH8xLv/jqzSdhNQI5Q1epaOXdK6jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DPuORpZ3IY8xr83rr3y0Tm223oRubv/qR+hsUD/I0II=;
 b=NJtmOpDEknY/jDe82mO3KMDVT8Ux4RzUb7RrWBr27Y6E3UnCI9ThyigA9Ya4ZcQeAjA0JSo+jno9WnFiTQXCeYQnvGYBkynyNl6KoZASw+dQ7KpHPLyvIG2ZAfXEPs0sVzLaPqq1BK9RyJrZqLuB/MuWDZC4SaCbDCAEcEQgOEI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4425.namprd13.prod.outlook.com (2603:10b6:610:6c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 09:22:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 09:22:30 +0000
Date: Wed, 24 May 2023 11:22:21 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	bcm-kernel-feedback-list@broadcom.com, justinpopo6@gmail.com,
	f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
	andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	richardcochran@gmail.com, sumit.semwal@linaro.org,
	christian.koenig@amd.com, conor@kernel.org,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: Re: [PATCH net-next v4 6/6] MAINTAINERS: ASP 2.0 Ethernet driver
 maintainers
Message-ID: <ZG3XTeLb/Z5aoi/L@corigine.com>
References: <1684878827-40672-1-git-send-email-justin.chen@broadcom.com>
 <1684878827-40672-7-git-send-email-justin.chen@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1684878827-40672-7-git-send-email-justin.chen@broadcom.com>
X-ClientProxiedBy: AS4P251CA0027.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4425:EE_
X-MS-Office365-Filtering-Correlation-Id: 92dc277c-adda-4503-69c3-08db5c3865cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tAGCLnogI57S0RsUMFdx1O5/vABHWUKYw7mxqVhu8kn4853UuFACU/R8TwSBF0mGeMcQkWFvurRzFgZ+OVd+Pf0+IBTidASe5FabWxu0QtUXxsQVW1aWVHD6/A0olJxIWewvsbrD4c4aebH6h9Ct1381+eWmJVHB4RY1V30F+sSqR3k2bNi/tXx7T+e0IwDKtCjdOi5SZTW3U+ngLyQQxhgQuaxGolE/OZKVI3ZKjkCaQpB6E83I4+ps076cOHYR33XTI5BLQwuqjTSYNHB8+ygCwYn0oRhugWI7rkxTHJPkJmNvJ44ZOenD2HZ++isFctu2zbpyV3h7NFo6z7HM1xDgpGGOUToYB5iZfAOaqMxiAzj9xCpLSI/35UzK79ZlQp4PXXI3FEHRivITXAD1wDDoY+u3WcNiOvZ1rU1/VJImn97t1IO93G+U17tDMunCAGk8MxsuvntKuLyVcIT9EeHJBB56sD9PmoqL0jAEU6Cw8ubLKl1uCtWTZ8OqyB4SNzN30y4kbBSNM1auMTHOAl80Ek80Ia4KAYW8EROurWpz5pCAb3webpH7z5hWFx6pWlMtBeNsmxNM67P4y7iQj3V/rNYwDP8wTrNi1mFY258=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(376002)(346002)(396003)(136003)(366004)(451199021)(7416002)(186003)(6506007)(2906002)(6512007)(558084003)(38100700002)(44832011)(36756003)(2616005)(66556008)(6666004)(66946007)(66476007)(316002)(6916009)(4326008)(6486002)(41300700001)(86362001)(478600001)(8676002)(8936002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fhu9h9gbtkHPs+cP5DBNgGiajDcmtFiIshfjO09d+kUHVhGfM9U1YcxmvjtM?=
 =?us-ascii?Q?ynzKh5FbsdRQpKppA8FkABZhbiWY+4N/caaAJrIyvmFAO/0vXE/TKjAcJqYm?=
 =?us-ascii?Q?jnZvgoluye8zuX/G26kORX7MrvTSgeq9ztrS4sNeFso3RhHoRiCZO0W3Xw2m?=
 =?us-ascii?Q?UeGAuVjHECgrhRIZWAHEMxXpu8cHmymxDzFKmSkIzxNjkWRBlYjknZzBPWN7?=
 =?us-ascii?Q?ng0LCQzFYVgEoTGbJyw1NZdoM1DCf7iER4vYIEUAxtNLwcgyLYI7zSqYbahS?=
 =?us-ascii?Q?UiU998OkspKCTY5qZlX0nqaPwl6tIlRT6rV0gcYnoMPuhf9ac6YqEK9p0LXi?=
 =?us-ascii?Q?+2wsHSkfjEWldR0nDQSIW5QRx4gNQADnLjd8v4baVFkBbxXSBx0Udo1w1S//?=
 =?us-ascii?Q?UHLHkmS4VkapFSFzV3CPWcrA1FZPkewTCLFeUppbcR+/N/uBK6/8EwmtjNBJ?=
 =?us-ascii?Q?JtIsBe4KHmongiiKSu5NxFqf5dVdrfXHnswbSGvtsHF8Z2FSqpFRAg8jsNfd?=
 =?us-ascii?Q?/40MvmWYaSk0iMirD09hMdVxhV3Vg6I+yZGxVfEAhihzcgO76Gko7T2GJCUO?=
 =?us-ascii?Q?cJpfoU9q/1L1bZT7MZOZwS61ooU7657lTkUD+kurhwSDrHb3VFC4j9nxrnFq?=
 =?us-ascii?Q?Q+KL9jn8jsKnDDGFZeBZY0o7EY5xJND48bvZPW/o8uYUHnY1B+O4DzMQEB3V?=
 =?us-ascii?Q?OraYcUpR3RZgo3l93yJCJOmBLApyAW3ElGifJyx5326SxYOWeVaIOnLsHjGM?=
 =?us-ascii?Q?5flMNPm4ulK1RzOZ7/zcldAnH6BR+lDrcwgdsn6ff8cAYqrxnmbW2/xeBsYT?=
 =?us-ascii?Q?fM4szTbsPIqXIMVy3JZMxaaSYbCK5D8mzS3kfbLCJthrAgFxk/c21Q0iEPQE?=
 =?us-ascii?Q?b4oZHf+CZwbHuEI/S05708qiCBvPAPHL49ixLGH8W+hT8ciR+0xZhEJx9d/v?=
 =?us-ascii?Q?/v3OYEkEHYxRu9U/7y8V4xWq1KwwjPiouutgO2yzANZxicpTlbKkyXE/gnui?=
 =?us-ascii?Q?fj2Z8Ryuc0Qf8qyjm4xY9e24jn4TmF6KaQ2nSt/pzuga58k2IkFdU68V7hej?=
 =?us-ascii?Q?imPDJYTEZRB6qWFjFdVtcsSgyi1mcFta/Bl/0hECTyyU+j4Ld7tH1wwdNz7Z?=
 =?us-ascii?Q?g0BaSDaAEmzU+lBjyQWeiGIt9f1CfMf49jdumWgAE7OBjJgM9yiPC54nH3/w?=
 =?us-ascii?Q?8SZx3fbRN7bGuNYBycvnlIrefUqa/kaAPsreqWMSCzYXc9N45XKIJzkbEaqo?=
 =?us-ascii?Q?mM5uq5sAAh6dbpOrejkhrenzlj97WTbTNshyE7EqN6xyI0aKrNQn4nmkgFMO?=
 =?us-ascii?Q?3f+LDb3ShX4Xz9djA6bAHiU7nRc9HMKu0+LsWTjOnAgk6sBYQkZZO79CCJ4u?=
 =?us-ascii?Q?Vo3TE9J9DtHCgLT3qfmpli3XJZtiBxGZ8szo74MNkA8b5iqUFQPe6rkXiN32?=
 =?us-ascii?Q?zdT7nps7BKvc8iYIoVY39XdKxl0j6y2e4OovHX6cR9xv+7tqSYiBo9q97LJ3?=
 =?us-ascii?Q?Ika+cOR5yyyAoc5gjCuZVHtHTZkUPlMfo8x+e+zi2D2fjkD80XqGEEpGJ3Ul?=
 =?us-ascii?Q?Uv1VSC4m89fp+LklUfOr9L2Afbn07oYAPqW+Gbssi80mEdbO63mPK6dN1arY?=
 =?us-ascii?Q?f+0G4NQvIBWeN+cfTGlxzNzbc1OxpMLvzPwgKsjYiCYAIQtctl0GUcr3X2P3?=
 =?us-ascii?Q?Z2qjhw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92dc277c-adda-4503-69c3-08db5c3865cf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 09:22:30.1346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gyy7S/Pg6FiUXuQjVhn5g+5fFm0hFUqEXA/gQN+A5VSqdDcRlxyVDcRF4fguIfeltN9vfvE6lnUajyBoPrnOHjQqzJ+8y1pgZSAOSy17LJg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4425
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 02:53:47PM -0700, Justin Chen wrote:
> Add maintainers entry for ASP 2.0 Ethernet driver.
> 
> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
> Signed-off-by: Justin Chen <justin.chen@broadcom.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>



