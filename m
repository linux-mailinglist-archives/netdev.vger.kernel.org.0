Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A89B1BEF8F
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 07:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgD3FHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 01:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726040AbgD3FHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 01:07:07 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D99C035494
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 22:07:06 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id e26so339615wmk.5
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 22:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3lppuwYoHQdYNn4lewcN8zW/Uyz6kIUto9s2hN6Q8Do=;
        b=UoRghsulQqDrn/1wEUcicvnsbZspC6Idl5+Kn6vPsWymMLPQ4EO1mKlxeDBnKgwK4T
         J0ywSlPvAoJnFMMiMalsB6FWFobK/RncyYsf3OaiqcvaddUKqtHgysTNpHljVwFMW5ST
         xn//IAMGv8jL0huNLh0hlYTTD+02XlL3MeShlZyx8fLdKzUD8UibyhRrqTBghiPNEcPr
         hcJuAufcvdS0QL5YWtIS6zRSxnydv0C9z64djvJZP01GMll2lnCQYJRFl2WvVd/n47U2
         SCT9EOkgL3+Lwtm6Q+Jn8uf1ZUYCCKcQelRienIPT9oGwSvsV5Kqdw5sDbpIL16Pw0Cy
         Hujg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3lppuwYoHQdYNn4lewcN8zW/Uyz6kIUto9s2hN6Q8Do=;
        b=cxni4R0QqoJnXcre5UhG676fFLLc2muVWB6oOe7SknTb2KnRuH7IT3vDJWOJ+34VLq
         qMBekAzGsOh1rcscvC8cyXe0Qerb5xsQuoc29AEa05PCX7ykxcXGs1JqqqonG+Uxne/P
         5JYqjmLALurO0ZNsAZ2C4fbRXbXjVDWK+pFAGmXaan0KcikY8CIb71q8Wiuw6mwFPY8n
         Fl2dIINOx9SNH+2BTLIL6U3QSfsmk6SN1hFwJKTsvh3lJJPxiCe338YXGmmsiI2wTD/G
         XmbdI/Ke6vwX/72huM/z5SnBv93Gb51aLLczxDV9mM6PIiWo7L47yJbHJ0S0jqVKuQlI
         4a2w==
X-Gm-Message-State: AGi0PuY3fejp1VSwMYFL9gxq6CJfWXvMiL9lsB/jggCG7CV8dqB2L4PU
        AS5JjdmnEic1g7x8N/Gw8TZ9Myn0PjbXEwsU9wk=
X-Google-Smtp-Source: APiQypJv8LnJx2O2eRU+pyB/uhAGFaYZXtySWZTltUWCvSVPlX1U4MeWJEhuNhyY8w5hKHghYMStKDa/lFFT5oYc0fA=
X-Received: by 2002:a05:600c:29c2:: with SMTP id s2mr793798wmd.111.1588223225351;
 Wed, 29 Apr 2020 22:07:05 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1587983178.git.lucien.xin@gmail.com> <a06922f5bd35b674caee4bd5919186ea1323202a.1587983178.git.lucien.xin@gmail.com>
 <838c55576eabd17db407a95bc6609c05bf5e174b.1587983178.git.lucien.xin@gmail.com>
 <1cd96ed3-b2ec-6cc7-8737-0cc2ecd38f72@gmail.com>
In-Reply-To: <1cd96ed3-b2ec-6cc7-8737-0cc2ecd38f72@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 30 Apr 2020 13:12:31 +0800
Message-ID: <CADvbK_cSTXakVS9qkiESu6swXPsEZyDvfPggQp1cWXYHg6hC5Q@mail.gmail.com>
Subject: Re: [PATCHv4 iproute2-next 2/7] iproute_lwtunnel: add options support
 for vxlan metadata
To:     David Ahern <dsahern@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 12:58 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 4/27/20 4:27 AM, Xin Long wrote:
> > diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
> > index 8599853..9945c86 100644
> > --- a/ip/iproute_lwtunnel.c
> > +++ b/ip/iproute_lwtunnel.c
> > @@ -333,6 +333,26 @@ static void lwtunnel_print_geneve_opts(struct rtattr *attr)
> >       close_json_array(PRINT_JSON, name);
> >  }
> >
> > +static void lwtunnel_print_vxlan_opts(struct rtattr *attr)
> > +{
> > +     struct rtattr *tb[LWTUNNEL_IP_OPT_VXLAN_MAX + 1];
> > +     struct rtattr *i = RTA_DATA(attr);
> > +     int rem = RTA_PAYLOAD(attr);
> > +     char *name = "vxlan_opts";
> > +     __u32 gbp;
> > +
> > +     parse_rtattr(tb, LWTUNNEL_IP_OPT_VXLAN_MAX, i, rem);
> > +     gbp = rta_getattr_u32(tb[LWTUNNEL_IP_OPT_VXLAN_GBP]);
> > +
> > +     print_nl();
> > +     print_string(PRINT_FP, name, "\t%s ", name);
> > +     open_json_array(PRINT_JSON, name);
> > +     open_json_object(NULL);
> > +     print_uint(PRINT_ANY, "gdp", "%u ", gbp);
>
> gdp? should that be 'gbp'?
Right, should be 'gbp'. Sorry.
The same mistake also exists in:

  [PATCHv4 iproute2-next 4/7] tc: m_tunnel_key: add options support for vxlan

Any other comments? Otherwise, I will post v5 with the fix.

Thanks.
