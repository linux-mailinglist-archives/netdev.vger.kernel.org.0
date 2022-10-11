Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A645FAC0E
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 08:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiJKGCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 02:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiJKGCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 02:02:48 -0400
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CC9868A0
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 23:02:43 -0700 (PDT)
X-QQ-mid: Yeas51t1665468144t648t04932
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FK8000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     <netdev@vger.kernel.org>, <mengyuanlou@net-swift.com>
References: <20220929093424.2104246-1-jiawenwu@trustnetic.com> <20220929093424.2104246-3-jiawenwu@trustnetic.com> <YzXL1WoOwUnU93Lq@lunn.ch> <00f601d8dc71$f0ded460$d29c7d20$@trustnetic.com> <Y0TM+eHBtGa0YLXq@lunn.ch>
In-Reply-To: <Y0TM+eHBtGa0YLXq@lunn.ch>
Subject: RE: [PATCH net-next v3 2/3] net: txgbe: Reset hardware
Date:   Tue, 11 Oct 2022 14:02:23 +0800
Message-ID: <013301d8dd37$08530d30$18f92790$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFGz/tyg7e+EkGDFw8tCHUpsPOTggGWvgXhAfnsFSECMiGtIAIWhpoxru3Tq7A=
Content-Language: zh-cn
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday, October 11, 2022 9:55 AM, Andrew Lunn wrote:
> > > So you have an IO barrier before and a read barrier afterwards.  So
> > > all i think you need is a
> > mb(), not a
> > > full rd32().
> > >
> > >    Andrew
> > >
> >
> > I think we need a readl(), because there are problems that sometimes
> > IO is not synchronized with flushing memory on some domestic cpu platforms.
> > It can become a serious problem, causing register error configurations.
> 
> So please document this as a comment in the code.
> 
> I also then start to wounder if more such flushes are needed, to handle this broken hardware.
> Do you have a detailed description of what actually goes wrong? Otherwise how do you know
> when such a flush is needed?
> 
>    Andrew
> 

We don't know the exact behavior of the platforms, but it works under this workaround. That is, read
the register once after the write operations.

