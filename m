Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39CE86B795E
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 14:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjCMNqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 09:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjCMNqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 09:46:40 -0400
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2048.outbound.protection.outlook.com [40.107.241.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA256C8BD;
        Mon, 13 Mar 2023 06:46:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E33ZGJC/A16AYGaRBrfjXNu9EHSuHdQEwj9kwe9fuyjCDlEnaDUZWcrcv2U/GaTv/5BCzVzozozgmOJT5cb+eZQRoe7E4Kut8ALdUSc13dZSNQ+kOck6V5c/F4tokr/j+p+zts3uWCkL8aoiFQNnLp1eBH6asIxN6iKHEVLMQkJvWonfL0k61/XO6UwNTLfAS1fouHcRFXRH2+rYC4RGJX869fUkkt8cg2vssNc0vDCQS7psPOWkVwcjhvu255GsFeJu3ibqcW4BtVla4jv3Dhua90RAPHz+bJhA3Y+jmaAXgAre+MA5f5RZSWx4Gr0TxKL9VrSZKUtHBjU11c1hZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ULyG7tRBn7S53XsWo6pfLYmQ49V+7t/mtHGYReqonv4=;
 b=Nb9ZekzRNuZdf+PZCUwvAUmj5ZrO8TTgxiwqzMYF7oNpyDeB2E/4T5wnacuJ999MSUfC84R8TH1RbBnQDexKqWWui00g8VJwt4cEpyPxmgy5W/xE0ToRH03LQCRj1rD9OHFmV4UAiBc9l6uRfSHy/mFTmBe0IxRYNLnfdPf3C/yEYFvVOK/3DkT+s0HG4wcNzjC7nl4FMr4mi5rIN3FI79a8fAG8R83BQCKezBpsXi+EToZshNWFzrrpew23fYw0l3M9HKyfpVKFVuOjRy4F/tM4oHXtzmbb1yB303+GdYVnM9DL6FEPQkJV0mEr3lZ89mP7iEz6iTp98XyXntQ0mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULyG7tRBn7S53XsWo6pfLYmQ49V+7t/mtHGYReqonv4=;
 b=SlUsVTkuJFQXm6bKmn2Gun9JGi1xpdkUxYi4q5u8ZIXRti8SZ3zgiTT+nG8RjlPStj6zTbUH2OCRyXrxbFR0rcrMgoFyedd6sS47vB15jg+umjgn2OLQjWAumbhd38BoET+WA1TBQI+6A7dKXKvWYk17U96eDN0zH3eENMFNh0o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by PR3PR04MB7306.eurprd04.prod.outlook.com (2603:10a6:102:81::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 13:46:29 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::9c6d:d40c:fbe5:58bd]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::9c6d:d40c:fbe5:58bd%7]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 13:46:28 +0000
