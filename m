Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8794C6DB2
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 14:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbiB1NRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 08:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbiB1NQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 08:16:54 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D2F7463D;
        Mon, 28 Feb 2022 05:16:10 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21S9nQ1e021519;
        Mon, 28 Feb 2022 13:14:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=NvferwtCX3rywbPFtcFbe7khL3mP+l5hGLqhdm467HU=;
 b=qFDmxGdu7OTRhERHjL2WdcIJgwvCXSbQ1mrT98DsxHyhGv1awYmzokOXHaRjAZU5zjrF
 3yQ0JH6uIA1bKugK+2yDWiaSZH1NrDZLmlpfpD0dZXYCTLg26gIBru0y3kqhAq2D6hbX
 gj49kjfSFFZuKWWDlMFQ4xadT2szePeeNxIQx1W4BHLIvgWnCba8Zm2rvLsPxYIIXmVW
 +0HK4ntoMmVbXormcxPLUar1c+RrMDJZLDWjgn5vQ9FLxuQOtdW8z7ict1zOXvoiOqgz
 gYKzO1AdnV/P/msEBCKdVeKcuCHwIW7qSn3wifmLKNPV+PJKf2gLLyEZ0TjJ8M/bUif9 3g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efat1v6sk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 13:14:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21SCukwt165301;
        Mon, 28 Feb 2022 13:14:19 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by aserp3020.oracle.com with ESMTP id 3efc12yf7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 13:14:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K3TAkGH8TvF4AQ7wlB14nitaOm0IbHcl3x5wfSkHxXEOUqVXtgnJgjmyqfC9Z45MWNsR191iDOVHUkd3g9qqPjG5uePZv3gccwyMYmZ0eGGt+29RTtkCEjmejwkG7r4Gtak0xgvVXrYqXRhf/FEg/FzwhlTXK0JJ5ZsiUVVXeFWNITehXD9hGPH6IWoTKdXT4ZTuwPfYpuJ9O7FOD3CWUiPnmnCCHaFgYGVr0/q9JOkAHasNMpOuOnVX38Q+DA8v/aSJTWYcbFX3EyVLneWIo0GxL0TiDss1OoRxJ7CyQrA/Anv3k728HkM4y7A7vKwaqFMSu9gOcddTRkyCXTVHzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NvferwtCX3rywbPFtcFbe7khL3mP+l5hGLqhdm467HU=;
 b=SvMdMzu1iYWdUbDUVPV4hYdGS0uAE0CypPM+9kDpTrFOIG4CEsQAhZKICoLhU0IfB7Pfjp2fsDMVWlBLo2Q/9y7t2SLJw8evYqInsQ+vuet0HhM8Jei5o0+k5aW6jNYGj15cSLqpvMaWCoYfhhCGypFFtzkpeS/gmGUAzKKvwilWBh1mPlsJ+r4CPmzdp0pIiki40KMgvEGTgob3qsA2MQyaHRhFq/3amN6eB5X3UWmyfVXkvsPY2LRuGdyOcduPXn4+A6XjqekNyu7HXVwRAmi3TMgledmzJXg4H6SLGOhwu1rStsBRPxz6StRb7eM8yNYd8zdjaFQo19iEfEwiCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NvferwtCX3rywbPFtcFbe7khL3mP+l5hGLqhdm467HU=;
 b=Cp7cfYsqS5EFSsYrMRFCUTGF/k5MQd/chu0oFBUC+nfEz9R6RGP75pM5dVmkUyc9e8fZvL2/qtlIgtGa+PfG21uVJmh1uoLefU85ORAR0l0Z0DoVLG9INL4ilwNs1UR6bvL5SHBDpEo/wjUHDH8r/Ylb+AfqCFPR93eYEJlk5+U=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM5PR10MB1241.namprd10.prod.outlook.com
 (2603:10b6:4:e::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Mon, 28 Feb
 2022 13:14:16 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 13:14:15 +0000
Date:   Mon, 28 Feb 2022 16:13:25 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Mike Rapoport <rppt@kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-sgx@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-crypto@vger.kernel.org,
        dmaengine@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        bcm-kernel-feedback-list@broadcom.com, linux-tegra@vger.kernel.org,
        linux-mediatek@lists.infradead.org, kvm@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        v9fs-developer@lists.sourceforge.net,
        tipc-discussion@lists.sourceforge.net, alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
Message-ID: <20220228131325.GC2794@kadam>
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
 <20220228110822.491923-3-jakobkoschel@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228110822.491923-3-jakobkoschel@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: CT2P275CA0026.ZAFP275.PROD.OUTLOOK.COM
 (2603:1086:100:a::14) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11330734-de4b-4304-c793-08d9fabc37f7
X-MS-TrafficTypeDiagnostic: DM5PR10MB1241:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1241541F7F8269760A57B8AA8E019@DM5PR10MB1241.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HBSAJMpVh1ar/Gd52v8X93Gq1tLyJua5/+JcFan12PFGyF6oeCPh6weqwOOk6ibPtKdytnYd8MXsD05YtM7LE2+j7SVEwPv5vPY2Qqto4qodst5K+0tXxtUe+E9kTYfGet66+q+pqSggWAZ9y+/Y/yI/bMdJWeNwfn0mpOZhAROTFN1K0howfk+AkMdwftCF6dm4ROSSm/lljscAW1Kn590Mnap8xaplF7rJJyaVsCsFGnW9jroNfOo301a+pDISpYWSDJ19Pr6UDwaGCMUvQh1myhtBhMHYHxGej62cISRWq7ZLy7xUenNMk8o7lQeLRDHZPlexLOMUR0ylwz7DdUV8soZlQqmfLlfJk+9ZwRhhs+xFZLrfR/y0VZ6nj2SlTfPlVyrYv+rguhwvLr41UqXiFwEMatMFhVbaANOSWr5Z1mc2Mg+qwBxl4Z1Xm0OB2lm7NN3HYKUXcXAWW+ooYSJUdwxLEvLDuZxNlwx6yTQ0hhS+7Czxd/Wpuu4AIlU2rCq0GylmjxK5LYFMs8V8jPgG13VDsLnyrFfJ8Lv3aTbocFLWkbjMgA08SLbNIElgCVvZmsRPbqLV1g0MTLs2QYLJYkA0Zph3tGYZtRoTKd/VSJzFCRaBQGhxJ7X9Wwio13Ds0IW1yRKNkDhw2LCOtuEX0tfbr1s0aUByq8Wm2r4u35R5pSr1rn9KeTSh5BZCyb8rrD4gz6mj8MIKN1SD/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(7416002)(5660300002)(7406005)(7366002)(8936002)(44832011)(4326008)(2906002)(66556008)(66476007)(8676002)(66946007)(33716001)(86362001)(33656002)(38350700002)(38100700002)(316002)(83380400001)(186003)(26005)(1076003)(6486002)(508600001)(54906003)(6916009)(52116002)(6506007)(6512007)(6666004)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tnpFmoIVUBY9+A0nwXFCCOGbfHokH58MghExpEJudU3G0jSVueQRPOOPpTLg?=
 =?us-ascii?Q?hqhUmUSBkBxIL8j5GCoiEq/ADSwOryPkL6EfHFmFpoilF9ypf6r7pr9tEMSH?=
 =?us-ascii?Q?45K4KB4ObVEkqZFJhVtfZbeDKAIV0s3fzPsijOJhgtWjcNxTRdGusMpIxF0x?=
 =?us-ascii?Q?M0Pym2HJ27lj5u3Rv81JzOsBJoBVCQaIuN3VDLP39nlY8daip/tre+NSHPB8?=
 =?us-ascii?Q?f1jmYLqV9oVnZz7z6tKyLS/lbTyY2VYITX/YZAk+vYV09ey7TL6iF8ZstPCR?=
 =?us-ascii?Q?ORKR/QirszHg78/hQBWfwGMbTYLGhIbFZ2LV6PzsW5XT61e9IshKj+6L7CTv?=
 =?us-ascii?Q?6YEN50b4Ct27vfYseh7B3lvqtwBsucsoRQgoBsBXlIDT6EVLlXjq+1BilFhe?=
 =?us-ascii?Q?OjQweuTOT2wEvsbWFt1P9EoDOgMAkIBjNhGbaZ+Szu+CBOxkzbkQquxo3ZB3?=
 =?us-ascii?Q?GusFihnGcS8wBjkV2wE83KDHPc4M95LMXzPrD0zihmenGXffj6VvX7ELqrR/?=
 =?us-ascii?Q?g2SY4rigjPrs3OMtbUviUOEbP9Szl7gfrLSreWnLbUL9Kc+zCfrY0pkCk9Oo?=
 =?us-ascii?Q?9k6qEcjr0D4W3fzUYgRQ66fe9f2mxfS2p2wRsQv/YVoMidD555dcAZ3o7ecY?=
 =?us-ascii?Q?FiCe8K9mB8DlAkZvkqPk3nIi5J5WpzGU5+llJqA2qK5zRmqZYqmfwV+kZYHn?=
 =?us-ascii?Q?Xc+gCq8avNiFZwKLdTwquYeVPHeHcc1hrjxG6KZZg0grZ77FNbOZ/3LzYFXQ?=
 =?us-ascii?Q?8q7BZ7isAmmvXX2dZkD9J7I0+aAEeCCBRk0Xtln93PTSd72x5Vqium7+nYge?=
 =?us-ascii?Q?8rrRizK0GUpI8PmUjkYHTvNJF0iwk2WPedJMPWXm4N3eukNeNr0xeux5QnMG?=
 =?us-ascii?Q?XzRwoV2Z2OHIldtg+FK9suGbsOi8zyP8V3SVDkwTpFbHlYCFa9oELwVJcgs8?=
 =?us-ascii?Q?+BgvAWjE0AG2n7NbVCikt1yCTw4Dj6dqoWc3rtV1Y+6cgg3XPVaSK7Y1apLB?=
 =?us-ascii?Q?71RPUzKwtCw88+pFkm0ff10dSGtXaBLiubXjUf2P/nK4dGByUogvheFxToLr?=
 =?us-ascii?Q?pQxlxd9sWfK1LN1Zbsfv7bVh1EwiNzfkYWzR0VlVd8P1Q0EeZSR94ABzr8OQ?=
 =?us-ascii?Q?KnzEcezXP2Xq4I14KEYTGDkBbZJl5+UeXZDV+vg4xH/nkonCaqi5OFub8fNQ?=
 =?us-ascii?Q?TciWGo+Kaasw4Y/DW24XNFO+jplg0uwHujeQPR5OfQGq1gx+zPZt8vC0bOJc?=
 =?us-ascii?Q?tcdkWN1wqMHykaP1PxUeCmd3kxYkTS14z4QO/9j2/DT8KjeSUYVxKUAC9iAI?=
 =?us-ascii?Q?QWkMA4cmNSrJE2kjxC7Rnm9dm6Kcd19JhdmbbNDaNZSTyXvTjtjvGvd0xmzZ?=
 =?us-ascii?Q?QnY4gcyRKe9QgDn/ROAirh5052+DdA4fZxF9tRBnCPC/MKUOPLH4Epq4jyqP?=
 =?us-ascii?Q?CY+I7OTV2eTfki0qJDvO5HzxTSL7xgqNAneCFByktPUcw6+8uGXyt0Ehi2Wp?=
 =?us-ascii?Q?AB9v5+2ZKQhqGIF3t9iTKyTR2vWFPTHgBWBj4/FFOeerpJvjNy15ZvpXyIiq?=
 =?us-ascii?Q?7ds8PexWNrAwtUngu1Qs8k/Mr18qZpPHx2z3zW+h9UodZ6y4ORnL+JtZgG0I?=
 =?us-ascii?Q?WdqjUYdqVWrvAv8x5OMMA9yYc8YlhLgqRP2jwI67pZyNUUVtVaUns0I90ya2?=
 =?us-ascii?Q?C30LFw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11330734-de4b-4304-c793-08d9fabc37f7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 13:14:15.5197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pO9kODICkk7VOql0luIhoT5cwQPYKZqHA2qqEqeASZWIMJ3m183W7XHISYMIjKu951+nXW+qVMXF1CfxUFnSmZ7v3YuMGcEX8mOQpDvyh2Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1241
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10271 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280070
X-Proofpoint-GUID: s7TGwM5vDCDJ_P1DjNSvTf6pMB3hx2z8
X-Proofpoint-ORIG-GUID: s7TGwM5vDCDJ_P1DjNSvTf6pMB3hx2z8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 12:08:18PM +0100, Jakob Koschel wrote:
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index 4ee578b181da..a8cbd90db9d2 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -1060,26 +1060,29 @@ EXPORT_SYMBOL(sas_port_get_phy);
>   * connected to a remote device is a port, so ports must be formed on
>   * all devices with phys if they're connected to anything.
>   */
> -void sas_port_add_phy(struct sas_port *port, struct sas_phy *phy)
> +void sas_port_add_phy(struct sas_port *port, struct sas_phy *_phy)

_phy is an unfortunate name.

>  {
>  	mutex_lock(&port->phy_list_mutex);
> -	if (unlikely(!list_empty(&phy->port_siblings))) {
> +	if (unlikely(!list_empty(&_phy->port_siblings))) {
>  		/* make sure we're already on this port */
> +		struct sas_phy *phy = NULL;

Maybe call this port_phy?

>  		struct sas_phy *tmp;
> 
>  		list_for_each_entry(tmp, &port->phy_list, port_siblings)
> -			if (tmp == phy)
> +			if (tmp == _phy) {
> +				phy = tmp;
>  				break;
> +			}
>  		/* If this trips, you added a phy that was already
>  		 * part of a different port */
> -		if (unlikely(tmp != phy)) {
> +		if (unlikely(!phy)) {
>  			dev_printk(KERN_ERR, &port->dev, "trying to add phy %s fails: it's already part of another port\n",
> -				   dev_name(&phy->dev));
> +				   dev_name(&_phy->dev));
>  			BUG();
>  		}
>  	} else {
> -		sas_port_create_link(port, phy);
> -		list_add_tail(&phy->port_siblings, &port->phy_list);
> +		sas_port_create_link(port, _phy);
> +		list_add_tail(&_phy->port_siblings, &port->phy_list);
>  		port->num_phys++;
>  	}
>  	mutex_unlock(&port->phy_list_mutex);

regards,
dan carpenter
