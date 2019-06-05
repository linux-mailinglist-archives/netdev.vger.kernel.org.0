Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14631355C1
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 06:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfFEEIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 00:08:14 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43327 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbfFEEIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 00:08:14 -0400
Received: by mail-pf1-f196.google.com with SMTP id i189so2039213pfg.10
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 21:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=mBw1AI7ewES7L6axd+01Wq47/E/t4H+nSCRXvrFTARs=;
        b=hSnXGNlhV8/7lyDPyPn9PmFh+zFlfv4un9Zy7ybQIeH7A2DjDceOjMiIcKcfpIYr7V
         96y0OmuYqjtkLbpkDze6HIAVSEWo38sg8lwkK2tYkiiOeFZsQw/pZj19562z7Q8o9csY
         PmFyUEROa1ls9AOk11D8t9EGnU6oPnLKkQA9XZWFOf7zkPccGRlpLdrdmFj6hAlrvZ0f
         Rp1izQUcJW+TMVgGwZYe1CETfT7JSE8JKlIsuW191qy9Gm9QVkEwVYyhXPPC3WI8I8qo
         rLPUCCEzxHS33QU+F5xV41IbPj29vL00UIPaG4S5pESN+hLXR2m8chtMLT7QqKtFTz9y
         r6cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=mBw1AI7ewES7L6axd+01Wq47/E/t4H+nSCRXvrFTARs=;
        b=aGKl4rYaFQFZRadcyAQVarXBTiTZmdfVk9vCvqDFXEVvRolWX8nynQrm0pC679FCNX
         U1e52KLHQWzwbzwt/EV3gkwTNNetXKkIFV+ZztfghFojt7CmZ4apyuzIeJIaYB0SFNnF
         SGiOJT3GLxlU60yFpcGI1RCFM4dUxGKk9BlOssBsn4PYqL7e5ZrdjdgFCo+ItMrNTxV6
         M1185NtRwelHcsFhsuRk2Ium0BQ1sPX1ZKiICDRdvlWpnHO2qg+s7LX+AR1ZNQ2I+vdI
         qiKn38VOSYawjaE/P9jKmdgywjgVgJ/Leuh7YPkff9kG8EVdtJVn1/NAmWldM8/kaRDY
         voEg==
X-Gm-Message-State: APjAAAWKpT+ikwDfZELnuiGYT3JZWqqZkzsbXRAwKvxhru2T/ZD1ilHq
        wxI47aojXiMMKbmOYNs1EGE=
X-Google-Smtp-Source: APXvYqxxM8y0IXaSZIfRQGzv+kmeVF1AHEEsSpF0XpeylIRf+FyvgTmGwmR7HvZ+bXkqB7t3MqkNTg==
X-Received: by 2002:a17:90b:14e:: with SMTP id em14mr41340546pjb.19.1559707693438;
        Tue, 04 Jun 2019 21:08:13 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i16sm18860292pfd.100.2019.06.04.21.08.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 21:08:12 -0700 (PDT)
Date:   Wed, 5 Jun 2019 12:08:02 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Ahern <dsa@cumulusnetworks.com>
Cc:     David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>,
        Yaro Slav <yaro330@gmail.com>,
        Thomas Haller <thaller@redhat.com>,
        Lorenzo Colitti <lorenzo@google.com>, astrachan@google.com,
        Greg KH <greg@kroah.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        mateusz.bajorski@nokia.com,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH net] fib_rules: return 0 directly if an exactly same rule
 exists when NLM_F_EXCL not supplied
Message-ID: <20190605040801.GC18865@dhcp-12-139.nay.redhat.com>
References: <20190507091118.24324-1-liuhangbin@gmail.com>
 <20190508.093541.1274244477886053907.davem@davemloft.net>
 <CAHo-OozeC3o9avh5kgKpXq1koRH0fVtNRaM9mb=vduYRNX0T7g@mail.gmail.com>
 <20190605014344.GY18865@dhcp-12-139.nay.redhat.com>
 <eef3b598-2590-5c62-e79d-76eb46fae5ff@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eef3b598-2590-5c62-e79d-76eb46fae5ff@cumulusnetworks.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 09:57:56PM -0600, David Ahern wrote:
> On 6/4/19 7:43 PM, Hangbin Liu wrote:
> > Hi David Ahern,
> > 
> > On Fri, May 31, 2019 at 06:43:42PM -0700, Maciej Żenczykowski wrote:
> >> FYI, this userspace visible change in behaviour breaks Android.
> >>
> >> We rely on being able to add a rule and either have a dup be created
> >> (in which case we'll remove it later) or have it fail with EEXIST (in
> >> which case we won't remove it later).
> >>
> >> Returning 0 makes atomically changing a rule difficult.
> >>
> >> Please revert.
> > What do you think? Should I rever this commit?
> 
> I think it is crazy to add multiple identical rules given the linear
> effect on performance. But, since it breaks Android, it has to be reverted.

OK.. Since you also agree to revert it.

Thanks
Hangbin