Date:   Mon, 13 Mar 2023 15:46:21 +0200
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Roy Pledge <Roy.Pledge@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Vinod Koul <vkoul@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        dmaengine@vger.kernel.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 0/6] bus: fsl-mc: Make remove function return void
Message-ID: <20230313134621.5rmzawmhv3lvis32@LXL00007.wbi.nxp.com>
References: <20230310224128.2638078-1-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230310224128.2638078-1-u.kleine-koenig@pengutronix.de>
X-ClientProxiedBy: VI1PR0302CA0008.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::18) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|PR3PR04MB7306:EE_
X-MS-Office365-Filtering-Correlation-Id: a701bb84-b878-42a6-b8ff-08db23c95769
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n++m2zcQ+ipq0ce5NaO6z3K5JFwhXBR07BOWqpwwqTNVFonElZQmMVlXbOiUMYM0rbGB4WcyeXT6fazthwwWNMRAsjjGNs8vC5gScg4Lw7aNTjQXQUpSfZco2ntf4eOzT+WBSS8QcoaAltUptCa4UiaKAmenwMiQ4JS6Q2XpRycPA+2g/HvzoPu+WxH5afaloLSAEaanDMr9lJ7zzHxpW0TPtU/9k43Q2IDnw6Ij1fBjMbOnia5Kz+kZbSBW1a7qszymuaHtTpXTRyLxbAi28HI9NSlmmU9VmyczNUosovRCkdT8pWN+1SqNumSBeaj76Sa6QufHCvbXOLJ7QR7NiOLa/k2B1WCAWBvzijR2e2/go+/ztC20c3CwWZYX4II6fk2c2yVzmCV2JEtNTmo10oUVZNHVVaDeKu8yZtEHV7mkdzs5XcdVSooYze+3HLbLYknunJyCi0Iul74sOfCF3Eg1GPAUdEpswt16BeofNrGKG41BPE9MWIV7rtgj/nm4DOQPeq034W4YGEOaLdZJbGsU6BcqEqRBTy/CgC808Zi6y6/Oq3gH7xycXE7r2cJ1Kv7+aTpPTrp3b7x4ykUJzcDFS4HstzgKzIzoeIssYkd/nBhqu92cHXn+NkYoZ942/ZxfwCZOfbHAHma/T8leAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(451199018)(2906002)(83380400001)(7416002)(44832011)(5660300002)(66556008)(66946007)(41300700001)(8936002)(4326008)(6916009)(8676002)(66476007)(38100700002)(54906003)(86362001)(316002)(478600001)(66574015)(186003)(6486002)(26005)(6666004)(6506007)(1076003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?B5i8T64NYVV+0AFGAs8jsVs5EXj+XBj2AdCggRWOQqzyC5xWjESJIgluSl?=
 =?iso-8859-1?Q?Sds4Zm8R869qoMmEAXmkF78kjUhKIvxQ/+4567qAGZcULMdHKNQRPary22?=
 =?iso-8859-1?Q?wlCuF1WtBLfUBkgQTQu1tks0yKialOfkLz1Bp25deDHRbbNh0YBBSw8d+t?=
 =?iso-8859-1?Q?ALQHtK8vMPlJtXVKGsPrLO0wNFnPKnQ0jzmUV8ZE5kaRIBvMl2em0v02RQ?=
 =?iso-8859-1?Q?0Tf597dQ5J3iF9F+cTK5XH0pwk9M7BIMyjlAIofkRE/gLy80qbuiCSurWN?=
 =?iso-8859-1?Q?jwZd3wxR0Nibo5p/l6LsKqnKKb/7E4BYFxLVYZJcu7NlGUMOsAC0q9tPlY?=
 =?iso-8859-1?Q?Uge0XTcY8naxS6FuHz9FQ0ytMvaW4soWlToVFRcyinZWoA/jK7HaMy/hwQ?=
 =?iso-8859-1?Q?VN5/Ko7wULCz4KF6H/ee+OTDjkipVipuypRYRkk5oObkIBCMpnxLN8RS+u?=
 =?iso-8859-1?Q?OuMM7dOalRxVHE38cju960+h7kDYbkoua64hAk/PF+5WubFmnDLSeQt6NH?=
 =?iso-8859-1?Q?L1SmH5OnY9YrGduCVyUiS6v4taUb8KoWM1lk++tjrV2LvP9OKAcEb3Xuuw?=
 =?iso-8859-1?Q?UCwvy6gL5JkSedKpvQQaGJA9bjQdDPDZyXZqY5k3MDu8oGcdGdK2kd8eEV?=
 =?iso-8859-1?Q?gjK2xREyRVSyOm9UOUL1GVIIu5lrnmkiOZnmMcPfpG55/7MF5hNmTvGeBT?=
 =?iso-8859-1?Q?LQGovQ1ZZYDIQ5t8ypxAt0CY4FKUtd2w/Jg+yyFiZqiU/e0ohD+3JHeOFQ?=
 =?iso-8859-1?Q?1gm+xPInNh3Fs32K2gsH1isHhu7o4CiR/WVMvMSGJoh3/4g++6e+TQe6oN?=
 =?iso-8859-1?Q?O4p/NBvcMlvaBIDNRSfibosaQZKvChExuKTGP4MTBem6yX5ufoDMuaQ0VF?=
 =?iso-8859-1?Q?mGx9lAbsAL9EJ0a6KEsccWptvxyIoUZ3ZC7CgoE+j7tXVwGtOfqBA8TSr4?=
 =?iso-8859-1?Q?HMxy38tDFVESxZmOEg6I6jla6PWGida7vl7kjzeZl8VQZTH8GDj+FfKJ35?=
 =?iso-8859-1?Q?8kCR6sfBYgqnl8rGrSL9IrFqobnaISupAbY3F9m5oUal17qH2vQ+qzr4SI?=
 =?iso-8859-1?Q?4ioWyWf+FdGnVXBQPo6Vzt67qmFSa+3uk6SgiuS68zY3blKSN+/yjow25V?=
 =?iso-8859-1?Q?FCEQfF4a6aaN0nln65UqyPtf/+ZrxhKu3sSRGrrN6bmV1nzKKWA21ARPIj?=
 =?iso-8859-1?Q?fQsH4EWXQwbr48sSrOwSNVlFFlhPusH6JYuvJrjTSegBiQzietXOwtXzYM?=
 =?iso-8859-1?Q?7jv//pxY7QJ3VS80yrmoK2V2UVTXTb4oIQ+kisQgtEx+90SVk0oJ2efJJQ?=
 =?iso-8859-1?Q?Pjfx5mK4uiTbo1L8rF5EfFsD2WjbyL59vuRxEnGuxOyNjwNbe/TJC7E+Qw?=
 =?iso-8859-1?Q?9z+0JTigUHgpBM8nK242Q7ZyuAB30oh5iRac9owlETgH5Qo/btApaDLbst?=
 =?iso-8859-1?Q?UZtihIAzRpois361AZ04EzJJZya6EedlRepb2nhnbJ5S4dXIOX9owvyBfA?=
 =?iso-8859-1?Q?Jg55ct9UQk9zUUR4BGeG1KpWMJITUIL0jeHI1i1NafydjFOLj/A+L4yNmZ?=
 =?iso-8859-1?Q?+O4/lAJBzexYBbgQiD1VTPdOUiMwbqkhQmn+ShNGDDzXGE4NZkpX8wrJfn?=
 =?iso-8859-1?Q?u1s0Pgx0ESWd+kneC/a3t+gU0/DUJJjvl9/4fNd1bwPQsI1T7T5jHHjQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a701bb84-b878-42a6-b8ff-08db23c95769
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 13:46:28.2498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rvWiizfBB/cqLXnu63ye5XHWmzfzQeInv+HCziodOjzxZUXq8kgBJ05v0L56p9R2g9FMXYCInnc1f9lzM36GwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7306
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 11:41:22PM +0100, Uwe Kleine-König wrote:
> Hello,
> 
> many bus remove functions return an integer which is a historic
> misdesign that makes driver authors assume that there is some kind of
> error handling in the upper layers. This is wrong however and returning
> and error code only yields an error message.
> 
> This series improves the fsl-mc bus by changing the remove callback to
> return no value instead. As a preparation all drivers are changed to
> return zero before so that they don't trigger the error message.
> 
> Best regards
> Uwe
> 
> Uwe Kleine-König (6):
>   bus: fsl-mc: Only warn once about errors on device unbind
>   bus: fsl-mc: dprc: Push down error message from fsl_mc_driver_remove()
>   bus: fsl-mc: fsl-mc-allocator: Drop if block with always wrong
>     condition
>   bus: fsl-mc: fsl-mc-allocator: Improve error reporting
>   soc: fsl: dpio: Suppress duplicated error reporting on device remove
>   bus: fsl-mc: Make remove function return void
> 

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com> # sanity checks


