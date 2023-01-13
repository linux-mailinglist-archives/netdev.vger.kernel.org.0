Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76A27669451
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 11:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241244AbjAMKhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 05:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240887AbjAMKg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 05:36:58 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2091.outbound.protection.outlook.com [40.107.96.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6230E7A3B6
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 02:35:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z+ShUi5lTcmyHRf1tBAQBRa45beXH4yk8o/g5tT9HxkHScnkWOyZkdxtC7ldaMVoV53sxVt6D8hjT0YdCMXyanfeEDVfcIrx3R+fGblVyiKFhSDAz5WDjg5lDyXy4CegM62P2hHdV7TWldr+ek/q9ZyAIPDd5t8Snxdeh1cZYCIxV4PldyjT52RQG7h+xnJ1TSAawucMHvuF0hFbFzGK09q9aj+i2rp9JwtatdgPPfle/y+pUmJdngDVr15gAzNnr6awuNais+RcqVIcURud92OClrMBRF5jGlk8Cg2gdQ2jZT1RW2u0ATS0PjPWi4g7kRoQuswsxagg3rpGD2VESg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8IS/HZauxCleDwZqW6f3aetqhunyRa7e/6Z9qSPjs0=;
 b=TlIjSUw3XE3jrjpgKo6OyZXmWP+BCMwGSDDv5O7Sh8p+y0S2+tPnwu2gggSpI4ycyHvkBih006311s9DkYWalat0pV7wKMj3xxYjreRXlN0WRXjG/WjxUKM01oOmJz3isaS+i0RTiSLj0ONHC8OUWFpo3NYMhznOavf49iAJF5X0KFF01Nte+8BjvjwJTiMPrex4TlM3bAZUrmBFZhIrcHFhyAkp0tYx+Wx9mNRWeOrceirW0GUduzuBVDnhz9jvwaxgjR7sOGgLUfWyyaparMSc313Hj+UA2WpYriDOVBlYxsKtGoh1//PQHRp8qIB30f9NZwtd0HTzPPktkWlZcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a8IS/HZauxCleDwZqW6f3aetqhunyRa7e/6Z9qSPjs0=;
 b=iXrb6TL73z1YluVdXgXHqQodSldEp+VKqvMzxk8/eWq1K2Kvw/rGPH8n1k2IiR7ngp/erA4qlFHHrazh3C2KENaY4WaP10bJOZcasAHYeF9gJ7nPhRc/iE4/DzDuZIOjj1SNvQ/Sq1pYsuYnGDG8fm5f0LpSZn/yIVpr3NzNqbs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4972.namprd13.prod.outlook.com (2603:10b6:510:7a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Fri, 13 Jan
 2023 10:35:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.5986.019; Fri, 13 Jan 2023
 10:35:05 +0000
Date:   Fri, 13 Jan 2023 11:34:59 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 09/10] tc: use SPDX
Message-ID: <Y8Ez09UmY9qzMlfi@corigine.com>
References: <20230111031712.19037-1-stephen@networkplumber.org>
 <20230111031712.19037-10-stephen@networkplumber.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111031712.19037-10-stephen@networkplumber.org>
X-ClientProxiedBy: AM9P195CA0015.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4972:EE_
X-MS-Office365-Filtering-Correlation-Id: b4f6ca82-95bf-44a9-e612-08daf551d571
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FrDhu4pillzqIC3RhhOuAzR2OK/MXbED6/hrcsGuZJN6MyMbret5KCs9NIDXevg8WjCTWHnQ97rfXOWaIl/69wOT3W6PLUxVb/x2MpOM6y79SQUlw98+6W7y/YkVXOvZM1z8XBWz1KX2MkyyPx9dzMaaQ8+BNiSYuKNSF7zjr74DLqqU6SJg2wykZ6lpEELdF0XYbHQzu/toRrYQTCKNkDLz4TxCINkQqI3gTfayLIuEeoFAqdlhrhz5ni6qnflXqPFI/MRynLfsUx9isGP3+82CsGYwqtNDfUrObRGWQpxL7DalD0Cngp7Fg1xxnuHazmsCYGuUX2qEyxqRdgqQNTadSpuONxWZ0T1qzMB/abF6U/kFbQCC4+7ZXO4ABeNhEBID1evS7wgEYueHgce8u567pNydn6CisQH6wFrY1Ywg2aUne1SdGt55gLuePv+lUbxlVTAZn5A/1m2IMuvus46iuHrPFCSEa1iU+fnhtXWwAqZuo9B9edR7n7aNJvqhhgChUENJ3af8v9A7Rme1/gDPo+1qSb1v903/IKUfVdEj4Fl5qQc8qQA3iY/m514af9GJA4vS5LP9OyT6Tmq+RB347anEfzEKFqmmjsnolvCH8g8lLkHgLvmugg0olcUlRdivto8UWFr8OAtrpzcrOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(346002)(39830400003)(366004)(451199015)(6666004)(36756003)(6506007)(86362001)(41300700001)(8676002)(478600001)(5660300002)(6512007)(8936002)(6486002)(38100700002)(186003)(66946007)(6916009)(4744005)(44832011)(4326008)(2906002)(2616005)(66556008)(66476007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jDtDTXNlo8IF5G4je06OHjuBZhKvXgKLFf/09y59w5nINoCWqdsVKDbKvejO?=
 =?us-ascii?Q?tcygrGWMt3f60oEbhuh32TEBuL2I0eCGaGJ5oV0MLoQTRSv0lXusOkZemLLY?=
 =?us-ascii?Q?6wF+TYfvP5gFGSjAgZKzzPg7us8R9P4zxzhpD2RVIHvmsltcMoLmOEJ5jo96?=
 =?us-ascii?Q?gQ29fkk26H0dcWBzrqUaIQ/Yi587J3+blXekgGpcabbBNAVEFq6PrgkIdDlw?=
 =?us-ascii?Q?zrfJe0OnLMb5c0t4mhQ9jgi6uToBLK1R1EGCcXUEBRjcbPpQCp7G44Thezd3?=
 =?us-ascii?Q?r9FMmcRqY2+WNLJpxM6obLHgKUwSUGdBOHhWn77WQGS8sK/4a5bXxyaAhvHs?=
 =?us-ascii?Q?iduw3L/g0QxMTLj1jWmA4czWKBFWvABiMnzlGqa8V/AWt4bQ4KqBdZWXBytS?=
 =?us-ascii?Q?okJEcatswc756CipcyETr+awNotS3q4B4oxrF55T9KNVFbcfRB2ugRxyJDvI?=
 =?us-ascii?Q?TZ3UXaIYbifkPgQNOIkWgJMgX++6rj5EU68WpQ6sehMpV+UwxvVwnNgaOulI?=
 =?us-ascii?Q?3dW1HHSHkEWLTivlh0Jo2wyZASaSV1sOpaJTtIzlqwpRypjNi/IMvWAqJlAs?=
 =?us-ascii?Q?/dMhp/rVH7sseNf5qdU1Yn6ussqC1/edQAFSWg1x5QJ8CX9XELdj1Xsfp4G0?=
 =?us-ascii?Q?dxnWuTqIDxwhIriGAqNL9vazcBKYsGXP2ArVcTFdINEfpF+QJMiw78vO83ya?=
 =?us-ascii?Q?K885q0WZIBQ9WdYHAvjPlMIIn1yoJXy/20eCKDbDKQzUTtkY4Nd+8i39RY6/?=
 =?us-ascii?Q?UXX8nYrS0M2qJLMSwBg3OZct73T2tie3KXG9GiufiXKIqWLUYGX5Q0imNb4y?=
 =?us-ascii?Q?WHW0qOHMC2hhZFHsXx58qlBEaTaZpVCIuUp+ykofqpYQKlph1XlBajzyWo02?=
 =?us-ascii?Q?6gZ9dNpy4kU1TFaRNaIsDD+C2qOQ/jLYBsPs9BXluuzFxItBT5Dl3vvLraT7?=
 =?us-ascii?Q?hELADype9YCboQwCBkTecSQvDfBW2TdoHTnE7qWBG/ojEqh+9tG9IXv0uy7T?=
 =?us-ascii?Q?xMu5dIJAn+tBcLA048vd+vAHPG6SxstUC/ZfCnzQp0jLKrOJNYfsc4WpjK/3?=
 =?us-ascii?Q?uDV2sxOaT7tvHGs5xba7gJETcMi/rEy5EZ1Mqj02r+fUA5to3Ym1NaJSS9+L?=
 =?us-ascii?Q?kDmAwC9eYyEAYfHytMBqrV8VOA+Y3p6irpy1Q3L5TSmcQjpPre/rTyOSK4Ne?=
 =?us-ascii?Q?Z2ou6HjVocPgwKF3TtJsYdpzrX4FfDr/6RBS8uaYY7LhmYjPwS7g1s7XtN/+?=
 =?us-ascii?Q?KevtVnw7dWZXHaXp06ru8iXj/pXa9T3ln0hlz13uwB/rxnPPKZ3vphCKN47g?=
 =?us-ascii?Q?KMvF37z2gvd31Afq5bPoDammLsx9QdUscJXQhAruWgvYJA0ixjqxtdlds7HF?=
 =?us-ascii?Q?wBSx5vNE16g1F7dfhgRMRiHjEojvCBpvfAHYlQeCh8HcQK3MAHe+rEtVawAm?=
 =?us-ascii?Q?qfz1dbXUERh7Tu29yPFnJuwZCcbeLW5Ef7Ut2P5Fq7azafZyVBH3/8CkrsaG?=
 =?us-ascii?Q?7VZEebYYKB9Evomc91rnP2HdId2zrziEpHn1ublzkadeLuqbH4uOTw4Hjk/V?=
 =?us-ascii?Q?zL9piaZus7nF8Pd+VnHUbxHQOWbxd9FS5Yrw3w/1BRxEnnSQ8POGenq1Fvk9?=
 =?us-ascii?Q?EJYuv3DrMtMkfB9c5RUXcV1oogtsbkEWoLq0lM/LBANd1yOrLwzpbCkUcewq?=
 =?us-ascii?Q?7UYZyw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4f6ca82-95bf-44a9-e612-08daf551d571
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 10:35:05.1169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2VB/gF5DKMCgzqV5FvjdSQaFmq7FA+zmMsQs2In4nYQW/GvY6MvwkYWt3vhXesIcDr2qs7kOGUTK7zcWHYlg3fqqncq9wmsiGNTYAze3XLY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4972
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 07:17:11PM -0800, Stephen Hemminger wrote:
> Replace GPL boilerplate with SPDX.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

...

>  #include <stdio.h>
> diff --git a/tc/q_atm.c b/tc/q_atm.c
> index 77b56825f777..07866ccf2fce 100644
> --- a/tc/q_atm.c
> +++ b/tc/q_atm.c
> @@ -3,7 +3,6 @@
>   * q_atm.c		ATM.
>   *
>   * Hacked 1998-2000 by Werner Almesberger, EPFL ICA
> - *
>   */
>  
>  #include <stdio.h>

Maybe add an SPDX header here?
I assume it is GPL-2.0-or-later.
Or is that pushing our luck?

>  #include <stdio.h>
> diff --git a/tc/q_dsmark.c b/tc/q_dsmark.c
> index d3e8292d777c..9adceba59c99 100644
> --- a/tc/q_dsmark.c
> +++ b/tc/q_dsmark.c
> @@ -3,7 +3,6 @@
>   * q_dsmark.c		Differentiated Services field marking.
>   *
>   * Hacked 1998,1999 by Werner Almesberger, EPFL ICA
> - *
>   */
>  
>  #include <stdio.h>

Ditto.
