Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA3C1F92C8
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 11:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbgFOJIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 05:08:48 -0400
Received: from mail-eopbgr00114.outbound.protection.outlook.com ([40.107.0.114]:24038
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729275AbgFOJIs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 05:08:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TJqaD3sfODzJfK5VkakbVgXDAdwYl6O8LIVBI/txjY1kk8B9g43QBJNQlAPkW+oHoz4WDArJp4Kj4H2tBUyCUnko5iMsC6AdPr392Y5uCLEAMPueSDN+YJ0IjmMEkWlLvPMXxDs0w+TQIs5/sQ9R2ZfAeUS4rYaXn49urE02VuMxjRFsUtwyuh8T1o4XIAUv6t1yqp+Cv+FemjyWbdp+9UjqE4oXsfiVRwnrcCrk3Z5J66YivcVOdqCgUTKqwa4kV+/6WbBOioMWIUYP/5fl7NZUaMOKILbCI5NC80UxMM6KjVRTRyHI5ubB7YAz2V9vju65cnOEDreBUU+GVy/VDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFJwy5eHSsSrz6HimUrA5oj/NgB9ZK9DGTF8YHS8OlY=;
 b=T+4XttedJ8Zd2jlagjn2Jrk1qpi936l5G1XzrTMRTgn8XkfM67qtWfq1eBwMbr09xfdSVlPM4ZBPISOP2ysPeoCqVpIC+yTdw7XW2jmJuoKIAyT809khw0ud2olzpRm1w4nHJszTwWK2WdntF342nBlu8ygeLicHuEmN0u0pwyVuJuFpfGSPlIQVV1o5ENSJ/VOzuTyT+Qh3FFtFwAZI2zjAgDuCoQaFwXuGIWrmSsW1RyabStpbmEd1v63ojih3gBVEgPzpOPW6bsIBX+lXSoYRmhJ5poW3VnT/HsSQvmoDPZy4H01xoqNebg8tCpBtUs+eByfOd7KLt91EWsY4Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFJwy5eHSsSrz6HimUrA5oj/NgB9ZK9DGTF8YHS8OlY=;
 b=TQuFU9Qgz5+44oCwH0l+0xfXOOwiXBlCqsijd0rOyEt0OqBANGGvmVsjVE4vDZTVp3yCHoEvrvD6OBYhGE14EHGwnh3Cjbmahux84Yp4E8DgEdI6yenBr4rytatqB11o0NlTucWKTsu9fM0ygoDlm4okBy51YNv+1myMStnT2ow=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11) by AM4PR0501MB2337.eurprd05.prod.outlook.com
 (2603:10a6:200:53::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.21; Mon, 15 Jun
 2020 09:08:45 +0000
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39]) by AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39%11]) with mapi id 15.20.3088.029; Mon, 15 Jun
 2020 09:08:45 +0000
Date:   Mon, 15 Jun 2020 11:08:43 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Matteo Croce <technoboy85@gmail.com>
Cc:     netdev@vger.kernel.org, antoine.tenart@bootlin.com,
        gregory.clement@bootlin.com, maxime.chevallier@bootlin.com,
        thomas.petazzoni@bootlin.com, miquel.raynal@bootlin.com,
        Marcin Wojtas <mw@semihalf.com>, lorenzo@kernel.org
Subject: Re: [PATCH 1/1] mvpp2: ethtool rxtx stats fix
Message-ID: <20200615090843.jh7ua4jlckey2qbe@SvensMacbookPro.hq.voleatech.com>
References: <20200614071917.k46e3wvumqp6bj3x@SvensMacBookAir.sven.lan>
 <CAFnufp3oqcqsuhTC975iVu5-ZPAVZm3RBsY2fdq10=g1eOu7Tg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFnufp3oqcqsuhTC975iVu5-ZPAVZm3RBsY2fdq10=g1eOu7Tg@mail.gmail.com>
