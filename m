Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86DB45A910F
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 09:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbiIAHr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 03:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbiIAHrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 03:47:18 -0400
Received: from sender-of-o50.zoho.in (sender-of-o50.zoho.in [103.117.158.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1092BB1C;
        Thu,  1 Sep 2022 00:45:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1662018254; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=OUKwXP06JyBShM0lVsZPEn9hR711amw+fz7BzyMHNv+CA6wjwCeqrzftloTPy/wSzC3vZOULQMrRPd+5E82myqlzXLXOH/hhNZBpXwBdMgAg/frz8GqdwZMzpVJ/gVEoywhVnFuorGF304VXQJbIU779B/lgyFseVCI6vGeddmk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1662018254; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=8Q6F9jaqQPy3UvEI+uLKzcrDWPbXthbhfdMMNG359bA=; 
        b=bjWI49foavIJeD6uevNVqQPz0ia0JMQ9TVI9M+oIouuI1u/Mx3NpJPsLg3rAwVvYknwvfD9JmXH5P9iZAMIYmSy8TixqmQml7Nnnn60i3A82n9GMklx8cEpQ5j2TP8qaesl32ZpjzE8r6RLGiV4gWuvB2ryi5nfYZ6GGZZkYZc4=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1662018254;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=8Q6F9jaqQPy3UvEI+uLKzcrDWPbXthbhfdMMNG359bA=;
        b=HO+/5qlCThvhSpkPO7jaqXBcg4oK7HVn+cF7eM7qyAEEUvK7yF5rF4+Y5FlsMQhW
        +trjtNIMumt8CV+05NWs7S5ubf0EIPP2VSQFyns8TmnapPIEmTwpuGlqGzV4f0841ul
        g0gRo5Dk51jfuhtITVoLetrIJ3VRfmnlQXGdLaTY=
Received: from mail.zoho.in by mx.zoho.in
        with SMTP id 1662018242963613.3045038319508; Thu, 1 Sep 2022 13:14:02 +0530 (IST)
Date:   Thu, 01 Sep 2022 13:14:02 +0530
From:   Siddh Raman Pant <code@siddh.me>
To:     "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc:     "palmer@rivosinc.com" <palmer@rivosinc.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@rivosinc.com" <linux@rivosinc.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Message-ID: <182f801c979.751199c4530197.7043811006670900472@siddh.me>
In-Reply-To: <MW5PR84MB184223FFE931E4B121AF7AC0AB769@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20220812055249.8037-1-palmer@rivosinc.com>
 <20220825110108.157350-1-code@siddh.me> <MW5PR84MB184223FFE931E4B121AF7AC0AB769@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
Subject: RE: [PATCH] Bluetooth: L2CAP: Elide a string overflow warning
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Aug 2022 01:21:58 +0530  Elliott, Robert (Servers)  wrote:
> > -----Original Message-----
> > From: Siddh Raman Pant code@siddh.me>
> > Sent: Thursday, August 25, 2022 6:01 AM
> > To: palmer@rivosinc.com
> > Cc: davem@davemloft.net; edumazet@google.com; johan.hedberg@gmail.com;
> > kuba@kernel.org; linux-bluetooth@vger.kernel.org; linux-
> > kernel@vger.kernel.org; linux@rivosinc.com; luiz.dentz@gmail.com;
> > marcel@holtmann.org; netdev@vger.kernel.org; pabeni@redhat.com
> > Subject: Re: [PATCH] Bluetooth: L2CAP: Elide a string overflow warning
> > 
> > On Fri, 12 Aug 2022 11:22:49 +0530  Palmer Dabbelt  wrote:
> > > From: Palmer Dabbelt palmer@rivosinc.com>
> > >
> > > Without this I get a string op warning related to copying from a
> > > possibly NULL pointer.  I think the warning is spurious, but it's
> > > tripping up allmodconfig.
> > 
> > I think it is not spurious, and is due to the following commit:
> > d0be8347c623 ("Bluetooth: L2CAP: Fix use-after-free caused by l2cap_chan_put")
> 
> That commit was OK - it added an "if (!c) continue" to handle if
> the value c is changed to NULL.
>  
> > The following commit fixes a similar problem (added the NULL check on line
> > 1996):
> > 332f1795ca20 ("Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm regression")
> 
> That commit wiped out the "if (!c) continue" path escape clause
> from the previous patch, introducing a path back to code that
> doesn't check for NULL:

You are correct, thanks for clarifying. Sorry for getting it reversed.

So I think this patch can be modified to just introduce back the escape
clause rather than having an extra indentation.

Thanks,
Siddh
