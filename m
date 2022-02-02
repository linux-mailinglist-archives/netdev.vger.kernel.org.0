Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5E54A6FD8
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 12:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343769AbiBBLVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 06:21:23 -0500
Received: from relay035.a.hostedemail.com ([64.99.140.35]:43314 "EHLO
        relay4.hostedemail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbiBBLVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 06:21:21 -0500
Received: from omf02.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay07.hostedemail.com (Postfix) with ESMTP id E0A92212E0;
        Wed,  2 Feb 2022 11:21:19 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf02.hostedemail.com (Postfix) with ESMTPA id 0368B80017;
        Wed,  2 Feb 2022 11:20:56 +0000 (UTC)
Message-ID: <a0ee4c6252ba69ec1425421ed3f297b12dfdcc3f.camel@perches.com>
Subject: Re: [PATCH] rtlwifi: remove redundant initialization of variable
 ul_encalgo
From:   Joe Perches <joe@perches.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Kees Cook <keescook@chromium.org>
Cc:     Pkshih <pkshih@realtek.com>, "kvalo@kernel.org" <kvalo@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "colin.i.king@gmail.com" <colin.i.king@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Wed, 02 Feb 2022 03:21:17 -0800
In-Reply-To: <20220202110554.GT1978@kadam>
References: <20220130223714.6999-1-colin.i.king@gmail.com>
         <55f8c7f2c75b18cd628d02a25ed96fae676eace2.camel@realtek.com>
         <20220202050229.GS1951@kadam>
         <90e40bb19320dcc2f2099b97b4b9d7d23325eaac.camel@perches.com>
         <20220202110554.GT1978@kadam>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.35
X-Stat-Signature: yntegr61bhth4o37xokye356pnstz3jh
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 0368B80017
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/nffVRXJall65azq8iu1FI4aKTxEamYtk=
X-HE-Tag: 1643800856-284986
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-02-02 at 14:05 +0300, Dan Carpenter wrote:
> On Wed, Feb 02, 2022 at 02:10:40AM -0800, Joe Perches wrote:
> > On Wed, 2022-02-02 at 08:02 +0300, Dan Carpenter wrote:
> > > On Mon, Jan 31, 2022 at 02:53:40AM +0000, Pkshih wrote:
> > > > On Sun, 2022-01-30 at 22:37 +0000, Colin Ian King wrote:
> > > > 
> > > > When I check this patch, I find there is no 'break' for default case.
> > > > Do we need one? like
> > > > 
> > > > @@ -226,6 +226,7 @@ void rtl_cam_empty_entry(struct ieee80211_hw *hw, u8 uc_index)
> > > >                 break;
> > > >         default:
> > > >                 ul_encalgo = rtlpriv->cfg->maps[SEC_CAM_AES];
> > > > +               break;
> > > 
> > > No, it's not necessary.  The choice of style is up to the original
> > > developer.
> > 
> > every case should have one.
> > 
> > Documentation/process/deprecated.rst:
> > 
> > All switch/case blocks must end in one of:
> > 
> > * break;
> > * fallthrough;
> > * continue;
> > * goto <label>;
> > * return [expression];
> > 
> 
> I doubt that's what Kees had in mind when he wrote that.

uhh, I wrote that.  I think Kees reformatted it for .rst

> The extra break statement doesn't improve readability.  It also doesn't
> hurt readability.
> 
> There is no reason to add a break statement after a default case.  No
> one is going to add another case after the default case.

Several hundred switch statements in the kernel use default:
as the first block.

> And if they
> do then a dozen static analysis tools will complain about the missing
> break.

true, doesn't mean that's a good thing.


