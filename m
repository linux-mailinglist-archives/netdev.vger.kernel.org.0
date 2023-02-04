Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A945A68A9E7
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbjBDNGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233319AbjBDNGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:06:10 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2137.outbound.protection.outlook.com [40.107.243.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9E828851;
        Sat,  4 Feb 2023 05:06:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JfY8ZVBvJj4Cgz03hiYREE2Iqm79Y6qzOEKADkby5LpUZq7AOlQWLiPVhI73h4P/djZ3h0xKcMUbIBHi+JtQzWVTU9U2jxUZvvmFGeVozAp12wj5XEvwJ7oy1fgEDSLXNSoIOU0MBHnY502PjWB+qQ/gdqHChmYroo/8pXckoug3N3BCIC2/Auptbxzf+fRDkUPuX+PZOWiaGwazkjTMymUygRlKeCC+W+Q9RyOhaeBABTqwlwk6vRxFu29IZG1EIhgwvay7A56T8hTVpA4L9VDwyk3s3tC2zMEdRbVy6vciQavSbznSk4wFe9GFXZQLhyHElWc83V3HD3oE5eLGZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4WPnf6/2DwT5LNV4QzclykLoQ1t7pXi4lIv8igP7tfE=;
 b=G78hPBnEgkFsZvu0NRYuQq1UgvlcdPhflBMmL+cF8Ku2pOo2cVNy3ME447tijPaf1IprtXcI/sedO4AayVMISbb+WJfi/sYPjYynCth9Ah+Vhv7QhpA+NEV63InJsKMz9+VmiqLMMj+TTTtF3Amqc0BE/BbUCCMkTnldihdzdW4cN1mfMYddc06bIo1+8RHiE7zX3ofEDS8U9njgSxJdGUYoZSIxNSbpjT4ruA0b9J7RNgds7i+y3LwFbYL+j+WsdH9CDMuFiKtqhEXdSdXVw1xxig2690x6b1B+GhH6lnHLj+J85lu0BRC9XiMfL93A+AhW1bsGZ9+ebPl8Q7a9VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4WPnf6/2DwT5LNV4QzclykLoQ1t7pXi4lIv8igP7tfE=;
 b=TVWjLDxkkjXIV11mPayaOnyX2l0lDkID5S1azPSt2gyAhQvukRYCY/IE4qLD+6QwNR3uyvg3DB1UPkKsi6WyOTrsFHWFFEBn455lmQ7tCJjKxqKrRNCwDcTSJkBTFBmH0LkQfUPc84bk6vtwyQ1fvD/86nGTqgBnAl82TWjnqBs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4527.namprd13.prod.outlook.com (2603:10b6:5:1ba::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 13:06:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 13:06:03 +0000
Date:   Sat, 4 Feb 2023 14:05:57 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 08/18] can: m_can: Write transmit header and data in
 one transaction
Message-ID: <Y95YNQwMfTM2h7iW@corigine.com>
References: <20230125195059.630377-1-msp@baylibre.com>
 <20230125195059.630377-9-msp@baylibre.com>
 <Y9I0KEeWq0JFy6iB@corigine.com>
 <20230130080419.dzdnmq4vtag7wbpd@blmsp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130080419.dzdnmq4vtag7wbpd@blmsp>
X-ClientProxiedBy: AS4P250CA0007.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4527:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bbf6923-cb25-48a6-7e54-08db06b091fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8a08y7BdzFMV68kSIPMhQnJ1RXeBnvHEArxTYW9mnoW6dZoKwNHqMVYbRu5eIlmXDDJy0xfK849RzoNm+603T/tPugyq2UmIgdhzXU4ZYkmyoGQU3M3c6qekkf3Mg4Druxuvt+931oisS9IhoKOSP5soK+Bkmoygc2y1AR+LjtgX9xiigpxTXszUuCLrZj7ld3VNkY8J6q8Dt9hUArXtXXc3WIWLJM1+0c6PclJcxxS7Z19rjEYthEG+jhqA4ILi3ZI1TC6ETAdgqmH+q2UbcK7Ead5znLcdrWD8CcjGDOLLhne3nPalSKBOj7Oug7wSPsIVyIsNjCY0PgVKsk1WPxBmzpBpjWsna0uNZWJ6yNYAFIH6Y+cDyEemARiBNdkrwMa1ZCopI6kVqnp1cN3zogzzN6K4HcolBpaNN2yccjirxVduWC9h7pbz3YheN5g4G85UFhtCLafh2qUPv6mbFWd+2W7UO34s7WuBdLL++qPE4ipv6L0Ka6AcyaGIv+wfTOp3YNu//2UTtT2CsnA2urFTV8pMlX6QfLTxkwpgdbOO1QBPX6tz2sz7YjDSeFvsoDCPGXG3eOhWHDuDRbHDjSfDC6PylSHqlZQXJrilCegMsdrt/pVMSAvW+nxURQJ9WSDyDf1/jimTNE8XFM4b1BycuLO1qv/LPuZeE6cNl1TYISNWCnV/uBfUBH2Ejp4w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39840400004)(136003)(366004)(376002)(396003)(451199018)(83380400001)(86362001)(36756003)(6916009)(41300700001)(8936002)(316002)(54906003)(66476007)(8676002)(4326008)(66946007)(6506007)(6512007)(2616005)(6666004)(478600001)(66556008)(44832011)(5660300002)(2906002)(186003)(6486002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NYFLIHOeOQMlL1i9Atiq0yLFpp45mJgwHKEqC0AOvTw7k/MSQiso2nliTG1v?=
 =?us-ascii?Q?MZKRyusuxfzz0kpYZfikvBIchjZGkb51AB8gVq/rmJnLDIt2d/CFT9EoXO26?=
 =?us-ascii?Q?TJxqa2bXOu9jn84dk9IMH1USnWc2fw30uWkBrMjZZ7+oTUNBMLGkB4lYGS4f?=
 =?us-ascii?Q?o/pUbiWQtgvEwYVpBGyAoidxMpjpGpGk/kLdf9R0jEUUZByuFof1//e7jNPK?=
 =?us-ascii?Q?1Ohig9bXeLKWAoiBMbBN8ZzbKpbfLj5iqZs3kpUUVwib5wC2SktFcucFNzOl?=
 =?us-ascii?Q?zLdhD7VqpJdGF74+OTIDH2h7zfkxLw0+o4d+Nbkzr3+Ox3SPCzdidZaLhpJw?=
 =?us-ascii?Q?Dd+Y7GvoY3YEIazj1nfjTWqoIqndTC2BqqjfPLlt6k9zx7ul4PuMGXo9KHz0?=
 =?us-ascii?Q?i3H/tiUWVjbnXBBJh0epbR+u1rbYX794WHDdzVmS5GIZERrVGsL50ghAW9Dv?=
 =?us-ascii?Q?DMtO58UqY4SHkCQ+xHlD+5mvrHTPuKwHOEgOkkDeSblonvO1O8n3WO/+zRsA?=
 =?us-ascii?Q?RzNZWTgBKVHoX9PaZZve+6Zet0gwagAdps7vf8Qs1tgE4CFj6634EZyOTS/T?=
 =?us-ascii?Q?r51Y6Lk1MCgWZbcxhRTb0d0dEu/mtcWO8qJRNSStzQuWwF3IkuPM3C9LSXty?=
 =?us-ascii?Q?0gbBRY1u51POx6P0lZGXNIL63UKeZMHr4iekIidSNH+rQ35ipvjcn9UhOokK?=
 =?us-ascii?Q?C2/9p0YzE69XljByyKRqxMeF+VgUEUjXioBydFL4FiHtxmjt48lc1M38L/yA?=
 =?us-ascii?Q?oRmuFFvYxpUfciptlJOxluFICZWpsF1KxRycp7I8VC8xuesyMnV4+mTAhksS?=
 =?us-ascii?Q?lpr8/5rtB91PVcvqeFWL5VSr0u20kIvp4wNM8NUOdeXLdKdBXu7LEFBzz41g?=
 =?us-ascii?Q?+w3mOrm7y6VRK++KPKcdZzG2V7UIDPZuu+g5v/hHFY84efGZV9aM/1MGJgc3?=
 =?us-ascii?Q?krlrfx2eckhOXJrsogkqeSHsn0Rmk/FZV2j4diipqLO2X4GW1uSc7x6d6y8q?=
 =?us-ascii?Q?UkXa55PUp0dp5Z6G1tfHqwunzsPETVmeoCBRVmmQHArKo55sL9DXvuuVEXo0?=
 =?us-ascii?Q?HGqYlcOkIxnBXPMxwpxHHnIIKtK7J3Ey+zZiNdnsmyGPEOwZ2fuluc2Fb6sU?=
 =?us-ascii?Q?ZwVp5xXodYQ3Eyj50JEdC8i+RR4rozRR+2ABhfX4oAVL3E9KKJioWU75/elB?=
 =?us-ascii?Q?qJPkOsBTY1LDasmd5PywiorRfpjfCxBGkDL9ToApcXSlZnb3B1Mp6ilfEmV7?=
 =?us-ascii?Q?H/+wvowlXqNY+IuTtvUg+sf7RCTm+NIkwPT1cuFsEQyx3g4+jOMZDD1WvBd2?=
 =?us-ascii?Q?wjEB6yZVfST/WHIN3InkzEdPnuolb5CJpZNCYazE4BPVTntWoPwtFG7pnKEm?=
 =?us-ascii?Q?F2UaQybUEyvrdhYv0JZMv/bT7CcC2mX2eEL3FhxpJmzLgJZk63OaON6gISr+?=
 =?us-ascii?Q?F9H4v5kTW1ho/1r4oY+wez9VgF5ylkFNnHYgUqfBsAEasn9/OBQZiPn+98RL?=
 =?us-ascii?Q?tNhMy25CKWl9xiMfLbMl7F2GV3xj6ZToaCM4lkcYaZKxSnG28RjpWcvUXEgA?=
 =?us-ascii?Q?zFSSM6i4ED5R0Q8OjPLMkzd8n+T8MIHWZwWkc8uYQnu+eF2bjFe9BJ5IhR+C?=
 =?us-ascii?Q?dgj1sx1OXO4CW+QHrjQeLDxRc9EYBQRw07+QX11hUFcFOrZMioeBRhTaRa3n?=
 =?us-ascii?Q?upHUzA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bbf6923-cb25-48a6-7e54-08db06b091fc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 13:06:03.8186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ff80EgNfCoRxSoU67bmeTrKwosumWDkiomH3dy04eQlOv6KmjnCeidB2MSHtGh7QtS7Ufeuf7TKnxS1A7wK7DXq/OQ5EBo90y9xQNcGxXoE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4527
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 09:04:19AM +0100, Markus Schneider-Pargmann wrote:
> Hi Simon,
> 
> On Thu, Jan 26, 2023 at 09:04:56AM +0100, Simon Horman wrote:
> > On Wed, Jan 25, 2023 at 08:50:49PM +0100, Markus Schneider-Pargmann wrote:
> > > Combine header and data before writing to the transmit fifo to reduce
> > > the overhead for peripheral chips.
> > > 
> > > Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> > > ---
> > >  drivers/net/can/m_can/m_can.c | 10 +++++-----
> > >  1 file changed, 5 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> > > index 78f6ed744c36..440bc0536951 100644
> > > --- a/drivers/net/can/m_can/m_can.c
> > > +++ b/drivers/net/can/m_can/m_can.c
> > > @@ -1681,6 +1681,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
> > >  		m_can_write(cdev, M_CAN_TXBAR, 0x1);
> > >  		/* End of xmit function for version 3.0.x */
> > >  	} else {
> > > +		char buf[TXB_ELEMENT_SIZE];
> > >  		/* Transmit routine for version >= v3.1.x */
> > >  
> > >  		txfqs = m_can_read(cdev, M_CAN_TXFQS);
> > > @@ -1720,12 +1721,11 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
> > >  		fifo_header.dlc = FIELD_PREP(TX_BUF_MM_MASK, putidx) |
> > >  			FIELD_PREP(TX_BUF_DLC_MASK, can_fd_len2dlc(cf->len)) |
> > >  			fdflags | TX_BUF_EFC;
> > > -		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_ID, &fifo_header, 2);
> > > -		if (err)
> > > -			goto out_fail;
> > > +		memcpy(buf, &fifo_header, 8);
> > > +		memcpy(&buf[8], &cf->data, cf->len);
> > >  
> > > -		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_DATA,
> > > -				       cf->data, DIV_ROUND_UP(cf->len, 4));
> > > +		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_ID,
> > > +				       buf, 8 + DIV_ROUND_UP(cf->len, 4));
> > 
> > Perhaps I am missing something here, but my reading is that:
> > 
> > - 8 is a length in bytes
> > - the 5th argument to m_can_fifo_write is the val_count parameter,
> >   whose unit is 4-byte long values.
> > 
> >   By this logic, perhaps the correct value for this argument is:
> > 
> >   DIV_ROUND_UP(8 + cf->len, 4)
> 
> Thank you for spotting this. You are totally right, I will fix it for
> the next version.

Thanks.

> > Also:
> > 
> > - If cf->len is not a multiple of 4, is there a possibility
> >   that uninitialised trailing data in buf will be used
> >   indirectly by m_can_fifo_write()?
> 
> Good point. I think this can only happen for 1, 2, 3, 5, 6, 7 bytes,
> values above have to be multiple of 4 because of the CAN-FD
> specification.
> 
> With 'buf' it should read garbage from the buffer which I think is not a
> problem as the chip knows how much of the data to use. Also the tx
> elemnt size is hardcoded to 64 byte in the driver, so we do not overwrite
> the next element with that. The chip minimum size is 8 bytes for the
> data field anyways. So I think this is fine.

I'm not the expert on the hw in question here, but intuitively
I do feel that it may be unwise to send uninitialised data.
While I'm happy to defer to you on this, I do wonder if it would be somehow
better to use memcpy_and_pad() in place of memcpy().
