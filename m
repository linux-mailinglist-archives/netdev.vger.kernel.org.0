Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69C8018AA01
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 01:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgCSArj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 20:47:39 -0400
Received: from mail-qv1-f66.google.com ([209.85.219.66]:36610 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbgCSArj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 20:47:39 -0400
Received: by mail-qv1-f66.google.com with SMTP id z13so146901qvw.3
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 17:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A720JABHxNJ9agKM47V+Qyc1pFwMkcg2jlZ4hFlzOr0=;
        b=QSraFvt5isb6q82CVvF0YlJ5wMcrox8yv5yjEJEcQSXKa3SWYtne12tF7oIGsa9In0
         1+fDmAoWF60Rr9BW9ZTXgglY+8UU8TSUresHRbN8a/Zh8prwn6Tk4uj2hi7D8F4DOZEM
         Xhl4cADhXvp+p8S009WSfF6Mru4mEyb70WHds=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A720JABHxNJ9agKM47V+Qyc1pFwMkcg2jlZ4hFlzOr0=;
        b=LEad6SpYtCJgky8iMgIH6g0uXRkWRCduJPvrPVidOEZtxM7VdRLhoVxK+deXbhDX+R
         tG3QNIbaQLldwyn+E+VeN8NEdXGp3+H8b/dJ0dAKqu2MQnHpwKS0RqAOuLxDU3fB9VfZ
         rRawsIOLAgGUB6UOnhR/hbvpmM7Dy5uqtHEwKVtFZ+SmR5q4FwbRuMjBgYaCVcYUXVxK
         Wz04OlvkNlHwkHvRkxMu6jPMx04EB3xRaDJwNuG1sjmf0D4QwPr+KtV3fqwtKE3bnCp3
         ck2TVUsKJcD3OB2zDUt7u48ie4n3CgDCVD+yqEehY6ORpazrR7/jWkWmcKjE6jMPS5iK
         NVDw==
X-Gm-Message-State: ANhLgQ01pql4YZUobdtqVqf9jaqQfWj6oNnHliDH5tRTnMQzAuxalE6i
        XWwUfNzeMMdDprJQmeLPbcy9LWtAYzS/zp/ldI7paw==
X-Google-Smtp-Source: ADFU+vvlmszk//vEOKvcanmLt18UkRrYcZTTNdlZrOtBFvwem4KTrueVhhWQJZVhEWQ4R9um+82XSqBP0PZJ7IcJfv8=
X-Received: by 2002:a0c:ee28:: with SMTP id l8mr657058qvs.196.1584578858194;
 Wed, 18 Mar 2020 17:47:38 -0700 (PDT)
MIME-Version: 1.0
References: <1584458082-29207-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1584458082-29207-2-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200317104046.1702b601@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAACQVJqSMsMNChPssuw850HVYXYJAYx=HcwYXGrG3FsMgVQf1g@mail.gmail.com>
 <20200318130441.42ac70b5@kicinski-fedora-PC1C0HJN> <cc554929-9dbb-998e-aa83-0e5ccb6c3867@intel.com>
In-Reply-To: <cc554929-9dbb-998e-aa83-0e5ccb6c3867@intel.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Wed, 18 Mar 2020 17:47:26 -0700
Message-ID: <CACKFLikpaDrykkzsUNgRdUejQSM4S3M==+TVnRxMCA54DRFFOQ@mail.gmail.com>
Subject: Re: [PATCH net-next 01/11] devlink: add macro for "drv.spec"
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 5:05 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
> On 3/18/2020 1:04 PM, Jakub Kicinski wrote:
> > We're just getting rid of driver versions, with significant effort,
> > so starting to extend devlink info with driver stuff seems risky.
> > How is driver information part of device info in the first place?
> >
> > As you said good driver and firmware will be modular and backward
> > compatible, so what's the meaning of the API version?
> >
> > This field is meaningless.
> >
>
> I think I agree with Jakub here. I assume, if it's anything like what
> the ice driver does, the firmware has an API field used to communicate
> to the driver what it can support. This can be used by the driver to
> decide if it can load.
>
> For example, if the major API number increases, the ice driver then
> assumes that it must be a very old driver which will not work at all
> with that firmware. (This is mostly kept as a safety hatch in case no
> other alternative can be determined).
>
> The driver can then use this API number as a way to decide if certain
> features can be enabled or not.
>
> I suppose printing the driver's "expected" API number makes sense, but I
> think the stronger approach is to make the driver able to interoperate
> with any previous API version. Newer minor API numbers only mean that
> new features exist which the driver might not be aware of. (for example,
> if you're running an old driver).
>

Agreed.  Our driver is backward and forward compatible with all
production firmware for the most part.  The idea is that the effective
API version number is the minimum of the driver's API and firmware's
API.  For example, if firmware is at v1.5 and driver is at v1.4, then
the effective or operating API is v1.4.  The new features after v1.4
are unused because the driver does not understand those new features.
Similarly, a newer driver running on older firmware will have the
older firmware's API as the effective API.  The driver will not use
the new features that the firmware doesn't understand.

So if there is only one API version to report, reporting the min.
makes the most sense to the user in our case.  It is similar to a Gen4
PCIe card currently operating in a Gen3 slot.

Thanks.
