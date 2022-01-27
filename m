Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FB249E78A
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243750AbiA0QaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:30:09 -0500
Received: from mail-dm6nam10on2127.outbound.protection.outlook.com ([40.107.93.127]:5409
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243747AbiA0QaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 11:30:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ccjx6zDbuOnFosq8Rt85gHUQvgyTqav0i596gbsvj/NYjWvxY9td0IPfbvNB4/NR+4rFdH6FalTsBN/Cn1vJS3hcgZBwgpg7L5hFeAcOwyLRkaZI+fo4ixswjpRmiT631kwJD0Bcgfe0uHE0FGGexFQJOKXXipm0fZ65snWV1Xzdl4W9TP2njtUCQ8xYqzbrcarJK3zZ9PUAH0Ue3Z9BhRUGdrjfHrbvNuXLRwx8G+xvDXj0WBRHwUhVKoirTqtC8Tghof9Xs0Qjje4l8/JCISuEvBqpBJ8PrBiUmJ4H06Os8ITS1PAEhFBtB1dVrTie+p94coJfUlaCPM5tMCg7xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ND038PngL9SDxEB+gfunheSDzWfpvSZl3TYK9DK/nnU=;
 b=G5qbsBy8+MO0JQQS/wZEw4AeSeF8vmaMUtXW1Rp+iWmMBEdX/Pjb3X8Ihuko6l1TGWd3Fn2aHv/uyjhJ3X1ws8fFvuFuOGoL/M2al0KhQp/Oo389zI1MCIpPift3PDys+C9Q3Zbcv/jd81W0QMEoZk7QDrIqCmt5BhvwUFPvazvRYcgcvO/X6NYXG6Wh3tqmAMzXowbpkSFafaiaZUnK+JoXUCkxS6IdSxNVvQTxrWMIt2UQcsKJ5iCW8uUcrt3+1eukawVM9r+QmpFxCUj4VI9hq4tohrBrV4qx33X+xNCkoMZrcSLzhzjsngY31rU/YQ1weS8tV4KSwZhlpY0ZOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ND038PngL9SDxEB+gfunheSDzWfpvSZl3TYK9DK/nnU=;
 b=Tmq3txTS1jJRYqK14aQe8irWQXfdDxXAeSEJd3sh0yULU4XJ6gEpkRsbyVT7R66nFRBgsnJScdyUB+9teG5/eqbl5gP3Omlb17vTzBXnWDAwqNn6sHxfWFYTnJxky8PLmtXSonqZ5Z5Qt+AI5Y/RI/31UOaJUkn7RO9VPpLYyJg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BYAPR10MB3608.namprd10.prod.outlook.com
 (2603:10b6:a03:120::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Thu, 27 Jan
 2022 16:30:05 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4909.017; Thu, 27 Jan 2022
 16:30:05 +0000
Date:   Thu, 27 Jan 2022 08:30:09 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v3 net-next 2/2] net: mscc: ocelot: use bulk reads for
 stats
Message-ID: <20220127163009.GA3546@COLIN-DESKTOP1.localdomain>
References: <20220125071531.1181948-1-colin.foster@in-advantage.com>
 <20220125071531.1181948-3-colin.foster@in-advantage.com>
 <20220126183436.063b467c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126183436.063b467c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
X-ClientProxiedBy: MW2PR16CA0007.namprd16.prod.outlook.com (2603:10b6:907::20)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1ca80a5-268f-45ce-f917-08d9e1b24658
X-MS-TrafficTypeDiagnostic: BYAPR10MB3608:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB360833546A9DBD6374606A1AA4219@BYAPR10MB3608.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 07ED+K6XId8BeAMkq6bMHP1WxxAyX90FL52IpWAyh4kba6LVEIcFCuPJ8dekrewb+Zj4cv9uBHBfaE5+6ujMfg6L+uTIsmeh3lO4kwcftdURG0eI5+mVKXnZO3zKtPeRh1WOjMybJ+4TQkk5coC5FjEd4kHL6WfWrtK0x62sOTpSUnIjBV8Nz4qUBbwTUzeh1vUplLLYIgr+LDKDcYKmVRX6CpbWCgPZABVsjo/Fcg1nqWnOOf38izeTHBwnLrdPegWg2f5jKCj2GVBatr27TYFLdYZXnhWXuH1xBnwxONH/yp4LVaIimGM5Cq6/gzdO2bIWIKiSFcnjNIkwN3TCryCFl7RRmsGbEA933SBChEeBKEwoLJutfEv6F0psV9ACZbVHKPQiCw8925+NOiFSToqIh/oevIUyM4tEnANTozwYp9ZjnUj0PP9729Ro7BPs2JjXCaD+33S1u3QwdhaKIpq8qo5Zk/r4uYTkbE3z8lrO9bHgIKmUS6sDM4biPlimai4lOyP6agdtXlfEA5Klj6Al0VdeBpAcBW1eE+TOXRbtv8jpyjML/68h2CU1VHbG/XKxFiZd7qNdFQjENeEDM2uj2m1nZT8bOUKyuWyrIpCNDimIXHPRLKucowMmEkPfTkjMHDPITU/OD35Y53WR+63rad8eV/SHcVgY42wBEWDnc8HN8sYnqHVe3qe25qnYhXiJYKifWoZoMHh6UvI9xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(39830400003)(396003)(366004)(42606007)(38350700002)(6506007)(26005)(5660300002)(54906003)(4326008)(8676002)(2906002)(6916009)(9686003)(186003)(83380400001)(8936002)(52116002)(1076003)(66946007)(66476007)(6486002)(38100700002)(6512007)(44832011)(86362001)(316002)(508600001)(66556008)(33656002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HAZmlI1fPyzipPTuIeGi7oqbo/eKyRSF073PcGyhB8XS8lz/r6qZli5CLs9w?=
 =?us-ascii?Q?HnSrs1q3V9v1U7ykxBh9ZJjgj5ao76Uuv+A7mVPuwaVfUTZdTFVRlD/raiEe?=
 =?us-ascii?Q?Jc3o9g2nSnYDfwg9U6LnOGbu2Qo4dtljTbtCxfQDJppmN6bEI7U5nAhDQx1i?=
 =?us-ascii?Q?6P7ks2yzAo2POmooc7Tvwxtm5EKBcrkfDPl8qK8KCar5nSOeqXiB8c+0SqL7?=
 =?us-ascii?Q?xYq9nrKvBtWjA6JAbYi0kosqh9qqiVMAm3Tr+zj16plbVNeOXKyGRaPmWrCB?=
 =?us-ascii?Q?etyJ6yq9DJb2ELleQjMG2UD7oMrgUr4tkp7p5597eEJ37F4GJTt6LL3RMEDA?=
 =?us-ascii?Q?zr9aLHDli6+fx6u3jQZSPuvFB+l9Akwlidg4udtyTJuV+FHb8LDbKHD0ekLm?=
 =?us-ascii?Q?E3TpSQ9MMXKgECk7j45dcUdbs/WNqSVyvzAdYoAP08I6Zfk0qrGwfR5qBGXC?=
 =?us-ascii?Q?niSzkcgWf7vKh7JJp+9encfem6rsjyLW+gL0hDcLD/7RDpTTlv21ORGFhPNI?=
 =?us-ascii?Q?QpJCs8bZHO7bj8hus+GYqlnelxAT4lgPPMZfxa+D8MNUtECRraU9Cu6cfAbu?=
 =?us-ascii?Q?KEjwMiPk6b60rp/tnkacikFJYU+khuOVcUDoF1J90Kh7VDq6TRGDPC3GMpV7?=
 =?us-ascii?Q?LFWD/RLpTGrbtHVtarssdapgvMK8d2s3cNzXXBoMgj5p91Ix99fitVt2qi/G?=
 =?us-ascii?Q?9Qx0MTdvnz9SG2lk4M5uLgMLslq+Mhutk/8sEET7ZMSH4e7GNdHsFGKxTYqE?=
 =?us-ascii?Q?CeLRVAmb6Uruuf10oMkxG7IlkBsFRZlCgocWwAfBmj2NgAsXdurKg04d1PX+?=
 =?us-ascii?Q?JLglfFRz347oKjgvzoXB5VQbdrpEznqiotX+OeQNr84AV/nBGyrhNhSbpPD1?=
 =?us-ascii?Q?15o8U7KXKBX0QG/nnTRtTUltpPrAi1xGCI4BwlIkXU6dsvMCA1U3wPvC5GUM?=
 =?us-ascii?Q?MGY0eByEMfvlmcTuOH2UvOoIWTQwihyzxjUUG2vuHPdYXoPp5Zgdb5/rntyr?=
 =?us-ascii?Q?cD5zVLD0htKlEk9u97SgjufhwTEPFXAMtpXJ8FkvK3ATE3xVPNWRgsORXUcT?=
 =?us-ascii?Q?Xl2mvv6gJeon8ruXigD/XfTd+/Bl5GL+V2FMbj2Z1NJ8ZzyR3hQ11pQ0BM08?=
 =?us-ascii?Q?Ohu4j474UujdVGUtSOj5Gp0JopWLJ22IUqrNLWrV0TeNKl24h0gbWXkTlhv6?=
 =?us-ascii?Q?3HLxSWRqnwGMYaCQguDGsPxsNq624sWG9XEGe0Fzuh2EQiNgeuACepcgPfn+?=
 =?us-ascii?Q?XSlWMXhP38YtnNybvjPSnWlB1d7FwrP523O6686JS42M0/uRoE175IT4priu?=
 =?us-ascii?Q?+MtZJVl1xo47aRs9FFkWoPZQIyQ/JAoUPXfc4Z9XJUgvQH2+qR6a/MUFMJq3?=
 =?us-ascii?Q?qhwGW54MGqA0KZ0khaFBnCLBRVYXg5WLenn8TeXGgw2IFlQieknUwOvXPWwB?=
 =?us-ascii?Q?fjR3G3hBNfFN5Irt6zYrPNJXyfwniVodkljkG9wmG8RAKxyOCnEb5ckViJL9?=
 =?us-ascii?Q?OUNwtj0TjYMaQ4vyMkCzTO15v9AbNcVvHyP+fXN8/gNotaYSDdhC9U4/rUe5?=
 =?us-ascii?Q?MIXnfMW9LP/p3H5MFPMSSTMBfrfTIAASBF2l66sNV+7yveJJmUZXX/nYKe0f?=
 =?us-ascii?Q?2Qcn5Cqw1MrmRrwH/rv/jxg3Sr4p95O5HrRqP6doW9hgAkigZMqUC4BOPys7?=
 =?us-ascii?Q?3641JmfEpktikNX7cSgpe0Uqj6Y=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1ca80a5-268f-45ce-f917-08d9e1b24658
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 16:30:05.3893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q5OF9ptJsyhmjMwgNk9FiJu6KznJ/DfaFN2lN7KjrAqtUWCVynTAaD4LxX6jFP0h1MfLpcpABportAv+p/F7DgDE9ZYA9bPT+DTCMM6GoB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3608
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Wed, Jan 26, 2022 at 06:34:36PM -0800, Jakub Kicinski wrote:
> On Mon, 24 Jan 2022 23:15:31 -0800 Colin Foster wrote:
> > Create and utilize bulk regmap reads instead of single access for gathering
> > stats. The background reading of statistics happens frequently, and over
> > a few contiguous memory regions.
> > 
> > High speed PCIe buses and MMIO access will probably see negligible
> > performance increase. Lower speed buses like SPI and I2C could see
> > significant performance increase, since the bus configuration and register
> > access times account for a large percentage of data transfer time.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> 
> > +static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
> > +{
> > +	struct ocelot_stats_region *region = NULL;
> > +	unsigned int last;
> > +	int i;
> > +
> > +	INIT_LIST_HEAD(&ocelot->stats_regions);
> > +
> > +	for (i = 0; i < ocelot->num_stats; i++) {
> > +		if (region && ocelot->stats_layout[i].offset == last + 1) {
> > +			region->count++;
> > +		} else {
> > +			region = devm_kzalloc(ocelot->dev, sizeof(*region),
> > +					      GFP_KERNEL);
> > +			if (!region)
> > +				return -ENOMEM;
> > +
> > +			region->offset = ocelot->stats_layout[i].offset;
> > +			region->count = 1;
> > +			list_add_tail(&region->node, &ocelot->stats_regions);
> > +		}
> > +
> > +		last = ocelot->stats_layout[i].offset;
> > +	}
> > +
> > +	list_for_each_entry(region, &ocelot->stats_regions, node) {
> > +		region->buf = devm_kzalloc(ocelot->dev,
> > +					   region->count * sizeof(*region->buf),
> > +					   GFP_KERNEL);
> 
> devm_kcalloc()

Good catch. I'll probably give it another day for review and resubmit 
tomrrow. 

> 
> > +
> 
> unnecessary new line
> 
> > +		if (!region->buf)
> > +			return -ENOMEM;
