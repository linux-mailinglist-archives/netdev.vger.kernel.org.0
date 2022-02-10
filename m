Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D86E4B108B
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 15:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243003AbiBJOhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 09:37:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237546AbiBJOhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 09:37:32 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2132.outbound.protection.outlook.com [40.107.93.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEA727C;
        Thu, 10 Feb 2022 06:37:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sp0P4BnDyXlF6quUKjtZA8PZWop3S/DT+IpmiFmjmLETFXH4j9/EORBj3Vx0OKGKNoveH03Gsth8gBB2FkPn9xRkFMFtG2oXyBPMQEaZeYNtVzN1yK3Z+nMw/+apmNONkz8ebO7gnMljJ4sFHbNvO/C3RUe645vIU+vAFrImcQLyCVdokBpRKvVpfctwhMBAry/MIeGQLY8rrhGJVZ/gFKOVyIadPZnVttq7bW6CvilDg69IG3OhtloeiVQr60LVyS1XWXd9VR/iIK2wSfZE+kdaBtwxKPsXP8tppt69FEEc4aU1gMLLKM+DklOYJnwfrcQDGYpOe1et5aUw0iWemw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0X5rxW+CrwyH6+TfqQ8v998hG8HhHSQE+cIq761JDz4=;
 b=m6MGj+OWdQsCieXeszDWPwoCIfV0mngJaOkHIQ1CXUc9kCnblXhwhOla78pH3j+FWLvrhElZQCTBvmUOnUTXrn98+7PQoZ2d3WxVTVjEr2YNkcLceTouUlQxQNr3ZmZbd4nvrx0aXDkdvNBdPURPwmI386Mj7pXccMaeGup7r3ESKZMX+zYljL/RRiPz+Xm+KbD/wG2oXz1uiLeG0dollxaoYj+eG9w7H1N55k9fYb0ks4RCliiaLK8p4B8vgSGtw1tYaTUgr6Opp1As8qXy6N1Lx2GlFCV/ZSuQHpO2+FDYYfzdxY4YnwtwXYXRWBOHdGiOSPi00CaOQ7eAj5GDVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0X5rxW+CrwyH6+TfqQ8v998hG8HhHSQE+cIq761JDz4=;
 b=YRulyS6pUL0MAjZ8hjzam2DwlNkw3GSjvj1W9pvtu8d2YsAEihqwZJ638nDLCUf5k4L+0ZN4lJ9dKZ/kFw66MsPm5J+AxqPsve5JIIbXk4oPYeJPVgsbI9Oeu0UGA8xRoAHygR3PHNyw0YHguIt3XJmrL6u7aMvNCKBp9lhZycA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB5515.namprd10.prod.outlook.com
 (2603:10b6:510:109::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 14:37:30 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.4975.012; Thu, 10 Feb 2022
 14:37:29 +0000
Date:   Thu, 10 Feb 2022 06:37:23 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v6 net-next 5/5] net: mscc: ocelot: use bulk reads for
 stats
Message-ID: <20220210143723.GA354478@euler>
References: <20220210041345.321216-1-colin.foster@in-advantage.com>
 <20220210041345.321216-6-colin.foster@in-advantage.com>
 <20220210103636.gtkky2l2q7jyn7y5@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210103636.gtkky2l2q7jyn7y5@skbuf>
X-ClientProxiedBy: MW2PR2101CA0012.namprd21.prod.outlook.com
 (2603:10b6:302:1::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a34ee9db-9faa-4a2e-3216-08d9eca2dd5a
X-MS-TrafficTypeDiagnostic: PH0PR10MB5515:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB55154A3624B3B91642D41319A42F9@PH0PR10MB5515.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:747;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 03uZ8sPIEm8uCXoTGDyq1CvQfJs0JKjM12Q945Yxsja6npnbhsNua+BVEyLGnqfVSsLuqIZbh6K4mNE9uDYHtDjL5CMMtYYdNZcgaygOgrPVoUAbFCYEQfFvmV2t0/204kETH9Jxhn5c9D+gY+MXt3EK/kOwqFQoe2FBE1do6vzeWwax1y1iJm+SrxQgh/zNsiF7R9eCZkIf7mqZt8ygJpejM5z60OWaxndI042asKE0+f2Rctm9OJubdqYWSwA6MkhCfO3dhDzcFULnrt6+IZCpFRC2Ck2zAkc9vWxB6MJcSW5f8ScoKw/99G90Ws1ypkgRV+6TJsfCIhIesvMx9RrDwb/HV1qPUacMLUriQ/lCVpB240MFXQl5XkbLS8c386+kiBh9M3TI1Ogbdl3BvWLyxxgACYp5VytL61jBItOvmi0FhQnyljfe+37AXG+K83ZS+X6Qe9DBESd4qC9UbjhYO+ArL8TMMGYaw8ueMA6y0P/MO2l59YuTkJH88ZjatZvyFCYFUMKxIxUSkjbdMhNXpXexCseGBp/prF2YMPpkUx7q0X13BjsxvXepb8fnjSzyQ9nYVm+DxGfQgvbePd+doqVnotY/ROrMkpm6OdsKfD1BS6YZIQcMQ8nO/DEIAu9b+6ROZ+3cOE+KLjuetN2YvHunxvM0eTe0DYaDkfTx/FPGO7VMBc3Tk10MP6GFySE36sg71KItlAkLgQew7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(346002)(366004)(39830400003)(396003)(42606007)(376002)(136003)(186003)(83380400001)(5660300002)(86362001)(33716001)(33656002)(1076003)(26005)(38350700002)(44832011)(38100700002)(2906002)(4326008)(6506007)(6486002)(6512007)(9686003)(508600001)(66476007)(8936002)(316002)(8676002)(54906003)(66556008)(66946007)(6666004)(6916009)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qMOAOk7qDGL27BuB0BSA7oFy2Wag8Wfu/rHT7sjMzMC/1Q0tlve503T9n0mm?=
 =?us-ascii?Q?/EQrH8bQu0XRY4MDdMlQI6rv489SUx+DNm3qZBySYU2ikNT2xXAOtKlCig3P?=
 =?us-ascii?Q?Z+lsFBjoDwahquYVEKStWE22tjcfZu1E+g7oejqLaUCTlYEu+9/wdXSST7y0?=
 =?us-ascii?Q?OXm4V/pyXkha92d0DBg6ha7NHiepZib3IeBcwjVSgs49RwHDj4y6D54xol9H?=
 =?us-ascii?Q?S/EqmhyMdUxUf+dW/ywfopXCaX5U+ZY3kn1nXjHDhshlWTpB8AaG+sPbVUEs?=
 =?us-ascii?Q?k/PkXFsE2ZKTDUu+SnngY2rS6M7YJ+eHfEbsrzQrqJSY1D/i5wBvwsq8tBRs?=
 =?us-ascii?Q?zvu7DKIRvS2OcA9ybqRV5v1LOLuqSiTT2U0IL1V4kSty4Hh9t7ahnhP4dJcL?=
 =?us-ascii?Q?5EFsqCAGi9JqYa/Gyz45WV+lPwkHHH6ss6Weu4NQPUNLwP69ZejixACjF+gi?=
 =?us-ascii?Q?ZtC7FUclyYekApllzf6p9TgvOZT4kvfQ0v1cfr0zDNuoMG7DwaI9irCy6vQg?=
 =?us-ascii?Q?SdFLV3yBB8MkjcViPoKw+GytVC6/ugyCwdPViNS1Q+8hlFIiHGXawEfeOBsE?=
 =?us-ascii?Q?0I7wdLG6NXnUgyIAf/B7v2Oz7gU/3YCuMFIus2zxTuhkOZeJt3vf7w2JSwIG?=
 =?us-ascii?Q?O/BY2JEAUNsE2kJVs5bb/ADcFkz/nybPSXBVm5zAEUNRgirSQ8zf7WhnnlZL?=
 =?us-ascii?Q?faN8XJO/OGIYJAFf5t4AgfMdo/aPhaka6AQyOFzlu5MxtGrzkWVVQW7jn90k?=
 =?us-ascii?Q?gMCYIHtwPEZ85haalRdVQ0XGgGzfSXM0idwuYkd3pvT2rAZaRRsIsTY6Zw5x?=
 =?us-ascii?Q?D0sSoD3NN8MaQvziBajSppRdofY90iMmqi/7mfEZw2tFws1ifSk08gQi8ah5?=
 =?us-ascii?Q?qvpKHIDMK45irjxt8hXT0zCtb0gd2VF6FHJHk7kOeUWUuzTKKoSc7dUEqlus?=
 =?us-ascii?Q?1oawzbAPlGcyL/jPE2QC+6ELwIZ19/Q6/IVugECh2MBy9VBAfwFZIYdu0Zfp?=
 =?us-ascii?Q?wK7oJTC/E+nfax9ceDcjY/00W8TK3DU3Mze7XrKAzCZuJCvvEeYDiJRs3wwz?=
 =?us-ascii?Q?N271qM1GLYwRrNmqEe0IyEiHHb4HbnHMKbP1h7rYb89ELoDk2t0LO5DuiZG0?=
 =?us-ascii?Q?PFwgyZCksCAMmVbMaz6bl3cd3ECMfgivjQP1C4pm02uXbVq0Ytw3PiSeD6Dw?=
 =?us-ascii?Q?TewwhqTvKX6hPC57wDrPeTbxxpnWomUGSnTzhnXfTfzWD/YkkhAZzchRssAk?=
 =?us-ascii?Q?8YvVKcB+03t0gyYn0UbdkTJbgieFVHFoV4VL43IEiUVtUC5rGb1JA8qBiiJ/?=
 =?us-ascii?Q?S71YDUYHd6HMfKnWbJK7cyAmTc5ZqJIm3WNy7zQ37jO3M7Gfx101+rbtZVKD?=
 =?us-ascii?Q?bHVjuAmfL4GfvYvaUECpMI0W1Ub+wyBPDVDR2kypvXYqtFBd+Pl4cqImKu0Q?=
 =?us-ascii?Q?vpbc5YFEcwJqUhDILrcHR+V/bKvSvCtTXnqv7rhrziszsRGid+wTAH/Sii4m?=
 =?us-ascii?Q?DAsCscxMP6YavblWVXav38vzouusHOsVrxrdp7Pz2yrodVQ+TwtVSNtNef1b?=
 =?us-ascii?Q?3+NDrjLQx4ixoNsgH64mrLGIRAvYuT66MKx92n0LjN7R4NRZ5OAxFGMdDSjF?=
 =?us-ascii?Q?wnviwiFTGxBLSBYgzzt+874kVslTJxveUYo3IdjAoAJP/y98NpzPIEosSN/h?=
 =?us-ascii?Q?IzBj7Q=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a34ee9db-9faa-4a2e-3216-08d9eca2dd5a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 14:37:29.7168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uzQii+rHtfS9bYmUOVfXmPc92onTJR8Oa4MOBYe5b/9axmMxpDIVEji7hRLEsWXjAlqGiBtpN5HTVg4WFQ6CJY2n9KzTgrv9ALCaeK2fBN4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5515
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 10:36:37AM +0000, Vladimir Oltean wrote:
> On Wed, Feb 09, 2022 at 08:13:45PM -0800, Colin Foster wrote:
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
> > ---
> >  drivers/net/ethernet/mscc/ocelot.c | 79 +++++++++++++++++++++++++-----
> >  include/soc/mscc/ocelot.h          |  8 +++
> >  2 files changed, 75 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> > index ab36732e7d3f..fdbd31149dfc 100644
> > --- a/drivers/net/ethernet/mscc/ocelot.c
> > +++ b/drivers/net/ethernet/mscc/ocelot.c
> > @@ -1738,25 +1738,36 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
> >  EXPORT_SYMBOL(ocelot_get_strings);
> >  
> >  /* Caller must hold &ocelot->stats_lock */
> > -static void ocelot_update_stats_for_port(struct ocelot *ocelot, int port)
> > +static int ocelot_update_stats_for_port(struct ocelot *ocelot, int port)
> >  {
> > -	int j;
> > +	unsigned int idx = port * ocelot->num_stats;
> > +	struct ocelot_stats_region *region;
> > +	int err, j;
> >  
> >  	/* Configure the port to read the stats from */
> >  	ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port), SYS_STAT_CFG);
> >  
> > -	for (j = 0; j < ocelot->num_stats; j++) {
> > -		u32 val;
> > -		unsigned int idx = port * ocelot->num_stats + j;
> > +	list_for_each_entry(region, &ocelot->stats_regions, node) {
> > +		err = ocelot_bulk_read_rix(ocelot, SYS_COUNT_RX_OCTETS,
> > +					   region->offset, region->buf,
> > +					   region->count);
> > +		if (err)
> > +			return err;
> >  
> > -		val = ocelot_read_rix(ocelot, SYS_COUNT_RX_OCTETS,
> > -				      ocelot->stats_layout[j].offset);
> > +		for (j = 0; j < region->count; j++) {
> > +			u64 *stat = &ocelot->stats[idx + j];
> > +			u64 val = region->buf[j];
> >  
> > -		if (val < (ocelot->stats[idx] & U32_MAX))
> > -			ocelot->stats[idx] += (u64)1 << 32;
> > +			if (val < (*stat & U32_MAX))
> > +				*stat += (u64)1 << 32;
> > +
> > +			*stat = (*stat & ~(u64)U32_MAX) + val;
> > +		}
> >  
> > -		ocelot->stats[idx] = (ocelot->stats[idx] & ~(u64)U32_MAX) + val;
> > +		idx += region->count;
> >  	}
> > +
> > +	return err;
> >  }
> >  
> >  static void ocelot_check_stats_work(struct work_struct *work)
> > @@ -1777,12 +1788,14 @@ static void ocelot_check_stats_work(struct work_struct *work)
> >  
> >  void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
> >  {
> > -	int i;
> > +	int i, err;
> >  
> >  	mutex_lock(&ocelot->stats_lock);
> >  
> >  	/* check and update now */
> > -	ocelot_update_stats_for_port(ocelot, port);
> > +	err = ocelot_update_stats_for_port(ocelot, port);
> 
> ocelot_check_stats_work() should also check for errors.

Worthy enough for a resend. I'll send the fix patch to net with your
correct email and send this update once that gets merged through.

Thanks!

> 
> > +	if (err)
> > +		dev_err(ocelot->dev, "Error %d updating ethtool stats\n", err);
> >  
> >  	/* Copy all counters */
> >  	for (i = 0; i < ocelot->num_stats; i++)
> > @@ -1801,6 +1814,41 @@ int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
> >  }
> >  EXPORT_SYMBOL(ocelot_get_sset_count);
> >  
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
> > +		region->buf = devm_kcalloc(ocelot->dev, region->count,
> > +					   sizeof(*region->buf), GFP_KERNEL);
> > +		if (!region->buf)
> > +			return -ENOMEM;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  int ocelot_get_ts_info(struct ocelot *ocelot, int port,
> >  		       struct ethtool_ts_info *info)
> >  {
> > @@ -2801,6 +2849,13 @@ int ocelot_init(struct ocelot *ocelot)
> >  				 ANA_CPUQ_8021_CFG_CPUQ_BPDU_VAL(6),
> >  				 ANA_CPUQ_8021_CFG, i);
> >  
> > +	ret = ocelot_prepare_stats_regions(ocelot);
> > +	if (ret) {
> > +		destroy_workqueue(ocelot->stats_queue);
> > +		destroy_workqueue(ocelot->owq);
> > +		return ret;
> > +	}
> > +
> >  	INIT_DELAYED_WORK(&ocelot->stats_work, ocelot_check_stats_work);
> >  	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
> >  			   OCELOT_STATS_CHECK_DELAY);
> > diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> > index 312b72558659..d3291a5f7e88 100644
> > --- a/include/soc/mscc/ocelot.h
> > +++ b/include/soc/mscc/ocelot.h
> > @@ -542,6 +542,13 @@ struct ocelot_stat_layout {
> >  	char name[ETH_GSTRING_LEN];
> >  };
> >  
> > +struct ocelot_stats_region {
> > +	struct list_head node;
> > +	u32 offset;
> > +	int count;
> > +	u32 *buf;
> > +};
> > +
> >  enum ocelot_tag_prefix {
> >  	OCELOT_TAG_PREFIX_DISABLED	= 0,
> >  	OCELOT_TAG_PREFIX_NONE,
> > @@ -673,6 +680,7 @@ struct ocelot {
> >  	struct regmap_field		*regfields[REGFIELD_MAX];
> >  	const u32 *const		*map;
> >  	const struct ocelot_stat_layout	*stats_layout;
> > +	struct list_head		stats_regions;
> >  	unsigned int			num_stats;
> >  
> >  	u32				pool_size[OCELOT_SB_NUM][OCELOT_SB_POOL_NUM];
> > -- 
> > 2.25.1
> >
