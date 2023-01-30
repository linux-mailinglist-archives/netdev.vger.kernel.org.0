Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E00A6805A4
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 06:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235253AbjA3FeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 00:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjA3FeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 00:34:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DE81C338;
        Sun, 29 Jan 2023 21:34:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0590DB80E4C;
        Mon, 30 Jan 2023 05:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41474C433EF;
        Mon, 30 Jan 2023 05:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675056849;
        bh=2bS7jtEMGeBcHlS10sF+uvT/z2dEGxiHT9t0dsygdvE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qSSZkJEu1iUlSrOpSN1fSVKAJOME8kGHsnJpnbLTXoFdl+SN42SI6H0XAXFxsv4mi
         bQ0trrmLnKsykYvJwaSSnBecBqK6933JY6h9hOEwniy5YbahkAYL8AxJHD/CDRpdce
         a6UNWWvkpKy5w1LxyydHzPCrN3a3nIqoWuHyhADs=
Date:   Mon, 30 Jan 2023 06:34:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jaewan Kim <jaewan@google.com>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com, adelva@google.com
Subject: Re: [PATCH v6 1/2] mac80211_hwsim: add PMSR capability support
Message-ID: <Y9dWztPR3FxkLv26@kroah.com>
References: <20230124145430.365495-1-jaewan@google.com>
 <20230124145430.365495-2-jaewan@google.com>
 <Y8//ZflAidKNJAVQ@kroah.com>
 <CABZjns5FRY+_WD_G=sjiBxjSwaydgL-wgTAR-PSeh-42OTieRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABZjns5FRY+_WD_G=sjiBxjSwaydgL-wgTAR-PSeh-42OTieRg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 12:48:37AM +0900, Jaewan Kim wrote:
> On Wed, Jan 25, 2023 at 12:55 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > +static int parse_ftm_capa(const struct nlattr *ftm_capa,
> > > +                       struct cfg80211_pmsr_capabilities *out)
> > > +{
> > > +     struct nlattr *tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1];
> > > +     int ret = nla_parse_nested(tb, NL80211_PMSR_FTM_CAPA_ATTR_MAX,
> > > +                                ftm_capa, hwsim_ftm_capa_policy, NULL);
> > > +     if (ret) {
> > > +             pr_err("mac80211_hwsim: malformed FTM capability");
> >
> > dev_err()?
> 
> Is dev_err() the printing error for device code?

I am sorry, but I can not understand this question, can you rephrase it?

> If so, would it be better to propose another change for replacing all
> pr_err() with dev_err() in this file?

Odds are, yes, but that should be independent of your change to add a
new feature.

thanks,

greg k-h
