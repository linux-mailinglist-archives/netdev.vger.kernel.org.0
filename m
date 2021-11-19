Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650114567F0
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233991AbhKSCTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:19:30 -0500
Received: from mail-dm6nam11on2122.outbound.protection.outlook.com ([40.107.223.122]:11104
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229830AbhKSCT3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 21:19:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FtoNtbHpxTfw4okVVAPBgzYtn5iUBXr60P3XuuJmDXYQqFop7aHRNXGbi3kfQFoV3e2VjZWQsTGkb5IPtUIin5Z1jazv0VFrOShQGqhJhYyIL2o85Na1E4raDJOtupk4MFXN+T6KbimPusjx1wfrbbVPP8xlcqJR7diVeQE0pj7QpK71TpGCRgN1jtBfQgK0TqfQGL6HMEnOibK2Zy/RggvRGmsqR+rXkG7T/xei19UN6L1QwKtC0iLf88YZOAyOpujouHglKPqQnz9Uw+HJiyQWJOw+S+4nFZcodez8yKdgdZVnGX79S36V0E7/zK5HtmNgYGiLWZ3hCpRdfc5GZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SeVLvStSSwbu4qW0qh6ETvXScJfxeRkzu8YxE2bguR4=;
 b=P8n5tbM4LnpkWYd/AOmn3JpeRv04dC+fUlVxkPe5pCLfEs9kOCncVXS7oje4vQv0F7YltJgfBgnmLz0fg73C8GYUEhSj76h29i4qFPcxVB7QJlcd2G7qLzCtnPr3VQZyltRBBKYMOXICpuBKbjQSe9bsjtdD4xtd/x2nUGyo0SlazVnA2zBJyF1vzSrGBbvs131/v85AU/4lplbcWVzfM2Ya60TJlAGjEXGTVRDDMXjplhv+mgPHhma0JiuzD+MCCABOfYLHqT5M7zSJTevv/pkEoM33Ci9hzxwfAExjeJmYYoP4822HFH5bgZkDoFlucwh9Q3dphgkfv+lpnvwxJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SeVLvStSSwbu4qW0qh6ETvXScJfxeRkzu8YxE2bguR4=;
 b=kvJ96Ce3uMP2tbX5E7ISRUUKhNKhGyumwwaJVLto3BJTwe1y7HRJ3AEQA6Q1xC0P8xcCvU4n2WpdSNT6zypCb977w6aGeB1V2Zy8arTX+mHE9jTrk/7w5cpVGQitp2xqo6BDHw5/8OWbkcqF8QPCuZy9zzAdzEYpOKTBsA5BcU0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW5PR10MB5805.namprd10.prod.outlook.com
 (2603:10b6:303:192::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Fri, 19 Nov
 2021 02:16:27 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4713.019; Fri, 19 Nov 2021
 02:16:27 +0000
Date:   Thu, 18 Nov 2021 18:16:24 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [RFC PATCH v4 net-next 11/23] pinctrl: ocelot: update pinctrl to
 automatic base address
Message-ID: <20211119021624.GB1155@DESKTOP-LAINLKC.localdomain>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
 <20211116062328.1949151-12-colin.foster@in-advantage.com>
 <YZPsIW2bfbBThtWj@piout.net>
 <20211117144705.24f21ef1@fixe.home>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211117144705.24f21ef1@fixe.home>
X-ClientProxiedBy: CO1PR15CA0091.namprd15.prod.outlook.com
 (2603:10b6:101:21::11) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from DESKTOP-LAINLKC.localdomain (96.93.101.165) by CO1PR15CA0091.namprd15.prod.outlook.com (2603:10b6:101:21::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Fri, 19 Nov 2021 02:16:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b8d0a3c-cf2e-4e7f-009d-08d9ab0297a4
X-MS-TrafficTypeDiagnostic: MW5PR10MB5805:
X-Microsoft-Antispam-PRVS: <MW5PR10MB5805B754CAA60CC12B51CCABA49C9@MW5PR10MB5805.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0MZa61sRZ6o4EmwrzbAuJSZ/2QFgo9rLk6bKK64WJlhuNih05k2Iwvt7sDQNHjf23fgVmKD/6OYruIghsk612F0HLS8TNy+ZYpYz6dJ3+jazb88tigoF+8c4RZP6ZdAWWg1peuXP/47hoNwsHfJsPm3vE1rzxsbZA8uo5JNDOyTCAeBfrB5VJC+sEHmcOH9P5bNfO7kMMXbVF5eEXi/KlIS3d78LS5ub1rdfk3AQiIORCDWuGRVAjY74xkpeNPFkSujKgt2tCihQQwcFlxx8ENbGuD3HAMDBoNvt+VYRd3vKfWK2m4Oc1xqs3tY6BYuNDCclRv9J/ztJwZQLZWdUq+1vXtAx14g1ALI9OHEx6xGYAV1kDEnUgHNaS1NAKUqrq23lZtDcf4iiZNprQHPEPFaf+zNlaFXDsTBmlN1VUQpzErx8+GG5aLzo5wUHHzo6JDlOMLYTsXkaN90BAP0SyxfiyT489iSt3OHz17FjqvWLm7i2ZF41xF7NJ5A0cqHo/yHR8SlvOaCvnbf49DhKhPBI9U+VNyFsrZ429T3xNERtEnf7we6WiM6XEb27g9qsZmg0bwcL9vTCRun+crSJmOIEcxWQXdOpSN0TP6stgP6/UCUCKH5spBQ8k3QHEQoqX2WmIN5kaD4zjBirQOO2JKMxPNFwks5oDSxaqiSoB231bbkjkmW9+1f45ZjeYAgCTUlD3CvSfBhn5UWfWqIX+C+NNS8ihZcj50NhAvoI2UG6ZfuwX+ermDEFBavDBTGjCPebBRknu5kpolfns1xdM5CGrXza42dTJMQCcmRmxuA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(376002)(136003)(39830400003)(7416002)(55016002)(52116002)(54906003)(7696005)(508600001)(2906002)(1076003)(26005)(4326008)(86362001)(966005)(5660300002)(38100700002)(8676002)(38350700002)(33656002)(66574015)(66476007)(66556008)(6506007)(44832011)(186003)(8936002)(316002)(66946007)(9686003)(83380400001)(956004)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEw0T0pnaTIyOC9ERUNacHlTRUMycGkwMmFVMmVvR3dWbWFlV3FFdW1oVWxH?=
 =?utf-8?B?NHNMZUVlS1ZYcitDRkRib3VJR1BRZTcyS1dwS1RkdkNyMFN3dkRJVmFFWXY3?=
 =?utf-8?B?bllvdWE0eDlldnJzSlg3Z3Z2RlVNa2orTUJPcVIrN1Q5ZU5nQlNXWlZkVmNC?=
 =?utf-8?B?Q2tsUHNWS0NwbFRPWlovZHpEY3FZUzZOcTRyUWtnaU1SbXA5OTI0OEZmRzI0?=
 =?utf-8?B?SXRpV2tGVitPT2pIYUFsZmY1cWRaczBJODJsYXJMbllhZTcwOWtuUmJxcG5t?=
 =?utf-8?B?T24yOWtQSjN2TmtlWjJsa2xvYkhqcWNERHlDWDZ4Vmt0VUxubHBZMTNFWGty?=
 =?utf-8?B?V3ByNFRhbXhTTnZIWVp1K1U3cTQxRzhyWHArbFY0NFo5R0Y2K281N3ZBRHl3?=
 =?utf-8?B?VGMyajJyblRUMVdyNTdKM0pJQ0duZHhSeFZRT3d3U1ZuWGlocUh6UU1SQkJz?=
 =?utf-8?B?aXVsRmxBeEVwTWpadzBpSWg4RnFXSTloa0R6WlZqTUw5MnB5Q2pVdFZEUUJK?=
 =?utf-8?B?Szg0djB3ZktQUTNqTGltcWtjeHNRMTdtamVTTnhKTEE5VnVjR1VqNURLRjFF?=
 =?utf-8?B?alRObmxRaEU1SHNZWSs2YXZOV2ZPbVgrYUpmMGR4aXhEZlN0eFc2UEdPWW1C?=
 =?utf-8?B?TWV0VEV1YXJRMUtBd3ZQcjVSOGZIWEVtZE44VVFzcDZZUHJLK2ZIM3F0NlJU?=
 =?utf-8?B?T1dPUEpteXU5a0o2R3I2VGVXWVhDNlFOaDdoaGpmNFR5dlpmOGZqbEVUSWVN?=
 =?utf-8?B?QllFNGtHVk1aZzJ4NVJLcHdITFd0TCtIZ0Q5Mms2ajRKdjRtR2IvYzQ5R0l5?=
 =?utf-8?B?Y2xSYnMvMnk4RDhMVXMyVGo5eFVCeWM5OFdUZFVHMzVvOS9FRFIvR1RZMlJr?=
 =?utf-8?B?UzVkc0tnWkNVRXBoMHNFZUZYRXNsNjh6d0R4SUpOYzVIMXREeVJKUnRFSDUv?=
 =?utf-8?B?NXhXdmEyZXN5OW1TN2l3Ym5vTnUvRTQ4ekRyMGZlQkFtSjZCdUFSQWFaeXBj?=
 =?utf-8?B?bDM5dXFNQlZ6bmpOUzhVZWdZaDJsTDZHa0xMRGV4SWJrMVEzNExMRUNPaWxm?=
 =?utf-8?B?UHk5SktLUWVWNFQxMjJvODVoYWdtWS9mN1VyRURjN3dxRVdRU3Z0ZzRQVFVh?=
 =?utf-8?B?RStWSGthb3VrcGE0dExGRHEyMnVpdzczN2luZ2VEQTBVYnRpL09OWXlMK2Rz?=
 =?utf-8?B?WWtrcW9tZHdYRXNZQ0VvL3ErTnEydDI0VlgrWHJ2Z0txRVJ5OUlSSmE0MC8r?=
 =?utf-8?B?bmZ1UFE4a2R5cjMvdGExeFR0U2NHV3Flc2N0N0EyQmdENEdENHVCRFRrZHFS?=
 =?utf-8?B?UHAvcjBObCtWcklDOVBZWENXaXVNakJnUFdST0lhREZRVUhXRGZTT2NtTi9X?=
 =?utf-8?B?TlhNSHNPM3pXOVczSS9scEZYUzR4VHVNM2k2bmhDL1FtSWgwNWdOM0lNeVQw?=
 =?utf-8?B?bmhWdXRaTjdnanJhd1dDcmVmeW42L3IxWE5JY1phZ0JLQlc5OUl4eXJwSUF2?=
 =?utf-8?B?RDFNZUZCQWdqRmkwZ2N0S28rUTVVR1R5d3Z4NjlPMzFyRDRwZThqM096NUtM?=
 =?utf-8?B?amROcnlVbnRXWmlxTXhYUzFuZ2ozTVBhNVpiUHlIZEdKUS9VTUJHY3pZbFJv?=
 =?utf-8?B?Wm53UFVwbm1pOUxyeW5hOFZsQThlb21wcWdHQWdSTy9DSFpFZkFHS0NmQWR1?=
 =?utf-8?B?ejBybks3MWxkd09aN2RIUWw4eFlsTEhFMmV4M0JhM2dETWpqZjlNY1doTmRP?=
 =?utf-8?B?RXVlazd5cmRqUWFseXFEWkxwbmlmc1NrbTlnY01wNFpDa2JtMGxMek9Zek0w?=
 =?utf-8?B?SzVxbXE0cXNTSHduQ0xUdVZoRjE5YklUT05OVW5sbytVd0VLalNKM2N2RTE5?=
 =?utf-8?B?U28rS01PazZkdE9zRndPU0VXLzQ5LzdaWWdpcTVGdHZycUNSZERQQzIxcUg0?=
 =?utf-8?B?K01iVnNETXR2OVNLU1pjdUg3L05hdXk1bkdmcDFKY2dmbVhpd2dkUFdBNlZy?=
 =?utf-8?B?S1V4QU5kU1hQbEtpNDNsaWFUZmsyUm91aDkvd0RETDUyR3RqeFhqWEpBT0V1?=
 =?utf-8?B?Tzk3L0RKNDBjbFFWbVdTb3YrczZUL0VhaW5jR3MzT1JtZExsWE03Nmo4dUJG?=
 =?utf-8?B?VVd3YUY4S0MzVjliY3VwdklJR3hLanlPYkFTZmNvdlA0VUxyenlkUVBxS2VX?=
 =?utf-8?B?SCtUb1ZhK1FSTGwvZkpRblJ3OWdGSExTWmYxcXUvVzVhMUwzT1c1U054VG9o?=
 =?utf-8?B?R1IvNms0VElMVHkxYTBwcXZGUkR3PT0=?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b8d0a3c-cf2e-4e7f-009d-08d9ab0297a4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 02:16:27.5126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vx2sT60uAYhPdu1pMUCXDJ5JWmeHRhzabbE67kz2zpLJq++rk4cwQfelpflCgihrARG0wj0e0vYTiK4AXkC3v5Y4SK7DDFcMFcvYtZAmAJw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5805
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 02:47:05PM +0100, Clément Léger wrote:
> Le Tue, 16 Nov 2021 18:36:33 +0100,
> Alexandre Belloni <alexandre.belloni@bootlin.com> a écrit :
> 
> > Hello,
> > 
> > On 15/11/2021 22:23:16-0800, Colin Foster wrote:
> > > struct gpio_chip recommends passing -1 as base to gpiolib. Doing so avoids
> > > conflicts when the chip is external and gpiochip0 already exists.
> > > 
> > > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > > ---
> > >  drivers/pinctrl/pinctrl-ocelot.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
> > > index cc7fb0556169..f015404c425c 100644
> > > --- a/drivers/pinctrl/pinctrl-ocelot.c
> > > +++ b/drivers/pinctrl/pinctrl-ocelot.c
> > > @@ -1308,7 +1308,7 @@ static int ocelot_gpiochip_register(struct platform_device *pdev,
> > >  	gc = &info->gpio_chip;
> > >  	gc->ngpio = info->desc->npins;
> > >  	gc->parent = &pdev->dev;
> > > -	gc->base = 0;
> > > +	gc->base = -1;  
> > 
> > I can't remember why but I'm pretty sure I did that on purpose but this
> > indeed cause issues when the chip is external. I've asked Clément to
> > check, let's see what the result is ;)
> 
> After testing, it works on ocelot pcb123 board.

Thank you! Glad to hear it didn't break anything.

> 
> Tested-by: Clément Léger <clement.leger@bootlin.com>
> 
> > 
> > >  	gc->of_node = info->dev->of_node;
> > >  	gc->label = "ocelot-gpio";
> > >  
> > > -- 
> > > 2.25.1
> > >   
> > 
> 
> 
> 
> -- 
> Clément Léger,
> Embedded Linux and Kernel engineer at Bootlin
> https://bootlin.com
