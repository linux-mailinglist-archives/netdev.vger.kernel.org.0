Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFCD216EF2D
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 20:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730968AbgBYTkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 14:40:20 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:45628 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729510AbgBYTkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 14:40:20 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j6g3y-00AX5g-Jj; Tue, 25 Feb 2020 20:40:14 +0100
Message-ID: <c80d2bbae9606ae09746ad0d382b0b555f9987e3.camel@sipsolutions.net>
Subject: Re: [RFC] wwan: add a new WWAN subsystem
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        elder@linaro.org, m.chetan.kumar@intel.com, dcbw@redhat.com,
        bjorn.andersson@linaro.org
Date:   Tue, 25 Feb 2020 20:40:12 +0100
In-Reply-To: <20200225.110033.2078372349210559509.davem@davemloft.net>
References: <20200225100053.16385-1-johannes@sipsolutions.net>
         <20200225105149.59963c95aa29.Id0e40565452d0d5bb9ce5cc00b8755ec96db8559@changeid>
         <20200225.110033.2078372349210559509.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-02-25 at 11:00 -0800, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Tue, 25 Feb 2020 11:00:53 +0100
> 
> > +static struct wwan_device *wwan_create(struct device *dev)
> > +{
> > +     struct wwan_device *wwan = kzalloc(sizeof(*wwan), GFP_KERNEL);
> > +     u32 id = ++wwan_id_counter;
> > +     int err;
> > +
> > +     lockdep_assert_held(&wwan_mtx);
> > +
> > +     if (WARN_ON(!id))
> > +             return ERR_PTR(-ENOSPC);
> 
> This potentially leaks 'wwan'.

Eagle eyes ... thanks! :)

I suppose this will be totally different if I can integrate with the
component device stuff somehow, will see.

johannes