X-ClientProxiedBy: AM0PR06CA0116.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::21) To AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacbookPro.hq.voleatech.com (37.24.174.42) by AM0PR06CA0116.eurprd06.prod.outlook.com (2603:10a6:208:ab::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.19 via Frontend Transport; Mon, 15 Jun 2020 09:08:44 +0000
X-Originating-IP: [37.24.174.42]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b2f9c51-98a9-46c4-d8a8-08d8110bb4d0
X-MS-TrafficTypeDiagnostic: AM4PR0501MB2337:
X-Microsoft-Antispam-PRVS: <AM4PR0501MB2337757873EB57BFD9ED6B94EF9C0@AM4PR0501MB2337.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04359FAD81
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pvz65atuADDg2ljWpgWYNEVxdtRrDivM+bbjY0VwWNzbdrp9l0iMW25U5u0p+CggubhI/Ci1sxAwKoysoCY58Y5KlMELhFGM44EQx7kNSZYx8RkhBO+wYbRSQCx9bm+l6fLZizDV1eAaeCjNI3fRQbnEY/mk04JwuKHbE7II218WpHwLRPzgsQu2oQLwZ+CHq+xC/FxAAowlMjpjoVXqVrAlIlQKtXXRcT09gKrotvXX0bFNOCC9FN/udN6IqwKcJFk16FXpJF5hUZBMeZKETeZPUUMwT2VutQzykJg9NiSG1A59SXJOI3K5fSjwULRb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0501MB2785.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(366004)(39830400003)(136003)(86362001)(5660300002)(508600001)(66556008)(6916009)(6506007)(66476007)(53546011)(8936002)(7696005)(52116002)(66946007)(956004)(316002)(44832011)(186003)(26005)(1076003)(9686003)(16526019)(4326008)(2906002)(55016002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: idhb3FVJyg2f2m1NRWJT3oCwCH3Vv5WEHOWJMyb9yC60rTVWrUTLbxdCt0ju0pAJl7pUa7PGfFNRk2aewI1CtJwUPv7yqD55DeLo9QdTIV1rgnZ5I26Nrzhg4EKy837ENN3O75SUnAXCdDdAy23KgiLOJOwJ4sTCCh+tjKffrmO0yS4GBZXhtNK/wSifHyH0ikTnPUbbcX9wgHAjIehkUeLjkB3xiYLc2NCre+MyP0uKMbfm6Okdlak7XQzGjg7FwT9SSWhGixOPVwXV0cAqa2KEOauBpqvPSLbZdVn25K9MyzQjjZuGNkpBVXBL018GzbpSYhosGvorFlKlrxZAVSsiZ2HZgNCaqjLULboDkpdfhTp1RuMP0dYmsKip/OiPUzvHag5uUJUtsq652dEPC8ni+nCdwNbtGimXTkPhqGbbwFIwrGD+7Y/XvikCrsA7trgbEgWcEW3RXh693UONujiUk0OLECpjjOvZsnGOMow=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b2f9c51-98a9-46c4-d8a8-08d8110bb4d0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2020 09:08:45.1062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NQRDrhc1pyqilbeKMi0zJ+N4sVqETb5OW+gJholGhfHYxURMtPvxod/jAQY9Ji1LK4LzPyAnyA47k3qQyZ/FtSBY2K38iSCSgCAa3Bb0gdQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2337
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 12:23:20AM +0000, Matteo Croce wrote:
> On Sun, Jun 14, 2020 at 7:19 AM Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> >
> > The ethtool rx and tx queue statistics are reporting wrong values.
> > Fix reading out the correct ones.
> >
> > Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> 
> Hi Sven,
> 
> seems to work as expected now:
> 
> # ethtool -S eth2 |grep rxq
>     rxq_0_desc_enqueue: 983
>     rxq_0_queue_full_drops: 0
>     rxq_0_packets_early_drops: 0
>     rxq_0_packets_bm_drops: 0
>     rxq_1_desc_enqueue: 14
>     rxq_1_queue_full_drops: 0
>     rxq_1_packets_early_drops: 0
>     rxq_1_packets_bm_drops: 0
>     rxq_2_desc_enqueue: 12
>     rxq_2_queue_full_drops: 0
>     rxq_2_packets_early_drops: 0
>     rxq_2_packets_bm_drops: 0
>     rxq_3_desc_enqueue: 4
>     rxq_3_queue_full_drops: 0
>     rxq_3_packets_early_drops: 0
>     rxq_3_packets_bm_drops: 0
> 
> If you manage to find the commit which introduced this tag, please add
> a Fixes tag.

Hi Matteo,

I looked through the commits from the past 2 years but no luck.
This must have been in there for a while.

Best
Sven

> 
> Thanks,
> -- 
> Matteo Croce
> 
> perl -e 'for($t=0;;$t++){print chr($t*($t>>8|$t>>13)&255)}' |aplay
