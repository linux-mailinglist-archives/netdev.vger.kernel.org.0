Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3FCB6D7D57
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 15:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238186AbjDENFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 09:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238233AbjDENE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 09:04:58 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2121.outbound.protection.outlook.com [40.107.223.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43144C20;
        Wed,  5 Apr 2023 06:04:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EF/S0ki2713xI5sV0/IjfNwYVCGYurgIH4uU8q0vHuEjNU9qQU5sSEgej93e8X2z7DZljzwCz0ZhjD8FVljbLZQifvLMmVh6uKQ3zRzv2GMlX1JcLvHJ14V683XLVGNGmJfqOdlFcsARIga1z6MoU1GU1N/j/KzLCRtUmVPEIYWSie31sRQGqeuNj2bhqAhqBKCRd/YrDbY5vRf0ZAWr0MHXBKmdg9hxZX3yZckeMTAtulLPQSOn2g2p53cG1mqDSxoin+kg94Qi8az3QYNM7QaWkz7Tobbt38kr0y41QGueuwr3XdaeuT5IRKEtff3P35XQqTxI8MM9oAXcPuFSRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a7mC/0vE7jiatcosXUxderq2ig+lIDKlSHk9MCSpYs0=;
 b=RegkJCfAwNz2ZjO2n/8u7/nIDDus4kagOfKaHU/NH8JJkqiIulaN79DZfdH8a2ThrgWlO2Qpal0PkVebs/sPRsl34QZ+ykwJb9wQ10IFaw6Lf+weoJsiyD9uDZp/cBHIYL3zfy5HW/7oSagGuw0vRTOSJFv34dX3DUoNf7dEOfuljyEfds66cGoDnRSacnmgphQNA5+SeuguVJxH6VxPaZXx6hgjSBJeHJODnC749oT8N5hiP1ILGCKN6PFz+9kIJnoC1KND/4UiIw35eFT9pw2VNfCXagYOWoZbcENP3EWx3TCH0h0IOudgqUkXQdvREjILX0KlqnTOlgcFfEdF+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7mC/0vE7jiatcosXUxderq2ig+lIDKlSHk9MCSpYs0=;
 b=u8GrSPV94MErMSfIa1Q5lZoeArIH0nFjbCCkY0MoIlBCxulnMWVCVQtfOucJvVAhtPJmPG9DeZ6ST/WBwaa0XHlGhQnJ4EU1eZ8g5eavL9JXtVl/XfqTZHTpiur+FEubRHBjkTV05Ut1oOL5AUIM5aAykUURU/yPgphYaLuJ7o4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY1PR13MB6189.namprd13.prod.outlook.com (2603:10b6:a03:523::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Wed, 5 Apr
 2023 13:04:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 13:04:47 +0000
Date:   Wed, 5 Apr 2023 15:04:39 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Denis Plotnikov <den-plotnikov@yandex-team.ru>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] qlcnic: check pci_reset_function result
Message-ID: <ZC1x57v1JdUyK7aG@corigine.com>
References: <20230331080605.42961-1-den-plotnikov@yandex-team.ru>
 <ZCcd1c0jhKxk+FD+@corigine.com>
 <b4852db1-61bd-410e-e89d-05d89cf14063@yandex-team.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4852db1-61bd-410e-e89d-05d89cf14063@yandex-team.ru>
X-ClientProxiedBy: AM9P193CA0019.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY1PR13MB6189:EE_
X-MS-Office365-Filtering-Correlation-Id: dacdffa0-ee69-4489-ddb1-08db35d65508
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7rVx34VEvrZZeNh1A9TiBtr4OyRjeCauVzEKTZgarBlG1KkQyq2MD6DFeZPeGutBZ+ssrvMg+kUQAlzw7kJC8/4RRUbQ0+2GWnTHZhnsuE8ej+4ibGYqX5/EU3cXlQmrarl3CjT031IJ6Bq/vTu7TxBev2HUOM300SXQfw5tjDxVsS0+Dq83if/CnnEYyePckRA+bWjhyQD8J5/sJs19wkQKEO1qYAz79Jyj2k8GiyXCqDbou0+5exjEwVkzRum9+tbKj5wWpLw+meMVCkyFUhkD7uofoE/fSyhKlLgBmrydYK2qU7VB5zLoIO5a2ZJMsc0i6CMZVBf+ltw+mWOQDNmxNclcPM2tzSdT+Pgngf9NpIR8ssZ4mUgxJx6Fgq78j8iQpvVhNTkb9HUZqYy14u7RPBpGfPfe0ddDkDzcWNxGr8qrWf4MUYm+aPbkkb/I1VA9MOM/ThPXwUnBUFJJ62TcH/yLfdrBvTcrOvSV0C+4+NDZ+atggcHux4fSAY56bUuz8ZSMMQKbxlfWfSoIjgr6O+xqPBzc3ABWwxkzJkv+wysa92wcif26Dadlotg6iLU+49s1mP2q1NlBNNm6/1FZzePlS5k4VdIbHkFO1NU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(396003)(39830400003)(376002)(451199021)(2616005)(83380400001)(478600001)(6666004)(6486002)(186003)(6512007)(6506007)(316002)(53546011)(2906002)(7416002)(44832011)(5660300002)(36756003)(38100700002)(66556008)(66476007)(4326008)(6916009)(86362001)(66946007)(41300700001)(8936002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1YRNznjZMTeknzq2yh6fyj+kovxBT38nM+zav5WS6JZJa41hihPLXWjRvBEd?=
 =?us-ascii?Q?E6MNFQulaCVzGwuCbs/9wWAO2mWZtvHJJw3hZYuBg8sJsYUcyDDhkAj0oot7?=
 =?us-ascii?Q?U5GvCszTVyPv+iQVb1r1ag8ZxBk7VHWkyECwO7PK1/M72xKkniWkn197Yvi1?=
 =?us-ascii?Q?yFDRB5jgpD/SLOv8xrIwn1FfE9kzUhtU78PeE8ruEoLVL4yI1gePKQkTNA8U?=
 =?us-ascii?Q?8gJvLV6Yikr6M8IitQ9xyAvp9NI5Ayh61uCEkJ0lk0SFIr9SyvhcTY0ZyUj8?=
 =?us-ascii?Q?flPDsOI2I8jivaUN0Xj4YjiucXTnt7C5Zo+GvW9g9pf/PDRnJVMYT2oZckk8?=
 =?us-ascii?Q?KznrgdXshegVVuBKcbEvVNzEA95+gB64BZWGqQBOWN/c9o0QO95Kpv/EgPdS?=
 =?us-ascii?Q?1Xo1o+jddYClryopxl/OdfaJeIVCxfcGXWix9vEALw8tTAUue85Y2dyjeIsO?=
 =?us-ascii?Q?LOP9afR+wpUN5OvkuKlblbf2sxucCM8aZfN34rwudaPEeS0QvEJ9SP1adYWr?=
 =?us-ascii?Q?zx/kQbJvGIECDf+t4jNsf8Htw7IFGiRjcX3hebGCYca8ZtzLVh69XFTemvfn?=
 =?us-ascii?Q?prHayLwZdbkKChod+C0ETN6hwOjOp0R/MrqUuZOCOOpqmt0uCqTaKM0rjiKZ?=
 =?us-ascii?Q?bkp4OO1hznIcmEHAozjQRLq/ilo1KnejWelZ9HNzIg1REvjX9GrTnHVCBxzI?=
 =?us-ascii?Q?fRrQRzCQSMAzAsVEW+l9f8+Z7QKgKeYIQ0KN7gdp6t9QuzFJyAb5CXpEZ1ZE?=
 =?us-ascii?Q?Nrb4luLWEjuE3k6RSe53Ho1+UoIHJOFNvyuqK8vWoO204f6TTJ4TpwHJpr/j?=
 =?us-ascii?Q?OS8qrZko+EDAQvjx9J2h3wV4ll4Jfn9ho26eBYRHIEUdcHKn1SAEi8yLR6SS?=
 =?us-ascii?Q?058SMNx59K9bDz2Letgllb0Nhx5ET9VJnRDYul+X9RFeKqdlVdmIQ9O3xno0?=
 =?us-ascii?Q?iSFn2cU+UqN0qxyERPpmmDVx1HJKpcEjwdp7AXMjlO9MCus2iBjaRw2+lnJr?=
 =?us-ascii?Q?CUSgbJ8xLrb7v5rjN2KyuvPU2v6VBchTstSp2jVd4gQKc3hNwFi2HJ3QKEqR?=
 =?us-ascii?Q?pmUVaMkBangP+QzTvrG4nl4WQqdcGeuGDQ/A5g+cwipiUWiszfB5eXZyemCC?=
 =?us-ascii?Q?VnMjJikbpKEpQEqNEfh0IlVk6Mu4dAayHuMp1VYRbGGCFUG0oVTrRwoM+ynJ?=
 =?us-ascii?Q?4M00maixC+lf0IyCHE5VSjI1MEJeIdAehGbcGzeSwyM8VnwjsGr8y+zZNUjc?=
 =?us-ascii?Q?g8prRv7nWDeYIpAedy/NtD1gh2iUool6cJYWmV0E/QNwm2lqzDDAintiIF3Z?=
 =?us-ascii?Q?T9GYdgda5/TvCChWcc0Sdt1zIHbG1/rain0W3bPkC48GXvsCD2ZV3lSUMLM3?=
 =?us-ascii?Q?eZMJBWI155uvCsqCTXOyIcjly/00+j8lTvZfjG2iuZ1IWys69m8iFuo/i1MJ?=
 =?us-ascii?Q?cWnBWmhWXgD0F8z9uNbXpFmJZWth9LK+8BcKElhnFxm4hwQVQD72x7Xk5NIn?=
 =?us-ascii?Q?5SkZZF94uy/Gpha9R/Ft5TJ1g665NDKOXL6eD1tu+zsT9ro7lG+nOcRpLA+P?=
 =?us-ascii?Q?n66UNfpib0Qrdr/ewoFBqgRXB7tw9hayXzvsrBMajAF/dvCWGz5VIhOfM8oh?=
 =?us-ascii?Q?Y3sbn+ntksrVb/Out25RRSgvH4Mh9QxvR+EkSfcULnR06LaY+pa0Gikl+Vpg?=
 =?us-ascii?Q?pS/3Pw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dacdffa0-ee69-4489-ddb1-08db35d65508
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 13:04:47.0966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FNVylMJVNJzMMlRFvCWLQ39gVEy/b1y2wblPbleQJVMk0Fwc2/5+jXH30VV/+2GZFlBTcuNjPy5OG126WV5nzr91mzTWgMkKqZiRWyWPsgM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR13MB6189
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Bjorn Helgaas and linux-pci, as this is about FLR

On Mon, Apr 03, 2023 at 01:58:49PM +0300, Denis Plotnikov wrote:
> 
> On 31.03.2023 20:52, Simon Horman wrote:
> > On Fri, Mar 31, 2023 at 11:06:05AM +0300, Denis Plotnikov wrote:
> > > Static code analyzer complains to unchecked return value.
> > > It seems that pci_reset_function return something meaningful
> > > only if "reset_methods" is set.
> > > Even if reset_methods isn't used check the return value to avoid
> > > possible bugs leading to undefined behavior in the future.
> > > 
> > > Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
> > nit: The tree this patch is targeted at should be designated, probably
> >       net-next, so the '[PATCH net-next]' in the subject.
> > 
> > > ---
> > >   drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c | 4 +++-
> > >   1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> > > index 87f76bac2e463..39ecfc1a1dbd0 100644
> > > --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> > > +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> > > @@ -628,7 +628,9 @@ int qlcnic_fw_create_ctx(struct qlcnic_adapter *dev)
> > >   	int i, err, ring;
> > >   	if (dev->flags & QLCNIC_NEED_FLR) {
> > > -		pci_reset_function(dev->pdev);
> > > +		err = pci_reset_function(dev->pdev);
> > > +		if (err && err != -ENOTTY)
> > Are you sure about the -ENOTTY part?
> > 
> > It seems odd to me that an FLR would be required but reset is not supported.
> No, I'm not sure. My logic is: if the reset method isn't set than
> pci_reset_function() returns -ENOTTY so treat that result as ok.
> pci_reset_function may return something different than -ENOTTY only if
> pci_reset_fn_methods[m].reset_fn is set.

I see your reasoning: -ENOTTY means nothing happened, and probably that is ok.
I think my main question is if that can ever happen.
If that is unknown, then I think this conservative approach makes sense.

Bjorn, do you happen to have any guidance here?

> > > +			return err;
> > >   		dev->flags &= ~QLCNIC_NEED_FLR;
> > >   	}
> > > -- 
> > > 2.25.1
> > > 
