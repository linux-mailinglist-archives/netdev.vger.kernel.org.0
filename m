Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970D422310C
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 04:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgGQCMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 22:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgGQCMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 22:12:38 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86909C061755;
        Thu, 16 Jul 2020 19:12:38 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id w34so6596688qte.1;
        Thu, 16 Jul 2020 19:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2to7PZ35DmNzJzcrbrv1v/mw1Q6DUkd154VCyr9iHYM=;
        b=Z4QPo/np7cP3M1LqYu5EjVw0oGllxD1s2t1KkJVuTCJmjURgb5cyz7yy1NvEhOURrJ
         9naR0/w2uRgXGnOo8iLGmMc/Sn3ZT1x8giUYE46Q1ibL0fGebeX5c6KQWHGkm7XhTI1A
         AW0z9ZDFWii9yToprB4nv8HkRM/e9kDdoYI6A3AZwW+tyJ6kcXJsO76DqSBJR/7BeuC+
         pjtJjqo1OEohXcmCogMcs8aICiLz37X0KVtUfhCt7FUmYxMc1SpNgSqL0y3KpMLFHK1a
         m5+pLo8gXsKOjPPXxy2euZt5pIVLPtDICiWUCJFta9OYf/ZZqyoszNZlnG52lKUpOFRk
         DbEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2to7PZ35DmNzJzcrbrv1v/mw1Q6DUkd154VCyr9iHYM=;
        b=nkNsyzg4VL4IzBBXcaWNpAE3T+BqjyVTfLQXfe7615bbwFqzJebGOV0oosmSN1ggsn
         VQQNgu3/c9pUB4DIFZ4RPUjeOs4Vsl6cxqK3dF6fMUb0bbgyKDNSfyyNfVYzyXzVOhYO
         TDzBfJztEtKIMqZ2sV2vdt6S3nxO71icwsML0IJJUanoeuN0lIqUdayPgYRkQgLStza+
         Z/4Ge7Qil/qLrufjXStgavlyruwnL51r+KSlsF+blZfQh+nLucucimNXjcerEroYrYL6
         8MTuMnt8NmhOT02QMh1qp8QlPxn6P53m/9BwFTUG0xwSQFb5K6LelaN6D9Jgk+zM33JF
         IEfw==
X-Gm-Message-State: AOAM532xTSz9t+Y43BqfeXFnJ+5PBVD9WYa0tFEILl/JyG+JjfREG1EP
        ldkiS12wLGaeZhoO13lSAOg=
X-Google-Smtp-Source: ABdhPJyL/IPCMF02mbDdmX6L6UIUmDWsfuLL612T41/Tr+CQ6HA3NtNqjsYig6nYlfN8cEZhnO1rvA==
X-Received: by 2002:aed:2f46:: with SMTP id l64mr8237129qtd.1.1594951957365;
        Thu, 16 Jul 2020 19:12:37 -0700 (PDT)
Received: from ubuntu-n2-xlarge-x86 ([2604:1380:45d1:2600::1])
        by smtp.gmail.com with ESMTPSA id u20sm10432214qtj.39.2020.07.16.19.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 19:12:36 -0700 (PDT)
Date:   Thu, 16 Jul 2020 19:12:35 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     "Neftin, Sasha" <sasha.neftin@intel.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH] igc: Do not use link uninitialized in
 igc_check_for_copper_link
Message-ID: <20200717021235.GA4098394@ubuntu-n2-xlarge-x86>
References: <20200716044934.152364-1-natechancellor@gmail.com>
 <cdfec63a-e51f-e1a6-aa60-6ca949338306@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdfec63a-e51f-e1a6-aa60-6ca949338306@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 07:29:03PM +0300, Neftin, Sasha wrote:
> On 7/16/2020 07:49, Nathan Chancellor wrote:
> > Clang warns:
> > 
> Hello Nathan,
> Thanks for tracking our code.Please, look at https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20200709073416.14126-1-sasha.neftin@intel.com/
> - I hope this patch already address this Clang warns - please, let me know.

I have not explicitly tested it but it seems obvious that it will. Let's
go with that.

Cheers,
Nathan

> > drivers/net/ethernet/intel/igc/igc_mac.c:374:6: warning: variable 'link'
> > is used uninitialized whenever 'if' condition is true
> > [-Wsometimes-uninitialized]
> >          if (!mac->get_link_status) {
> >              ^~~~~~~~~~~~~~~~~~~~~
> > drivers/net/ethernet/intel/igc/igc_mac.c:424:33: note: uninitialized use
> > occurs here
> >          ret_val = igc_set_ltr_i225(hw, link);
> >                                         ^~~~
> > drivers/net/ethernet/intel/igc/igc_mac.c:374:2: note: remove the 'if' if
> > its condition is always false
> >          if (!mac->get_link_status) {
> >          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > drivers/net/ethernet/intel/igc/igc_mac.c:367:11: note: initialize the
> > variable 'link' to silence this warning
> >          bool link;
> >                   ^
> >                    = 0
> > 1 warning generated.
> > 
> > It is not wrong, link is only uninitialized after this through
> > igc_phy_has_link. Presumably, if we skip the majority of this function
> > when get_link_status is false, we should skip calling igc_set_ltr_i225
> > as well. Just directly return 0 in this case, rather than bothering with
> > adding another label or initializing link in the if statement.
> > 
> > Fixes: 707abf069548 ("igc: Add initial LTR support")
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1095
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > ---
> >   drivers/net/ethernet/intel/igc/igc_mac.c | 6 ++----
> >   1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
> > index b47e7b0a6398..26e3c56a4a8b 100644
> > --- a/drivers/net/ethernet/intel/igc/igc_mac.c
> > +++ b/drivers/net/ethernet/intel/igc/igc_mac.c
> > @@ -371,10 +371,8 @@ s32 igc_check_for_copper_link(struct igc_hw *hw)
> >   	 * get_link_status flag is set upon receiving a Link Status
> >   	 * Change or Rx Sequence Error interrupt.
> >   	 */
> > -	if (!mac->get_link_status) {
> > -		ret_val = 0;
> > -		goto out;
> > -	}
> > +	if (!mac->get_link_status)
> > +		return 0;
> >   	/* First we want to see if the MII Status Register reports
> >   	 * link.  If so, then we want to get the current speed/duplex
> > 
> > base-commit: ca0e494af5edb59002665bf12871e94b4163a257
> > 
> Thanks,
> Sasha
