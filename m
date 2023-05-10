Return-Path: <netdev+bounces-1349-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 666536FD8D7
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:02:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D3AE1C20CAF
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:02:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32FA86AB3;
	Wed, 10 May 2023 08:02:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2770D80C
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:02:55 +0000 (UTC)
Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD45519F
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 01:02:52 -0700 (PDT)
X-QQ-mid:Yeas51t1683705659t545t18989
Received: from 3DB253DBDE8942B29385B9DFB0B7E889 (jiawenwu@trustnetic.com [125.119.253.217])
X-QQ-SSF:00400000000000F0FNF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 7245937968249303649
To: <andy.shevchenko@gmail.com>
Cc: "'Piotr Raczynski'" <piotr.raczynski@intel.com>,
	<netdev@vger.kernel.org>,
	<jarkko.nikula@linux.intel.com>,
	<andriy.shevchenko@linux.intel.com>,
	<mika.westerberg@linux.intel.com>,
	<jsd@semihalf.com>,
	<Jose.Abreu@synopsys.com>,
	<andrew@lunn.ch>,
	<hkallweit1@gmail.com>,
	<linux@armlinux.org.uk>,
	<linux-i2c@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>,
	<mengyuanlou@net-swift.com>
References: <20230509022734.148970-1-jiawenwu@trustnetic.com> <20230509022734.148970-3-jiawenwu@trustnetic.com> <ZFpQF4hi0FciwQsj@nimitz> <009d01d9830a$c7c6dab0$57549010$@trustnetic.com> <ZFtMGTLiivnlrN1e@surfacebook>
In-Reply-To: <ZFtMGTLiivnlrN1e@surfacebook>
Subject: RE: [PATCH net-next v7 2/9] i2c: designware: Add driver support for Wangxun 10Gb NIC
Date: Wed, 10 May 2023 16:00:58 +0800
Message-ID: <00a901d98315$8e388180$aaa98480$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJdw4zS3rpHMobUlf9gBLGLbLpYXQJZ55l3AhfCTYMCH7b03QEwDQEVrgyXMoA=
Content-Language: zh-cn
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wednesday, May 10, 2023 3:48 PM, andy.shevchenko@gmail.com wrote:
> Wed, May 10, 2023 at 02:43:50PM +0800, Jiawen Wu kirjoitti:
> > On Tuesday, May 9, 2023 9:52 PM, Piotr Raczynski wrote:
> > > On Tue, May 09, 2023 at 10:27:27AM +0800, Jiawen Wu wrote:
> 
> ...
> 
> > > >  	/*
> > > > -	 * Initiate I2C message transfer when AMD NAVI GPU card is enabled,
> > > > +  * Initiate I2C message transfer when polling mode is enabled,
> > > >  	 * As it is polling based transfer mechanism, which does not support
> > > >  	 * interrupt based functionalities of existing DesignWare driver.
> > > >  	 */
> > > > -	if ((dev->flags & MODEL_MASK) == MODEL_AMD_NAVI_GPU) {
> > > > +	switch (dev->flags & MODEL_MASK) {
> > > > +	case MODEL_AMD_NAVI_GPU:
> > > >  		ret = amd_i2c_dw_xfer_quirk(adap, msgs, num);
> > > >  		goto done_nolock;
> > > > +	case MODEL_WANGXUN_SP:
> > > > +		ret = txgbe_i2c_dw_xfer_quirk(adap, msgs, num);
> > > > +		goto done_nolock;
> > > > +	default:
> > > > +		break;
> > > >  	}
> > > Nit pick, when I first saw above code it looked a little weird,
> > > maybe it would be a little clearer with:
> > >
> > > 	if (i2c_dw_is_model_poll(dev)) {
> > > 		switch (dev->flags & MODEL_MASK) {
> > > 		case MODEL_AMD_NAVI_GPU:
> > > 			ret = amd_i2c_dw_xfer_quirk(adap, msgs, num);
> > > 			break;
> > > 		case MODEL_WANGXUN_SP:
> > > 			ret = txgbe_i2c_dw_xfer_quirk(adap, msgs, num);
> > > 			break;
> > > 		default:
> > > 			break;
> > > 		}
> > > 		goto done_nolock;
> > > 	}
> > >
> > > I do not insist though.
> >
> > Sure, it looks more obvious as polling mode quirk.
> 
> I don't think we need a double checks. The i2c_dw_is_model_poll() will repeat
> the switch. Please, leave it as is in your current version.

Okay, thanks for all your comments.



