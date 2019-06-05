Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF2F035524
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 04:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbfFECPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 22:15:45 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41560 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFECPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 22:15:45 -0400
Received: by mail-pf1-f194.google.com with SMTP id q17so13884172pfq.8
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 19:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=k/uRXrNm9b2m5iQtOpDOFOP7OyhVOSzwWx2c+KdNsiU=;
        b=a7AZiORkC4I8oKw2NA49yTfX9pJliyZmLyQWKoAlrTzIDhK2OOCztBZSoy33k3XvhE
         VWs4EkTBhYcdIV4F6GcEDTO7JiHsKwaGF0ByOHGBEdt+6eQ2xH5+unStf9qdDnoRZTUT
         t12Og8lfLS1LDMDWo3t0/7TJ5aOeJtMTFOfQfP99f3eihvyw1hRZ6i8/uTR4UxZff/29
         PNwx4sCbIyjoHhINbTgUz8CKuB1aDdo/gqvArGzERcuLoIAZlhjW41Rh6KWoEvJKPxW3
         OFADdqr8EYdZHC5KrMN7ArxCxwMBer5SXYVaXjcgBzkLVkmQ4UO0HIe1wLcwxqGFQzrX
         u5Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=k/uRXrNm9b2m5iQtOpDOFOP7OyhVOSzwWx2c+KdNsiU=;
        b=OWwCv1UDUxUdVAtHZS9VB1fqXoqkGVHYuFDeibVSgdsNL++eIRIFVmwNJr/um61nFV
         ykhM6QWz0+/4O7s6Y1VJ/eQd8V5Hb2MnFbhLjC6q/A26A1paobR1kBMSf0NZOjStxzgG
         xY1HoU7mMiLZbTL58C8Yh+1ufrIZyI97VE51zE3qa5aNtpcYjlkp4ikKkavqu1ED+VWd
         /lW1d56BoEbHzBAxmrr/OLWBYN6uxOLlM1U0kZl5YDYF+e9VQLE/0SWHU5L5zHpkDC1F
         BfhYPvb3Odopkm3cqInntJqy1LIHdtBeZ6ys6NMlF/+jGexknGkvKIkv3pc1gWhzqMd8
         2qhw==
X-Gm-Message-State: APjAAAUut1983AkH3w/8UdnEXh6rDE+wCO28ZHCmpvp51WaIRTHe1aJB
        Gy4ROyVwvq+bXH0gsVn+TBk=
X-Google-Smtp-Source: APXvYqyhZEcQeQzy+rUrffEUFxCUgx94hnWrVaXWeLxKRNJsXYPD7tJkPI59/aV5SIGm1eOW8hOHtg==
X-Received: by 2002:a63:4006:: with SMTP id n6mr966048pga.424.1559700944964;
        Tue, 04 Jun 2019 19:15:44 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n21sm18826084pff.92.2019.06.04.19.15.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 19:15:44 -0700 (PDT)
Date:   Wed, 5 Jun 2019 10:15:33 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Lorenzo Colitti <lorenzo@google.com>
Cc:     David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>,
        Yaro Slav <yaro330@gmail.com>,
        Thomas Haller <thaller@redhat.com>,
        Alistair Strachan <astrachan@google.com>,
        Greg KH <greg@kroah.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH net] fib_rules: return 0 directly if an exactly same rule
 exists when NLM_F_EXCL not supplied
Message-ID: <20190605021533.GZ18865@dhcp-12-139.nay.redhat.com>
References: <20190507091118.24324-1-liuhangbin@gmail.com>
 <20190508.093541.1274244477886053907.davem@davemloft.net>
 <CAHo-OozeC3o9avh5kgKpXq1koRH0fVtNRaM9mb=vduYRNX0T7g@mail.gmail.com>
 <20190605014344.GY18865@dhcp-12-139.nay.redhat.com>
 <CAKD1Yr3px5vCAmmW7vgh4v6AX_gSRiGFcS0m+iKW9YEYZ2wG8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKD1Yr3px5vCAmmW7vgh4v6AX_gSRiGFcS0m+iKW9YEYZ2wG8w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 10:47:58AM +0900, Lorenzo Colitti wrote:
> On Wed, Jun 5, 2019 at 10:43 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
> > Although I'm still not clear what's the difference between
> >
> > a) adding a dup rule and remove it later
> > and
> > b) return 0 directly if the rule exactally the same.
> 
> The Android code updates ip rules by adding the new rule and then
> deleting the old rule. Before this patch, the result of the operation
> is that the old rule is deleted and the new rule exists. After this
> patch, if the new rule is the same as the old rule, then the add does
> nothing and the delete deletes the old rule. The result of the
> operation is that the old rule is deleted and the new rule is no
> longer there, and the rules are broken.

Hi Lorenzo,

How do you add the rules? with ip cmd it should has NLM_F_EXCL flag and
you will get -EEXIST error out.

Thanks
Hangbin
