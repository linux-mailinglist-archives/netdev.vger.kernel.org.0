Return-Path: <netdev+bounces-6246-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E7FE3715563
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 08:13:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CA1C1C20B10
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 06:13:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 153A98F71;
	Tue, 30 May 2023 06:13:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A09E1FAC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 06:13:14 +0000 (UTC)
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D16B0
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 23:13:09 -0700 (PDT)
X-QQ-mid:Yeas53t1685427069t065t27383
Received: from 3DB253DBDE8942B29385B9DFB0B7E889 (jiawenwu@trustnetic.com [183.159.96.128])
X-QQ-SSF:00400000000000F0FOF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 12025745897829443806
To: "'Andy Shevchenko'" <andriy.shevchenko@linux.intel.com>,
	"'Hans de Goede'" <hdegoede@redhat.com>
Cc: <netdev@vger.kernel.org>,
	<jarkko.nikula@linux.intel.com>,
	<mika.westerberg@linux.intel.com>,
	<jsd@semihalf.com>,
	<Jose.Abreu@synopsys.com>,
	<andrew@lunn.ch>,
	<hkallweit1@gmail.com>,
	<linux@armlinux.org.uk>,
	<linux-i2c@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>,
	<mengyuanlou@net-swift.com>,
	"'Piotr Raczynski'" <piotr.raczynski@intel.com>
References: <20230524091722.522118-1-jiawenwu@trustnetic.com> <20230524091722.522118-2-jiawenwu@trustnetic.com> <ZHHC6OGH9NJZgRfA@smile.fi.intel.com>
In-Reply-To: <ZHHC6OGH9NJZgRfA@smile.fi.intel.com>
Subject: RE: [PATCH net-next v9 1/9] net: txgbe: Add software nodes to support phylink
Date: Tue, 30 May 2023 14:11:08 +0800
Message-ID: <038901d992bd$863a6b30$92af4190$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIrQcdiCo7tNEhbaUMwQ6r5o07FvQMfMz0nAm3dY9Ouoo2ZQA==
Content-Language: zh-cn
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Saturday, May 27, 2023 4:44 PM, Andy Shevchenko wrote:
> +Cc Hans (see below)
> 
> On Wed, May 24, 2023 at 05:17:14PM +0800, Jiawen Wu wrote:
> > Register software nodes for GPIO, I2C, SFP and PHYLINK. Define the
> > device properties.
> 
> ...
> 
> > +int txgbe_init_phy(struct txgbe *txgbe)
> > +{
> > +	int ret;
> > +
> > +	ret = txgbe_swnodes_register(txgbe);
> > +	if (ret) {
> > +		wx_err(txgbe->wx, "failed to register software nodes\n");
> 
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> 
> These 4 lines can be as simple as
> 
> 	return ret;

This function is going to be extended with later patches, is it necessary to
simply it here?

> 
> > +}
> 
> ...
> 
> > +#define NODE_PROP(_NAME, _PROP)			\
> > +	(const struct software_node) {		\
> > +		.name = _NAME,			\
> > +		.properties = _PROP,		\
> > +	}
> 
> Looking at the amount of drivers that want this, I would declare it in the
> property.h with SOFTWARE_NODE_PROPERTY name. I'll Ack that.
> 
> Hans, what do you think?
 


